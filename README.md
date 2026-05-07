# Behavioral and Cardiometabolic Risk Factor Analysis Using SAS

## Project Overview  
This project uses SAS to perform an exploratory statistical analysis of behavioral and cardiometabolic risk factors using a stratified sample of the Tecumseh epidemiological dataset (N = 900). The analysis examines relationships between smoking behavior, alcohol consumption, age, sex, and body mass index (BMI) across two time points.

The goal is to demonstrate skills in data management, statistical analysis, and interpretation commonly used in public health and healthcare analytics.

---

## Dataset  
- Source: Tecumseh epidemiological dataset (sampled using simple random sampling)  
- Sample size: N = 900  
- Key variables:
  - Demographics: age, sex  
  - Behavioral factors: smoking status, alcohol consumption  
  - Clinical measures: height, weight, BMI (time 1 and time 3)

---

## Tools & SAS Procedures Used  
- Data sampling: `PROC SURVEYSELECT`  
- Data transformation: DATA steps + `PROC FORMAT`  
- Descriptive statistics: `PROC MEANS`  
- Frequency analysis: `PROC FREQ`  
- Cross-tabulation & association testing:
  - Chi-square tests  
  - Cochran-Armitage trend test  
  - McNemar’s test (paired categorical data)  
- Group comparisons:
  - `PROC TTEST` (independent and paired samples)  
  - `PROC GLM` (ANOVA with Tukey post-hoc tests)  
- Correlation analysis: `PROC CORR`  
- Regression analysis: `PROC REG`  
- Data visualization: `PROC SGPLOT`, `PROC UNIVARIATE`  

---

## Key Findings

### Smoking Behavior
- Smoking prevalence was significantly higher among males compared to females (p < 0.0001).  
- Smoking status was significantly associated with both age group and alcohol consumption.  
- Smoking prevalence decreased significantly between time 1 and time 3 (McNemar’s test, p < 0.0001).  

---

### BMI and Demographic Factors
- No statistically significant difference in BMI between males and females (p = 0.36).  
- BMI increased significantly across age groups (ANOVA, p < 0.0001).  
- Tukey post-hoc tests identified multiple significant differences between younger and older age groups.  

---

### Alcohol Consumption and BMI
- Alcohol consumption was not a significant predictor of BMI (p = 0.27).  
- Regression model explained very little variability in BMI (R² = 0.002), suggesting weak association.  

---

### BMI Over Time
- Strong positive correlation between BMI at time 1 and time 3 (r = 0.89, p < 0.0001).  
- Paired t-test showed a statistically significant increase in BMI over time (p < 0.0001).  

---

## Key Insights
- Behavioral risk factors (smoking and alcohol use) are strongly associated with demographic characteristics such as age and sex.  
- Age is a significant predictor of BMI, while alcohol consumption alone shows minimal predictive value.  
- Smoking prevalence declined over time in the study population.  
- BMI remains highly correlated over time but shows a small overall increase.

---

## Repository Structure
```text
smoking-risk-sas-analysis/
│
├── data/
│   └── tecumseh_etoh.sas7bdat
│
├── output/
│   └── (generated RTF files go here)
│
├── sas/
│   └── final_project.sas
│
└── README.md
```

---

## 📁 Project Setup

Before running the SAS program:

1. Ensure the following folders exist in the repository:
   - `data/`
   - `output/`

2. Place the dataset file in:
  - data/tecumseh_etoh.sas7bdat

---

## How to Run the Analysis  
1. Open SAS Studio or a local SAS environment  
2. Set the correct library path in the `libname` statement  
3. Run the SAS program sequentially from top to bottom  
4. View output in the Results Viewer or exported RTF file  

---

## Author  
Hannah Baiyor  
MPH (Biostatistics), University of Nebraska Medical Center  
