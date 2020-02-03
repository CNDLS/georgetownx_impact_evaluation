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

log using "table5_biomarkers", replace;

** THIS FILE GENERATES THE RESULTS IN TABLE 5 OF THE PAPER;
* As usual use only information from panel households present both at baseline and at follow-up (that is, match==1);
use "panel_biomarkers" if match==1;

* Column 1, Malaria prevalence, follow-up only;
reg m1 arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
lincom arm_free - arm_mf;

* Column 2, Malaria prevalence, DD;
gen dm = m1 - m0;
reg dm arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
lincom arm_free - arm_mf;

* Column 3, Hemoglobin (Hb), follow-up only;
reg hb1 arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
lincom arm_free - arm_mf;

* Column 4, Malaria prevalence, DD;
gen dhb = hb1 - hb0;
reg dhb arm_free arm_mf if sample_panel==1, cluster(id_v);
test arm_free arm_mf;
lincom arm_free - arm_mf;
* The results without imposing sample_panel==1 are almost identical (one obs. with problematic matching between baseline and followup is not dropped);
reg dhb arm_free arm_mf, cluster(id_v);

* Column 5, Anemia (that is, Hb<11), follow-up only;
gen an1 = hb1<11 if hb1<.;
reg an1 arm_free arm_mf, cluster(id_v);
test arm_free arm_mf;
lincom arm_free - arm_mf;

* Column 6, Anemia, DD;
gen an0 = hb0<11 if hb0<.;
gen dan = an1 - an0;
reg dan arm_free arm_mf if sample_panel==1, cluster(id_v);
test arm_free arm_mf;
lincom arm_free - arm_mf;
* Again the results are almost identical if the observation for which sample_panel=0 is not dropped;
reg dan arm_free arm_mf, cluster(id_v);

* Column 7, Malaria, follow-up only, with tester FE;
xi: reg m1 arm_free arm_mf i.bloodtester, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;

* Column 8, Malaria, DD, with tester FE;
xi: reg dm arm_free arm_mf i.bloodtester, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;

* Column 9, Malaria, follow-up only, with controls for IRS spraying (need to import data on this from follow-up household-level data);
merge m:1 id_v id_hhno using "hhinfo_fup";
gen innermissing = innerspray==.;
gen outermissing = outerspray==.;
recode innerspray .=0;
recode outerspray .=0;
xi: reg m1 arm_free arm_mf inner* outer*, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;

* Column 10, Malaria, DD, with controls for IRS spraying;
xi: reg dm arm_free arm_mf inner* outer*, cluster(id_v);
test arm_free arm_mf;
test arm_free = arm_mf;

log close;
