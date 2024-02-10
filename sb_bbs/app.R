library(shiny)
library(tidyverse)
library(ggpubr)
library(htmltools)
library(markdown)
source("create_data_and_fcn.R")

# Define a server for the Shiny app
server <- function(input, output) {
  # Fill in the spot we created for a plot
  output$trendline <- renderPlot(
    # Render a line plot
    single_species_plot_function(select_species = input$species,
                                 time_aggr = "week")
  )
  
  output$species_table <- DT::renderDataTable(
    DT::datatable(bbs_df %>%
                    filter(common_name == input$species) %>%
                    select(locality, observation_date, day_of_year, breeding_evidence), 
                  options = list(pageLength = 10),
                  colnames = c("Location", "Date", "Day of year", "Evidence type"),
                  rownames = FALSE)
  )
  
  comp_plot_1 <- reactive({
    single_species_plot_function(select_species = input$sp_for_comp_1,
                                              time_aggr = "week")
  })
  
  comp_plot_2 <- reactive({
    single_species_plot_function(select_species = input$sp_for_comp_2,
                                              time_aggr = "week")
  })
  
  output$sp_comp_1 <- renderPlot(
    ggarrange(comp_plot_1(), comp_plot_2(), ncol = 1, nrow = 2, common.legend = TRUE, legend = "bottom"),
    width = "auto",
    height = 700
  )

  output$tree_plot <- renderPlot(
    tree_by_week_plot(input$tree)
  )
  
}

# Use a fluid Bootstrap layout
ui <- navbarPage("Santa Barbara Breeding Bird Study", theme = shinytheme("flatly"),
                 
                 tags$head(includeHTML("google-analytics.Rhtml")),

  tabPanel(title = "Single-species display",
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("species", "Species:", 
                  choices=unique(bbs_df$common_name),
                  selected = sample(bbs_df$common_name, 1))
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("trendline"),
      DT::dataTableOutput("species_table"))
    
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
         ),

tabPanel(title = "Tree usage",
         sidebarLayout(
           sidebarPanel(
             selectInput("tree", "Tree type:",
                         choices = unique(tree_by_week$tree_type),
                         selected = sample(unique(tree_by_week$tree_type)))
           ),
           mainPanel(
             plotOutput("tree_plot"))
           )
         ),

tabPanel(title = "Methods",
         htmltools::includeMarkdown("bbs_methods.md"))
)

shinyApp(ui = ui, server = server)
