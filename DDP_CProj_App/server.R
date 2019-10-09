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

## Get stock quote data from Yahoo Finance
fb_data <- getSymbols("FB",src='yahoo')
apple_data <- getSymbols("AAPL",src='yahoo')
amzn_data <- getSymbols("AMZN",src='yahoo')
nflx_data <- getSymbols("NFLX",src='yahoo')
goog_data <- getSymbols("GOOG",src='yahoo')

## Get stock market cap data from Yahoo Finance
what_metrics <- yahooQF(c("Market Capitalization"))

tickers <- c("FB", "AAPL", "AMZN", "NFLX", "GOOG")
# Not all the metrics are returned by Yahoo.
metrics <- getQuote(paste(tickers, sep="", collapse=";"), what=what_metrics)

#Add tickers as the first column and remove the first column which had date stamps
metrics <- data.frame(Symbol=tickers, metrics[,2:length(metrics)]) 

#Change colnames
colnames(metrics) <- c("Ticker", "Market Cap")

## Create data frames with stock data
fb <- data.frame(Date=index(FB),coredata(FB))
fb <- fb %>% select(1, 5)
names(fb)[2] <- "Stock_price_close_USD"
fb$name <- "Facebook, Inc."
fb_market_cap <- filter(metrics, Ticker =="FB")
fb_market_cap <- fb_market_cap[,2]

aapl <- data.frame(Date=index(AAPL),coredata(AAPL))
aapl <- aapl %>% select(1, 5)
names(aapl)[2] <- "Stock_price_close_USD"
aapl$name <- "Apple Inc."
aapl_market_cap <- filter(metrics, Ticker =="AAPL")
aapl_market_cap <- aapl_market_cap[,2]

amzn <- data.frame(Date=index(AMZN),coredata(AMZN))
amzn <- amzn %>% select(1, 5)
names(amzn)[2] <- "Stock_price_close_USD"
amzn$name <- "Amazon.com, Inc."
amzn_market_cap <- filter(metrics, Ticker =="AMZN")
amzn_market_cap <- amzn_market_cap[,2]

nflx <- data.frame(Date=index(NFLX),coredata(NFLX))
nflx <- nflx %>% select(1, 5)
names(nflx)[2] <- "Stock_price_close_USD"
nflx$name <- "Netflix, Inc."
nflx_market_cap <- filter(metrics, Ticker =="NFLX")
nflx_market_cap <- nflx_market_cap[,2]

goog <- data.frame(Date=index(GOOG),coredata(GOOG))
goog <- goog %>% select(1, 5)
names(goog)[2] <- "Stock_price_close_USD"
goog$name <- "Google (Alphabet Inc.)"
goog_market_cap <- filter(metrics, Ticker =="GOOG")
goog_market_cap <- goog_market_cap[,2]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  showFb <- reactive ({ if (input$show_Fb) { fb } else { data.frame() } })
  showAapl <- reactive ({ if (input$show_Aapl) { aapl } else { data.frame() } })
  showAmzn <- reactive ({ if (input$show_Amzn) { amzn } else { data.frame() } })
  showNflx <- reactive ({ if (input$show_Nflx) { nflx } else { data.frame() } })
  showGoog <- reactive ({ if (input$show_Goog) { goog } else { data.frame() } })
  
  marketCapFb <- reactive ({ if (input$show_Fb) { fb_market_cap } else { 0 } })
  marketCapAapl <- reactive ({ if (input$show_Aapl) { aapl_market_cap } else { 0 } })
  marketCapAmzn <- reactive ({ if (input$show_Amzn) { amzn_market_cap } else { 0 } })
  marketCapNflx <- reactive ({ if (input$show_Nflx) { nflx_market_cap } else { 0 } })
  marketCapGoog <- reactive ({ if (input$show_Goog) { goog_market_cap } else { 0 } })
  
  dataInput <- reactive({
          rbind(showFb(), showAapl(), showAmzn(), showNflx(), showGoog())
  })
  
  output$market_cap <- reactive({
          market_cap_bil <- sum(marketCapFb(), marketCapAapl(), marketCapAmzn(), marketCapNflx(), 
              marketCapGoog()) / 1000000000
          paste("Total current market capitalization in billion USD: ", round(market_cap_bil,1))
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
