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
  
  output$sp_comp_1 <- renderPlot({
    # Render a line plot
    single_species_plot_function(select_species = input$sp_for_comp_1,
                                 time_aggr = "week") +
      theme(legend.position = "none")
  })
  
  output$sp_comp_2 <- renderPlot({
    # Render a line plot
    single_species_plot_function(select_species = input$sp_for_comp_2,
                                 time_aggr = "week")
  })
  
}

# Use a fluid Bootstrap layout
ui <- navbarPage("Santa Barbara Breeding Bird Study", theme = shinytheme("flatly"),

  tabPanel(title = "Single species display",
  
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
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("trendline"),
      DT::dataTableOutput("species_table"),
      HTML("<br>"),
      HTML("<br><p>For more information, see <a href = https://santabarbaraaudubon.org/santa-barbara-county-breeding-bird-study/>https://santabarbaraaudubon.org/santa-barbara-county-breeding-bird-study</a>. Web app by Linus Blomqvist.<p>")
    )
    
  )
),
tabPanel(title = "Two-species comparison",
         sidebarLayout(      
           
           # Define the sidebar with one input
           sidebarPanel(
             selectInput("sp_for_comp_1", "Species 1:", 
                         choices=unique(bbs_df$common_name),
                         selected = sample(bbs_df$common_name, 1)),
           hr(),
           selectInput("sp_for_comp_2", "Species 2:", 
                       choices=unique(bbs_df$common_name),
                       selected = sample(bbs_df$common_name, 1))),
           # Create a spot for the barplot
           mainPanel(
             plotOutput("sp_comp_1"),
             plotOutput("sp_comp_2")
           )
         )
         )
)

shinyApp(ui = ui, server = server)
