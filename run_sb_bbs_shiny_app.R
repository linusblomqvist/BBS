# Publish app
setwd("/Users/linusblomqvist/Library/CloudStorage/Dropbox/Birding/BBS/sb_bbs")
library(rsconnect)
deployApp()

library(shiny)
source("server.R")
source("ui.R")
shinyApp(ui, server)
