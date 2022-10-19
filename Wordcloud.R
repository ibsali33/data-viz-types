# Libraries needed to clean data and create plots used for the UCLA LibGuide 
# for Data Visualization. If not already installed, install then load library

packages <- c('glue', 'rvest', 'purrr', 'wordcloud', 'tm')
for (package in packages){
  if (!(package %in% installed.packages())){
    print(paste("Installing", package, "package..."))
    install.packages(package)
  }
  library(package, character.only = TRUE)
}

blues <- c("#8BB8E8", "#005587") # these are UCLA brand colors
#color gradient
colfunc <- colorRampPalette(blues)
blue_gradient <- colfunc(10)

#unique page ideas
page_ids <- c(9224439, 9224427, 9224430, 9224485)
urls <- glue("https://guides.library.ucla.edu/c.php?g=180624&p={page_ids}&preview=a2dacfd562be9abdc9eeaa82be97ad74")
# Define the worker function
scraper <- function(url) {
  data.frame(read_html(url) %>%
    html_text2() %>% 
    stringi::stri_extract_all_words(simplify = TRUE))
}

# Iterate over the urls, applying the function each time
text <- as.matrix(map_dfr(urls, scraper, .id = "page"))
#text


#get rid of jquery and lib words
for (word in c('jq', 'lib$')){
  text <- text[!grepl(paste0('^', word), text, ignore.case = TRUE)]
}

wordcloud(text, min.freq=12, random.order=FALSE, scale=c(7,1), colors=blue_gradient)
