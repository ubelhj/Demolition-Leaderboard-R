## Will connect to dropbox api to sync and share leaderboard

library(httr)
library(rdrop2)
library(dplyr)
library(data.table)
library(jsonlite)
library(shiny)
library(purrr)


##drop_auth(new_user = T)
##token <- drop_auth()
##saveRDS(token, file = "token.rds")

token <- drop_auth(rdstoken = "token.rds")

drop_download('/Apps/Demo Leaderboard/leaderboard.csv', overwrite = TRUE, dtoken = token)


RV <- reactiveValues()

loadLeaderboard <- function() {

  leaderboard <- read.csv("./leaderboard.csv", fileEncoding="UTF-8-BOM") 
  
  leaderboard <- leaderboard[order(-row_number(leaderboard)), ]
  
  leaderboard <- leaderboard[!duplicated(leaderboard[1]), ]
  
  leaderboard <- leaderboard[order(-leaderboard$Demos), ]
  
  orderedDemos <- frank(-leaderboard$Demos, ties.method = "min")
  
  orderedExterms <- frank(-leaderboard$Exterminations, ties.method = "min")
  
  leaderboard <- leaderboard %>% 
    mutate("Demolitions Rank" = orderedDemos)
  
  leaderboard <- leaderboard %>% 
    mutate("Exterminations Rank" = orderedExterms)
  
  leaderboard <- leaderboard[ ,c(1, 4, 2, 5, 3)]

  return(leaderboard)
}


## Webserver Manipulation

RV$leaderboard <- loadLeaderboard()

server <- function(input, output) {
  output$table <- renderDataTable(RV$leaderboard)
  observeEvent(input$refresh, {
    drop_download('/Apps/Demo Leaderboard/leaderboard.csv', overwrite = TRUE, dtoken = token)
    
    RV$leaderboard <- loadLeaderboard()
  })
}

ui <-fluidPage(title="Demolitions Leaderboard", 
               mainPanel(p(actionButton("refresh", "Refresh")),
                         dataTableOutput("table")))

app <- shinyApp(ui, server)
