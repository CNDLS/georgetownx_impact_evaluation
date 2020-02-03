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

log using "tableA15_externalities", replace;

* In this dataset one observation is one surveyed household. For each household the variables denote the # of neighbors and # BISWA neighbors 
* within a given distance (in meters) indicated by the variable name;
use "gpsdata";
merge 1:m id_v id_hhno using "panel_biomarkers";
tab vtype _merge, missing;
* Merging is OK with the exception of one single household that we drop;
keep if _m==3;
drop _merge;

* So now the data set is composed of individual-level observations for malaria status of individuals in GPS-ed households;

renpfix n_ n;
count if m1==.;
count if hb1==.;
drop if m1+hb1==.;

foreach dist of numlist 5 10 20 30 40 50 100 150 200 300 400 {;

	rename n`dist'_1 P`dist';
	rename n`dist'_1_biswa B`dist';
	gen BP`dist' = P`dist'*B`dist';
	gen B_P`dist' = B`dist'/P`dist';
	gen F_P`dist' = arm_free*P`dist';
	gen F_B`dist' = arm_free*B`dist';
	gen F_BP`dist'= arm_free*BP`dist';
	gen F_B_P`dist' = arm_free*B_P`dist';

};

* Estimate mean # of neighbors and biswa neighbors for different radii;
preserve;
duplicates drop id_v id_hhno, force;
foreach dist of numlist 5 10 20 30 40 50 100 150 200 300 400 {;
	sum P`dist' B`dist';
};
dis 2.6*0.035;
restore;

* This to ensure replicability of the bootstrap;
set seed 1;

display in white "Radius = 5 meters";
bootstrap, reps(250): areg m1 P5 B5 F_P5 F_B5, absorb(id_v) clu(id_v);
mat results = _b[P5]\_se[P5]\_b[B5]\_se[B5]\_b[F_P5]\_se[F_P5]\_b[F_B5]\_se[F_B5];

foreach dist of numlist 10 20 30 40 {;
	
	display in white "Radius = `dist' meters";
	rename P`dist' P;
	rename B`dist' B;
	rename F_B`dist' F_B;
	rename F_P`dist' F_P;
	bootstrap, reps(250): areg m1 P B F_P F_B, absorb(id_v) clu(id_v);
	mat results = results,[_b[P]\_se[P]\_b[B]\_se[B]\_b[F_P]\_se[F_P]\_b[F_B]\_se[F_B]];
	drop P B F_B F_P;
	
};
mat rownames results = P_beta P_se B_beta B_se F_P_beta F_P_se F_B_beta F_B_se;
mat list results, format(%8.3f);

cap log close;
