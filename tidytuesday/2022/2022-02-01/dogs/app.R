library(shiny) # Web Application Framework for R
library(dplyr) # A Grammar of Data Manipulation
library(tidyr) # Tidy Messy Data
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(purrr) # Functional Programming Tools
library(stringr) # Simple, Consistent Wrappers for Common String Operations
library(tibble) # Simple Data Frames
library(showtext) # Using Fonts More Easily in R Graphs 

# Data Prep ---------------------------------------------------------------
showtext_auto()
walk2(c("Press Start 2P", "Akaya Telivigala"), c("stats", "annotation"), font_add_google)

prep_data <- function(x) {
  readRDS(x) %>%
    janitor::clean_names() %>%
    arrange(across(1)) %>% 
    rowid_to_column(var = "dog_id")
}

dogs <- map(fs::dir_ls(here::here("tidytuesday/2022/2022-02-01/dogs"), glob = "*.rds"), prep_data)

traits <- dogs[[2]] %>% 
  pivot_longer(-c(breed, dog_id, coat_type, coat_length), names_to = "trait", values_to = "trait_value") %>% 
  mutate(trait = str_replace_all(trait, "_", " "), breed = str_squish(breed)) %>% 
  right_join(dogs[[1]][c(1,12)], by = "dog_id") %>% 
  mutate(coat_desc = paste0("Coat is ", str_to_lower(paste(coat_length, coat_type, sep = " \nand "))))


# Shiny UI ----------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Dogs + Data"),
  
  mainPanel(
    selectInput("dog", "Choose a dog", traits %>% distinct(breed) %>% pull()),
    plotOutput("plot")
  )
)


# Shiny Server ------------------------------------------------------------
server <- function(input, output) {
  
  output$plot <- renderPlot({
    selected_dog <- traits %>% filter(breed == input$dog)
    
    ggplot(tibble(x = c(0,10), y = c(-9,16))) +
      theme_void() +
      ggimage::geom_image(aes(x = 5, y = 10, image = selected_dog$image[1]), size = 0.35) +
      geom_text(aes(x = 5, y = 16, label = selected_dog$breed[1]), size = 7.5, family = "stats") +
      annotate(geom = "curve", x = 7, y = 13, xend = 6, yend = 12, curvature = 0.2, arrow = arrow(length = unit(2, "mm")), size = 0.75) +
      annotate(geom = "text", x = 7.2, y = 13, label = selected_dog$coat_desc[1], hjust = "left", size = 6, family = "annotation") +
      pmap(list(rep(1, 14), seq(-8.5, 4.5, 1), traits %>% distinct(trait) %>% pull()), ~geom_text(aes(x = ..1, y = ..2), label = str_to_sentence(..3), size = 5, family = "stats", hjust = 0)) +
      pmap(list(rep(9, 14), seq(-8.5, 4.5, 1), traits %>% distinct(trait) %>% pull()), ~geom_text(aes(x = ..1, y = ..2, label = selected_dog$trait_value[selected_dog$trait==..3], family = "stats"), size = 5)) +
      scale_y_continuous(limits = c(-9,16)) +
      scale_x_continuous(limits = c(0,10))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
