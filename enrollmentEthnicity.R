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
#Code 0 = Not Reported (Added from in 2007)
#Code 1 = American Indian or Alaska Native
#Code 2 = Asian
#Code 3 = Pacific Islander
#Code 4 = Filipino
#Code 5 = Hispanic or Latino
#Code 6 = African American, not Hispanic
#Code 7 = White, not Hispanic
#Code 8 = Multiple or No Response
#Code 9 = Two or More Races, Not Hispanic ( Replaces number 8 after 2007)



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




# For the year 2001-2002
dat2001<-read.table("filesenr.asp01.txt",sep='\t',fill = TRUE, header = TRUE)
dat2001$HSenrollment<-dat2001$GR_9+dat2001$GR_10+dat2001$GR_11+dat2001$GR_12
#Aggregate enrollment by school 
enrollment_agg <-dat2001 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2001 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat1<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat1$year<-rep(2001,nrow(dat1))




# For the year 2002-2003
dat2002<-read.table("filesenr.asp02.txt",sep='\t',fill = TRUE, header = TRUE)
dat2002$HSenrollment<-dat2002$GR_9+dat2002$GR_10+dat2002$GR_11+dat2002$GR_12
enrollment_agg <-dat2002 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2002 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat2<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat2$year<-rep(2002,nrow(dat2))




# For the year 2003-2004
dat2003<-read.table("filesenr.asp03.txt",sep='\t',fill = TRUE, header = TRUE)
dat2003$HSenrollment<-dat2003$GR_9+dat2003$GR_10+dat2003$GR_11+dat2003$GR_12
enrollment_agg <-dat2003 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2003 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat3<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat3$year<-rep(2003,nrow(dat3))




# For the year 2004-2005
dat2004<-read.table("filesenr.asp04.txt",sep='\t',fill = TRUE, header = TRUE)
dat2004$HSenrollment<-dat2004$GR_9+dat2004$GR_10+dat2004$GR_11+dat2004$GR_12
enrollment_agg <-dat2004 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2004 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat4<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat4$year<-rep(2004,nrow(dat4))




# For the year 2005-2006
dat2005<-read.table("filesenr.asp05.txt",sep='\t',fill = TRUE, header = TRUE)
dat2005$HSenrollment<-dat2005$GR_9+dat2005$GR_10+dat2005$GR_11+dat2005$GR_12
enrollment_agg <-dat2005 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2005 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat5<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat5$year<-rep(2005,nrow(dat5))




# For the year 2006-2007
dat2006<-read.table("filesenr.asp06.txt",sep='\t',fill = TRUE, header = TRUE)
dat2006$HSenrollment<-dat2006$GR_9+dat2006$GR_10+dat2006$GR_11+dat2006$GR_12
enrollment_agg <-dat2006 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2006 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat6<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat6$year<-rep(2006,nrow(dat6))






### Notice that panel is unbalanced when rbind. Search for CDS Code to make sure not in 2000 or 2001 data
grep(10621170101949, dat$CDSCode)
grep(10621170101949, dat1$CDSCode)

# Take panel that is in all years to make sure grep works
grep(10621171030196, dat$CDSCode)




##### Second half of data aggregation 
###### Starting with 2007, Annual enrollment data takes a different form. 
### Bind all of these data points and then use SmartBind to create final enrollment data WITH POTENTIAL FOR ETHNICITY PERCENTAGES 


# For the year 2007-2008
dat2007<-read.table("filesenr.asp07.txt",sep='\t',fill = TRUE,quote="", header = TRUE)
dat2007$HSenrollment<-dat2007$GR_9+dat2007$GR_10+dat2007$GR_11+dat2007$GR_12
enrollment_agg <-dat2007 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2007 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat7<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat7$year<-rep(2007,nrow(dat7))


# For the year 2008-2009
dat2008<-read.table("filesenr.asp08.txt",sep='\t',fill = TRUE, quote="",header = TRUE)
dat2008$HSenrollment<-dat2008$GR_9+dat2008$GR_10+dat2008$GR_11+dat2008$GR_12
enrollment_agg <-dat2008 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2008 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat8<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat8$year<-rep(2008,nrow(dat8))




# For the year 2009-2010
dat2009<-read.table("filesenr.asp09.txt",sep='\t',fill = TRUE, quote="",header = TRUE)
dat2009$HSenrollment<-dat2009$GR_9+dat2009$GR_10+dat2009$GR_11+dat2009$GR_12
enrollment_agg <-dat2009 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2009 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat9<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat9$year<-rep(2009,nrow(dat9))


# For the year 2010-2011
dat2010<-read.table("filesenr.asp10.txt",sep='\t',fill = TRUE,quote = "",header = TRUE)
dat2010$HSenrollment<-dat2010$GR_9+dat2010$GR_10+dat2010$GR_11+dat2010$GR_12
enrollment_agg <-dat2010 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2010 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat10<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat10$year<-rep(2010,nrow(dat10))



# For the year 2011-2012
dat2011<-read.table("filesenr.asp11.txt",sep='\t', quote = "" , fill = TRUE, header = TRUE)
dat2011$HSenrollment<-dat2011$GR_9+dat2011$GR_10+dat2011$GR_11+dat2011$GR_12
enrollment_agg <-dat2011 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2011 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat11<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat11$year<-rep(2011,nrow(dat11))



# For the year 2012-2013
dat2012<-read.table("filesenr.asp12.txt",sep='\t', quote = "" , fill = TRUE, header = TRUE)
dat2012$HSenrollment<-dat2012$GR_9+dat2012$GR_10+dat2012$GR_11+dat2012$GR_12
enrollment_agg <-dat2012 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2012 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat12<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat12$year<-rep(2012,nrow(dat12))


# For the year 2013-2014
dat2013<-read.table("filesenr.asp13.txt",sep='\t', quote = "" , fill = TRUE, header = TRUE)
dat2013$HSenrollment<-dat2013$GR_9+dat2013$GR_10+dat2013$GR_11+dat2013$GR_12
enrollment_agg <-dat2013 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2013 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat13<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat13$year<-rep(2013,nrow(dat13))



# For the year 2014-2015
dat2014<-read.table("filesenr.asp14.txt",sep='\t', quote = "" , fill = TRUE, header = TRUE)
dat2014$HSenrollment<-dat2014$GR_9+dat2014$GR_10+dat2014$GR_11+dat2014$GR_12
enrollment_agg <-dat2014 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2014 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat14<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat14$year<-rep(2014,nrow(dat14))


# For the year 2015-2016
dat2015<-read.table("filesenr.asp15.txt",sep='\t', quote = "" , fill = TRUE, header = TRUE)
dat2015$HSenrollment<-dat2015$GR_9+dat2015$GR_10+dat2015$GR_11+dat2015$GR_12
enrollment_agg <-dat2015 %>% group_by(CDS_CODE) %>% summarise(HSenrollment=sum(HSenrollment))
# Aggregate enrollment by school and ethnicity 
enrollment_perc <-dat2015 %>% group_by(CDS_CODE,ETHNIC) %>% summarise(HSenrollment=sum(HSenrollment))
# Get percent of each ethnicity per school
school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))
# Reshape data to have column with Percent of Hs enrollment for each ethnicity 
z<-cast(school_enrollment, CDS_CODE ~ ETHNIC, value = "percent")
#Write aggregate enrollment to z data
z$HSEnrollment<-enrollment_agg$HSenrollment[match(z$CDS_CODE,enrollment_agg$CDS_CODE)]
# Match on CDSCode and pull HS enrollment variable 
dat15<-merge(z, scho, by = "CDS_CODE")
# Create year variable to SmartBind with 2007-2015 formatted data 
dat15$year<-rep(2015,nrow(dat15))


# Direct Smart Bind each year.  
agg_data<-smartbind(dat,dat1,dat2,dat3,dat4,dat5,dat6,dat7,dat8,dat9,dat10,dat11,dat12,dat13,dat14,dat15)
# Subset data with HS Enrollment total greater than 0 to just get information for High School 
data<-agg_data[as.numeric(agg_data$HSEnrollment) >0, ]

# Create panel data by sorting by CDS_COde
pan<-data[order(data$CDS_CODE),]

# Move year variable next to CDS Code
colnames(pan)[61]<-"O"
colnames(pan)[62]<-"nin"
library(tibble)
pan<-add_column(pan, yr = pan$year, .after = 1)
pan<-add_column(pan, zero = pan$O, .after = 2)
pan<-add_column(pan, nine = pan$nin, .after = 11)

pan[,62:ncol(pan)]<-NULL

# Name columns appropriate ethnicity 
colnames(pan)[3]<-"notReport"
colnames(pan)[4]<-"Indian/Alaskian"
colnames(pan)[5]<-"Asian"
colnames(pan)[6]<-"Pacific Islander"
colnames(pan)[7]<-"Filipino"
colnames(pan)[8]<-"hispanicLatino"
colnames(pan)[9]<-"africanAmerican"
colnames(pan)[10]<-"White"
colnames(pan)[11]<-"Multiple"
colnames(pan)[12]<-"Multiple2"

# Check all percentages add up to 1 for given school in a year 
pan$new<-rowSums(pan[,3:12],na.rm = TRUE)
pan$new<-NULL
# Write CSV file to dropbox 
write.csv(pan, "HSenrollment_ethnicity00-15.csv")
