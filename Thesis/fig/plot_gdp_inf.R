library(tidyverse)
library(readxl)

setwd("C:/Users/tedb0/Documents/debt-trap/Thesis/fig")

DebtData <- read_excel("C:/Users/tedb0/Documents/debt-trap/DATA/ModelData.xlsx", 
                       sheet = "GDP")

gdp_inflation = DebtData %>% select(year,code, r_gdp, inflation) %>% filter(year >= 1980)

sri_lanka_data = gdp_inflation %>% filter(code == 'LKA') %>% mutate(gdp_growth = (r_gdp - lag(r_gdp))/r_gdp * 100)
pak_lanka_data = gdp_inflation %>% filter(code == 'PAK') %>% mutate(gdp_growth = (r_gdp - lag(r_gdp))/r_gdp * 100)

# Create the plot
plot_sri <- ggplot(data = sri_lanka_data) +
  geom_bar(aes(x = year, y = gdp_growth, fill = "Real GDP Growth"), stat = "identity", width = 0.8) +
  geom_line(aes(x = year, y = inflation / 2, color = "Inflation"), size = 1, linetype = "solid") +
  scale_fill_manual(values = "gray", guide = guide_legend(reverse = TRUE)) +
  scale_color_manual(values = "black") +
  scale_y_continuous(name = "Real GDP Growth (%)", sec.axis = sec_axis(~.*2, name = "Inflation Rate (%)")) +
  theme_bw() +
  theme(text = element_text(size = 15, family = "serif"))+
  labs(x = "Year") +
  theme(legend.key=element_blank(), legend.title=element_blank(), legend.box="horizontal",legend.position = "bottom")


# Display the plot
ggsave("sri_lanka_gdp_infl.pdf", plot_sri, width=6, height = 4)

#  Pakistan
plot_pak <- ggplot(data = pak_lanka_data) +
  geom_bar(aes(x = year, y = gdp_growth, fill = "Real GDP Growth"), stat = "identity", width = 0.8) +
  geom_line(aes(x = year, y = inflation / 2, color = "Inflation"), size = 1, linetype = "solid") +
  scale_fill_manual(values = "gray", guide = guide_legend(reverse = TRUE)) +
  scale_color_manual(values = "black") +
  scale_y_continuous(name = "Real GDP Growth (%)", sec.axis = sec_axis(~.*2, name = "Inflation Rate (%)")) +
  theme_bw() +
  theme(text = element_text(size = 15, family = "serif"))+
  labs(x = "Year") +
  theme(legend.key=element_blank(), legend.title=element_blank(), legend.box="horizontal",legend.position = "bottom")


# Display the plot

ggsave("pak_gdp_infl.pdf", plot_pak, width=6, height = 4)


