# R Data Sources
# Michael Beven
# 20150920
# Data: YAHOO! Finance, Quandl

# Load packages
require(Quandl)
require(ggplot2)
require(quantmod)
require(colorspace)

# Querying YAHOO! Finance

URL = "http://ichart.finance.yahoo.com/table.csv?s=WOOF"
WOOF.info = read.csv(URL)
WOOF.info$Date = as.Date(WOOF.info$Date, "%Y-%m-%d")

# Taking a subset of selected data

WOOFsub.info = subset(WOOF.info, WOOF.info$Date > as.Date("2015-09-01"))

# Plotting the data

plot(WOOF.info$Date, WOOF.info$Close, pch=19, col = "Black", 
     cex = 0.25, xlab = "Date", ylab = "Price")

# Exercise
# Obtain close prices for XOM and CHK from January 2013 until December 2014

# Query YAHOO! Finance

# XOM
XOM.URL = "http://ichart.finance.yahoo.com/table.csv?s=XOM"
XOM.info = read.csv(XOM.URL)
XOM.info$Date = as.Date(XOM.info$Date, "%Y-%m-%d")
subXOM.info = subset(XOM.info[,c("Date", "Close")], XOM.info$Date >= 
                    as.Date("2013-01-01") & XOM.info$Date <= as.Date("2014-12-31"))

# CHK

CHK.URL = "http://ichart.finance.yahoo.com/table.csv?s=CHK"
CHK.info = read.csv(CHK.URL)
CHK.info$Date = as.Date(CHK.info$Date, "%Y-%m-%d")
subCHK.info = subset(CHK.info[,c("Date", "Close")], CHK.info$Date >= 
                    as.Date("2013-01-01") & CHK.info$Date <= as.Date("2014-12-31"))


# Exercise
# Make a combined data frame of these two price series, and compute the Pearson 
# correlation between XOM prices and CHK prices

# Combine data sets
CHK.XOM.Close = merge(subXOM.info,subCHK.info, by = "Date")

# Rename columns
colnames(CHK.XOM.Close) = c("Date", "XOM.Close", "CHK.Close")

# Apply Pearson correlation
cor(CHK.XOM.Close$XOM.Close, CHK.XOM.Close$CHK.Close, use = "all.obs", "pearson")

# Querying Quandl

Quandl.api_key("v21snmSix9KyXBWc1RkF") # optional for free data sets
oil.raw = Quandl::Quandl(c('NSE/OIL'))

# Plot data

plot(oil.raw$Date, abs(oil.raw$Close - oil.raw$Open), type = 'l', col = "black")

# Exercise
# Find the exchange rate of the Turkish Lira to the US Dollar from January 2011
# through December 2015 using Quandl.  Plot it's time series with a title, colors
# and axis labels

TRYUSD.raw = Quandl::Quandl(c('CURRFX/TRYUSD'))
TRYUSD.raw$Date = as.Date(TRYUSD.raw$Date, "%Y-%m-%d")

# Subset of TRYUSD.raw from January 2011 to December 2015

TRYUSDsub.raw = subset(TRYUSD.raw, TRYUSD.raw$Date >= as.Date('2011-01-01') & 
                         TRYUSD.raw$Date <= as.Date('2015-12-31'))

# Plot data

plot(TRYUSDsub.raw$Date, TRYUSDsub.raw$Rate, col = "black", 
     pch = 20, cex = 0.1, main = "Time Series of Turkish Lira to US Dollars",
     xlab = "Date", ylab = "TRY-USD")
par(new=T)
points(TRYUSDsub.raw$Date, TRYUSDsub.raw$`High (est)`, col = 
         "green", pch = 20, cex = 0.1)
points(TRYUSDsub.raw$Date, TRYUSDsub.raw$`Low (est)`, col = 
         "orange", pch = 20, cex = 0.1)
legend('topright', legend = c("High (est)", "Rate", "Low (est)"), lty = 1,
                              col = c('green', 'black',' orange'))

par(new=F)

# Exercise
# Use diff() to plot increments of the TL/USD exchange rate, with a title,
# good colors and axis labels
# Use diff() to plot a histogram of the TL/USD exchange rate, with a title,
# good colors and axis labels



