source("demolitions.R")

server <- function(input, output) {
  output$table <- renderDataTable(leaderboard)
}

shinyServer(server)
