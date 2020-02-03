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

log using "tableA12_kap", replace;

*** This file generates the results in Table A.12: Knowledge of Causes of Malaria and Risk Mitigating Behavior;

use "hhinfo_fup" if match==1;

gen arm_c = vtype==1;
gen arm_free = vtype==2;
gen arm_mf = vtype==3;

drop prev__ra;

cap matrix drop results;

* Panel (A) of table A.12;

qui foreach var of varlist from1_mwater from2_mmosq from6_menviron from__dk {;
	reg `var' arm_c arm_free arm_mf if match==1, cluster(id_v) nocon;
	matrix temp = e(b);
	matrix rownames temp = `var';
	test arm_c=arm_free=arm_mf;
	matrix temp = temp,r(p);
	cap matrix results = results\temp;
		if _rc > 0 {; matrix results = temp;
		};
	};
mat list results, format(%4.3f);

cap matrix drop results;

* Panels (B) and (C);
qui foreach var of varlist prev* inner outer {;
	reg `var' arm_c arm_free arm_mf if match==1, cluster(id_v) nocon;
	matrix temp = e(b);
	matrix rownames temp = `var';
	test arm_c=arm_free=arm_mf;
	matrix temp = temp,r(p);
	cap matrix results = results\temp;
		if _rc > 0 {; matrix results = temp;
		};
	};
mat list results, format(%4.3f);

* Panel (D);
qui foreach var of varlist nets_tot* {;
	reg `var' arm_c arm_free arm_mf if match==1, cluster(id_v) nocon;
	matrix temp = e(b);
	matrix rownames temp = `var';
	test arm_c=arm_free=arm_mf;
	matrix temp = temp,r(p);
	cap matrix results = results\temp;
		if _rc > 0 {; matrix results = temp;
		};
	};
mat list results, format(%4.3f);

cap log close;
