#
# Some R notes from 04-11-24 Class
#

#
# Loading and viewing CSV and XLSX files into R
#
list.files("/home/courses/S223_1/CNotes/")
mydata2 <- read.csv("/home/courses/S223_1/CNotes/firstdaydata.csv")
View(mydata2)
list.files("/home/courses/S223_1/CNotes/")
install.packages("readxl")
library("readxl")
help(read_excel)
read_excel("/home/courses/S223_1/CNotes/examscores.xlsx")
somescore <- read_excel("/home/courses/S223_1/CNotes/examscores.xlsx")
View(somescore)
#
# Working with vectors and dataframes in R
#
c(1,2,3,2,3,4,5,3,4,6)
mynumbers <- c(1,2,3,2,3,4,5,3,4,6)
mean(mynumbers)
sd(mynumbers)
cor(mydata$height, mydata$wingspan)
head(mynumbers)
summary(mynumbers)
summary(mydata$knoxyear)
table(mydata$knoxyear)
#
# Some plotting with basic R
#
help("pie")
pie(table(mydata$knoxyear))
pie(table(mydata$knoxyear), label=c(1,2,3,4))
pie(table(mydata$knoxyear), label=names(mydata$knoxyear))
plot(mydata$height, mydata$wingspan)
plot(mydata$height, mydata$wingspan, title= "My Title",xlab="My X Label")
#
# Filtering and subsetting with basic R
#
mydata[gender=="Male"]
mean(age[gender=="Male"])
mydata[mydata$gender=="Male"]
mydata[mydata$gender=="Male",]
newdata <- mydata[mydata$gender=="Male",]
View(newdata)
newdata$age
mean(newdata$age)
#
# Linear models with R
#
help(lm)
lm(mydata$height ~ mydata$wingspan )
lm(height ~ wingspan, mydata )
mylm <- lm(height ~ wingspan, mydata )
summarize(mylm)
summary(mylm)
hist(mydata$wingspan)
#
# Using ggplot for plotting
#
library("ggplot2")
ggplot(mydata,aes(x=wingspan, y = height))
ggplot(mydata,aes(x=wingspan, y = height)) + geom_point()
ggplot(mydata,aes(x=wingspan, y = height, color= gender)) + geom_point()
ggplot(mydata,aes(x=wingspan, y = height, color= gender),size=cubit) + geom_point()
ggplot(mydata,aes(x=wingspan, y = height, color= gender,size=cubit)) + geom_point()
list.files("/home/courses/S223_1/CNotes")
birthdata <- read.csv("/home/courses/S223_1/CNotes/birthsmokers.csv")
View(birthdata)
ggplot2(birthdata, aes(x = Gest, y = Wgt, color = Smoke)) +geom_point()
ggplot(birthdata, aes(x = Gest, y = Wgt, color = Smoke)) +geom_point()
#
# Working with tidyverse pipelines
#
library(tidyverse)
mydata |> filter(gender == "Male")
mydata |> filter(gender == "Male") |> select(height)
mydata |> filter(gender == "Male") |> select(height) |> summarize(mean=mean(height))
