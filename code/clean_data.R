library(tidyverse)
library(readxl)
library(glue)
library(janitor)


files <- list.files(path = "data/raw/year_2019", pattern = "*.xlsx", full.names = T)


x = files %>%
  map(read_excel) %>%
  reduce(bind_rows)


colnames(x) = x[3, ]

x %>% clean_names() %>% 
  unite(dir, c("direccion", "na", "na_2", sep = "", remove = TRUE))

