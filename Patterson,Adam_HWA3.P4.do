
set more off
clear all
cap log close


** Homework Assignment 3 A3Q4

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
log using "$log/homework.A3P4.log", replace

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
python
import pandas as pd
from pandas import DataFrame
import numpy as np
import statsmodels.api as sm
import statistics as st

# Create fillers to house 3,000 values 
q=[]
aq=[]
s=[]
as_=[]

# Draw 20 samples from uniform distribution from 2 to 8
x=np.random.uniform(2,8,20)
# Draw 20 samples from standard normal
z=np.random.normal(0,1,20)
# Create W
w= 5 + 2*x + 9*z

### Start of loop to get 3,000 iterations
for i in range(3001):
	# Create noise from standard normal
	e=np.random.normal(0,1,20)
	# create y variable
	y= 1 + 4*x + 3*e
	# Save x as x_1 to preserve x . add constant to x_1 for first regression.
	x_1=x
	x_1=sm.add_constant(x_1)
	# run first regression
	mod=sm.OLS(y,x_1).fit()
	# Save r and adjusted r squared 
	q1=mod.rsquared
	aq1=mod.rsquared_adj

	# create x variable for second regression
	x_2=DataFrame({'x1':x, 'x2':z})
	# Add intercept
	x_2=sm.add_constant(x_2)
	# Run second regression including z variable 
	mod2=sm.OLS(y,x_2).fit()
	# Save r squared and adj r squared values
	s1=mod2.rsquared
	as1=mod2.rsquared_adj
	
	# Append variables
	q.append(q1)
	aq.append(aq1)
	s.append(s1)
	as_.append(as1)

print('The average value for r squared q is',st.mean(q))
print('The average value for adj r squared q is',st.mean(aq))
print('The average value for r squared s is',st.mean(s))
print('The average value for adj r squared s is',st.mean(as_))	
end


* The relative magnitudes of Q and S should be larger than the relative magnitude of AQ and AS. As the adjusted r squared should account for the penalty of adding another regressor. Conversely, the r squared values should automatically increase as the number of variables increases. Thus, we expect the magnitude of going from Q to S to be larger than AQ to AS as the AQ and AS values include penalty terms. 


