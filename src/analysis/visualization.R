#Loading packages
library(dplyr)
library(GGally)
library(ggplot2)
library(tidyr)

# ggpairs plot
ggpairs(director_stats,
        columns = c("avg_rating", "film_count", "avg_runtime"),
        title = "Director Statistics")

# Creating a new variable for director_stats
director_stats$total_runtime <- director_stats$avg_runtime * director_stats$film_count

# Scatterplot with regressionline
ggplot(director_stats %>% dplyr::filter(total_runtime <= 20000),
       aes(x = total_runtime, y = avg_rating)) +
  geom_point(color = "blue", alpha = 0.6, size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    x = "Total runtime (avg_runtime * film_count)",
    y = "Average rating",
    title = "Linear Regression: Runtime vs Rating (≤ 20,000)"
  ) +
  theme_minimal()





