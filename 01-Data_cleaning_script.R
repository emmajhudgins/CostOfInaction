##Code to extract cumulative cost data for management and damage costs from InvaCost 3.0
## Written by Emma J Hudgins, 2020, after participation in the InvaCost workshop
## contact emma.hudgins@mail.mcgill.ca for any questions

rm(list=c(ls()))
require(invacost)
require(countrycode)
require(dplyr)
require(mgsub)
require(here)

setwd(here())


### Load data ###
library(invacost) # Invacost 3.0
data(invacost)

### extract only Observed, High reliability costs at country and site level of spatial resolution ###

invacost <- invacost[invacost$Implementation == "Observed", ]
invacost <- invacost[which(invacost $Method_reliability == "High"), ]
invacost  <- invacost[which(invacost$Spatial_scale %in% c("Country", "Site")), ]
invacost <- invacost[which(is.na(invacost$Probable_starting_year_adjusted)==F),]
invacost<-expandYearlyCosts(invacost, startcolumn = "Probable_starting_year_adjusted", endcolumn="Probable_ending_year_adjusted")


invacost_cln<-invacost[,c(1,2,13:19,29,37,38,54,55,56,46)] # remove unneccessary columns

### Import sTwist ###
stwist<-read.table('sTwist_database.csv', header=T)
# Match column names to invacost for merging
colnames(stwist)[3]<-'Species'
colnames(stwist)[1]<-"Official_country"

#Clean up country codes in Invacost for merging
invacost_cln$Official_country<-mgsub(invacost_cln$Official_country,c("England", "Northern Ireland", "Scotland", "Salvador"), c(rep("United Kingdom", 3),"El Salvador"))

#Assign iso3c codes#
stwist$code<-countrycode(stwist$Official_country, 'country.name', 'iso3c') # many islands not considered countries and therefore not matched
invacost_cln$code<-countrycode(invacost_cln$Official_country, 'country.name', 'iso3c')

### merge databases##
allcountry_spp<-merge(invacost_cln, stwist, by=c("Species", "code"), all.x=T)
allcountry_spp<-unique(allcountry_spp)
allcountry_spp<-allcountry_spp[,c(1:17,22)]# remove unnecessary columns
colnames(allcountry_spp)[c(11,17)]<-c("Official_country","Cost.USD")

# Only examine damage costs and post-invasion management
sub_postinv<-subset(allcountry_spp, Management_type%in%c(NA, "Post-invasion_management"))
sub_postinv<-subset(sub_postinv, Type_of_cost_merged%in%c("Mixed_costs", NA)==F)

#check first year of damage vs first record in sTwist for each genus in each country
cost_dm<-subset(sub_postinv, Type_of_cost_merged=="Damage_costs")
sub_dm<-subset(cost_dm, Genus%in%c("Aedes", "Ambrosia", "Procyon","Callosciurus"))
sub_dm<-sub_dm%>%group_by(Genus, Official_country)%>%summarise_at(c("Cost.USD", "Impact_year"),.funs=list(sum=sum,min=min))

#check first year of management vs first record in sTwist for each genus in each country
cost_mg<-subset(sub_postinv, Type_of_cost_merged=="Management_costs")
sub_mg<-subset(cost_mg, Genus%in%c("Aedes", "Anoplophora", "Cenchrus","Salvinia"))
genera_mg<-c("Aedes", "Anoplophora", "Cenchrus","Salvinia")
sub_mg<-sub_mg%>%group_by(Genus, Official_country)%>%summarise_at(c("Cost.USD", "Impact_year"),.funs=list(sum=sum,min=min))

# sum to species:country:year level,keep cost types separate
cost_agg<-sub_postinv%>%group_by(Species,Impact_year, Type_of_cost_merged, Management_type, code,Genus, Cost_ID)%>%summarise_if(is.numeric, sum)

# look at number of independent cost references for each genus
cost_agg_sum<-cost_agg%>%group_by(Type_of_cost_merged,Genus)%>%summarise_at('Cost_ID',n_distinct)
cost_agg<-cost_agg[,c(1:7,10)] # remove unncessary columns

# take first first record when multiple reported
stwist$eventDate<-gsub(";.*","",stwist$eventDate )
stwist$eventDate<-as.numeric(stwist$eventDate)

#check first record for each species to determine precolonial invaders and lag time
minyear<-stwist%>%group_by(Species, code)%>%summarise_at('eventDate', min, na.rm=T)
cost_agg<-merge(cost_agg, minyear, c("Species", "code"), all.x=T)
precol<-unique(subset(minyear, eventDate<1500)$Species) # remove pre-colonial invaders
cost_agg<-subset(cost_agg, Species%in%precol==F)
cost_agg<-subset(cost_agg, eventDate>1500) # remove pre-colonial invaders
cost_agg$eventDate[which(is.infinite(cost_agg$eventDate))]<-NA

#first invacost record for species in each country
minyear2<-cost_agg%>%group_by(Species, code)%>%summarise_at('Impact_year', min)
colnames(minyear2)[3]<-"First_invacost"
cost_agg<-merge(cost_agg,minyear2, all.x=T)
cost_dm<-subset(cost_agg, Type_of_cost_merged=="Damage_costs")
sub_dm<-subset(cost_dm, Genus%in%c("Aedes", "Ambrosia", "Procyon", "Callosciurus"))

#calculate management delay for each species as first invacost management record
sub_dm$First_manage<-NA
for (i in 1:nrow(sub_dm))
     {
       sub_dm$First_manage[i]<-min(invacost_cln$Impact_year[which(invacost$Genus==sub_dm$Genus[i]& invacost_cln$code==sub_dm$code[i] & invacost_cln$Type_of_cost_merged=="Management_costs")], na.rm=T)}
sub_dm$First_manage[which(is.infinite(sub_dm$First_manage))]<-NA

#for genera missing country-level lags, take global management delay
sub_dm$First_manage_invacost<-NA
for (i in 1:nrow(sub_dm))
{
  sub_dm$First_manage_invacost[i]<-min(invacost$Impact_year[which(invacost$Genus==sub_dm$Genus[i]& invacost$Type_of_cost_merged=="Management_costs")], na.rm=T)}

### fill in missing management lags and get yearly time since first record
sub_clean<-cbind(sub_dm$Genus, sub_dm$code, (sub_dm$Impact_year-sub_dm$eventDate), sub_dm$Cost.USD, (sub_dm$First_manage-sub_dm$eventDate))
colnames(sub_clean)<-c("Genus", "code", "Time.since.introduction", "Cost.USD", "Management.delay")
#calculate time since sTwist first record
sub_clean[which(is.na(sub_clean[,3])),3]<-(sub_dm$Impact_year-sub_dm$First_invacost)[which(is.na(sub_clean[,3]))]
#calculate either country-level of global management delay
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_dm$First_manage_invacost-sub_dm$eventDate)[which(is.na(sub_clean[,5]))]
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_dm$First_manage_invacost-sub_dm$First_invacost)[which(is.na(sub_clean[,5]))]
write.csv(sub_clean, file="filled_logistic.csv", row.names=F)

#### Create cumulative cost dataframe based on yearly cost data ##
sub_clean<-sub_clean[order(sub_clean[,3]),]
sub_clean<-data.frame(sub_clean)
sub_clean$Cost.USD<-as.numeric(sub_clean$Cost.USD)
sub_clean$Time.since.introduction<-as.numeric(sub_clean$Time.since.introduction)
new<-sub_clean%>%group_by(Genus, Time.since.introduction)%>%summarise_if(is.numeric,sum)
new2<-sub_clean%>%group_by(Genus)%>%distinct_at('Time.since.introduction')
new2<-new2[order(new2$Genus,new2$Time.since.introduction),]
new<-new%>%group_by(Genus)%>%summarise_at('Cost.USD',cumsum)
new$Time.since.introduction<-new2$Time.since.introduction
write.csv(new, file="cumulative_logistic.csv", row.names=F)


##### repeat same process but for management costs ###
cost_agg_mgmt<-subset(cost_agg, cost_agg$Type_of_cost_merged=="Management_costs")
cost_agg_mgmt<-subset(cost_agg_mgmt, cost_agg_mgmt$Management_type=="Post-invasion_management")

sub_mg<-subset(cost_agg_mgmt, Genus%in%c("Aedes", "Salvinia", "Cenchrus", "Anoplophora"))
colnames(sub_mg)
sub_mg$First_manage<-NA
for (i in 1:nrow(sub_mg))
{
  sub_mg$First_manage[i]<-min(invacost_cln$Impact_year[which(invacost$Genus==sub_mg$Genus[i]& invacost_cln$code==sub_mg$code[i] & invacost_cln$Type_of_cost_merged=="Management_costs")], na.rm=T)}
sub_mg$First_manage[which(is.infinite(sub_mg$First_manage))]<-NA
sub_mg$First_manage_invacost<-NA
for (i in 1:nrow(sub_mg))
{
  sub_mg$First_manage_invacost[i]<-min(invacost$Impact_year[which(invacost$Genus==sub_mg$Genus[i]& invacost$Type_of_cost_merged=="Management_costs")], na.rm=T)}
write.csv(sub_mg, file="Managementcosts_logsitic.csv", row.names=F)


sub_clean<-cbind(sub_mg$Genus, sub_mg$code,(sub_mg$Impact_year-sub_mg$eventDate), sub_mg$Cost.USD, (sub_mg$First_manage-sub_mg$eventDate))
colnames(sub_clean)<-c("Genus", "code", "Time.since.introduction", "Cost.USD", "Management.delay")
sub_clean[which(is.na(sub_clean[,3])),3]<-(sub_mg$Impact_year-sub_mg$First_invacost)[which(is.na(sub_clean[,3]))]
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_mg$First_manage_invacost-sub_mg$eventDate)[which(is.na(sub_clean[,5]))]
sub_clean[which(is.na(sub_clean[,5])),5]<-(sub_mg$First_manage_invacost-sub_mg$First_invacost)[which(is.na(sub_clean[,5]))]
write.csv(sub_clean, file="filled_mgmt_logistic.csv", row.names=F)
sub_clean<-sub_clean[order(sub_clean[,3]),]
sub_clean<-data.frame(sub_clean)
sub_clean$Cost.USD<-as.numeric(sub_clean$Cost.USD)
sub_clean$Time.since.introduction<-as.numeric(sub_clean$Time.since.introduction)
new<-sub_clean%>%group_by(Genus, Time.since.introduction)%>%summarise_if(is.numeric,sum)
new2<-sub_clean%>%group_by(Genus)%>%distinct_at('Time.since.introduction')
new2<-new2[order(new2$Genus,new2$Time.since.introduction),]
new<-new%>%group_by(Genus)%>%summarise_at('Cost.USD',cumsum)
new$Time.since.introduction<-new2$Time.since.introduction
write.csv(new, file="cumulative_mgmt_logistic.csv", row.names=F)



