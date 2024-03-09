library(dplyr)
library(ggpubr)


## Importing dataset 

ADRMdataset <- read.csv("C:/Users/bixaj/DROPBOX MAR2022/Dropbox/PHD 2017-2018/R ANALYSIS DATA FOR CD4 AND VL DATA ANALYSIS/TO_ADRM Manuscript/datasets/ADRMandVLcorr.csv", sep=",")



glimpse(ADRMdataset)

## Changing variable types

ADRMdataset <- as.data.frame(unclass(ADRMdataset), stringsAsFactors = TRUE)

glimpse(ADRMdataset)

## Reorder timepoint categories

FollowUpONLYADRMdataset$Timepoint_reordered <- factor(FollowUpONLYADRMdataset$timepoint, levels = c("3 months", "6 months", "9 months", "12 months"))
levels(FollowUpONLYADRMdataset$Timepoint_reordered)

## Plotting correlation

ADRMviralLoadCor <- ggboxplot(data = FollowUpONLYADRMdataset, x="DRMvariants", y="follow_up_log_hiv", select = c("Majority variant", "Minority variant"), color = "DRMvariants", add = "jitter", shape = "DRMvariants", facet.by ="Timepoint_reordered", short.panel.labs = FALSE) + scale_shape_manual(values=c(16, 17)) + scale_size_manual(values=c(18,18)) + facet_wrap(.~Timepoint_reordered, ncol=2, nrow=2, drop = TRUE, scales="free_y") + labs(x="", y="HIV-1 viral loads (log10 copies/mL)") +  stat_compare_means(method.args = list(alternative = "greater"), size=5, label= "p.signif", label.x=0.7, label.y =6.0) + theme(legend.position = "none") + theme(text = element_text(size =20), strip.text.x = element_text(size = 20, color = "blue", face = "bold"))   

print(ADRMviralLoadCor)


ADRMviralLoadCor_final <- print(ADRMviralLoadCor +  ylim(0,8) +  stat_compare_means(size=5, label.x=0.7, label.y =6.5) + theme(legend.position = "none"))                                                     




## Export correlation graphs 

custom_dir <- "C:/Users/bixaj/DROPBOX MAR2022/Dropbox/PHD 2017-2018/R ANALYSIS DATA FOR CD4 AND VL DATA ANALYSIS/TO_ADRM Manuscript/outputs/images"


ggsave(filename = file.path(custom_dir, "ADR-viral load correlation.svg"), plot=ADRMviralLoadCor_final, width=30, height=30,  unit="cm", dpi=300)




