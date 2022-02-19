library(dplyr) # A Grammar of Data Manipulation
library(janitor) # Simple Tools for Examining and Cleaning Dirty Data
library(lubridate) # Make Dealing with Dates a Little Easier
library(tidyr) # Tidy Messy Data
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(purrr) # Functional Programming Tools
library(stringr) # Simple, Consistent Wrappers for Common String Operations
library(widyr)
library(tidytext)


chocolate <- readRDS(here::here("tidytuesday/2022/2022-01-18/chocolate.rds"))

# chocolate %>%
#   with_groups(company_location, summarise, avg_rating = median(rating), n = n()) %>% 
#   filter(n > 9) %>% 
#   arrange(desc(avg_rating))

chocolate %>%
  filter(company_location == "Australia") %>% 
  mutate(
    word_1 = word(most_memorable_characteristics, 1, sep = ",") %>% str_trim(),
    word_2 = word(most_memorable_characteristics, 2, sep = ",") %>% str_trim(),
    word_3 = word(most_memorable_characteristics, 3, sep = ",") %>% str_trim()
    ) %>% 
  pivot_longer(word_1:word_3, names_to = "characteristic_number", values_to = "characteristic") %>% 
  add_count(characteristic) %>%
  filter(n >= 3 & !is.na(characteristic)) %>%
  pairwise_cor(characteristic, ref, sort = TRUE)

