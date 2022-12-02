
set more off
clear all
cap log close

** Homework Assignment 2 A2.P3


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
log using "$log/homeworkA2P3.log", replace

** Use this command to check if python is downloaded on your system
python search
* If python is not installed on your pc, please go download Anaconda 
* Get the wd from Anaconda by typing python search again. Copy and Paste the wd from Anaconda into the python exec path
python search
* copy this command with ur anaconda C:   
* set python_exec  C:\Users\alp17005\Desktop\python.exe, permanently 
* run python query, anaconda should be set up on your desktop
python query 

* Your exec path should now have python through anaconda. This will allow STATA to run pandas, numpy and other python packages without having to install them separately through the shell. 

* Start of code. Python opens the code,  end stops STATA reading python code.

python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import math 
# Read data into memory
d=pd.read_stata(r"$dta\WAGE2.dta")
# Print first five observations and first and last few columns
d.head()

# a) Print Selected Summary Statistics
print("The mean wage is:",round(d['wage'].mean(),2))
print("The mean IQ is:",round(d['IQ'].mean(),2))
print("The sample std of IQ is:",round(d['IQ'].std(),2))

# b) Create SLR model
# create x and y variables
X=d['IQ']
Y=d['wage']
# Add intercept using statsmodels package
X=sm.add_constant(X)
# Run model using statsmodels with created data as arguments
model=sm.OLS(Y,X).fit()
# Print summary of model
model.summary()

# Create new data vector to predict with. 1 to include the intercept for a true prediction. But we are asked for the predicted increase in wage when x increases by 15 points. 
new_IQ=[0,15]
# Print predicted value use predict function and new data as argument
print("The predicted wage when IQ increases by 15 points is:", model.predict(new_IQ))

# IQ only explains around 10 % of the variation in wage. Thus, IQ does not explain most of the variation in wage. 

## c) Run log-level model instead of level - level model 
# create data
X1=d['IQ']
Y1=np.log(d['wage'])
# add constant
X1=sm.add_constant(X1)
# fit model
model1=sm.OLS(Y1,X1).fit()
# summary of model
model1.summary()

# Percent Increase in Wage from improved IQ with log-level
# create new data
new_IQ=[0,15]

print("The % wage increase when IQ increases by 15 points is:", model1.predict(new_IQ)*100, "%")

end
