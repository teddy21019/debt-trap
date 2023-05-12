library(readxl)
library(tidyverse)
library(gridExtra)
library(reshape2)
library(scales)

setwd("/Users/abc/Desktop/論文3/Thesis/fig")
#setwd("C:/Users/tedb0/Documents/debt-trap/Thesis/fig")

Debt.Comparison.International <- read_excel("../../DATA/Horn Reinhart Trebesch _ China's Overseas Lending _ Data and Replication Folder/HRT _ DebtDatabase.xlsx", 
                               sheet = "Figure9", 
                               skip = 1,
                               col_names = c("Year","Debt to China", "Debt to Paris Club",
                                             "Debt to IMF", "Debt to World Bank"))

PLT = Debt.Comparison.International %>% 
  select("Year","Debt to China", 
         "Debt to World Bank", "Debt to IMF", "Debt to Paris Club") %>% 
  melt(id.vars = 'Year', variable.name = 'Creditor') %>% 
  ggplot(aes(x = Year, y= value)) +
  geom_point(aes(shape = Creditor)) + 
  geom_line(aes(linetype= Creditor)) +
  ylab("Billions of USD") +
  xlab("Year") +
  theme_bw()+
  theme(text = element_text(size = 10, family = "serif"))+
  theme(legend.position="bottom",
        legend.margin = margin(t = -0.5, unit = "cm")) +
  scale_y_continuous(labels = unit_format(unit = "", scale = 1e-9))+
  guides(shape = guide_legend(nrow =2))


ggsave("aggr_debt_source.pdf", PLT, width=4, height = 3)
