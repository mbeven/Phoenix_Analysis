# 2.5 R Lab
# 2.5.1 Data Analysis

dat = read.csv("Stock_FX_Bond.csv", header = TRUE)
names(dat)

# Put database into R searchpath
attach(dat)

# Sample size
n = dim(dat)[1]

# GM and Ford simple returns
GMReturn = GM_AC[2:n]/GM_AC[1:(n-1)] - 1
FReturn = F_AC[2:n]/F_AC[1:(n-1)] - 1

# Specify plotting parameters
par(mfrow = c(1,1))

# Plot simple returns
pdf("tempplot.pdf")
plot(GMReturn,FReturn)
dev.off()

# Problem 2
# Compute the log returns for GM and plot the
# returns versus the log returns? How highly
# correlated are the two types of returns? (The
# R func- tion cor computes correlations.)

# GM and Ford log returns
GMLogReturn = log(GM_AC[2:n]/GM_AC[1:(n-1)])
FLogReturn = log(F_AC[2:n]/F_AC[1:(n-1)])

# Correlation between GM and Ford log returns
cor(GMLogReturn, FLogReturn)
