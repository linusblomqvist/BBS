library(shiny)
library(tidyverse)
source("create_data_and_fcn.R")

# Define a server for the Shiny app
server <- function(input, output) {
  # Fill in the spot we created for a plot
  output$trendline <- renderPlot({
    # Render a line plot
    single_species_plot_function(select_species = input$species,
                                 time_aggr = input$time_aggr)
  })
  
  output$species_table <- DT::renderDataTable(
    DT::datatable(bbs_df %>%
                    filter(common_name == input$species) %>%
                    select(common_name, locality, observation_date, breeding_evidence), 
                  options = list(pageLength = 10),
                  colnames = c("Species", "Location", "Date", "Evidence type"),
                  rownames = FALSE)
  )
}

# Use a fluid Bootstrap layout
ui <- fluidPage(    
  
  tags$head(includeHTML("google-analytics.Rhtml")),
  
  # Give the page a title
  titlePanel("Santa Barbara Breeding Bird Study"),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("species", "Species:", 
                  choices=unique(bbs_df$common_name),
                  selected = sample(bbs_df$common_name, 1)),
      hr(),
      selectInput("time_aggr", "By week or month:",
                  choices = c("week", "month"),
                  selected = "week")
      # selectInput("evidence", "Breeding evidence:",
      #             choices = breeding_evidence,
      #             multiple = TRUE,
      #             selected = breeding_evidence)
      #helpText("Data from the National Audubon Society, with adjustments to account for changing taxonomy, erroneous records, and the like. Web app by Linus Blomqvist. ")
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("trendline"),
      DT::dataTableOutput("species_table"),
      HTML("<br>"),
      HTML("<br><p>For more information, see <a href = https://santabarbaraaudubon.org/santa-barbara-county-breeding-bird-study/>https://santabarbaraaudubon.org/santa-barbara-county-breeding-bird-study</a>. Web app by Linus Blomqvist.<p>")
    )
    
  )
)

shinyApp(ui = ui, server = server)
