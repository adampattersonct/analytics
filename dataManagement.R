rm(list=ls())

setwd("~/Dropbox/Andrew Chia/covariates/Enrollment/")
library(stringr)
library( dplyr )
library('fastDummies')
#install.packages('fastDummies')


# Load school name and district with identifier to match with covariate data
scho<-read.table("pubschls.txt",sep='\t',fill = TRUE, header = TRUE)
scho$CDS_Code<-scho$CDSCode
scho$CDS_CODE<-scho$CDSCode

# Ethnicity Key
#Code 1 = American Indian or Alaska Native
#Code 2 = Asian
#Code 3 = Pacific Islander
#Code 4 = Filipino
#Code 5 = Hispanic or Latino
#Code 6 = African American, not Hispanic
#Code 7 = White, not Hispanic
#Code 8 = Multiple or No Response


### Start of enrollment data 
# For the year 2000-2001
dat2000<-read.table("filesenr.asp.txt",sep='\t',fill = TRUE, header = TRUE)
# We notice that CDS_code for covariates is in scientific notation. Set computer settings to decimal format. Scipen = 0 converts back to sci notation
options(scipen = 999)
dat2000<-read.table("filesenr.asp.txt",sep='\t',fill = TRUE, header = TRUE)
dat2000$HSenrollment<-dat2000$GR_9+dat2000$GR_10+dat2000$GR_11+dat2000$GR_12
#Aggregate enrollment by school 
enrollment_agg <-dat2000 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2000 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))

# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat$year<-rep(2000,nrow(dat))




#Should have merged school covariate at end but did not want to lose information during. Subset down and then scale back up. 
sub<-data[,c("CDS_CODE","year","0","1","2","3","4","5","6","7","8","9","HSEnrollment")]
# Create panel data by sorting by CDS_COde
pan<-sub[order(data$CDS_CODE),]

#Bring back school covariate data
data1<-merge(sub,scho,by="CDS_CODE")




# Get percentages of race using HS enrollment by CDS code.
school_enrollment1<-dat2000 %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
#It visually works, but check by summing all CDS_Code group percents and making sure they equal 1. Looks good 
##percent1<- school_enrollment %>% group_by(CDS_CODE) %>% mutate(sumPercent=sum(percent))
# Aggregate female and male ethnicities to get total percentage number per ethnic group 
percent<- school_enrollment %>% group_by(CDS_CODE, ETHNIC) %>% mutate(aggPercent =sum(percent))


# Remove female observations to avoid duplicate percentages/information 
#percent<-percent[-which(percent$GENDER== "F"),] # Can't do this...what if only observation for a ethnicity is female and male not reported. Find more clever way to deal with this
# Check sum of percent per school code after dropping female to double check
#percent1<-percent %>% group_by(CDS_CODE) %>% mutate(sumPercent=sum(aggPercent))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(percent, CDS_CODE ~ ETHNIC, value = "aggPercent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]


enrollment_agg <-dat2000 %>% group_by(CDS_CODE) %>% summarise(perc=sum(HSenrollment))


z$HSEnrollment<-percent$HSenrollment[match(z$CDS_CODE,percent$CDS_CODE)]


group <-percent %>% group_by(CDS_CODE,ETHNIC) %>% summarise(perc=sum(aggPercent))


z<-cast(group, CDS_CODE ~ ETHNIC)





colnames(group)
x<-reshape(group, idvar = colnames(group)[1], timevar = colnames(group)[2], direction = "wide")
z<-cast(group, CDS_CODE ~ ETHNIC)
library(reshape)
x<-spread(group, key =colnames(group)[1] , value = colnames(group)[2])
dat<- dummy_cols(group, select_columns = "ETHNIC")



library(reshape2)
reshape()



?dummy_cols

percent1<- percent %>% group_by(CDS_CODE, ETHNIC) %>% mutate(summPercent =sum(percent))

percent<- school_enrollment %>% group_by(CDS_CODE, ETHNIC) %>% mutate(aggPercent =sum(percent))

#Check all CDS_Code group percents sum to 1
percent1<- school_enrollment %>% group_by(CDS_CODE, ETHNIC) %>% mutate(summPercent =sum(percent))



# Each ethnicity is reported per school and grade combination for each sex. I will aggregate the created HS enrollment variable 
# check school_enrollment<-aggregate(dat2000$HSenrollment, by=list(dat2000$CDSCode),sum)
school_enrollment<-aggregate(dat2000$HSenrollment, by=list(dat2000$CDS_CODE),sum)
colnames(school_enrollment)[1]<-"CDS_CODE"
colnames(school_enrollment)[2]<-"HSenrollment"
# merge school enrollment. HS enrollment x is the total in school over all ethnicities. HS enrollment.y is enrollment for each ethnic code. 
school_enrollment<-merge(school_enrollment,dat2000,by="CDS_CODE")
# Match on CDSCode and pull HS enrollment variable 
dat<-merge(school_enrollment, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat$year<-rep(2000,nrow(dat))





percent<-dat2000 %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))



percent %>% 
  group_by(CDS_CODE) %>%
  summarize(totEnroll=sum(HSenrollment))






dat2000 %>% 
  group_by(CDS_CODE) %>%
  summarize(HSenroll=sum(c(GR_9,GR_10,GR_11,GR_12)), hispanics=((sum(ETHNIC==1 & (GR_9 >0|GR_10>0|GR_11>0|GR_12)))/HSenroll))

dat2000 %>% 
  group_by(CDS_CODE) %>%
  summarize(HSenroll=sum(c(GR_9,GR_10,GR_11,GR_12)), hispanics=(sum(ETHNIC==1 & (GR_9 >0|GR_10>0|GR_11>0|GR_12))/HSenroll)*100)




dat2000 %>% 
  group_by(CDS_CODE) %>%
  summarize(HSenroll=sum(c(GR_9,GR_10,GR_11,GR_12)), hispanics=(sum(ETHNIC==5)/HSenroll)*100,)



dat2000 %>%
  mutate()



aggregate(Amount ~ ID + Year, DF, sum)














# For the year 2001-2002
dat2001<-read.table("filesenr.asp01.txt",sep='\t',fill = TRUE, header = TRUE)
dat2001$HSenrollment<-dat2001$GR_9+dat2001$GR_10+dat2001$GR_11+dat2001$GR_12
# Each ethnicity is reported per school and grade combination for each sex. I will aggregate the created HS enrollment variable 
school_enrollment<-aggregate(dat2001$HSenrollment, by=list(dat2001$CDS_CODE),sum)
colnames(school_enrollment)[1]<-"CDS_CODE"
colnames(school_enrollment)[2]<-"HSenrollment"
# merge school enrollment. HS enrollment x is the total in school over all ethnicities. HS enrollment.y is enrollment for each ethnic code. 
school_enrollment<-merge(school_enrollment,dat2001,by="CDS_CODE")
# Match on CDSCode and pull HS enrollment variable 
dat1<-merge(school_enrollment, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat1$year<-rep(2001,nrow(dat1))


















?group_by()







x<-group_by(dat2000,ETHNIC)






































# Merging list of chemicals and their CAS #
chem$cas<-cas$casnum[match(chem$chem_code,cas$chem_code)]

# look for the first NA value mapped from the column to see if it is in cas
which(chem$chem_code==792254)
# Create CARN variable to match with osha given identifier 
chem$CARN<-gsub("-","",chem$cas)
chem$CARN<-str_trim(chem$CARN)

# Make sure CAS # is valid. Search for 514103 online. https://www.chemexper.com/chemicals/supplier/cas/514-10-3+Abietic+acid.html
# The name Abietic acid is the same as the name mapped into chem. 

#Load OSHA cutoff csv to add half-life column
#setwd("~/Desktop/Sandro Research")
setwd("~/Dropbox/Andrew Chia/Adam_assistance")
osha<-read.csv("oshaThreshold.csv")
# write osha theshold to chem
chem$osha<-osha$mg.m3_pel[match(chem$cas,osha$casnum)]

# Load original osha table
dat<-read.csv("TABLE AC-1 PERMISSIBLE EXPOSURE LIMITS FOR CHEMICAL CONTAMINANTS.csv")
dat$CARN<-as.numeric(dat$CARN)
sub<-dat[dat$CARN>0,]

# Match values into chem to verify the original 
chem$ppm_pel<-sub$PPM_pel[match(chem$CARN,sub$CARN)]
chem$mgm3_pel<-sub$MG.M3_pel[match(chem$CARN,sub$CARN)]
# 197 chemicals matched to mgm3 . Greater than the length for ppm_pel
length(which(chem$mgm3_pel >0))
length(which(chem$ppm_pel >0))





