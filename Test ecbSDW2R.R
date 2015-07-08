## Test ecbSDW2R


#

series.key <- "IVF.Q.U2.N.T0.A30.A.1.Z5.0000.Z01.E" 
series.key <- "IVF.M.U2.N.T0.T00.A.1.Z5.0000.Z01.E"
#IVF.Q.U2.N.T0.A5A.A.1.Z5.0000.Z01.E
series.key <- "ICPF.Q.U.N.T0.A30.blabla"
series.key <- "BSI.M.U2.Y.V.M30.X.I.U2.2300.Z01.A"






data <- get.sdw.series(series.key)
data <- as.time.series(data=data, freq="m")



head(data)


library(ggplot2)
ggplot(data, aes(x = obsTime)) + 
  geom_line(aes(y = obsValue), size = 0.9)


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