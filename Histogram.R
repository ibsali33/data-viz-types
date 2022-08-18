# Libraries needed to clean data and create plots used for the UCLA LibGuide 
# for Data Visualization. If not already installed, use install.packages("library")
# then run the code below

library(dplyr)
library(tidyr)
library(palmerpenguins)
library(ggplot2)
library(RColorBrewer)

# view palmerpenguins data frame. the step below removes NA from 'sex' variable
# just a data cleaning step. using dplyr pipe commands and syntax

penguins <- penguins %>%
  filter(!is.na(sex))

pengfilt <- penguins %>%
  filter(island == "Biscoe")

blues <- c("#8BB8E8", "#005587") # these are UCLA brand colors

# histogram plot using ggplot. visualizing penguin body mass (in grams)
# viewing two species on Biscoe island (filter step above)
ggplot(pengfilt, aes(x = body_mass_g, fill = species)) +
  geom_histogram(binwidth = 50) +
  theme_classic()+
  scale_fill_manual(values = blues) +
  labs(title = "Body Mass for Penguins on Biscoe Island",
       x = "Penguin Body Mass (grams)",
       y = "Number of Penguins",
       fill = "Species")

# used ggsave to create png for webpage - dpi = 72 as resolution for the image seems to work fine
ggsave("histogram.png", dpi = 72)

# I thought it might be cool to pull from some tidy tuesday data sets. 
# the scatter plot looks at the relationship between acidity and flavor scores
# for coffee.

coffee_ratings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv')

# removes one value that has no ratings and makes the plot more difficult to interpret
# this plot might show
ratingscleaned <- coffee_ratings %>%
  filter(acidity != 0)

ggplot(ratingscleaned, aes(x = acidity, y = flavor, color = species)) +
  geom_point()+  
  theme_classic()+
  scale_color_manual(values = blues) +
  labs(title = "Coffee Flavor Score vs Acidity",
       x = "Acidity Score",
       y = "Flavor Score",
       color = "Coffee Species") + 
  theme(title = element_text(size = 18),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16))
  
ggsave("scatterplot.png", dpi = 72)


