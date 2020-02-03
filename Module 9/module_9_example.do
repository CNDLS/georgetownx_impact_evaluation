*Change the current directory to YOUR Module 9 folder 
cd 

//Task 1 
set more off 
drop _all 

use "Data/module_9_data.dta", clear 

describe 

//Task 2 
generate testxjump = test*jump 
label var testxjump "Test x jump"

regress secondary test jump testxjump if abs(test) < 0.8, robust 

//Task 3
ssc install rdrobust 
rdplot secondary test if abs(test) < 1, c(0)

graph export "Graphs/secondary_education.png", width(1000) replace

//Task 4 
regress rv test jump testxjump if abs(test) < 0.8, robust 

//Task 5 
ivregress 2sls rv test testxjump (secondary = jump) if abs(test) < 0.8, robust

//Task 6 
rdplot rv test if abs(test) < 1, c(0)

graph export "Graphs/rv.png", width(1000) replace
