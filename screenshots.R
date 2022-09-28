# required packages

library(xml2)
library(rvest)
library(xsitemap)
library(webshot)
library(imagefluency)
library(magick)
library(Rcrawler)
library(png)
library(dplyr)

setwd("./domains")
domains.files <- list.files(domains.path)

for (j in 1:length(domains.files)){
  
  domains <- read.csv(domains.files[j])
  dlength <- length(domains[,1])
  domains <- domains[5:dlength,]
  
  # dates -- convert to monthly frequency
  domains$date <- substr(domains$datetime, 6, 16)
  domains$date <- as.Date(domains$date,"%d %B %Y")
  domains$date.monthly <- format(domains$date, "%m/%Y")
  
  df <- domains %>% 
    group_by(date.monthly) %>%
    slice(which.max(date))
  
  df$date.monthly <- gsub("/", "_", df$date.monthly)
  write.csv(df, paste0(domains.path, "/", "reduced/", j, ".csv"))
  
  setwd('..')
  screenshots.path <- c("./screenshots")
  setwd(screenshots.path)
  
  folder_name <- gsub(" .csv", "", domains.files[j])
  dir.create(folder_name)
  setwd(paste0(screenshots.path, "/", folder_name))
  
  
  start_time <- Sys.time()
  start_time
  for (i in 1:nrow(df)){ 
    
    setwd(paste0(screenshots.path, "/", folder_name))
    
    skip_to_next <- FALSE
    url <- df[i,3]
    url <- as.character(url)
    
    tryCatch(webshot(url, delay = 5, paste0(df$date.monthly[i], ".png"), zoom = 2), error = function(e) { skip_to_next <<- TRUE})
    if(skip_to_next) { next } 
    
  }
  
  end_time <- Sys.time()
  print(end_time - start_time)
  setwd('..')
  domains.path <- c("./domains")
  setwd(domains.path)
}



