##===============================
## Joerg Reddig
## 21.4.2015
## ecbSDW2R
## Last Change: 4.7.2015 
##===============================

# Github: https://github.com/joergreddig/ecbSDW2R
# https://sdw-wsrest.ecb.europa.eu/
# A package for downloading ECB SDW data via the API into R



# TODO(JR): 
# write function that retrieves data from SDW and stores it into a dataframe
# function should allow for options from ECB SDW API
# how to retrieve data from internal SDW? -> internal reference page
# make a package on Github!
# use wildcards!
# decide between fix gesmes keys or individually assembled keys


# have an internal and external version of a functino to download the data!


#confidential data cannot be downloaded via the (internal) SDW API

series.key <- "IVF.Q.U2.N.T0.A30.A.1.Z5.0000.Z01.E" 
#IVF.Q.U2.N.T0.A5A.A.1.Z5.0000.Z01.E
series.key <- "ICPF.Q.U.N.T0.A30.blabla"
series.key <- "BSI.M.U2.Y.V.M30.X.I.U2.2300.Z01.A"

# Load packages
library(rsdmx)
library(stringr)



## Function for cutting the series key into needed parts
split.series.key <- function(series.key) {
  regex <- "([A-z])+"    # regular expression for extracting the first part of the series key

  # str_extract(string, regular expression) -- extracts text corresponding to the first match
  dataflow <- str_extract(series.key, regex)
  
  char.length <- str_length(dataflow)    # length extracted so far
  
  # extract string as of the second argument
  key <- substring(series.key, char.length + 2)
  
  #return dataflow and key in a list
  list(dataflow=dataflow, key=key)
}

# str_replace(string, regular expression, replacement string) -- replaces the first matched pattern and returns a character vector #str_replace(series.key, regex, "")




# Construct the appropriate REST query.

sdw.query <- function (series.key.elements) {
  
  dataflow    <- series.key.elements$dataflow
  key         <- series.key.elements$key
  resource    <- "data"
  
  # Construct the query
  base_url    <- "http://sdw-wsrest.ecb.europa.eu/service/"
  partial_url <- paste(resource, dataflow, key, sep="/")
  rest_query  <- paste0(base_url, partial_url)
  
  # Make the request using the readSDMX function from rsdmx
  sdmx <- readSDMX(rest_query)
}




get.sdw.series <- function(series.key) {
  
  series.key.elements <- split.series.key(series.key)
  
  sdmx <- sdw.query(series.key.elements)
  
  # Extract the numerical data 
  retrieved.data <- as.data.frame(sdmx)
  
  retrieved.data <- retrieved.data[, c("obsTime", "obsValue")]
}





colnames(stats)[2] <- paste(series.key)

plot(stats)




series.keys <- c("IVF.Q.U2.N.10.A30.A.1.Z5.0000.Z01.E", "IVF.Q.U2.N.20.A30.A.1.Z5.0000.Z01.E", "IVF.Q.U2.N.20.A30.A.1.Z5.0000.Z01.E")



for(i in series.keys){
  get.sdw.series(i)
  
  #mehrere reihen herunterladen und all in einen data frame reinstecken mit dem Namen der series als colName. 
  
}




plot.ts(stats$obsValue)

m3growth <- stats[ , c("obsTime", "obsValue")]


ggplot(stats, aes(x=obsTime, y=obsValue)) + geom_line() + scale_x_date(format = "%b-%Y")



library(zoo)
stats$obsTime <- read.zoo(stats$obsTime, FUN = as.yearmon)

stats$m3growth <- as.Date(stats$m3growth, format="%Y-%m")

stats$obsValue <- as.Date(stats$obsValue, format="%Y-%m")

m3 <- as.xts(m3growth)



str(m3growth)

stats1 <- as.data.frame(sdmx)

head(stats1$obsvalue)

# To be continued...

# End of script.
