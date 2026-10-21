# From Model Specification to Interpretation

**ESS9 · Introduction to Statistical Modelling (SOST70011)**

[← Full case study](README.md) · [← Quantitative portfolio](../../README.md)

This page traces **two models reported in my submitted MSc coursework** from the research question to their interpretation. Figures are copied from the submitted results, rather than presented as a new computational replication.

## Part 1 · Binary logistic regression: income and crime victimisation

### 01 · Research question and outcome

**Question:** Is household income associated with reporting crime victimisation in the Great Britain sample?

- **Outcome:** `crime_victim` (1 = victim, 0 = non-victim).
- **Main predictor:** `hinctnta`, household income decile (1–10).
- **Covariates:** `agea` (age), `gndr` (gender), `disability` (activity-limiting disability), and `aesfdrk_num` (perceived safety walking alone after dark).

### 02 · Model specification

```r
glm(
  crime_victim ~ hinctnta + agea + gndr +
    disability + aesfdrk_num,
  family = binomial(link = "logit"),
  data = uk
)
```

**Why this model?** The dependent variable is binary. A binomial GLM with a logit link estimates **log-odds**; exponentiating a one-unit coefficient gives an **odds ratio (OR)**.

`family = binomial` uses the logit link by default in R. The code above is a readable representation of the submitted model formula, not a newly verified run.

### 03 · Reported result

| Predictor | OR | 95% confidence interval |
| --- | ---: | --- |
| Household income | **0.99** | **0.95–1.04** |
| Age | 0.97 | 0.96–0.98 |
| Female vs male | 0.90 | 0.69–1.18 |
| Disability-related limitations | 1.47 | 1.10–1.98 |
| Perceived lack of safety after dark | 1.46 | 1.25–1.70 |

### 04 · Interpretation

For each one-decile increase in household income, the model estimated an OR of **0.99** for reporting crime victimisation, holding the included covariates constant. This corresponds to estimated **odds approximately 1% lower**, **not** a one-percentage-point change in probability.

The 95% confidence interval **includes 1**, so the submitted analysis did not find a statistically clear adjusted association between income and victimisation. This does **not** prove that income has no relationship with the outcome.

---

## Part 2 · Multilevel linear model: income and internet use

### 01 · Research question and outcome

**Question:** How is household income associated with typical daily internet-use time across countries?

- **Outcome:** `netustm`, reported minutes of internet use per day.
- **Main predictor:** `hinctnta`, household income decile.
- **Covariates:** `agea`, `gndr`, `eisced` (education category).
- **Data structure:** individuals grouped within **29 countries**; **27,872** observations reported in the submission.

### 02 · Model specification

```r
lmer(
  netustm ~ hinctnta + agea + gndr +
    eisced + (1 | cntry),
  data = analysis_data
)
```

**Why this model?** The outcome is measured in minutes, and respondents are clustered within countries. The random-intercept term `(1 | cntry)` lets the **baseline predicted internet-use level vary by country**, while the displayed specification estimates a **common income slope** across countries.

The formula summarises the model reported in the submitted assignment; `analysis_data` is a descriptive placeholder, **not** a provided dataset object or executable reproduction script.

### 03 · Reported result

| Predictor | Estimated coefficient | Reported p-value |
| --- | ---: | --- |
| Household income (per decile) | **+1.97 min/day** | **<0.001** |
| Age (per year) | −3.39 min/day | <0.001 |
| Female vs male | −12.66 min/day | <0.001 |
| Education category (per unit) | +14.21 min/day | <0.001 |

Country-level intercept variance: **1,115**; residual variance: **25,535**, as reported in the submission.

### 04 · Interpretation

Holding the other included predictors constant, a one-decile higher household income was associated with approximately **1.97 additional reported minutes of daily internet use** in the fitted model. Country-specific intercepts allow average levels to differ across countries without assuming that the income association differs by country.

---

## What these two models demonstrate

| Decision | Part 1 | Part 2 |
| --- | --- | --- |
| **Outcome type** | Binary (yes/no) | Continuous (minutes/day) |
| **Modelling framework** | Binomial GLM / logistic regression | Linear mixed-effects model |
| **Key R syntax** | `glm(..., family = binomial)` | `lmer(... + (1 | cntry))` |
| **Interpretation scale** | Odds ratios | Minutes/day coefficients |
| **Core consideration** | OR is not a probability ratio | Random intercepts allow national baselines to differ |

**Scope of interpretation:** Both analyses use secondary survey data and describe *associations*, not experimentally identified causal effects. Available survey measures may not capture every aspect of the intended concepts.

**Source and verification:** Based on the submitted *SOST70011 Assessment 3*, including its R appendix. No independent ESS9 model rerun or numerical verification is claimed in this portfolio.

[← Full ESS9 case study](README.md)
