## Local Manipulation For Reddit Posting
## Creates two seperate csv files, one for the top 20 demolitions, one for the top 20 exterminators

library(httr)
library(rdrop2)
library(dplyr)
library(data.table)
library(jsonlite)
library(shiny)
library(purrr)

token <- drop_auth(rdstoken = "token.rds")

#token <- drop_auth()
#saveRDS(token, file = "token.rds")
drop_download('/Apps/Demo Leaderboard/leaderboard.csv', overwrite = TRUE, dtoken = token)

leaderboard <- read.csv("./leaderboard.csv") 

leaderboard <- leaderboard[order(-leaderboard$Demos), ]

##Use Row Numbers of data to delete here
## intended to delete duplicate data that may sneak in
##leaderboard <- leaderboard[-c(21, 41, 50, 52), ]

leaderboard <- leaderboard[!duplicated(leaderboard$Username), ]

orderedDemos <- frank(-leaderboard$Demos, ties.method = "min")

orderedExterms <- frank(-leaderboard$Exterminations, ties.method = "min")

demoLeaderboard <- leaderboard %>% 
  mutate("Rank" = orderedDemos)

demoLeaderboard <- demoLeaderboard[,c(ncol(demoLeaderboard), 1:(ncol(demoLeaderboard) - 1))]

demoLeaderboard <- demoLeaderboard[1:20, ]

extermLeaderboard <- leaderboard %>% 
  mutate("Rank" = orderedExterms)

extermLeaderboard <- extermLeaderboard[,c(ncol(extermLeaderboard), 1:(ncol(extermLeaderboard) - 1))]

extermLeaderboard <- extermLeaderboard[order(-extermLeaderboard$Exterminations), ]

extermLeaderboard <- extermLeaderboard[1:20, ]

write.csv(leaderboard, "./leaderboard.csv", row.names = FALSE)

write.csv(extermLeaderboard, "./extermLeaderboard.csv", row.names = FALSE)

write.csv(demoLeaderboard, "./demoLeaderboard.csv", row.names = FALSE)