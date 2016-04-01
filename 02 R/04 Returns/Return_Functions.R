# Return functions
# Michael Beven
# 20151017

Gross_Returns = function(price_matrix, column){
  
  #get length of dataset
  len = dim(price_matrix)[1]
  
  #calculate returns
  Gross.Returns = (price_matrix[2:len,column] / price_matrix[1:len-1,column])
  
  Date = price_matrix[2:len,1]
  
  rets = data.frame(Date,Gross.Returns)
  
  rets$Date = as.Date(rets$Date,"%Y-%m-%d")
  
  return(rets)
}

Net_Returns = function(price_matrix, column){
  
  #get length of dataset
  len = dim(price_matrix)[1]
  
  #calculate returns
  Net.Returns = (price_matrix[2:len,column] / price_matrix[1:len-1,column]) - 1
  
  Date = price_matrix[2:len,1]
  
  rets = data.frame(Date,Net.Returns)
  
  rets$Date = as.Date(rets$Date,"%Y-%m-%d")
  
  return(rets)
}


Log_Returns = function(price_matrix,column){
  
  #get length of dataset
  len = dim(price_matrix)[1]
  
  #calculate returns
  Log.Returns = log(price_matrix[2:len,column] / price_matrix[1:len-1,column])
  
  Date = price_matrix[2:len,1]
  
  rets = data.frame(Date,Log.Returns)
  
  rets$Date = as.Date(rets$Date,"%Y-%m-%d")
  
  return(rets)
}

Effective_Annual_Rate_Net = function(Gross_Returns_Matrix){
  
  #get length of dataset
  len = dim(Gross_Returns_Matrix)[1]
  n = 250/len 
  
  #accumulate returns
  Cum.Rets = prod(Gross_Returns_Matrix[,2])
  
  #calculate annual rate return
  Effective.Annual.Ret = Cum.Rets^n - 1 #assume 250 trading days
    
  return(Effective.Annual.Ret)
}

Effective_Annual_Rate_Log = function(Log_Returns_Matrix){
  
  #get length of dataset
  len = dim(Log_Returns_Matrix)[1]
  n = 250/len #assume 250 trading days
  
  #accumulate returns
  Cum.Ret = sum(Log_Returns_Matrix[,2])
  
  #scale to an annual ammount (assume 250 trading days)
  Effective.Annual.Ret = Cum.Ret*n
  
  return(Effective.Annual.Ret)
}