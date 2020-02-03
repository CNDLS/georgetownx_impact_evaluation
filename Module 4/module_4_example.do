//Task 1

drop _all
set more off

cd "/mass_storage/WB/Module 4"

use "Data/TarozziEtAlReplicationFiles/panel_biomarkers.dta", clear

describe

//Task 2

ci mean survey_m61

//Task 3

*90% CI
ci mean survey_m61, level(90)

*99% CI
ci mean survey_m61, level(99)

//Task 4
ttest survey_m61 == 1

//Task 5
ttest survey_m61 == .095

//Task 6
generate treat_loan = 1 if arm_mf == 1
replace treat_loan = 0 if arm_c == 1

label define treat_loan 0 "Control" 1 "MF loan"
label val treat_loan treat_loan

ttest netlast_fup, by(treat_loan)

//Task 7
generate treat_free = 1 if arm_free == 1
replace treat_free = 0 if arm_mf == 1

label define treat_free 0 "MF Loan" 1 "Free"

ttest netlast_fup, by(treat_free)
