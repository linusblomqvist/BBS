library(shiny)
library(tidyverse)
library(ggpubr)
library(htmltools)
library(markdown)
library(plotly)
library(shinythemes)
source("create_data_and_fcn.R")

server <- function(input, output, session) {
  
  # Parse the query string to set the 'species' input on app load
  observe({
    query <- parseQueryString(session$clientData$url_search)  # Read the query string
    
    # Check if the 'species' parameter exists and matches a valid species
    if (!is.null(query$species) && query$species %in% bbs_df$common_name) {
      updateSelectInput(session, "species", selected = query$species)
    }
  })
  
  # Tab 1: Single-species display
  output$trendline <- renderPlot(
    single_species_plot_function(select_species = input$species,
                                 time_aggr = "week")
  )
  
  output$species_table <- DT::renderDataTable(
    DT::datatable(
      bbs_df %>%
        filter(common_name == input$species) %>%
        select(record_number, locality, observation_date, week, breeding_evidence), 
      options = list(pageLength = 10),
      colnames = c("Record no.", "Location", "Date", "Week", "Evidence type"),
      rownames = FALSE
    )
  )
  
  # Tab 2: Two-species comparison
  output$sp_comp_1 <- renderPlot({
    single_species_plot_function(select_species = input$sp_for_comp_1, time_aggr = "week")
  })
  
  output$sp_comp_2 <- renderPlot({
    single_species_plot_function(select_species = input$sp_for_comp_2, time_aggr = "week")
  })
  
  # Tab 3: Tree usage
  output$tree_plot <- renderPlot({
    tree_by_week_plot(select_tree = input$tree)
  })
}

# UI layout
ui <- navbarPage("Santa Barbara Breeding Bird Study Data Explorer", theme = shinytheme("flatly"),
                 
                 tags$head(includeHTML("google-analytics.Rhtml")),
                 
                 tabPanel(title = "Single-species display",
                          sidebarLayout(      
                            sidebarPanel(
                              selectInput("species", "Species:", 
                                          choices = unique(bbs_df$common_name),
                                          selected = sample(bbs_df$common_name, 1))
                            ),
                            mainPanel(
                              plotOutput("trendline"),
                              DT::dataTableOutput("species_table")
                            )
                          )
                 ),
                 
                 tabPanel(title = "Two-species comparison",
                          sidebarLayout(      
                            sidebarPanel(
                              selectInput("sp_for_comp_1", "Species 1:", 
                                          choices = unique(bbs_df$common_name),
                                          selected = sample(bbs_df$common_name, 1)),
                              hr(),
                              selectInput("sp_for_comp_2", "Species 2:", 
                                          choices = unique(bbs_df$common_name),
                                          selected = sample(bbs_df$common_name, 1))
                            ),
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
                                          selected = sample(unique(tree_by_week$tree_type), 1))
                            ),
                            mainPanel(
                              plotOutput("tree_plot")
                            )
                          )
                 ),
                 
                 tabPanel(title = "Methods",
                          htmltools::includeMarkdown("bbs_methods.md"))
)

shinyApp(ui = ui, server = server)
