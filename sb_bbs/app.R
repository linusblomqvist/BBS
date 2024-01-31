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

# Use a fluid Bootstrap layout
ui <- fluidPage(    
  
  # Give the page a title
  titlePanel("Observations of breeding evidence by species"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("species", "Species:", 
                  choices=unique(bbs_df$Common.Name)),
      hr(),
      selectInput("evidence", "Breeding evidence:",
                  choices = breeding_evidence,
                  multiple = TRUE,
                  selected = breeding_evidence)
      #helpText("Data from the National Audubon Society, with adjustments to account for changing taxonomy, erroneous records, and the like. Web app by Linus Blomqvist. ")
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("trendline")#,
      #p("text")
    )
    
  )
)

shinyApp(ui = ui, server = server)
