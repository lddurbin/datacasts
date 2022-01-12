library(dplyr) # A Grammar of Data Manipulation
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(gganimate) # A Grammar of Animated Graphics
library(ggtext)

# Get the Data
# tuesdata <- tidytuesdayR::tt_load('2022-01-11')
# 
# saveRDS(tuesdata$colony, here::here("tidytuesday/2022/2022-01-11/colony.rds"))

colony <- readRDS(here::here("tidytuesday/2022/2022-01-11/colony.rds"))

stressor <- readRDS(here::here("tidytuesday/2022/2022-01-11/stressor.rds"))

colonies_lost <- colony %>% 
  filter(!year %in% c("6/") & !state %in% c("United States", "Other States")) %>% 
  mutate(
    year = as.double(year),
    season = ifelse(months %in% c("October-December", "January-March"), "Autumn/Winter", "Spring/Summer"),
    seasonal_year = ifelse(months == "October-December", paste(year, year+1, sep = "/"), paste(year-1, year, sep = "/"))
    ) %>% 
  filter(!seasonal_year %in% c("2014/2015", "2020/2021")) %>% 
  with_groups(c(state, seasonal_year, season), summarise, avg_loss = mean(colony_lost_pct, na.rm = TRUE)/100) %>% 
  mutate(
    title = ifelse(season == "Spring/Summer", "Most US states report that <strong>fewer than 15%</strong> of their bee colonies are lost during <span style='color:#ffd700'><strong>Spring/Summer</strong></span>", "Many US states report that <strong>15% or more</strong> of their bee colonies are lost during <span style='color:blue'><strong>Autumn/Winter</strong></span>")
    )

plot <- ggplot(data = colonies_lost, aes(reorder(seasonal_year, desc(seasonal_year)), avg_loss)) +
  ggbeeswarm::geom_beeswarm(aes(group = 1L, size = 2, colour = season)) +
  geom_hline(yintercept = .15) +
  scale_colour_manual(values = c("blue", "#ffd700")) +
  scale_y_continuous(breaks = c(0,.15,.3), labels = scales::percent) +
  coord_flip() +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.title = element_blank(),
    plot.title.position = "plot",
    axis.text = element_text(size=12),
    plot.title = element_text(size=14),
    panel.grid.minor.x = element_blank()
  ) +
  transition_states(
    title,
    transition_length = 1.5,
    state_length = 1
  ) +
  labs(
    title = "{closest_state}",
    caption = "Average seasonal loss of bee colonies per state | Source: TidyTuesday 2022 [Week 2]"
    ) +
  theme(plot.title = element_markdown(lineheight = 1.1))

anim_save(filename = "not_the_bees.gif", animation = plot, path = "tidytuesday/2022/2022-01-11", width = 1300, height = 800, units = "px", res = 150)
