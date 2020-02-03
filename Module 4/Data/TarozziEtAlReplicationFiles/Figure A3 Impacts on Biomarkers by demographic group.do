#delimit;
set more off;
pause on;
cap log close;
set logtype text;
drop _all;

**** Before you run this code you need to set the paths to the appropriate locations;
* Set the working directory;
cd "C:\Users\tarozzino\Dropbox\Experimental\AERR\Final\Stata";

log using "Figure A3 Impacts on Biomarkers by demographic group", replace;

use "panel_biomarkers";
gen an1 = hb1<11 if hb1<.;
gen an0 = hb0<11 if hb0<.;
drop agegroup;
recode age1 (0/4=1 "Age<5") (5/14=2 "5<=Age<15") (15/59=3 "15<=Age<60") (50/130=4 "Age>=50"), generate(agegroup) label(agegroup);

* Keep only observations from panel households;
keep if match==1;
drop if agegroup==. | female==. | vtype==4;

* Estimate and store results using only follow-up;
mat results = J(4*2*3,13,.);
mat colnames results = agegroup female vtype an1 an1_se an1_u an1_l an1_n m1 m1_se m1_u m1_l m1_n;
local line = 1;
forvalues agegroup = 1/4 {;
	forvalues gender = 0/1 {;
		forvalues arm = 1/3 {;
		
		qui reg an1 if agegroup==`agegroup' & female==`gender' & vtype==`arm', cluster(id_v);
		matrix temp = [`agegroup',`gender',`arm',_b[_cons],_se[_cons],_b[_cons]+1.96*_se[_cons],_b[_cons]-1.96*_se[_cons],e(N)];
		qui reg m1 if agegroup==`agegroup' & female==`gender' & vtype==`arm', cluster(id_v);
		matrix temp = temp,[_b[_cons],_se[_cons],_b[_cons]+1.96*_se[_cons],_b[_cons]-1.96*_se[_cons],e(N)];
		matrix results[`line',1]=temp;
		local line = `line'+1;
		};	
	}; 
};
mat list results, format(%5.3g);
drop _all;
svmat results, n(col);

recode vtype (1=1 "C") (3=2 "MF") (2=3 "Free"), gen(newvtype) label(newvtype);
gen newg = newvtype*(agegroup==1) + (newvtype+4)*(agegroup==2) + (newvtype+8)*(agegroup==3) + (newvtype+12)*(agegroup==4);
label var newg "Age group";

twoway (bar an1 newg if newvtype==1) (bar an1 newg if newvtype==2) (bar an1 newg if newvtype==3)
	(rcap an1_u an1_l newg) if female==0, yline(0(.2).8, lwidth(vthin)) ylabel(0(.2)1)
	xlabel(2 "0-4" 6 "5-14" 10 "15-59" 14 ">=60", noticks) legend(row(1) order(1 "C" 2 "MF" 3 "Free") ) scale(1.6)
	title("C. Anemia (Hb<11g/dl) Prevalence, Males", position(11)) legend(on position(1) ring(0)) saving(an1_male, replace);

twoway (bar m1 newg if newvtype==1) (bar m1 newg if newvtype==2) (bar m1 newg if newvtype==3)
	(rcap m1_u m1_l newg) if female==0, yline(0(.1).4, lwidth(vthin)) ylabel(0(.1).5)
	xlabel(2 "0-4" 6 "5-14" 10 "15-59" 14 ">=60", noticks) legend(row(1) order(1 "C" 2 "MF" 3 "Free") ) scale(1.6)
	title("A. Malaria Prevalence, Males", position(11)) legend(on position(1) ring(0)) saving(m1_male, replace);
	
twoway (bar an1 newg if newvtype==1) (bar an1 newg if newvtype==2) (bar an1 newg if newvtype==3)
	(rcap an1_u an1_l newg) if female==1, yline(0(.2).8, lwidth(vthin)) ylabel(0(.2)1)
	xlabel(2 "0-4" 6 "5-14" 10 "15-59" 14 ">=60", noticks) legend(row(1) order(1 "C" 2 "MF" 3 "Free") ) scale(1.6)
	title("D. Anemia (Hb<11g/dl) Prevalence, Females", position(11)) legend(on position(1) ring(0)) saving(an1_female, replace);
	
twoway (bar m1 newg if newvtype==1) (bar m1 newg if newvtype==2) (bar m1 newg if newvtype==3)
	(rcap m1_u m1_l newg) if female==1, yline(0(.1).4, lwidth(vthin)) ylabel(0(.1).5)
	xlabel(2 "0-4" 6 "5-14" 10 "15-59" 14 ">=60", noticks) legend(row(1) order(1 "C" 2 "MF" 3 "Free") ) scale(1.6)
	title("B. Malaria Prevalence, Females", position(11)) legend(on position(1) ring(0)) saving(m1_female, replace);

graph combine m1_male.gph m1_female.gph an1_male.gph an1_female.gph, iscale(.4);
 
erase an1_male.gph;
erase an1_female.gph;
erase m1_male.gph;
erase m1_female.gph;

log close;
