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


tuition_cost <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-10/tuition_cost.csv')
salary_potential <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-10/salary_potential.csv')

cost_and_pay <- inner_join(tuition_cost, salary_potential, by = 'name') %>% select('name','in_state_tuition', 'out_of_state_tuition', 'early_career_pay':'make_world_better_percent') %>% gather(career_point, potential_salary, early_career_pay, mid_career_pay)

ggplot(cost_and_pay, aes(x = in_state_tuition, y = potential_salary, color = career_point)) +
  geom_point()+  
  theme_classic()+
  scale_color_manual(values = blues) +
  labs(title = "In State Tuition Cost vs Potential Salary",
       x = "In State Tuition Cost",
       y = "Potential Salary",
       color = "Career Point") + 
  theme(title = element_text(size = 18),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16))
