/* Code for Carbon Pricing Induces Innovation: Evidence from China's Regional Carbon Market Pilots
Jingbo Cui, Junjie Zhang, and Yang Zheng
Wuhan University, Duke Kunshan University and Duke University
Updated by Jan 12, 2018 */

set matsize 10000, perm

* Figure 1
****************************
use "AEA_P&P_figure1.dta", clear


twoway (line avg_envrAEW year if Ind == 1) (line avg_envrAEW year if Ind == 0, lpattern(dash_dot) lcolor(green)), ///
by(, title("")) legend(order(1 "Covered Sectors" 2 "NonCovered Sectors")) by(ETS_cat, note("")) ytitle("") xlabel(2003(1)2015, angle(45)) xline(2011) plotregion(color(white))

graph save "Figure1", replace


***********************
// generate results in the baseline model and alternative model 
use "AEA_P&P_table.dta", clear

xtset id year
sort id year
gen period = year - 2003

gen stderror = Nnindcd

global dep_var logenvrAEW logNon_envrAEW envrAEW_ratio // broad definition of low carbon
global dep_altvar logenvrAE logenvrAERD  // narrowed defintion of low carbon
global control t_Assets t_Revenue t_ROA t_EBIT t_CurrentLiability // firm-level control variables


* Summary Statistics (Table A1)
logout, save(TableA1) excel replace:  /*
*/ tabstat logenvrAEW logNon_envrAEW envrAEW_ratio /*
*/ t_Assets t_Revenue t_ROA t_CurrentLiability t_EBIT, /* 
*/ stats(count mean sd min max) long f(%6.2f) c(s) 


* 1. Baseline Model (Table 1)
foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y' c.Ind##c.region##c.post $control i.year i.province*period i.Nindnme*period, fe vce(cluster stderror)
  outreg2 using Table1.xls, excel keep(c.Ind#c.region#c.post) dec(3) /*
	*/ addtext(Firm FE, Y, Year FE, Y, Province-Year linear trend, Y, Industry-Year linear trend, Y)
}


* 2. Heterogeneous Effect (Table 2)
foreach v of varlist price turnover {
foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y' c.Ind##c.`v' $control /*
	*/ i.year i.province*period i.Nindnme*period, fe vce(cluster stderror)
	outreg2 using Table2.xls, excel keep(c.Ind#c.`v' `v') dec(3) /*
	*/ addtext(Firm FE, Y, Year FE, Y, Province-Year liner trend, Y, Industry-Year linear trend, Y)
}
}


* 3. Robustness Checks (Table A2)
foreach Y of varlist $dep_altvar {
	quietly xi: xtreg `Y' c.Ind##c.region##c.post $control i.year i.province*period i.Nindnme*period, fe vce(cluster stderror)
  outreg2 using TableA2.xls, excel keep(c.Ind#c.region#c.post) dec(3) /*
	*/ addtext(Firm FE, Y, Year FE, Y, Province-Year linear trend, Y, Industry-Year linear trend, Y)
}

foreach v of varlist price turnover {
foreach Y of varlist $dep_altvar {
	quietly xi: xtreg `Y' c.Ind##c.`v' $control /*
	*/ i.year i.province*period i.Nindnme*period, fe vce(cluster stderror)
	outreg2 using TableA2.xls, excel keep(c.Ind#c.`v' `v') dec(3) /*
	*/ addtext(Firm FE, Y, Year FE, Y, Province-Year linear trend, Y, Industry-Year linear trend, Y)
}
}


* Placebo Test 
*********************************
// Pseudo region (500 randomized assignment)
// please uncomment the following parts of 500 randomized DDD estimations
/*
use "AEA_P&P_table.dta", clear

joinby province using region_random.dta  // load pseudo ETS pilot regions
joinby Nnindcd using Ind_random.dta      // load pseudo covered sectors

* Set panel
xtset id year
sort id year
gen period = year - 2003

gen stderror = Nnindcd
gen Ind_random = 0
gen region_random = 0

// Re-run baseline DDD model
forvalue r = 1/300 {
replace Ind_random = Ind_random`r'
replace region_random = region_random`r'

quietly xi: xtreg logenvrAEW  c.Ind_random##c.region_random##c.post $control /*
*/ i.year i.province*period i.Nnindcd*period, fe vce(cluster stderror)
est store m`r'
}

// Output pseudo results
esttab m* using baseline_random1.xls, keep(c.Ind_random#c.region_random#c.post) b p

est drop m*

forvalue r = 301/500 {
replace Ind_random = Ind_random`r'
replace region_random = region_random`r'

quietly xi: xtreg logenvrAEW  c.Ind_random##c.region_random##c.post $control /*
*/ i.year i.province*period i.Nnindcd*period, fe vce(cluster stderror)
est store m`r'
}

// Output pseudo results 
esttab m* using baseline_random2.xls, keep(c.Ind_random#c.region_random#c.post) b p
*/

/* Adjust the layout in EXCEL (manual works)  Placebo test figure (Figure A1) */

import excel "placebo_baseline.xlsx", sheet("Sheet1") firstrow clear

replace AEWcoef = subinstr(AEWcoef,"*","",.)
destring AEWcoef , replace
destring AEWp , replace

* Coefficient K-density and Distribution of P-value
# delimit ; 
twoway (kdensity AEWcoef, yaxis(1)) 
|| (scatter AEWp AEWcoef, yaxis(2))
||, xline(0.177)
legend (label(1 "Coefficient") label(2 "P-Value"))
xtitle("Coefficient")
ytitle("Density", axis(1))
ytitle("P-Value", axis(2));
# delimit cr

graph save "FigureA1", replace

