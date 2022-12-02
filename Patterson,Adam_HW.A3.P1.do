
set more off
clear all
cap log close


** Homework Assignment 3 A1Q1

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
log using "$log/homework.A3P1.log", replace

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

************************** Question 1
***** Note, I did not remove 2 obs where earnwke=0 as STATA autommatically did. Thus, my results will be different. Python does not allow me to log a 0. I was taught to never remove observations. Thus, I was contemplating changing the 0 values to 1 so that the log would be equal to 0. I ended up changing 0 to .01 so that the log value became close to -2. This will allow a near uniform transformation of all variables. 
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
d.head()

# a) Create experience proxy variable as defined by Jacob Mincer (age - education - 6) 
d['potential_experience']=d['age'] - d['ihigrdc'] - 6
d['potential_square']=d['potential_experience']**2
str(d['potential_experience'])
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
mod1.summary()


# c) Regression of natural log of weekly earnings on years of schooling and potential experience 
# Create variables
x=d[['ihigrdc','potential_experience']]
y=d['earnings_log']
x=sm.add_constant(x)
# Run OLS model 
mod2=sm.OLS(y,x).fit()
mod2.summary()

# e)  12 schooling and 20 years potential experience.
# Create new data for 12 years schooling and 10 years experience
new1=[1,12,10]
new2=[1,12,20]
print('The predicted % earnings increase for 12 years of schooling and 10 years of experience is:',round(float(mod2.predict(new1)),2), '%')
print('The predicted % earnings increase for 12 years of schooling and 20 years of experience is:',round(float(mod2.predict(new2)),2), '%')

# I tried to log the predicted earnings increase to interpret as level earnings
print('The earnings prediction is 12 yrs of school and 10 yrs experience:',np.exp(round(float(mod2.predict(new1)),2)))
print('The earnings prediction is 12 yrs of school and 20 yrs of experience:',np.exp(round(float(mod2.predict(new2)),2)))

#We should run a level-level model to predict the amount of earnings as question asks, to confirm that that earnings increase is the same. 
y=d['earnwke1']
x=sm.add_constant(x)
# Run OLS model 
mod2=sm.OLS(y,x).fit()
mod2.summary()
print('The predicted  earnings increase for 12 years of schooling and 10 years of experience is:',round(float(mod2.predict(new1)),2))
print('The predicted  earnings increase for 12 years of schooling and 20 years of experience is:',round(float(mod2.predict(new2)),2))

# They are not the same, thus I would take the results from the level-level model. I even used earnwke1 to have same variable as log transformation 

# f) Run same model as in c but include potential experience squared
# Create squared variable
d['potential_square']=d['potential_experience']**2
x=d[['ihigrdc','potential_experience','potential_square']]
y=d['earnings_log']
x=sm.add_constant(x)
# Run OLS
mod3=sm.OLS(y,x).fit()
mod3.summary()

end

*d) We see that the coefficient of ihigrdc became slightly more positive when controling for potential experience. Omitting potential experience caused our estimate to be downward biased. This follows intuition as the cov between potential experience and years education is negative while the effect of potential experience on wage should be positive. Thus a negative times positive equals a negative bias in our original beta hat. 

*g) potential exeperience has a positive effect on earnings up until 25.78 years. After 25.78 years, additional potential experience starts to decrease wage relative to the maximizing value of 25.78


************************** Question 2

python
import scipy 
from scipy import stats
from statsmodels.formula.api import ols
from statsmodels.stats.weightstats import ttest_ind
## create dummy variables
# Classify education as integer
d['ihigrdc']=d['ihigrdc'].astype(int)
# Create edle12
d['elde12']=d['ihigrdc'].astype(int)
# When values greater than 12, set equal to 12
d['elde12'].values[d['elde12']>12]=12
# Create edgt12
d['edgt12']=d['ihigrdc'] - 12
# Make negative values equal to 
d['edgt12'].values[d['edgt12']<0]=0
d.head()
# a) Rewriting the model so that the test involves only a single coefficient:
# ln earnwke = beta.naught + beta.1_age + theta.1_edgt12 + beta.3(elde12+edgt12). Where ihigrdc = elde12+edgt12 ; theta1 = beta2

# Classify and Run OLS model with transformed model
mod4=ols('earnings_log~age+edgt12+ihigrdc', data=d).fit()
mod4.summary()

# b) Yes, we reject the null hypothesis at the 5 percent level. We reject at the 2 percent level. 
# c) The p value of our test is .019  . d follows

# Calculate array with desired coefficient restrictions (that b2 is equal to b3)
b=np.array([0,0,1,-1])
print(mod4.f_test(b))

# Now we run original model to see if different at all 
mod5=ols('earnings_log~age+elde12+edgt12', data=d).fit()
b=np.array([0,0,1,-1])
print(mod5.f_test(b))

# e) do you reject at the 5 percent level? Yes, we reject the null at the 5 % level when using the originally written model, not with transformed

# f) what is the p-value of your test? P value is .018534 for the original model and .58 for the transformed
end





************************** Question 3
*a) regression code below .
python
import pandas as pd
import numpy as np
import statsmodels.api as sm
import math 
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm

# read data into memory. note the r before character value to input string as raw string. 
# Data does not read properly without it
d=pd.read_stata(r"$dta\cps_ps2.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last few columns
d.head()
d['potential_experience']=d['age'] - d['ihigrdc'] - 6
# Create squared variable
d['potential_square']=d['potential_experience']**2
mod5=ols('earnwke~ihigrdc+potential_experience+potential_square', data=d).fit()
mod5.summary()
print('The value of SSR for the unrestricted model is:',mod5.ssr)
mod5restricted=ols('earnwke~ihigrdc',data=d).fit()
mod5restricted.summary()
print('The value of SSR for the restricted model is:',mod5restricted.ssr)

#calculate test statistic. Save SSR as variables
restricted=mod5restricted.ssr
unrestricted=mod5.ssr
# Create F Stat
F=((restricted-unrestricted)/2)/(unrestricted/796)
# Print F Stat
print('The calculated F stat is:',F)

# Verify results
anovaResults = anova_lm(mod5restricted,mod5)
print(anovaResults)







end
*b) beta2 = beta3 = 0 when beta2 = coefficient for potential experience and beta3 is the coefficient for potential experience squared.

*c) The value of "q" in this case is 2. There are 2 restrictions, beta 2 equal to 0 and beta 3 equal to 0

*d) 800-3-1 = 796

*e) value of SSR restricted is printed above and equals 174622633.5167995

*f) value of SSR unrestricted is printed above and equals 171560527.59715497

*g) F stat is printed above and equals 7.10

*h) Yes we reject the null

*i) The anova results are printed above. We can see that the calculated F statistic is 7.10 just as calculated