
set more off
clear all
cap log close


** Homework Assignment 3 A1Q2

/*
* created by: Adam Patterson
* date: October 20, 2021
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
log using "$log/homework.A3P2.log", replace

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

* Start of code. Python opens the code,  end stops STATA reading python code.

************ Copy Question 1 from Part 1 to load regression results
python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import math 
# read data into memory. note the r before character value to input string as raw string. 
# Data does not read properly without it
d=pd.read_stata(r"$dta\cps_ps2.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last few columns


# a) Create experience proxy variable as defined by Jacob Mincer (age - education - 6) 
d['potential_experience']=d['age'] - d['ihigrdc'] - 6
# Print head to verify it worked properly
d.head()
# b) Create y and x variables to run regression. Run Regression
# Convert 0 income values to .01 so that log of income is not nan
d['earnwke1']=d['earnwke'].replace(0,.01)
# Create earnings log variable equal to natural log of earnings per week
d['earnings_log']=np.log(d['earnwke1'])
y=d['earnings_log']
x=d['ihigrdc']
x=sm.add_constant(x)

# Run OLS of natural log of weekly earnings on years of schooling
mod1=sm.OLS(y,x).fit()

# c) Regression of natural log of weekly earnings on years of schooling and potential experience 
# Create variables
x=d[['ihigrdc','potential_experience']]
y=d['earnings_log']
x=sm.add_constant(x)
# Run OLS model 
mod2=sm.OLS(y,x).fit()



end


*********************************** Question 1 for Part 2

python 
from statsmodels.formula.api import ols
# save schooling coefficient from first regression, Beta tilde
beta1_tilde=mod1.params[1]
print('Calling the estimated coefficient for years of schooling is:',beta1_tilde)
# save schooling coefficient from second regression, Beta hat
beta1_hat=mod2.params[1]
# save potential experience estimator as beta2_hat
beta2_hat=mod2.params[2]
# Run OLS model of potential experience on ihigrdc
model=ols('potential_experience~ihigrdc', data=d).fit()
delta1_tilde=model.params[1]

# Verify that the results hold
print('The result for beta1_tilde is:',beta1_tilde)
iv=beta1_hat + beta2_hat*delta1_tilde
print('The result for the independent variables are:',iv)
# From above, we can see that the results hold and that beta1_tilde = the independent variables 
end

*********************************** Question 2 for Part 2

python 
# read data into memory. note the r before character value to input string as raw string. 
# Data does not read properly without it
d=pd.read_stata(r"$dta\cps_ps2.dta")
d=pd.DataFrame(d)
# Run Regression model of earnings per week on education, age, and their interaction. 
model2=ols('earnwke~ihigrdc*age',data=d).fit()
model2.summary()

end

*a) The estimated coefficient on the interaction term is not statistically significant different from zero for alpha = 0.05, although close. 

*b) No, the p value does not indicate substantial significance

*c) The expected earnings change with education is 22.4018 + 1.0669*age for each education unit increase 

*d) Education increases earnings once an individual reaches the age of -21. Doesn't make much practical sense. Thus, I assume education increases earnings throughout the course of an individuals lifetime. 

*e) The slope increases as age increases. It increases at an increasing rate as age gets larger, the effect gets larger. 

*f) Age impacts earnings by -10.8985 + 1.0669*education for each additional year. 

*g) The effect of age on earnings decreases until education level reaches 10.2 years, from this point age has a positive effet on earnings. 

*h) The graph looks like a parabola. The effect decreases until the x axis hits 10.2, a critical point, then the effect of age on earnings starts to increase with education. 

***************************************** Question 3 for Part 2

*a) The sign of beta 2 would be positive if hours spent studying has a positive effect on the final grade of ARE 5311. 

*b) Given that beta2 is positive and delta1 tilde is negative (delta1 tilde is negative as the correlation between prior knowledge and hours spent studying is negative), performing mulitplication gives us a negative number, thus the expectation of our beta estimate will be less than the true population parameter. Hence, from the formula above:  E(beta tilde) = B1 - the bias from excluding variable.

*c) The expected value of beta1 tilde will be equal to Beta1. If the correlation is 0 then delta1 tilde equals 0 and the additional term equals 0. Thus, expectation of beta1 tilde equals beta1. 


