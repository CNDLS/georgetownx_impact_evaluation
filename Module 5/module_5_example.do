//Example .do file for Module 5: Regression 

//Task 1
drop _all
set more off

cd "C:\\Module 5\Data"

use "Thornton HIV Testing Data.dta", clear
describe

//Task 2
tabulate tinc

//Task 3
generate treatment = cond(tinc>0, 1,0)
label define treatment 0 "Control" 1 "Treatment"
label val treatment treatment

//Task 4
regress got treatment 

//Task 5
regress got treatment, robust

//Task 6
regression got treatment 
estat hettest

//Task 7
summarize got if treatment == 0
summarize got if treatment == 1

//Task 8
regress got treatment age, robust

//Task 9
generate treatxmale = treatment*male

regress got treatment male treatxmale, robust

//Task 10 
generate treatxage = treatment*age
regress got treatment age treatxage, robust
