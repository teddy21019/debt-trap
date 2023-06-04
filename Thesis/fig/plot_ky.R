setwd("/Users/abc/Desktop/論文3/Thesis/fig")

library(readr)
zarazaga_plot_data <- read_csv("~/Desktop/論文3/DATA/Zarazaga/zarazaga_plot_data.csv")
View(zarazaga_plot_data)

library(tidyverse)

sri_lanka_plt = zarazaga_plot_data %>% 
  filter(Country == 'LKA') %>% 
  ggplot() +
  geom_line(aes(x=Year, y=KY))+
  geom_vline(xintercept=c(2005, 2012, 2017), linetype="dashed") +
  ylab("Capital-output ratio") +
  xlab("Year") +
  theme_bw()+
  theme(text = element_text(size = 10, family = "serif"))+
  theme(legend.position="bottom",
        legend.margin = margin(t = -0.5, unit = "cm"))

pakistan_plt = zarazaga_plot_data %>% 
  filter(Country == 'PAK') %>% 
  ggplot() +
  geom_line(aes(x=Year, y=KY))+
  geom_vline(xintercept= 1999, linetype="dashed") +
  ylab("Capital-output ratio") +
  xlab("Year") +
  theme_bw()+
  theme(text = element_text(size = 10, family = "serif")) +
  theme(legend.position="bottom",
        legend.margin = margin(t = -0.5, unit = "cm"))

sri_lanka_plt

pakistan_plt

ggsave('sri_lanka_output_loss.pdf', sri_lanka_plt, width = 4, height = 3)
ggsave('pakistan_output_loss.pdf', pakistan_plt, width = 4, height = 3)
