
set more off
clear all
cap log close


** Homework Assignment 4 A4Q2

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
log using "$log/homework.A4P2.log", replace

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

**************** Question 1
*a) run regression . following regression code included
python
import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.formula.api import ols
import math 
# read data into memory. note the r before character value to input string as raw string
# Data does not read properly without it
d=pd.read_stata(r"$dta\morg03.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last few columns
d.head()
print(d)
end

*************** Question 1 continued 
python
# The count of each variable is :
pd.crosstab(d['emplw'],d['sex'])

# The percentage of each variable is :
pd.crosstab(d['emplw'],d['sex'], normalize='index')
end
* What is the proportion of the men in the sample who are employed? What is the proportion of the women in the sample who are employed? What is the unconditional difference in the probability of employment for men and women? Hint: the row and col options to the tabulate command are your friends. 

* The proportion of men in the sample that are employed is approx 52.5 % 
* The proportion of women in the sample that are employed is approx 47.5 %
* The unconditional difference in the probability of employment for men and women is 4.9236% or approx 5%



*************** Question 2
python 
# Check to see which columns have NA values.
d.isna().any()

# Locate index of NA for emplw to stay consistent amongst packages 
d.loc[pd.isna(d['emplw']), :].index

# Print Observation 
print(d.loc[[133]])

# After verifying correct index number, omit observation from data as it is omitted from regression results in question 2.
d=d.drop(133)

# Create age squared. Cannot include squared operator in regression as data is not integer/float
d['age']=d['age'].astype(int)
d['age2']=d['age']**2

# Run Regression 
mod1=ols('emplw~sex+age+age2+ihigrdc+black+othrac', data=d).fit()
mod1.summary()
end
*Oh no, python omitted an observation. I thought it was better than this. I went back above this to omit the observation from data to stay consistent when using various different packages.  

* We can see that the difference in conditional probabilities between men and women employment, for this sample, is 15%. This is a much larger value than unconditional probabilities, increased by a factor of 3. 


************** Question 3

* First we calculate the marginal effect of a one year increase of age given our non-linear terms
* We get:  .0606 - ( (-0.0014)^2 * age)
python 
# Save model coefficients 
age_coef=mod1.params[2]
age2_coef=mod1.params[3]
age2_coef_squared=age2_coef**2

# Print age2 coefficient and age2 coefficient to make sure squared operator works. Python gives me problems with this when not int and float. 
print(age2_coef)
print(age2_coef_squared)

# Calculate conditional marginal effect of probability that an individual aged 20 is employed 
marginal_effect= age_coef - (age2_coef_squared*20)
print('The estimated effect of an additional year of schooling conditional on an individual being 20 years old is:', marginal_effect)
end




*************** Question 4
*Generate predicted values based on the regression in Question 2. Summarize the predicted values. What is the mean? What is the median? How many values, if any, lie outside the interval [0,1]? If no observations have predicted values outside the [0,1] interval, describe the characteristics of someone who would, given your estimated coefficients.
python 
# Generate fitted values
predicted_values=mod1.fittedvalues
print('The mean of predicted values is:',predicted_values.mean())
print('The median of predicted values is:',predicted_values.median())

# Check if any predicted values are are less than 0 or greater than 1
print('The min predicted value is:',min(predicted_values))
print('The max predicted value is:',max(predicted_values))
end
* Thus we can see no predicted values greater than 1 or less than 0. Although we are very close to 1 on our upper bound. We anticipate an older white male with a very large amount of education years to provide a misfit. 





***************** Question 5
python 
# Create edgt12 variable
d['edgt12']=0
d['edgt12'].values[d['ihigrdc']>12]=1

# Create edeq12 variable
d['edeq12']=0
d['edeq12'].values[d['ihigrdc']==12]=1

# Check to see if created variables are made correctly
d.head()
d.tail()
end
* We notice many Nan values for weekly earnings. Remember this for future exercises with this dataset




****************** Question 6
python 
# Run Regression 
mod2=ols('emplw~sex+age+age2+black+othrac+edgt12+edeq12', data=d).fit()
mod2.summary()

# Difference in employment rates between a woman with 11 years of schooling and a man with 15 years of schooling, holding other factors constant
difference= mod2.params[1] + mod2.params[6]
print('The difference in employment rates between the given observations is:',difference)
end
* A man with 15 years of schooling will have an .1552 increase in probability due to sex, and a  + .1940 effect from having 4 years of additional schooling. The total probability is approx 35%
* The .1940 additional probability is the probability of having greater than 12 years of schooling compared to having less than 12 years of schooling




******************* Question 7
python 
# Create new model with sex interacted with the 2 education dummy variables 
mod3=ols('emplw~sex+age+age2+black+othrac+edgt12+edeq12+I(sex*edgt12)+I(sex*edeq12)', data=d).fit()
mod3.summary()

# Calculating new comparison 
sex_coef=mod3.params[1]
education_coef=mod3.params[6]
interacted_coef=mod3.params[8]

# Calculate total difference between observations
difference1= mod3.params[1] + mod3.params[6] + mod3.params[8]
print('The difference in probability of employment rates given the interacted model is:',difference1)

print('The difference in differences between models, given our 2 given observations is:', difference-difference1)
end
* The result from our interacted model is slightly different from the predicted probability without interaction. EXPLAIN WHY
* Some of the variation is going into the intercept. The intercept is acting as a magnet toward unidentified variation as sex and education past 12 years is already included in the model. The interaction is built into the dummy structure. 



******************** Question 8 
python 
# Run Regression from Question 2 with robust standard errors 
mod4=ols('emplw~sex+age+age2+ihigrdc+black+othrac', data=d).fit(cov_type='HC0')
mod4.summary()

# or estimating se more simply using our original model results
mod1.HC0_se
end
* We do not notice any changes in significance amongst any independent variables. We notice that the robust standard error for education is increased by .001


******************** Question 9 
python 
# Calculate condition probability given xs
cond_prob=mod1.fittedvalues
# Save complement of probability 
cond_complement=1-cond_prob
# Calculate error variance
error_variance= cond_prob * cond_complement
end


******************** Question 10 
python
import statistics as stats 
from statsmodels.formula.api import wls
# Create inverse weight of error variance 
w=1/error_variance

# Create y and x variables
y=d['emplw']
x=d[['sex','age','age2','ihigrdc','black','othrac']]
x=sm.add_constant(x)

mod10=sm.WLS(y, x, weights=(w)).fit()
end


********************* Question 11
python
# Comparing results from Question 2 and Question 10 (Mod1 and Mod10)
mod1.summary()
mod10.summary()
end
* The coefficients on the WLS are all relatively smaller than the coefficient estimates on our first model. The standard errors fluctuate marginally in both directions. The significance did not change of any variables, however, other race dummy had tremendous reduction in pvalue with WLS. The coefficient also got more negative in the WLS model. 











