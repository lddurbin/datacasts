library(magick)

reformat_image <- function(filepath, format = c("png", "jpg"), size = "800x") {
  format <- match.arg(format)
  
  filename <- basename(filepath)
  filename_no_ext <- substr(filename, 1, nchar(filename)-4)
  
  image_read(filepath) |> 
    image_resize(size) |> 
    image_write(paste0(filename_no_ext, format))
}