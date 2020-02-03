# Module 4 Stata Tutorial

This tutorial introduces the Stata commands associated with the content in __Module 4: Statistical inference (advanced)__.

We will use data from a randomized controlled trial by Alessandro Tarozzi, Aprajit Mahajan, Brian Blackburn, Dan Kopf, Lakshmi Krishnan, and Joanne Yoong. They evaluated the uptake of insecticide-treated bednets (ITNs), comparing one treatment group that was offered micro-consumer loans, a second treatment group that received free nets, and a control group (citation: Tarozzi, Alessandro, Aprajit Mahajan, Brian Blackburn, Dan Kopf, Lakshmi Krishnan, and Joanne Yoong. 2014. "Micro-loans, Insecticide-Treated Bednets, and Malaria: Evidence from a Randomized Controlled Trial in Orissa, India." American Economic Review, 104 (7): 1909-41.). The study took place in Orissa, India. The data can be downloaded here (https://www.aeaweb.org/aer/data/10407/20110888_data.zip) or from the course page.

As in prior exercises, the data will be downloaded as a compressed (zip) file. You should unzip it before using the dta file. There are a number of folders and files in the unzipped directory. We will only use the file called `panel_biomarkers.dta` in this exercise.

## Part 1: Getting started

All of the commands in this tutorial should be written in a single Stata .do file. An example Module 4 .do file can be downloaded from the course page. To start a .do file, type doedit into the Stata command line then hit enter. You should save the file to a location where you will remember by selecting **File** then **Save as** from the menu (the upper left corner) of the .do file.

Just like in Module 3, at the start of the .do file, enter the commands `drop _all` and `set more off`. Then import and describe the data. Confirm that there are 18,569 observations and 115 variables. 

__Task 1:__ Clear Stata’s memory, set the more option to off, and describe the data.

__Execution 1:__

Note that the working directory and path to the `panel_biomarkers.dta` file in this example may differ on your computer. 

```
. cd "C:\\Module 4"

. use "Data/TarozziEtAlReplicationFiles/panel_biomarkers.dta", clear 

. 
. describe 

Contains data from Data/TarozziEtAlReplicationFiles/panel_biomarkers.dta
  obs:        18,569                          
 vars:           115                          12 Oct 2013 13:01
 size:     5,236,458                          
-------------------------------------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
-------------------------------------------------------------------------------------------------------------------------------------------------
id_v            float   %9.0g                 
hid             double  %12.0g                Household ID: 1000*id_hhno + id_v
id_dist         byte    %20.0g     district   
id_block        byte    %8.0g                 
block           str15   %15s                  block, string
vtype           byte    %8.0g      treatment
                                              
arm_c           byte    %9.0g                 CONTROL experimental arm
arm_mf          byte    %9.0g                 MF experimental arm
arm_free        byte    %9.0g                 FREE experimental arm
arm_new         byte    %9.0g                 NEW experimental arm
id_hhno         long    %12.0g                
sample_panel    byte    %9.0g                 To be used in individual-level DD estimation
match           byte    %49.0g     match      Household match between baseline and follow-up
memid           byte    %8.0g                 
merge_01        byte    %22.0g     merge_01   Result of roster merging (Sections 1)
match_ind       byte    %57.0g     match_ind
                                              
female          byte    %9.0g      female     sexB or sex0 (if sexB missing) or q0102b_gender (if sex0, sexB missing)
age             int     %9.0g                 Age at follow-up
agegroup        byte    %10.0g     agegroup   FUp: Age group
sex0            byte    %8.0g      sex        Bl 1.04: Gender
relhead0        byte    %22.0g     relhead    Bl 1.05: Relation to head
age0            byte    %8.0g                 Bl 1.06: Age
visit0          byte    %15.0g     yesno      Bl 1.08: Temporary visitor
biswamember0    byte    %15.0g     yesno      Bl BISWA membership (from Section 14)
sexB            byte    %8.0g      sex        B.02: Gender, FUp tracking section B
relheadB        byte    %22.0g     relhead    B.03: Relation to head, FUp tracking section B
ageB            byte    %8.0g                 B.04: Age, FUp tracking section B
visitB          byte    %15.0g     yesno      B.05: Temporary visitor, FUp tracking section B
memberB         byte    %30.0g     b06        B.06: Current household member, FUp tracking section B
nolongerB       byte    %32.0g     b07        B.07: Why no longer a member, FUp tracking section B
q0102b_gender   byte    %8.0g      sex        1.02B: FUp Gender (new hhs only)
relhead1        byte    %26.0g     relhead    FUp 1.03: Relation to head
age1            int     %8.0g                 FUp 1.04: Age (in years)
away1           byte    %15.0g     yesno      FUp 1.05: Away from village
biswamember1    byte    %15.0g     yesno      FUp 1.24: BISWA member
survey_m0       byte    %9.0g                 Bl: Any reported malaria episode in 2 months before interview
survey_mf0      byte    %9.0g                 Bl: Any reported malaria/fever episode in 2 months before interview
survey_m_now0   byte    %9.0g                 Bl: Reported malaria episode in same month as interview
survey_mf_now0  byte    %9.0g                 Bl: Reported malaria/fever episode in same month as interview
survey_m60      byte    %9.0g                 Bl: Total # reported malaria episodes last 6 m
survey_mf60     byte    %9.0g                 Bl: Total # reported malaria/fever episodes last 6 m
cost_m_days0    int     %9.0g                 Bl: Days of work/school lost for malaria last 6 m
cost_mf_days0   int     %9.0g                 Bl: Days of work/school lost for malaria/fever last 6 m
cost_m_pub0     byte    %9.0g                 Bl: # malaria episodes treated in pub. health struct. last 6 m
cost_mf_pub0    byte    %9.0g                 Bl: # malaria/fever episodes treated in pub. health struct. last 6 m
cost_m_priv0    byte    %9.0g                 Bl: # malaria episodes treated in priv. health struct. last 6 m
cost_mf_priv0   byte    %9.0g                 Bl: # malaria/fever episodes treated in priv. health struct. last last 6 m
cost_m_exp0     double  %9.0g                 Bl: Tot. exp. (2008/09 Rs) for malaria last 6 m (single question)
cost_mf_exp0    double  %9.0g                 Bl: Tot. exp. (2008/09 Rs) for malaria/fever last 6 m (single question)
cost_m_expit0   double  %9.0g                 Bl: Tot. exp. (2008/09 Rs) for malaria last 6 m (itemized)
cost_mf_expit0  double  %9.0g                 Bl: Tot. exp. (2008/09 Rs) for malaria/fever last 6 m (single question)
cost_m_expdd0   double  %9.0g                 Bl: Total doctors/drugs expenditure (2008/09 Rs) for malaria last 6 m
cost_mf_expdd0  double  %9.0g                 Bl: Total doctors/drugs expenditure (2008/09 Rs) for malaria/fever last 6 m
cost_m_debt0    byte    %9.0g                 Bl: # times debt due to malaria episodes last 6 m
cost_mf_debt0   byte    %9.0g                 Bl: # times debt due to malaria/fever episodes last 6 m
cost_m_less0    byte    %9.0g                 Bl: # times reduction in cons. due to malaria episodes last 6 m
cost_mf_less0   byte    %9.0g                 Bl: # times reduction in cons. due to malaria/fever episodes last 6 m
type0           byte    %23.0g     q1802      Bl: Type of individual tested (18.02)
agem0           byte    %19.0g     q1803      Bl: Age (in months), U5 only (18.03)
height0         float   %19.0g     q1803      Bl: Height (in cm.), (18.04)
lf0             byte    %9.0g                 Baseline LF RDT (1=Positive, 0=Negative)
hb0             float   %9.0g                 Baseline Hb RDT result
malaria0        int     %23.0g     malaria0   Baseline malaria RDT: 0/1/2/3 code
m0              byte    %9.0g                 Baseline malaria status (0/1)
use_net_last    byte    %8.0g      yesno      1.08: FUp Slept under net last night
use_itn_last    byte    %8.0g      yesno      1.09: FUp net used last night treated last 6mts
use_net_usual   byte    %8.0g      yesno      1.10: FUp Usually sleeps under net when lots of mosquitoes
use_itn_usual   byte    %8.0g      yesno      1.11: FUp net used when lots of mosquitoes treated last 6mts
test1_day       byte    %8.0g      negatives
                                              FUp: day of testing
test1_month     byte    %8.0g      negatives
                                              FUp: month of testing
test1_year      byte    %8.0g      negatives
                                              FUp: year of testing
bloodtester     str21   %21s                  10: FUp Name of Blood tester
bloodtester_o~r str22   %22s                  
net1            byte    %9.0g                 2.05 FUp: Used a net last night (from Census of Sleeping Spaces)
net_seen1       byte    %9.0g                 2.07 FUp: Used a net last night, seen by surveyor (from CSS)
net_good1       byte    %9.0g                 2.08 FUp: Used a net last night, seen to be in good conditions (from CSS)
net_hung1       byte    %9.0g                 2.09 FUp: Used a net last night, seen to hang properly (from CSS)
net_biswa1      byte    %9.0g                 2.10 FUp: Used a net last night, seen to be BISWA net (from Census of Sleeping S
survey_m1       byte    %9.0g                 FUp: Any reported malaria episode in 2 months before interview
survey_mf1      byte    %9.0g                 FUp: Any reported malaria/fever episode in 2 months before interview
survey_m_now1   byte    %9.0g                 FUp: Reported malaria episode in same month as interview
survey_mf_now1  byte    %9.0g                 FUp: Reported malaria/fever episode in same month as interview
survey_m61      byte    %9.0g                 FUp: Total # reported malaria episodes last 6 m
survey_mf61     byte    %9.0g                 FUp: Total # reported malaria/fever episodes last 6 m
cost_m_days1    int     %9.0g                 FUp: Days of work/school lost for malaria last 6 m
cost_mf_days1   int     %9.0g                 FUp: Days of work/school lost for malaria/fever last 6 m
cost_m_pub1     byte    %9.0g                 FUp: # malaria episodes treated in pub. health struct. last 6 m
cost_mf_pub1    byte    %9.0g                 FUp: # malaria/fever episodes treated in pub. health struct. last 6 m
cost_m_priv1    byte    %9.0g                 FUp: # malaria episodes treated in priv. health struct. last 6 m
cost_mf_priv1   byte    %9.0g                 FUp: # malaria/fever episodes treated in priv. health struct. last last 6 m
cost_m_exp1     long    %9.0g                 FUp: Tot. exp. (2008/09 Rs) for malaria last 6 m (single question)
cost_mf_exp1    long    %9.0g                 FUp: Tot. exp. (2008/09 Rs) for malaria/fever last 6 m (single question)
cost_m_expit1   long    %9.0g                 FUp: Tot. exp. (2008/09 Rs) for malaria last 6 m (itemized)
cost_mf_expit1  long    %9.0g                 FUp: Tot. exp. (2008/09 Rs) for malaria/fever last 6 m (single question)
cost_m_expdd1   long    %9.0g                 FUp: Total doctors/drugs expenditure (2008/09 Rs) for malaria last 6 m
cost_mf_expdd1  long    %9.0g                 FUp: Total doctors/drugs expenditure (2008/09 Rs) for malaria/fever last 6 m
cost_m_debt1    byte    %9.0g                 FUp: # times debt due to malaria episodes last 6 m
cost_mf_debt1   byte    %9.0g                 FUp: # times debt due to malaria/fever episodes last 6 m
cost_m_less1    byte    %9.0g                 FUp: # times reduction in cons. due to malaria episodes last 6 m
cost_mf_less1   byte    %9.0g                 FUp: # times reduction in cons. due to malaria/fever episodes last 6 m
roster_m61      byte    %9.0g                 FUp: # malaria episodes last 6 m, from roster
roster_m6diag1  byte    %9.0g                 FUp: # malaria episodes last 6mts, from roster, confirmed by blood test
roster_m_now1   byte    %9.0g                 FUp: Has malaria now, from household roster
roster_m_nowd~1 byte    %9.0g                 FUp: Has malaria now, from household roster, confirmed by blood test
hb1             float   %9.0g                 Follow-up Hb RDT result
m1              byte    %9.0g                 Follow-up malaria RDT: 0=-ve, 1=+ve
malaria1        int     %40.0g     malaria    Follow-up malaria RDT: 0/1/2/3 code
age_fup         int     %8.0g                 1.04: FUp Age (in years)
netlast_bl      float   %9.0g                 Baseline, any net used last night
itnlast_bl      float   %9.0g                 Baseline, ITN used last night
netus_bl        float   %9.0g                 Baseline, any net used in peak season
netlast_fup     float   %9.0g                 Follow-up, any net used last night
itnlast_fup     float   %9.0g                 Follow-up, ITN used last night
netus_fup       float   %9.0g                 Follow-up, any net used in peak season
itnus_fup       float   %9.0g                 Follow-up, ITN used in peak season
-------------------------------------------------------------------------------------------------------------------------------------------------
Sorted by: 

```

__Notes:__ Quotes are only necessary in file or folder names if there are spaces in them, but they can always be used. The option `clear` is only necessary if there is already data loaded, but is useful to include in case you wish to only run a proportion of the .do file later.

## Part 2: Summary statistics, confidence intervals, and t-tests

Now that we have imported the data, we will begin to examine it further. In the last exercise, we examined how we could use the `summarize` command to obtain the sample average and standard deviation. In this module, we will calculate an estimate of the population mean with measures of confidence. Since we use the sample average to estimate the population mean, the estimate of the population mean can be read directly from the output of the `summarize` command. However, the `summarize` command does not tell us how confident we can be in that estimate.

Let's consider `survey_m61`, a variable that measures the total number of "reported malaria episodes" that the individual experienced in the prior 6 months.  We can estimate the population mean of this variable and a 95% confidence interval using a single command, `ci mean`.

__Task 2:__

Estimate a 95% confidence interval of the population mean of `survey_m61`. 

__Execution 2:__

```
. ci mean survey_m61

    Variable |        Obs        Mean    Std. Err.       [95% Conf. Interval]
-------------+---------------------------------------------------------------
  survey_m61 |     17,202    .0920242    .0024892        .0871452    .0969032

```

This output shows that the sample average is 0.0920242.  That is, on average, individuals in the sample experienced this many episodes of malaria, or more naturally, about one in ten people reported having malaria in the last 6 months.

Second, the table shows that we can state with 95% confidence that the population mean of the number of malaria episodes in the past 6 months falls between .0871452 and .0969032.

The `ci mean` command can also be used to calculate other confidence intervals (enter `help ci mean` to see what's possible). For example, we can calculate 90% and 99% confidence intervals of the population average of `survey_m61`.

__Task 3:__

Estimate a 90% and 99% confidence interval of the population mean of `survey_m61`. 

__Execution 3:__ 

```
. *90% CI
. ci mean survey_m61, level(90)

    Variable |        Obs        Mean    Std. Err.       [90% Conf. Interval]
-------------+---------------------------------------------------------------
  survey_m61 |     17,202    .0920242    .0024892        .0879297    .0961187

. 
. *99% CI
. ci mean survey_m61, level(99)

    Variable |        Obs        Mean    Std. Err.       [99% Conf. Interval]
-------------+---------------------------------------------------------------
  survey_m61 |     17,202    .0920242    .0024892        .0856118    .0984366

```

So there's a 90% chance that the population mean falls between .0879297 and 0961187, and a 99% chance that it falls between .0856118 and .0984366. 

Suppose we want to calculate how confident we can be that the population average of `survey_m61` is not equal to 1.  Just looking at the confidence interval above, this seems rather unlikely, but conducting a t-test lets us quantify just how unlikely it is.  We first run a t-test using the `ttest` command, then examine at the p-value from the test. Run the test and determine the confidence with which we can reject the null hypothesis that the population average equals 1.

__Task 4:__

Test the null hypothesis that the population mean of `survey_m61` equals 1 against the alternative hypothesis that the population average is not equal to 1. What are the t-score and p-value of the test?

__Execution 4:__ 


```
. ttest survey_m61 == 1

One-sample t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
surv~m61 |  17,202    .0920242    .0024892    .3264698    .0871452    .0969032
------------------------------------------------------------------------------
    mean = mean(survey_m61)                                       t = -3.6e+02
Ho: mean = 1                                     degrees of freedom =    17201

    Ha: mean < 1                 Ha: mean != 1                 Ha: mean > 1
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000

``` 

Based on the output from Stata, the t-score of the test is about `-3.6*10^2` or `-360`. The parameter `Pr(|T| > |t|) = 0.0000` displays the p-value associated with the test that `survey_m61=1` against the alternative hypothesis that `survey_m61!=1`. You may ignore `Pr(T < t) = 0.0000` and `Pr(T > t) = 1.0000` as they report the results of so-called "one-sided t-tests tests" that we do not cover in this course.

In this case, we see that the p-value is less than 0.00005 (it is rounded to 0.0000). Hence, it is very unlikely that the population means equals 1. 

Let's look at a more probable value of the population mean of `survey_m61`. Test the null hypothesis that the population mean of `survey_m61` equals `0.095` against the alternative hypothesis that the population average is not equal to 0.095. 

__Task 5:__

Run a t-test testing the null hypothesis that the population mean of `survey_m61` equals 0.095 against the alternative hypothesis that the population average is not equal to 0.095. 

__Execution 5:__ 

```
. ttest survey_m61 == .095

One-sample t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
surv~m61 |  17,202    .0920242    .0024892    .3264698    .0871452    .0969032
------------------------------------------------------------------------------
    mean = mean(survey_m61)                                       t =  -1.1955
Ho: mean = .095                                  degrees of freedom =    17201

   Ha: mean < .095             Ha: mean != .095               Ha: mean > .095
 Pr(T < t) = 0.1160         Pr(|T| > |t|) = 0.2319          Pr(T > t) = 0.8840

```

In this case, the p-value is relatively large at `0.2319`. So we can only say that the population mean is not equal to `0.095` with about `73%` confidence. This makes sense since the 90% confidence interval of the population mean we calculated earlier includes this value. In other words, the population mean of `survey_m61` is not different from `0.095` by a statistically significant margin. 

## Part 3: Comparing means

So far, we have learned how to estimate the population mean of a variable and use the `ttest` command to test the hypothesis that the population mean equals a particular value. Next, we will use the `ttest` command to compare 2 means – in particular, to ask if they are different.

Suppose that we aim to test if there is a difference in the proportion of people that reported using a net during the follow-up survey among the group that was offered a loan and the control group. 

Perform this test by generating the appropriate variable (hint: `arm_mf` indicates that the respondent was offered the loan and `arm_c` indicates that they were part of the control group) and then performing a t-test. You should look at the documentation for a two-sample t-test using groups. There are several other possible t-tests, but we will not cover them in this course.

__Task 6:__

Run a t-test to determine whether the average of `netlast_fup` is different among the control group and treatment group that was offered a loan.

__Execution 6:__ 

```
. generate treat_loan = 1 if arm_mf == 1
(12,377 missing values generated)

. replace treat_loan = 0 if arm_c == 1
(5,981 real changes made)

. 
. label define treat_loan 0 "Control" 1 "MF loan"

. label val treat_loan treat_loan

. 
. ttest netlast_fup, by(treat_loan)

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
 Control |   2,907    .1757826    .0070609    .3807006    .1619377    .1896275
 MF loan |   2,949     .301119     .008449    .4588221    .2845524    .3176856
---------+--------------------------------------------------------------------
combined |   5,856    .2389003    .0055727    .4264481    .2279757    .2498248
---------+--------------------------------------------------------------------
    diff |           -.1253364    .0110256               -.1469507   -.1037222
------------------------------------------------------------------------------
    diff = mean(Control) - mean(MF loan)                          t = -11.3678
Ho: diff = 0                                     degrees of freedom =     5854

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000

```

__Notes:__ We cannot use `by(arm_mf)` since respondents offered a free net would have an `arm_mf` value of 0. That would mean that we were testing the rate of people that used a net among the MF loan group to people in either the control or free net group. The way that we generated `treat_loan`, we are comparing the MF loan group to the control group and not considering the free net group in the calculations. 

Respondents that were offered the loan to purchase a net were more likely to report sleeping under a net the prior night be a statistically significant margin. In addition, by comparing the means we can see that this gap was over 10 percentage points. Hence, offering loans to purchase insecticide-treated bed-nets was successful at increasing their use. 

We may also want to compare the proportion of respondents that reported sleeping under a net in the two treatment groups: those that were offered a loan and those that received a free net. Perform another t-test to determine if net use is higher among the group that received free nets than the group that was offered a loan to purchase a net.

__Task 7:__

Run a t-test to determine whether the average of `netlast_fup` is different among the treatment group that was offered a loan and the treatment group that was given a free bed net. 

__Execution 7:__ 

```
. generate treat_free = 1 if arm_free == 1
(12,173 missing values generated)

. replace treat_free = 0 if arm_mf == 1
(6,192 real changes made)

. 
. label define treat_free 0 "MF Loan" 1 "Free"

. 
. ttest netlast_fup, by(treat_free)

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
       0 |   2,949     .301119     .008449    .4588221    .2845524    .3176856
       1 |   3,181    .5337944    .0088463    .4989351    .5164494    .5511395
---------+--------------------------------------------------------------------
combined |   6,130    .4218597    .0063082    .4938966    .4094934     .434226
---------+--------------------------------------------------------------------
    diff |           -.2326754    .0122717               -.2567321   -.2086186
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t = -18.9604
Ho: diff = 0                                     degrees of freedom =     6128

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000

```

Respondents that were given a free bed net were over 20 percentage points more likely to report sleeping under a net the prior night than respondents that were offered a loan to purchase a bed net. This difference is statistically significant. This makes sense since the group that was offered a loan still had to pay for a net.  