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

log using "tableA7_census", replace;

* The file censusdata includes village-specific characteristics and amenities at the village level from Census of India 2001;

use "censusdata";

gen arm_c = vtype==1;
gen arm_mf = vtype==3;
gen arm_free = vtype==2;
gen notinbaseline = 1 - arm_mf - arm_free - arm_c;

gen sharesc = sc_p/t_p;
gen sharest = st_p/t_p;
gen sharef = t_f/t_p;
gen sc_primary =  p_sch > 0;
gen sc_middle = m_sch > 0;
gen sc_secondary = s_sch > 0;
gen hospital =  all_hosp > 0;
gen shareirr = tot_irr/area;
gen shareunirr = un_irr/area;

reg area notinbaseline arm_c arm_free arm_mf, robust nocons;
matrix results = _b[notinbaseline],_b[arm_c],_b[arm_free],_b[arm_mf],e(N);
test arm_mf = arm_free = arm_c;
local equalarms = r(p);
reg area arm_c arm_free arm_mf, robust;
test arm_mf arm_free arm_c;
mat rownames results = area;
matrix results = results,r(p),`equalarms';

qui foreach var of varlist 
	t_hh sharesc sharest sharef sc_primary sc_middle sc_secondary hospital ph_cntr phs_cnt 
	well tank river canal post_off phone bs_fac comm_bank ac_soc app_pr dist_town power_dom power_agr shareirr shareunirr 	{;

	reg `var' notinbaseline arm_c arm_free arm_mf, robust nocons;
	matrix temp = _b[notinbaseline],_b[arm_c],_b[arm_free],_b[arm_mf],e(N);
	test arm_mf = arm_free = arm_c;
	local equalarms = r(p);
	reg `var' arm_c arm_free arm_mf, robust;
	test arm_mf arm_free arm_c;
	matrix temp = temp,r(p),`equalarms';	
	mat rownames temp = `var';
	matrix results = results\temp;
};	

* This displays the results, compare to Table A.7 in the Appendix;

mat list results, format(%8.3f);

cap log close;
