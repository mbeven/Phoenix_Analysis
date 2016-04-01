# Introduction to Portfolio Theory
# Michael Beven
# 20150922
# Data: amazonaws

# Load relevant packages
library("PerformanceAnalytics")
library("zoo")
library("PortfolioAnalytics")
require("PortfolioAnalytics")

# Load the data
load(url("http://s3.amazonaws.com/assets.datacamp.com/course/compfin/lab8.RData"))

# Explore the data set
head(returns_df)
tail(returns_df)

# Estimate the parameters: multivariate
mu_hat_annual = apply(returns_df,2,mean)*12   
sigma2_annual = apply(returns_df, 2, var)*12
sigma_annual = apply(returns_df, 2, sd)*sqrt(12)
cov_mat_annual = cov(returns_df)*12 
cov_hat_annual = cov(returns_df)[1,2]*12    
rho_hat_annual = cor(returns_df)[1,2]

# The annual estimates of the CER model parameters for Boeing and Microsoft
mu_boeing = mu_hat_annual["rboeing"]
mu_msft = mu_hat_annual["rmsft"]
sigma2_boeing = sigma2_annual["rboeing"]
sigma2_msft = sigma2_annual["rmsft"]
sigma_boeing = sigma_annual["rboeing"]
sigma_msft = sigma_annual["rmsft"]
sigma_boeing_msft = cov_hat_annual
rho_boeing_msft = rho_hat_annual

# The ratio Boeing stock vs Microsoft stock (adds up to 1)
boeing_weights = seq(from=-1, to=2, by=0.1)
msft_weights = 1 - boeing_weights
  
# Portfolio parameters
mu_portfolio = boeing_weights * mu_boeing + msft_weights * mu_msft
  
sigma2_portfolio = boeing_weights^2 * sigma2_boeing + msft_weights^2 * sigma2_msft +
                    2 * boeing_weights * msft_weights * sigma_boeing_msft
  
sigma_portfolio = sqrt(sigma2_portfolio)

# Plotting the different portfolios
plot(sigma_portfolio, mu_portfolio, type="b", pch=16, ylim=c(0, max(mu_portfolio)), 
     xlim=c(0, max(sigma_portfolio)), xlab=expression(sigma[p]), ylab=expression(mu[p]),
     col=c(rep("green", 18), rep("red", 13)))
text(x=sigma_boeing, y=mu_boeing, labels="Boeing", pos=4)
text(x=sigma_msft, y=mu_msft, labels="Microsoft", pos=4)

# Annual risk-free rate of 3% per year for the T-bill
t_bill_rate = 0.03
  
# Ratio Boeing stocks
boeing_weights = seq(from=-1, to=2, by=0.1)
t_bill_weights = 1 - boeing_weights

# Portfolio parameters
mu_portfolio_boeing_bill = t_bill_weights * t_bill_rate + boeing_weights * mu_boeing
  
sigma_portfolio_boeing_bill = abs(boeing_weights * sigma_boeing)
  
# Plot previous exercise
plot(sigma_portfolio, mu_portfolio, type="b", pch=16, ylim=c(0, max(mu_portfolio)), 
     xlim=c(0, max(sigma_portfolio)), xlab=expression(sigma[p]), ylab=expression(mu[p]),
     col=c(rep("green", 18), rep("red", 13)))
text(x=sigma_boeing, y=mu_boeing, labels="Boeing", pos=4)
text(x=sigma_msft, y=mu_msft, labels="MSFT", pos=4)

# Portfolio Combination Boeing and T-bills
points(sigma_portfolio_boeing_bill, mu_portfolio_boeing_bill, col = "blue", type = "b")

# Sharp ratio Boeing
sharp_ratio_boeing = (mu_boeing - t_bill_rate) / sigma_boeing
  
# The global minimum variance portfolio
global_min_var_portfolio = globalMin.portfolio(er=mu_hat_annual, cov.mat = cov_mat_annual)
  
global_min_var_portfolio

# Summary of global_min_var_portfolio that takes into account the annual risk-free rate of 3% per year
summary(global_min_var_portfolio, risk.free = 0.03)

# Portfolio weights Boeing and Microsoft
plot(global_min_var_portfolio)

# Plot previous exercises
plot(sigma_portfolio, mu_portfolio, type="b", pch=16, ylim=c(0, max(mu_portfolio)), xlim=c(0, max(sigma_portfolio)), xlab=expression(sigma[p]), ylab=expression(mu[p]),col=c(rep("green", 18), rep("red", 13)))
text(x=sigma_boeing, y=mu_boeing, labels="Boeing", pos=4)
text(x=sigma_msft, y=mu_msft, labels="MSFT", pos=4)

# Plot the position of the global minimum variance portfolio
text(x=global_min_var_portfolio$sd, y=global_min_var_portfolio$er, labels="Global min", pos=2)

# The tangency portfolio
tangency_portfolio = tangency.portfolio(er = mu_hat_annual, cov.mat = cov_mat_annual, 
                                        risk.free = 0.03)
  
tangency_portfolio

# Summary of tangency_portfolio with annual risk free rate of 3%
summary(tangency_portfolio, risk.free = 0.03)

# Portfolio weights Boeing and Microsoft
plot(tangency_portfolio)

# Set of tangency portfolio weights
tangency_weights <- seq(from=0, to=2, by=0.1)

# Portfolio parameters
mu_portfolio_tangency_bill = t_bill_rate + tangency_weights*(tangency_portfolio$er-t_bill_rate)
  
sigma_portfolio_tangency_bill = tangency_weights*tangency_portfolio$sd
  
# Plot previous exercises
plot(sigma_portfolio, mu_portfolio, type="b", pch=16, ylim=c(0, max(mu_portfolio)), xlim=c(0, max(sigma_portfolio)), xlab=expression(sigma[p]), ylab=expression(mu[p]),col=c(rep("green", 18), rep("red", 13)))
text(x=sigma_boeing, y=mu_boeing, labels="Boeing", pos=4)
text(x=sigma_msft, y=mu_msft, labels="MSFT", pos=4)

# Plot portfolio combinations of tangency portfolio and T-bills
text(x=tangency_portfolio$sd, y=tangency_portfolio$er, labels="Tangency", pos=2)
points(sigma_portfolio_tangency_bill, mu_portfolio_tangency_bill, type="b", col="blue", pch=16)

# Define the portfolio ratio's
tangency_weight = 0.3
t_bill_weight = 1 - tangency_weight

# Define the portfolio parameters
mu_portfolio_efficient <- t_bill_rate + tangency_weight*(tangency_portfolio$er - t_bill_rate)
sd_portfolio_efficient <- tangency_weight*tangency_portfolio$sd

# Plot previous exercises
plot(sigma_portfolio, mu_portfolio, type="b", pch=16, ylim=c(0, max(mu_portfolio)), xlim=c(0, max(sigma_portfolio)), xlab=expression(sigma[p]), ylab=expression(mu[p]),col=c(rep("green", 18), rep("red", 13)))
text(x=sigma_boeing, y=mu_boeing, labels="Boeing", pos=4)
text(x=sigma_msft, y=mu_msft, labels="MSFT", pos=4)
text(x=tangency_portfolio$sd, y=tangency_portfolio$er, labels="Tangency", pos=2)
points(sigma_portfolio_tangency_bill, mu_portfolio_tangency_bill, type="b", col="blue", pch=16)

# Plot Efficient Portfolio with 30% Tangency
points(sd_portfolio_efficient, mu_portfolio_efficient, type="b", col="orange", pch=16, cex=2)
text(x=sd_portfolio_efficient, y=mu_portfolio_efficient, labels="Efficient Portfolio with 30% Tangency", pos=4, cex=0.75)

# Define the tangency portfolio ratio
tangency_weight  = sigma_boeing/tangency_portfolio$sd

# Calculate the weight of the tangency portfolio in the portfolio
mu_portfolio_efficient = t_bill_rate + tangency_weight*(tangency_portfolio$er - t_bill_rate)
sd_portfolio_efficient = tangency_weight*tangency_portfolio$sd

# Plot previous exercises
plot(sigma_portfolio, mu_portfolio,bg="NA", type="b", pch=16, ylim=c(0, max(mu_portfolio)), xlim=c(0, max(sigma_portfolio)), xlab=expression(sigma[p]), ylab=expression(mu[p]),col=c(rep("green", 18), rep("red", 13)))
text(x=sigma_boeing, y=mu_boeing, labels="Boeing", pos=4)
text(x=sigma_msft, y=mu_msft, labels="MSFT", pos=4)
text(x=tangency_portfolio$sd, y=tangency_portfolio$er, labels="Tangency", pos=2)
points(sigma_portfolio_tangency_bill, mu_portfolio_tangency_bill, type="b", col="blue", pch=16)

# Plot Efficient Portfolio with the same risk as Boeing
points(sd_portfolio_efficient, mu_portfolio_efficient, type="p", col="orange", pch=16, cex=2)
text(x=sd_portfolio_efficient, y=mu_portfolio_efficient, labels="Efficient Portfolio with same risk as Boeing", pos=2, cex=0.75)