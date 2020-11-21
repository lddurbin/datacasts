install.packages("tidyverse")
library("tidyverse")

target_urls <- c("https://www.bl.uk/britishlibrary/~/media/bl/global/services/collection%20metadata/pdfs/bnb%20records%20rdf/bnbrdf_n3618.zip?la=en&hash=AA432EC232641BA593846EB29440A29F", "https://www.bl.uk/britishlibrary/~/media/bl/global/services/collection%20metadata/pdfs/bnb%20records%20rdf/bnbrdf_n3619.zip?la=en&hash=425EF29835CA284A9F7C980BF443E4E8", "https://www.bl.uk/britishlibrary/~/media/bl/global/services/collection%20metadata/pdfs/bnb%20records%20rdf/bnbrdf_n3620.zip?la=en&hash=DC5A0A827772208859EAFF59B8FB3128")
target_files <- basename(target_urls) %>% str_replace("(?<=.zip).*$","")
download.file(target_urls, destfile = target_files, method = "libcurl")
