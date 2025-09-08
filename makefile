# This makefile will be used to automate the
load_pkg <- function(pkg){
  if(!require(pkg, character.only = TRUE)){
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}
packages <- c("readr", "tidyverse", "tidyr", "dplyr", "tinytex", "rmarkdown")

lapply(packages, load_pkg)

# set working directory
setwd("your data path")

# load the data
title_ratings <- read_tsv("title.ratings.tsv")  
title_crew    <- read_tsv("title.crew.tsv")        
name_basics   <- read_tsv("name.basics.tsv")                

title_basics <- read_tsv("title.basics.tsv") %>% 
  filter(titleType == "movie") %>%
  select(tconst, runtimeMinutes, genres)


#different steps in your project.