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

log using "tableA13_selfreported", replace;

*** Generates the results in Table A.13: Self-reported Malaria Indices: Baseline and Follow-up Differences in Levels;

use "panel_biomarkers";

cap program drop mydisplay;
prog define mydisplay;
	qui reg `1' arm_free arm_mf if match==1, cluster(id_v);
	local clusters = e(N_clust);
	qui test arm_free arm_mf;
	local t = r(p);
	qui test arm_free = arm_mf;
	local equal = r(p);
	matrix results = _b[arm_free]\_se[arm_free]\_b[arm_mf]\_se[arm_mf]\_b[_cons]\_se[_cons]\e(N)\ `t'\ `equal';
	mat list results, format(%8.3f);
end;


*** FIRST THE RESULTS IN COLUMNS 1-4 OF THE TOP PANEL, USING SELF-REPORTED MALARIA EPISODES;

*** Column (1) "Current" malaria, baseline;
mydisplay survey_m_now0;

*** Column (2) "Current" malaria, followup;
mydisplay survey_m_now1;

*** Column (3) # of malaria episodes last 6 months, baseline;
mydisplay survey_m60;

*** Column (4) # of malaria episodes last 6 months, follow-up;
mydisplay survey_m61;


**** NOW THE RESULTS FOR THE BOTTOM PANEL, AGAIN COLUMNS 1-4, FOR SELF-REPORTED MALARIA AND FEVER POOLED TOGETHER;

*** Column (1) "Current" malaria / fever, baseline;
mydisplay survey_mf_now0;

*** Column (2) "Current" malaria / fever, followup;
mydisplay survey_mf_now1;

*** Column (3) # of malaria / fever episodes last 6 months, baseline;
mydisplay survey_mf60;

*** Column (4) # of malaria / fever  episodes last 6 months, follow-up;
mydisplay survey_mf61;


*****************************************************************************************************************
*** THE RESULTS OF THE ESTIMATES ARE AT THE HOUSEHOLD LEVEL, SO NEED TO COLLAPSE BY HOUSEHOLDS BEFORE ESTIMATION;
keep if match==1;
collapse match arm_free arm_mf (sum) cost*, by(id_v id_hhno);


*** Now columns 5-14, top panel, malaria only;

*** Column (5) # Days of work/school lost for malaria last 6 m, baseline;
mydisplay cost_m_days0;

*** Column (6) # Days of work/school lost for malaria last 6 m, follow-up;
mydisplay cost_m_days1;

*** Column (7) Tot. exp. (2008/09 Rs) for malaria last 6 m (itemized), baseline;
mydisplay cost_m_expit0;

*** Column (8) Tot. exp. (2008/09 Rs) for malaria last 6 m (itemized), follow-up;
mydisplay cost_m_expit1;

*** Column (9) Total doctors/drugs expenditure (2008/09 Rs) for malaria last 6 m, baseline;
mydisplay cost_m_expdd0;

*** Column (10) Total doctors/drugs expenditure (2008/09 Rs) for malaria last 6 m, follow-up;
mydisplay cost_m_expdd1;

*** Column (11) # times debt due to malaria episodes last 6 m, baseline;
mydisplay cost_m_debt0;

*** Column (12) # times debt due to malaria episodes last 6 m, follow-up;
mydisplay cost_m_debt1;

*** Column (13) # times reduction in cons. due to malaria episodes last 6 m, baseline;
mydisplay cost_m_less0;

*** Column (14) # times reduction in cons. due to malaria episodes last 6 m, follow-up;
mydisplay cost_m_less1;


*** And finally again columns 5-14, BOTTOM panel, MALARIA/FEVER pooled together;

*** Column (5) # Days of work/school lost for malaria/fever last 6 m, baseline;
mydisplay cost_mf_days0;

*** Column (6) # Days of work/school lost for malaria/fever last 6 m, follow-up;
mydisplay cost_mf_days1;

*** Column (7) Tot. exp. (2008/09 Rs) for malaria/fever last 6 m (itemized), baseline;
mydisplay cost_mf_expit0;

*** Column (8) Tot. exp. (2008/09 Rs) for malaria/fever last 6 m (itemized), follow-up;
mydisplay cost_mf_expit1;

*** Column (9) Total doctors/drugs expenditure (2008/09 Rs) for malaria/fever last 6 m, baseline;
mydisplay cost_mf_expdd0;

*** Column (10) Total doctors/drugs expenditure (2008/09 Rs) for malaria/fever last 6 m, follow-up;
mydisplay cost_mf_expdd1;

*** Column (11) # times debt due to malaria/fever episodes last 6 m, baseline;
mydisplay cost_mf_debt0;

*** Column (12) # times debt due to malaria/fever episodes last 6 m, follow-up;
mydisplay cost_mf_debt1;

*** Column (13) # times reduction in cons. due to malaria/fever episodes last 6 m, baseline;
mydisplay cost_mf_less0;

*** Column (14) # times reduction in cons. due to malaria/fever episodes last 6 m, follow-up;
mydisplay cost_mf_less1;

cap log close;
