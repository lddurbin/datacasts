# Load libraries
library(dplyr)
library(ggplot2)
library(showtext)
library(ggtext)

# Read data into R
# studio_album_tracks <- readr::read_csv("https://github.com/jacquietran/spice_girls_data/raw/main/data/studio_album_tracks.csv") %>% 
#   saveRDS(here::here("tidytuesday/spicegirls.rds"))

spice_girls_album_tracks <- readRDS(here::here("tidytuesday/spicegirls.rds"))

font_add_google(name = "Orbitron", family = "orbitron")
showtext_auto()

spice_girls_album_tracks %>% 
  distinct(album_name, track_name, track_number, energy) %>% 
  mutate(album_name = factor(album_name, levels = c("Spice", "Spiceworld", "Forever"))) %>% 
  ggplot(aes(x = album_name, y = energy)) +
  geom_violin(width=1.3, trim = FALSE, size = 1.6) +
  geom_jitter(aes(colour = album_name), width = 0.1, size = 5, shape = 8) +
  scale_colour_manual(values = c("#41a617", "purple", "#b2260a")) +
  ggthemes::theme_fivethirtyeight() +
  theme(
    axis.text.y = element_blank(),
    axis.text.x = element_text(size = 16, family = "orbitron"),
    legend.position = "none",
    panel.grid.major = element_blank(),
    title = element_text(family = "orbitron")
    ) +
  labs(
    title = "On their first and last albums, the Spice Girls kept the\nenergy levels pretty steady. But on Spiceworld, they\nexplored a much fuller range",
    caption = "Perceptual measure of intensity and activity of Spice Girls album tracks | Source: TidyTuesday 2021 (Week 51)"
    )
