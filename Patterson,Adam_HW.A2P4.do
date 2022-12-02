
set more off
clear all
cap log close


** Homework Assignment 2 A2.P4

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
log using "$log/homeworkA2P4.log", replace

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
import random
## Looked up how to set seed but cannot get this to work properly. Moved on to the exercise but ideally we would like to set a seed when working with randomized commands so that our data is reproducible. 
random.seed(1)
## Create empty list for filler
av=[]
sd=[]
se=[]
# Run for loop for 1-2000. 
for i in range(2001):
	# Obtain 100 random observations from standard normal distribution 
	_norm=np.random.normal(0,1,100)
	# Multiply observations by 4 and add 1
	_norm=(_norm*4) + 1
	# save the mean of observations
	avDraw=_norm.mean()
	# save the std of observations
	sdDraw=_norm.std()
	# Calculate the standard error
	seDraw= sdDraw/10
	# Append each iteration of our loop to the filler lists to create one large list of parameters
	av.append(avDraw)
	sd.append(sdDraw)
	se.append(seDraw)

# Sort the three parameters ( default is ascending order)
sortedav=sorted(av)
sortedsd=sorted(sd)
sortedse=sorted(se)

# Print the 1900th value for the mean
print(sortedav[1900])
end

* Questions 
* I would anticipate the 1900th order valued to be around 3 as this would account for 95 % of the distribution. Thus a 1.96 critical statitic, implying that the mean * 1(1.96) is close to around 3. 

* The data tell me I am very wrong. With a transformed mean of 1, std of 1, I would anticipate the value to equal approximately mu + 1.96(1). The 1900th value is approx 1.64 in these results. I can see taking the average of a random normal distribution from 100 samples may have skewed something. 

* I would guess that around 15% of the observations would be negative given percentages of standard normal distribution graph. Again I am way off, and thus my understanding of the material should be revisited. As we can see from the long printed list below, there are only a few negative numbers out of 2000 iterations. The data says that I am wrong again. 

python
# Print all mean values in our list to confirm everything worked properly. 
print(sortedav)
end




