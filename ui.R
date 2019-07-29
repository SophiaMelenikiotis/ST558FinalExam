#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(fluidPage(
  
  # Application title
  titlePanel("Industries around the world"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("plotType", "Plot Type", c(Barplot = "barplot", Scatter = "scatter")), 
      selectInput("dataset", "Choose first variable: ",
                  choices = c("sales", "profits", "assets", "marketvalue")),
      
      selectInput("dataset2", "Choose second variable: ",
                  choices = c("sales", "profits", "assets", "marketvalue"))
      
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
