rm(list=ls())

setwd("~/Desktop/Sandro Research/chemical_data")
setwd("~/Dropbox/Andrew Chia/chemical_data/")
library(stringr)

chem<-read.table("chemical.txt", sep=",", fill=TRUE, header=TRUE)
cas<-read.table("chem_cas.txt", sep=",", fill=TRUE, header=TRUE)
product<-read.table("product.txt", sep=",", fill=TRUE, header=TRUE)
site<-read.table("site.txt", sep=",", fill=TRUE, header=TRUE)
formula<-read.table("formula.txt", sep=",", fill=TRUE, header=TRUE)





## Loading OSHA values 

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






















agrep("herb",product$product_name)


# List of most uses chem codes within database. They are not unique to each product. Chemicals within compound formula used for application
sort(summary(as.factor(cas$casnum)),decreasing = TRUE)



chem$chem_code
cas$chem_code

cas$chem_code










# Load threshold values retrieved from https://www.dir.ca.gov/title8/ac1.pdf, more specifically https://www.osha.gov/chemical-hazards. 
# OSHA gives Cali their own chemical permissable exposure limits. I can see hesitancy to use OSHA given we are modeling non-occupational pesticide use
# but could be a very conservative exposure cutoff estimate. 
setwd("~/Desktop/Sandro Research/")
cutoff<-read.csv("thresh.csv")

#Data Management . turn NA values into last observation. 
cutoff$CARN[which(cutoff$CARN=="" )]<-NA
id<-na.locf(cutoff$CARN)

cutoff$CARN<-id

# Bring over chemical names for reference amongst matching CARN
match(cas$chem_code,chem$chem_code)
chem$chemname[match(cas$chem_code,chem$chem_code)]
cas$chemname<-chem$chemname[match(cas$chem_code,chem$chem_code)] 

# Modify California Abstract Registry Number 
cas$CARN<-gsub("-","",cas$casnum)
cas$CARN<-str_trim(cas$CARN)


# Aggregate cutoff threshold by ID. Usually we would use mean, but duplicate ID values only have 1 row of data. It is either or reporting. 
aggregate_values1<-aggregate(as.numeric(cutoff$mg.m_pel),list(cutoff$CARN),mean)
aggregate_values<-aggregate(as.numeric(cutoff$mg.m_pel),list(cutoff$CARN),sum)

#exploring results
x2<-which(aggregate_values1$x == aggregate_values$x)
x2<-which(aggregate_values1$x != aggregate_values$x)
data<-aggregate_values[x2,]
x<-which(is.na(aggregate_values1$x))
x1<-which(is.na(aggregate_values$x))

# Pel is permissible exposure limit, as defined by section 5155(b) and (c)(1). The maximum permitted 8-hour time-weighted average concentration of an airborne contaminant
# Stel is short term exposure limit, as defined by  sections 5155(b) and (c)(2). 
# https://www.dir.ca.gov/title8/5155.html
merged<-merge(cas,cutoff, by="CARN")

## this soultion is creates a more compact dataset than the merged option above
match(cas$CARN,aggregate_values1$Group.1)
aggregate_values1$x[match(cas$CARN,aggregate_values1$Group.1)]
cas$mg.m_pel1<-aggregate_values1$x[match(cas$CARN,aggregate_values1$Group.1)]

# appears to be 5 liters. Not sure how to handle this unit comparative to others in creating a column?
cas[309,]

# Subset na index, and remove from dataset
len<-which(is.na(cas$mg.m_pel))
len1<-cas[-len,]

# Mg/M is Milligrams of substance per cubic meter of air at 25°C and 760mm Hg pressure. Mg/m_pel is 8 hour air cutoff
# Subset to only use mg/M. I kept matched name in dataset so that we can verify all duplicates and avg by group if necessary. 
# Looking through the data, I can see that most duplicate names have only 1 row of mg/m values. That is just from quick visual check 
data<-merged[,c(1,2,4,7:9)]
head(data)

write.csv(len1,"chemicalCutoffOSHA.csv")