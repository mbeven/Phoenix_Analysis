# Querying YAHOO! Finance for data
# Michael Beven
# 20151017

Yahoo_Data = function(start_date,end_date,symbol){

# Parameters
URL = paste("http://ichart.finance.yahoo.com/table.csv?s=",symbol,sep="")

# Read in data
data.info = read.csv(URL)
data.info$Date = as.Date(data.info$Date, "%Y-%m-%d")

# Get subset of data
sub.data.info = subset(data.info, data.info$Date >= as.Date(start_date) & 
                         data.info$Date <= as.Date(end_date))


return(sub.data.info)

}