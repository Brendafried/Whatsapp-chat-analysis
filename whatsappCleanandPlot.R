library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(scales)

chat <- read.csv('chatd.txt',row.names = NULL, quote = "", stringsAsFactors = FALSE, strip.white = TRUE)
chat <- chat[-2, ]
colnames(chat) <- c('date', 'time', 'member','text')
data <- chat %>% mutate(member = case_when(
    (member == "Totty") ~ "Dad",
    TRUE ~ member
    ))
data <- data %>%
  group_by(member) %>%
  summarise(count = n()) %>%
  mutate(total = sum(count))
#compute position of labels
data <- data %>% 
  arrange(desc(member)) %>%
  mutate(prop = count / sum(count)) %>%
  mutate(ypos = cumsum(prop)- 0.5*prop ) %>%
  mutate(label = percent(prop))


data %>%
  ggplot(aes(x="", y = prop, fill = member))+
    geom_bar(width = 1, stat = "identity", color="white")+
    coord_polar("y", start=0) + 
    theme_void() +
    geom_text(aes(y = ypos, label = label), color = "black", size=4) +
    scale_fill_brewer(palette="Pastel1") +
    ggtitle("Not Fried o lays Whatsapp usage \nfrom March 30th - November 19") +
      theme(plot.title = element_text(lineheight=1.2, face="bold", hjust = 0.5))

grep("<Media omitted>", chat$text, value = TRUE)

media_data <- chat %>% 
  mutate(media = case_when(
    (text == "<Media omitted>") ~ 1,
    (TRUE ~ 0)
  )) %>%
  mutate(media = as.factor(media)) %>%
  group_by(media, member) %>%
  summarise(count = n()) %>% 
  filter(media == 1)

media_data %>% ggplot(aes(x = media, y=count, fill = member)) +
  geom_bar(stat="identity",position="dodge")+
  theme_classic() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  ggtitle("How many images each member sent") +
  theme(plot.title = element_text(lineheight=1.2, face="bold", hjust = 0.5))
  