## Will connect to dropbox api to sync and share leaderboard

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

RV <- reactiveValues(data = leaderboard)

leaderboard <- read.csv("./leaderboard.csv") 
  
leaderboard <- leaderboard[order(-leaderboard$Demos),]

RV$leaderboard <- leaderboard[!duplicated(leaderboard$Username), ]

server <- function(input, output) {
  output$table <- renderDataTable(RV$leaderboard)
  observeEvent(input$refresh, {
    drop_download('/Apps/Demo Leaderboard/leaderboard.csv', overwrite = TRUE, dtoken = token)
    
    leaderboard <- read.csv("./leaderboard.csv") 
    
    leaderboard <- leaderboard[order(-leaderboard$Demos),] 
    
    RV$leaderboard <- leaderboard[!duplicated(leaderboard$Username), ]
  })
}

ui <-fluidPage(title="Demolitions Leaderboard", 
               mainPanel(p(actionButton("refresh", "Refresh")),
                         dataTableOutput("table")))

app <- shinyApp(ui, server)
