cap log close
* Set global vars 
global root "P:/Metrics"
global do "$root/do"
global dta "$root/dta"
global log "$root/log"

* Add a log file for the output. I have attached the log file to the homework problem
* so that you can verify my code works without having to download python if you do not want
* If you have any questions, reach out to me before or after class
log using "$log/homework4.log", replace

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
import os
path = "$dta/"
os.chdir(path)
os.getcwd()

dtafile = '$dta/howa_LCC_Yields.dta'
data1 = pd.read_stata(dtafile)

dtafile2= '$dta/hua14_mapunit_areas.dta'
data2 = pd.read_stata(dtafile2)

data1.shape
data2.shape

result = pd.merge(data1, data2, on="MapUnitSymbol")
result.head()
result.tail()
result.shape

result = result.replace("---","na")

result.to_stata('mergedData.dta')
end


use "$dta/mergedData.dta"
tab LCC
label variable index "observation number"
label variable MapUnitSymbol "observation number"
label variable LCC "LLC"
label variable HUA14 "hydrologic units"
label variable mapUnitArea "area of each map unit within each HUA14 area"
label variable HUA14_Area "HUA14 Area"
save "$dta/mergedData.dta", replace

