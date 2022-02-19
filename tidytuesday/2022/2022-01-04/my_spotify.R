library(dplyr) # A Grammar of Data Manipulation
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(purrr) # Functional Programming Tools

podcasts <- c(
  "History Extra podcast",
  "The Rest Is History",
  "THE ADAM BUXTON PODCAST",
  "Blocked and Reported",
  "FiveThirtyEight Politics",
  "TALKING POLITICS",
  "The Property Academy Podcast",
  "Why Is This Happening? The Chris Hayes Podcast",
  "Payne's Politics",
  "Revolutions",
  "Stories of our times",
  "The Media Show",
  "The Briefing Room",
  "The Intelligence from The Economist",
  "Bridges to the Future",
  "Honestly with Bari Weiss",
  "Tides of History",
  "Conversations With Coleman ",
  "Talking Politics: HISTORY OF IDEAS",
  "The LRB Podcast",
  "Producing The Beatles"
)

scrobbles <- map(fs::dir_ls(here::here("tidytuesday/2022/2021-01-04/spotify_data")), jsonlite::fromJSON) %>%
  bind_rows() %>% 
  tibble() %>% 
  filter(msPlayed > 0)

top_artists <- scrobbles %>% 
  filter(!artistName %in% podcasts) %>% 
  with_groups(artistName, summarise, played_time = sum(msPlayed)) %>% 
  arrange(desc(played_time)) %>% 
  head(20)