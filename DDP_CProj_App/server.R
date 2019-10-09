#
# Developing Data Products - Course Project
# Author: Mats
# server.R
#

library(quantmod)
library(dplyr)
library(plotly)
library(ggplot2)
library(shiny)

# Get stock data from Yahoo Finance
fb_data <- getSymbols("FB",src='yahoo')
apple_data <- getSymbols("AAPL",src='yahoo')
amzn_data <- getSymbols("AMZN",src='yahoo')
nflx_data <- getSymbols("NFLX",src='yahoo')
goog_data <- getSymbols("GOOG",src='yahoo')

# Create data frames with stock data
fb <- data.frame(Date=index(FB),coredata(FB))
fb <- fb %>% select(1, 5)
names(fb)[2] <- "Stock_price_close_USD"
fb$name <- "Facebook, Inc."

aapl <- data.frame(Date=index(AAPL),coredata(AAPL))
aapl <- aapl %>% select(1, 5)
names(aapl)[2] <- "Stock_price_close_USD"
aapl$name <- "Apple Inc."

amzn <- data.frame(Date=index(AMZN),coredata(AMZN))
amzn <- amzn %>% select(1, 5)
names(amzn)[2] <- "Stock_price_close_USD"
amzn$name <- "Amazon.com, Inc."

nflx <- data.frame(Date=index(NFLX),coredata(NFLX))
nflx <- nflx %>% select(1, 5)
names(nflx)[2] <- "Stock_price_close_USD"
nflx$name <- "Netflix, Inc."

goog <- data.frame(Date=index(GOOG),coredata(GOOG))
goog <- goog %>% select(1, 5)
names(goog)[2] <- "Stock_price_close_USD"
goog$name <- "Google (Alphabet Inc.)"

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  showFb <- reactive ({ if (input$show_Fb) { fb } else { data.frame() } })
  showAapl <- reactive ({ if (input$show_Aapl) { aapl } else { data.frame() } })
  showAmzn <- reactive ({ if (input$show_Amzn) { amzn } else { data.frame() } })
  showNflx <- reactive ({ if (input$show_Nflx) { nflx } else { data.frame() } })
  showGoog <- reactive ({ if (input$show_Goog) { goog } else { data.frame() } })
  
  dataInput <- reactive({
          rbind(showFb(), showAapl(), showAmzn(), showNflx(), showGoog())
  })
  
        
  output$stocksPlot <- renderPlotly({
          data <- dataInput()
          if ((dim(data)[1] != 0)) {
                p <- plot_ly(data, x = ~Date, y = ~Stock_price_close_USD, 
                       type = "scatter", mode = "lines", color = ~name) %>%
                        layout(xaxis = list(title="Time interval"), 
                       yaxis = list(title="Stock closing price (USD)"))
                length <- length(summary(as.factor(data$name),maxsum=50000))
                if (length == 1) { 
                        p <- p %>% layout(title = unique(data$name))
                }
          } else {
             p <- NULL  
          }
          p
  })

})
