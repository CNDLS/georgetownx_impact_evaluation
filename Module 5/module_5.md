# Module 5 Stata Tutorial


This tutorial introduces the Stata commands associated with the content in **Module 5: Regression**.

We use data from a randomized controlled trial (RCT) in Malawi in which individuals were provided varying incentives to learn their HIV status after receiving an HIV test.<sup>[1](#myfootnote1)</sup> The data can be downloaded [here](https://www.aeaweb.org/aer/data/dec08/20060732_data.zip) or from the course web page. The Abdul Latif Jameel Poverty Action Lab provides a [detailed description](https://www.povertyactionlab.org/evaluation/demand-and-impact-learning-hiv-status-malawi) of the intervention.

The data is contained in a compressed (zip) file. The extracted file contains the Stata .do files used by the author, the data, and a document describing the data. We will use the data (Thornton HIV Testing AER.dta) and the PDF describing the data (Readme.pdf) in this tutorial.

## Part 1: Getting started

Begin by preparing Stata, importing `Thornton HIV Testing AER.dta`, and describe the data.

__Task 1:__ Import and describe `Thornton HIV Testing AER.dta`.

__Execution 1:__ 

```
drop _all
set more off

cd "C://Module 5"

. use "Thornton HIV Testing Data.dta", clear

. describe

Contains data from Thornton HIV Testing Data.dta
  obs:         4,820                          
 vars:            44                          12 Mar 2008 11:10
 size:       785,660                          (_dta has notes)
-------------------------------------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
-------------------------------------------------------------------------------------------------------------------------------------------------
site            float   %9.0g                 1=Mchinji 2=Balaka 3=Rumphi
rumphi          float   %9.0g                 Rumphi
balaka          float   %9.0g                 Balaka
villnum         double  %9.0g                 VILLNUM
m1out           float   %9.0g                 Survey outcome in 1998
m2out           float   %9.0g                 Survey outcome in 2001
survey2004      float   %9.0g                 completed baseline survey
got             float   %9.0g                 Got HIV results
zone            float   %9.0g                 VCT zone
distvct         float   %9.0g                 Distance in km
tinc            float   %9.0g                 Total value of the incentive (kwacha)
Ti              float   %9.0g                 Value of incentive (kwacha) discrete
any             float   %9.0g                 Received any incentive
under           float   %9.0g                 under 1.5 km
over            float   %9.0g                 over 1.5 km
simaverage      float   %9.0g                 (mean) simaverage
age             float   %10.0g                Age
age2            float   %9.0g                 Age squared
male            float   %9.0g                 Gender
mar             float   %9.0g                 Married at baseline
educ2004        float   %9.0g                 Yrs of completed education
timeshadsex_s   byte    %8.0g                 Times per month had sex (subsample)
hadsex12        float   %9.0g                 Had sex in past 12 months (baseline)
eversex         float   %9.0g                 Ever had sex at baseline
usecondom04     float   %9.0g                 Used a condom during last year at baseline
tb              float   %9.0g                 HIV Test before baseline
thinktreat      float   %9.0g                 Think there will be ARV treatment in the future
a8              byte    %8.0g      A8         Likelihood of HIV infection
land2004        float   %9.0g                 Owned any land at baseline
T_consentsti    long    %8.0g      yesno      consent to sti test
T_consenthiv    long    %8.0g      yesno      consent to hiv test
T_final_trich~t float   %9.0g      res        final trich results
T_final_resul~t float   %23.0g     otherres   final CT results
T_final_resul~c float   %23.0g     otherres   final GC results
hiv2004         float   %9.0g                 HIV results
test2004        float   %9.0g                 HIV test in 2004
followup_tested byte    %8.0g                 Different HIV testing sample. Drop from analysis
followupsurvey  float   %9.0g                 Was interviewed at follow-up
havesex_fo      byte    %10.0g                Had sex between baseline and follow-up
numsex_fo       byte    %10.0g                Num partners between baseline and follow-up
likelihoodhiv~o int     %10.0g                Likelihood of infection at follow-up
numcond         float   %9.0g                 Number of condoms purchased at follow-up
anycond         float   %9.0g                 Any condoms purchased at the follow-up
bought          float   %9.0g                 Bought condoms on own at follow-up
-------------------------------------------------------------------------------------------------------------------------------------------------
Sorted by: 


```

Confirm that there are 44 variables and 4,820 observations.

##Part 2: Regressions in Stata

In this section, we will analyze the impact of receiving _any_ monetary incentive on the study participant's decision to learn the results from their HIV test. The variable `tinc` records the total value of the monetary incentive that respondent was offered (in kwacha). We may `tabulate` the variable `tinc` to see what range of incentives were offered. 

__Task 2:__ Tabulate `tinc`. 

__Execution 2:__ 

```
. tabulate tinc

Total value |
     of the |
  incentive |
   (kwacha) |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        679       23.41       23.41
         10 |         58        2.00       25.41
         20 |        154        5.31       30.71
         30 |         81        2.79       33.51
         40 |         64        2.21       35.71
         50 |        205        7.07       42.78
         60 |         37        1.28       44.05
         70 |         40        1.38       45.43
         80 |          7        0.24       45.67
         90 |          8        0.28       45.95
        100 |        492       16.96       62.91
        110 |         14        0.48       63.39
        120 |         82        2.83       66.22
        130 |          9        0.31       66.53
        140 |         42        1.45       67.98
        150 |         43        1.48       69.46
        160 |         28        0.97       70.42
        170 |          8        0.28       70.70
        180 |          9        0.31       71.01
        200 |        431       14.86       85.87
        210 |         36        1.24       87.11
        220 |         48        1.65       88.76
        230 |         30        1.03       89.80
        240 |          2        0.07       89.87
        250 |         68        2.34       92.21
        260 |          3        0.10       92.31
        300 |        223        7.69      100.00
------------+-----------------------------------
      Total |      2,901      100.00
```

From the tabulation, we can see that a wide range of incentives were offered. However, in this exercise we only aim to analyze the effect of receiving _any_ financial incentive. Hence, we want to create a `factor variable` indicating whether or not the respondent in question received an incentive. Refer to the Stata exercise associated with __Module 3__ if you need a refresher on factor variables. 

__Task 3:__ Generate a variable called `treatment` that takes on a value of 1 if the respondent received any financial incentive, and otherwise takes on a value of 0. Label the values of `treatment` so that 1 displays as `Treatment` and 0 displays as `Control`.

```
. generate treatment = cond(tinc>0, 1,0)

. label define treatment 0 "Control" 1 "Treatment"

. label val treatment treatment
```

Now that we have created the variable `treatment`, we may analyze the impact of receiving a financial incentive on the decision to obtain HIV test results. Recall from the __Module 5__ lesson that we can use regressions to estimate the treatment effect of an intervention. The variable `got` indicates whether or not the respondent received the results of their HIV test. Use the `regress` command to calculate the treatment effect of being offered any monetary incentive to learn HIV results. Refer to the __Module 5__ videos for detailed instructions on how to interpret the results.

__Task 4:__ Run a regression of `got` on `treatment`.

__Execution 4:__ 

```
. regress got treatment


      Source |       SS           df       MS      Number of obs   =     2,894
-------------+----------------------------------   F(1, 2892)      =    576.85
       Model |  101.710406         1  101.710406   Prob > F        =    0.0000
    Residual |  509.916409     2,892  .176319643   R-squared       =    0.1663
-------------+----------------------------------   Adj R-squared   =    0.1660
       Total |  611.626814     2,893  .211416113   Root MSE        =     .4199

------------------------------------------------------------------------------
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .4561203    .018991    24.02   0.000     .4188831    .4933575
       _cons |   .3386838   .0168231    20.13   0.000     .3056973    .3716703
------------------------------------------------------------------------------

```
**Notes:** The dependent variable is always listed first followed by all independent variables. 

The treatment effect is 0.4506, or about 45 percentage points, compared to a control group average, measured by the constant term, of about 34 percent (0.3387).  The treatment effect has a p-value of 0.000, and the 95% confidence interval is from about 42 to 49 percentage points.

### Robust standard errors

In most regression analyses, we typically include an additional option, `robust`. The option instructs Stata to calculate so-called “robust standard errors”, which tend to be larger than unadjusted errors.  It is necessary to calculate robust standard errors when the data exhibit what’s called heteroskedasticity, which basically means that the variance of observed values of the dependent variable changes as the independent variables vary.  The `robust` option does NOT change the estimate of any parameter in a regression, just the standard errors and confidence intervals.

> Aside: on heteroskedasticity
>
> To understand what’s going on, consider a comparison of means in two groups, say a treatment group and a control group.  When making this comparison, we assumed that the distributions of outcomes in the two groups had the same variance, even though their means might have differed.  Under this “homoskedasticity” assumption, we calculated standard errors and confidence intervals.
>
> But if the variances in the treatment and control groups had been different – that is, if the error terms were heteroskedastic – then the formula for the standard error of the difference in means would have been a bit different, and the confidence intervals a bit wider.
>
> Now remember that a regression of an outcome on treatment group assignment, is simply a way of comparing the mean outcomes in the treatment and control groups.  And if we are concerned that the distributions of outcomes in the two groups might have different variances, then we’ll have to adjust the standard errors.
>
>This intuition carries over to any regression, not just one involving two values of the independent variable, and adding the robust option tells Stata to calculate standard errors that account for the heteroskedastic properties of the data.  The robust option does NOT change the estimate of any parameter in a regression, just the standard errors and confidence intervals.

Now run a regression of `got` on `treatment` with the `robust` option.

__Task 5:__ Run a regression of `got` on `treatment` with robust standard errors. 

__Execution 5:__ 

```
. regress got treatment, robust

Linear regression                               Number of obs     =      2,894
                                                F(1, 2892)        =     482.00
                                                Prob > F          =     0.0000
                                                R-squared         =     0.1663
                                                Root MSE          =      .4199

------------------------------------------------------------------------------
             |               Robust
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .4561203   .0207756    21.95   0.000     .4153837    .4968568
       _cons |   .3386838   .0189674    17.86   0.000     .3014928    .3758748
------------------------------------------------------------------------------
```

The coefficients on `treatment` and the constant term are exactly the same as in Task 5. But observe that both of the standard errors are larger. 

> Aside: on testing for heteroskedasticity
>
> A simple test to determine the validity of this assumption is to regress `got` on `treatment` without robust standard errors, then immediately enter the command `estat hettest`. 

__Task 6:__ Run a regression of `got` on `treatment` without robust standard errors, then execute the command `estat hettest`. 

__Execution 6:__ 

```
. regress got treatment


      Source |       SS           df       MS      Number of obs   =     2,894
-------------+----------------------------------   F(1, 2892)      =    576.85
       Model |  101.710406         1  101.710406   Prob > F        =    0.0000
    Residual |  509.916409     2,892  .176319643   R-squared       =    0.1663
-------------+----------------------------------   Adj R-squared   =    0.1660
       Total |  611.626814     2,893  .211416113   Root MSE        =     .4199

------------------------------------------------------------------------------
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .4561203    .018991    24.02   0.000     .4188831    .4933575
       _cons |   .3386838   .0168231    20.13   0.000     .3056973    .3716703
------------------------------------------------------------------------------

. estat hettest

Breusch-Pagan / Cook-Weisberg test for heteroskedasticity 
         Ho: Constant variance
         Variables: fitted values of got

         chi2(1)      =    29.19
         Prob > chi2  =   0.0000
```

> The `estat hettest` command effectively tests the null hypothesis that errors are homoskedastic against the alternative hypothesis that the variance in standard errors either increases or decreases with one or more of the dependent variables. The very low p-value (`Prob > chi`) indicates that we can safely reject the null hypothsis that standard errors are homoskedastic. 
>
> As a cautionary note, `estat hettest` does not capture all instances of heteroskedasticity. For instance, you may have a case where errors are very large for small and large values of the independent variable, but small for values in between. In this case, errors are not increasing or decreasing with respect to the independent variable, so `estat hettest` will not find heteroskedasticity, but errors are not uniformly distributed. If you are not sure whether or not to include the `robust` option, we advise including it since it is better to err on the side of caution. In instances where the dependent variable is binary (takes on a value of 0 or 1), we suggest using robust standard errors because the dependent variable may introduce heteroskedasticity by construction.

Now that we have discussed robust standard errors, we may return to analyzing the effect of monetary incentives on respondents' decision to learn their HIV status. 

Use the `summarize` command to confirm that the regression coefficient is equal to the difference in means.

__Task 7:__ Calculate the mean of `got` among those that were treated and were not treated.

__Execution 7:__ 

```
. summarize got if treatment == 0

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
         got |        623    .3386838    .4736425          0          1

. summarize got if treatment == 1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
         got |      2,271    .7948041    .4039337          0          1

```

__Notes:__ Note that the average in the control group in this table is indeed the same as the constant term in the earlier regression.  Also, the sum of the constant term and the treatment effect in the regression table is equal to the average in the treatment group.

Now, suppose that we wish to control for age. Add this variable to the regression.

__Task 8:__ Add the control variable `age` to the regression of `got` on `treatment`

__Execution 8:__ 

```
. regress got treatment age, robust

Linear regression                               Number of obs     =      2,888
                                                F(2, 2885)        =     248.14
                                                Prob > F          =     0.0000
                                                R-squared         =     0.1681
                                                Root MSE          =     .41936

------------------------------------------------------------------------------
             |               Robust
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .4521674   .0208415    21.70   0.000     .4113016    .4930332
         age |   .0017075   .0005772     2.96   0.003     .0005756    .0028393
       _cons |   .2849152   .0261532    10.89   0.000     .2336343     .336196
------------------------------------------------------------------------------


```

__Notes:__ The coefficient does not change much at all, which is what we would tend to expect.  Note also that the statistical significance of the treatment effect estimate, as measured by the confidence interval, is also largely unaffected by including the age control.

The treatment effect may be different between men and women. Include an interaction between `treatment` and `male` to test for heterogeneous treatment effects. This is most easily done by generating a new variable equal to `treatment`\*`male` to capture the interaction and including it in the regression.

__Task 9:__ Regress `got` on `treatment`, `male`, and an interaction between `treatment` and `male`.

__Execution 9:__ 

```
. generate treatxmale = treatment*male

. 
. regress got treatment male treatxmale, robust

Linear regression                               Number of obs     =      2,894
                                                F(3, 2890)        =     160.89
                                                Prob > F          =     0.0000
                                                R-squared         =     0.1664
                                                Root MSE          =     .42002

------------------------------------------------------------------------------
             |               Robust
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .4521861   .0286526    15.78   0.000     .3960044    .5083678
        male |  -.0165726   .0379766    -0.44   0.663    -.0910365    .0578913
  treatxmale |   .0081584   .0416196     0.20   0.845    -.0734488    .0897655
       _cons |   .3465046    .026253    13.20   0.000     .2950282     .397981
------------------------------------------------------------------------------

```
__Notes:__ The coefficient on the interaction term (treatxmale) of .0074354 is not statistically significant, so we cannot conclude that the treatment had a differential effect on men and women.

We cannot conclude that the treatment effect is different for men than for women, but perhaps financial incentives matter more to older individuals. Run a regression to test this hypothesis.

__Task 8:__ Regress `got` on `treatment`, `age`, and an interaction between `treatment` and `age`.

__Execution 8:__ 

```
. generate treatxage = treatment*age
(441 missing values generated)

. regress got treatment age treatxage, robust

Linear regression                               Number of obs     =      2,888
                                                F(3, 2884)        =     166.34
                                                Prob > F          =     0.0000
                                                R-squared         =     0.1685
                                                Root MSE          =     .41933

------------------------------------------------------------------------------
             |               Robust
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .5093135   .0553942     9.19   0.000     .4006973    .6179297
         age |   .0031301    .001485     2.11   0.035     .0002183    .0060418
   treatxage |  -.0017605   .0016095    -1.09   0.274    -.0049164    .0013953
       _cons |   .2392093   .0503174     4.75   0.000     .1405476     .337871
------------------------------------------------------------------------------

```

__Notes:__ The coefficient on the interaction term (treatxage) of -.0018617 is again not statistically significant so we cannot conclude that age impacts the effectiveness of the intervention.


___

## Footnotes

<a name="myfootnote1">1</a>: Thornton, Rebecca L. 2008. "The Demand for, and Impact of, Learning HIV Status." *American Economic Review*, 98 (5): 1829-63.

<a name="myfootnote2">2</a>: The same method brings up the help pages for all Stata commands.