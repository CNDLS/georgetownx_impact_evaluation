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

log using "table3_purchase", replace;

* Import only data from MF villages to study demand for ITNs. Include only panel households;
use "hhinfo_bl" if match==1;

gen debtpc = (debtot_bl/hhsize)^.25;
gen debtpcbsw = (debtbiswa_bl/hhsize)^.25;
gen pcinc = (income/hhsize)^.25;
gen pccost = (costm_bl/hhsize)^.25;
gen cost =  (exp_cost_wm_bl)^.25;
gen headillit =  head_anysch_bl==0;

sum costm_bl if costm_bl>0 & vtype==3, d;

local wealth = "lpce_bl debtpcbsw";
local demog = "hhsize dem_u5_bl dem_young_bl dem_elderly_bl head_male_bl head_age_bl headill head_highed_bl";
local netsmal = "pccost last_net_bl last_itn_bl nets_bl itns_bl usual_net_bl mal_deaths5_bl cost biom_anem_bl biom_mal_bl selfmf_bl";
local prefbeliefs = "pref_riskaverse_bl pref_hyperb_bl pref_impatient_bl p_gamma_bl p_itn_bl";

* This replicates the results in Table 3 of the paper;
reg somenets_ic `wealth' `demog' `netsmal' `prefbeliefs' if vtype==3, cluster(id_v);
* This shows that using probit (here showing marginal effects) produces approximately the same results;
dprobit somenets_ic `wealth' `demog' `netsmal' `prefbeliefs' if vtype==3, cluster(id_v);

/* The following maps the variables in the stata code into the variables displayed in Table 3 of the paper;

lpce_bl		(monthly total expenditure per head)
debtpcbsw	Debt towards BISWA (per head, quartic root)
pccost		Cost of malaria episodes last 6 months (per capita, quartic root)
last_net_bl	% members who slept under net last night
last_itn_bl	% members who slept under ITN last night
nets_bl		# nets owned by household
itns_bl		# nets treated last 6 months
usual_net_bl	% members using nets during peak season
mal_deaths5_bl	Any malaria-related deaths last 5 yrs
cost		Expected cost of a malaria episode (quartic root)
biom_mal_bl	% tested members positive for malaria
selfmf_bl	% members with self-reported malaria episodes last 6 months
p_gamma_bl	Subjective P(malaria | untreated net) - P(malaria | ITN)
p_itn_bl	Subjective P(malaria | no net) - P(malaria | ITN)

*/

log close;
