# HIV-Treatment-outcomes-in-Northern-South-Africa

This repository contains R code used for analysis included in our manuscript titled **Immunologic, virologic and drug resistance outcomes in an HIV-infected prospective cohort on treatment in South Africa** [DOI]. The analysis was performed using R-4.2.3 (arm64).

## Overview
The project includes scripts for data preparation, summary table, survival analysis, cox regression analysis and correlation plot. Key components include:

Data Preparation: Importing dataset and updating variable types
summary table: Table 1 summarizing characteristics of population
Survival Analysis: Implementation of survival analysis to generate Kaplan Meier curves for viral suppression and immunological response
Cox proportional hazard regression analysis: Implementation of cox proportional hazard regression to show association between predictor variables and outcome variables namely viral suppression and immunological response
Visualization: Generation of plot to visualize association between drug resistance detected and viral load

## Repository Structure

A parent folder called "TO_ADRM Manuscript" which contains 3 child folders called "code", "dataset" and "outputs". The child folder outputs contains sub-child folders "images" and "tables"

The child folder labelled code contains R codes used to generate outputs
- table_1.R: R script summarizing characteristics of study population
- viral_suppression.R: R script for viral suppression Kaplan Meier curve and cox hazard model
- immunological_response.R: R script for immunological response Kaplan Meier curve and cox hazard model
- cox_regression_analysis.R: R script for regression analysis
- ADRMandVLcorrelations.R: R script for visualizing drug resistance vs viral load

The child folder labelled dataset contains all the files containing data for running the analysis 
- BaselineData.csv: Baseline data for summarizing characteristics of study population
- viralSuppression.csv: Viral suppression data
- ImmunologicalResponse.csv: Immunological response data
- ADRMandVLcorr.csv: data for visualizing drug resistance vs viral load
- ADRMdata.xlsx: data for excel graphs for summarizing frequencies of acquired drug resistance

The child folder labelled outputs contains word/docx files and svg images generated from running analysis 

## How to Use
To run the analysis, follow these steps:

- Ensure you have R are installed on your system.
- Install required R packages:
  - measurements
  - survminer
  - ggpubr
  - ggplot2
  - survival
  - lubridate
  - flextable
  - forcats
  - gtsummary
  - dplyr
- Clone this repository to your local machine.
- Set your working directory to the cloned repository's root.
- Run R script in R or RStudio.

## Results

### Summary table 

[Table showing participant characteristics](TO_ADRM%20Manuscript/outputs/tables/Summary%20tablec3429c16269.docx)


### Immunological response 
#### Kaplan Meier curve for immunological response

![KM_IR.svg](https://github.com/GitBixa/HIV-1-Treatment-outcomes-in-Northern-South-Africa/blob/main/TO_ADRM%20Manuscript/outputs/images/KM_IR.svg)

#### Cox regression

[Table showing associations between immunological response and participant characteristics](TO_ADRM%20Manuscript/outputs/tables/Coxhazard%20for%20Immunological%20responsec344907189f.docx)



### Viral suppression
#### Kaplan Meier curve for viral suppression
![KM_VS.svg](https://github.com/GitBixa/HIV-1-Treatment-outcomes-in-Northern-South-Africa/blob/main/TO_ADRM%20Manuscript/outputs/images/KM_VS.svg)

#### Kaplan Meier curve for viral suppression stratified by intiation of ART

![KM_VS_ART.svg](https://github.com/GitBixa/HIV-1-Treatment-outcomes-in-Northern-South-Africa/blob/main/TO_ADRM%20Manuscript/outputs/images/KM_VS_ART.svg)


#### Cox regression

[Table showing associations between viral suppression and participant characteristics](TO_ADRM%20Manuscript/outputs/tables/Coxhazard%20for%20viral%20suppressionc34b7098c.docx)


### ADRM and viral load correlation

![](https://github.com/GitBixa/HIV-1-Treatment-outcomes-in-Northern-South-Africa/blob/main/TO_ADRM%20Manuscript/outputs/images/ADR-viral%20load%20correlation.svg)

### Acquired drug resistance 


[Excel file with data and graphs showing counts of Acquired drug resistance](TO_ADRM%20Manuscript/datasets/ADRMdata.xlsx)



## Session Info

```r
R version 4.2.3 (2023-03-15 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 19045)

Matrix products: default

Random number generation:
 RNG:     Mersenne-Twister 
 Normal:  Inversion 
 Sample:  Rounding 
 
locale:
[1] LC_COLLATE=English_United States.utf8  LC_CTYPE=English_United States.utf8   
[3] LC_MONETARY=English_United States.utf8 LC_NUMERIC=C                          
[5] LC_TIME=English_United States.utf8    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] measurements_1.5.1 survminer_0.4.9    ggpubr_0.6.0       ggplot2_3.4.4     
 [5] survival_3.5-3     lubridate_1.9.3    flextable_0.9.4    forcats_1.0.0     
 [9] gtsummary_1.7.2    dplyr_1.1.4       

loaded via a namespace (and not attached):
 [1] ggtext_0.1.2            fontquiver_0.2.1        tools_4.2.3            
 [4] backports_1.4.1         utf8_1.2.4              R6_2.5.1               
 [7] colorspace_2.1-0        withr_3.0.0             tidyselect_1.2.0       
[10] gridExtra_2.3           curl_5.2.0              compiler_4.2.3         
[13] textshaping_0.3.7       cli_3.6.2               gt_0.10.1              
[16] xml2_1.3.6              officer_0.6.3           fontBitstreamVera_0.1.1
[19] labeling_0.4.3          sass_0.4.8              scales_1.3.0           
[22] survMisc_0.5.6          askpass_1.2.0           commonmark_1.9.0       
[25] systemfonts_1.0.5       stringr_1.5.1           digest_0.6.30          
[28] svglite_2.1.3           rmarkdown_2.25          gfonts_0.2.0           
[31] pkgconfig_2.0.3         htmltools_0.5.7         labelled_2.12.0        
[34] fastmap_1.1.1           rlang_1.1.1             rstudioapi_0.15.0      
[37] httpcode_0.3.0          shiny_1.8.0             farver_2.1.1           
[40] generics_0.1.3          zoo_1.8-12              jsonlite_1.8.8         
[43] zip_2.3.1               car_3.1-2               magrittr_2.0.3         
[46] Matrix_1.6-5            Rcpp_1.0.12             munsell_0.5.0          
[49] fansi_1.0.6             abind_1.4-5             gdtools_0.3.5          
[52] lifecycle_1.0.4         stringi_1.8.3           carData_3.0-5          
[55] grid_4.2.3              promises_1.2.1          crayon_1.5.2           
[58] lattice_0.20-45         haven_2.5.4             cowplot_1.1.3          
[61] splines_4.2.3           gridtext_0.1.5          hms_1.1.3              
[64] knitr_1.45              pillar_1.9.0            uuid_1.2-0             
[67] markdown_1.12           ggsignif_0.6.4          crul_1.4.0             
[70] glue_1.7.0              evaluate_0.23           fontLiberation_0.1.0   
[73] data.table_1.14.10      broom.helpers_1.14.0    vctrs_0.6.5            
[76] httpuv_1.6.14           gtable_0.3.4            openssl_2.1.1          
[79] purrr_1.0.2             tidyr_1.3.1             km.ci_0.5-6            
[82] xfun_0.41               mime_0.12               xtable_1.8-4           
[85] broom_1.0.5             rstatix_0.7.2           later_1.3.2            
[88] ragg_1.2.7              tibble_3.2.1            KMsurv_0.1-5           
[91] timechange_0.3.0        ellipsis_0.3.2   
```
