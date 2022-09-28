# Required packages - uncomment to run

#install.packages(c("httr", "jsonlite", "rvest"))
#devtools::install_github("jsta/wayback")
#devtools::install_github("hrbrmstr/wayback")

library(wayback)
library(tidyverse)

websites <- read.csv("./domains/bhc_domains.csv", header = TRUE)

for (i in 1:length(websites[,1])){
  
  arch_avlb <- archive_available(websites$website[i])
  
  if (arch_avlb$available == "TRUE") {
    
    mementos <- get_mementos(websites$domain[i])
    if(length(mementos) == 0) { next }  
    timemap <- get_timemap(mementos$link[2])
    
    write.csv(timemap, paste(websites$cb_name[i], ".csv"))
    
  } else {
    cat(i)
  }
}
