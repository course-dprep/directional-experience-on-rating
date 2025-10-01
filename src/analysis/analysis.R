#Loading packages
library(dplyr)
library(GGally)
library(ggplot2)
library(tidyr)

# input from the dataprep_directeffect and dataprep_modeffect
readr::write_csv(director_stats, "directeffect_data.csv")
readr::write_csv(data_mod, "modeffect_data.csv")

# Creating a new variable for director_stats
director_stats$total_runtime <- director_stats$avg_runtime * director_stats$film_count

# Regressionmodel
model <- lm(avg_rating ~ total_runtime, data = director_stats)
summary(model)



# Regression with the moderator: first regression model integration with the moderator
data_mod$dominant_genre <- factor(data_mod$dominant_genre, levels = c("Drama", "Action"))

lrmmod <- lm(avg_rating ~ total_runtime * dominant_genre, data = data_mod)
summary(lrmmod)

#Output results from the lrmmod
lrmmodel_summary <- summary(lrmmod)
coef_lrmmod <- as.data.frame(lrmmod_summary$coefficients)
coef_lrmmod$Term <- ownames(coef_lrmmod)
coef_lrmmod <- coef_lrmmode\[, c("Term", "Estimate", "Std. Error", "t value", "Pr(>|t|)")\]
write.csv(coef_lrmmod,"analysis.csv", row.names = FALSE)