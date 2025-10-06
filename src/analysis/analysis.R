#SETUP
packages <- c("readr", "tidyverse", "dplyr", "ggplot2")
lapply(packages, library, character.only = TRUE)

# Set working directory
setwd("../../")

#INPUT
imdb_movies_direct <- read_csv("gen/temp/imdb_movies_direct.csv")
imdb_movies_mod <- read_csv("gen/temp/imdb_movies_mod.csv")

#TRANSFORMATION
#Transform the data for the direct effect of total_runtime on average IMDB rating
linearregression_directeffect <- lm(avg_rating ~ total_runtime, data = imdb_movies_direct)
summary(linearregression_directeffect)


p <- ggplot(imdb_movies_direct, aes(x = total_runtime, y = avg_rating)) +
  geom_point(color = "#007BFF", alpha = 1, size = 0.5) +                
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(
    title = "The relationship between total runtime and average rating",
    x = "Total runtime (minutes)",
    y = "Average rating"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "#3A0CA3"),
    plot.subtitle = element_text(size = 13, color = "#7209B7"),
    axis.title = element_text(face = "bold", color = "#264653"),
    axis.text = element_text(color = "#333333"),
    panel.grid.major = element_line(color = "#F1F1F1"),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "#FFF9F3", color = NA),
    panel.background = element_rect(fill = "#FFF9F3", color = NA),
    legend.position = "right",
    legend.background = element_rect(fill = "#FFF9F3", color = NA)
  )

#Transformation of the moderating effect
imdb_movies_mod$most_common_genre <- factor(imdb_movies_mod$most_common_genre)
linear_model_moderatinginteraction <- lm(avg_rating ~ total_runtime * most_common_genre,
                               data = imdb_movies_mod)
summary(linear_model_moderatinginteraction)

pmod <- ggplot(imdb_movies_mod, aes(x = total_runtime, y = avg_rating, color = most_common_genre)) +
  geom_point(alpha = 0.6, size = 0.7) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1.2) +
  facet_wrap(~most_common_genre) +
  scale_color_manual(values = c("Action" = "#FF6B6B", "Drama" = "#1F77B4")) +
  labs(
    title = "Runtime & Genre on Average Rating, with an interaction effect",
    x = "Total Runtime (minutes)",
    y = "Average IMDb Rating",
    color = "Genre"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 14, color = "#3A0CA3"),
    plot.subtitle = element_text(size = 12, color = "#7209B7"),
    axis.title = element_text(face = "bold", color = "#264653"),
    axis.text = element_text(color = "#333333"),
    panel.grid.major = element_line(color = "#F1F1F1"),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "#FFF9F3", color = NA),
    panel.background = element_rect(fill = "#FFF9F3", color = NA),
    legend.position = "right",
    legend.background = element_rect(fill = "#FFF9F3", color = NA)
  )
print(pmod)

#OUTPUT

#Output for the direct effect
summary(linearregression_directeffect)

ggsave(
  filename = "gen/temp/visual_directeffect.png",  
  plot = p,                              
  width = 7, height = 5, dpi = 300       
)

#Output for the moderating effect
summary(linear_model_moderatinginteraction)

ggsave(
  filename = "gen/temp/visual_moderatingeffect.png",  
  plot = pmod,                              
  width = 10, height = 5, dpi = 300       
)