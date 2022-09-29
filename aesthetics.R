#install.packages('imagefluency')
require(imagefluency)

screens.path <- setwd("~")
screens.path.files <- list.files(screens.path, recursive = TRUE)

for (j in 1:length(screens.path.files)){
  image.info <- data.frame()
  screens.path.files <- list.dirs(getwd(), recursive = FALSE)
  folder <- list.files(screens.path.files[j])
  setwd(screens.path.files[j])
  
  for (i in 1:length(folder)){
    print(getwd())
    image <- img_read(folder[i])
    complexity <- img_complexity(image)
    symmetry <- img_symmetry(image , horizontal = FALSE)
    self_sim <- img_self_similarity(image)
    contrast <- img_contrast(image)
    scores <- cbind(complexity, symmetry, self_sim, contrast)
    image.info <- rbind(image.info, scores)
  }
  
  write.csv(image.info, paste0("./output/image_scores/", j, ".csv"))
}

