# Event and Execution handler - run code after testing 3_Train.R from the same file
# Michael Beven
# 20151105

# Grab data for gold (lets test the gold ETF, GLD, with gold miners ETF, GDX)
library(quantmod)
library(tseries) #applying tests for co-integration

# Global variables

stationarity.window = 120
start.analysis.period = as.Date("2015-01-01") 
end.analysis.period = as.Date(Sys.Date()) # today's date
analysis.time = as.numeric(end.analysis.period - start.analysis.period)

# Build initial dataframe to store results

# First get a column of desired trading days
getSymbols("GLD",from=start.analysis.period,to=end.analysis.period)
tmp = Ad(GLD)
dates = as.data.frame(time(tmp))
# Build dataframe to fill in results of each iteration of the loop
df <- data.frame(Date=as.Date(rep(NA, dim(dates)[1])),         # dataframe for change events
                         GLD.Adjusted=as.integer(rep(NaN, dim(dates)[1])),
                        GDX.Adjusted=as.integer(rep(NaN, dim(dates)[1])),
                        alpha = as.integer(rep(NaN, dim(dates)[1])),
                        beta = as.integer(rep(NaN, dim(dates)[1])),
                        signal.asset1=as.integer(rep(NaN, dim(dates)[1])),
                        signal.asset2=as.integer(rep(NaN, dim(dates)[1]))
)

# Based on 3_Train.R, create a loop function to estimate alpha and beta between two stocks for the given time window

handler = function(today.date) {
today.date = as.Date(today.date)
end.date = as.Date(today.date) - 1
start.date = end.date - stationarity.window
  
# GLD
getSymbols("GLD",from=start.date,to=end.date)
GLD.Prices = Ad(GLD)

# GDX
getSymbols("GDX",from=start.date,to=end.date)
GDX.Prices = Ad(GDX)

# Join the two series
Both.Prices = merge(GLD.Prices,GDX.Prices)

# Find alpha and beta to set the hedge ratio
regression <- lm(Both.Prices[,1] ~ Both.Prices[,2])
alpha <- coef(regression)[1]
beta <- coef(regression)[2]

# Get today's prices and apply beta 

getSymbols("GLD",from=today.date,to=today.date)
GLD.Price.Today = Ad(GLD)

getSymbols("GDX",from=today.date,to=today.date)
GDX.Price.Today = Ad(GDX)

Both.Prices.Today = merge(GLD.Price.Today,GDX.Price.Today)

signal.asset1 = 0
signal.asset2 = 0

# Signal logic - can be changed depending on desired strategy
if (Both.Prices.Today[1,1] >= alpha + beta*Both.Prices.Today[1,2]) {
  signal.asset1 = -1
  signal.asset2 = +1
} else if (Both.Prices.Today[1,1] <= alpha + beta*Both.Prices.Today[1,2]) {
  signal.asset1 = +1
  signal.asset2 = -1 
} 

return(data.frame("Date" = as.Date(today.date), "GLD Adjusted" = Both.Prices.Today[1,1], "GDX Adjusted" = Both.Prices.Today[1,2], alpha, beta, signal.asset1,signal.asset2))
}

for(i in 1:dim(dates)[1])
{
  df[i,] = handler(as.Date(dates[i,1]))
}

