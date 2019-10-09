#
# Developing Data Products - Course Project
# Author: Mats
# ui.R
#
library(plotly)
library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("FAANG stocks comparison"),
  
  # Sidebar with checkboxes for selecting stocks to show 
  sidebarLayout(
    sidebarPanel(
       p("FAANG is an acronym for the companies Facebook, Amazon, Apple, Netflix and Google (now Alphabet Inc.)."),
       p("Source: ", a("Wikipedia article", href="https://en.wikipedia.org/wiki/Facebook,_Apple,_Amazon,_Netflix_and_Google")) ,
       h4("Show stocks in graph"),
       checkboxInput("show_Fb", " Facebook, Inc.", value = TRUE),
       checkboxInput("show_Aapl", " Apple Inc.", value = TRUE),
       checkboxInput("show_Amzn", " Amazon.com, Inc.", value = TRUE),
       checkboxInput("show_Nflx", " Netflix, Inc.", value = TRUE),
       checkboxInput("show_Goog", " Google (Alphabet Inc.)", value = TRUE)
    ),
    
    # Show a plot of the stocks
    mainPanel(
       plotlyOutput("stocksPlot"),
       br(),
       h4(textOutput("market_cap")),
       br(),
       p("Select one or several stocks by checking the checkboxes to the left."),
       p("Try out some of the features available in the Plotly graph above by hoovering with the pointer over the 
        graph and, for example:", 
         br(),
         tags$ul(
                 tags$li("zoom in by using the + and - symbols showing"), 
                 tags$li("select a specific time interval by clicking and selecting area"), 
                 tags$li("pan the area vertically and horisontally by using the pan symbol.")
                )
         ) 
    )
  )
))
