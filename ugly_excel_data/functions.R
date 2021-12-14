# Filter based on either of two column numbers supplied to get activity data, select standard fields
find_activity_stat <- function(col1, col2) {
  raw_data %>% 
    filter((col == {{col1}} | col == {{col2}}) & row > 7) %>% 
    select(sheet, c(row:col), c(numeric:character))
}

# Filter based on either of two column numbers supplied to get player data, select standard fields
find_player_stat <- function(row, stat_name) {
  raw_data %>% 
    filter(row == {{row}} & col == 2) %>% 
    select(sheet, {{stat_name}} := numeric)
}
