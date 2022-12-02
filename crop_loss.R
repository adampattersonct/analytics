rm(list=ls())
setwd("~/Desktop/Sandro Research")
install.packages("usmap")
library(reshape2)
library(geosphere)
library(usmap)

#### Calculating Total Soy Area
data<-read.csv("soy_census1.csv")
data1<-read.csv("fips_codes.csv")
data$CV....<-NULL

data$County.ANSI<-as.numeric(data$County.ANSI)
data$County.ANSI<-ifelse(data$County.ANSI<10,paste(0,data$County.ANSI),data$County.ANSI)
data$County.ANSI<-gsub(" ","",data$County.ANSI)

if (data$County.ANSI < 100){
  data$County.ANSI<-paste(0,data$County.ANSI)
} else {
  data$County.ANSI<-data$County.ANSI
}

data$County.ANSI<-paste(0,data$County.ANSI)
data$County.ANSI<-gsub(" ","",data$County.ANSI)
data$County.ANSI<-substr(data$County.ANSI,nchar(data$County.ANSI)-2,nchar(data$County.ANSI))
data$fips<-paste0(data$State.ANSI,data$County.ANSI)

#load fips locations with uogd within 25km
fips<-read.csv("fips_uogd.csv")
uogd<-fips$fips

total_area<-NA
for (i in 1:nrow(fips)) {
  wells<-data[data$fips == uogd[i],]
  area<-wells$Value
  total_area<-c(total_area,area)
}
total_area<-total_area[-c(1:2,13)]
total_area<-gsub(",","",total_area)
total_area<-as.numeric(total_area)
mean<-mean(total_area)
missing<-2*mean
sum<-sum(total_area)
total_acres<-sum+missing


#### Calculating Total Corn Area
data<-read.csv("corn_census1.csv")
data1<-read.csv("fips_codes.csv")
data$CV....<-NULL

data$County.ANSI<-as.numeric(data$County.ANSI)
data$County.ANSI<-ifelse(data$County.ANSI<10,paste(0,data$County.ANSI),data$County.ANSI)
data$County.ANSI<-gsub(" ","",data$County.ANSI)

if (data$County.ANSI < 100){
  data$County.ANSI<-paste(0,data$County.ANSI)
} else {
  data$County.ANSI<-data$County.ANSI
}

data$County.ANSI<-paste(0,data$County.ANSI)
data$County.ANSI<-gsub(" ","",data$County.ANSI)
data$County.ANSI<-substr(data$County.ANSI,nchar(data$County.ANSI)-2,nchar(data$County.ANSI))
data$fips<-paste0(data$State.ANSI,data$County.ANSI)

#load fips locations with uogd within 25km
fips<-read.csv("fips_uogd.csv")
uogd<-fips$fips

total_area<-NA
for (i in 1:nrow(fips)) {
  wells<-data[data$fips == uogd[i],]
  area<-wells$Value
  total_area<-c(total_area,area)
}
total_area<-total_area[-c(1,57)]
total_area<-gsub(",","",total_area)
total_area<-as.numeric(total_area)
total_acres<-sum(total_area)


