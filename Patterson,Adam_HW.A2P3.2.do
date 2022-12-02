set more off
clear all
cap log close

** Homework Assignment 2 A2.P3
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
log using "$log/homeworkA2P3__2.log", replace

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
import numpy as np
import statsmodels.api as sm
import math 
# Create empty list for fillers
uppers=[]
lowers=[]
# Run loop to calculate 20 confidence intervals from 9 obs normal distribution with mean 69, std 9 
np.random.seed(1) # I need to figure out how to properly set a seed in Pythono so that these results are reproducible
for i in range(21):
	sample=np.random.normal(69,3,9)
	# Create upper and lower bounds
	upper=sample.mean()+ 1.96*(sample.std()/3)
	lower=sample.mean()- 1.96*(sample.std()/3)
	# Append values 
	lowers.append(lower)
	uppers.append(upper)

# create vectors named Y and X from our appended lists	
d={'Y':lowers, 'X':uppers}
# create dataframe from created observations
df=pd.DataFrame(data=d)	
# Print dataframe to observe
print(df)
# e) Calculate rows with intervals containing various arguments :
seventy_two=df[(df['Y'] <= 71.9) & (df['X'] >= 72.01)]
print("The row numbers with intervals containing 72 are:",seventy_two)
seventy=df[(df['Y'] <= 69.9) & (df['X'] >= 70.01)]
print("The row numbers with intervals containing 70 are:",seventy)
sixnine=df[(df['Y'] <= 68.9) & (df['X'] >= 69.01)]
print("The row numbers with intervals containing 69 are:",sixnine)


# a) The 11th iteration provided a confidence interval that does not contain mu. 19 out of 20 contain mu. 
# b) I would expect to potentially see 1 confidence interval fail to include the true value. Given that we estimate a 95 % confidence interval, at random we expect 5 out of 100 sets of confidence invtervals failing to contain the true mean. Thus 1 out of 20 is expected, on average. 
# c) Checking the width of confidence intervals below, we notice significant variation amongst samples. This variation would decrease as n increases. n is relatively low at 9 for this exercise. 
print(df['X']-df['Y'])
# d) The 90 % confidence intervals would be wider than the 95 % confidence intervals as the z ,or t depending on if sigma is known, statistic would be larger with less confidence.
# e) code for intervals containing requested values are located just above a). 
# f) Of course in absolute terms the number covered within the interval would be larger with a larger sampple. I would expect the width of confidence intervals to get more narrow as the sample size increases. As n increases, the value multiplied by 1.96 converges to 1.96. Thus, the confidence invtervals get marginally smaller as n increases. 
# g) I would expect 19 of the values to contain the true value of mu. I would not be sure how to tell which observations these may be given the random sample. Posterior we may be able to evaluate which intervals would be more likely. 

end