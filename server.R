#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggplot2)


forbes <- read_csv("/Users/sophiamelenikiotis/Downloads/Forbes2000.csv")
forbes <- as.data.frame(forbes)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
   
  output$distPlot <- renderPlot({
  
    
    
    if (input$plotType == "barplot"){
      g <- ggplot(data = forbes, aes(x = category))
      g + geom_bar() + coord_flip()
    }
    
    else if (input$plotType == "scatter"){
      if ((input$dataset == "sales" && input$dataset2 == "profits") || (input$dataset == "profits" && input$dataset2 == "sales")){
        plot(forbes$sales, forbes$profits, main = "Scatterplot of Sales and Profit", xlab = "Sales", ylab = "Profit")
      } else if ((input$dataset == "sales" && input$dataset2 == "assets") || (input$dataset == "assets" && input$dataset2 == "sales")){
        plot(forbes$sales, forbes$assets, main = "Scatterplot of Sales and Assets", xlab = "Sales", ylab = "Assets")
      } else if ((input$dataset == "sales" && input$dataset2 == "marketvalue") || (input$dataset == "marketvalue" && input$dataset2 == "sales")){
        plot(forbes$sales, forbes$marketvalue, main = "Scatterplot of Sales and Marketvalue", xlab = "Sales", ylab = "Marketvalue")
      } else if ((input$dataset == "profits" && input$dataset2 == "assets") || (input$dataset == "assets" && input$dataset2 == "profits")){
        plot(forbes$profits, forbes$assets, main = "Scatterplot of Profits and Assets", xlab = "Profit", ylab = "Marketvalue")
      } else if ((input$dataset == "assets" && input$dataset2 == "marketvalue") || (input$dataset == "marketvalue" && input$dataset2 == "assets")){
        plot(forbes$assets, forbes$marketvalue, main = "Scatterplot Assets and Marketvalue", xlab = "Assets", ylab = "Marketvalue")
      }
      
     
      
    }
    
    #create raw data table
    
    
    
    
    
  })
  
})




