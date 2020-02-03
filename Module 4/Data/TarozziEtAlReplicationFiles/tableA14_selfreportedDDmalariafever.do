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

log using "tableA14_selfreportedDDmalariafever", replace;

use "panel_biomarkers" if match==1;

* COLUMN 1, MALARIA/FEVER IN THE SAME MONTH AS THE INTERVIEW;
gen diff = survey_mf_now1 - survey_mf_now0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum survey_mf_now1 if vtype==1;

* COLUMN 2, TOTAL NUMBER OF MALARIA/FEVER EPISODES LAST 6 MONTHS;
replace diff = survey_mf61 - survey_mf60;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum survey_m61 if vtype==1;

* The following results use information at the household level. First generate the aggregates;

collapse arm_free arm_mf vtype (sum) cost_mf_days* cost_mf_expit* cost_mf_expdd* cost_mf_debt* cost_mf_less*, by(id_v id_hhno);

* COLUMN 3, NUMBER OF DAYS OF SCHOOL/WORK LOST IN HOUSEHOLD;
gen diff = cost_mf_days1 - cost_mf_days0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_mf_days1 if vtype==1;

* COLUMN 4, TOTAL EXPENDITURES;
replace diff = cost_mf_expit1 - cost_mf_expit0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_mf_expit1 if vtype==1;

* COLUMN 5, EXPENDITURES FOR DRUGS/DOCTORS;
replace diff = cost_mf_expdd1 - cost_mf_expdd0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_mf_expdd1 if vtype==1;

* COLUMN 6, # EPISODES PAID WITH DEBT;
replace diff = cost_mf_debt1 - cost_mf_debt0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_mf_debt1 if vtype==1;

* COLUMN 7, # EPISODES PAID WITH REDUCTED CONSUMPTION;
replace diff = cost_mf_less1 - cost_mf_less0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_mf_less1 if vtype==1;


cap log close;
