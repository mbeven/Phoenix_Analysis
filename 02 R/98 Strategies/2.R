# Trading Strategy from Quantstart.com
# Michael Beven
# 20151018

#The strategy is carried out on a "rolling" basis:
  
# For each day, n, the previous k days of the differenced logarithmic returns of a 
# stock market index are used as a window for fitting an optimal ARIMA and GARCH model.
# The combined model is used to make a prediction for the next day returns.
# If the prediction is negative the stock is shorted at the previous close, while if it 
# is positive it is longed.If the prediction is the same direction as the previous day 
# then nothing is changed.

# Install suggested packages
library(quantmod)
library(lattice)
library(timeSeries)
library(rugarch)

# Set Parameters
window.length = 500

# Extract data using the quantmod package.  Here are differenced log returns of close price.
# Also removed the first NA value

getSymbols("^GSPC",from="1950-01-01")
spReturns = diff(log(Cl(GSPC)))
spReturns[as.character(head(index(Cl(GSPC)),1))] = 0

# Create a vector to store forecast values.  foreLength is the length of trading data we
# have minus k (window length)

fore.length = length(spReturns) - window.length
forecasts = vector(mode="character",length=fore.length)

# Loop through every day in trading data and fit an appropriate ARIMA and GARCH to rolling
# window of length k

for (d in 0:fore.length) {
  spReturnsOffset = spReturns[(1+d):(window.length+d)]
  
final.aic <- Inf
final.order <- c(0,0,0)
for (p in 0:5) for (q in 0:5) {
  if ( p == 0 && q == 0) {
    next
    }

  arimaFit = tryCatch( arima(spReturnsOffset, order=c(p, 0, q)),
                       error=function( err ) FALSE,warning=function( err ) FALSE )
  if( !is.logical( arimaFit ) ) {
    current.aic <- AIC(arimaFit)
    if (current.aic < final.aic) {
      final.aic <- current.aic
      final.order <- c(p, 0, q)
      final.arima <- arima(spReturnsOffset, order=final.order)
      }
    } else {
      next
    }
  }
}


# Carry out fitting of ARMA+GARCH using ugarchfit command

spec = ugarchspec(
  variance.model=list(garchOrder=c(1,1)),
  mean.model=list(armaOrder=c(final.order[1],final.order[3]),include.mean=T),ditribution.model="sged")

fit = tryCatch(ugarchfit(spec, spReturnsOffset, solver='hybrid'),error=function(e) e,warning=function(w) w)

# Create a csv file

if(is(fit,"warning")) {
  forecasts[d+1] = paste(index(spReturnsOffset[window.length]),1,sep=",")
  print(paste(index(spReturnsOffset[window.length]),1,sep=","))
        } else {
          fore = ugarchforecast(fit,n.ahead=1)
          ind = fore@forecast$seriesFor
          forecasts[d+1] = paste(colnames(ind),ifseld(ind[1]<0,-1,1),sep=",")
          print(paste(colnames(ind),ifelse(ind[1]<0,-1,1),sep=","))
        }


write.csv(forecasts,file="forecasts_test.csv",row.names=FALSE)

