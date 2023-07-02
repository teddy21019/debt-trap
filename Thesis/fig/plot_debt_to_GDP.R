library(tidyverse)
library(readxl)

setwd("C:/Users/tedb0/Documents/debt-trap/Thesis/fig")

DebtData <- read_excel("C:/Users/tedb0/Documents/debt-trap/DATA/ModelData.xlsx", 
                       sheet = "Adjusted Debt")
plot_data = DebtData %>% select(year, lka_with_china, lka_gdp_trade) %>% 
  mutate(lka_with_china = lka_with_china/1e9,
         lka_gdp_trade = lka_gdp_trade/ 1e9,
         ratio = lka_with_china/lka_gdp_trade)

ratio_scale <- max(plot_data$lka_gdp_trade) / max(plot_data$ratio) * 2

pd = plot_data %>% ggplot(aes(x = year)) +
  geom_line(aes(y = lka_with_china, linetype = "Debt"), color = "black", size = 1) +
  geom_line(aes(y = lka_gdp_trade, linetype = "Tradable GDP"), color = "gray", size = 1) +
  geom_line(aes(y = ratio * ratio_scale, linetype = "Ratio"), color = "black", size = 1, linetype = "dotdash") +
  scale_linetype_manual(values = c("Debt" = "solid", "Tradable GDP" = "solid", "Ratio" = "dotdash")) +
  theme_bw() +
  theme(text = element_text(size = 15, family = "serif"))+
  labs(x = "Year", y = "Billion USD", linetype = "") +
  scale_y_continuous(sec.axis = sec_axis(~./ratio_scale, name = "Ratio")) +
  scale_x_continuous(breaks = plot_data$year, labels = as.character(plot_data$year)) +  # Specify integer values on x-axis
  theme(legend.position = "bottom")+
  guides(linetype = guide_legend(override.aes = list(color = c("black", "gray", "black"))))
  
ggsave("sri_lanka_debt_gdp.pdf", pd, width=6, height = 3)



plot_data = DebtData %>% select(year, pak_with_china, pak_gdp_trade) %>% 
  mutate(pak_with_china = pak_with_china/1e9,
         pak_gdp_trade = pak_gdp_trade/ 1e9,
         ratio = pak_with_china/pak_gdp_trade)

ratio_scale <- max(plot_data$pak_gdp_trade) / max(plot_data$ratio) * 1

pd = plot_data %>% ggplot(aes(x = year)) +
  geom_line(aes(y = pak_with_china, linetype = "Debt"), color = "black", size = 1) +
  geom_line(aes(y = pak_gdp_trade, linetype = "Tradable GDP"), color = "gray", size = 1) +
  geom_line(aes(y = ratio * ratio_scale, linetype = "Ratio"), color = "black", size = 1, linetype = "dotdash") +
  scale_linetype_manual(values = c("Debt" = "solid", "Tradable GDP" = "solid", "Ratio" = "dotdash")) +
  theme_bw() +
  theme(text = element_text(size = 15, family = "serif"))+
  labs(x = "Year", y = "Billion USD", linetype = "") +
  scale_y_continuous(sec.axis = sec_axis(~./ratio_scale, name = "Ratio")) +
  scale_x_continuous(breaks = plot_data$year, labels = as.character(plot_data$year)) +  # Specify integer values on x-axis
  theme(legend.position = "bottom")+
  guides(linetype = guide_legend(override.aes = list(color = c("black", "gray", "black"))))

ggsave("pak_debt_gdp.pdf", pd, width=6, height = 3)

