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
      hr()#,
      #helpText("Data from the National Audubon Society, with adjustments to account for changing taxonomy, erroneous records, and the like. Web app by Linus Blomqvist. ")
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("trendline")#,
      #p("text")
    )
    
  )
)
