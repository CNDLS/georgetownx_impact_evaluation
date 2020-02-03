*Change the current directory to YOUR Module 8 folder 
*cd {directory}

//Task 1 
set more off 
drop _all 

use "Data/Code & Result/AEA_P&P_table.dta", clear 

describe 

//Task 2 
label define post 0 "Before ETS" 1 "After ETS"
label val post post 

label define region 0 "Non-ETS region" 1 "ETS region"
label val region region

regress logenvrAEW post##region, cluster(id)

//Task 3
regress logenvrAEW post##region t_Assets t_Revenue, cluster(id)

//Task 4
regress logNon_envrAEW post##region t_Assets t_Revenue, cluster(id)

//Task 5
label define Ind 0 "Unaffected industry" 1 "Affected industry"
label val Ind Ind 

regress logenvrAEW post##region##Ind t_Assets t_Revenue, cluster(id)

//Task 6
regress logNon_envrAEW post##region##Ind t_Assets t_Revenue, cluster(id)
