
set more off
clear all
cap log close


** Homework Assignment 4 A4Q3

/*
* created by: Adam Patterson
* date: November 10, 2021
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
log using "$log/homeworkA4P3.log", replace

** Use this command to check if python is downloaded on your system
python search
* If python is not installed on your pc, please go download Anaconda 
* Get the wd from Anaconda by typing python search again. Copy and Paste the wd from Anaconda into the python exec path
python search
* copy this command with ur anaconda C:   
* set python_exec C:\Users\alp17005\Desktop\python.exe, permanently 
* run python query, anaconda should be set up on your desktop
python query 

* Your exec path should now have python through anaconda. This will allow STATA to run pandas, numpy and other python packages without having to install them separately through the shell. 

***********************************Question 1
*a) load data
python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.stats.diagnostic as dg
from statsmodels.formula.api import ols
from statsmodels.compat import lzip
import math 
# read data into memory. note the r before character value to input string as raw string
# Data does not read properly without it
d=pd.read_stata(r"$dta\morg03.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last few columns
d.head()
end

*b) estimate model 
python
# Run Regression Model
mod1=ols('earnwke~sex+black+othrac+age+ihigrdc',data=d).fit()
mod1.summary()

# We can see that our regression results will omit many variables
d1=d.dropna()
d1.shape

# Get breuschpagan test results 
pagan=dg.het_breuschpagan(mod1.resid, exog_het=mod1.model.exog)

# Create names list to concatenate with breusch pagan results so that values make sense
names = ['Lagrange multiplier statistic', 'p-value',
        'f-value', 'f p-value']
		
# Merge test results with test names		
lzip(names,pagan)
end
* We can see that both the p value of the test and the null hypothesis of homoskedastic errors are rejected. We notice that the F statistic from our first model is equal to the lagrange multiplier statistic 

* Run calculations "by hand"
python
# Save model1 residuals and square results 
mod1.resid=mod1.resid.astype(float)
d['res1']=mod1.resid**2

# Run model with squared residuals and print results
by_hand_model=ols('res1~sex+black+othrac+age+ihigrdc', data=d).fit()
by_hand_model.summary()

end 
* We can see the F stat for our 'hand calculated' regression equals the breusch pagan F test. We also notice that the F statistic from our first model is equal to the lagrange multiplier statistic in the breusch pagan F test. 



**********************************Question 2
python
# Standard Errors for Model 1
mod1.bse

# Robust Standard Errors for Model 1
mod1.HC0_se
end
* Using robust standard errors  does not change significance of any variables. Although the black variable becomes very close. 

*********************************Question 3
python 
# Convert 0 education values to .01 making division feasible
d['ihigrdc1']=d['ihigrdc'].replace(0,.01)

# Also convert earnings as many Nan values, just to explore differences in results
d['earnwke1']=d['earnwke'].replace(0,.01)
d['earnwke1']=d['earnwke1'].replace(np.nan,.01)

# Create variables for regression
y=d['earnwke1']
x=d[['sex','black','othrac','age','ihigrdc1']]
x=sm.add_constant(x)

# Create weights for our WLS model, inverse of education. I made the two 0 values equal to .01 to make this feasible 
w=1/d['ihigrdc1']

# Run WLS model
mod2=sm.WLS(y, x, weights=(w)).fit()
mod2.summary()

# Run OLS model with slightly modified data for direct comparison 
mod3=ols('earnwke1~sex+black+othrac+age+ihigrdc1',data=d).fit()

# OLS Results to compare above 
mod3.summary()

# OLS robust standard errors
mod3.HC0_se

# WLS robust standard errors
mod2.HC0_se
end
* The coefficients seem to increase slightly with the WLS model. No significance changes are present between the OLS and WLS specifications. We see the standard errors decrease , with the exception of age, with our weighted regression. 


********************************** Question 4
python
from scipy.linalg import toeplitz

# Import data from Question 2 as it seems a little funky now
# Convert 0 education values to .01 making division feasible
d1['ihigrdc1']=d1['ihigrdc'].replace(0,.01)

# Also convert data to fit first regression omitting many values =(
d1['earnwke1']=d1['earnwke'].replace(0,.01)
d1['earnwke1']=d1['earnwke1'].replace(np.nan,.01)
y=d1['earnwke1']
x=d1[['sex','black','othrac','age','ihigrdc1']]
x=sm.add_constant(x)


# Run model using Generalized Least Squares

# Get residuals from OLS
ols_resid=sm.OLS(y, x).fit().resid

#Rename residuals to fit endogenous and exogenous variables 
a=ols_resid[1:]
b= ols_resid[:-1]
# Reindex a and b index to match 
a.reindex(b.index)

# Run regression of residuals to obtain weights 
res_fit = sm.OLS(list(a),list(b)).fit()

# Create covariance variance matrix, named sigma 
rho = res_fit.params
order = toeplitz(np.arange(521))
sigma = rho**order

# Run GLS model with conditioned/created data
mod3=sm.GLS(y, x, sigma=sigma).fit()

# Run first two models with same slightly modified data 
mod1=sm.OLS(y,x).fit()
mod1b=sm.OLS(y,x).fit(cov_type='HC0')
end


******* Comparing the GLS model to the first model 
python
# Print model output
mod1.summary()
mod3.summary()
end
*** Generalized least squares did not change the significance on any parameters. However, we can see that the coefficient values changed using GLS. The estimates change considerably. 