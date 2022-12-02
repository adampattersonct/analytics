rm(list=ls())

setwd("~/Desktop/Sandro Research")
require(sf)
library(rgdal)
library(plyr)
shape <- st_read('~/Desktop/Sandro Research/Public_Land_Survey_System_(PLSS)%3A_Township_and_Range.shp')
centroid<-st_centroid(shape)
## According to https://stackoverflow.com/questions/61369386/get-longitude-and-latitude-from-a-shapefile-with-leaflet-in-r/61371842#61371842, warning may not matter
## with smaller sized polygons. Warning message should be acceptable to proceed in our case ?
xy<-st_coordinates(centroid)
tx_coordinates<-st_transform(centroid, "+proj=longlat +ellps=WGS84 +datum=WGS84")
centroid<-cbind(centroid,st_coordinates(tx_coordinates))

# Summary of meridian 
summary(as.factor(shape$Meridian))

# Let us assume HM is humboldt, MDM is mount diablo, and SBM is san bernardino 
centroid$MeridianCode<-revalue(centroid$Meridian, c(HM = "H",SBM="S",MDM="M"))
centroid$Township<-substr(centroid$Township,2,nchar(centroid$Township))
centroid$Range<-substr(centroid$Range,2,nchar(centroid$Range))


#M,TTD,RRD format
centroid$MTR<-paste0(centroid$MeridianCode,centroid$Township,centroid$Range)


########### Create matching variable from field tag
setwd("~/Desktop/Sandro Research/geocode/")
library(R.utils)
library(dplyr)
library(sharpshootR)
gunzip("field_tag.csv.gz", remove=FALSE)

dat<-read.csv("field_tag.csv")
# Load county code mapping and split column
code<-read.csv("county_code.csv")
code$county<-tolower(substr(code$County.codes,6,nchar(code$County.codes)))
code$code<-substr(code$County.codes,1,2)

# Match county code to field tag csv through matched county
match(tolower(dat$couty_name),code$county)
code$code[match(tolower(dat$couty_name),code$county)]
dat$county_code<-code$code[match(tolower(dat$couty_name),code$county)]


# Add leading 0's for township and range columns 
dat$township<-sprintf("%02d", as.numeric(dat$township))
dat$range<-sprintf("%02d", as.numeric(dat$range))

# Create COMTRS variable (if needed in future analysis)
dat$COMTRS<-paste0(dat$county_code,dat$base_ln_mer,dat$township,dat$tship_dir,dat$range,dat$range_dir,dat$section)

# Create MTR variable from shapefile available variables to match 
dat$MTR<-paste0(dat$base_ln_mer,dat$township,dat$tship_dir,dat$range,dat$range_dir)



# Convert Lon values to field tag data 
match(dat$MTR,centroid$MTR)
centroid$X[match(dat$MTR,centroid$MTR)]
dat$lon<-centroid$X[match(dat$MTR,centroid$MTR)]

# Convert Lat values to field tag data 
match(dat$MTR,centroid$MTR)
centroid$Y[match(dat$MTR,centroid$MTR)]
dat$lat<-centroid$Y[match(dat$MTR,centroid$MTR)]


head(dat)
# First observation belongs to proper TMR using https://www.earthpoint.us/TownshipsCaliforniaSearchByLatLon.aspx  lat centroid is off by.015
## Second obs is approx to 3 decimal places 
# Third observation belongs to proper township from earthpoint.org, approx up until 3 decimal places 

tail(dat)
# Second observation checks out up until 2 and 3 decimal places
# Fifth observation checks out 

colnames(dat)[10]<-"TMR"

write.csv(dat,"field_tag_TMR.csv")


