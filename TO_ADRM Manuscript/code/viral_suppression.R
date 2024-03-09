library(dplyr)
library(lubridate)
library(survival)
library(survminer)
library(grDevices)
library(measurements)
library(gtsummary)
library(flextable)

# importing dataset


viralSuppressionDataset <- read.csv("/TO_ADRM Manuscript/datasets/viralSuppression.csv", sep=",")


glimpse(viralSuppressionDataset)



## Changing variable types


viralSuppressionDataset$baseline_date_of_collection <- dmy(viralSuppressionDataset$baseline_date_of_collection)
class(viralSuppressionDataset$baseline_date_of_collection)

viralSuppressionDataset$followup_date_of_collection <- dmy(viralSuppressionDataset$followup_date_of_collection)
class(viralSuppressionDataset$followup_date_of_collection)


viralSuppressionDataset <- as.data.frame(unclass(viralSuppressionDataset), stringsAsFactors = TRUE)



VSintegers_to_factors <- c("aids_stage")


viralSuppressionDataset[VSintegers_to_factors] <- lapply(viralSuppressionDataset[VSintegers_to_factors], as.factor)
str(viralSuppressionDataset)



# survival function and Kaplan Meier for viral suppression


viralSuppressionDataset$time_difference <- difftime(viralSuppressionDataset$followup_date_of_collection, viralSuppressionDataset$baseline_date_of_collection, units = "days")

viralSuppression_survivalObject <-Surv(viralSuppressionDataset$time_difference, viralSuppressionDataset$viral_suppression==1)

fitKM_VS <- survfit(viralSuppression_survivalObject~0, type = "kaplan-meier", conf.type="log-log", data = viralSuppressionDataset)


KM_VS <- survminer::ggsurvplot(fitKM_VS, risk.table = "abs_pct", risk.table.y.text.col = TRUE, ggtheme = theme_bw(base_size = 20), fun = "event", surv.scale = "percent", break.time.by = 90, conf.int = TRUE, main = "Survival function for time to viral suppression (K-M estimates)", font.caption = c(100, "blue"), font.tickslab = 20, font.x = c(30,"bold"), font.y = c(20,"bold"), xlab = "Time (in days after ART initiation)", ylab = "viral suppression",  risk.table.col = "strata", risk.table.height = 0.25, fontsize = 7, risk.table.y.text = TRUE, risk.table.pos = c("out"), palette =  c("#2E9FDF"), legend = "none")

print(KM_VS)

## Exporting survival curve

custom_output_dir <- "/TO_ADRM Manuscript/outputs/images"

svg(file = file.path(custom_output_dir, "KM_VS.svg"),
    width = measurements::conv_unit(x = 400, from = "mm", to = "inch"),
    height = measurements::conv_unit(x = 200, from = "mm", to = "inch"))
print(KM_VS, newpage = FALSE)
dev.off()


# survival function and survival curve for viral suppression vs initation of ART


viralSuppressionDataset$ART_initiation <- cut(viralSuppressionDataset$CD4, breaks = c(0,499,2959), labels = c("Late initiator of ART", "Early initiator of ART"))
class(viralSuppressionDataset$ART_initiation)
summary(viralSuppressionDataset$ART_initiation)


viralSuppressionDataset <-
  viralSuppressionDataset |> 
  dplyr::mutate(
    ART_initiation = forcats::fct_explicit_na(ART_initiation)
  )

VSvsART_suvivalObject <- survfit(viralSuppression_survivalObject~ ART_initiation, type = "kaplan-meier", conf.type="log-log", data = viralSuppressionDataset)


KM_VS_ART <- ggsurvplot(VSvsART_suvivalObject, risk.table = "abs_pct", risk.table.y.text.col = TRUE, ggtheme = theme_bw(base_size = 20), fun = "event", surv.scale = "percent", censor = TRUE, break.time.by = 90, main = "Survival function for time to viral suppression (K-M estimates)", font.tickslab = 20, font.x = c(30,"bold"), font.y = c(23,"bold"), font.legend = 30, xlab = "Time (in days after ART initiation)", ylab = "viral suppression", conf.int = FALSE, pval = TRUE, pval.coord=c(18,0.5), risk.table.col = "strata", risk.table.height = 0.4, risk.table.fontsize = 7, palette =  c("#E7B800", "#2E9FDF", "#3ad900"), legend = "right", legend.title = 'ART Initation', legend.labs = c("Early initiation of ART", "Late initiation of ART", "Unknown"))

print(KM_VS_ART)


## Exporting survival curve


svg(file = file.path(custom_output_dir, "KM_VS_ART.svg"),
    width = measurements::conv_unit(x = 550, from = "mm", to = "inch"),
    height = measurements::conv_unit(x = 225, from = "mm", to = "inch"))
print(KM_VS_ART, newpage = FALSE)
dev.off()


glimpse(viralSuppressionDataset)


# Creating categories and renaming variable names



viralSuppressionDataset$`Age groups` <- cut(viralSuppressionDataset$age, breaks = c(18,30,40,50,100), labels = c("Between 19 to 30 years old", "Between 31 to 40 years old", "Between 41 to 50 years old", "Greater than 50 years old"))
summary(viralSuppressionDataset$`Age groups`)

viralSuppressionDataset$`Haemoglobin count (grams per decilitre)` <- cut(viralSuppressionDataset$haemoglobin, breaks = c(0,11.9,40), labels = c("Less than 12", "Greater than 12"))
summary(viralSuppressionDataset$`Haemoglobin count (grams per decilitre)`)


viralSuppressionDataset$`ART initiation` <- cut(viralSuppressionDataset$CD4, breaks = c(0,499,2959), labels = c("Late initiator of ART", "Early initiator of ART"))
summary(viralSuppressionDataset$`ART initiation`)


variable_names <- colnames(viralSuppressionDataset)
cat(paste0("\"", variable_names, "\", "), "\n")

new_names <- c("SampleID",  "viral_suppression",  "baseline_date_of_collection",  "followup_date_of_collection",  "Sex",  "age",  "Monthly income (South African Rands)",  "Baseline TB infection", "WHO clinical diagnosed HIV-1 Stage",  "CD4",  "Haemoglobin", "time_difference", "EarlyVsLateInitators", "Age groups",  "Haemoglobin count (grams per decilitre)", "ART initiation")

viralSuppressionDataset <- setNames(viralSuppressionDataset, new_names)

str(viralSuppressionDataset)



# Cox propotional hazard


VScox <-
  coxph(viralSuppression_survivalObject ~ `Sex` + `Age groups` + `Monthly income (South African Rands)`+ `WHO clinical diagnosed HIV-1 Stage` + `Baseline TB infection` +  `Haemoglobin count (grams per decilitre)` + `ART initiation`, data = viralSuppressionDataset, na.action = na.omit) %>%
  tbl_regression(exponentiate = TRUE) %>%
  bold_p(t = 0.05) %>%
  bold_labels() %>%
  italicize_levels()
  


print(VScox)

# Exporting table

VSCox_exported <- as_flex_table(VScox)

tf <- tempfile(pattern = "Coxhazard for viral suppression", tmpdir = "/TO_ADRM Manuscript/outputs/tables", fileext = ".docx")

flextable::save_as_docx(VSCox_exported, path = tf)


sessionInfo()

