# Libraries needed to clean data and create plots used for the UCLA LibGuide 
# for Data Visualization. If not already installed, install then load library

packages <- c('dplyr', 'tidyr', 'ggplot2')
for (package in packages){
  if (!(package %in% installed.packages())){
    print(paste("Installing", package, "package..."))
    install.packages(package)
  }
  library(package, character.only = TRUE)
}

blues <- c("#8BB8E8", "#005587") # these are UCLA brand colors
yellow <- c("#FFB81C")


#can also use voter turnout @ '.../2018/2018-10-09/voter_turnout.csv'
prison_summary <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-01-22/prison_summary.csv') %>% filter(urbanicity == 'urban' & !(pop_category == 'Male' | pop_category == 'Female' | pop_category == 'Total'))

other_summary <- prison_summary %>% filter(pop_category != 'Black' | pop_category != 'White') %>% group_by(year) %>% summarize(rate_per_100000 = mean(rate_per_100000)) %>% mutate(pop_category = 'Other')

prison_summary <- prison_summary %>% filter(pop_category == 'Black' | pop_category == 'White') %>% select(-c(urbanicity))
prison_summary <- rbind(prison_summary, other_summary)

ggplot(prison_summary, aes(x = year, y = rate_per_100000, color = pop_category)) +
  geom_line()+  
  theme_classic()+
  scale_color_manual(values = c(blues, yellow)) +
  labs(title = "US Incarceration Trends in Urban Areas",
       x = "Year",
       y = "Incarcerated (per 100,000)",
       color = "Race") + 
  theme(title = element_text(size = 18),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16))
ggsave("lineplot.png", dpi = 72)
