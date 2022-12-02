
set more off
clear all
cap log close

** Homework Assignment 2 A2.P1


/*
* created by: Adam Patterson
* date: October 1, 2021
*
* Notes: hw 
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
log using "$log/homeworkA2P1.log", replace

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
import seaborn as sb
# Create requested dataframe
d={'Y':[8,10,6,4,12], 'X':[6,2,4,2,6]}
df=pd.DataFrame(data=d)
# Call the first five observations with first and last columns
df.head()

# Create Beta Hat estimate from covariance-variance matrix. Pull a covariance value divided by the variance of X. 
beta_1= ( np.cov(d['X'],d['Y'])[0,1] ) / ( np.cov(d['X'],d['Y'])[0,0] )
# Create Intercept by take mean of y - beta1 hat* mean x
beta_0 = df['Y'].mean() - beta_1*df['X'].mean()
# Print values saved into system as named variables. If we just save the variables, they will never be shown in the homework
print("The intercept value is:",beta_0)
print("The beta 1 estimate is:",beta_1)

# Run linear regression model to verify above regression results
# Name variables subsetting from df dataset 
x=df['X']
y=df['Y']
# Use statsmodels package to add a constant to x variable. 
x=sm.add_constant(x)
# save ols model run from statsmodels with created y and x variables as arguments
mod=sm.OLS(y,x).fit()
# Print the summary of mod saved from package 
mod.summary()

# Although certain tests are omitted due to low observation count, we can stil see the beta estimate of x to be .75 and our intercept to be 5. Our manual calculations hold. 

# Save data to desktop to perform visual analysis. Visual packages in Python do not appear to run in STATA 
df.to_stata(r"$dta\fakeData.dta")
end 

* Scatter Plot with Line of Best Fit 
use "$dta\fakeData.dta" 
twoway (scatter Y X, sort) (lfit Y X)