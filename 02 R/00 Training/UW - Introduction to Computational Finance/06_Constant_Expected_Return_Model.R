# Constant Expected Return Model
# Michael Beven
# 20150922
# Data: YAHOO!

require(tseries)
library("boot")

VBLTX_prices = get.hist.quote(instrument="vbltx", start="2005-09-01", end="2010-09-30", quote="AdjClose",provider="yahoo", origin="1970-01-01",compression="m", retclass="zoo", quiet = TRUE)
FMAGX_prices = get.hist.quote(instrument="fmagx", start="2005-09-01", end="2010-09-30", quote="AdjClose",provider="yahoo", origin="1970-01-01",compression="m", retclass="zoo", quiet = TRUE)
SBUX_prices = get.hist.quote(instrument="sbux", start="2005-09-01",end="2010-09-30", quote="AdjClose",provider="yahoo", origin="1970-01-01",compression="m", retclass="zoo", quiet = TRUE)

# Change the class of the time index to yearmon, which is appropriate for monthly data.
# index() and as.yearmon() are functions in the zoo package 
index(VBLTX_prices) = as.yearmon(index(VBLTX_prices))
index(FMAGX_prices) = as.yearmon(index(FMAGX_prices))
index(SBUX_prices) = as.yearmon(index(SBUX_prices))

# Create merged price data
all_prices = merge(VBLTX_prices, FMAGX_prices, SBUX_prices)
# Rename columns
colnames(all_prices) = c("VBLTX", "FMAGX", "SBUX")

# Calculate cc returns as difference in log prices
all_returns = diff(log(all_prices))

# Create matrix with returns
return_matrix = coredata(all_returns)

# Consider the constnt expected return model (CER):
# R(i,t) = mu(i) + eps(i,t)
# t = 1,...,T
# eps(i,t) ~ iid N(0,sig(i)^2)
# cov(eps(i,t),eps(j,t)) = sig(i,j)

# Find estimates and investigate their precision.  The estimate formula is:
# SE_hat(sig_hat(i)^2) = sig_hat(i)^2 / sqrt(T/2)

# Number of observations
n_obs = nrow(return_matrix)
  
# Estimates of sigma2hat
sigma2hat_vals = apply(return_matrix, 2, var)
  
# Standard Error of sigma2hat
se_sigma2hat = sigma2hat_vals / sqrt(n_obs/2)

# Calculate the precision of the correlation estimate, given by:
# SE_hat(rho_hat(i,j)) = (1 - (rho_hat(i,j)^2))/sqrt(T)

# Calculate the correlation matrix
cor_matrix = cor(return_matrix)
  
# Get the lower triangular part of that 'cor_matrix'
rhohat_vals = c(cor_matrix["VBLTX","FMAGX"],cor_matrix["VBLTX","SBUX"],
                cor_matrix["FMAGX","SBUX"])
  
# Set the names
names(rhohat_vals) = c("VBLTX,FMAGX","VBLTX,SBUX","FMAGX,SBUX")

# Compute the estimated standard errors for correlation
se_rhohat = (1 - rhohat_vals^2) / sqrt(n_obs)
  
se_rhohat

# Test for each mu(i):
# H0 : mu(i) = 0 vs. H1 : mu(i) != 0
t.test(all_returns[,"FMAGX"], conf.level = 0.95)

# Test the correlation between VBLTX,FMAGX
cor.test(x = all_returns[,"VBLTX"], y = all_returns[,"SBUX"])

# Test the normality of the returns of VBLTX
# H0 : r(i,t) ~ normal vs. H1 : r(i,t) ~ not normal
jarque.bera.test(all_returns[,"FMAGX"])

# Function for bootstrapping sample mean: 
mean_boot = function(x, idx) {
ans = mean(x[idx])
ans 
} 

# Construct VBLTX_mean_boot:
VBLTX_mean_boot = boot(return_matrix[,"VBLTX"], R = 999, statistic = mean_boot)
  
# Print the class of VBLTX_mean_boot
class(VBLTX_mean_boot)

# Print VBLTX_mean_boot
VBLTX_mean_boot

# Plot bootstrap distribution and qq-plot against normal
plot(VBLTX_mean_boot)