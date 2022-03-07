# CostOfInaction

A Github repository to accompany Ahmed, Hudgins, Cuthbert et al. "Managing biological invasions: the cost of inaction" submitted to the *Biological Invasions* Special Issue: *Economic costs of Biological Invasions*. If you have questions or suspect an error, please e-mail me at emma.hudgins@mail.mcgill.ca or open an issue.


##### Please refer to this document in order to understand the workflow necessary to reproduce our results. 

##### the first script was written in R version 4.0.3, while the remainder use MATLAB, and require the following routine: https://au.mathworks.com/matlabcentral/fileexchange/13188-shade-area-between-two-curves

### R Scripts

- *01-Data_cleaning_script.R* - this script generates the input data required to fit models (*filled_aedes_logistic.csv* for damage costs and *filled_mgmt_aedes_logistic.csv* for management costs), based on annual cost files *annual_aedes_logistic.csv* and *annual_mgmt_aedes_logistic.csv*, using the invacost R package and (see Data accessibility statement in the main manuscript). It also produces the more generic datasheets based on initial invacost extraction *(Damagecosts_logistic.csv and Managementcosts_logistic.csv)*. Within the script, the number of independent cost references and management lag times for each genus are derived.  

### MATLAB Scripts

- *Fig_\*.m* - these scripts generates the results for Figures 2-6, which are plotted in the plots folder. Figures 2-4 are theoretical results, while Figures 5-6 use the R script-derived damage and management data to fit the curves to Aedes spp.


