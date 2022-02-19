library(dplyr) # A Grammar of Data Manipulation
library(ggplot2) # Create Elegant Data Visualisations Using the Grammar of Graphics
library(purrr) # Functional Programming Tools

frames <- tibble::tribble(
  ~x, ~xend, ~y, ~yend,
  0,   0,    0,   13,
  0,   13,   13,  13,
  13,  13,   13,  0,
  13,  0,    0,   0,
  2,   2,    2,   11,
  2,   11,   11,  11,
  11,  11,   11,  2,
  11, 2,     2,   2
)

ggplot(data = tibble(x = seq(0:13), y = seq(0:13))) +
  theme_void() +
  pmap(frames, ~geom_segment(aes(x = ..1, xend = ..2, y = ..3, yend = ..4))) +
  pmap(list(rep(0, 10), rep(2, 10), seq(2,11), seq(2,11)), ~geom_segment(aes(x = ..1, xend = ..2, y = ..3, yend = ..4))) +
  pmap(list(rep(11, 10), rep(13, 10), seq(2,11), seq(2,11)), ~geom_segment(aes(x = ..1, xend = ..2, y = ..3, yend = ..4))) +
  pmap(list(seq(2,11), seq(2, 11), rep(13,10), rep(11,10)), ~geom_segment(aes(x = ..1, xend = ..2, y = ..3, yend = ..4))) +
  pmap(list(seq(2,11), seq(2, 11), rep(0,10), rep(2,10)), ~geom_segment(aes(x = ..1, xend = ..2, y = ..3, yend = ..4))) +
  geom_rect(aes(xmin = 2, xmax = 3, ymin = 1.5, ymax = 1.5))

