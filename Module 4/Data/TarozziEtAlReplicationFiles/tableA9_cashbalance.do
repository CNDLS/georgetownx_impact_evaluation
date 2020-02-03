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

log using "tableA9_cashbalance", replace;

* IMPORT CENSUS DATA FROM THE FIRST THREE EXPERIMENTAL ARMS AS WELL AS FROM THE ADDITIONAL VILLAGES STUDIES IN THE CASH ARM;

use "censusdata" if inlist(vtype,1,2,3) | price<.;
gen sharesc = sc_p/t_p;
gen sharest = st_p/t_p;
gen sharef = t_f/t_p;
gen sc_primary =  p_sch > 0;
gen sc_middle = m_sch > 0;
gen sc_secondary = s_sch > 0;
gen hospital =  all_hosp > 0;
gen shareirr = tot_irr/area;
gen shareunirr = un_irr/area;

* Generate a dummy = 1 if village was included in the Cash-only ex-post experimental arm;
gen incash = price<.;
gen byte low = price==1 if price<.;

matrix results = J(1,3,.);

* Exclude 'hospital' (only one village has it), 'sc_primary' (all but 7 villages have it) and comm_bank (only 10 villages have it);

foreach var of varlist 
		area t_hh sharesc sharest sharef sc_middle sc_secondary ph_cntr phs_cnt well tank river canal 
		post_off phone bs_fac  ac_soc app_pr dist_town power_dom power_agr shareirr shareunirr 	{;

	matrix temp = J(1,3,.);

	* Check equality between Cash and Others;
	reg `var' incash, robust;
	test incash;
	matrix temp[1,1] = r(p);	
	
	* Check equality between "New cash" and "Control Cash";
	reg `var' new, robust;
	test new;
	matrix temp[1,2] = r(p);
	
	* Check equality between High and Low price;
	reg `var' low if low<., robust;
	test low;
	matrix temp[1,3] = r(p);
	
	matrix rownames temp = `var';
	matrix results = results\temp;
	
	};

matrix colnames results = "Cashvsothers" "ControlvsNew" "HighvsLowPrice";
mat list results, format(%8.3f);

cap log close;
