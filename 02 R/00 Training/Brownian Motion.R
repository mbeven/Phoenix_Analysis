#####################################################################################
# Michael Beven
# Investigating brownian motions and the Ornstein Uhlenbeck mean reverting process
# 20151115
#####################################################################################

# Set parameters
T = 1 # time length of process
n = 1000 # number of divisions in T

# Calculations... 
dt = T/n
t = seq(0,1,by=dt)
# Create a set of random normals
dW = rnorm(n = (length(t) - 1), 0, sqrt(dt))
# Cumulative sum aggregates all changes in the process
dW = c(0, cumsum(dW))
# Plot the standard BM process
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/Standard_BM.jpg', width = 1000, height = 500)
plot(t, dW, type = "l", main = "One-Dimensional Standard Brownian Motion", ylab = "W(t)", xlab = "t")
dev.off()

# We could also generate a stochastic process for X~BM(mu, sigma^2)

# Set parameters
T = 1 # time length of process
n = 1000 # number of divisions in T
X0 = 5 # starting point of process
mu = 0.05 # mean (drift)
sigma = 0.01 # volatility

# Calculations...
dt = T/n
t = seq(0,1,by=dt)

# Create a set of random normals
dW = rnorm(n = (length(t) - 1), 0, sqrt(dt))

# Run loop for each step of the process
X = c(X0)
for (i in 2:(n+1)) {
  X[i] = X[i-1] + mu*dt + sigma*dW[i-1]
}

# Plot the BM process
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/BM_with_mu_sigma.jpg', width = 1000, height = 500)
plot(t,X,type = 'l', main = paste("One-Dimensional Brownian Motion with X0=",X0,", mu=",mu,", sigma=",sigma), ylab = "X(t)", xlab = "t")
dev.off()

# Now let us try and create the Ornstein Uhlenbeck process

# Set parameters
T = 1 # time length of process
n = 10000 # number of divisions in T
X0 = 10 # starting point of process
sigma = 4 # volatility
kappa = 8 # reversion rate
theta = 15 # long-term mean

# Calculations...
dt = T/n
t = seq(0,1,by=dt)

# Create a set of random normals
dW = rnorm(n = (length(t) - 1), 0, sqrt(dt))

# Run loop for each step of the process
X = c(X0)
for (i in 2:(n+1)) {
  X[i] = X[i-1] + kappa*(theta - X[i-1])*dt + sigma*dW[i-1]
}

# Plot the OU process
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/OU_process.jpg', width = 1000, height = 500)
plot(t,X,type = 'l', main = paste("Ornstein Uhlenbeck Process with X0=",X0,", kappa=",kappa,", theta=",theta,", sigma=",sigma), ylab = "X(t)", xlab = "t")
dev.off()

# May as well turn the OU process into a function and run it a few times...
OU.process = function(T, n, X0, sigma, kappa, theta) {
  # Calculations...
  dt = T/n
  t = seq(0,1,by=dt)
  
  # Create a set of random normals
  dW = rnorm(n = (length(t) - 1), 0, sqrt(dt))
  
  # Run loop for each step of the process
  X = c(X0)
  for (i in 2:(n+1)) {
    X[i] = X[i-1] + kappa*(theta - X[i-1])*dt + sigma*dW[i-1]
  }
  
  return(X)
}

# create a matrix with N simulations
T = 1 # time length of process
n = 10000 # number of divisions in T
X0 = 10 # starting point of process
sigma = 4 # volatility
kappa = 8 # reversion rate
theta = 15 # long-term mean
N = 10 # number of simulations

# Calculations...
dt = T/n
t = seq(0,1,by=dt)

# blank matrix
df = t(matrix(0,N,length(t)))

# run loop for simulations
for (j in 1:N) {
  df[,j] = OU.process(T, n, X0, sigma, kappa, theta)
}

# Plot the simulations
jpeg('/Users/michaelbeven/Documents/02 R/98 Strategies/Plots/OU_process_multiple_sims.jpg', width = 800, height = 500)
matplot(t,df, type = "l",lwd=1.5,lty=1,col = 1:N, main = paste(N, "Simulations of the O-U Process with X0=",X0,", kappa=",kappa,", theta=",theta,", sigma=",sigma), ylab="X(t)", xlab="t")
grid(col = "gray", lty = "dotted",lwd = par("lwd"), equilogs = TRUE)
dev.off()
