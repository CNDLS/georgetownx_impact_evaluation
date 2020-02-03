#delimit;
set more off;
pause on;
cap log close;
set logtype text;
drop _all;

**** Before you run this code you need to set the paths to the appropriate locations;
* Set the working directory;
cd "C:\Users\tarozzino\Dropbox\Experimental\AERR\Final\Stata";

log using "Figure A2 Baseline biomarkers by demographic group", replace;
use "panel_biomarkers" if vtype<=3;

* This uses data from all households at baseline (not only panel households);

* First generate a dummy for anemic individuals (Hb<11 g/dl blood, as defined in the paper);
gen an = hb0<11 if hb0<.;

recode age0 (0/4 = 1 "U5") (15/44 = 2 "15 to 45") (45/100=3 "45 or older") (5/14=.)
	, label(newagegroup) generate(newagegroup);
graph bar (mean) an (mean) m0, over(sex0) over(newagegroup) legend(label(1 "Anemia (Hb<11)") label(2 "Malaria"));

* Count non-missing observations for anemia/Hb and malaria prevalence (caption of Figure A1);
sum m0;
sum hb0;

* Now test equality of biomarkers by gender for each age group;

forvalues newagegroup = 1/3 {;
	reg m0 female if newagegroup == `newagegroup', cluster(id_v);
	reg hb0 female if newagegroup == `newagegroup', cluster(id_v);
	reg an female if newagegroup == `newagegroup', cluster(id_v);
};

log close;
