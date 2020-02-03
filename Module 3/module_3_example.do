drop _all 
set more off 

cd "/mass_storage/WB/Module 3/Data" 
use lakisha_aer.dta, clear 

describe

summarize yearsexp, detail 

histogram yearsexp 

graph export "../Images/hist1.png", width(1000) replace  //This saves the histogram in "/mass_storage/WB/Module 3/Images"

histogram yearsexp, normal 

graph export "../Images/hist2.png", width(1000) replace  

histogram yearsexp, by(race) 

graph export "../Images/hist3.png", width(1000) replace  

generate race_numeric = cond(race=="w",0,1)

tabulate race

tabulate call race

//Optional bonus exercise 

drawnorm X, n(100) means(10) sds(10) clear

graph export "../Images/hist4.png", width(1000) replace 

//First create our underlying distribution and save it to a temporary file so that we can recall it 

tempfile normal_distribution 
drawnorm X, n(10000) means(10) sds(10) clear
save `normal_distribution'

tempfile results

forval i = 1/100 {

use `normal_distribution', clear

set seed `i' //This is so we get a different set of observations each time 
generate order = runiform()
sort order //These two lines of code create a random order to the observations, then we take the first 100, so they change each time 

keep if _n <= 100 
drop order 

collapse (mean) mean = X (sd) sd = X //Replaces the 100 observations with 1 observation containing the mean and standard deviation
generate variance = sd^2 //Convert the standard deviation to the variance
drop sd //Get rid of the standard deviation variable

if `i' == 1 {

save `results' // On the first iteration, we need to create a new file

}

else { //on the 2nd-100th iteration we need to append to the results file

append using `results'
save `results', replace

}

}

list if _n < 11 //List first 10 observations 

histogram mean, normal 

graph export "../Images/hist5.png", width(1000) replace 

summarize mean, detail 

//Now uniform distributions 

drop _all 
set obs 100 

local lower = 10 - 0.5*((1200)^0.5) //These scalars are to get a variance of 100
local upper = 10 + 0.5*((1200)^0.5)

generate X = runiform(`lower',`upper')

histogram X 

graph export "../Images/hist6.png", width(1000) replace 

tempfile uniform_distribution 

drop _all 

set obs 10000

local lower = 10 - 0.5*((1200)^0.5) //These scalars are to get a variance of 100
local upper = 10 + 0.5*((1200)^0.5)

generate X = runiform(`lower',`upper')

save `uniform_distribution'

tempfile results


forval i = 1/100 {

use `uniform_distribution', clear

set seed `i' //This is so we get a different set of observations each time 
generate order = runiform()
sort order //These two lines of code create a random order to the observations, then we take the first 100, so they change each time 

keep if _n <= 100 
drop order 

collapse (mean) mean = X (sd) sd = X //Replaces the 100 observations with 1 observation containing the mean and standard deviation
generate variance = sd^2 //Convert the standard deviation to the variance
drop sd //Get rid of the standard deviation variable

if `i' == 1 {

save `results', replace //On the first iteration, we need to create a new file

}

else { //on the 2nd-100th iteration we need to append to the results file

append using `results'
save `results', replace

}

}
histogram mean, normal 

graph export "../Images/hist7.png", width(1000) replace 

summarize mean, detail 
