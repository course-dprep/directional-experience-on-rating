#Loading packages
library(dplyr)
library(GGally)
library(ggplot2)
library(tidyr)

# Creating a new variable for director_stats
director_stats$total_runtime <- director_stats$avg_runtime * director_stats$film_count

# Regressionmodel
model <- lm(avg_rating ~ total_runtime, data = director_stats)
summary(model)


# Regression with the moderator: first regression model integration with the moderator
data_mod$dominant_genre <- factor(data_mod$dominant_genre, levels = c("Drama", "Action"))

lrmmod <- lm(avg_rating ~ total_runtime * dominant_genre, data = data_mod)
summary(lrmmod)