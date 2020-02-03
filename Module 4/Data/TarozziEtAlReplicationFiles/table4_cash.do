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

log using "table4_cash", replace;

* Import data for cash-only experiment. This includes data on LLIN demand at the household level;
use "data_cash_hh";

* For Table 4 use only information from households that received vouchers (that is, hh_v==1);

* ROW A. - Number of LLINs sold, and fraction of buyers;
reg hh_nets if hh_v==1, cluster(id_v);
reg hh_some if hh_v==1, cluster(id_v);

* ROWS B and C and test of equality;
gen PC = type=="PC";
gen New = type=="new";
reg hh_nets PC New if hh_v==1, cluster(id_v) nocons;
test PC=New;
reg hh_some PC New if hh_v==1, cluster(id_v) nocons;
test PC=New;

* ROWS D and E and test of equality;
gen Low = price==1;
gen High = price==2;
reg hh_nets Low High if hh_v==1, cluster(id_v) nocons;
test Low=High;
reg hh_some Low High if hh_v==1, cluster(id_v) nocons;
test Low=High;

* ROWS F and G and test of equality;
* New households were assigned a household id larger than 1000;
gen baseline = hid>1000;
gen non_b = 1-baseline;
reg hh_nets baseline non_b if new==0 & hh_v==1, cluster(id_v) nocon;
test baseline=non_b;
reg hh_some baseline non_b if new==0 & hh_v==1, cluster(id_v) nocon;
test baseline=non_b;

log close;
