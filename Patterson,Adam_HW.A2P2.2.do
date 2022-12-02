set more off
clear all
cap log close

** Homework Assignment 2 A2.P2 
* Question 2

/*
* created by: Adam Patterson
* date: October 1, 2021
*
* Notes: describe the purpose of this file
*
* Version updates: 
*/

* set directories
global root "C:\Users\AdamL\OneDrive\Desktop\Metrics"
global do "$root\do"
global dta "$root\dta"
global log "$root\log"
global working "$root\working"

* Add a log file for the output. I have attached the log file to the homework problem
* so that you can verify my code works without having to download python if you do not want
* If you have any questions, reach out to me before or after class
log using "$log/homeworkA2P2_2.log", replace

** Use this command to check if python is downloaded on your system
python search
* If python is not installed on your pc, please go download Anaconda 
* Get the wd from Anaconda by typing python search again. Copy and Paste the wd from Anaconda into the python exec path
python search
* copy this command with ur anaconda C:   
* set python_exec  C:\Users\AdamL\Anaconda3\python.exe, permanently 
* run python query, anaconda should be set up on your desktop
python query 

* Your exec path should now have python through anaconda. This will allow STATA to run pandas, numpy and other python packages without having to install them separately through the shell. 

* Start of code. Python opens the code,  end stops STATA reading python code.

python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import math 
# read data into memory. note the r before character value to input string as raw string. Data does not read properly without it
d=pd.read_stata(r"$dta\BWGHT.dta")
# Call first five observations of the first and last few columns
d.head()
# create y and x variables 
Y=d['bwght']
X=d['cigs']
# add constant to x value with statsmodels package
X=sm.add_constant(X)
# fit our OLS model using saved variables
mod=sm.OLS(Y,X).fit()
# call summary of model
mod.summary()
# Print the mean birth weight as part of below question 
print(d['bwght'].mean())

# 1a) The estimated birth weight with no cigs smoked is 119.78 ounces. 
# Create vector of new data to multiply into fitted model. 1 for intercept and 20 times Beta1
pack_per_day=[1,20]
# Use predict function with newly saved data to print
print("The predicted birth weight for a pack per day smoker is:",mod.predict(pack_per_day), "ounces")

# The reduction in birth weight for smoking mothers is noticeable given the birth weight of non smokers. The 10 ounce difference is approximately 8 % of the "normal" birth weight. This is considerable given that some mothers smoke 2 packs per day. 

# 1b) No, this regression does not represent a causal relationship between child's birth weight and mother's smoking habits. Maternal genetics could influence an infant's birth weight. Also, sociodemographic information would drive birth health. This would include variation in mothers income and account for the strength of healthcare system local to the birth mother. 

# 1c) To predict a birth weight of 125 ounces, cigs smoked would have to be around negative 10 to 11 per day. This does not make intuitive sense. 

pos=[1,-11]
print("The predicted birth weight for -11 cigs smoked per day is:",mod.predict(pos), "ounces")

# 1d) As most of our observations are not smokers, consuming 0 cigs, we have a lot of observations influencing our results toward the origin. The further we go away from 0, the more biased our results could be. Depending on what values are asked, if a new data value to be examined falls outside of the range of our sample...then our results may exhibit extrapolation. We should not automatically "throw" away our results but just be mindful of the underlying dynamics. 


end