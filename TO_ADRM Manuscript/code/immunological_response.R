library(dplyr)
library(lubridate)
library(survival)
library(survminer)
library(gtsummary)
library(grDevices)
library(measurements)



## Importing dataset 



immunologicalResponseDataset <- read.csv("/TO_ADRM Manuscript/datasets/ImmunologicalResponse.csv", sep=",")




## Changing variable types


glimpse(immunologicalResponseDataset) 

immunologicalResponseDataset$baseline_date_of_collection <- dmy(immunologicalResponseDataset$baseline_date_of_collection)
class(immunologicalResponseDataset$baseline_date_of_collection)

immunologicalResponseDataset$followup_date_of_collection <- dmy(immunologicalResponseDataset$followup_date_of_collection)
class(immunologicalResponseDataset$followup_date_of_collection)


immunologicalResponseDataset <- as.data.frame(unclass(immunologicalResponseDataset), stringsAsFactors = TRUE)

VSintegers_to_factors <- c('Timepoints_in_months', "aids_stage")


immunologicalResponseDataset[VSintegers_to_factors] <- lapply(immunologicalResponseDataset[VSintegers_to_factors], as.factor)
str(immunologicalResponseDataset)


### Generating survival function and Kaplan Meier for immunological response


immunologicalResponseDataset$time_difference <- difftime(immunologicalResponseDataset$followup_date_of_collection, immunologicalResponseDataset$baseline_date_of_collection, units = "days")


immunologicalResponse_survObject <-Surv(immunologicalResponseDataset$time_difference, immunologicalResponseDataset$Immuological_response==1)


fitKM_IR <- survfit(immunologicalResponse_survObject~1, type = "kaplan-meier", conf.type="log-log", data = immunologicalResponseDataset, start.time=90)


KM_IR <- ggsurvplot(fitKM_IR, risk.table = "abs_pct",censor = TRUE, risk.table.y.text.col = TRUE, ggtheme = theme_bw(base_size = 20), fun="event", surv.scale = "percent", break.time.by = 90, conf.int = TRUE, main = "Survival function for time to immunological response (K-M estimates)", font.tickslab = 20, font.x = c(30,"bold"), font.y = c(20,"bold"), xlab = "Time (in days after ART initiation)", ylab = "immunological response", fontsize = 7, risk.table.col = "strata", risk.table.height = 0.27, palette =  c("#2E9FDF"), legend = "none")


print(KM_IR)


#### Exporting survival curve

custom_output_dir <- "/TO_ADRM Manuscript/outputs/images"

svg(file = file.path(custom_output_dir, "KM_IR.svg"),
    width = measurements::conv_unit(x = 400, from = "mm", to = "inch"),
    height = measurements::conv_unit(x = 183, from = "mm", to = "inch"))
print(KM_IR, newpage = FALSE)
dev.off()



# Creating categories and renaming variable names


immunologicalResponseDataset$`Age groups` <- cut(immunologicalResponseDataset$age, breaks = c(18,40,60,100), labels = c("Between 19 to 40 years old", "Between 41 to 60 years old", "Greater than 60 years old"))
summary(immunologicalResponseDataset$`Age groups`)

immunologicalResponseDataset$`Haemoglobin count (grams per decilitre)` <- cut(immunologicalResponseDataset$baseline_haemoglobin, breaks = c(0,11.9,40), labels = c("Less than 12", "Greater than 12"))
summary(immunologicalResponseDataset$`Haemoglobin count (grams per decilitre)`)


immunologicalResponseDataset$ART_initiation <- cut(immunologicalResponseDataset$baseline_CD4, breaks = c(0,499,2959), labels = c("Late initiator of ART", "Early initiator of ART"))
summary(immunologicalResponseDataset$ART_initiation)

immunologicalResponseDataset$`Baseline CD4+ cell counts (cells per microliter)` <- cut(immunologicalResponseDataset$baseline_CD4, breaks = c(20,100,200,500,1007), labels = c("20 - 100", "101 - 200", "201 - 500", "501 - 1007"))
summary(immunologicalResponseDataset$`Baseline CD4+ cell counts (cells per microliter`)

summary(immunologicalResponseDataset$baseline_CD4)

immunologicalResponseDataset$`Baseline viral load (copies/mL)` <- cut(immunologicalResponseDataset$baseline_viral_load, breaks = c(0,1000,5170000), labels = c("51 - 1000", "Greater than 1000"))
summary(immunologicalResponseDataset$`Baseline viral load (copies/mL)`)

variable_names <- colnames(immunologicalResponseDataset)
cat(paste0("\"", variable_names, "\", "), "\n")

new_names <- c("SampleID",  "Immuological_response",  "Timepoints_in_months",  "baseline_date_of_collection",  "followup_date_of_collection",  "Sex",  "age",  "Marital status",  "Baseline TB infection",  "Baseline bacterial infections",  "WHO clinical diagnosed HIV-1 Stage",  "TB medication",  "Bactrim",  "baseline_CD4",  "baseline_haemoglobin",  "baseline_viral_load",  "time_difference",  "Age groups",  "Haemoglobin count (grams per decilitre)",  "ART initiation",  "Baseline CD4+ cell counts (cells per microliter)",  "Baseline viral load (copies/mL)")

immunologicalResponseDataset <- setNames(immunologicalResponseDataset, new_names)

str(immunologicalResponseDataset)


# Cox propotional hazard

IRcox <-
  coxph(immunologicalResponse_survObject ~ `Sex`  + `Age groups` + `Marital status` + `ART initiation` + `Baseline bacterial infections` + `Baseline TB infection` + `TB medication`+ Bactrim + `WHO clinical diagnosed HIV-1 Stage` + `Baseline viral load (copies/mL)` + `Baseline CD4+ cell counts (cells per microliter)` + `Haemoglobin count (grams per decilitre)`, data = immunologicalResponseDataset, na.action = na.omit) %>%
  tbl_regression(exponentiate = TRUE) %>%
  bold_p(t = 0.05)  %>%
  bold_labels() %>%
  italicize_levels()

print(IRcox)

# Exporting table

IRCox_exported <- as_flex_table(IRcox)

tf <- tempfile(pattern = "Coxhazard for Immunological response", tmpdir = "/TO_ADRM Manuscript/outputs/tables", fileext = ".docx")

flextable::save_as_docx(IRCox_exported, path = tf)


sessionInfo()


