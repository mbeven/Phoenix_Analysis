# Moving Average Crossover Strategy - Historical Analysis
# Michael Beven
# 20151113


# Grab Australian big 4 banks' data
library(quantmod)
# For moving averages
library(TTR)

# Set analysis period
start.date = as.Date("2013-01-01") 
end.date = as.Date(Sys.Date()) # today's date
analysis.time = as.numeric(end.analysis.period - start.analysis.period)

# First get a column of desired trading days.  Use WBC as dummy
getSymbols("WBC.AX",from=start.date,to=end.date)
tmp = Ad(WBC.AX)
dates = as.data.frame(time(tmp))

# Westpac
getSymbols("WBC.AX",from=start.date,to=end.date)
WBC.AX.Prices = Ad(WBC.AX)

# Commonwealth
getSymbols("CBA.AX",from=start.date,to=end.date)
CBA.AX.Prices = Ad(CBA.AX)

# NAB
getSymbols("NAB.AX",from=start.date,to=end.date)
NAB.AX.Prices = Ad(NAB.AX)

# ANZ
getSymbols("ANZ.AX",from=start.date,to=end.date)
ANZ.AX.Prices = Ad(ANZ.AX)
# Index of ANZ
ANZ.AX.Index = ANZ.AX.Prices / as.numeric(rep(ANZ.AX.Prices[1], dim(dates)[1])) * 100

# Index of WBC + CBA + NAB
Trio.AX.Index = (WBC.AX.Prices + CBA.AX.Prices + NAB.AX.Prices) / as.numeric(rep(WBC.AX.Prices[1] + CBA.AX.Prices[1] + NAB.AX.Prices[1], dim(dates)[1]))*100

# Data for analysis, with moving/rolling averages
df = merge(Trio.AX.Index,ANZ.AX.Index,SMA(Trio.AX.Index, n = 15), SMA(ANZ.AX.Index, n = 100))

# Rename correctly
names(df)[1] = "Trio.Index"
names(df)[2] = "ANZ.Index"
names(df)[3] = "Trio.Index.MA.15"
names(df)[4] = "ANZ.Index.MA.100"

# Quick look
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/MA_Crossover.jpg', width = 1000, height = 500)
matplot(df, type = "l",lwd=1,lty=1,col = 1:6, main = "Australian Big 4 Banks - Moving Averages", ylab=paste("Index: base=",start.date), xaxt="n")
legend("topleft", names(df), col=1:ncol(df), lty=1, cex=1.5)
timelabels<-format(index(df))
axis(1,at=1:dim(df)[1],labels=timelabels)
dev.off()

# Signal logic
signal = function(ma.lt,ma.st){
  trade.signal = 0 
  
  if (is.na(ma.lt) || is.na(ma.st)) {
    trade.signal = 0
  } else if (ma.lt <= ma.st) {
    trade.signal = +1
  } else if (ma.lt > ma.st) {
    trade.signal = -1
  } 
 return(trade.signal)
}

# Add buy/sell signals to df
df = merge(df,trade.signal=rep(NA, dim(df)[1]))
for(i in 1:dim(df)[1])
{
  df[i,5] = signal(df[i,4],df[i,3])
}

