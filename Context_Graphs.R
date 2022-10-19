# Libraries needed to clean data and create plots used for the UCLA LibGuide 
# for Data Visualization. If not already installed, install then load library

packages <- c('dplyr', 'ggplot2', 'RColorBrewer', 'scales')
for (package in packages){
  if (!(package %in% installed.packages())){
    print(paste("Installing", package, "package..."))
    install.packages(package)
  }
  library(package, character.only = TRUE)
}

blues <- c("#8BB8E8", "#005587") # these are UCLA brand colors
yellow <- c("#FFB81C")


#prevent scientific notation
options(scipen=6, digits=1)
#graph without context
covid_data <- readr::read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv')
ca_data <- covid_data %>% filter(state == 'California') %>% slice(which(row_number() %% 30 == 1))
ny_data <- covid_data %>% filter(state == 'New York') %>% slice(which(row_number() %% 30 == 1))
ny_data <- covid_data %>% filter(state == 'New York') %>% slice(which(row_number() %% 30 == 1))
wy_data <- covid_data %>% filter(state == 'Wyoming') %>% slice(which(row_number() %% 30 == 1))
ca_ny_wy_covid <- bind_rows(ca_data, ny_data, wy_data) %>% subset(date < "2022-01-01")

#ca_ny_wy_covid[order(as.Date(ca_ny_wy_covid$date, format="%Y-%d-%m")),]

ggplot(ca_ny_wy_covid, aes(x = date, y = cases, color = state)) +
  geom_line()+  
  theme_classic()+
  scale_color_manual(values = c(blues, yellow)) +
  labs(title = "Covid Cases 2020-2021",
       x = "Month",
       y = "COVID Cases",
       color = "State") + 
  theme(title = element_text(size = 18),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  scale_x_date(date_labels='%b %Y') +
  scale_y_continuous(labels = comma)
  
  
#graph with population context
population_data <-readr::read_csv('https://raw.githubusercontent.com/human-bootleg/covid_data_viz/main/PEPPOP2021.NST_EST2021_POP-2022-10-05T163656.csv')
population_data$pop_mean <- rowMeans(population_data[,-1])
#population_data

per_100000_covid_data <- ca_ny_wy_covid
for (s in c('California', 'New York', 'Wyoming')){
  per_100000_covid_data <- per_100000_covid_data %>% mutate(cases = if_else(state == s, cases*100000/pull(population_data[population_data$"Geographic Area Name (NAME)" == s, 'pop_mean']), cases))
}
#per_100000_covid_data[order(as.Date(ca_ny_wy_covid$date, format="%Y-%d-%m")),]

ggplot(per_100000_covid_data, aes(x = date, y = cases, color = state)) +
  geom_line()+  
  theme_classic()+
  scale_color_manual(values = c(blues, yellow)) +
  labs(title = "Covid Cases 2020-2021",
       x = "Month",
       y = "COVID Cases (per 100,000)",
       color = "State") + 
  theme(title = element_text(size = 18),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
        scale_x_date(date_labels='%b %Y') +
        scale_y_continuous(labels = comma) 
