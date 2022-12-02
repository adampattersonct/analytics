
set more off
clear all
cap log close


** Homework Assignment 3 A1Q3

/*
* created by: Adam Patterson
* date: October 29, 2021
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
log using "$log/homework.A3P3.log", replace

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


** Question 1

*a) As n increases, the variance of the error increases
 
*a) Interesting self thought: As n increases, the variance of the error stays constant as it is a population parameter.  

*b) SST for x2 increases when n increases. 

*c) As N increases, var of our estimator decreases. The residuals grow at a slower pace than the denominator when N increases. 

*d) I would prefer the first dataset as there is more variation in the data. With each observation weighted, the first dataset will allow for a model to exploit more variation. In terms of the equation above, as SST2 is larger for dataset 1 .... the denominator for var(beta hat) will be larger. This will cause var(beta hat) to be smaller relative to the SST2 for dataset 2. 

*e) The value of R_2^2 when x1 and x2 are independent is 0. 

*f) The value of R_2^2 is 1 when x1=x2, in theory. I tried to run it but software would not let me run regression of y on x when y=x. 



*********************************** Question 2
*a) run regression . following regression code included
python
import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.formula.api import ols
import math 
# read data into memory. note the r before character value to input string as raw string. 
# Data does not read properly without it
d=pd.read_stata(r"$dta\cps_ps2.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last few columns
d.head()

## Not the most efficient way to create dummy variables, but I could not get the get_dummies function working for task needed while being time efficient
# Create variables
d['age3135']=0
d['age3640']=0
d['age4145']=0
d['age4650']=0
d['age5155']=0
d['age5660']=0
d['age6165']=0

# Fill column with 1 value if argument is true
d.loc[(d['age']>= 31) & (d['age'] <= 35), ['age3135']]=1
d.loc[(d['age']>= 36) & (d['age'] <= 40), ['age3640']]=1
d.loc[(d['age']>= 41) & (d['age'] <= 45), ['age4145']]=1
d.loc[(d['age']>= 46) & (d['age'] <= 50), ['age4650']]=1
d.loc[(d['age']>= 51) & (d['age'] <= 55), ['age5155']]=1
d.loc[(d['age']>= 56) & (d['age'] <= 60), ['age5660']]=1
d.loc[(d['age']>= 61) & (d['age'] <= 65), ['age6165']]=1

d['age'].max()
d['age'].min()

mod=ols('earnwke~age3135+age3640+age4145+age4650+age5155+age5660+age6165', data=d).fit()
mod.summary()

# Run regression of earnwke on age  
mod2=ols('earnwke~age',d).fit()
mod2.summary()

# Run regression of earnke on age and age squared
d['age']=d['age'].astype(int)
mod3=ols('earnwke~age+I(age**2)',d).fit()
mod3.summary()

end

*b) The omitted category is age group 25-30 

*c) Relative to the 25-30 year old group, our estimated coefficients increase until around age 50 where the coefficient peaks and declines sequentially.

*d) This model is not a good approximation to the findings from the model using the dummy variables estimated in part a. Model2 is compared to the mean while our first model is compared against arguably the lowest income earning group(25-30 year olds). The relative difference, coefficients, in the model should be more extreme compared to 25-30 rather than using the mean. 

*e) The squared age term is statistically significant

*f) The maximizing value is 94.7 years of age. This makes no sense. Beyond this value, age has a negative effect on earnings. We also say this is severe extrapolation because our highest age observation value is 65. 

*g) Just using adjusted r squared, I would prefer the regression in part e. 



************************** Question 3
*a)
python 
import statistics
from pandas import DataFrame
from scipy.stats import pearsonr


# Create filler variables 
x_11=[]
x_22=[]
x_33=[]
#Run regression including collinear variables in loop 
for i in range(101):
	# create random variable 
	x1=np.random.normal(100,10,100)
	# Create collinear variable 
	x2=x1
	# create variable not correlated with other x variables 
	x3=np.random.uniform(7,10,100)
	# Create different unobservables with different variances
	u=np.random.normal(0,1,100)
	e=np.random.normal(0,10,100)
	# create y variable with collinear variables
	y=5*x1+x2+e

	# Create dataset for model with collinear variables
	d=DataFrame({'x1':x1,'x2':x2})
	# Add intercept
	d=sm.add_constant(d)

	# Run Model
	mod2=sm.OLS(y,d).fit()
	x_1=mod2.params[1]
	x_2=mod2.params[2]
	x_11.append(x_1)
	x_22.append(x_2)

	
cor=pearsonr(d['x1'],d['x2'])
print('Correlation between x1 and x2 is:',cor[0])

mod2.summary()
# Print expectation of each estimator 	
statistics.mean(x_11)
statistics.mean(x_22)

# Print standard deviation of each estimator 	
statistics.stdev(x_11)
statistics.stdev(x_22)

end
*d=DataFrame({'x1':x1, 'x2':x2, 'x3':x3,'u':u})


*a) We can see that the multicollinearity made the coefficient values not true to the true parameter. Essentially off by half the true value. The population beta1 is 5 where beta1 hat is 2.9. We see that the regression confused variation in x2 in interpreting the coefficients. Interesting that the p values are both highly significant. When it is 0.000, I will always look cautiously. We notice a high adjusted r squared and we reject the null on the F test. The variation in our IVS account for almost all of the variation in our y. The overlapping variation, multicollinearity, is a large (the whole in this case) portion of this variation. All this information is disregarded when calculating coefficients. Coefficients were primarily determined based upon the unobservables. We can see that our estimates are biased downward.  

*b) model violating zero conditional mean using omitting variable approach. X_22 = x_33 in the code. 
python
import statistics
from pandas import DataFrame
from scipy.stats import pearsonr

# Create filler variables 
x_11=[]
x_22=[]

#Run regression including collinear variables in loop 
for i in range(101):
	# create random variable 
	x1=np.random.normal(100,10,100)
	# Create collinear variable 
	x2=x1
	# create variable not systematically correlated with other x variables 
	x3=np.random.uniform(7,12,100)
	# Create different unobservables with different variances
	u=np.random.normal(0,1,100)
	e=np.random.normal(0,10,100)
	# create y variable with collinear variables
	y=5*x1+x2+x3+e

	# Create dataset for model with collinear variables, omitting x2 variable that is correlated with x1. 
	d=DataFrame({'x1':x1,'x3':x3})
	# Add intercept
	d=sm.add_constant(d)

	# Run Model
	mod2=sm.OLS(y,d).fit()
	x_1=mod2.params[1]
	x_2=mod2.params[2]
	x_11.append(x_1)
	x_22.append(x_2)
	
corr=pearsonr(d['x1'],d['x3'])
print('The correlation between x1 and x3 is:',corr[0])
	
mod2.summary()	
# Print expectation of each estimator 	
statistics.mean(x_11)
statistics.mean(x_22)

# Print standard deviation of each estimator 	
statistics.stdev(x_11)
statistics.stdev(x_22)	
end

*b) With omitting the correlated variable, our beta1 estimate is not overestimated rather than underestimated. If the omitted variable has positive correlation and positive beta2 in the original regression as does in this case, the bias induced from omission will be positive. Although it is now biased in a different direction...there is less bias than the multicollinearity case, but more variance in our estimator. 


*** Now we run another set of loops using more noise with 100 variance in our unobservables

python 
import statistics
from pandas import DataFrame
from scipy.stats import pearsonr


# Create filler variables 
x_11=[]
x_22=[]
x_33=[]
#Run regression including collinear variables in loop 
for i in range(101):
	# create random variable 
	x1=np.random.normal(100,10,100)
	# Create collinear variable 
	x2=x1
	# create variable not correlated with other x variables 
	x3=np.random.uniform(7,10,100)
	# Create different unobservables with different variances
	u=np.random.normal(0,1,100)
	e=np.random.normal(0,100,100)
	# create y variable with collinear variables
	y=5*x1+x2+e

	# Create dataset for model with collinear variables
	d=DataFrame({'x1':x1,'x2':x2})
	# Add intercept
	d=sm.add_constant(d)

	# Run Model
	mod2=sm.OLS(y,d).fit()
	x_1=mod2.params[1]
	x_2=mod2.params[2]
	x_11.append(x_1)
	x_22.append(x_2)

	
cor=pearsonr(d['x1'],d['x2'])
print('Correlation between x1 and x2 is:',cor[0])

mod2.summary()
# Print expectation of each estimator 	
statistics.mean(x_11)
statistics.mean(x_22)

# Print standard deviation of each estimator 	
statistics.stdev(x_11)
statistics.stdev(x_22)

end
*d=DataFrame({'x1':x1, 'x2':x2, 'x3':x3,'u':u})


*a) We can see that the multicollinearity model has higher variance, by around the same factor that we scaled variance (10), and that our mean estimators increased very very slightly.  

*b) model violating zero conditional mean using omitting variable approach. X_22 = x_33 in the code. 
python
import statistics
from pandas import DataFrame
from scipy.stats import pearsonr

# Create filler variables 
x_11=[]
x_22=[]

#Run regression including collinear variables in loop 
for i in range(101):
	# create random variable 
	x1=np.random.normal(100,10,100)
	# Create collinear variable 
	x2=x1
	# create variable not systematically correlated with other x variables 
	x3=np.random.uniform(7,12,100)
	# Create different unobservables with different variances
	u=np.random.normal(0,1,100)
	e=np.random.normal(0,100,100)
	# create y variable with collinear variables
	y=5*x1+x2+x3+e

	# Create dataset for model with collinear variables, omitting x2 variable that is correlated with x1. 
	d=DataFrame({'x1':x1,'x3':x3})
	# Add intercept
	d=sm.add_constant(d)

	# Run Model
	mod2=sm.OLS(y,d).fit()
	x_1=mod2.params[1]
	x_2=mod2.params[2]
	x_11.append(x_1)
	x_22.append(x_2)
	
corr=pearsonr(d['x1'],d['x3'])
print('The correlation between x1 and x3 is:',corr[0])
	
mod2.summary()	
# Print expectation of each estimator 	
statistics.mean(x_11)
statistics.mean(x_22)

# Print standard deviation of each estimator 	
statistics.stdev(x_11)
statistics.stdev(x_22)	
end

* We can see similar results for our omitted model. The variance of our estimator jumped up tremendously with the increase in error variance. In our omitted variable model, we can see that the mean beta hat estimates become slightly (.01) closer to the true population value (less bias) but our variance is significantly higher. Thus, we might not produce a consistent estimate if we use different samples from the population. We can see what increasing variance in the unobservables will do consistency. 

