/* =========================================================
   Portable SAS Project Setup
   This project uses relative paths so it can be run
   from any local copy of the GitHub repository.
   ========================================================= */

/*************************************************************************/
/*             Introduction to SAS Programming - Final Project           */
/*             Hannah Baiyor                                             */
/*             hbaiyor@unmc.edu                                          */
/*             December 18, 2024                                         */
/*************************************************************************/

libname ref "./data";

*Simple Random Sample - 900 observations, seed 9653;
*output to permanent sas dataset hbaiyor.sas7bdat;
proc surveyselect data=ref.tecumseh_etoh out=ref.hbaiyor method=srs sampsize=900 seed=9653 rep=1;
run;

*create formats for categorical variables;
proc format;
    value sexfmt 1='Male'
                 2='Female';
    value examstatfmt 1='CV I, II and III'
                   2='CV I and II'
                   4='CV I and III'
                   5='CV I only';
    value cigsmoke1fmt 0='Never Smoked'
                       1='Current Smoker'
                       2='Ex Smoker';
    value cigday3fmt 0='None'
                     1='Less than 1 cigarette per day'
                     2='1-9 cigarettes per day'
                     3='10-19 cigarettes per day'
                     4='1 pack a day'
                     5='21-29 cigarettes per day'
                     6='30-39 cigarettes per day'
                     7='40-59 cigarettes per day'
                     8='60+ cigarettes per day'
                     9='Smokes, amount not ascertained';
    value smoke1fmt 1='Current cigarette smoker at time 1'
                    2='Not a current cigarette smoker at time 1';
    value smoke3fmt 1='Current cigarette smoker at time 3'
                    2='Not a current cigarette smoker at time 3';
    value alc_weekfmt 1='Less than one ounce per week'
                      2='From 1 to less than 3 ounces per week'
                      3='From 3 to less than 7 ounces per week'
                      4='7 or more ounces per week';
    value agegrpfmt 1='20-29 years old'
                      2='30-39 years old'
                      3='40-49 years old'
                      4='50-59 years old'
                      5='60-69 years old';

data tecumseh; *create temporary sas dataset work.tecumseh for analysis;
    set ref.hbaiyor;
    
    *create new categorical variable smoke1 based off values of cigsmoke1;
    if cigsmoke1=0 then smoke1=2;
    if cigsmoke1=2 then smoke1=2;
    if cigsmoke1=1 then smoke1=1;
    if cigsmoke1 not in (0, 1, 2) then smoke1=.;
    
    *create new categorical variable smoke3 based off values of cigday3;
    if cigday3=0 then smoke3=2;
    if cigday3 in (1,2,3,4,5,6,7,8,9) then smoke3=1;
    if cigday3 not in (0,1,2,3,4,5,6,7,8,9) then smoke3=.;
    
    *create new categorical variable alc_week based off values of ozetoh;
    if 0<=ozetoh<1 then alc_week=1;
    if 1<=ozetoh<3 then alc_week=2;
    if 3<=ozetoh<7 then alc_week=3;
    else if 7<=ozetoh then alc_week=4;
    
    *create new categorical variable agegrp based off values of age1;
    if 20<=age1<=29 then agegrp=1;
    if 30<=age1<=39 then agegrp=2;
    if 40<=age1<=49 then agegrp=3;
    if 50<=age1<=59 then agegrp=4;
    if 60<=age1<=69 then agegrp=5;
    
    *create new continuous variables for bmi at time 1 and 3 calculated from height and weight at time 1 and 3;
    bmi1=examwt1/((ht1/100)**2);
    bmi3=examwt3/((ht3/100)**2);
    
    *create descriptive labels for all variables;
    label
    id='Case Number'
    sex='Sex'
    age1='Age at CV I'
    examstat='Exam Status I, II, III'
    cigsmoke1='Cigarette Smoking CV I'
    ozetoh='Ounces Ethanol per Week CV I'
    examwt1='Weight(kg) CV I'
    ht1='Height(cm) CV I'
    cigday3='Cigarettes per day CV III'
    examwt3='Weight(kg) CV III'
    ht3='Height(cm) CV III'
    smoke1='Smoking Status CV I'
    smoke3='Smoking Status CV III'
    alc_week='Alcohol Consumption CV I'
    agegrp='Age Group'
    bmi1='BMI(kg/m^2) CV I'
    bmi3='BMI(kg/m^2) CV III';
    
    *apply user defined formats;
    format sex sexfmt. examstat examstatfmt. cigsmoke1 cigsmoke1fmt. cigday3 cigday3fmt. smoke1 smoke1fmt. smoke3 smoke3fmt. alc_week alc_weekfmt. agegrp agegrpfmt.;
run;

*check new categorical variables - verify n and nmiss match between original and recoded variables and that min and max values make sense;
proc means data=tecumseh n nmiss min max;
var cigsmoke1 smoke1 cigday3 smoke3 ozetoh alc_week age1 agegrp;
run;

*check new calculated variables bmi1 and bmi3 - verify n, nmiss, min and max for new variables make sense;
proc means data=tecumseh n nmiss min max;
var ht1 examwt1 bmi1 ht3 examwt3 bmi3;
run;

*check how many records were missing both height and weight at time 1;
proc means data=tecumseh n nmiss;
where ht1=. and examwt1=.;
var ht1 examwt1 bmi1;
run;

*check how many records were missing either height or weight at time 1;
proc means data=tecumseh n nmiss;
where (ht1=. and examwt1 ne .) or (ht1 ne . and examwt1=.);
var ht1 examwt1 bmi1;
run;

*check how many records were missing height and weight at time 3;
proc means data=tecumseh n nmiss;
var ht3 examwt3 bmi3;
where ht3=. and examwt3=.;
run;

*check how many records were missing height or weight at time 3;
proc means data=tecumseh n nmiss; 
var ht3 examwt3 bmi3;
where (ht3=. and examwt3 ne .) or (ht3 ne . and examwt3=.);
run;

*output results to ODS RTF file;
ods rtf file="./output/hbaiyorprojectoutput.rtf" style=barrettsblue;

proc contents data=tecumseh; run; *proc contents of data set with newly created variables;

*descriptive statistics for continuous variables;
proc means data=tecumseh n nmiss min max mean maxdec=2;
    var age1 ozetoh examwt1 ht1 examwt3 ht3 bmi1 bmi3;
    title 'Simple Descriptive Statistics for Continuous Variables';
run;

*frequencies for sex, cigsmoke1, and cigday3;
proc freq data=tecumseh;
    tables sex cigsmoke1 cigday3;
    title 'Frequencies - Sex, Cigsmoke1, Cigday3';
run;

*frequencies for smoke1, smoke3, agegrp, and alc_week;
proc freq data=tecumseh;
    tables smoke1 smoke3 agegrp alc_week;
    title 'Frequencies - Smoke1, Smoke3, Agegrp, Alc_week';
run;

*proc tabulate - age1, ozetoh and bmi1 by gender;
proc tabulate data=tecumseh;
    class sex; *categorical variable - sex;
    var age1 ozetoh bmi1; *continuous variables - age1, ozetoh and bmi1;
    table sex ALL, (age1 ozetoh bmi1)*(n mean std); *rows will be gender (including summary row), columns will be age1, ozetoh and bmi1 with n, mean and std for each;
    title 'Descriptive Statistics - Age1, Ozetoh, BMI1 by Gender';
run;

*create a macro for creating cross-tabs;
%macro frequency (dataset, var1, var2, options, title);
    proc freq data=&dataset;
        tables &var1*&var2 / &options;
        title &title;
    run;
%mend frequency;

*cross-tab sex and smoke1 - include chi-square test and relative risk;
%frequency (tecumseh, sex, smoke1, nocol nopct chisq expected relrisk, "Cross-tab: Sex vs. Smoke1");
*cross-tab agegrp and smoke1 - include chi-square test;
%frequency (tecumseh, agegrp, smoke1, nocol nopct chisq expected, "Cross-tab: Age Group vs. Smoke1");
*cross-tab alc_week and smoke1 - include chi-square test and Chochran Armitage test for trend;
%frequency (tecumseh, alc_week, smoke1, nocol nopct chisq trend expected, "Cross-tab: Alcohol per week vs. Smoke1");
*cross-tab smoke1 and smoke3 - include McNemar's test;
%frequency (tecumseh, smoke1, smoke3, norow nocol agree expected, 'Cross-tab: Smoke1 vs. Smoke3');

*box plot of BMI by sex;
proc sgplot data=tecumseh;
    vbox bmi1 / category=sex;
    title 'Box Plot: BMI1 by Sex';
run;

*sort data by sex to utilize proc univariate;
proc sort data=tecumseh out=tecumseh_sexsort;
    by sex;
run;

*proc univariate to assess assumption of normality;
proc univariate data=tecumseh_sexsort normal;
    var bmi1;
    by sex;
    histogram / normal (mu=est sigma=est);
    qqplot /normal (mu=est sigma=est);
run;

*independent samples t-test to compare mean BMI at time 1 by gender;
proc ttest data=tecumseh;
    class sex;
    var bmi1;
    title 'Independent Samples T-Test: BMI 1 by Gender';
run;

*box plot of BMI by smoke1;
proc sgplot data=tecumseh;
    vbox bmi1 / category=smoke1;
    title 'Box Plot: BMI1 by Smoke1';
run;

*independent samples t-test to compare mean BMI at time 1 by smoking status at time 1;
proc ttest data=tecumseh;
    class smoke1;
    var bmi1;
    title 'Independent Samples T-Test: BMI 1 by Smoke1';
run;

*box plot of BMI at time 1 by age group;
proc sgplot data=tecumseh;
    vbox bmi1 / category=agegrp;
    title 'Box Plot: BMI1 by Age Group';
run;

*descriptive statistics for BMI1 for each level of agegrp;
proc means data=tecumseh n mean min max std;
    var bmi1;
    class agegrp;
    title 'Descriptive Statistics: BMI1 by Age Group';
run;

*ANOVA test with Tukey's method for multiple comparisons;
proc glm data=tecumseh plots=diagnostics; *plots=diagnostics option to produce diagnostic plots to evaluate assumptions;
    class agegrp;
    model bmi1=agegrp;
    means agegrp / tukey;
    title 'ANOVA with Multiple Comparisons (Tukey): BMI1 by Age Group';
run;

*linear regression model of BMI1 as a function of ETOH;
proc reg data=tecumseh;
    model bmi1=ozetoh;
    title 'Regression Analysis: Ozetoh predicting BMI1';
run;

*pearson correlation for paired data comparing BMI1 and BMI3;
proc corr data=tecumseh nomiss pearson;
    var bmi1;
    with bmi3;
    title 'Correlation Matrix: BMI1 with BMI3';
run;

*scatter plot of BMI1 with BMI3;
proc sgplot data=tecumseh;
    reg x=bmi1 y=bmi3; *include regression line on scatter plot;
    title 'Scatter Plot BMI1 with BMI3';
run;

*paired samples t-test to compare bmi at time 1 vs. time 3;
proc ttest data=tecumseh;
    paired bmi1*bmi3;
    title 'Paired T-Test: BMI1 vs. BMI3';
run;
    
ods rtf close;
    





