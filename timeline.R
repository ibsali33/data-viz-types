# Libraries needed to clean data and create plots used for the UCLA LibGuide 
# for Data Visualization. If not already installed, install then load library

packages <- c('dplyr', 'ggplot2', 'anytime', 'vistime')
for (package in packages){
  if (!(package %in% installed.packages())){
    print(paste("Installing", package, "package..."))
    install.packages(package)
  }
  library(package, character.only = TRUE)
}

blues <- c("#8BB8E8", "#005587") # these are UCLA brand colors

war_data <- readr::read_csv('https://gist.githubusercontent.com/emeeks/280cb0607c68faf30bb5/raw/1519767c148a9a2541e3a3c34c24d72fcd7bdace/wars.csv') %>% group_by(sphere) %>% arrange(sphere, start)
#format dates
war_data$start <- anydate(war_data$start)
war_data$end <- anydate(war_data$end)
#get only wars 5 years or more in length
war_data <- war_data %>% filter(difftime(end, start, units = 'weeks') >= 260)

spheres <- unique(war_data$sphere)
#color gradient for sphers
colfunc <- colorRampPalette(blues)
blue_gradient <- colfunc(length(spheres))
war_data <- war_data %>% mutate(color = blue_gradient[match(sphere, spheres)])

g <- gg_vistime(war_data, optimize_y = FALSE, col.event = 'name', col.group = 'sphere', linewidth = 10, show_labels = FALSE, title = 'Pre-1900s American Wars (5 Years or Longer)')
g +
  theme(title = element_text(size = 16), axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12)) +
  geom_text(aes(label=if_else(war_data$start < as.Date('1819-01-01'), war_data$name, NULL), x=as.POSIXct(war_data$end)), color='black', size=4.6, hjust=-0.05) +
  geom_text(aes(label=if_else(war_data$start > as.Date('1819-01-01') & war_data$name != 'United States Exploring Expedition', war_data$name, NULL), x=as.POSIXct(war_data$start)), color='black', size=4.6, hjust=1.08) +
  geom_text(aes(label=if_else(war_data$name == 'United States Exploring Expedition', war_data$name, NULL), x=as.POSIXct(war_data$start)), color='black', size=4.6, hjust=1.04)
