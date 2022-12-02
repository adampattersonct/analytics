library(haven)
install.packages("gtools")
library(gtools)
library(fixest)
library(texreg)
library(ggplot2)
library(iplots)
library(car)

rm(list=ls())

setwd(paste0("~/Desktop/year201",2))

setwd("~/Desktop/year2010")

## 2010  (All years are in separate folders)
# Load all files from folder into environment 
myFiles <- mixedsort(list.files("~/Desktop/year2010"))
my.data <- lapply(myFiles, read_dta)

mat<-matrix(NA,nrow=1,ncol=4)
`colnames<-`(mat,c("fips","year","temp","prec"))

for (i in 1:length(my.data)) {
  x<-as.data.frame(my.data[i])
  prec<-mean(x[,5])
  t1<-mean(x[,3])
  t2<-mean(x[,4])
  temp<-(t1+t2)/2
  fips<-substr(myFiles[i],5,nchar(myFiles[i])-4)
  year<-substr(x[1,2],1,4)
  bind<-cbind(fips,year,temp,prec)
  mat<-rbind(mat,bind)
}





mat<-matrix(NA,nrow=1,ncol=4)
`colnames<-`(mat,c("fips","year","temp","prec"))

## 2010  (All years are in separate folders)
# Load all files from folder into environment 
for (i in 0:9) {
setwd(paste0("~/Desktop/year201",i))  
myFiles <- mixedsort(list.files(paste0("~/Desktop/year201",i)))
my.data <- lapply(myFiles, read_dta)

for (i in 1:length(my.data)) {
  x<-as.data.frame(my.data[i])
  prec<-mean(x[,5])
  t1<-mean(x[,3])
  t2<-mean(x[,4])
  temp<-(t1+t2)/2
  fips<-substr(myFiles[i],5,nchar(myFiles[i])-4)
  year<-substr(x[1,2],1,4)
  bind<-cbind(fips,year,temp,prec)
  mat<-rbind(mat,bind)
}
}

setwd("~/Desktop/Sandro Research")
write.csv(mat,"2010-2019covariates.csv")

head(mat)
tail(mat)




one<-read.csv("2010-2015covariates.csv")
two<-read.csv("2017-2019covariates.csv")
final<-rbind(one,two)
write.csv(final,"2010-2019covariates.csv")






x<-as.data.frame(my.data[3])
x

assign(mat,paste0("mat_201",2))

for (i in 9:9) {
  assign(paste0("mat_201",i),mat)
}













mat<-matrix(NA,nrow=1,ncol=4)
`colnames<-`(mat,c("fips","year","temp","prec"))



setwd("~/Desktop/year2016")

## 2010  (All years are in separate folders)
# Load all files from folder into environment 
myFiles <- mixedsort(list.files("~/Desktop/year2016"))
my.data <- lapply(myFiles, read_dta)

for (i in 1:length(my.data)) {
  x<-as.data.frame(my.data[i])
  prec<-mean(x[,5])
  t1<-mean(x[,3])
  t2<-mean(x[,4])
  temp<-(t1+t2)/2
  fips<-substr(myFiles[i],5,nchar(myFiles[i])-4)
  year<-substr(x[1,2],1,4)
  bind<-cbind(fips,year,temp,prec)
  mat<-rbind(mat,bind)
}




setwd("~/Desktop/year2017")

## 2010  (All years are in separate folders)
# Load all files from folder into environment 
myFiles <- mixedsort(list.files("~/Desktop/year2017"))
my.data <- lapply(myFiles, read_dta)


for (i in 1:length(my.data)) {
  x<-as.data.frame(my.data[i])
  prec<-mean(x[,5])
  t1<-mean(x[,3])
  t2<-mean(x[,4])
  temp<-(t1+t2)/2
  fips<-substr(myFiles[i],5,nchar(myFiles[i])-4)
  year<-substr(x[1,2],1,4)
  bind<-cbind(fips,year,temp,prec)
  mat<-rbind(mat,bind)
}


setwd("~/Desktop/year2018")

## 2010  (All years are in separate folders)
# Load all files from folder into environment 
myFiles <- mixedsort(list.files("~/Desktop/year2018"))
my.data <- lapply(myFiles, read_dta)

for (i in 1:length(my.data)) {
  x<-as.data.frame(my.data[i])
  prec<-mean(x[,5])
  t1<-mean(x[,3])
  t2<-mean(x[,4])
  temp<-(t1+t2)/2
  fips<-substr(myFiles[i],5,nchar(myFiles[i])-4)
  year<-substr(x[1,2],1,4)
  bind<-cbind(fips,year,temp,prec)
  mat<-rbind(mat,bind)
}


setwd("~/Desktop/year2019")

## 2010  (All years are in separate folders)
# Load all files from folder into environment 
myFiles <- mixedsort(list.files("~/Desktop/year2019"))
my.data <- lapply(myFiles, read_dta)

for (i in 1:length(my.data)) {
  x<-as.data.frame(my.data[i])
  prec<-mean(x[,5])
  t1<-mean(x[,3])
  t2<-mean(x[,4])
  temp<-(t1+t2)/2
  fips<-substr(myFiles[i],5,nchar(myFiles[i])-4)
  year<-substr(x[1,2],1,4)
  bind<-cbind(fips,year,temp,prec)
  mat<-rbind(mat,bind)
}

setwd("~/Desktop/Sandro Research")
write.csv(mat,"2017-2019covariates.csv")
