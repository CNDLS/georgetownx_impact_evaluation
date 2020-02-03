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

log using "table1_randomization", replace;

* HOUSEHOLD-LEVEL BASELINE INFORMATION;

use "hhinfo_bl";

gen pcexp = (totexp_bl/hhsize)/30;
gen pcexp_nof = (totexp_nof_bl/hhsize)/30;
gen anynet = pcnets>0 & pcnets<.;
gen debt = debtot_bl/(totexp_bl*12);
gen debtbiswa = debtbiswa_bl/(totexp_bl*12);
* For the CPI deflators see caption of Table 1;
gen poor = (totexp_bl/hhsize) < 326*(373/319.5);

matrix results = J(1,10,.);
gen control=vtype==1;

cap program drop thisreg;
prog define thisreg;
syntax varlist, [Weight(varname)];
	
	if "`weight'" ~= "" {;
		reg `varlist' control free mf [pw=`weight'], nocon cluster(id_v);
		};
	else {;
		reg `varlist' control free mf, nocon cluster(id_v);
	};

	matrix temp = [_b[control],_se[control],_b[free],_se[free],_b[mf],_se[mf],.,.,.,.];
	test control=free=mf;
	matrix temp[1,7]=r(p);
	
	if "`weight'" ~= "" {;
		sum `varlist' [w=`weight'];
		};
	else {;
		sum `varlist';
	};	
	mat temp[1,8]=r(mean);
	mat temp[1,9]=r(sd);
	mat temp[1,10]=r(N);	
	matrix rowname temp = `varlist';
	matrix results=results\temp;
end;

*** This will estimate the statistics for the variables in Table 1, rows 1-18;

foreach var of varlist scstobc_bl hhsize_bl dem_u5_bl head_male_bl head_anysch_bl head_highed_bl {;
	thisreg `var';
	};
foreach var of varlist pcexp poor {;
	thisreg `var', w(hhsize);
	};
foreach var of varlist hard500_bl debt anynet {;
	thisreg `var';
	};
foreach var of varlist pcnets_bl pcitns_bl {;
	thisreg `var', w(hhsize);
	};
thisreg costm_bl;
foreach var of varlist last_net_bl last_itn_bl usual_net_bl {;
	thisreg `var', w(hhsize);
	};
thisreg price, w(n_price);
* Note that in Table 1 the number of observations is 579, not 332 as in the results produced by this code. That's because there are 332 households
* with non-missing price data on owned bednets, but there are a total of 579 such bednets;
matrix colnames results = control se_control Free se_Free MF se_MF p Mean StDev Obs;
matrix results = results[2...,1...];
mat list results, format(%10.3g);

*** Now estimate the statistics in rows 19-23 from the file that includes individual-level health outcomes and display full table
* of results;

use "panel_biomarkers" if inlist(match,0,1,6), clear;
gen an0 = hb0<11 if hb0<.;
rename arm_c control;
rename arm_mf mf;
rename arm_free free;
foreach var of varlist m0 hb0 an0 survey_m60 survey_mf60 {;
	thisreg `var';
	};

mat list results, format(%10.3g);


cap log close;
