#
#  Time series with basic R: ts data structure and plot.ts
#
c(1,4,5,3,6,5,2,8,8,7,9,10)
mydata <- c(1,4,5,3,6,5,2,8,8,7,9,10)
mydata
plot()
help(ts)
myts <- ts(mydata)
plot(myts)
myts2 <- ts(mydata, start=2024, end= 2025)
plot(myts2)
myts2 <- ts(mydata, start=2024, end= 2025, frequency= 12)
plot(myts2)
myts2 <- ts(mydata, start=c(2024,1), end= c(2024,12), frequency= 12)
plot(myts2)
plot.ts(myts2)
myts2
help(plot.ts)
myts2 <- ts(mydata, start=c(2024,1), end= c(2024,12), frequency= 12)
plot.ts(myts2, xy.labels= TRUE)
#
# Issues with importing time series data into R (dates)
mytimedata <- read.csv("/home/employee/aleahy/stat223/Data/tuition-series.csv")
View(mytimedata)
help(typeof)
typeof(mytimedata$Year)
help("as.Date")
as.Date(mytimedata$Year)
as.Date("01/01/76")
typeof(as.Date("01/01/76", tryFormats= c("%d/%m/%y")))
as.Date(mytimedata$Year, tryFormats= c("%d/%m/%y") )
mytimedata$year <- as.Date(mytimedata$Year, tryFormats= c("%d/%m/%y") )
mytuition <- ts(mytimedata$tuition, begin=1966)
mytuition <- ts(mytimedata$tuition, begin=1966, end=2020)
mytuition <- ts(mytimedata$tuition, start=1966, end=2020)
plot(mytuition)
#
# Simulating common time series data with the simts package
#
library(simts)
help(gen_gts)
#
# Simulating and plotting 'white noise' normal distributions
#  (Note a difference time series appears each time we plot)
#
gen_gts(100, WN(sigma2 = 1))
myts3 <- gen_gts(100, WN(sigma2 = 1))
plot(myts3)
myts3 <- gen_gts(100, WN(sigma2 = 1))
plot(myts3)
myts3 <- gen_gts(100, WN(sigma2 = 1))
plot(myts3)
#
#  Plotting a simulated random walk
#
myts3 <- gen_gts(100, RW(gamma2 = 1))
plot(myts3)
myts3 <- gen_gts(200, RW(gamma2 = 1))
plot(myts3)
myts3 <- gen_gts(300, RW(gamma2 = 1))
plot(myts3)
#
# Plotting AR1 and MA1 time series with simts
#
model = AR1(phi = .5, sigma2 = .1) + WN(sigma2=1)
x = gen_gts(300, model)
plot(x)
model = AR1(phi = .5, sigma2 = .1)
x = gen_gts(300, model)
plot(x)
model = MA1(phi = .5, sigma2 = .1)
model = MA1(sigma2 = .1)
