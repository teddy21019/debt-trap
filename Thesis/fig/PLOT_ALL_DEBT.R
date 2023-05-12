library(readxl)
library(tidyverse)
library(gridExtra)
library(reshape2)

setwd("/Users/abc/Desktop/論文3/Thesis/fig")

HRT_DebtDatabase <- read_excel("~/Desktop/論文3/DATA/Horn Reinhart Trebesch _ China's Overseas Lending _ Data and Replication Folder/HRT _ DebtDatabase.xlsx", 
                               sheet = "Data")

countries = unique(HRT_DebtDatabase$RecipientCountry)

for (country in countries){
  print(country)
  Country.Data = HRT_DebtDatabase %>% 
    filter(RecipientCountry == country, Year > 2000) %>% 
    mutate(PPGDebt_WB = PPGDebt_IBRD + PPGDebt_IDA) %>% 
    select(Year, ExternalDebt_China, PPGDebt_IMF, PPGDebt_WB , PPGDebt_ParisClub)
  
  Country.Plot = Country.Data %>% 
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
        scale_y_continuous(labels = unit_format(unit = "", scale = 1e-9)) +
    scale_shape_manual(values = c(19, 17, 15, 16),
                       labels = c("Debt to China", "Debt to World Bank", "Debt to IMF", "Debt to Paris Club")) +
    scale_linetype_manual(values = c("solid", "dashed", "dashed", "dashed"),
                          labels = c("Debt to China", "Debt to World Bank", "Debt to IMF", "Debt to Paris Club")) +
      guides(shape = guide_legend(nrow =2))


    ggsave(paste("ALL/",country, "_debt_source.pdf", sep = ""), Country.Plot, width=5, height = 3)
}
                