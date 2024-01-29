library(shiny)

source("create_data_and_fcn.R")

# Define a server for the Shiny app
server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$trendline <- renderPlot({
    
    # Render a line plot
    single_species_plot_function(species = input$species, 
                                 breeding_evidence = breeding_evidence,
                                 time_aggr = "Month",
                                 time_key = month_key)
  })
}
