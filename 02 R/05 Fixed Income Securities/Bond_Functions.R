# Bond Functions
# Michael Beven
# 20151017

Bond_Zero_Coupon = function(par.value,rate,n,compound.frequency){
  
  # Make easier to read
  M = par.value
  r = rate
  n = n
  f = compound.frequency
  
  return(M/(1 + r/f)^(n*f))
}

Bond_With_Coupon = function(coupon,coupon.frequency,par.value,rate,n){
  # Formula assumes coupon frequency and compounding frequency are the same
  # Make easier to read
  c = coupon
  f = coupon.frequency
  M = par.value
  r = rate
  n = n
  
  # Present value of par
  PV.Par = M/(1 + r/c)^(c*n)
  
  # Present value of coupons
  PV.Coupons = (c/(r/c))*(1 - (1+r/c)^-(c*n))
  
  return(PV.Par + PV.Coupons)
  
}

Yield_To_Maturity = function(price,coupon,coupon.frequency,par.value,n){
  # Formula assumes coupon frequency and compounding frequency are the same
  # Make easier to read
  p = price
  c = coupon
  f = coupon.frequency
  M = par.value
  n = n
  
  # Uses Bond_With_Coupon function
  
  r = seq(0.01,0.15,length = 1400)
  
  value = Bond_With_Coupon(c,f,M,r,n)
  
  ytm = spline(value,r,xout=p)
  
  plot(r,value,xlab='yield to maturity',ylab='price of bond',
       type="l",main="par = 1000, coupon payment = 40, T = 30",lwd=2)
  abline(h=p)
  abline(v=ytm)
  
  return(ytm$y/f)
}