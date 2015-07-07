##===============================
## Joerg Reddig
## 21.4.2015
## ecbSDW2R
## Last Change: 7.7.2015 
##===============================

# Github: https://github.com/joergreddig/ecbSDW2R
# https://sdw-wsrest.ecb.europa.eu/
# A package for downloading ECB SDW data via the API into R



# Load packages
library(rsdmx)
library(stringr)
library(zoo)


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

sdw.query <- function (series.key.elements, internal) {
  
  dataflow    <- series.key.elements$dataflow
  key         <- series.key.elements$key
  resource    <- "data"
  
  # Construct the query
  if(internal==TRUE){
    base_url    <- "http://sdw-wsrest.ecb.europa.eu/service/" # Replace with internal url!
  } else {
    base_url    <- "http://sdw-wsrest.ecb.europa.eu/service/"
  }
  partial_url <- paste(resource, dataflow, key, sep="/")
  rest_query  <- paste0(base_url, partial_url)
  
  # Make the request using the readSDMX function from rsdmx
  sdmx <- readSDMX(rest_query)
}




get.sdw.series <- function(series.key, internal=FALSE) {
  
  series.key.elements <- split.series.key(series.key)
  
  sdmx <- sdw.query(series.key.elements, internal)
  
  # Extract the numerical data 
  retrieved.data <- as.data.frame(sdmx)
  
  retrieved.data <- retrieved.data[, c("obsTime", "obsValue")]
}




#=================




as.time.series <- function(data, freq){
  #determine whether data is monthly or quarterly frequency and convert data to the respective time series
  if (freq=="m"){
    # for monthly data, convert to date format: 
    data$obsTime <-  as.Date(as.yearmon(data$obsTime), frac=1) # konvertiert 2015-01 nach date format 2015-01-31 
  } else if (freq=="q"){
    # for quarterly data to date: 
    data$obsTime <-  as.Date(as.yearqtr(data$obsTime, format="%Y-Q%q"), frac=1) # sdw quarterly format: "%Y-Q%q"
  }
  
  return(data)
}




# End of script.
