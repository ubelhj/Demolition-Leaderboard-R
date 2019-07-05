source("demolitions.R")

ui <-fluidPage(title="Demolitions Leaderboard", 
               mainPanel(dataTableOutput("table")))

shinyUI(ui)
