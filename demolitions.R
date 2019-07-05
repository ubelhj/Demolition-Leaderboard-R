## Will connect to dropbox api to sync and share leaderboard

library(httr)
library(rdrop2)
library(dplyr)
library(data.table)
library(jsonlite)
library(shiny)
library(purrr)

drop_auth()
drop_download('/Apps/Demo Leaderboard/leaderboard.csv', overwrite = TRUE)

leaderboard <- read.csv("./leaderboard.csv") 
  
leaderboard <- leaderboard[order(-leaderboard$Demos),] %>% 
  unique()
