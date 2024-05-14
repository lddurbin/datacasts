data_dir <- here::here("20240523_whatsapp/data")
zip_file <- fs::dir_ls(data_dir, glob = "*.zip")

unzip(zip_file, exdir = data_dir)