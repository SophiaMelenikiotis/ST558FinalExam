#this read in the libraries
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)
library(knitr)
library(ape)

#this read in the datafile and has it as a dataframe
forbes <- read_csv("Forbes2000.csv")
forbes <- as.data.frame(forbes)



#user interface
ui <- dashboardPage(
  #Title of dashboard is Forbes 2000 Analysis
  dashboardHeader(title = "Forbes 2000 Analysis"),
  #These are the different tabs of the dashboard
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Numerical Summaries", tabName = "Graph", icon = icon("th")),
      menuItem("Categorical Summaries", tabName = "Graph2", icon = icon("th")),
      menuItem(" Linear Modeling", tabName = "Linear_Model", icon = icon("th")),
      menuItem("Tree Modeling", tabName = "Tree_Model", icon = icon("th")),
      menuItem("Clustering", tabName = "Cluster", icon = icon("th")),
      menuItem("Raw Data", tabName = "Raw", icon = icon("th"))
      
    )
  ),
  dashboardBody(
    #This is the first tab: Introduction. It goes to explain what each tab does. 
    tabItems(
      tabItem(tabName = "dashboard",
              h1("About the Data", style = "color: black; font-weight: bold"),
              h2("This data came from the forbes 2000 database. It looks at companies from around the world and compares their profits, sales, assets, and marketvalue. The link at the bottom shows you more information about each variable. Each tab allows you to download the plots and data tables to png or csv."),
              tabsetPanel(
                tabPanel("Numerical Summaries",
                         h4("This tab has two main options. The first is a scatterplot that looks at correlations of each specified variables. We also see a regression line running through the points. The second options is a histogram that looks at the distribution of of each specified variable.")),
                tabPanel("Categorical Summaries",
                         h4("This tab is a barplot that shows the distribution of each company category in the forbes data set.")),
                tabPanel("Linear Modeling",
                         h4("This tab performs linear regression on the dataset. It allows the user to choose one response variable and multiple predictor varaibles. Based on the choices it outputs a summary plot of the linear model. At the right there is a table with predicted values of the test set. The data was split into 80% training and 20% test sets. If your response and predictor variables are blank then nothing populates.")),
                
                
                
                tabPanel("Tree Modeling",
                         h4("This tab is another prediction method that allows the user to input multiple predictor variables and it uses Random Forest to predict the response. It shows a plot of the prediction error based on number of trees. It starts off blank, and as you add predictors a plot populates. Only thing this is if your response and predictor are the same it will remain blank. Also there is a table that shows the predicted values for the test set. The data was also split into 80% training and 20% test set.")),
                tabPanel("Clustering",
                         h4("This tab looks at two clustering methods: PCA and hiearchial clustering. It allows the user to pick which method to investigate. If PCA, it allows the user to select which two PCs to pick and populates a biplot and if clusters then it takes a random sample and does a denrogram. The cluster graphs use all the data, so the raw data on the next tab can be used to get the data used for that plot.")),
                tabPanel("Raw Data",
                         h4("This shows the raw data which you can export to a csv by clicking on the button."))
              ),
              
              fluidPage(
                #this shows the link that explains more about the variables of the data. 
                #uiOutput("url"),
                h5("This link takes you to see more information about the column variables in this forbes dataset:",
                   a("Forbes Homepage", href = "https://vincentarelbundock.github.io/Rdatasets/doc/HSAUR/Forbes2000.html")),
                #h4("In this data we use a linear form in this form: "),
                withMathJax(),
                uiOutput('equation')
                
              )
              
              
              
              
      ),
      #This is the second tab: Numerical summaries. We have the user select either a scatter plot or histogram. Based on the selection it allows you to select numeric variables and outputs based on those selections. 
      
      
      tabItem(tabName = "Graph",
              #title of tab
              h1("Numerical Summaries",style = "color: black; font-weight: bold"),
              fluidRow(
                
                #outputs plot
                box(plotOutput('plot1')),
                
                #controls
                #first asks if you want scatter plot or histogram
                #next asks variables you want. 
                #also allows user to download plot
                box(
                  title = "Controls",
                  selectInput("plotType", "Plot Type", c(Scatter = "scatter", Histogram = "histogram")),
                  
                  
                  
                  conditionalPanel(
                    condition = "input.plotType=='scatter'",
                    selectInput("dataset5", "Choose first variable: ",
                                choices = c("sales", "profits", "assets", "marketvalue")),
                    
                    selectInput("dataset6","Choose second variable: ",
                                choices = c("sales", "profits", "assets", "marketvalue")),
                    
                    downloadButton('downloadPlot', 'Download Plot'),
                    
                    
                    
                    downloadButton('downloadData3', 'Download Data')
                    
                  ),
                  
                  conditionalPanel(
                    condition = "input.plotType=='histogram'",
                    
                    selectInput("dataset3", "Choose variable: ",
                                choices = c("sales", "profits", "assets", "marketvalue")),
                    
                    downloadButton('downloadPlot7', 'Download Plot'),
                    downloadButton('downloadData4', 'Download Data')
                    
                  )
                  
                  
                  
                  
                  
                )
                
              )
              
              
              
              
              
              
              
              
      ),
      
      
      
      #This is the second tab: Categorical Summaries
      tabItem(tabName = "Graph2",
              #title is Categorical Summaries
              h1("Categorical Summaries",style = "color: black; font-weight: bold"),
              #outputs barplot and allows user to hover over and see how many are in each barplot. 
              fluidRow(plotlyOutput("plot2"),
                       verbatimTextOutput("event")),
              
              box(
                #below the barplot is raw data table that you can filter to each specific category. 
                title = "Table Drill Down",
                selectInput("tableType", "Select a category to drill down the table: ",
                            choices = c("Utilities", "Transportation", "Trading companies", "Telecommunications services", "Technology hardware & equipment", "Software & services", "Semiconductors", "Retailing", "Oil & gas operations", "Media", "Materials", "Insurance", "Household & personal products", "Hotels restaurants & services", "Food markets", "Food drink & tobacco", "Drugs & biotechnology", "Diversified financials", "Consumer durables", "Construction", "Conglomerates", "Chemicals", "Capital goods", "Business services & supplies", "Banking", "Aerospace & defense")),
                downloadButton("downloadData", "Download")
              ),
              
              #data table
              DT::dataTableOutput("table")
              
              
      ),
      
      
      
      
      
      
      
      #This is the third tab: Linear Modeling
      tabItem(tabName = "Linear_Model",
              #name of tab: Linear Modeling
              h1("Linear Modeling",style = "color: black; font-weight: bold"),
              fluidRow(
                #outputs diagnostics plots of the linear model based on selections. 
                box(plotOutput("plot7")),
                
                
                
                box(
                  #allows user to select one response and multiple predictor variables. 
                  #also allows user to download plots
                  title = "Controls", 
                  selectInput("response2", "response to predict: ",
                              choices = c("sales", "profits", "assets", "marketvalue")),
                  
                  
                  checkboxGroupInput("predictor2", "predictors to show:",
                                     c("Sales" = "sales",
                                       "Profits" = "profits",
                                       "Assets" = "assets",
                                       "Marketvalue" = "marketvalue")),
                  downloadButton('downloadPlot6', 'Download Plot'),
                  downloadButton('downloadData5', 'Download Data from Plot')
                  
                ),
                #outputs table of predicted values 
                box( h2("Table of predicted values"),
                    tableOutput("table6"))
                
                
              )
      ),
      
      #This is the fourth tab: Tree Modeling
      tabItem(tabName = "Tree_Model",
              #title of tab: Tree Modeling
              h1("Tree Modeling",style = "color: black; font-weight: bold"),
              fluidRow(
                #outputs plot of random forest model
                box(plotOutput("plot6")
                ),
                
                box(
                  title = "Controls",
                  #allows user to select one response and multiple predictor variables
                  #allows user to input a number between 50 and 1000 and produces the plot based on the number of trees
                  #also allows user to save plot
                  selectInput("response", "response to predict: ",
                              choices = c("sales", "profits", "assets", "marketvalue")),
                  
                  
                  checkboxGroupInput("predictor", "predictors to show:",
                                     c("Sales" = "sales",
                                       "Profits" = "profits",
                                       "Assets" = "assets",
                                       "Marketvalue" = "marketvalue")),
                  
                  
                  numericInput("numbertype2", "Insert number of trees between 50 and 1000: ", 50, min = 50, max = 1000),
                  downloadButton('downloadPlot5', 'Download Plot'),
                  downloadButton('downloadData6', 'Download Data from Plot')
                  
                  
                  
                ),
                
                
                box( h2("Table of predicted values"),
                  tableOutput("table5"))
                
                
                
              )),
      
      #This is the fifth tab: Cluster Analysis
      tabItem(tabName = "Cluster",
              #title of tab: Cluster Analysis
              h1("Cluster Analysis",style = "color: black; font-weight: bold"),
              
              fluidRow(
                
                
                #allows user to select either PCA or Cluster. Based on the selection, allows user to create a biplot or hiearchial clustering
                #also allows users to download plots
                box(
                  title = "Controls",
                  selectInput("PlotType2", "PCA or Cluster", c(PCA = "pca", Cluster = "cluster")),
                  
                  conditionalPanel(
                    condition = "input.PlotType2 == 'pca'",
                    selectInput("PCType1", "Pick a PC: ", c(one = "one", two = "two", three = "three", four = "four")),
                    selectInput("PCType2", "Pick another PC: ", c(one = "one", two = "two", three = "three", four = "four")),
                    downloadButton('downloadPlot2', 'Download Plot'),
                    
                    
                    box(plotOutput("plot3"),height=500,width=450)
                    
                    
                    
                    
                  ),
                  
                  conditionalPanel(
                    condition = "input.PlotType2 == 'cluster'",
                    selectInput("dataset4","Choose variable: ",
                                choices = c("sales", "profits", "assets", "marketvalue")),
                    selectInput("ClusterType1", "Pick one of the following cluster methods: ", c(single = "single", complete = "complete", average = "average")),
                    numericInput("NumericType1", "Insert a sample size between 50 and 300: ", 50, min = 50, max = 300),
                    downloadButton('downloadPlot3', 'Download Plot'),
                    
                    box(plotOutput("plot4"), height = 500, width = 450)
                  )
                  
                  
                  
                  
                )
              )
      ),
      
      #This is the sixth tab: Raw Data
      tabItem(tabName = "Raw",
              #Title of tab: Raw Data
              h1("Raw Data",style = "color: black; font-weight: bold"),
              fluidRow(
                #allows users to download raw data
                box (title = "Controls",
                     downloadButton("downloadData2", "Download")),
                
                DT::dataTableOutput("table2"))
      )
      
      
      
      
    )
    
  ))

server <- function(input, output, session) {
  
  
  #outputs url
  url <- a("Forbes Homepage", href = "https://vincentarelbundock.github.io/Rdatasets/doc/HSAUR/Forbes2000.html")
  output$url <- renderUI({
    tagList("This link takes you to see more information about the column variables in this forbes dataset:", url)
  })
  
  
  
  
 #outputs plot for numerical summaries
  output$plot1 <- renderPlot({
    
    
    if (input$plotType == "scatter"){
      
      
      
      forbes4 <- na.omit(forbes)
      
      if ((input$dataset5 == "sales" && input$dataset6 == "profits") || (input$dataset5 == "profits" && input$dataset6 == "sales")){
        ggplot(forbes4, aes(x=profits, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "sales" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "sales")){
        ggplot(forbes4, aes(x=assets, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "sales" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "sales")){
        ggplot(forbes4, aes(x=marketvalue, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "profits" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "profits")){
        ggplot(forbes4, aes(x=assets, y=profits)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "assets" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "assets")){
        ggplot(forbes4, aes(x=assets, y=marketvalue)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "profits" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "profits")){
        ggplot(forbes4, aes(x=profits, y=marketvalue)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "sales" && input$dataset6 == "sales"){
        ggplot(forbes4, aes(x=sales, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "profits" && input$dataset6 == "profits"){
        ggplot(forbes4, aes(x=profits, y=profits)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "assets" && input$dataset6 == "assets"){
        ggplot(forbes4, aes(x=assets, y=assets)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "marketvalue" && input$dataset6 == "marketvalue"){
        ggplot(forbes4, aes(x=marketvalue, y=marketvalue)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      }
      
      
      
    }
    
    else if (input$plotType == "histogram"){
      
      
      
      
      if (input$dataset3 == "sales"){
        g <- ggplot(data = forbes, aes(x = sales))
        g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(sales)),col='red',size=2)
      }
      
      else if (input$dataset3 == "profits"){
        g <- ggplot(data = forbes, aes(x = profits))
        g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(profits)),col='red',size=2)
      }
      
      else if (input$dataset3 == "assets"){
        g <- ggplot(data = forbes, aes(x = assets))
        g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(assets)),col='red',size=2)
      }
      
      else if (input$dataset3 == "marketvalue"){
        g <- ggplot(data = forbes, aes(x = marketvalue))
        g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(marketvalue)),col='red',size=2)
      }
    }
    
    
    
  })
  
  #donwloads scatter plot
  output$downloadPlot <- downloadHandler(
    
    
    
    
    filename = function() { paste(input$dataset5, '.png', sep='') },
    content = function(file) {
      
      
      ggsave(file, if (input$plotType == "scatter"){
        
        
        
        forbes4 <- na.omit(forbes)
        
        if ((input$dataset5 == "sales" && input$dataset6 == "profits") || (input$dataset5 == "profits" && input$dataset6 == "sales")){
          ggplot(forbes4, aes(x=profits, y=sales)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if ((input$dataset5 == "sales" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "sales")){
          ggplot(forbes4, aes(x=assets, y=sales)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if ((input$dataset5 == "sales" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "sales")){
          ggplot(forbes4, aes(x=marketvalue, y=sales)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if ((input$dataset5 == "profits" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "profits")){
          ggplot(forbes4, aes(x=assets, y=profits)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if ((input$dataset5 == "assets" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "assets")){
          ggplot(forbes4, aes(x=assets, y=marketvalue)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if ((input$dataset5 == "profits" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "profits")){
          ggplot(forbes4, aes(x=profits, y=marketvalue)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if (input$dataset5 == "sales" && input$dataset6 == "sales"){
          ggplot(forbes4, aes(x=sales, y=sales)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if (input$dataset5 == "profits" && input$dataset6 == "profits"){
          ggplot(forbes4, aes(x=profits, y=profits)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if (input$dataset5 == "assets" && input$dataset6 == "assets"){
          ggplot(forbes4, aes(x=assets, y=assets)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        } else if (input$dataset5 == "marketvalue" && input$dataset6 == "marketvalue"){
          ggplot(forbes4, aes(x=marketvalue, y=marketvalue)) + 
            geom_point(color='#2980B9', size = 4) + 
            geom_smooth(method=lm, color='#2C3E50')
          
        }
        
        
        
      }
      
      
      
      )
    }
  )
  
  output$downloadData3 <- downloadHandler(
    filename = function() {
      "data.csv"
    },
    content = function(file) {
      
      forbes2 <- forbes %>% select(input$dataset5,input$dataset6)
      
      write_csv(forbes2, file)
    }
  )
  
  output$downloadData4 <- downloadHandler(
    filename = function() {
      "data.csv"
    },
    content = function(file) {
      
      forbes2 <- forbes %>% select(input$dataset3)
      
      write_csv(forbes2, file)
    }
  )
  
  
  output$downloadData5 <- downloadHandler(
    filename = function() {
      "data.csv"
    },
    content = function(file) {
      
      forbes2 <- forbes %>% select(input$response2,input$predictor2)
      
      write_csv(forbes2, file)
    }
  )
  
  output$downloadData6 <- downloadHandler(
    filename = function() {
      "data.csv"
    },
    content = function(file) {
      
      forbes2 <- forbes %>% select(input$response,input$predictor)
      
      write_csv(forbes2, file)
    }
  )
  
  
  
  #downloads histogram
  output$downloadPlot7 <- downloadHandler(
    
    
    
    
    filename = function() { paste(input$dataset3, '.png', sep='') },
    content = function(file) {
      
      
      ggsave(file, 
             
             if (input$plotType == "histogram"){
               
               forbes4 <- na.omit(forbes)
               
               
               if (input$dataset3 == "sales"){
                 g <- ggplot(data = forbes, aes(x = sales))
                 g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(sales)),col='red',size=2)
               }
               
               else if (input$dataset3 == "profits"){
                 g <- ggplot(data = forbes, aes(x = profits))
                 g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(profits)),col='red',size=2)
               }
               
               else if (input$dataset3 == "assets"){
                 g <- ggplot(data = forbes, aes(x = assets))
                 g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(assets)),col='red',size=2)
               }
               
               else if (input$dataset3 == "marketvalue"){
                 g <- ggplot(data = forbes, aes(x = marketvalue))
                 g + geom_histogram(binwidth=1) + geom_vline(aes(xintercept=mean(marketvalue)),col='red',size=2)
               }
             }
             
      )
    }
  )
  
  
  #outputs barplot
  output$plot2 <- renderPlotly({
    g <- ggplot(data = forbes, aes(x = category))
    g + geom_bar() + theme(axis.text.x = element_text(angle=90, hjust=1)) 
  })
  
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
  
  
  #outputs data table for bar plot
  output$table <- DT::renderDataTable({
    forbes2 <- forbes %>% filter(category == input$tableType)
    
    forbes2
    
    
  })
  
  
  #downloads filtered data to a csv
  output$downloadData <- downloadHandler(
    filename = function() {
      "data.csv"
    },
    content = function(file) {
      
      forbes2 <- forbes %>% filter(category == input$tableType)
      write_csv(forbes2, file)
    }
  )
  
  #downloads raw data
  output$downloadData2 <- downloadHandler(
    filename = function() {
      "data.csv"
    },
    content = function(file) {
      
      #forbes2 <- forbes %>% filter(category == input$tableType)
      write_csv(forbes, file)
    }
  )
  
 
  
  
  
  
  #raw data table
  output$table2 <- DT::renderDataTable({
    forbes
  })
  
  #outputs biplot
  output$plot3 <- renderPlot({
    forbes2 <- forbes %>% select(sales, profits, assets, marketvalue) 
    PCs <- prcomp(na.omit(forbes2), center = TRUE, scale = TRUE)
    
    
    
    if ((input$PCType1 == "one" && input$PCType2 == "one")){
      biplot(PCs, choices = c(1,1))
    } else if ((input$PCType1 == "one" && input$PCType2 == "two") || (input$PCType1 == "two" && input$PCType2 == "one")){
      biplot(PCs, choices = c(1,2))
    } else if ((input$PCType1 == "one" && input$PCType2 == "three") || (input$PCType1 == "three" && input$PCType2 == "one")){
      biplot(PCs, choices = c(1,3))
    } else if ((input$PCType1 == "one" && input$PCType2 == "four") || (input$PCType1 == "four" && input$PCType == "one")){
      biplot(PCs, choices = c(1,4))
    } else if ((input$PCType1 == "two" && input$PCType2 == "two")){
      biplot(PCs, choices = c(2,2))
    } else if ((input$PCType1 == "two" && input$PCType2 == "three") || (input$PCType1 == "three" && input$PCType == "two")){
      biplot(PCs, choices = c(2,3))
    } else if ((input$PCType1 == "two" && input$PCType2 == "four") || (input$PCType1 == "four" && input$PCType2 == "two")){
      biplot(PCs, choices = c(2,4))
    } else if (input$PCType1 == "three" && input$PCType2 == "three"){
      biplot(PCs, choices = c(3,3))
    } else if ((input$PCType1 == "three" && input$PCType2 == "four") || (input$PCType1 == "four" && input$PCType2 == "three")){
      biplot(PCs, choices = c(3,4))
    } else if (input$PCType1 == "four" && input$PCType2 == "four"){
      biplot(PCs, choices = c(4,4))
    } 
    
    
    
  })
  
  #downloads biplot
  output$downloadPlot2 <- downloadHandler(
    filename = function() { paste(input$PCType1, '.png', sep='') 
      
    },
    content = function(file) {
      
      forbes2 <- forbes %>% select(sales, profits, assets, marketvalue) 
      PCs <- prcomp(na.omit(forbes2), center = TRUE, scale = TRUE)
      ggsave(file, if ((input$PCType1 == "one" && input$PCType2 == "one")){
        biplot(PCs, choices = c(1,1))
      } else if ((input$PCType1 == "one" && input$PCType2 == "two") || (input$PCType1 == "two" && input$PCType2 == "one")){
        biplot(PCs, choices = c(1,2))
      } else if ((input$PCType1 == "one" && input$PCType2 == "three") || (input$PCType1 == "three" && input$PCType2 == "one")){
        biplot(PCs, choices = c(1,3))
      } else if ((input$PCType1 == "one" && input$PCType2 == "four") || (input$PCType1 == "four" && input$PCType == "one")){
        biplot(PCs, choices = c(1,4))
      } else if ((input$PCType1 == "two" && input$PCType2 == "two")){
        biplot(PCs, choices = c(2,2))
      } else if ((input$PCType1 == "two" && input$PCType2 == "three") || (input$PCType1 == "three" && input$PCType == "two")){
        biplot(PCs, choices = c(2,3))
      } else if ((input$PCType1 == "two" && input$PCType2 == "four") || (input$PCType1 == "four" && input$PCType2 == "two")){
        biplot(PCs, choices = c(2,4))
      } else if (input$PCType1 == "three" && input$PCType2 == "three"){
        biplot(PCs, choices = c(3,3))
      } else if ((input$PCType1 == "three" && input$PCType2 == "four") || (input$PCType1 == "four" && input$PCType2 == "three")){
        biplot(PCs, choices = c(3,4))
      } else if (input$PCType1 == "four" && input$PCType2 == "four"){
        biplot(PCs, choices = c(4,4))
      } )
    }
  )
  
  
  #outputs hierarchy cluster
  output$plot4 <- renderPlot({
    
    set.seed(1)
    forbes4 <- forbes[sample(nrow(forbes), input$NumericType1), ]
    
    if (input$dataset4 == "sales"){
      if (input$ClusterType1 == "single"){
        hierClust <- hclust(dist(data.frame(forbes4$sales)), method = "single")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "complete"){
        hierClust <- hclust(dist(data.frame(forbes4$sales)), method = "complete")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "average"){
        hierClust <- hclust(dist(data.frame(forbes4$sales)), method = "average")
        plot((hierClust), cex = 0.9, label.offset = 1)
      }
    }
    
    else if (input$dataset4 == "profits"){
      if (input$ClusterType1 == "single"){
        hierClust <- hclust(dist(data.frame(forbes4$profits)), method = "single")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "complete"){
        hierClust <- hclust(dist(data.frame(forbes4$profits)), method = "complete")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "average"){
        hierClust <- hclust(dist(data.frame(forbes4$profits)), method = "average")
        plot((hierClust), cex = 0.9, label.offset = 1)
      }
    }
    
    else if (input$dataset4 == "assets"){
      if (input$ClusterType1 == "single"){
        hierClust <- hclust(dist(data.frame(forbes4$assets)), method = "single")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "complete"){
        hierClust <- hclust(dist(data.frame(forbes4$assets)), method = "complete")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "average"){
        hierClust <- hclust(dist(data.frame(forbes4$assets)), method = "average")
        plot((hierClust), cex = 0.9, label.offset = 1)
      }
    }
    
    else if (input$dataset4 == "marketvalue"){
      if (input$ClusterType1 == "single"){
        hierClust <- hclust(dist(data.frame(forbes4$marketvalue)), method = "single")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "complete"){
        hierClust <- hclust(dist(data.frame(forbes4$marketvalue)), method = "complete")
        plot((hierClust), cex = 0.9, label.offset = 1)
      } else if (input$ClusterType1 == "average"){
        hierClust <- hclust(dist(data.frame(forbes4$marketvalue)), method = "average")
        plot((hierClust), cex = 0.9, label.offset = 1)
      }
    }
    
    
  })
  
  #download hierarchial cluster
  output$downloadPlot3 <- downloadHandler(
    filename = function() { paste(input$ClusterType1, '.png', sep='') 
      
    },
    content = function(file) {
      
      
      set.seed(1)
      forbes4 <- forbes[sample(nrow(forbes), input$NumericType1), ]
      
      ggsave(file,  if (input$dataset4 == "sales"){
        if (input$ClusterType1 == "single"){
          hierClust <- hclust(dist(data.frame(forbes4$sales)), method = "single")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "complete"){
          hierClust <- hclust(dist(data.frame(forbes4$sales)), method = "complete")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "average"){
          hierClust <- hclust(dist(data.frame(forbes4$sales)), method = "average")
          plot((hierClust), cex = 0.9, label.offset = 1)
        }
      }
      
      else if (input$dataset4 == "profits"){
        if (input$ClusterType1 == "single"){
          hierClust <- hclust(dist(data.frame(forbes4$profits)), method = "single")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "complete"){
          hierClust <- hclust(dist(data.frame(forbes4$profits)), method = "complete")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "average"){
          hierClust <- hclust(dist(data.frame(forbes4$profits)), method = "average")
          plot((hierClust), cex = 0.9, label.offset = 1)
        }
      }
      
      else if (input$dataset4 == "assets"){
        if (input$ClusterType1 == "single"){
          hierClust <- hclust(dist(data.frame(forbes4$assets)), method = "single")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "complete"){
          hierClust <- hclust(dist(data.frame(forbes4$assets)), method = "complete")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "average"){
          hierClust <- hclust(dist(data.frame(forbes4$assets)), method = "average")
          plot((hierClust), cex = 0.9, label.offset = 1)
        }
      }
      
      else if (input$dataset4 == "marketvalue"){
        if (input$ClusterType1 == "single"){
          hierClust <- hclust(dist(data.frame(forbes4$marketvalue)), method = "single")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "complete"){
          hierClust <- hclust(dist(data.frame(forbes4$marketvalue)), method = "complete")
          plot((hierClust), cex = 0.9, label.offset = 1)
        } else if (input$ClusterType1 == "average"){
          hierClust <- hclust(dist(data.frame(forbes4$marketvalue)), method = "average")
          plot((hierClust), cex = 0.9, label.offset = 1)
        }
      })
    }
  )
  
  #outputs scatterplot with linear regression line
  output$plot5 <- renderPlot({
    
    forbes4 <- na.omit(forbes)
    
    if ((input$dataset5 == "sales" && input$dataset6 == "profits") || (input$dataset5 == "profits" && input$dataset6 == "sales")){
      ggplot(forbes4, aes(x=profits, y=sales)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if ((input$dataset5 == "sales" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "sales")){
      ggplot(forbes4, aes(x=assets, y=sales)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if ((input$dataset5 == "sales" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "sales")){
      ggplot(forbes4, aes(x=marketvalue, y=sales)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if ((input$dataset5 == "profits" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "profits")){
      ggplot(forbes4, aes(x=assets, y=profits)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if ((input$dataset5 == "assets" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "assets")){
      ggplot(forbes4, aes(x=assets, y=marketvalue)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if ((input$dataset5 == "profits" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "profits")){
      ggplot(forbes4, aes(x=profits, y=marketvalue)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if (input$dataset5 == "sales" && input$dataset6 == "sales"){
      ggplot(forbes4, aes(x=sales, y=sales)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if (input$dataset5 == "profits" && input$dataset6 == "profits"){
      ggplot(forbes4, aes(x=profits, y=profits)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if (input$dataset5 == "assets" && input$dataset6 == "assets"){
      ggplot(forbes4, aes(x=assets, y=assets)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    } else if (input$dataset5 == "marketvalue" && input$dataset6 == "marketvalue"){
      ggplot(forbes4, aes(x=marketvalue, y=marketvalue)) + 
        geom_point(color='#2980B9', size = 4) + 
        geom_smooth(method=lm, color='#2C3E50')
      
    }
  })
  
  
  #downloads scatterplot
  output$downloadPlot4 <- downloadHandler(
    filename = function() { paste(input$dataset5, '.png', sep='') },
    content = function(file) {
      forbes4 <- na.omit(forbes)
      ggsave(file,if ((input$dataset5 == "sales" && input$dataset6 == "profits") || (input$dataset5 == "profits" && input$dataset6 == "sales")){
        ggplot(forbes4, aes(x=profits, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "sales" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "sales")){
        ggplot(forbes4, aes(x=assets, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "sales" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "sales")){
        ggplot(forbes4, aes(x=marketvalue, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "profits" && input$dataset6 == "assets") || (input$dataset5 == "assets" && input$dataset6 == "profits")){
        ggplot(forbes4, aes(x=assets, y=profits)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "assets" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "assets")){
        ggplot(forbes4, aes(x=assets, y=marketvalue)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if ((input$dataset5 == "profits" && input$dataset6 == "marketvalue") || (input$dataset5 == "marketvalue" && input$dataset6 == "profits")){
        ggplot(forbes4, aes(x=profits, y=marketvalue)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "sales" && input$dataset6 == "sales"){
        ggplot(forbes4, aes(x=sales, y=sales)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "profits" && input$dataset6 == "profits"){
        ggplot(forbes4, aes(x=profits, y=profits)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "assets" && input$dataset6 == "assets"){
        ggplot(forbes4, aes(x=assets, y=assets)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      } else if (input$dataset5 == "marketvalue" && input$dataset6 == "marketvalue"){
        ggplot(forbes4, aes(x=marketvalue, y=marketvalue)) + 
          geom_point(color='#2980B9', size = 4) + 
          geom_smooth(method=lm, color='#2C3E50')
        
      })
    }
  )
  
  
  #outputs plot for random forest
  output$plot6 <- renderPlot({
    library(randomForest)
    library(party)
    #library(reprtree)
    
    
    forbes3 <- na.omit(forbes) 
    set.seed(1)
    train <- sample(1:nrow(forbes3), size = nrow(forbes3)*0.8)
    test <- dplyr::setdiff(1:nrow(forbes3), train)
    
    forbesTrain <- forbes3[train, ]
    forbesTest <- forbes3[test, ]
    
    
    
    #look what I did 
    if(!is.null(input$predictor)) {
      
      valid = TRUE
      for(i in 1:length(input$predictor)) {
        str(input$predictor[i])
        str(input$response)
        
        if (input$response == input$predictor[i]){
          valid = FALSE
          break
        }
      }
      
      if(valid) {
        
        model <- randomForest(as.formula(paste(input$response, paste(" ~ ", paste(input$predictor, collapse= "+")))), 
                              data = forbesTrain, 
                              importance = TRUE, 
                              ntree = input$numbertype2, 
                              mtry =  ncol(forbesTrain)/3)
        
        model_predict <- predict(model, newdata = forbesTest)
        plot(model_predict, type="l") 
        
        
        
        
      }
      
      
    }
    
    
    
    
    
    
    
    
    
    
  })
  
  #outputs plot for linear model
  output$plot7 <- renderPlot({
    
    
    
    
    forbes3 <- na.omit(forbes) 
    set.seed(1)
    train <- sample(1:nrow(forbes3), size = nrow(forbes3)*0.8)
    test <- dplyr::setdiff(1:nrow(forbes3), train)
    
    forbesTrain <- forbes3[train, ]
    forbesTest <- forbes3[test, ]
    
    
    
    #look what I did 
    if(!is.null(input$predictor2)) {
      
      valid = TRUE
      for(i in 1:length(input$predictor2)) {
        str(input$predictor2[i])
        str(input$response2)
        
        if (input$response2 == input$predictor2[i]){
          valid = FALSE
          break
        }
      }
      
      if(valid) {
        
        model2 <- lm(as.formula(paste(input$response2, paste(" ~ ", paste(input$predictor2, collapse= "+")))), 
                     data = forbesTrain)
        
        model_predict2 <- predict(model2, newdata = forbesTest)
        par(mfrow=c(2,2))
        plot(model2)
        
        
        
        
      }
      
      
    }
    
    
    
    
    
    
    
    
    
    
  })
  
  #table of predicted values: linear model
  output$table6 <- renderTable({
    
    
    forbes3 <- na.omit(forbes) 
    set.seed(1)
    train <- sample(1:nrow(forbes3), size = nrow(forbes3)*0.8)
    test <- dplyr::setdiff(1:nrow(forbes3), train)
    
    forbesTrain <- forbes3[train, ]
    forbesTest <- forbes3[test, ]
    
    
    
    #look what I did 
    if(!is.null(input$predictor2)) {
      
      valid = TRUE
      for(i in 1:length(input$predictor2)) {
        str(input$predictor2[i])
        str(input$response2)
        
        if (input$response2 == input$predictor2[i]){
          valid = FALSE
          break
        }
      }
      
      if(valid) {
        
        model2 <- lm(as.formula(paste(input$response2, paste(" ~ ", paste(input$predictor2, collapse= "+")))), 
                     data = forbesTrain)
        
        model_predict2 <- predict(model2, newdata = forbesTest)
        model_predict2
        
        
        
        
      }
      
      
    }
  })
  
  #table for predicted values: random forest model
  output$table5 <- renderTable({
    library(randomForest)
    library(party)
    #library(reprtree)
    
    
    forbes3 <- na.omit(forbes) 
    set.seed(1)
    train <- sample(1:nrow(forbes3), size = nrow(forbes3)*0.8)
    test <- dplyr::setdiff(1:nrow(forbes3), train)
    
    forbesTrain <- forbes3[train, ]
    forbesTest <- forbes3[test, ]
    
    
    
    #look what I did 
    if(!is.null(input$predictor)) {
      
      valid = TRUE
      for(i in 1:length(input$predictor)) {
        str(input$predictor[i])
        str(input$response)
        
        if (input$response == input$predictor[i]){
          valid = FALSE
          break
        }
      }
      
      if(valid) {
       
        model <- randomForest(as.formula(paste(input$response, paste(" ~ ", paste(input$predictor, collapse= "+")))), 
                              data = forbesTrain, 
                              importance = TRUE, 
                              ntree = input$numbertype2, 
                              mtry =  ncol(forbesTrain)/3)
        
        model_predict <- predict(model, newdata = forbesTest)
        model_predict
        
        
        
        
        
      }
      
      
    }
  })
  
  
  
  #downloads data for random forest
  output$downloadPlot5 <- downloadHandler(
    filename = function() { paste(input$predictor, '.png', sep='') },
    content = function(file) {
      library(randomForest)
      library(party)
      #library(reprtree)
      
      
      forbes3 <- na.omit(forbes) 
      set.seed(1)
      train <- sample(1:nrow(forbes3), size = nrow(forbes3)*0.8)
      test <- dplyr::setdiff(1:nrow(forbes3), train)
      
      forbesTrain <- forbes3[train, ]
      forbesTest <- forbes3[test, ]
      ggsave(file,
             if(!is.null(input$predictor)) {
               
               valid = TRUE
               for(i in 1:length(input$predictor)) {
                 str(input$predictor[i])
                 str(input$response)
                 
                 if (input$response == input$predictor[i]){
                   valid = FALSE
                   break
                 }
               }
               
               if(valid) {
                 
                 model <- randomForest(as.formula(paste(input$response, paste(" ~ ", paste(input$predictor, collapse= "+")))), 
                                       data = forbesTrain, 
                                       importance = TRUE, 
                                       ntree = input$numbertype2, 
                                       mtry =  ncol(forbesTrain)/3)
                 
                 model_predict <- predict(model, newdata = forbesTest)
                 plot(model_predict, type="l") 
               }
               
               
             })
    }
  )
  
  
  
  
  
  #downloads plot for linear model
  output$downloadPlot6 <- downloadHandler(
    filename = function() { paste(input$predictor2, '.png', sep='') },
    content = function(file) {
      
      
      
      forbes3 <- na.omit(forbes) 
      set.seed(1)
      train <- sample(1:nrow(forbes3), size = nrow(forbes3)*0.8)
      test <- dplyr::setdiff(1:nrow(forbes3), train)
      
      forbesTrain <- forbes3[train, ]
      forbesTest <- forbes3[test, ]
      ggsave(file,
             if(!is.null(input$predictor2)) {
               
               valid = TRUE
               for(i in 1:length(input$predictor2)) {
                 str(input$predictor2[i])
                 str(input$response2)
                 
                 if (input$response2 == input$predictor2[i]){
                   valid = FALSE
                   break
                 }
               }
               
               if(valid) {
                 
                 model2 <- lm(as.formula(paste(input$response2, paste(" ~ ", paste(input$predictor2, collapse= "+")))), 
                              data = forbesTrain)
                 
                 par(mfrow=c(2,2))
                 model_predict2 <- predict(model2, newdata = forbesTest)
                 plot(model2) 
               }
               
               
             })
    }
  )
  
  #math jax to show that beta is the coefficient for the linear model. 
  output$equation <- renderUI({
    withMathJax(helpText('Note: with the linear model depending on the variables selected our formula looks like this: y = x*$$\\beta$$'))
    
  })
  
  
}

shinyApp(ui, server)
#shiny::runGitHub('ST558FinalExam','SophiaMelenikiotis')
