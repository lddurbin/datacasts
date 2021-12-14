library(dplyr, warn.conflicts = FALSE)
library(tidyxl, warn.conflicts = FALSE)
library(unpivotr, warn.conflicts = FALSE)
library(tidyr, warn.conflicts = FALSE)

raw_data <- xlsx_cells(here::here("ugly_excel_data/ugly_data.xlsx"))

prepare_table <- function(cells, header_position, remove_first, remove_second) {
  cells %>% 
    behead(header_position, header) %>% 
    select(-{{remove_first}}) %>% 
    spatter(header) %>% 
    select(-{{remove_second}})
}

clean_exercise_data <- function(col_range) {
  raw_data %>% 
    filter(row > 5, col %in% col_range) %>% 
    select(sheet, row, col, data_type, ugly_character = character, numeric, ugly_date = date) %>% 
    mutate(exercise = case_when(row == 6 ~ ugly_character)) %>% 
    fill(exercise) %>% 
    filter(row > 6) %>% 
    mutate(
      character = case_when(
        (col == col_range[2] & row > 7) & !is.na(ugly_date) ~ stringr::word(ugly_date, 2),
        (col == col_range[2] & row > 7) & !is.na(ugly_character) ~ paste0("00", ugly_character, ":00"),
        (col == col_range[2] & row > 7) & !is.na(numeric) ~ paste0("00:", numeric, ":00"),
        TRUE ~ ugly_character
      ),
      date = case_when(
        (col == col_range[1] & row > 7) & !is.na(ugly_date) ~ as.Date(ugly_date),
        (col == col_range[1] & row > 7) & !is.na(ugly_character) ~ as.Date(ugly_character, format = "%m-%d-%Y")
      ),
      numeric = case_when(
        (col == col_range[2] & row > 7) & !is.na(numeric) ~ NA_integer_,
        TRUE ~ as.integer(numeric)
      ),
      data_type = case_when(
        !is.na(date) ~ "date",
        !is.na(character) ~ "character",
        !is.na(numeric) ~ "numeric"
      )) %>% 
    select(-c(starts_with("ugly"))) %>% 
    nest(data = -c(sheet, exercise)) %>% 
    mutate(data = lapply(data, prepare_table, "up", col, row)) %>%
    unnest(cols = c(data)) %>% 
    janitor::remove_empty("cols")
}

player_tables <- raw_data %>% 
  filter(row %in% 1:4, col %in% 1:2) %>% 
  select(sheet, row, col, data_type, character, numeric) %>% 
  nest(data = -sheet) %>% 
  mutate(data = lapply(data, prepare_table, "left", row, col)) %>%
  unnest(cols = c(data))

clean_data <- lapply(list(1:3, 4:5), clean_exercise_data) %>% 
  bind_rows() %>% 
  left_join(player_tables, by = "sheet")
