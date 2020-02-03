#delimit;
set more off;
pause on;
cap log close;
set logtype text;
drop _all;

**** Before you run this code you need to set the paths to the appropriate locations;
* Set the working directory;
cd "C:\Users\tarozzino\Dropbox\Experimental\AERR\Final\Stata";

log using "Figure A5 Malaria Prevalence vs Intensity of ITNs Distribution", replace;

use "panel_biomarkers";
merge m:1 id_v using "villagedistribution";

gen ratio = bmem/t_p;
gen pcnets = vnets_deliv/t_p;

* Keep only panel households;
keep if match==1;

gen both = 1 if m1<. & m0<.;
gen mboth = m1==1 & m0==1 if both<.;

collapse arm_mf arm_free vtype id_dist v_pcnets pcnets ratio m1 m0 mboth
	(count) n_both=both n_m1=m1 n_m0=m0, by(id_v);
	
label var m1 "Village-level prevalence, follow-up";
label var n_m1 "Number of malaria tests at follow-up";
label var m0 "Village-level prevalence, baseline";
label var n_m0 "Number of malaria tests at baseline";
label var n_both "Number of individuals tested at both baseline and followup";
label var mboth "Had malaria both at baseline and at follow up";
label var v_pcnets "(# program ITNs)/(Village pop.)";
label var ratio "# BISWA members/total population";
label var pcnets "ITNs delivered / village population";

gen sigma = m0*(1-m0)/n_m0 + m1*(1-m1)/n_m1 - 2*(n_both/(n_m0*n_m1))*(mboth - m0*m1);
list n* m* if sigma==0;
gen oneoversigma = 1/sigma;

range grid 0 .3 100;
* Calculate a weight for the change in malaria prevalence. Here I calculate it as the geometric mean of the numbers of tests in baseline and follow-up;
gen weight = sqrt(n_m1*n_m0);
label var grid "# BISWA members / village population";
gen dm = m1 - m0;
label var dm "Change";



**** LOOK AT CHANGES IN MALARIA PREVALENCE AT THE VILLAGE LEVEL VS. NUMBER OF NETS DISTRIBUTED;

* Generate the arm-specific graphs grouped into Figure A.5 and estimate the regressions in the graphs, whose main coefficients
* of interest are reported in the caption to the figure;

*** FREE;

reg dm v_pcnets [aw=weight] if vtype==2, robust;
predict d_mhat if vtype==2;
label var d_mhat "OLS";
reg dm v_pcnets [aw=weight] if vtype==2 & v_pcnets<.35, robust;
predict temp if vtype==2;
sum v_pcnets if vtype==2;
gen d_mhat2 = temp if vtype==2 & v_pcnets==r(min) | v_pcnets==r(max);
label var d_mhat2 "OLS, no outliers";

twoway (scatter dm v_pcnets, mcolor(black) msymbol(circle) mfcolor(none)) 
	(connected d_mhat v_pcnets, msymbol(none) lwidth(medium) lpattern(solid)) 
	(connected d_mhat2 v_pcnets, mcolor(black) msize(small) msymbol(none) lwidth(vthin) lpattern(dash)) if vtype==2,  
	title("(A) Change in Malaria prevalence (Free)", position(11) justification(left))
	legend(rows(1) region(lcolor(none))) ylabel(-.4(.2).8, angle(horizontal)) saving(g1, replace);

drop temp d_mhat d_mhat2;


*** MF;

reg dm v_pcnets [aw=weight] if vtype==3, robust;
predict d_mhat if vtype==3;
label var d_mhat "OLS";
reg dm v_pcnets [aw=weight] if vtype==3 & v_pcnets<.35, robust;
predict temp if vtype==3;
sum v_pcnets if vtype==3;
gen d_mhat2 = temp if vtype==3 & v_pcnets==r(min) | v_pcnets==r(max);
label var d_mhat2 "OLS, no outliers";

twoway (scatter dm v_pcnets, mcolor(black) msymbol(circle) mfcolor(none)) 
	(connected d_mhat v_pcnets, msymbol(none) lwidth(medium) lpattern(solid)) 
	(connected d_mhat2 v_pcnets, mcolor(black) msize(small) msymbol(none) lwidth(vthin) lpattern(dash)) if vtype==3,  
	title("(B) Change in Malaria prevalence (MF)", position(11) justification(left))
	legend(rows(1) region(lcolor(none))) ylabel(-.4(.2).8, angle(horizontal)) saving(g2, replace);

drop temp d_mhat d_mhat2;


*** CONTROL (in this case use "ratio", not v_pcnets, because no ITNs were distributed;

reg dm ratio [aw=weight] if vtype==1, robust;
predict d_mhat if vtype==1;
label var d_mhat "OLS";
reg dm ratio [aw=weight] if vtype==1 & ratio<.20, robust;
predict temp if vtype==1;
sum ratio if vtype==1;
gen d_mhat2 = temp if vtype==1 & ratio==r(min) | ratio==r(max);
label var d_mhat2 "OLS, no outliers";

twoway (scatter dm ratio, mcolor(black) msymbol(circle) mfcolor(none)) 
	(connected d_mhat ratio, msymbol(none) lwidth(medium) lpattern(solid)) 
	(connected d_mhat2 ratio, mcolor(black) msize(small) msymbol(none) lwidth(vthin) lpattern(dash)) if vtype==1,  
	title("(C) Change in Malaria prevalence (Controls)", position(11) justification(left))
	legend(rows(1) region(lcolor(none))) ylabel(-.4(.2).8, angle(horizontal)) saving(g3, replace);

graph combine g1.gph g2.gph g3.gph, iscale(.55);

xi: reg dm i.arm_free*ratio if v_pcnets<.35 & vtype<3, robust;
xi: reg dm i.arm_free*ratio if v_pcnets<.35 & vtype<3 [aw=weight], robust;
xi: reg dm i.arm_free*ratio if vtype<3 [aw=weight], robust;
xi: reg dm i.arm_free*ratio if v_pcnets<.35 & vtype<3 [aw=oneoversigma], robust;

list ratio v_pcnets vtype if ratio>.18 | v_pcnets>.35;
 

erase g1.gph;
erase g2.gph;
erase g3.gph;

cap log close;
