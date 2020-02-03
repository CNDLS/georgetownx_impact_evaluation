#delimit;
clear;
pause on;
cap log close;
set more off;
set logtype text;
version 11.2;

**** Before you run this code you need to set the paths to the appropriate locations;
* Set the working directory;
cd "C:\Users\tarozzino\Dropbox\Experimental\AERR\Final\Stata";

log using "tableA11_validation", replace;

use "validationdata";
gen microscopy = 0 if result_clinic=="neg";
replace microscopy = 1 if result_clinic=="Pf";
replace microscopy = 2 if result_clinic=="Pv";
label define rdt 1 "Pf or mixed" 2 "Pf" 3 "non-Pf" 4 Negative, modify;
label values result_1-result_3 rdt;

gen rdt_1 = result_1<4;
gen rdt_2 = result_2<4;
gen rdt_3 = result_3<4;
gen micro = microscopy>0;

pwcorr rdt_* micro, star(1);

tab rdt_1 micro;
tab rdt_2 micro;
tab rdt_3 micro;

cap log close;
