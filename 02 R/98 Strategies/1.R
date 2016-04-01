# Strategy 1
# Michael Beven
# 20151017

# Find the high point over the last 200 days.  If the number of days since that high is
# is less than 100, buy the stock. If it is more, sell the stock

require(quantmod)
source("/Users/michaelbeven/Documents/02 R/02 Data Extraction/Yahoo_Data.R")
source("/Users/michaelbeven/Documents/02 R/04 Returns/Return_Functions.R")

# Required parameters
symbol = "GSPC"
start_date = "2010-01-01"
end_date = Sys.Date()

# Grab data
data.info = Yahoo_Data(start_date,end_date,symbol)

# Build function to look at the data, and the maximum point over the last time frame n
daysSinceHigh = function(x,n){
  apply(embed(x,n),1,which.max)-1
}

myStrat = function(x, nHold=100, nHigh=200){
  position = ifelse(daysSinceHigh(x,nHigh) <= nHold,1,0)
  c(rep(0,nHigh-1),position)
}

# Set Position
Position = myStrat(as.matrix(data.info),100,200)
Bench.Rets = format(Log_Returns(data.info,7), scientific = FALSE)
my.Rets.info = cbind(as.numeric(Bench.Rets[,2]),Lag(Position,1)[1:length(Position)-1])
my.Rets = data.frame(my.Rets.info)
my.Rets[1,2] = 0
my.Rets.final = data.frame(my.Rets$X1 * my.Rets$X2)
names(my.Rets.final) = c('Me')
