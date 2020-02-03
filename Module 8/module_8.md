# Module 8 Stata Tutorial

This tutorial introduces the Stata commands associated with the content in __Module 8: Difference-in-Difference__.

The data we use is from a study by Jingbo Cui, Junjie Zhang, and Yang Zheng in which they used both a double difference and a triple difference methodology to evaluate the effect of a policy change on firm innovation.  Specifically, the study examines the effect of a new emission trading scheme (ETS) in China on the development by firms of low-carbon technologies.  The authors use patent application data of publicly-listed Chinese firms between 2003 and 2015 for the study (Cui, Jingbo, Junjie Zhang, and Yang Zheng. 2018. "Carbon Pricing Induces Innovation: Evidence from China's Regional Carbon Market Pilots." AEA Papers and Proceedings, 108 : 453-57.). The data can be downloaded here (https://www.aeaweb.org/doi/10.1257/pandp.20181027.data) or from the course page.

There are several dta files in the downloaded directory. We will only use "AEA_P&P_table.dta" in this exercise. We will follow the general methodology used in the paper, but with some simplifications to emphasize the concepts presented in Module 8. Hence, results may not always align exactly with those of the study.

Begin by importing and describing the data to verify that the version you downloaded matches the data used in the tutorial.

__Task 1:__ Import and describe `AEA_P&P_table.dta`. 

__Execution 1:__ 

```
. //Task 1 
. 
. set more off 

. drop _all 

. 
. use "Data/Code & Result/AEA_P&P_table.dta", clear 

. 
. describe 

Contains data from Data/Code & Result/AEA_P&P_table.dta
  obs:        18,937                          
 vars:            23                          12 Jan 2018 12:33
 size:     3,654,841                          
-------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
-------------------------------------------------------------------------------
id              float   %9.0g                 group(id)
year            double  %10.0g              * year
t_Revenue       double  %10.0g                TotalRevenue
t_Assets        double  %10.0g                Assets
t_CurrentLiab~y double  %10.0g                CurrentLiability
t_ROA           float   %9.0g                 ROA, returns on assets
t_EBIT          float   %9.0g                 
Nnindcd         str13   %13s                  Nnindcd
Nindnme         str51   %51s                  Nindnme
Indcd           str13   %13s                  Indcd
province        str24   %24s                  province
region          float   %9.0g                 carbon ETS pilot regions
Ind             float   %9.0g                 covered ETS sectors
post            float   %9.0g                 post announcement year of 2011
price           float   %9.0g                 carbo price across pilots
turnover        float   %9.0g                 turnover rates acorss pilots
logNon_envrAEW  float   %9.0g                 log count of non-low-caron
                                                patents
logNon_envrAE   float   %9.0g                 log count of non-low-caron
                                                patents in narrowed definition
logenvrAEW      float   %9.0g                 log count of low-carbon patents
logenvrAEWRD    float   %9.0g                 log count of low-carbon patents
                                                per RD expenditure
logenvrAE       float   %9.0g                 log count of low-carbon patents
                                                in narrowed defintion
logenvrAERD     float   %9.0g                 log count of low-carbon patents
                                                in narrowed definition per RD
                                                expenditure
envrAEW_ratio   float   %9.0g                 low-carbon patents ratio
                                            * indicated variables have notes
-------------------------------------------------------------------------------
Sorted by: 

. 
```

Make sure that your data has 18,937 observations and 23 variables. 

Before proceeding with the exercise, we need to figure out what we want to accomplish. Following the spirit of Jingbo Cui and his co-authors, we aim to determine whether the introduction of the ETS (cap and trade) scheme in China increased innovation. Consistent with the paper, we will use patent applications to measure innovation. Three sources of variation in the implementation of the program allow us to estimate the treatment effect: time, region, and sector. 

**Time**: The authors collected data on each firm's patent applications before and after the program was implemented. The variable `post` records this and takes on a value of 0 if the observation is before ETS was implemented and 1 if it is after. 

**Region**: The pilot program was implemented in some regions, but not others. The variable `region` records whether the observation is in an area where ETS was implemented. 

**Industry:** The pilot only covers some industries. The variable `Ind` takes on a value of 0 if the industry is not covered by ETS and 1 if it is covered.

We can exploit these differences in when, whether, and which firms are covered by the ETS program to construct double-difference and triple-difference estimates of the effect of ETS on innovation. We will first construct a difference-in-difference estimate using `post` and `region`, and then add `Ind` to calculate a triple difference estimate.

There are two dependent variables that we are interested in examining. First, `logenvrAEW` records the log of the number of patents for low-carbon technologies. Second, `logNon_envrAEW` records the log of the number of patents for non-low-carbon technologies. Begin by calculating the difference-in-difference estimate of the effect of ETS on the number of low-carbon technologies. 

__Task 2:__ Regress `logenvrAEW` on `post`, `region`, and an interaction between `post` and `region`. 

__Execution 2:__ 

```
. //Task 2 
. label define post 0 "Before ETS" 1 "After ETS"

. label val post post 

. 
. label define region 0 "Non-ETS region" 1 "ETS region"

. label val region region

. 
. regress logenvrAEW post##region, cluster(id)

Linear regression                               Number of obs     =     18,937
                                                F(3, 1955)        =     193.83
                                                Prob > F          =     0.0000
                                                R-squared         =     0.0557
                                                Root MSE          =     .69259

                                 (Std. Err. adjusted for 1,956 clusters in id)
------------------------------------------------------------------------------
             |               Robust
  logenvrAEW |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
        post |
  After ETS  |   .2963886   .0146725    20.20   0.000     .2676132     .325164
             |
      region |
 ETS region  |    .099148   .0257738     3.85   0.000     .0486009    .1496951
             |
 post#region |
  After ETS #|
 ETS region  |   .0613632   .0322132     1.90   0.057    -.0018126     .124539
             |
       _cons |      .1121   .0083942    13.35   0.000     .0956375    .1285624
------------------------------------------------------------------------------

. 
```

In Stata, tying `regress y a##b` is a shortcut to including interactions between variables. Internally, Stata generates `a` times `b` and then regresses `y` on `a`, `b`, and `a` times `b`. So the difference-in-difference coefficient is `After ETS # ETS region`. We see that the coefficient is about 0.06. Since our dependent variable is the natural logarithm of the number of patents, we can interpret this as indicating that ETS increases the number of patents for low-carbon products by about 6%. This value is statistically significant at the 5% level, but not at the 10% level. 

Another component of the code that may stand out is the `cluster(id)` option. When we use OLS, one of the assumptions is that each observation is independent of every other observation. But in this case, we are measuring the same firms multiple times. We can imagine that firms that are innovative tend to have higher than average innovation every year, so they are not statistically independent. The `cluster(id)` option instructs Stata to calculate standard errors that are robust to this serial correlation. 

We can imagine that firms with higher assets and revenue may file more patents because they have more resources to devote to research and development. Let's try adding these as control variables. 


__Task 3:__ Regress `logenvrAEW` on `post`, `region`, and an interaction between `post` and `region`. Control for `t_Revenue` and `t_Assets`.

__Execution 3:__ 

```

. regress logenvrAEW post##region t_Assets t_Revenue, cluster(id)

Linear regression                               Number of obs     =     18,795
                                                F(5, 1842)        =     138.26
                                                Prob > F          =     0.0000
                                                R-squared         =     0.2004
                                                Root MSE          =     .63907

                                          (Std. Err. adjusted for 1,843 clusters in id)
---------------------------------------------------------------------------------------
                      |               Robust
           logenvrAEW |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
----------------------+----------------------------------------------------------------
                 post |
           After ETS  |   .1631673   .0148724    10.97   0.000     .1339988    .1923359
                      |
               region |
          ETS region  |   .0716401   .0225464     3.18   0.002     .0274208    .1158593
                      |
          post#region |
After ETS#ETS region  |   .0748521   .0324436     2.31   0.021     .0112221    .1384821
                      |
             t_Assets |   .1744742   .0166879    10.46   0.000      .141745    .2072033
            t_Revenue |   .0297928   .0130779     2.28   0.023     .0041438    .0554418
                _cons |  -4.165994   .2594659   -16.06   0.000    -4.674872   -3.657116
---------------------------------------------------------------------------------------


```

With the addition of the control variables, the difference-in-differences estimate is similar, but the standard errors declined because assets and revenue reduced the amount of noise. Now our estimate of the treatment is significant at the 5% level, suggesting that the implementation of ETS increased the number of environmentally-oriented patents.

But perhaps innovation in environmentally-friendly products came at the expense of other forms of innovation. Rerun the model in *Task 3*, but use `logNon_envrAEW` as the dependent variable. 

__Task 4:__ Calculate the difference-in-difference estimate of ETS on `logNon_envrAEW`.

__Execution 4:__ 

```
. regress logNon_envrAEW post##region t_Assets t_Revenue, cluster(id)

Linear regression                               Number of obs     =     18,795
                                                F(5, 1842)        =     615.47
                                                Prob > F          =     0.0000
                                                R-squared         =     0.3300
                                                Root MSE          =     1.3587

                                          (Std. Err. adjusted for 1,843 clusters in id)
---------------------------------------------------------------------------------------
                      |               Robust
       logNon_envrAEW |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
----------------------+----------------------------------------------------------------
                 post |
           After ETS  |   .8446065   .0322886    26.16   0.000     .7812804    .9079325
                      |
               region |
          ETS region  |   .2673184   .0615778     4.34   0.000     .1465487    .3880881
                      |
          post#region |
After ETS#ETS region  |  -.0041906   .0597581    -0.07   0.944    -.1213914    .1130102
                      |
             t_Assets |    .379764   .0393068     9.66   0.000     .3026734    .4568545
            t_Revenue |    .166582   .0341808     4.87   0.000     .0995448    .2336192
                _cons |  -10.59577   .4495054   -23.57   0.000    -11.47736   -9.714175
---------------------------------------------------------------------------------------

```

The coefficient on the interaction term is slightly negative, but very close to zero and not statistically significant. Hence, there does not appear to be evidence of a crowd-out of other forms of non-environmental innovation. 

But what if you are not convinced that the parallel trends assumption is valid? Since there's a third source of difference -- industry -- that we have not yet made use of, we can instead try a triple-difference specification. 

First, calculate the triple difference estimate of the effect of ETS on patents for low-carbon technology. Continue controlling for assets and revenue. 

__Task 5:__ Calculate the triple difference estimate of the effect of ETS on `logenvrAEW`. 

__Execution 5:__ 

```

. label define Ind 0 "Unaffected industry" 1 "Affected industry"

. label val Ind Ind 

. 
. regress logenvrAEW post##region##Ind t_Assets t_Revenue, cluster(id)

Linear regression                               Number of obs     =     18,795
                                                F(9, 1842)        =      78.34
                                                Prob > F          =     0.0000
                                                R-squared         =     0.2091
                                                Root MSE          =     .63567

                                          (Std. Err. adjusted for 1,843 clusters in id)
---------------------------------------------------------------------------------------
                      |               Robust
           logenvrAEW |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
----------------------+----------------------------------------------------------------
                 post |
           After ETS  |   .1736874   .0190061     9.14   0.000     .1364117    .2109632
                      |
               region |
          ETS region  |   .0657795   .0268483     2.45   0.014     .0131231    .1184359
                      |
          post#region |
After ETS#ETS region  |   .0359873   .0371004     0.97   0.332     -.036776    .1087506
                      |
                  Ind |
   Affected industry  |  -.1191976   .0190315    -6.26   0.000    -.1565233    -.081872
                      |
             post#Ind |
           After ETS #|
   Affected industry  |  -.0602914   .0279687    -2.16   0.031    -.1151451   -.0054376
                      |
           region#Ind |
          ETS region #|
   Affected industry  |  -.0284517   .0508447    -0.56   0.576    -.1281711    .0712676
                      |
      post#region#Ind |
           After ETS #|
          ETS region #|
   Affected industry  |   .1351495   .0765237     1.77   0.078    -.0149329    .2852319
                      |
             t_Assets |   .1810742   .0165937    10.91   0.000     .1485297    .2136186
            t_Revenue |    .032217   .0129918     2.48   0.013     .0067368    .0576972
                _cons |  -4.308179   .2627628   -16.40   0.000    -4.823523   -3.792835
---------------------------------------------------------------------------------------

```

The triple-difference coefficient that we are interested in is given by `After ETS#ETS region#Ind`. The coefficient is still positive, and now larger, but it is no longer significant at a 5% significance level.  This is not necessarily surprising, as we know power falls when we introduce more differences.

Finally, let's test for innovation crowd-out using a triple difference model. 

__Task 6:__ Calculate the triple difference estimate of the effect of ETS on `logNon_envrAEW`.


__Execution 6:__

```
. regress logNon_envrAEW post##region##Ind t_Assets t_Revenue, cluster(id)

Linear regression                               Number of obs     =     18,795
                                                F(9, 1842)        =     363.16
                                                Prob > F          =     0.0000
                                                R-squared         =     0.3692
                                                Root MSE          =     1.3185

                                          (Std. Err. adjusted for 1,843 clusters in id)
---------------------------------------------------------------------------------------
                      |               Robust
       logNon_envrAEW |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
----------------------+----------------------------------------------------------------
                 post |
           After ETS  |   .8778651   .0406239    21.61   0.000     .7981914    .9575387
                      |
               region |
          ETS region  |   .2648282   .0695821     3.81   0.000     .1283602    .4012963
                      |
          post#region |
After ETS#ETS region  |  -.0909174   .0710117    -1.28   0.201    -.2301893    .0483545
                      |
                  Ind |
   Affected industry  |  -.5608919   .0547892   -10.24   0.000    -.6683473   -.4534366
                      |
             post#Ind |
           After ETS #|
   Affected industry  |  -.2443168   .0575102    -4.25   0.000    -.3571089   -.1315247
                      |
           region#Ind |
          ETS region #|
   Affected industry  |  -.2242338   .1313463    -1.71   0.088    -.4818371    .0333694
                      |
      post#region#Ind |
           After ETS #|
          ETS region #|
   Affected industry  |   .2713291   .1343072     2.02   0.044     .0079187    .5347395
                      |
             t_Assets |   .4145887   .0356275    11.64   0.000     .3447142    .4844633
            t_Revenue |   .1777079   .0318977     5.57   0.000     .1151484    .2402674
                _cons |   -11.3382   .4241564   -26.73   0.000    -12.17008   -10.50632
---------------------------------------------------------------------------------------


```

Based on these results, ETS increased non-low-carbon patents. So there does not appear to be evidence of crowd-out of other forms of innovation. In short, the results indicate that China's cap and trade program increased innovation. 

