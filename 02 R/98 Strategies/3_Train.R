# Good Cointegrating and Mean-Reverting Pair of Stocks
# Michael Beven
# 20151018

# Grab data for gold (lets test the gold ETF, GLD, with gold miners ETF, GDX)
library(quantmod)
library(tseries) #applying the dickey fuller test for co-integration

# GLD
getSymbols("GLD",from="1950-01-01")
GLD.Returns = diff(log(Ad(GLD)))
GLD.Returns[as.character(head(index(Ad(GLD)),1))] = 0
GLD.Prices = Ad(GLD)

# GDX
getSymbols("GDX",from="1950-01-01")
GDX.Returns = diff(log(Ad(GDX)))
GDX.Returns[as.character(head(index(Ad(GDX)),1))] = 0
GDX.Prices = Ad(GDX)

# Join the two return series
Both.Returns = merge(GLD.Returns['2014::2015'],GDX.Returns['2014::2015']) #from 2010 to 2015
Both.Prices = merge(GLD.Prices['2014::2015'],GDX.Prices['2014::2015']) #from 2010 to 2015

#Plot the prices against each other
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/Hist_Prices.jpg', width = 1000, height = 500)
par(mar=c(5,4,4,6)+.1)
plot(Both.Prices[,1], main="GLD & GDX Adj. Close Prices")
axis(2)
par(new=TRUE)
plot(Both.Prices[,2],type="l",col="blue",xlab="", ylab="",axes = FALSE, main = "")
axis(4)
axis.Date(3,as.Date(time(Both.Prices)))
mtext("GDX",side=4,line=3)
mtext("GLD",side=2,line=3)
legend("topright",col=c("black","blue"),lty=1,lwd = 1,legend=c("GLD","GDX"))
dev.off()

# View of the difference in returns (eye if there is any stationarity)
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/Diff_Returns.jpg', width = 1000, height = 500)
plot(Both.Returns[,1]-Both.Returns[,2], main="Difference in Log Returns")
abline(h = 0, col = 'red')
dev.off()

# Correlations
cor(Both.Prices)
cor(Both.Returns)

# Apply the Dickey-Fuller test to test cointegration.  Alternative hypothesis is stationarity, and null
# hypothesis is rejected with p-values less than 0.05
adftest = adf.test(Both.Returns[,1]-Both.Returns[,2])
adftest
print(paste("Dickey Fuller Test is significant: ",adftest$statistic ,sep=""))

# Apply the Phillips-Perron test to test cointegration.  Alternative hypothesis is stationarity, and null
# hypothesis is rejected with p-values less than 0.05
pptest = pp.test(Both.Returns[,1]-Both.Returns[,2])
pptest
print(paste("Phillips-Perron Test is significant: ",pptest$statistic ,sep=""))

# Apply the KPSS test to test cointegration.  Null hypothesis for the KPSS is stationarity
kpsstest = kpss.test(Both.Returns[,1]-Both.Returns[,2])
kpsstest
print(paste("KPSS is significant: ",kpsstest$statistic ,sep=""))

# Plot ACF - looks stationary
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/ACF.jpg', width = 1000, height = 500)
tmp = acf(Both.Returns[,1] - Both.Returns[,2], lag.max = 10, plot = TRUE, main = "GLD Adjusted Returns - GDX Adjusted Returns ACF")
dev.off()

# Find regression beta - this gives us an optimal hedge ratio
regression <- lm(Both.Prices[,1] ~ Both.Prices[,2] )
summary(regression)
beta <- coef(regression)[1]
print(paste("Hedge Ratio is: ", beta,sep=""))

# Plot regression
attach(as.data.frame(Both.Prices))
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/Regression.jpg', width = 1000, height = 500)
plot(GDX.Adjusted,GLD.Adjusted, pch=20, main = "Regression of Prices of GLD vs. GDX")
abline(regression, col = 'red')
dev.off()

