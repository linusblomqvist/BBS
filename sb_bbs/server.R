library(shiny)
library(tidyverse)
load("objects.Rdata")

# Define a server for the Shiny app
server <- function(input, output) {
  # Fill in the spot we created for a plot
  output$trendline <- renderPlot({
    # Render a line plot
    single_species_plot_function(select_species = input$species, 
                                 select_breeding_evidence = input$evidence,
                                 time_aggr = "Month",
                                 time_key = month_key)
  })
}
