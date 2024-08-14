library(shiny)

source("../generate_gwas_data.R")
source("../manhattan_plot.R")

# UI
ui <- fluidPage(
  titlePanel("Manhattan Plot"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n_points", "Number of Points:", min = 500000, max = 3000000, value = 500000, step = 500000)
    ),
    mainPanel(
      plotOutput("manhattanPlot", width = 600, height = 400)
    )
  )
)

# Server
server <- function(input, output, session) {
  data <- reactive({
    generate_gwas_data(input$n_points)
  })

  output$manhattanPlot <- renderPlot({
    create_manhattan_plot(data())
  })
}

# Run the app
shinyApp(ui = ui, server = server)
