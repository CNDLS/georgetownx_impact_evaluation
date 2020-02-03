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

log using "tableA10_bloodtestabsence", replace;

*** Generates the estimates in Table A.10: Post-intervention Malaria Biomarkers: Testing Success Rate in Baseline Households;

use "panel_biomarkers" if match==1;

* Generate age/gender categories. Adult (15-45) males will be the omitted category;
gen age0_5m = (age1 < 5)*(1-female) if age1<.;
gen age0_5f = (age1 < 5)*female if age1<.;
gen age5_15m = (age1>=5 & age1<15)*(1-female) if age1<.;
gen age5_15f = (age1>=5 & age1<15)*female if age1<.;
gen age15_45f = (age1>=15 & age1<45)*female if age1<.;
gen ageO45m = (age1>=45)*(1-female) if age1<.;
gen ageO45f = (age1>=45)*female if age1<.;
gen ageU15m = (age1<15)*(1-female) if age1<.;
gen ageU15f = (age1<15)*(female) if age1<.;
gen ageO15m = (age1>=15)*(1-female) if age1<.;
gen ageO15f = (age1>=15)*(female) if age1<.;

* Check fraction tested at follow-up and differences in age/gender. Consider only members of baseline households listed as members at follow-up;
tab merge_01, missing;
gen refusal = malaria1 == -997 if inlist(merge_01,1,3);
gen absent = malaria1 == -666 if inlist(merge_01,1,3);

******************
***  ABSENCE   ***
******************;

* Column 1;
reg absent, cluster(id_v);

* Column 2;
reg absent arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;

* Column 3;
reg absent arm_free arm_mf age0_5m-ageO45f, cluster(id_v);
test age0_5m=age0_5f;
local 0_5 = r(p);
test age5_15m=age5_15f;
local 5_15 = r(p);
test ageO45m=ageO45f;
local O45 = r(p);
test arm_free arm_mf;


******************
***  REFUSAL   ***
******************;

* Column 4;
reg refusal, cluster(id_v);

* Column 5;
reg refusal arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;

* Column 6;
reg refusal arm_free arm_mf age0_5m-ageO45f, cluster(id_v);
test age0_5m=age0_5f;
local 0_5 = r(p);
test age5_15m=age5_15f;
local 5_15 = r(p);
test ageO45m=ageO45f;
local O45 = r(p);
test arm_free arm_mf;



cap log close;
