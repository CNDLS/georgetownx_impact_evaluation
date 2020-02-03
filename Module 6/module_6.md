# Module 6 Stata Tutorial

This tutorial introduces the Stata commands associated with the content in __Module 6: Further topics in RCTs__.

We will use the same data for this exercise as we did in __Module 5: Regression__. Configure Stata and load the data the same way that you did for Module 5. In addition, generate a variable called `treatment` indicating if the respondent received any financial incentive following the same procedure as in Module 5. 

__Task 1:__ Import `Thornton HIV Testing AER.dta` and generate a variable called `treatment` that takes on a value of 1 if the respondent received any financial incentive, and otherwise takes on a value of 0. Label the values of `treatment` so that 1 displays as `Treatment` and 0 displays as `Control`.

__Execution 1:__ 

```
. drop _all

. set more off

. 
. cd "C:\\Module 6" //Note - this path and the path to the dta file may vary on your computer 
C:\\Module 6

. 
. use "Data/Thornton HIV Testing Data.dta", clear

. 
. generate treatment = cond(tinc>0, 1,0)

. label define treatment 0 "Control" 1 "Treatment"

. label val treatment treatment

```

## Part 1: Compliance

The objective of this study is to evaluate how learning one's HIV status changes an individual’s sexual behavior.  Being "treated" means an individual knows her or his HIV status; for those assigned to the treatment group, a monetary incentive is used to encourage them to obtain this information.

First, let’s calculate the compliance rate for the experiment, which we defined in module 6 as the difference between the share of members of the treatment group who know their HIV status, and the share in the control group who know it.  The variable that indicates whether a respondent learned the results of her/his HIV test is `got`. 


__Task 2:__ Calculate the shares of people in the treatment and control groups who learned their HIV status.

__Execution 2:__ 

```

. generate followed_treatment = cond(treatment==1, got, 1-got)
(1,926 missing values generated)

. 
. tab followed_treatment if treatment == 0 //control 

followed_tr |
    eatment |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        211       33.87       33.87
          1 |        412       66.13      100.00
------------+-----------------------------------
      Total |        623      100.00

. tab followed_treatment if treatment == 1 //treatment 

followed_tr |
    eatment |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        466       20.52       20.52
          1 |      1,805       79.48      100.00
------------+-----------------------------------
      Total |      2,271      100.00


```

So 66.13% of the control group learned their status (33.87% did obtain test results), and 79.48% of the treatment group did so (79.48% obtained their test results). 

One of the outcomes that Thornton considers is the effect of learning one's HIV status on the decision by sexually active, HIV-positive individuals' to purchase.  To address this question, we will need to restrict the sample to sexually active and HIV-positive respondents.
So to start, let’s calculate the compliance rate among this restricted sample, which could be different to the compliance rate for the population at large.

__Task 3:__ Calculate the compliance rate among the restricted sample. In addition, perform a regression of `got` on `treatment` using the restricted sample. Use the variable `hadsex12` to measure sexual activity and `hiv2004` to determine if the respondent in HIV-positive. 

__Execution 3:__ 

```
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
(4,698 observations deleted)

. tab followed_treatment if treatment == 0 //control 

followed_tr |
    eatment |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |          7       29.17       29.17
          1 |         17       70.83      100.00
------------+-----------------------------------
      Total |         24      100.00

. tab followed_treatment if treatment == 1 //treatment 

followed_tr |
    eatment |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         27       27.55       27.55
          1 |         71       72.45      100.00
------------+-----------------------------------
      Total |         98      100.00

. 
. regress got treatment, robust

Linear regression                               Number of obs     =        122
                                                F(1, 120)         =      17.31
                                                Prob > F          =     0.0001
                                                R-squared         =     0.1284
                                                Root MSE          =     .45203

------------------------------------------------------------------------------
             |               Robust
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .4328231   .1040308     4.16   0.000     .2268493    .6387969
       _cons |   .2916667   .0935505     3.12   0.002     .1064433    .4768901
------------------------------------------------------------------------------

. restore 


```
__Notes:__ The command `preserve` takes a snapshot of the data, and the command `restore` returns it to the state it was in when `preserve` was issued. Hence, we temporarily get rid of observations where the respondent was not sexually active or was not HIV positive, then add them back to the data. 

The sample of respondents in the study who were HIV positive in 2004 and who reported that they were sexually active amounted to just 122 individuals, 24 in the control group and 98 in the treatment group.  In this smaller sample, the share of treated individuals in the control group (corresponding to <a href="https://www.codecogs.com/eqnedit.php?latex=\inline&space;$\phi_A$" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\inline&space;$\phi_A$" title="$\phi_A$" /></a> in Module 6) is 29.17%, and the share of treated individuals in the treatment group (corresponding to  <a href="https://www.codecogs.com/eqnedit.php?latex=\inline&space;$\phi_A&space;&plus;&space;\phi_C$" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\inline&space;$\phi_A&space;&plus;&space;\phi_C$" title="$\phi_A + \phi_C$" /></a>) is 72.45%.

The compliance rate, amongst the group of sexually active HIV-positive respondents, is thus 72.45 – 29.17 = 43.28%.  This value is of course the same as the coefficient on treatment in the regression.  The standard error on the coefficient tells us that the effect of the encouragement on HIV knowledge was highly statistically significant.

## Part 2: Intent to Treat Effect and Treatment Effect on the Treated

Now that we have calculated the compliance rate, we will estimate the Intent to Treat (ITT) Effect of knowledge of HIV-positive status on an individual’s decision to purchase condoms.

__Task 4:__ Calculate the intent to treat effect of learning that one is HIV positive on the decision to purchase any condoms, restricting the sample to sexually active individuals. Use robust standard errors.

__Execution 4:__ 

```
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
(4,698 observations deleted)

. 
. regress anycond treatment, robust

Linear regression                               Number of obs     =         52
                                                F(1, 50)          =       2.30
                                                Prob > F          =     0.1356
                                                R-squared         =     0.0343
                                                Root MSE          =     .48756

------------------------------------------------------------------------------
             |               Robust
     anycond |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .2285714   .1506789     1.52   0.136    -.0740761     .531219
       _cons |         .2   .1289961     1.55   0.127    -.0590963    .4590963
------------------------------------------------------------------------------

. restore

```

Note: You may notice that there are only 52 observations here, but there were 122 in the prior task. The difference in sample size is due to 70 missing observations in the variable `anycond`. 

Based on the regression estimates, 20 percent of sexually active and HIV-positive individuals who were not offered a financial incentive to learn their HIV status nonetheless purchased condoms, while those who were offered the financial incentive were about 23 percentage points _more_ likely to purchase condoms. This suggests that being given a financial incentive to learn one’s HIV status increases the willingness to purchase condoms. However, the estimate is not statistically significant, with a p-value of 0.136.

Next, we will calculate the Local Average Treatment Effect (LATE) estimate of learning that one is HIV positive on the decision to purchase condoms. We will first do this manually by using the results from the regression of `anycond` on `treatment` and `got` on `treatment`. We will then use the two-stage least squares (2SLS) method.

__Task 5:__ Use the results of the regression of `anycond` on `treatment` and `got` on `treatment` to calculate the TOT effect. 

Do not use the results of the earlier regression of `got` on `treatment` for the calculation. Instead, run the regression again with a restricted sample of only the observations where `anycond` is not missing. This ensures we get the same result from the manual calculation as we will get by using 2SLS. 

__Execution 5__: 

```
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
(4,698 observations deleted)

. drop if missing(anycond)
(70 observations deleted)

. 
. regress got treatment, robust

Linear regression                               Number of obs     =         52
                                                F(1, 50)          =       6.38
                                                Prob > F          =     0.0147
                                                R-squared         =     0.1150
                                                Root MSE          =     .46198

------------------------------------------------------------------------------
             |               Robust
         got |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .4142857   .1639922     2.53   0.015     .0848976    .7436738
       _cons |         .3   .1477836     2.03   0.048     .0031679    .5968321
------------------------------------------------------------------------------

. 
. dis "TOT = " .2285714/.4142857
TOT = .55172409

. restore

```

Using the fact that the LATE effect is equal to the ITT effect divided by the compliance rate (i.e., the difference in the probably of being treated between the treatment group and control group), we estimate that amongst sexually active HIV-positive respondents, learning one’s HIV status increases the likelihood of purchasing condoms by over 50 percentage points.

However, we did not calculate a standard error, so we don't know if this value is statistically significant or not. For that, we will need to use the 2SLS method to calculate the LATE effect.

> A note on instrumental variable regression: 

> The 2SLS method is a form of _instrumental variable regression_. We will not go into the details of these regressions in this course. However, it is useful to learn some terminology to help navigate the 2SLS Stata command. The variable indicating treatment assignment is called an _instrumental variable_ or _instrument_. The variable indicating if one was actually treated, in this case `got`, is considered an _endogenous variable_. 

__Task 6:__ Use the `ivregress` command to calculate the LATE effect. 

__Execution 6:__ 

```
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
(4,698 observations deleted)

. 
. ivregress 2sls anycond (got = treatment), robust

Instrumental variables (2SLS) regression          Number of obs   =         52
                                                  Wald chi2(1)    =       4.25
                                                  Prob > chi2     =     0.0392
                                                  R-squared       =     0.1776
                                                  Root MSE        =     .44118

------------------------------------------------------------------------------
             |               Robust
     anycond |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         got |   .5517241   .2675736     2.06   0.039     .0272896    1.076159
       _cons |   .0344828   .1531167     0.23   0.822    -.2656204    .3345859
------------------------------------------------------------------------------
Instrumented:  got
Instruments:   treatment

. restore

```

Note that the coefficient on `got` is the same as in Task 5 (other than a slight difference created by rounding). However, the results from the 2SLS estimate include a standard error, yielding a p-value of 0.039. Hence, we can conclude that learning that one is HIV positive makes an individual more likely to purchase condoms by a statistically significant margin.

## Part 3: Attrition

Next, we will consider attrition. Since our analysis has only focused on HIV-positive and sexually active individuals, we will consider attrition within this subset of the full sample. 

Before we get into analysis, it is useful to examine the number of people that attrited. Create a table illustrating the overall rate of attrition.

__Task 7:__ Tabulate the number of people that attrited. 

__Execution 7:__ 

```
. //Task 7 
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  //sexually active and HIV-positive
(4,698 observations deleted)

. generate attrited = 1- followupsurvey
(34 missing values generated)

. label var attrited "Respondent attrited"

. label define attrited 0 "Did not attrite" 1 "Attrited"

. label val attrited attrited

. tabulate attrited

     Respondent |
       attrited |      Freq.     Percent        Cum.
----------------+-----------------------------------
Did not attrite |         52       59.09       59.09
       Attrited |         36       40.91      100.00
----------------+-----------------------------------
          Total |         88      100.00

. 
. restore

```

Across the sample of sexually active HIV-positive respondents, 59 percent completed the endline survey, and 41 percent did not – they “attrited”.  Such attrition reduces our statistical power, but we really want to know whether it is likely to introduce bias in our estimates of treatment effects.

Next, we want to test if attrition is random or not. One easy test that we can perform is to regress an indicator for completing the endline survey on treatment – are members of the treatment group more or less likely than members of the control group to complete the survey?

__Task 8:__ Regress `followupsurvey` on `treatment`. 

__Execution 8:__ 

```
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  
(4,698 observations deleted)

. regress followupsurvey treatment, robust

Linear regression                               Number of obs     =         88
                                                F(1, 86)          =       0.11
                                                Prob > F          =     0.7380
                                                R-squared         =     0.0013
                                                Root MSE          =     .49702

------------------------------------------------------------------------------
             |               Robust
followupsu~y |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .0444444   .1324565     0.34   0.738    -.2188705    .3077593
       _cons |   .5555556   .1184754     4.69   0.000     .3200342    .7910769
------------------------------------------------------------------------------

. 
. restore

```

The coefficient on `treatment` is not different from 0 by a statistically significant margin which is a good sign. However, this test does not rule out the possibility of non-random attrition. 

Another useful test that we can run is to test whether the means of baseline demographic variables are equal among the sample of respondents that completed the follow-up survey. This test is not perfect because even if the variables that we have are similar between the groups, there may be differences in characteristics that we cannot observe. In addition, there may be some statistically significant differences even if attrition is random. Nonetheless, the test can still provide useful insight into whether or not there is non-random attrition. 

This test could easily be done manually by running a regression of each of the variables on treatment, restricting the sample to those who completed the endline survey. But a convenient feature of Stata is that other users have written packages that make certain tasks easier. We will use a package called `orth_out` for this exercise. Before running your .do file, type `ssc install orth_out` to install the package. The package is named `orth_out` because the table that it produces is often called an "orthogonality table." You can then use it like any other Stata command. 

__Task 9:__ Restricting the sample to individuals that completed the follow-up survey, test whether the mean of `age`, `male`, `mar`, `educ2004`, `hadsex12`, `tb`, `land2004`, and `usecondom04`. Use the package `orth_out` for this task.

__Execution 9:__ 

```
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  
(4,698 observations deleted)

. keep if followupsurvey == 1
(70 observations deleted)

. 
. orth_out age male mar educ2004 hadsex12 tb land2004 usecondom04, by(treatment) pcompare stars se count

                                           Control:    Treatment:  (1) vs. (~e:
                                                 _             _             _
                            Age:mean        38.100        36.857         0.741
                                  se         2.968         1.677             .
                         Gender:mean         0.600         0.286         0.062
                                  se         0.163         0.071             .
            Married at baseline:mean         0.900         0.833         0.608
                                  se         0.100         0.058             .
     Yrs of completed education:mean         2.500         2.410         0.938
                                  se         1.147         0.502             .
Had sex in past 12 months (ba~l:mean         1.000         1.000             .
                                  se         0.000         0.000             .
       HIV Test before baseline:mean         0.500         0.119         0.005
                                  se         0.167         0.051             .
     Owned any land at baseline:mean         0.800         0.952         0.108
                                  se         0.133         0.033             .
Used a condom during last yea~a:mean         0.400         0.190         0.164
                                  se         0.163         0.061             .
                                 N:_        10.000        42.000             .

. 
. restore 


```

There are statistically significant differences (at the 10% level) in gender and the percent of people that received an HIV test before the baseline. While this test does not necessarily prove that there is non-random attrition, it does provide some cause for concern. Hence, we may want to perform tests to determine the potential effect of attrition on our results. 

We will next calculate Manski and Lee bounds to estimate the effect that attrition might have had on our earlier results. Start by calculating the upper and lower Manski bounds.

__Task 10:__ Calculate the upper and lower Manski bounds of the ITT effect of learning that one is HIV positive on the decision to purchase condoms. 

__Execution 10:__ 

```
//Upper bound
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  
(4,698 observations deleted)

. replace anycond = 1 if followupsurvey==0 & treatment == 1
(28 real changes made)

. replace anycond = 0 if followupsurvey==0 & treatment == 0
(8 real changes made)

. 
. regress anycond treatment, robust

Linear regression                               Number of obs     =         88
                                                F(1, 86)          =      33.47
                                                Prob > F          =     0.0000
                                                R-squared         =     0.1957
                                                Root MSE          =     .45173

------------------------------------------------------------------------------
             |               Robust
     anycond |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |   .5460317   .0943826     5.79   0.000     .3584053    .7336582
       _cons |   .1111111   .0749305     1.48   0.142    -.0378457    .2600679
------------------------------------------------------------------------------

. restore 

//Lower bound
. 
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  
(4,698 observations deleted)

. replace anycond = 0 if followupsurvey==0 & treatment == 1
(28 real changes made)

. replace anycond = 1 if followupsurvey==0 & treatment == 0
(8 real changes made)

. 
. regress anycond treatment, robust

Linear regression                               Number of obs     =         88
                                                F(1, 86)          =       5.29
                                                Prob > F          =     0.0238
                                                R-squared         =     0.0668
                                                Root MSE          =     .45515

------------------------------------------------------------------------------
             |               Robust
     anycond |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
   treatment |  -.2984127   .1297257    -2.30   0.024    -.5562988   -.0405266
       _cons |   .5555556   .1184754     4.69   0.000     .3200342    .7910769
------------------------------------------------------------------------------

. restore 

```

Hence, the upper Manski bound is .5460317 and the lower Manski bound is -.2984127. Both values are different from 0 by a statistically significant margin, but in different directions.

If we believe attrition is random, then our original point estimate of the ITT, about 0.229, is our best guess of the effect, although it is not statistically significantly different from zero.  This value lies between the upper and lower Manski bounds.
 
But if we are concerned that attrition might be biased one way or the other – that is, attrition is correlated, positively or negatively, with the potential impact of the treatment – then our best guess could be as high as 0.546, or as low as -0.298.  Note that both of these estimates are statistically significant, but they are based on extreme assumptions about the missing data.

Next calculate the upper and lower Lee bounds. This would be tricky to do manually. However, there is a package we can install to automatically calculate the bands. Type `ssc install leebounds` to install the package. 

__Task 11:__ Calculate upper and lower Lee bounds of the ITT effect of learning that one is HIV positive on their decision to purchase condoms. 

__Execution 11:__ 

```
. preserve 

. keep if hadsex12 == 1 & hiv2004 == 1  
(4,698 observations deleted)

. 
. leebounds anycond treatment 

Lee (2009) treatment effect bounds

Number of obs.                     =   122
Number of selected obs.            =   52
Trimming porportion                =   0.0278

------------------------------------------------------------------------------
     anycond |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
treatment    |
       lower |   .2122449   .2209034     0.96   0.337    -.2207179    .6452076
       upper |   .2408163   .1947452     1.24   0.216    -.1408773      .62251
------------------------------------------------------------------------------

. restore 

```

So the lower Lee bound is about 21 percentage points, and the upper Lee bound is about 24 percentage points.  These bounds provide a much narrower range of possible effect sizes, a range that again includes the original point estimate of 0.229.  However, like the point estimate, neither of the Lee bounds is statistically significantly different from zero.
