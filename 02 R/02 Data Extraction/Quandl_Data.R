# Querying Quandl for data
# Michael Beven
# 20151017

require(Quandl)

# Set parameters
start_date = "2015-10-01"
end_date = "2015-10-10"
symbol = "NSE/OIL"
api_key = "v21snmSix9KyXBWc1RkF"

# Query Quandl
Quandl.api_key(api_key) # optional for free data sets
data.info = Quandl::Quandl(c(symbol))

# Select subdata
sub.data.info = subset(data.info, data.info$Date >= as.Date(start_date) & 
                         data.info$Date <= as.Date(end_date))