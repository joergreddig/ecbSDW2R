# Jörg Reddig
# 21.4.2015
# geklaut von: 


#https://github.com/joergreddig/ecbSDW2R


# --------------------------------------------------------------------------------------
# Author: Graeme Walsh Date: 21/10/2014
# Title: "ECB SDW Example 2.R"
# Description: A script demonstrating how to retrieve data from ECB SDW.
# Note: This example involves using the ECB SDW API.
# --------------------------------------------------------------------------------------

# TODO(JR): 
# write function that retrieves data from SDW and stores it into a dataframe
# function should allow for options from ECB SDW API
# how to retrieve data from internal SDW? -> internal reference page
# make a package on Github!
# use wildcards!
# decide between fix gesmes keys or individually assembled keys


# have an internal and external version of a functino to download the data!




# Step 0: Load packages.
# The XML package is used later on to parse the XML retrieved from SDW.
# For a tutorial on XML and parsing XML documents, read this: http://www.w3schools.com/xpath/default.asp
# An introduction to the XML package can be found here: http://www.omegahat.org/RSXML/shortIntro.pdf
# The RCurl package is used to send the request to the server in order to retrieve the data.

# library(XML)
# library(RCurl)
library(rsdmx)
library(stringr)

# Step 1: Construct the appropriate REST query.
# First read this: https://sdw-wsrest.ecb.europa.eu/documentation/index.jsp
# https://github.com/sdmx-twg/sdmx-rest/wiki/Tips-for-consumers

# Specify the data to be retrieved.


series.key <- "IVF.Q.U2.N.T0.A30.A.1.Z5.0000.Z01.E" 
#IVF.Q.U2.N.T0.A5A.A.1.Z5.0000.Z01.E
series.key <- "ICPF.Q.U.N.T0.A30.blabla"
series.key <- "BSI.M.U2.Y.V.M30.X.I.U2.2300.Z01.A"

regex <- "([A-z])+"


# str_replace(string, regular expression, replacement string) -- replaces the first matched pattern and returns a character vector #str_replace(series.key, regex, "")


# str_extract(string, regular expression) -- extracts text corresponding 
# to the first match
dataflow <- str_extract(series.key, regex)

char.length <- str_length(dataflow)

# extract string as of the second argument
key <- substring(series.key, char.length + 2)




resource    <- "data"
#key         <- "M.U2.Y.V.M30.X.I.U2.2300.Z01.A"


#interne daten können so nicht gelesen werden? Wie geht es sonst? Andere URL?
# dataflow <- "SHS"
# key <- "Q.AT.I7.S12K.S122._X.LE.F3._Z.EUR.M.I.N.A._X._X.R._T.ZZZ"

# All the data stored in the Statistical Data Warehouse can be retrieved using the query string described below.
# 
# protocol://wsEntryPoint/resource/flowRef/key?parameters
# 
# where parameters are defined as such:
#   startPeriod=value&endPeriod=value&updatedAfter=value&firstNObservations=value&lastNObservations=value&detail=value&includeHistory=value
# 
# Examples:
# https://sdw-wsrest.ecb.europa.eu/service/data/EXR/M.USD+GBP+JPY.EUR.SP00.A?updatedAfter=2009-05-15T14%3A15%3A00%2B01%3A00
# https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.USD.EUR.SP00.A?startPeriod=2009-05-01&endPeriod=2009-05-31
# 



#BSI.M.U2.Y.V.M30.X.I.U2.2300.Z01.A 

# Construct the query

base_url    <- "http://sdw-wsrest.ecb.europa.eu/service/"
partial_url <- paste(resource, dataflow, key, sep="/")
rest_query  <- paste0(base_url, partial_url)

# Step 2: Make the request using cURL (that is, retrieve the data)
# For information about cURL, read this: http://curl.haxx.se/
# For information about the curl command, check out the man pages: http://curl.haxx.se/docs/manpage.html

# command   <- paste("curl", rest_query)
#raw_data  <- system(command, intern=TRUE)  #JR: doesn't seem to work

# An alternative method is to use getURL() from the RCurl package.

# raw_data <- getURL(rest_query)

# Note: at this stage, the data is a character object.

# class(raw_data)

# Step 3: Parse the data
# Here we use functions from the XML package - one could, of course, use base package functions, but why?

# data <- xmlParse(raw_data)

# Parsing the data returns an object of class: "XMLInternalDocument" and "XMLAbstractDocument"

# class(data)

# Step 4: Extract the numerical data 



#==============JR:=================

# xml_data <- xmlToList(data)
# tmp <- system.file("extdata","Example_Eurostat_2.0.xml", package="rsdmx")



#JRrest_query enthält die URL vom SDMX file
sdmx <- readSDMX(rest_query)

stats <- as.data.frame(sdmx)

plot.ts(stats$obsValue)

m3growth <- stats[ , c("obsTime", "obsValue")]


library(zoo)
stats$ObsTime <- read.zoo(stats$ObsTime, FUN = as.yearmon)

stats$m3growth <- as.Date(stats$m3growth, format="%Y-%m")


m3 <- as.xts(m3growth)



str(m3growth)

stats1 <- as.data.frame(sdmx)

head(stats1$obsvalue)

# To be continued...

# End of script.
