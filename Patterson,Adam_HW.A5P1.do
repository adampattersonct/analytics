
set more off
clear all
cap log close


** Homework Assignment 3 A5Q1-Q5

/*
* created by: Adam Patterson
* date: Dec 3, 2021
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
log using "$log/homework.A5P1.log", replace

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
from statsmodels.formula.api import ols
from statsmodels.discrete.discrete_model import Probit
from statsmodels.discrete.discrete_model import Logit
# read data into memory. note the r before character value to input string as raw string. 
# Data does not read properly without it
d=pd.read_stata(r"$dta\corpus.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last columns
d.head()
d.shape
for col in d:
	print (col)
end


******* Question 1
* LPM Model
python 
mod1=ols('accept~black+hisp+othrace+age+edlt10+ed10_11+ed13_15+edgt15',data=d).fit()
mod1.summary()
end

* Probit Model 
python 
y=d['accept']
x=d[['black','hisp','othrace','age','edlt10','ed10_11','ed13_15','edgt15']]
x=sm.add_constant(x)
mod2=Probit(y,x).fit()
mod2.summary()
end

* Logit Model 
python 
mod3=Logit(y,x).fit()
mod3.summary()
end

* The estimates should be different from each other, with the probit and logit models, if the distribution of the error was much different than normally distributed. Depends on the tails of the distribution really, which relates to Kurtosis and the depth of outliers amongst our sample. With more error in the tails, the link function(?) (or transition point of S) may get pulled to the left or right depending on where the outliers are. We can see in the summary that the Kurtosis value is 1.3, signaling that the tails are lighter than the normal distribution. Taking this information into account, we do not anticipate the results to vary drastically between models. We do, however, see that some coefficients are noticeably different, for example education less than 10.  We would anticipate the LPM to deliver different results if many of the observations are near end points of probability [0,1], thus some of the fitted values will lie outside the bounds of possibility. *If multiple alternatives exist as a dependent variable, we must evaluate the independence of unobservables in evaluating our logit model





******** Question 2  
* Derivatives calculated at the mean using 'mean' and default uses the mean of the marginal effects at each observation or 'overall' effects
* The constant marginal effect of our LPM model are the parameters themselves
python
# Print marginal effects at the mean
print(mod2.get_margeff('mean').summary())
print(mod3.get_margeff('mean').summary())

# Calculate Overall marginal effects for each model 
print(mod2.get_margeff().summary())
print(mod3.get_margeff().summary())
end


* III, calculate mean derivatives using predicted probabilties
python 
# LPM 
predicted_LPM= mod1.predict()
predicted_probit= mod2.predict()
predicted_logit= mod3.predict()



# Re-run models with different age
d['age2']=d['age'] + .2
mod1a=ols('accept~black+hisp+othrace+age2+edlt10+ed10_11+ed13_15+edgt15',data=d).fit()
y=d['accept']
x=d[['black','hisp','othrace','age2','edlt10','ed10_11','ed13_15','edgt15']]
x=sm.add_constant(x)
mod2a=Probit(y,x).fit()
mod3a=Logit(y,x).fit()


predic=mod2a.predict()



# Get predicted probabilties using new age variable, age2
predicted_LPMa= mod1a.predict()
predicted_probita= mod2a.predict()
predicted_logita= mod3a.predict()

# Get difference in probabilites
lpm_diff=abs(predicted_LPM-predicted_LPMa)
probit_diff=abs(predicted_probit-predicted_probita)
logit_diff=abs(predicted_logit-predicted_logita)

lpm_ratio= lpm_diff / .2
probit_ratio= probit_diff / .2
logit_ratio= logit_diff / .2

print(lpm_ratio)
print(probit_ratio)
print(logit_ratio)




## Run models again with difference in age embedded in same model as classmates get different result from this
d['age']=d['age']+ .2
mod1a=ols('accept~black+hisp+othrace+age+edlt10+ed10_11+ed13_15+edgt15',data=d).fit()
y=d['accept']
x=d[['black','hisp','othrace','age','edlt10','ed10_11','ed13_15','edgt15']]
mod2a=Probit(y,x).fit()
mod3a=Logit(y,x).fit()

# Get predicted probabilties using new age variable, age2
predicted_LPMa= mod1a.predict()
predicted_probita= mod2a.predict()
predicted_logita= mod3a.predict()

# Get difference in probabilites
lpm_diff=abs(predicted_LPM-predicted_LPMa)
probit_diff=abs(predicted_probit-predicted_probita)
logit_diff=abs(predicted_logit-predicted_logita)

lpm_ratio= lpm_diff / .2
probit_ratio= probit_diff / .2
logit_ratio= logit_diff / .2

# The mean derivative values are
print(lpm_ratio.mean())
print(probit_ratio.mean())
print(logit_ratio.mean())


end

* The ratios are equal to 0 when using a different model with age2. However, replacing age in the same model produces a different result. I have to figure out why this happens econometrically  

* We can also calculate elasticities off of this function d (lny) / d(lnx)
python
print(mod2.get_margeff(method='eyex').summary())
end


*a) We see the results for the probit are similar in all cases 
*b) We do not notice drastic differences in the marginal effects given different different evaluation metrics 

******** Question 3
python
# mod2.llf is log likelihood of full model and mod2.llnull consists of the null log likelihood (model with just constant)		
LR_index=1-(mod2.llf/mod2.llnull)
print(LR_index)

# Or we can call the calculated pseudo r squared option
mod2.prsquared
end
*According to these results, our model does not fit very well. The log likelihood of both the full and null model are close to each other at -746 and -742. Thus the proportion of the likelihoods is close to 1 and results in a small value when subtracted by 1. 


******** Question 4

python 
# Create variable for sample fraction of persons accepted
total_accept= sum(d['accept'])
sample_accept=total_accept/ len(d['accept'])
print(sample_accept)
end

* Calculate the prediction rate for .5 and the sample fraction 
python 
# Prediction using sample fraction as predicted probability threshold for acceptance 
mod2.pred_table(sample_accept)

# Calculate percentage of correct predicted
correct0=mod2.pred_table(sample_accept)[0][0]/(mod2.pred_table(sample_accept)[0][1]+mod2.pred_table(sample_accept)[0][0])
correct1=mod2.pred_table(sample_accept)[1][1]/(mod2.pred_table(sample_accept)[1][0]+mod2.pred_table(sample_accept)[1][1])

# Calculate weighted average of correct predictions 
weighted_averaged_sample_fraction= sample_accept*correct1 + (1-sample_accept)*correct0
print('The weighted average of correct predictions is:',weighted_averaged_sample_fraction)

# Using .5 as predicted probability threshold for acceptance 
mod2.pred_table(.5)
weighted_average_half= (1-sample_accept)
print('The weighted proportion of correct predictions is:',weighted_average_half)
end

* Using .5 as the threshold created a prediction of all 0 values. Thus, we see that the model incorrectly predicted all 419 accepted individuals while correctly predicting the unaccepted. Looking at the table results, we would think that the threshold with .5 probability would perform worse than the sample probability. We can see that adjusting for the proprotion in our sample created the prefered threshold. There is not much prediction power in selecting all values for 0 if we are interested in predicting treatment. I guess our prefered goodness of fit would depend on what research we are conducting... are we more interested in reducing type I or type II errors? I would intuitively try to rebalance or use the true sample proportion as a threshold to avoid this prediction bias of predicting all 0's. Thus, using the sample population prop as a threshold results in a model better in my opinion. 



******** Question 5 
*Repeat the JTPA-Corpus 4 but omitting the years of completed schooling indicator variables and the age variable from the model. Report the performance of the model relative to these criteria. Indicate whether or not removing the schooling and age variables has an effect on the predictive performance, and explain why or why not.
python 
# Subset required variables
y=d['accept']
x=d[['black','hisp','othrace']]
x=sm.add_constant(x)
# Run Model
mod2a=Probit(y,x).fit()
# Produce Results 
mod2a.summary()


# Calculate predictions using Sample proportion 
mod2a.pred_table(sample_accept)

# Calculate percentage of correct predicted
correct0=mod2a.pred_table(sample_accept)[0][0]/(mod2a.pred_table(sample_accept)[0][1]+mod2a.pred_table(sample_accept)[0][0])
correct1=mod2a.pred_table(sample_accept)[1][1]/(mod2a.pred_table(sample_accept)[1][0]+mod2a.pred_table(sample_accept)[1][1])
print('The unweighted average for correct predictions of 0:',correct0)
print('The unweighted average for correct predictions of 0:',correct1)

# Calculate weighted average of correct predictions 
weighted_averaged_sample_fraction= sample_accept*correct1 + (1-sample_accept)*correct0
print('The weighted average of correct predictions is:',weighted_averaged_sample_fraction)

# Using .5 as predicted probability threshold for acceptance (Simple estimation as correct value for True Positives is 0)
mod2a.pred_table(.5)
weighted_average_half= (1-sample_accept)
print('The weighted proportion of correct predictions is:',weighted_average_half)

end

* Dropping the age and education variables still result in our model predicting all 0 values when the threshold is .5. We can see that using the sample proportion as our threshold increased model predictive power by approximately 2.5%. Reducing age and education variables appear to help the predictive power only when using the sample fraction.





***********Warning : Question 6 and 7 was a bit of a bear in python . You will see many debugs and errors that did not work when I researched a solution. I left 
*********** the errors to show my effort and work in trying to find a time efficient solution.


******** Question 6
*Interpretation of Question 6a is in RMD PDF as I could classify "other" category as reference. This made it easier for interpretation 
** Load Data
python
# read data into memory. note the r before character value to input string as raw string. 
# Data does not read properly without it
d=pd.read_stata(r"$dta\jcity.dta")
d=pd.DataFrame(d)
# Call first five observations of the first and last columns
d.head()
d.shape
end

** Create dummy variables for education and race 
python 

# Create dummy variables for education
d['edlt10']=0
d['ed10_11']=0
# create educaton 12 variable although this is omitted and our base group
d['ed12']=0
d['ed13_15']=0
d['edgt15']=0

# Fill column with 1 value if argument is true
d.loc[(d['edcat'] ==1), ['edlt10']]=1
d.loc[(d['edcat'] ==2), ['ed10_11']]=1
d.loc[(d['edcat'] ==3), ['ed12']]=1
d.loc[(d['edcat'] ==4), ['ed13_15']]=1
d.loc[(d['edcat'] ==5), ['edgt15']]=1

# Create dummy variable for race
d['white']=0
d['black']=0
d['hispanic']=0
d['asianoth']=0

d.loc[(d['race'] ==1), ['white']]=1
d.loc[(d['race'] ==2), ['black']]=1
d.loc[(d['race'] ==3), ['hispanic']]=1
d.loc[(d['race'] ==4), ['asianoth']]=1


# Print head to confirm that dummy structure works properly 
d.head()

end


* Start Multinomial model  age,years of schooling, race, neverwkr  
python 
import statsmodels.formula.api as smf
# Subset endogenous and exogenous variables used for our MN Logit model
y=d['trtmnt']
x=d[['age','nvrwrk','edlt10','ed10_11','ed13_15','edgt15','white','black','hispanic']]
x=sm.add_constant(x)
# Classify y as list otherwise will not run. Python is tricky like this. This took a long time for me to debug for a simple issue
y=list(y)
# Create Multinomial Logit Model
mod6=sm.MNLogit(y,x).fit()
# Print Results Summary
mod6.summary()

# I would like to figure out how to omit the y=other group for our base group comparison. Seems I would have to rename variables. Taking too long to debug 
end

* We can see that our base group is the treatment group receiving classroom training in occupational skills treatment stream. I know to pick my baseline carefully but given feasibility of time constraint I am facing with this assignment, I cannot research how to change this in Python other than re-ordering names. I had serious trouble with wald test below, ordered multinomial, and multinomial. I assume because my y is a list output and  I have to correct for this with matrix arrays. I would need much more time to get this up and running in python. 


* Mean derivatives of probability of being in each stream for age variable (Just look at the age variable for each marginal effect summary) 
python
# Marginal effects at mean
mod6.get_margeff('mean').summary()

# Overall marginal effects 
mod6.get_margeff().summary()
end 
* We notice a difference, in sign and magnitude, in marginal effect of the black variable between the three choice groups. This trend is true of white and hispanic variables also. The education variables are relatively stable.

**Program marginal effect for age using formula in class
python
from scipy.stats import norm
import matplotlib.pyplot as plt
import numpy as np

# Get predictions of mod6 (subset by stream)
multi_prediction=mod6.predict()

# Get density of fitted values
density=norm.pdf(multi_prediction)

# Create analytical derivatives for each stream 
age_derivative_on_job=density*mod6.params[1][0]
age_derivative_other=density*mod6.params[1][1]

print('The age drivative for on the job training compared to class training is:',age_derivative_on_job)
print('The age drivative for other training compared to class training is:',age_derivative_other)
end 

** Marginal effects for age by each stream are printed above in the marginal effects result command. 


** Calculate Likelihood Index. Likelihood ratio and wald test are in the R pdf as I could not get them to run (see below) 
python
# mod6.llf is log likelihood of full model and mod2.llnull consists of the null log likelihood (model with just constant)		
LR_index1=1-(mod6.llf/mod6.llnull)
print('Hand calculated LR Index is:',LR_index1)

# Or we can call the calculated pseudo r squared option
print('Python calculated LR Index is:',mod6.prsquared)
end
* Our hand calculate and python generated LR Index is exactly the same, a good sign. We can see that our model does not perform well given the likelihood criteria.


* Calculate Wald Test ( many debug errors, I could not solve this question)
python 
# Perform wald test join sig with hypotheis 0
mod3.wald_test_terms()

# We can see it works with other models. It should also be in multinomial results. I could not get it to run after a few hours
mod6.wald_test_terms()

# Printing mod6 result attributes, we have a wald test term within the model output. I truly am baffled
for attr in dir(mod6):
    if not attr.startswith('_'):
        print(attr)
end
		
* Trying multiple alternative solutions for the wald test yields no success		
python
# Adding coefficient restrictions manually 
mod6.wald_test_terms([0,0,0,0,0,0,0,0,0])

# Trying a technique I found online
R = np.eye(len(mod6.params))
print(R)
mod6.wald_test(R)


# Try using array hypotheis used in F tests 
R = [[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0]]
mod6.wald_test(R)
# Reduce coefficients by 1
R = [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
mod6.f_test(R)

# Create string hypothesis as array not working
hyp='(age = 0),(nvrwrk=0),(edlt10=0),(ed10_11=0),(ed13_15=0),(edgt15=0),(white=0),(black=0),(hispanic=0)'
mod6.wald_test(hyp)
mod6.wald_test_terms(skip_single=False,combine_terms=['age','nvrwrk','edlt10','ed10_11','ed13_15','edgt15','white','black','hispanic'])

# Try solution from online
R = np.eye(len(mod6.params))
mod6.wald_test(R)

# Another solution from online
a=np.identity(len(mod6.params))
a=a[1:,:]
print(a)
mod6.wald_test(a)


hyp='(age = 0),(nvrwrk=0),(edlt10=0),(ed10_11=0),(ed13_15=0),(edgt15=0),(white=0),(black=0),(hispanic=0)'
str(hyp)

b=np.array(([0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0]))

hyp1='(age=0)'
mod6.wald_test(b)

mod6.f_test(b)


# Perform the likelihood test
mod6.loglike().summary()


end



********* Question 7 
* Below is an ordered logit model. I had a hard time finding ordered probit in any python packages. I would have had to manually create the model
* Examples online use OrderedModel from statsmodels.miscmodels.ordinal_model however that package may be removed ? I get the error below

* Reference : https://www.statsmodels.org/devel/examples/notebooks/generated/ordinal_regression.html (taken from R package, if this was research I would just bring it into R. This is very irritating to me, I can usually get packages to run)

* Reference2 (forum) : https://stackoverflow.com/questions/28035216/ordered-logit-in-python/32007463#32007463
*** Looks like I need to download the development version of OrderedModel as dev is ahead of current package. I need pip3 install to do this, and I cannot efficiently figure out how to do this in a timely sense. 

python 
from statsmodels.miscmodels.ordinal_model import OrderedModel
from statsmodels.discrete.discrete_model import Probit
import numpy as np
import pandas as pd
import scipy.stats as stats

d=pd.read_stata(r"$dta\corpus.dta")
d=pd.DataFrame(d)
d.head()

# Create dummy variables 
# Create variable. Make equal to base year requested , education equals to 12 
d['edCat']=2 
# Create lower than 12 years and greater than 12 years of education variables 
d.loc[(d['edlt10'] ==1), ['edCat']]=1
d.loc[(d['ed10_11'] ==1), ['edCat']]=1
d.loc[(d['ed13_15'] ==1), ['edCat']]=3
d.loc[(d['edgt15'] ==1), ['edCat']]=3


# Run Model 
mod_log = OrderedModel(d['edCat'],
                        d[['age', 'black', 'hisp','othrace']],
                        distr='logit')

res_log = mod_log.fit(method='bfgs', disp=False)
res_log.summary()


# Try ordered probit found online 
mod_ordered_logit=Probit('edCat~age+black+hisp+othrace+C(edCat)',data=d).fit()

end


* try example directly from internet that individuals claim work. Reference is above from stack 
python
import numpy as np
import pandas as pd
import scipy.stats as stats
from statsmodels.miscmodels.ordinal_model import OrderedModel
url = "https://stats.idre.ucla.edu/stat/data/ologit.dta"
data_student = pd.read_stata(url)
mod_prob = OrderedModel(data_student['apply'],
                        data_student[['pared', 'public', 'gpa']],
                        distr='probit')

res_prob = mod_prob.fit(method='bfgs')
res_prob.summary()
end


* Also found the mord option from LogisticIT, it appears to work for others. 
python 
from mord import LogisticIT

c = LogisticIT() #Default parameters: alpha=1.0, verbose=0, maxiter=10000
y=d['edCat']
x=d[['age', 'black', 'hisp','othrace']]
c.fit(y,x)
c.fit(np.array([[0,0,0,1],[0,1,0,0],[1,0,0,0]]), np.array([1,2,3]))
c.predict(np.array([0,0,0,1]))
c.predict(np.array([0,1,0,0]))
c.predict(np.array([1,0,0,0]))

end



