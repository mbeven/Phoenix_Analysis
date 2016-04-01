# Performance
# Michael Beven
# 20151017

require(PerformanceAnalytics)

comparison = cbind(Bench.Rets,my.Rets.final)

comparison$Date = as.Date(as.character(comparison$Date))
row.names(comparison) = comparison$Date
drops = "Date"
comparison = data.frame(comparison[,!(names(comparison) %in% drops)])
class(comparison[,1]) = "numeric"
class(comparison[,2]) = "numeric"

charts.PerformanceSummary(comparison)

Performance = function(x) {
  cumRetx = Return.cumulative(x)
  annRetx = Return.annualized(x,scale=252)
  #sharpex = SharpeRatio.annualized(x,scale=252)
  winpctx = length(x[x > 0])/length(x[x != 0])
  annSDx = sd.annualized(x,scale=252)
  
  DDs = findDrawdowns(x)
  maxDDx = min(DDs$return)
  maxLx = max(DDs$length)
  
  Perf = c(cumRetx,annRetx,winpctx,annSDx,maxDDx,maxLx)
  names(Perf) = c("Cumulative Return", "Annual Return",
                  "Win %", "Annualized Volatility", "Maximum Drawdown", "Max Length Drawdown")
  
  return(Perf)
}

cbind(Bench=Performance(comparison[1]),Me=Performance(comparison[2]))
