##Code to extract cumulative cost data for management and damage costs from InvaCost 3.0
## Written by Emma J Hudgins, 2020, after participation in the InvaCost workshop
## contact emma.hudgins@mail.mcgill.ca for any questions

rm(list=c(ls()))
require(invacost)
require(countrycode)
require(dplyr)
require(mgsub)
require(here)
require(rworldmap)

setwd(here())


### Load data ###
library(invacost) # Invacost 3.0
data(invacost)

### extract only Observed, High reliability costs at country and site level of spatial resolution ###

invacost <- invacost[invacost$Implementation == "Observed", ]
invacost <- invacost[which(invacost $Method_reliability == "High"), ]
invacost  <- invacost[which(invacost$Spatial_scale %in% c("Country", "Site")), ]
invacost <- invacost[which(is.na(invacost$Probable_starting_year_adjusted)==F),]
invacost <- invacost[which(is.na(invacost$Probable_ending_year_adjusted)==F),]
invacost<-expandYearlyCosts(invacost, startcolumn = "Probable_starting_year_adjusted", endcolumn="Probable_ending_year_adjusted")


invacost_cln<-invacost[,c(1,2,13:19,c(29,37,38,54,55,56,46)+1)] # remove unneccessary columns

#Clean up country codes in Invacost for merging
invacost_cln$Official_country<-mgsub(invacost_cln$Official_country,c("England", "Northern Ireland", "Scotland", "Salvador"), c(rep("United Kingdom", 3),"El Salvador"))

invacost_cln$code<-countrycode((invacost_cln$Official_country), 'country.name', 'iso3c')

### merge databases##
colnames(invacost_cln)[c(16)]<-c("Cost.USD")


invacost_cln$Cost.USD[which(is.na(invacost_cln$Cost.USD)&invacost_cln$Official_country=="United States of America")]<-invacost$Cost_estimate_per_year_local_currency[which(is.na(invacost_cln$Cost.USD)&invacost_cln$Official_country=="United States of America")]
# Only examine damage costs and post-invasion management
sub_postinv<-subset(invacost_cln, Management_type%in%c(NA, "Post-invasion management"))
sub_postinv<-subset(sub_postinv, Type_of_cost_merged%in%c("Mixed", NA)==F)
#sub_postinv<-subset(sub_postinv, Genus=="Aedes")
#length(unique(sub_postinv$Cost_ID))
#check first year of damage vs first record in sTwist for each genus in each country
cost_dm<-subset(sub_postinv, Type_of_cost_merged=="Damage")
sub_dm<-cost_dm
#sub_dm<-subset(cost_dm, Genus%in%c("Aedes", "Ambrosia", "Procyon","Callosciurus"))
sub_dm<-sub_dm%>%group_by(Genus, code)%>%summarise_at(c("Cost.USD", "Impact_year"),.funs=list(sum=sum,min=min))

#check first year of management vs first record in sTwist for each genus in each country
cost_mg<-subset(sub_postinv, Type_of_cost_merged=="Management")

sub_mg<-cost_mg%>%group_by(Genus, code)%>%summarise_at(c("Cost.USD", "Impact_year"),.funs=list(sum=sum,min=min))

# sum to species:country:year level,keep cost types separate
cost_agg<-sub_postinv%>%group_by(Species,Impact_year, Type_of_cost_merged, Management_type, code,Genus, Cost_ID)%>%summarise_if(is.numeric, sum)

# look at number of independent cost references for each genus
cost_agg_sum<-cost_agg%>%group_by(Type_of_cost_merged,Genus)%>%summarise_at('Cost_ID',n_distinct)
cost_agg<-cost_agg[,c(1:7,10)] # remove unncessary columns

#first invacost record for species in each country
minyear2<-cost_agg%>%group_by(Genus)%>%summarise_at('Impact_year', min)
colnames(minyear2)[2]<-"First_invacost"
cost_agg<-merge(cost_agg,minyear2, all.x=T)
## Calculate % of Aedes costs with unknown species level

cost_dm<-subset(cost_agg, Type_of_cost_merged=="Damage")
sub_dm<-cost_dm
sub_dm<-subset(cost_dm, Genus%in%c("Aedes"))
sum(subset(sub_dm, Species%in%c("Aedes aegypti", "Aedes albopictus")==F)$Cost.USD)/sum(sub_dm$Cost.USD)
cost_agg_mgmt<-subset(cost_agg, cost_agg$Type_of_cost_merged=="Management")
cost_agg_mgmt<-subset(cost_agg_mgmt, cost_agg_mgmt$Management_type=="Post-invasion management")
sub_mg<-subset(cost_agg_mgmt, Genus%in%c("Aedes"))
sum(subset(sub_mg, Species%in%c("Aedes aegypti", "Aedes albopictus", "Aedes camptorhynchus")==F)$Cost.USD)/sum(sub_mg$Cost.USD)

#calculate management delay for each species as first invacost management record
sub_dm$First_manage<-NA
for (i in 1:nrow(sub_dm))
     {
       sub_dm$First_manage[i]<-min(invacost_cln$Impact_year[which(invacost$Genus==sub_dm$Genus[i]& invacost_cln$code==sub_dm$code[i] & invacost_cln$Type_of_cost_merged=="Management")], na.rm=T)}
sub_dm$First_manage[which(is.infinite(sub_dm$First_manage))]<-NA

#for genera missing country-level lags, take global management delay
sub_dm$First_manage_invacost<-NA
for (i in 1:nrow(sub_dm))
{
  sub_dm$First_manage_invacost[i]<-min(invacost$Impact_year[which(invacost$Genus==sub_dm$Genus[i]& invacost$Type_of_cost_merged=="Management")], na.rm=T)}

### fill in missing management lags and get yearly time since first record
sub_clean<-cbind(sub_dm$Genus, sub_dm$code, (sub_dm$Impact_year-sub_dm$First_invacost), sub_dm$Cost.USD, (sub_dm$First_manage-sub_dm$First_invacost))
colnames(sub_clean)<-c("Genus", "code", "Time.since.introduction", "Cost.USD", "Management.delay")
#calculate time since sTwist first record
sub_clean[which(is.na(sub_clean[,3])),3]<-(sub_dm$Impact_year-sub_dm$First_invacost)[which(is.na(sub_clean[,3]))]
#calculate either country-level of global management delay
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_dm$First_manage_invacost-sub_dm$eventDate)[which(is.na(sub_clean[,5]))]
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_dm$First_manage_invacost-sub_dm$First_invacost)[which(is.na(sub_clean[,5]))]
write.csv(sub_clean, file="filled_aedes_logistic.csv", row.names=F)

#### Create cumulative cost dataframe based on yearly cost data ##
sub_clean<-sub_clean[order(sub_clean[,3]),]
sub_clean<-data.frame(sub_clean)
sub_clean$Cost.USD<-as.numeric(sub_clean$Cost.USD)
sub_clean$Time.since.introduction<-as.numeric(sub_clean$Time.since.introduction)
new<-sub_clean%>%group_by(Genus, Time.since.introduction)%>%summarise_if(is.numeric,sum, na.rm=T)
new2<-sub_clean%>%group_by(Genus)%>%distinct_at('Time.since.introduction')
new2<-new2[order(new2$Genus,new2$Time.since.introduction),]
new<-new%>%group_by(Genus, Time.since.introduction)%>%summarise_at('Cost.USD',sum, na.rm=T)
new$Time.since.introduction<-new2$Time.since.introduction
write.csv(new, file="annual_aedes_logistic.csv", row.names=F)



##### repeat same process but for management costs ###

colnames(sub_mg)
sub_mg$First_manage<-NA
for (i in 1:nrow(sub_mg))
{
  sub_mg$First_manage[i]<-min(invacost_cln$Impact_year[which(invacost$Genus==sub_mg$Genus[i]& invacost_cln$code==sub_mg$code[i] & invacost_cln$Type_of_cost_merged=="Management")], na.rm=T)}
sub_mg$First_manage[which(is.infinite(sub_mg$First_manage))]<-NA
sub_mg$First_manage_invacost<-NA
for (i in 1:nrow(sub_mg))
{
  sub_mg$First_manage_invacost[i]<-min(invacost$Impact_year[which(invacost$Genus==sub_mg$Genus[i]& invacost$Type_of_cost_merged=="Management")], na.rm=T)}
write.csv(sub_mg, file="Managementcosts_aedes_logsitic.csv", row.names=F)


sub_clean<-cbind(sub_mg$Genus, sub_mg$code,(sub_mg$Impact_year-sub_mg$First_invacost), sub_mg$Cost.USD, (sub_mg$First_manage-sub_mg$First_invacost))
colnames(sub_clean)<-c("Genus", "code", "Time.since.introduction", "Cost.USD", "Management.delay")
sub_clean[which(is.na(sub_clean[,3])),3]<-(sub_mg$Impact_year-sub_mg$First_invacost)[which(is.na(sub_clean[,3]))]
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_mg$First_manage_invacost-sub_mg$eventDate)[which(is.na(sub_clean[,5]))]
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_mg$First_manage_invacost-sub_mg$First_invacost)[which(is.na(sub_clean[,5]))]
write.csv(sub_clean, file="filled_mgmt_aedes_logistic.csv", row.names=F)
sub_clean<-sub_clean[order(sub_clean[,3]),]
sub_clean<-data.frame(sub_clean)
sub_clean$Cost.USD<-as.numeric(sub_clean$Cost.USD)
sub_clean$Time.since.introduction<-as.numeric(sub_clean$Time.since.introduction)
new<-sub_clean%>%group_by(Genus, Time.since.introduction)%>%summarise_if(is.numeric,sum, na.rm=T)
new2<-sub_clean%>%group_by(Genus)%>%distinct_at('Time.since.introduction')
new2<-new2[order(new2$Genus,new2$Time.since.introduction),]
new<-new%>%group_by(Genus, Time.since.introduction)%>%summarise_at('Cost.USD',sum)
new$Time.since.introduction<-new2$Time.since.introduction
write.csv(new, file="annual_mgmt_aedes_logistic.csv", row.names=F)




pdf(paste0("map_damage.pdf"))
layout(matrix(c(1,1,2), ncol=1, byrow=TRUE), heights=c(3,1))
my_palette <- colorRampPalette(c("yellow1", "violetred2", "mediumblue"))(50)[50:1]
bins<-seq(1920,2020,length.out=50)
par(oma=c(2,0,2,0))
par(mai=c(0.1,0,0.1,0))
par(font.main=3)
dm_first<-sub_dm%>%group_by(code)%>%summarise_at("Impact_year", min)
distMap <- joinCountryData2Map(dm_first, joinCode = "ISO3",
                                 nameJoinColumn = "code")
mapCountryData(distMap, nameColumnToPlot="Impact_year", catMethod = "pretty", col=my_palette,  mapTitle="", oceanCol = 'lightblue', borderCol = "black", missingCountryCol="white", addLegend = F)
par(mai=c(0.25,0.1,0,0.1))
image(1:50,1,matrix(1:50), col=my_palette, axes=FALSE, ann=F)
axis(1,labels=c(paste(seq(1920,2020, length.out=11))),at=c(seq(1,50,length.out=11)), cex.axis=1)
mtext(side=1, "Year", line=3)
dev.off()

pdf(paste0("map_management.pdf"))
layout(matrix(c(1,1,2), ncol=1, byrow=TRUE), heights=c(3,1))
my_palette <- colorRampPalette(c("yellow1", "violetred2", "mediumblue"))(50)[50:1]
bins<-seq(1920,2020,length.out=50)
par(oma=c(2,0,2,0))
par(mai=c(0.1,0,0.1,0))
par(font.main=3)
mg_first<-sub_mg%>%group_by(code)%>%summarise_at("Impact_year", min)
distMap <- joinCountryData2Map(mg_first, joinCode = "ISO3",
                               nameJoinColumn = "code")
mapCountryData(distMap, nameColumnToPlot="Impact_year", catMethod = "pretty", col=my_palette,  mapTitle="", oceanCol = 'lightblue', borderCol = "black", missingCountryCol="white", addLegend = F)
par(mai=c(0.25,0.1,0,0.1))
image(1:50,1,matrix(1:50), col=my_palette, axes=FALSE, ann=F)
axis(1,labels=c(paste(seq(1920,2020, length.out=11))),at=c(seq(1,50,length.out=11)), cex.axis=1)
mtext(side=1, "Year", line=3)
dev.off()
