library(magick)

reformat_image <- function(filepath, format = c("png", "jpg"), size = "800x") {
  format <- match.arg(format)
  
  image_read(filepath) |> 
    image_convert(format = format) |> 
    image_resize(size) |> 
    image_write(paste0(basename(filepath), ".", format))
}
