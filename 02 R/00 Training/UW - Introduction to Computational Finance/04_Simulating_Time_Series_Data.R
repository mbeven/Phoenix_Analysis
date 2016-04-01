# Simulating Time Series Data
# Michael Beven
# 20150922
# Data: none

require(graphics)

# Simulate data from a MA(1) model
# Consider the MA(1) model 
# Y(t) = 0.05 + eps(t) + theta*eps(t-1), 
# with abs(theta) < 0 and eps(t) iid N(0,(0.1)^2)


set.seed(123);

# Simulate 250 observations from the described MA(1) model
ma1_sim = arima.sim(n = 250, model = list(ma=0.5), mean = 0, sd = 0.1) + 0.05

# A line plot of the simulated observations
plot(ma1_sim, main = "MA(1) Process: mu=0.05, theta=0.5", xlab = "time", 
     ylab = "y(t)", type = "l")
abline(h = 0)

# Generate the theoretical ACF with upto lag 10
acf_ma1_model = ARMAacf(ma = 0.5, lag.max = 10)
  
# Split plotting window in three rows
par(mfrow=c(3,1))

# First plot: The simulated observations
plot(ma1_sim, type="l",main="MA(1) Process: mu=0.05, theta=0.5",xlab="time",ylab="y(t)")
abline(h=0)

# Second plot: Theoretical ACF
plot(1:10, acf_ma1_model[2:11], type="h", col="blue",  ylab="ACF", main="theoretical ACF")

# Third plot: Sample ACF
# Assign to tmp the Sample ACF
tmp = acf(ma1_sim, lag.max = 10, plot = TRUE, main = "Sample ACF")
  
# Reset graphical window to only one graph
par(mfrow=c(1,1))

# Simulate data from a RA(1) model
# Consider the RA(1) model
# Y(t) - 0.5 = phi(Y(t-1) - 0.05)
# with abs(phi) < 0 and eps(t) iid N(0,(0.1)^2)

set.seed(123);

# Simulate 250 observations from the described AR(1) model
ar1_sim = arima.sim(n = 250, model = list(ar=0.5), mean = 0, sd = 0.1) + 0.05
  
# Generate the theoretical ACF with ten lags
acf_ar1_model =  ARMAacf(ar = 0.5, lag.max = 10)
  
# Split plotting window in three rows
par(mfrow=c(3,1))

# Generate the same three graphs as in the previous exercise 
par(mfrow=c(3,1))

# First plot: The simulated observations
plot(ar1_sim, type="l", main="AR(1) Process: mu=0.05, phi=0.5",xlab="time",ylab="y(t)")
abline(h=0)

# Second plot: Theoretical AFC
plot(1:10, acf_ar1_model[2:11], type="h", col="blue", main="theoretical ACF")

# Third plot: Sample AFC
tmp = acf(ar1_sim, lag.max = 10, plot = TRUE, main = "Sample ACF")
  
# Reset plotting window to default
par(mfrow=c(1,1))

