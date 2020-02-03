//Task 1

drop _all
set more off

cd "/mass_storage/WB/Module 6" //Note - this path and the path to the dta file may vary on your computer 

use "Data/Thornton HIV Testing Data.dta", clear

generate treatment = cond(tinc>0, 1,0)
label define treatment 0 "Control" 1 "Treatment"
label val treatment treatment

//Task 2 
generate followed_treatment = cond(treatment==1, got, 1-got)

tab followed_treatment if treatment == 0 //control 
tab followed_treatment if treatment == 1 //treatment 

//Task 3
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
tab followed_treatment if treatment == 0 //control 
tab followed_treatment if treatment == 1 //treatment 

regress got treatment, robust
restore 

//Task 4
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive

regress anycond treatment, robust
restore

//Task 5 
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
drop if missing(anycond)

regress got treatment, robust

dis "TOT = " .2285714/.4142857
restore

//Task 6 
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive

ivregress 2sls anycond (got = treatment), robust 
restore

//Task 7 
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
generate attrited = 1- followupsurvey
label var attrited "Respondent attrited"
label define attrited 0 "Did not attrite" 1 "Attrited"
label val attrited attrited
tabulate attrited

restore

//Task 8
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
regress followupsurvey treatment, robust

restore

//Task 9
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
keep if followupsurvey == 1

orth_out age male mar educ2004 hadsex12 tb land2004 usecondom04, by(treatment) pcompare stars se count

restore 

//Task 10 
//Upper bound 
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
replace anycond = 1 if followupsurvey==0 & treatment == 1
replace anycond = 0 if followupsurvey==0 & treatment == 0

regress anycond treatment, robust
restore 

//Lower bound 
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
replace anycond = 0 if followupsurvey==0 & treatment == 1
replace anycond = 1 if followupsurvey==0 & treatment == 0

regress anycond treatment, robust
restore 

//Task 11
preserve 
keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive

leebounds anycond treatment 
restore 
