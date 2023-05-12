library(readxl)
library(tidyverse)
library(gridExtra)

setwd("/Users/abc/Desktop/論文3/Thesis/fig")

HRT_DebtDatabase <- read_excel("Desktop/論文3/DATA/Horn Reinhart Trebesch _ China's Overseas Lending _ Data and Replication Folder/HRT _ DebtDatabase.xlsx", 
                               sheet = "Data")

HRT_DebtDatabase %>% filter(Year == 2017) %>% select(Year, RecipientCountry,ExternalDebt_China)
Total.Debt.Data = HRT_DebtDatabase %>% 
  filter(Year == 2017) %>% 
  select(Year, RecipientCountry,ExternalDebt_China) %>% 
  drop_na() %>% 
  arrange( desc(ExternalDebt_China)) %>% 
  mutate(RecipientCountry = fct_reorder(RecipientCountry, ExternalDebt_China))

Total.Plot = Total.Debt.Data %>% top_n(30) %>% ggplot(aes(x = RecipientCountry, y = ExternalDebt_China)) +
    geom_bar(stat="identity", alpha=.6, width=.4) +
    coord_flip() +
    ylab("Billions of USD") +
    xlab("Country") +
    theme_bw()+
    theme(text = element_text(size = 10, family = "serif"))+
    scale_y_continuous(labels = unit_format(unit = "B", scale = 1e-9))

Perc.Debt.Data <- read_excel("Desktop/論文3/DATA/Horn Reinhart Trebesch _ China's Overseas Lending _ Data and Replication Folder/HRT _ DebtDatabase.xlsx", 
                               sheet = "Figure6")

Perc.Debt.Data  = Perc.Debt.Data %>% 
  select(DebtorCountry, ExtDebt_China_GDP) %>% 
  arrange( desc(ExtDebt_China_GDP)) %>% 
  mutate(DebtorCountry = fct_reorder(DebtorCountry, ExtDebt_China_GDP))

Perc.Plot = Perc.Debt.Data %>% top_n(30) %>% ggplot(aes(x = DebtorCountry, y = ExtDebt_China_GDP)) +
  geom_bar(stat="identity", alpha=.6, width=.4) +
  coord_flip() +
  ylab("Percent of GDP") +
  xlab("") +
  theme_bw()+
  theme(text = element_text(size = 10, family = "serif"))+
  scale_y_continuous(labels = percent_format(scale = 1))
  
ggsave("total_debt.pdf", Total.plot, width=3, height = 5)
ggsave("perc_debt.pdf", Perc.Plot, width=3, height = 5)
