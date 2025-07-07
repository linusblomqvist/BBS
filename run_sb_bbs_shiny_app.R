# Publish app
setwd("~/Documents/BBS/sb_bbs")
library(rsconnect)
deployApp()

library(shiny)
source("app.R")
shinyApp(ui, server)
