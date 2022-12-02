rm(list=ls())

setwd("~/Dropbox/Andrew Chia/covariates/Enrollment")

dat<-read.table("pubschls.txt",sep='\t',fill = TRUE, header = TRUE)
str(dat)

library(dplyr)
library(openxlsx)
library(readxl)
library(tibble)
setwd("~/Desktop/caliCovariates")
dat<-read_xls("zptab02ca.xls")

empty<-which(is.na(dat$`Table 1-- Individual Income Tax Returns: Selected Income and Tax Items by State, ZIP Code, and Size of Adjusted Gross Income, Tax Year 2002`))
cut<-dat[-empty,]

#Add NA column after the first column to map zip code values into 
cut<-add_column(cut, zipcode = NA, .after = 1)
head(cut)
# Delete state aggregate results (rows 1 through 8)
cut<-cut[-c(1,4:8),]
# Write zip codes over into zip code column 
colnames(cut)[1]<-"ID"

cut<-cut %>%
  mutate(Status = case_when(
    startsWith(ID, "9") ~ "1",
  ))


#Add 0 into Status column to loop easier
cut$Status[which(is.na(cut$Status))]<-0


for (i in 1:nrow(cut)) {
  if (cut$Status[i]==1) {
    cut$zipcode[i]<-cut$ID[i]
    cut$zipcode[i+1]<-cut$ID[i]
    cut$zipcode[i+2]<-cut$ID[i]
    cut$zipcode[i+3]<-cut$ID[i]
    cut$zipcode[i+4]<-cut$ID[i]
  } else {
    NA
  }
}


# Create average AGI (adjusted gross income) per income bracket 
cut$avgAGI<-((as.numeric(cut$...5))/as.numeric((cut$...2)))
cut$avgAGIpp<-cut$avgAGI*1000

# Take out aggregate zip code data from each zip code (to calculate proportions/weights)
cut1<-cut[-which(cut$Status==1),]

# Calc percent of each tax bracket in each zip code
weights<-cut1 %>% group_by(zipcode) %>% mutate(percent=prop.table(as.numeric(...2)))
# Multiply weights by income for each bracket 
weights$weightedBracket<-(weights$avgAGIpp)*(weights$percent)
# Aggregate weighted income by zipcode 
weighted<-weights %>% group_by(zipcode) %>% summarise(sum=sum(weightedBracket))

weighted1<-aggregate(weights$weightedBracket,list(weights$zipcode),sum)







school_enrollment<-enrollment_perc %>% group_by(CDS_CODE) %>% mutate(percent = prop.table(HSenrollment))























depr_df <- depr_df %>%
  add_column(Is_Depressed = 
               if_else(.$DeprIndex < 18, TRUE, FALSE),
             .after="ID")

starts


depr_df <- depr_df %>%
  add_column(Is_Depressed = 
               if_else(.$DeprIndex < 18, TRUE, FALSE),
             .after="ID")



depr_df <- cut1 %>%
  add_column(zip= 
               if_else(.$DeprIndex < 18, TRUE, FALSE),
             .after="cut$`Table 1-- Individual Income Tax Returns: Selected Income and Tax Items by State, ZIP Code, and Size of Adjusted Gross Income, Tax Year 2002`"

             
             
             
             
             
             
             
             
             
