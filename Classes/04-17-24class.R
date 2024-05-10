#
# Loading the packages
#  Note: the 'data' function gives a list of datasets in the named package
#    and the 'vignette' function gives a list of documentation in a package
#
library(tsibbledata)
data(package="tsibbledata")
library("fpp3")
olympic_running
library("tsibble")
library("tsibbledata")
data(package="tsibble")
data(package="tsibbledata")
vignette(package="tsibbledata")
vignette(package="tsibble")
vignette(intro-tsibble,package="tsibble")
vignette(introtsibble,package="tsibble")
vignette("intro-tsibble",package="tsibble")
#
#  Working with the tsibbledata 'olympic_running' dataset
#   to produce a time series plot of the winning men's 100meter dash time
#
olympic_running
olympic_running |> filter(Length == "100")
olympic_running |> filter(Length == "100") |> filter(Sex == "men")
mens100 <- olympic_running |> filter(Length == "100") |> filter(Sex == "men")
mens100
mens100 |> autoplot()
mens100 |> autoplot(Time)
#
# An example of working converting an external data set
#  into a tsibble
#
library(readr)
temp <- read_csv("~/stat223/Euclid/CNotes/04-17classplay.csv")
View(temp)
temp
temp |> mutate(quarters = yearquarter(TIME_PERIOD))
temp |> mutate(quarters = yearquarter(TIME_PERIOD)) |> as_tsibble(index = quarters, key=c("MEASURE","Reference area"))
#
# another example of a time series plots
#
aus_production
aus_production |> autoplot(Bricks)
