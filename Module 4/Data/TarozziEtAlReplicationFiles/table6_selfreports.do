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

log using "table6_selfreports", replace;

** THIS FILE GENERATES THE RESULTS IN TABLE 5 OF THE PAPER;
* As usual use only information from panel households present both at baseline and at follow-up (that is, match==1);
use "panel_biomarkers" if match==1;

* COLUMN 1, MALARIA IN THE SAME MONTH AS THE INTERVIEW;
gen diff = survey_m_now1 - survey_m_now0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum survey_m_now1 if vtype==1;

* COLUMN 2, TOTAL NUMBER OF MALARIA EPISODES LAST 6 MONTHS;
replace diff = survey_m61 - survey_m60;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum survey_m61 if vtype==1;

* The following results use information at the household level. First generate the aggregates;

collapse arm_free arm_mf vtype (sum) cost_m_days* cost_m_expit* cost_m_expdd* cost_m_debt* cost_m_less*, by(id_v id_hhno);

* COLUMN 3, NUMBER OF DAYS OF SCHOOL/WORK LOST IN HOUSEHOLD;
gen diff = cost_m_days1 - cost_m_days0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_m_days1 if vtype==1;

* COLUMN 4, TOTAL EXPENDITURES;
replace diff = cost_m_expit1 - cost_m_expit0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_m_expit1 if vtype==1;

* COLUMN 5, EXPENDITURES FOR DRUGS/DOCTORS;
replace diff = cost_m_expdd1 - cost_m_expdd0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_m_expdd1 if vtype==1;

* COLUMN 6, # EPISODES PAID WITH DEBT;
replace diff = cost_m_debt1 - cost_m_debt0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_m_debt1 if vtype==1;

* COLUMN 7, # EPISODES PAID WITH REDUCTED CONSUMPTION;
replace diff = cost_m_less1 - cost_m_less0;
reg diff arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;
sum cost_m_less1 if vtype==1;



log close;
