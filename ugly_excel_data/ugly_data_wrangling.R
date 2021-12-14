library(dplyr, warn.conflicts = FALSE)
library(tidyxl, warn.conflicts = FALSE)
library(lubridate, warn.conflicts = FALSE)

source(here::here("ugly_excel_data/functions.R"))

raw_data <- xlsx_cells(here::here("ugly_excel_data/ugly_data.xlsx"))

activity_names <- raw_data %>%
  filter(row == 6 & !is.na(character)) %>% 
  select(sheet, col, activity_name = character)

duration <- find_activity_stat(2, 5) %>% 
  mutate(col = col-1, duration = case_when(
    !is.na(date) ~ stringr::word(date, 2),
    !is.na(character) ~ paste0("00", character, ":00"),
    !is.na(numeric) ~ paste0("00:", numeric, ":00"),
  ), .keep = "unused")

date <- find_activity_stat(1, 4) %>% 
  mutate(date = case_when(
    !is.na(date) ~ as_date(date),
    !is.na(character) ~ mdy(character),
    is.na(numeric) ~ NA_Date_
  ), .keep = "unused")

distance <- find_activity_stat(3, 6) %>% 
  mutate(col = col-2, distance = numeric) %>% 
  select(sheet:col, distance)

activity_data <- left_join(activity_names, duration, by = c("sheet", "col")) %>% 
  left_join(date, by = c("sheet", "col", "row")) %>% 
  left_join(distance, by = c("sheet", "col", "row"))

player_name <- raw_data %>% 
  filter(row == 1 & col == 2) %>% 
  select(sheet, player_name = character)

player_data <- purrr::map2(list(2,3,4), list("player_height", "player_weight", "player_age"), find_player_stat) %>%
  plyr::join_all("sheet") %>% 
  left_join(player_name, by = "sheet")

clean_data <- left_join(player_data, activity_data, by = "sheet") %>% 
  select(player_id = sheet, player_name, everything(), -c(row, col))
