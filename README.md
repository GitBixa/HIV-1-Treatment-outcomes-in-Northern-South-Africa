# HIV-Treatment-outcomes-in-Northern-South-Africa

This repository contains R code used for analysis included in our manuscript titled **Immunologic, virologic and drug resistance outcomes in an HIV-infected prospective cohort on treatment in South Africa** [DOI]. The analysis was performed using R-4.2.3 (arm64).

## Overview
The project includes scripts for data preparation, summary table, survival analysis, cox regression analysis and correlation plot. Key components include:

Data Preparation: Importing dataset and verifying variables
summary table: Table 1 summarizing characteristics of population
Survival Analysis: Implementation of survival analysis to generate Kaplan Meier curves for viral suppression and immunological response
Cox proportional hazard regression analysis: Implementation of cox proportional hazard regression to show association between predictor variables and outcome variables namely viral suppression and immunological response
Visualization: Generation of plot to visualize association between drug resistance detected and viral load

## Repository Structure

table_1.R: R script summarizing characteristics of study population
viral_suppression_survival.R: R script for viral suppression Kaplan Meier curve.
immunological_response_survival.R: R script for immunological response Kaplan Meier curve.
cox_regression_analysis.R: R script for regression analysis
drug_resistance_vs_viral_load.R: R script for plotting drug resistance vs viral load

How to Use
To run the analysis, follow these steps:

Ensure you have R installed on your system.
Install required R packages: tidyverse, readxl, GetoptLong, openxlsx, ggprism, broom.mixed, ggalt, survival, ggsurvfit, and survminer:
install.packages(c("tidyverse", "readxl", "GetoptLong", "openxlsx", "ggprism", "broom.mixed", "ggalt", "survival", "ggsurvfit", "survminer"))
Clone this repository to your local machine.
Set your working directory to the cloned repository's root.
Run R script in R or RStudio.
