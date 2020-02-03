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

log using "tableA8_attrition", replace;

use "hhinfo_bl";
gen attrition = match==0 | match==6;
tab match attrition, missing;

replace head_age_bl = log(head_age_bl);
gen ratio = debtbiswa/(12*totexp_bl);
gen biswad_low = ratio<.05 if ratio<.;
gen biswad_high = ratio>.25 if ratio<.;

local regressors = "free mf lpce_bl hhsize electricity biswad_* pcnets last_net_bl usual_net_bl head_male_bl head_age_bl head_anysch_bl";
sum `regressors', sep(0);

* Column 1 of Table A.8: Attrition between Pre and Post Intervention Household Surveys;
reg attrition;

* Column 2;
reg attrition free mf, cluster(id_v);

* Column 3;
reg attrition `regressors', cluster(id_v);

* Column 4;
reg attrition `regressors' biom_mal biom_anem, cluster(id_v);

cap log close;
