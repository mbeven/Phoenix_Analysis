# Random Variables and Probability Distributions
# Michael Beven
# 20150922
# Data: None

# X ~ N(0.05, (0.10)^2)
mu_x = 0.05
sigma_x = sqrt(0.10^2)

# Pr(X > 0.10)
pnorm(0.10, mu_x, sigma_x, lower.tail = FALSE)

# Pr(X < -0.10)
pnorm(-0.10, mu_x, sigma_x, lower.tail = TRUE)

# Pr(-0.05 < X < 0.15)
pnorm(0.15, mu_x, sigma_x, lower.tail = TRUE) - pnorm(-0.05, mu_x, sigma_x, 
                                                      lower.tail = TRUE)

# 1%, 5%, 95% and 99% quantile
qnorm(c(0.01,0.05,0.95,0.99), mu_x, sigma_x, lower.tail = TRUE)

# Normally distributed monthly returns
x_vals = seq(-0.25, 0.35, length.out = 100)
MSFT = dnorm(x_vals, 0.05, 0.10)
SBUX = dnorm(x_vals, 0.025, 0.05)

# Normal curve for MSFT
plot(x_vals, MSFT, type = "l", col = "blue", ylab = "Normal curves", ylim = c(0,8))

# Add a normal curve for SBUX
lines(x_vals,SBUX, type = "l", col = "red")

# Add a plot legend
legend("topleft", legend = c("Microsoft", "Starbucks"), 
       col = c("blue", "red"), lty = 1)

# Value-at-Risk

# R ~ N(0.04, (0.09)^2) 
mu_R = 0.04
sigma_R = 0.09
  
# Initial wealth W0 equals $100,000
W0 = 100000
  
# The 1% value-at-risk
W0*qnorm(0.01, mu_R, sigma_R, lower.tail = TRUE)
  
# The 5% value-at-risk
W0*qnorm(0.05, mu_R, sigma_R, lower.tail = TRUE)

# r ~ N(0.04, (0.09)^2) 
mu_r = 0.04
sigma_r = 0.09
  
# Initial wealth W0 equals $100,000
W0 = 100000
  
# The 1% value-at-risk
W0*(exp(qnorm(0.01, mu_r, sigma_r, lower.tail = TRUE)) - 1)
  
# The 5% value-at-risk
W0*(exp(qnorm(0.05, mu_r, sigma_r, lower.tail = TRUE)) - 1)

# Vectors of prices
PA = c(38.23, 41.29)
PC = c(41.11, 41.74)
  
# Simple monthly returns
RA = PA[length(PA)] / PA[1] - 1
RC = PC[length(PA)] / PC[1] - 1

# Continuously compounded returns
rA = log(1 + RA)
rC = log(1 + RC)

# Cash dividend per share
DA = 0.10
  
# Simple total return
RA_total = (PA[length(PA)] + DA - PA[1]) / PA[1]
  
# Dividend yield
DY = DA / PA[2]

# Simple annual return
RA_annual = (1 + RA)^12 - 1
  
# Continuously compounded annual return
rA_annual = rA*12

# Suppose $10k to invest over Amazon and Costco, compute portfolio shares of
# $8k in Amazon and $2k in Costco

# Portfolio shares
xA = 8000 / 10000
xC = 2000 / 10000
  
# Simple monthly return
xA * RA + xC * RC