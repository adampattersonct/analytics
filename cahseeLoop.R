## Substitute math score for unique ID value 

#### I apologize that I have not cleaned this up in terms of comments after the loop was completed. I will make it readable when available #####


#rm(list=ls())
library(stringr)
library(stringdist)
library(sf)
library(openxlsx)
library(gtools)
library(reshape2)


# Load Data
setwd("~/Desktop/Txt Files")
data <- st_read("sab1516.gpkg")
data$schnam<-tolower(data$schnam)
data$shape.id<-1:nrow(data)
nces<-read.xlsx("nces_data_f.xlsx") # information mapping school district code to district name in main dataset (see match function near line 123)


## Loops do not work reading in the CAHSEE as there exists unique arguments for different read.tables ####### DO not run block, just proof 
setwd("~/Desktop/Txt Files/Cahsee")
# Load all files from folder into environment 
myFiles <- list.files(pattern="*.txt")
myData<- lapply(myFiles[1],read.table)

dat<-read.table(sep="\t", fill=TRUE, header=TRUE)
colnames<-colnames(data2001)
for (i in 1:15) {
  assign(paste0("cahsee_",i),read.table(file = myFiles[i], sep="\t", fill=TRUE, header=TRUE))
}

l<-list(data2001,data2002,data2003,data2004,data2005)
x<-l[[i]]
head(x)

i=1

head(data3)
for (i in 1:5) {
  assign(paste0("cahsee0",i), l[[i]])
}
################################## Start block
setwd("~/Desktop/Txt Files/Cahsee_txt/")
# Note the unique arguments for different read.tables
data2001<-read.table(file = "CAHSEE01.txt", sep="\t", fill=TRUE, header=TRUE)
data2002<-read.table(file = "CAHSEE02.txt", sep="\t", fill=TRUE, header=TRUE)
data2003<-read.table(file = "CAHSEE03.txt", sep=",", fill=TRUE, header=TRUE)

data2004<-read.table(file = "CAHSEE04.txt", sep=",", fill=TRUE, header=TRUE)
data2005<-read.table(file = "CAHSEE05.txt", sep="\t", fill=TRUE, header=TRUE)
data2007<-read.table(file = "CAHSEE07.txt", sep="\t", fill=TRUE, header=TRUE)
data2008<-read.table(file = "CAHSEE08.txt", sep="\t", fill=TRUE, header=TRUE)
data2012<-read.table(file = "CAHSEE2012.txt", sep="\t", fill=TRUE, header=TRUE)
data2014<-read.table(file = "CAHSEE2014.txt", sep="\t", fill=TRUE, header=TRUE)
data2015<-read.table(file = "CAHSEE2015.txt", sep="\t", fill=TRUE, header=TRUE)

data2006<-read.table(file = "CAHSEE06.txt", quote= "\"",sep="\t", fill=TRUE, header=TRUE)#
data2009<-read.table(file = "CAHSEE09.txt", quote= "\"",sep="\t", fill=TRUE, header=TRUE)#
data2010<-read.table(file = "CAHSEE2010.txt", quote= "\"",sep="\t", fill=TRUE, header=TRUE)#
data2011<-read.table(file = "CAHSEE2011.txt", quote= "\"",sep="\t", fill=TRUE, header=TRUE)#
data2013<-read.table(file = "CAHSEE2013.txt", quote= "\"",sep="\t", fill=TRUE, header=TRUE)#
data2014<-read.table(file = "CAHSEE2014.txt", sep="\t", fill=TRUE, header=TRUE)



## Write files into csv into unique file for looping
setwd("~/Desktop/Txt Files/Cahsee")
write.csv(data2001, "data2001.csv")
write.csv(data2002, "data2002.csv")
write.csv(data2003, "data2003.csv")
write.csv(data2004, "data2004.csv")
write.csv(data2005, "data2005.csv")
write.csv(data2006, "data2006.csv")
write.csv(data2007, "data2007.csv")
write.csv(data2008, "data2008.csv")
write.csv(data2009, "data2009.csv")
write.csv(data2010, "data2010.csv")
write.csv(data2011, "data2011.csv")
write.csv(data2012, "data2012.csv")
write.csv(data2013, "data2013.csv")
write.csv(data2014, "data2014.csv")
write.csv(data2015, "data2015.csv")
write.csv(data2013, "data2013.csv", fileEncoding = "UTF-8")
write.csv(data2014, "data2014.csv", fileEncoding = "UTF-8")
###################################################################################################

# Load created csv data to allow efficient looping through all datasets
setwd("~/Desktop/Txt Files/Cahsee")
myFiles <- mixedsort(list.files("~/Desktop/Txt Files/Cahsee"))
myData <- lapply(myFiles, read.csv)
setwd("~/Desktop/Txt Files")



## Subset non-high school names to omit:
#sample<-grep("elementary", data$schnam)
#sample1<-grep("middle", data$schnam)
#sample2<-grep("intermediate", data$schnam)
#sample3<-grep("kindergarten", data$schnam)

#omit<-c(sample,sample1,sample2,sample3)
#data<-data[-omit,]
#summary(as.factor(data$schnam))

data$gshi<-as.numeric(data$gshi)
data<-data[which(data$gshi > 08),]

# Transfer county or district name for code to run efficient 
data$NCES.District.ID<-substr(data$ncessch, 1,7)
sum(data$leaid == data$NCES.District.ID)
#data$NCES.District.ID<-tolower(data$NCES.District.ID)
#nces$NCES.District.ID<-tolower(nces$NCES.District.ID)

# We can use either leaid for district id or created variable from school code. 

match(data$NCES.District.ID,nces$NCES.District.ID)
# NCES values appear to be unique
grep("0600001", nces$NCES.District.ID)


# Write district name into main dataset to separate homogenous school names by 
match(data$NCES.District.ID,nces$NCES.District.ID)
nces$District.Name[match(data$NCES.District.ID,nces$NCES.District.ID)]
data$District.Name<-nces$District.Name[match(data$NCES.District.ID,nces$NCES.District.ID)]




## String split school names, to exclude the last word of each school name sequence. These are often Elementary, Middle, or High. Often homogenous, we may be able to fuzzy
## match strings better with the true name after grep and agrep are performed. 
data$schnam1<-gsub("\\s*\\w*$", "", data$schnam)
data$District.Name1<-gsub("\\s*\\w*$", "", data$District.Name)



## Make rows equal to 
data1<-as.data.frame(matrix(NA, nrow=nrow(data), ncol=1))
data1$shape.id<-data$shape.id
data1$O1_index<-NA
data1$O2_index<-NA
data1$O3_index<-NA
data1$O4_index<-NA
data1$O5_index<-NA
data1$O6_index<-NA
data1$O7_index<-NA
data1$O8_index<-NA
data1$O9_index<-NA
data1$O10_index<-NA
data1$O11_index<-NA
data1$O12_index<-NA
data1$O13_index<-NA
data1$O14_index<-NA
data1$O15_index<-NA

# Set global var for column start
O1<-2

# First loop 
index<-NA
index1<-NA
names<-NA

index_county<-NA


for (a in 1:1) {
  for (i in 1:nrow(data)) {
    j<-tolower(data$schnam[i])
    for (k in 1:15) {
      data2001<-as.data.frame(myData[k])
      data2001$SchoolName<-tolower(str_trim(as.character(data2001$SchoolName)))
      data2001$DistrictName<-tolower(as.character(data2001$DistrictName))
      w<-grep(j,tolower(data2001$SchoolName))
      if (length(w) > 1) {
        q<-data2001[w,]
        if (length(unique(q$DistrictName)) > 1){
          unique_index<-agrep(data$District.Name[i],q$DistrictName)
          unique_data<-q[unique_index,]
          if (length(unique(unique_data$DistrictName)) == 1){
            data1[i,O1+k]<-paste(w[unique_index], collapse = " ")
          } else if (length(unique(unique_data$DistrictName)) > 1) {
            unique_index1<-agrep(data$District.Name[i],q$DistrictName, max.distance = 5)
            unique_data1<-q[unique_index1,]
            if (length(unique(unique_data1$DistrictName)) == 1){
              data1[i,O1+k]<-paste(w[unique_index1], collapse = " ")
            } else if (length(unique(unique_data1$DistrictName)) > 1) {
              #Now we get nested into District name minus the last word (District.Name1)
              unique_index2<-agrep(data$District.Name1[i],q$DistrictName)
              unique_data2<-q[unique_index2,]
              if (length(unique(unique_data2$DistrictName1)) == 1){
                data1[i,O1+k]<-paste(w[unique_index2], collapse = " ")
              } else if (length(unique(unique_data2$DistrictName1)) > 1) {
                unique_index3<-agrep(data$District.Name1[i],q$DistrictName, max.distance = 5)
                unique_data3<-q[unique_index3,]
                if (length(unique(unique_data3$DistrictName1)) == 1){
                  data1[i,O1+k]<-paste(w[unique_index3], collapse = " ")
                } else {
                  index_county<-c(index_county,i)
                }
              }  else {
                index_county<-c(index_county,i)
              }
            }  else  {
              index_county<-c(index_county,i)
            }
          } else  {
            index_county<-c(index_county,i)
          }
        } else {
          data1[i,O1+k]<-paste(w, collapse = " ")
          index<-c(index,i)
        }
      } else {
        names<-c(names,i)
      }
    }
  }
  
  
  # names vector has all index values not matched. index1 vector contains all exact pattern matches but no corresponding district found within subset. 
  names<-unique(names[-1])
  ## Using agrep for fuzzy 
  index.<-NA
  index1.<-NA
  names.<-NA
  index_county.<-NA
  
  for (i in names) {
    j<-tolower(data$schnam[i])
    for (k in 1:15) {
      data2001<-as.data.frame(myData[k])
      data2001$SchoolName<-tolower(str_trim(as.character(data2001$SchoolName)))
      data2001$DistrictName<-tolower(data2001$DistrictName)
      w<-agrep(j,tolower(data2001$SchoolName))
      if (length(w) > 1) {
        q<-data2001[w,]
        if (length(unique(q$DistrictName)) > 1){
          unique_index<-agrep(data$District.Name[i],q$DistrictName)
          unique_data<-q[unique_index,]
          if (length(unique(unique_data$DistrictName)) == 1){
            data1[i,O1+k]<-paste(w[unique_index], collapse = " ")
          } else if (length(unique(unique_data$DistrictName)) > 1) {
            unique_index1<-agrep(data$District.Name[i],q$DistrictName, max.distance = 5)
            unique_data1<-q[unique_index1,]
            if (length(unique(unique_data1$DistrictName)) == 1){
              data1[i,O1+k]<-paste(w[unique_index1], collapse = " ")
            } else if (length(unique(unique_data1$DistrictName)) > 1) {
              #Now we get nested into District name minus the last word (District.Name1)
              unique_index2<-agrep(data$District.Name1[i],q$DistrictName)
              unique_data2<-q[unique_index2,]
              if (length(unique(unique_data2$DistrictName1)) == 1){
                data1[i,O1+k]<-paste(w[unique_index2], collapse = " ")
              } else if (length(unique(unique_data2$DistrictName1)) > 1) {
                unique_index3<-agrep(data$District.Name1[i],q$DistrictName, max.distance = 5)
                unique_data3<-q[unique_index3,]
                if (length(unique(unique_data3$DistrictName1)) == 1){
                  data1[i,O1+k]<-paste(w[unique_index3], collapse = " ")
                } else {
                  index_county.<-c(index_county.,i)
                }
              }  else {
                index_county.<-c(index_county.,i)
              }
            }  else  {
              index_county.<-c(index_county.,i)
            }
          } else  {
            index_county.<-c(index_county.,i)
          }
        } else {
          data1[i,O1+k]<-paste(w, collapse = " ")
          index.<-c(index.,i)
        }
      } else {
        names.<-c(names.,i)
      }
    }
  }
  
  
  names1<-unique(names.[-1])
  ## Using agrep for fuzzy with max distance = 5
  index..<-NA
  index1..<-NA
  names..<-NA
  index_county..<-NA
  
  
  for (i in names1) {
    j<-tolower(data$schnam[i])
    for (k in 1:15) {
      data2001<-as.data.frame(myData[k])
      data2001$SchoolName<-tolower(str_trim(as.character(data2001$SchoolName)))
      data2001$DistrictName<-tolower(data2001$DistrictName)
      w<-agrep(j,tolower(data2001$SchoolName), max.distance = 5)
      if (length(w) > 1) {
        q<-data2001[w,]
        if (length(unique(q$DistrictName)) > 1){
          unique_index<-agrep(data$District.Name[i],q$DistrictName)
          unique_data<-q[unique_index,]
          if (length(unique(unique_data$DistrictName)) == 1){
            data1[i,O1+k]<-paste(w[unique_index], collapse = " ")
          } else if (length(unique(unique_data$DistrictName)) > 1) {
            unique_index1<-agrep(data$District.Name[i],q$DistrictName, max.distance = 5)
            unique_data1<-q[unique_index1,]
            if (length(unique(unique_data1$DistrictName)) == 1){
              data1[i,O1+k]<-paste(w[unique_index1], collapse = " ")
            } else if (length(unique(unique_data1$DistrictName)) > 1) {
              #Now we get nested into District name minus the last word (District.Name1)
              unique_index2<-agrep(data$District.Name1[i],q$DistrictName)
              unique_data2<-q[unique_index2,]
              if (length(unique(unique_data2$DistrictName1)) == 1){
                data1[i,O1+k]<-paste(w[unique_index2], collapse = " ")
              } else if (length(unique(unique_data2$DistrictName1)) > 1) {
                unique_index3<-agrep(data$District.Name1[i],q$DistrictName, max.distance = 5)
                unique_data3<-q[unique_index3,]
                if (length(unique(unique_data3$DistrictName1)) == 1){
                  data1[i,O1+k]<-paste(w[unique_index3], collapse = " ")
                } else {
                  index_county..<-c(index_county..,i)
                }
              }  else {
                index_county..<-c(index_county..,i)
              }
            }  else  {
              index_county..<-c(index_county..,i)
            }
          } else  {
            index_county..<-c(index_county..,i)
          }
        } else {
          data1[i,O1+k]<-paste(w, collapse = " ")
          index..<-c(index..,i)
        }
      } else {
        names..<-c(names..,i)
      }
    }
  }
  
  
  
  
  names2<-unique(names..[-1])
  
  safe_names_not_matched<-names2
  ########## Run same series of loops but substracting the last word of School Name String for fuzzy or pattern match. These are often Elementary, Middle, or High. Often homogenous, we may be able to fuzzy
  ## match strings better with the true name. 
  
  ### Caution  : Store all values or indices that you wish to save as vector names that follow this code are non - unique. I copy and pasted from the top half and added data$schnam1 instead of data$schnam
  
  
  index<-NA
  index1<-NA
  names<-NA
  index_county<-NA
  
  for (i in names2) {
    j<-tolower(data$schnam1[i])
    for (k in 1:15) {
      data2001<-as.data.frame(myData[k])
      data2001$SchoolName<-tolower(str_trim(as.character(data2001$SchoolName)))
      data2001$DistrictName<-tolower(data2001$DistrictName)
      w<-grep(j,tolower(data2001$SchoolName))
      if (length(w) > 1) {
        q<-data2001[w,]
        if (length(unique(q$DistrictName)) > 1){
          unique_index<-agrep(data$District.Name[i],q$DistrictName)
          unique_data<-q[unique_index,]
          if (length(unique(unique_data$DistrictName)) == 1){
            data1[i,O1+k]<-paste(w[unique_index], collapse = " ")
          } else if (length(unique(unique_data$DistrictName)) > 1) {
            unique_index1<-agrep(data$District.Name[i],q$DistrictName, max.distance = 5)
            unique_data1<-q[unique_index1,]
            if (length(unique(unique_data1$DistrictName)) == 1){
              data1[i,O1+k]<-paste(w[unique_index1], collapse = " ")
            } else if (length(unique(unique_data1$DistrictName)) > 1) {
              #Now we get nested into District name minus the last word (District.Name1)
              unique_index2<-agrep(data$District.Name1[i],q$DistrictName)
              unique_data2<-q[unique_index2,]
              if (length(unique(unique_data2$DistrictName1)) == 1){
                data1[i,O1+k]<-paste(w[unique_index2], collapse = " ")
              } else if (length(unique(unique_data2$DistrictName1)) > 1) {
                unique_index3<-agrep(data$District.Name1[i],q$DistrictName, max.distance = 5)
                unique_data3<-q[unique_index3,]
                if (length(unique(unique_data3$DistrictName1)) == 1){
                  data1[i,O1+k]<-paste(w[unique_index3], collapse = " ")
                } else {
                  index_county<-c(index_county,i)
                }
              }  else {
                index_county<-c(index_county,i)
              }
            }  else  {
              index_county<-c(index_county,i)
            }
          } else  {
            index_county<-c(index_county,i)
          }
        } else {
          data1[i,O1+k]<-paste(w, collapse = " ")
          index<-c(index,i)
        }
      } else {
        names<-c(names,i)
      }
    }
  }
  
  # names vector has all index values not matched. index1 vector contains all exact pattern matches but no corresponding district found within subset. 
  names<-unique(names[-1])
  ## Using agrep for fuzzy 
  index.<-NA
  index1.<-NA
  names.<-NA
  index_county.<-NA
  
  for (i in names) {
    j<-tolower(data$schnam1[i])
    for (k in 1:15) {
      data2001<-as.data.frame(myData[k])
      data2001$SchoolName<-tolower(str_trim(as.character(data2001$SchoolName)))
      data2001$DistrictName<-tolower(data2001$DistrictName)
      w<-agrep(j,tolower(data2001$SchoolName))
      if (length(w) > 1) {
        q<-data2001[w,]
        if (length(unique(q$DistrictName)) > 1){
          unique_index<-agrep(data$District.Name[i],q$DistrictName)
          unique_data<-q[unique_index,]
          if (length(unique(unique_data$DistrictName)) == 1){
            data1[i,O1+k]<-paste(w[unique_index], collapse = " ")
          } else if (length(unique(unique_data$DistrictName)) > 1) {
            unique_index1<-agrep(data$District.Name[i],q$DistrictName, max.distance = 5)
            unique_data1<-q[unique_index1,]
            if (length(unique(unique_data1$DistrictName)) == 1){
              data1[i,O1+k]<-paste(w[unique_index1], collapse = " ")
            } else if (length(unique(unique_data1$DistrictName)) > 1) {
              #Now we get nested into District name minus the last word (District.Name1)
              unique_index2<-agrep(data$District.Name1[i],q$DistrictName)
              unique_data2<-q[unique_index2,]
              if (length(unique(unique_data2$DistrictName1)) == 1){
                data1[i,O1+k]<-paste(w[unique_index2], collapse = " ")
              } else if (length(unique(unique_data2$DistrictName1)) > 1) {
                unique_index3<-agrep(data$District.Name1[i],q$DistrictName, max.distance = 5)
                unique_data3<-q[unique_index3,]
                if (length(unique(unique_data3$DistrictName1)) == 1){
                  data1[i,O1+k]<-paste(w[unique_index3], collapse = " ")
                } else {
                  index_county.<-c(index_county.,i)
                }
              }  else {
                index_county.<-c(index_county.,i)
              }
            }  else  {
              index_county.<-c(index_county.,i)
            }
          } else  {
            index_county.<-c(index_county.,i)
          }
        } else {
          data1[i,O1+k]<-paste(w, collapse = " ")
          index.<-c(index.,i)
        }
      } else {
        names.<-c(names.,i)
      }
    }
  }
  
  
  names1<-unique(names.[-1])
  ## Using agrep for fuzzy with max distance = 5
  index..<-NA
  index1..<-NA
  names..<-NA
  index_county..<-NA
  
  
  for (i in names1) {
    j<-tolower(data$schnam1[i])
    for (k in 1:15) {
      data2001<-as.data.frame(myData[k])
      data2001$SchoolName<-tolower(str_trim(as.character(data2001$SchoolName)))
      data2001$DistrictName<-tolower(data2001$DistrictName)
      w<-agrep(j,tolower(data2001$SchoolName), max.distance = 5)
      if (length(w) > 1) {
        q<-data2001[w,]
        if (length(unique(q$DistrictName)) > 1){
          unique_index<-agrep(data$District.Name[i],q$DistrictName)
          unique_data<-q[unique_index,]
          if (length(unique(unique_data$DistrictName)) == 1){
            data1[i,O1+k]<-paste(w[unique_index], collapse = " ")
          } else if (length(unique(unique_data$DistrictName)) > 1) {
            unique_index1<-agrep(data$District.Name[i],q$DistrictName, max.distance = 5)
            unique_data1<-q[unique_index1,]
            if (length(unique(unique_data1$DistrictName)) == 1){
              data1[i,O1+k]<-paste(w[unique_index1], collapse = " ")
            } else if (length(unique(unique_data1$DistrictName)) > 1) {
              #Now we get nested into District name minus the last word (District.Name1)
              unique_index2<-agrep(data$District.Name1[i],q$DistrictName)
              unique_data2<-q[unique_index2,]
              if (length(unique(unique_data2$DistrictName1)) == 1){
                data1[i,O1+k]<-paste(w[unique_index2], collapse = " ")
              } else if (length(unique(unique_data2$DistrictName1)) > 1) {
                unique_index3<-agrep(data$District.Name1[i],q$DistrictName, max.distance = 5)
                unique_data3<-q[unique_index3,]
                if (length(unique(unique_data3$DistrictName1)) == 1){
                  data1[i,O1+k]<-paste(w[unique_index3], collapse = " ")
                } else {
                  index_county..<-c(index_county..,i)
                }
              }  else {
                index_county..<-c(index_county..,i)
              }
            }  else  {
              index_county..<-c(index_county..,i)
            }
          } else  {
            index_county..<-c(index_county..,i)
          }
        } else {
          data1[i,O1+k]<-paste(w, collapse = " ")
          index..<-c(index..,i)
        }
      } else {
        names..<-c(names..,i)
      }
    }
  }
  
}
uniq<-unique(names..)

not_matched<-data[uniq,]


setwd("~/Desktop/Txt Files")
# Write data under safe_oct25
#write.csv(data1,"data1_safe_dec6.csv")
#write.csv(uniq,"uniq_safe_dec6.csv")
#write.csv(not_matched,"nonmatch_safe_dec6.csv")
data1<-read.csv("data1_safe_dec6.csv")
uniq<-read.csv("uniq_safe_dec6.csv")
not_matched<-read.csv("nonmatch_safe_dec6.csv")

safe<-data1
#data1$O13_index<-NA # ? 


#data1<-read.csv("data1_safe_dec6.csv")
#data1$V1<-NULL
#head(data1)


## After all loops are completed 

index_of_main<-data1$shape.id
variables<-data[index_of_main,]
merge<-cbind(data1,variables)


## Conver to long format for panel
long<-melt(data1, measure.vars = c("O1_index", "O2_index", "O3_index","O4_index","O5_index", "O6_index", "O7_index","O8_index", "O9_index", "O10_index","O11_index","O12_index","O13_index","O14_index","O15_index"),id.vars = ("shape.id"))  



# sort shape id to create panel as requested
order<-order(long$shape.id, decreasing=FALSE)
panel<-long[order,]


#merge main data variables into panel
test<-merge.data.frame(panel,data, by="shape.id")




# Use if want cahsee variables instead of main variables
long$split<-str_split(long$value, " ")
long$split_index<-long$split[[1]]
long$split[[1]]
long  


## create safe dataset in case anything happens to test dataset. (I manipulate test dataset to match test1 below, so we save test). This is bc code was already written for test
safe_test_after_loop<-test

unassign<-which(test$schnam=="unassigned") 
test1<-test[-unassign,]

###################### Check 5 random samples of matched data for verification. If holds for arbitrary set, we assume it holds
# Set seed does not work with the sample function
set.seed(1)
test<-test1

##### Issue 1- to take care of "unassigned" school names. Just omit them as they were matched. Unless can use school code to infer name.we have district 

setwd("~/Desktop/Txt Files/Cahsee")
data2004<-read.csv("data2004.csv")
data2011<-read.csv("data2011.csv")


#### Subset from 2004 cahsee data to check 3 values. 
O4<-test[test$variable == "O4_index",]
data2004<-as.data.frame(myData[4])
random<-sample(1:nrow(O4),3,replace = FALSE) # use random below saved as sometimes NA values pop into this sample.

# seems to work without error when not get NA values 
random<-c(656,390,915)
random<-c(960,460,680)
random<-c(847,979)
random<-c(941,254,760)



##find year of first random 
test1<-str_split(O4$value[random[1]]," ")
test11<-test1[[1]]
subset1<-data2004[as.numeric(test11),]

# Check values of cahsee matched school and district name 
subset1$SchoolName
subset1$DistrictName
# Compare that to the school and district name matched in the panel data set
O4$schnam[random[1]]
O4$District.Name[random[1]]


####### WRONG --- INDEX NUMBER 843 , 84 good example with district name off by high and unified 
i=84
test1<-str_split(O4$value[i]," ")
test11<-test1[[1]]
subset1<-data2004[as.numeric(test11),]

# Check values of cahsee matched school and district name 
subset1$SchoolName
subset1$DistrictName
# Compare that to the school and district name matched in the panel data set
O4$schnam[i]
O4$SrcName[i]
O4$District.Name[i]




##find second random 
test2<-str_split(O4$value[random[2]]," ")
test22<-test2[[1]]
subset2<-data2004[as.numeric(test22),]

# Check values of cahsee matched school and district name 
subset2$SchoolName
subset2$DistrictName
# Compare that to the school and district name matched in the panel data set
O4$schnam[random[2]]
O4$District.Name[random[2]]




##find third random 
test3<-str_split(O4$value[random[3]]," ")
test33<-test3[[1]]
subset3<-data2004[as.numeric(test33),]

# Check values of cahsee matched school and district name 
subset3$SchoolName
subset3$DistrictName
# Compare that to the school and district name matched in the panel data set
O4$schnam[random[3]]
O4$District.Name[random[3]]


# We can find arthur benjamin health i Sacramento City
### 146, Anderson Valley Unified to Big Valley Joint 
# 275 Elkin both just as before ?
#arthur<-data2001[grep("arthur a. benjamin health pro",data2001$SchoolName),]
value<-grep("arthur",data2004$SchoolName)
### CHecks out as this school is in the 2001 cahsee dataset
value<-grep("arthur",data2001$SchoolName)
value<-value[-c(12,13)]
art<-data2001[value,]



#####################  now we check 2 random observations from 2011. ###########################
################################################################################################

O11<-test[test$variable == "O11_index",]
data2011<-as.data.frame(myData[11])
random<-sample(1:nrow(O11),2,replace = FALSE) # use random below saved as sometimes NA values pop into this sample

random<-c(689,717)
random<-c(250,176)
random<-c(55,870)
random<-c(905,69)
random<-c(680,932) ## This is a good result as it match North High correctly by district, a very common high school name 
random<-c(639,191)


##find year of first random 
test1<-str_split(O11$value[random[1]]," ")
test11<-test1[[1]]
subset1<-data2011[as.numeric(test11),]


# Check values of cahsee matched school and district name 
subset1$SchoolName
subset1$DistrictName
# Compare that to the school and district name matched in the panel data set
O11$schnam[random[1]]
O11$District.Name[random[1]]



##find year of second random 
test2<-str_split(O11$value[random[2]]," ")
test22<-test2[[1]]
subset2<-data2011[as.numeric(test22),]


# Check values of cahsee matched school and district name 
subset2$SchoolName
subset2$DistrictName
# Compare that to the school and district name matched in the panel data set
O11$schnam[random[2]]
O11$District.Name[random[2]]










#write.csv(panel,"panel_first_try.csv")



data2011<-as.data.frame(myData[16])
head(data2011)



head(data2004)


k=15
data2001<-as.data.frame(myData[k])
data2001$SchoolName<-tolower(str_trim(as.character(data2001$SchoolName)))
data2001$DistrictName<-tolower(as.character(data2001$DistrictName))
head(data2001)


i=1
for (i in 1:10) {
  split_index<-long$split[[i]]
  year<-as.character(long$variable[i])
  value<-as.numeric(substr(year, 2,2))
  data<-as.data.frame(myData[value])
  subset<-data[split_index,]
}




#write.csv(test,"panel_dec6.csv")


test$SrcName
test$schnam


unassign<-which(test$schnam=="unassigned") 
test1<-test[-unassign,]
test1$ncessch



#setwd("~/Desktop/Txt Files")
#write.csv(test,"panel_update_dec6b.csv")
