
set more off
clear all
cap log close


** Homework Assignment 4 A4Q1

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
log using "$log/homework.A4P1.log", replace

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

*********************************** Question 1
*a) run regression . following regression code included
python
import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.formula.api import ols
import math 
# read data into memory. note the r before character value to input string as raw string
# Data does not read properly without it
d=pd.read_stata(r"$dta\corpus.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last few columns
d.head()
# Find dimensions of data
d.shape

# Run LPM model and print results 
mod1=ols('accept~black+hisp+othrace+age+edlt10+ed10_11+ed13_15+edgt15',data=d).fit()
mod1.summary()

end
*a) The F stat indicates that this is not the most useful model. Education less than 10 years is the only significant individual coefficient. The coefficient indiciates that having less than 10 years of schooling indicates an approximately 8.5 percent decrease in the probability that the individual is accepted. The other coefficients are not significant but interpret in a similar fashion. I can only interpret these results after seeing that the robust standard errors do not change very much, thus the t values will be approximate to this regression. The age coefficients do not make much intuitive sense, as education is negative for all years minus 10 and 11. 

**************** Question 2
python
print('Below we see the normal standard errors of our model:')
print(mod1.bse)
# Run and save second model with heteroskedasticity robust se
mod2=ols('accept~black+hisp+othrace+age+edlt10+ed10_11+ed13_15+edgt15',data=d).fit(cov_type='HC0')
print('Below we see the robust standard errors of our model:')
print(mod2.bse)

# or we could simply use the model1 summary option HC0_se
mod1.HC0_se
end
*b) We can see there are not big differences between the standard errors. Black standard error is larger, education 10-11, and education greater than 15 are also marginally larger. 


*************** Question 3
python
print('The minimum predicted value is:',min(mod1.fittedvalues))
print('The maximum predicted value is:',max(mod1.fittedvalues))
end
*c) We can see that none of the fitted values are below 0 or above 1. 




**************** Question 4
python
# save residuals from model1
w=mod1.resid
# Instead of squaring and then square root, I just take absolute value of residual
w=np.abs(w)
# Get inverse of residual
w=1/w
# Make w list to input into package
w=list(w)

# Create data 
y=d['accept']
x=d[['black','hisp','othrace','age','edlt10','ed10_11','ed13_15','edgt15']]
x=sm.add_constant(x)

# Run model 
mod3=sm.WLS(y, x, weights=(w)).fit()
mod3.summary()
mod1.HC0_se
end
* The coefficients from our WLS models are mostly more negative than the OLS first model. Standard errors are generally reduced with the WLS model. Comparing our WLS standard error results to the robust standard errors, we find that the WLS standard errors are reduced even further than the robust standard error option. 







