# CostOfInaction

a Github repository to accompany Ahmed, Hudgins, Cuthbert et al. "Managing biological invasions: the cost of inaction"


# Please refer to this document in order to understand the workflow necessary to reproduce our results.

1. 01Data_cleaning_script.R - this script generates the input data required to fit models (cumulative_logistic.csv for damage costs and cumulative_mgmt_logistic.csv for management costs), based on the invacost R package and sTwist_database.csv (see also Data accessibility statement in the main manuscript). It also produces the more generic datasheets based on initial invacost extraction (Damagecosts_logistic.csv and Managementcosts_logistic.csv), and those linking sTwist and invacost (filled_logistic.csv, filled_mgmt_logistic.csv). Within the script, the number of independent cost references and management lag times for each genus are derived.

2. 02Model_fitting_script - this script fits nonlinear models to cumulative_logistic.csv and cumulative_mgmt_logistic.csv in order to parameterize the logistic curves. It also allows for the calculation of the cost inaction for the Aedes example.

3. 03Plotting_script  - this script plots all figures in the manuscript