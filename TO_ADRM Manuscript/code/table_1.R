
library(dplyr)
library(gtsummary)
library(forcats)
library(flextable)


# Importing data

BaselineDataset <- read.csv(file = "/TO_ADRM Manuscript/datasets/BaselineData.csv", sep=",") # Add absolute file path here 

glimpse(BaselineDataset)

## Change some of the integer and character variables to factors

BaselineDataset <- as.data.frame(unclass(BaselineDataset), stringsAsFactors = TRUE)
glimpse(BaselineDataset)


integers_to_factors <- c("tuberculosis_infection", "cryptococcus", "herpes", "bacterial_infections","fungal_infection", "non.communicable", "aids_stage", "tuberculosis_medication", "antiviral_acyclovir", "antibiotics", "hypertension_diabetes_asthma_medication", "bactrim", "vitamin_supplement", "antifungal")


BaselineDataset[integers_to_factors] <- lapply(BaselineDataset[integers_to_factors], as.factor)

## create categorical variables for age groups, CD4 groups, haemoglobin groups, viral load groups and year of infection 


BaselineDataset$age_groups <- cut(BaselineDataset$age, breaks = c(0,20,40,60, 100), labels = c("Less than or equal 20", "Between 21 and 40", "Between 41 and 40", "Greater than 60"))
summary(BaselineDataset$age_groups)

BaselineDataset$categorised_year_of_infection <- cut(BaselineDataset$probable_year_of_infection, breaks = c(2002,2014,2015,2017), labels = c("2002 - 2014", "2015", "2015-2017"))
summary(BaselineDataset$categorised_year_of_infection)


BaselineDataset$CD4_groups <- cut(BaselineDataset$CD4, breaks = c(0,50,100,200,350,500,1024), labels = c("Less than 50", "50 - 100", "101 – 200", "201 – 350", "351 – 500", "501 – 1024"))
summary(BaselineDataset$CD4_groups)

BaselineDataset$ART_initiation <- cut(BaselineDataset$CD4, breaks = c(0,500,1024), labels = c("CD4<500", "CD4>500"))
summary(BaselineDataset$ART_initiation)

BaselineDataset$percent_CD4_groups <- cut(BaselineDataset$percent_CD4, breaks = c(0,5,10,20,30,40,50), labels = c("Less than 5%", "5% – 10%", "11% – 20%", "21% – 30%", "31% – 40%", "41% – 50%"))
summary(BaselineDataset$percent_CD4_groups)

BaselineDataset$haemoglobin_groups <- cut(BaselineDataset$haemoglobin, breaks = c(4,6.4,7.9,10,11.9,27), labels = c("4 - 6.4", "6.5 - 7.9", "8 - 10", "10.1 - 12", "Greater than 12"))
summary(BaselineDataset$haemoglobin_groups)

BaselineDataset$viral_load_groups <- cut(BaselineDataset$viral_load, breaks = c(0,21,50,1000,70283606), labels = c("Not detected – 20", "20 – 50", "51 - 1000", "1001 - 7283606"))
summary(BaselineDataset$viral_load_groups)


# Summary table


BaselineDataset <-
  BaselineDataset |> 
  dplyr::mutate(
    ART_initiation = forcats::fct_explicit_na(ART_initiation)
  )


summary_table <- 
  BaselineDataset %>%
  select(sex, age, age_groups, marital_status, level_of_education, income_in_rands_per_month, occupation, place_of_infection, categorised_year_of_infection, aids_stage, tuberculosis_infection, cryptococcus, herpes, bacterial_infections, fungal_infection, non.communicable, current_arv_regimen, tuberculosis_medication, antiviral_acyclovir, antibiotics, hypertension_diabetes_asthma_medication, bactrim, vitamin_supplement, antifungal, CD4_groups, percent_CD4_groups, haemoglobin_groups, viral_load_groups, ART_initiation) %>% 
  tbl_summary(by = ART_initiation, statistic = list(all_continuous() ~ "{median} (IQR: {p25} - {p75})", all_categorical() ~ "{n} ({p}%)"),
              type = list(tuberculosis_infection ~"categorical",
                          cryptococcus ~ "categorical",
                          herpes ~ "categorical",
                          bacterial_infections ~ "categorical",
                          fungal_infection ~ "categorical",
                          non.communicable ~ "categorical",
                          tuberculosis_medication ~ "categorical",
                          antiviral_acyclovir ~ "categorical",
                          antibiotics ~ "categorical",
                          hypertension_diabetes_asthma_medication ~ "categorical",
                          bactrim ~ "categorical",
                          vitamin_supplement ~ "categorical",
                          antifungal ~ "categorical"),
              label = list(
                sex ~ "Sex",
                age ~ "Age (in Years)", 
                age_groups ~ "Age ranges",
                marital_status ~ "Marital Status",
                level_of_education ~ "Education",
                income_in_rands_per_month ~ "Monthly income (ZAR)",
                occupation ~ "Employment Status",
                place_of_infection ~ "Geographical area lived in when acquired HIV infection",
                categorised_year_of_infection ~ "Probable Year of HIV infection",
                aids_stage ~ "WHO clinical diagnosed HIV-1 Stage",
                tuberculosis_infection ~ "Tuberculosis infection",
                cryptococcus ~ "Cryptococcus infection",
                herpes ~ "Herpes infection",
                bacterial_infections ~ "Bacterial infections",
                fungal_infection ~ "Fungal infection",
                non.communicable ~ "Non-communicable diseases (hypertension, diabetes, and asthma)",
                current_arv_regimen ~ "ARV regimen",
                tuberculosis_medication ~ "TB medication (RHZE and INH)",
                antiviral_acyclovir ~ "Acyclovir (Antiviral)",
                antibiotics ~ "Antibiotics (Augmentin, Amoxicillin, Ceftriaxone, cloxacillin, erythromycin, flagyl)",
                hypertension_diabetes_asthma_medication ~ "Medication for non-communicable diseases",
                bactrim ~ "Bactrim",
                vitamin_supplement ~ "Vitamin and mineral supplements",
                antifungal ~ "Flucozole (antifungal)",
                CD4_groups ~ "CD4 measurement pre-ART initiation (cells per µl blood)",
                percent_CD4_groups ~ "Percentage CD4+ cells pre-ART initiation", 
                haemoglobin_groups ~ "Haemoglobin measurements pre-ART initiation (grams per decilitre)",
                viral_load_groups ~ "Viral load measurement pre-ART initiation (viral count per ml blood)"
              ),
              missing_text = "Unknown") %>%
  add_stat_label()


summary_table_beautified <- 
  summary_table %>%
  bold_labels() %>%
  italicize_levels() %>%
  add_p() %>%
  add_overall() %>%
  modify_footnote(all_stat_cols() ~ "median (IQR) for continuous variables; n (%) for categorical variables") %>%
  bold_p(t = 0.05)  


print(summary_table_beautified)


## Exporting table 

summary_table_beautified_exported <- as_flex_table(summary_table_beautified)

tf <- tempfile(pattern = "Summary table", tmpdir = "/TO_ADRM Manuscript/outputs/tables", fileext = ".docx") # Add the absolute file path here

flextable::save_as_docx(summary_table_beautified_exported, path = tf)



