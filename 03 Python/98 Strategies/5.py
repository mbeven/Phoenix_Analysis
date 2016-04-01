# -*- coding: utf-8 -*-
"""
Created on Sat Nov 21 17:48:39 2015

@author: michaelbeven

Computations around the Vasicek model
"""

from math import exp
import numpy as np
import pandas as pd
from scipy.stats import norm
import matplotlib.pyplot as plt

#Functions

# Create a function for the mean of the Vasicek model
def mean_vasicek(r,alpha,mu,t):
    return mu + (r - mu)*np.exp(-1*alpha*t)
    
# Create a function for the variance of the Vasicek model
def sd_vasicek(sigma, alpha, t):
    return np.sqrt(sigma*sigma*(1-exp(-2*alpha*t))/(2*alpha))

# Zero coupon bond price    
def price_vasicek(r, alpha, mu, sigma, t, T):
    BtT = (1 - np.exp(-1*alpha*(T - t)))/alpha
    AtT = (BtT - (T - t))*(mu - sigma*sigma/(2*alpha*alpha))-sigma*sigma/(4*alpha)*BtT*BtT
    return np.exp(AtT - BtT*r)

# Fixed Income Call Option
def call_price_vasicek(r, alpha, mu, sigma, S, K, t, T):
    PtS = price_vasicek(r,alpha,mu,sigma,t,S)
    PtT = price_vasicek(r,alpha,mu,sigma,t,T)
    sigma_p = sigma/alpha*(1-np.exp(-1*alpha*(S-T)))*np.sqrt((1-exp(-2*alpha*(T-t)))/(2*alpha))
    d1 = 1/sigma_p * np.log(PtS/(K*PtT)) + sigma_p/2
    d2 = d1 - sigma_p
    return PtS*norm.cdf(d1)-K*PtT*norm.cdf(d2)

# Fixed Income Put Option
def put_price_vasicek(r, alpha, mu, sigma, S, K, t, T):
    PtS = price_vasicek(r,alpha,mu,sigma,t,S)
    PtT = price_vasicek(r,alpha,mu,sigma,t,T)
    sigma_p = sigma/alpha*(1-np.exp(-1*alpha*(S-T)))*np.sqrt((1-exp(-2*alpha*(T-t)))/(2*alpha))
    d1 = 1/sigma_p * np.log(PtS/(K*PtT)) + sigma_p/2
    d2 = d1 - sigma_p
    return K*PtT*norm.cdf(-1*d2)-PtS*norm.cdf(-1*d1)

# Graphing the mean and standard deviation against time

# Set parameters

size = 100

r = 0
alpha = 0.1
mu = 0.08
sigma = 0.01
t = 100

# Create a matrix of values for different times
t = pd.DataFrame({'t': np.linspace(0,t,size+1)})
mean = pd.DataFrame(np.zeros(shape=(size+1,1)),columns=['mean'])
variance = pd.DataFrame(np.zeros(shape=(size+1,1)),columns=['variance'])
df = pd.concat((t,mean,variance),axis=1)

for i in range (0,size):
    df.iloc[i,1] = mean_vasicek(r,alpha,mu,df.iloc[i,0])
    df.iloc[i,2] = sd_vasicek(sigma,alpha,df.iloc[i,0])

plt.figure(1)    
plt.plot(df.iloc[0:size,0],df.iloc[0:size,1],df.iloc[0:size,0],df.iloc[0:size,2])
plt.axis([0,size,0,max(r,mu)+0.02])
plt.title('Vasicek Short Rate Mean and Variance')
plt.xlabel('t')

# Graphic the call price wrt the strike

# Set parameters

size = 100
k_min = 0.75
k_max = 0.95

r = 0.15
alpha = 0.25
mu = 0.06
sigma = 0.02
t = 0
T = 20
S = 23
K = 0.1

# Create a matrix of values for different times
K = pd.DataFrame({'K': np.linspace(k_min,k_max,size+1)})
call = pd.DataFrame(np.zeros(shape=(size+1,1)),columns=['Call Price'])
put = pd.DataFrame(np.zeros(shape=(size+1,1)),columns=['Put Price'])
df = pd.concat((K,call,put),axis=1)
for i in range (0,size):
    df.iloc[i,1] = call_price_vasicek(r,alpha,mu,sigma,S, df.iloc[i,0], t, T)
    df.iloc[i,2] = put_price_vasicek(r,alpha,mu,sigma,S, df.iloc[i,0], t, T)    

plt.figure(2)    
plt.plot(df.iloc[0:size,0],df.iloc[0:size,1],df.iloc[0:size,0],df.iloc[0:size,2])
plt.title('Vasicek Short Rate Call and Put Prices')
plt.xlabel('K')
plt.ylabel('Price')