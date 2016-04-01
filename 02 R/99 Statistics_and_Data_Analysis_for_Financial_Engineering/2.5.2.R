# 2.5.2 Simulations
# Michael Beven
# 20150929
# Data: None

# Problem 3

# number of iterations
niter = 100000

# set up storage
below = rep(0,niter)

# set seed
set.seed(2009)

# run simulation on log returns based on 
# normal distribution
for (i in 1:niter)
{
  r = rnorm(45, mean = 0.05/253, sd = 
              0.23/sqrt(253)) # generate rn
  logPrice = log(1e6) + cumsum(r)
  minlogP = min(logPrice) # minimum price over 
  # next 45 days
  below[i] = as.numeric(exp(minlogP) < 950000)
}

# view probability
mean(below)

# Problem 4

# number of iterations
niter = 1e5

# set up storage
above = rep(0,niter)

# set seed
set.seed(2009)

# run simulation on log returns based on 
# normal distribution
for (i in 1:niter)
{
  r = rnorm(100, mean = 0.05/253, sd = 
              0.23/sqrt(253)) # generate rn
  logPrice = log(1e6) + cumsum(r)
  minlogP = min(logPrice) # minimum price over 
  # next 100 days
  maxlogP = max(logPrice) # maximum price over
  # next 100 days
  above[i] = as.numeric(exp(tail(logPrice,1))
                        > 1100000)
}

# view probability
mean(above)

# Problem 5

# number of iterations
niter = 1e5

# set up storage
below = rep(0,niter)

# set seed
set.seed(2009)

# run simulation on log returns based on 
# normal distribution
for (i in 1:niter)
{
  r = rnorm(100, mean = 0.05/253, sd = 
              0.23/sqrt(253)) # generate rn
  logPrice = log(1e6) + cumsum(r)
  minlogP = min(logPrice) # minimum price over 
  # next 100 days
  maxlogP = max(logPrice) # maximum price over
  # next 100 days
  below[i] = as.numeric(exp(tail(logPrice,1))
                        < 1000000)
}

# view probability
mean(below)

