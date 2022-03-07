# CostOfInaction

A Github repository to accompany Ahmed, Hudgins, Cuthbert et al. "Managing biological invasions: the cost of inaction" submitted to the *Biological Invasions* Special Issue: *Economic costs of Biological Invasions*. If you have questions or suspect an error, please e-mail me at emma.hudgins@mail.mcgill.ca or open an issue.


##### Please refer to this document in order to understand the workflow necessary to reproduce our results. 

##### the first script was written in R version 4.0.3, while the remainder use MATLAB, and require the following routine: https://au.mathworks.com/matlabcentral/fileexchange/13188-shade-area-between-two-curves


1. *01-Data_cleaning_script.R* - this script generates the input data required to fit models (*cumulative_logistic.csv* for damage costs and *cumulative_mgmt_logistic.csv* for management costs), based on the invacost R package and (see Data accessibility statement in the main manuscript). It also produces the more generic datasheets based on initial invacost extraction *(Damagecosts_logistic.csv and Managementcosts_logistic.csv)*. Within the script, the number of independent cost references and management lag times for each genus are derived.  

2. *02-Fig2.m* - this script creates the theoretical results for Figure 2.

3. *03-Fig3.m* - this script creates the theoretical results for Figure 3.

4. *04-.\** - these two folders have 4 MATLAB scripts each, one for each genus, that fit nonlinear models to the data contained in 1. *cumulative_logistic.csv* and 2. *cumulative_mgmt_logistic.csv* in order to parameterize the logistic curves. 

6. *05-Fig6.m* - this script calculates the cost of inaction for the *Aedes* example.
