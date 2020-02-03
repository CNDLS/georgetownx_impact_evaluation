#delimit;
clear;
pause on;
cap log close;
set more off;
set logtype text;
version 10.1;

**** Before you run this code you need to set the paths to the appropriate locations;
* Set the working directory;
cd "C:\Users\tarozzino\Dropbox\Experimental\AERR\Final\Stata";

log using "table2_bednets", replace;

* HOUSEHOLD-LEVEL BASELINE INFORMATION;

use "hhinfo_bl";

* Column 1; 
reg totnet_ic mf free if match==1, clu(id_v) nocon;
lincom free - mf;
test free mf;

* Column 2; 
reg somenets_ic free mf if match==1, clu(id_v) nocon;
lincom free-mf;
test free mf;

* Column 3 (DD, so need to merge with follow-up data);
merge 1:1 id_v id_hhno using "hhinfo_fup";
keep if match==1 & _merge==3;
gen dnets = totnets - nets_bl;
sum nets_bl;
reg dnets free mf, clu(id_v);
test free mf;
lincom free-mf;

* Columns 4-7 were estimated using individual-level data;
use "panel_biomarkers" if match==1, clear;
gen d_net = netlast_fup -  netlast_bl;
gen d_itn = itnlast_fup -  itnlast_bl;

* Column 4;
reg d_net arm_free arm_mf, clu(id_v);
lincom arm_free - arm_mf;
test arm_free arm_mf;

* Column 5;
reg d_itn arm_free arm_mf, clu(id_v);
lincom arm_free - arm_mf;
test arm_free arm_mf;

* Column 6;
gen d_u = (netlast_fup-itnlast_fup) - (netlast_bl-itnlast_bl);
reg d_u arm_free arm_mf, clu(id_v);
lincom arm_free - arm_mf;
test arm_free arm_mf;

* Column 7;
reg net_biswa1 arm_free arm_mf, clu(id_v);
lincom arm_free - arm_mf;
test arm_free arm_mf; 

* Column 8;
* This is again a regression run at the household level;
use "hhinfo_bl", clear;
merge 1:1 id_v id_hhno using "hhinfo_fup";
* Keep only observations from MF & Free, where at least one net was delivered;
keep if _merge==3 & totnet_ic>0 & totnet_ic<. & (vtype==2 | vtype==3) & match==1;
gen ratio = usnets_sb/totnet_ic;
sum ratio;
count if ratio>1;
* In a handful of cases, the ratio between biswa nets used and delivered is larger than one. I set the ratio =1 although not doing so
* would leave the results virtually identical;
replace ratio = 1 if ratio>1;
reg ratio free mf, clu(id_v) nocons;
test free mf;
lincom free-mf;


cap log close;
