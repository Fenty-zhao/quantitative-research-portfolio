# Income, Crime Victimisation and Internet Use: Two ESS9 Modelling Studies

**Introduction to Statistical Modelling · University of Manchester MSc coursework**

[Portfolio home](../../README.md) · [Part 1: Logistic regression](#part-1--household-income-and-crime-victimisation-in-great-britain) · [Part 2: Multilevel model](#part-2--household-income-and-internet-use-across-countries) · [Research reflection](#research-choices-and-limitations)

## Project overview

This submitted assignment applied two regression frameworks to data from **European Social Survey Round 9 (ESS9)**. It was structured as two questions with different outcomes and data structures:

| | Part 1 | Part 2 |
| --- | --- | --- |
| Question | Is household income associated with crime victimisation in Great Britain? | How is household income associated with typical daily internet use across countries? |
| Outcome | Binary self-reported crime victimisation | Reported internet-use minutes per day |
| Method | Binomial logistic regression | Two-level random-intercept linear mixed-effects regression |
| Main clustering | Individuals in the GB subset | Individuals nested within 29 countries |
| Interpretation | Odds ratios and 95% confidence intervals | Fixed effects, country-level variation and uncertainty |

These are the **results documented in the submitted paper**, not newly reproduced results. The assessment includes an R appendix; the original ESS9 assessment dataset has not been independently rerun for this portfolio.

---

## Part 1 · Household income and crime victimisation in Great Britain

### Research question and model choice

The outcome was whether respondents reported having been victims of crime. I used a **binary logistic regression** because the recoded response took two values: victim (1) or non-victim (0).

The main predictor was household income decile (`hinctnta`, 1–10). The submitted model also included age, gender, disability-related activity limitations, and perceived safety when walking alone after dark:

```r
glm(crime_victim ~ hinctnta + agea + gndr +
      disability + aesfdrk_num,
    family = binomial, data = uk)
```

### Results reported in the submitted assignment

| Predictor | Odds ratio | Reported 95% CI |
| --- | ---: | --- |
| Household income | 0.99 | 0.95–1.04 |
| Age | 0.97 | 0.96–0.98 |
| Female (vs male) | 0.90 | 0.69–1.18 |
| Disability-related activity limitations | 1.47 | 1.10–1.98 |
| Feeling unsafe after dark | 1.46 | 1.25–1.70 |

The household-income confidence interval included 1, so the submitted model did **not** find clear statistical evidence of an adjusted income association. These numbers should not be interpreted as proof that income has no effect.

### A methodological issue worth revisiting

The research question and original text framed the goal as a **total causal effect**, while the fitted model was observational and included **`aesfdrk`: perceived safety after dark**. Importantly, that item describes *how safe the respondent feels*, not observed nighttime activity or a measured exposure to crime.

Its causal role is uncertain: perceptions of safety may be influenced by victimisation itself, by neighbourhood factors, or by other experiences. Treating it as a straightforward exposure control could distort the intended total-effect interpretation.

**Portfolio learning:** before interpreting a regression as causal, map the assumed relationships between exposure, outcome and controls. A useful next step would be a revised DAG and sensitivity models with and without this covariate. Those revisions **have not been run here**.

---

## Part 2 · Household income and internet use across countries

### Why a multilevel model?

The second outcome was typical daily internet use (`netustm`, minutes). Respondents belonged to different countries, where digital infrastructure and social conditions may differ. I used a **country random-intercept model** to allow average internet-use levels to vary across national contexts, while estimating common slopes for individual-level predictors.

```r
lmer(netustm ~ hinctnta + agea + gndr +
       eisced + (1 | cntry), data = analysis_data)
```

The covariates were household income decile, age, gender and education category. The specification in the submitted report treated education as a numeric ordered measure.

### Results reported in the submitted assignment

The analysis reported **27,872 observations from 29 countries**.

| Fixed effect | Estimated coefficient | Reported p-value |
| --- | ---: | --- |
| Household income (per decile) | +1.97 minutes/day | <0.001 |
| Age (per year) | −3.39 minutes/day | <0.001 |
| Female (vs male) | −12.66 minutes/day | <0.001 |
| Education category (per unit) | +14.21 minutes/day | <0.001 |

The reported country-level random-intercept variance was **1,115**, compared with a residual variance of **25,535**. This accommodates variation in average internet use across countries; it does not identify which country-level mechanisms caused that variation.

**Interpretation:** in the reported model, higher household income was associated with somewhat greater reported daily internet use after adjustment, but ESS9 cross-sectional associations do **not** on their own identify a causal effect.

---

## Research choices and limitations

### Different outcomes require different models

Part 1 estimated a probability-related association through **odds**, whereas Part 2 modelled a continuous outcome and accommodated **country clustering**. This distinction is the central methodological contrast between the two analyses.

### Covariate choice is a causal decision, not just a coding decision

The original assignment used causal language, but neither analysis had an identification strategy sufficient to establish a total causal effect. In particular, Part 1's perceived-safety measure should not be described as actual behaviour or an unambiguous confounder.

### Check specifications against the substantive question

Part 2 assumes the same income slope across countries and a linear change across ordered income and education categories. Alternative specifications could test whether those assumptions are reasonable.

### Reproducibility status

The original assessment contains R code, but this portfolio **has not independently executed or validated** the ESS9 models, reported sample counts or confidence intervals. The results above are accurately labelled as *submitted-paper results*. A future update can add an anonymised, documented R script after checking input data permissions, recoding rules and model outputs.

---

## Skills & evidence

| Research skill | Evidence from this coursework |
| --- | --- |
| Binary-outcome modelling | Logistic model and interpretation of odds ratios and confidence intervals |
| Multilevel modelling | Country random intercept to accommodate clustered ESS9 observations |
| Statistical communication | Contrasting binary and continuous outcomes and their coefficients |
| Critical model review | Revisiting variable meaning, confounder assumptions and causal wording |
| Reproducibility planning | Separating submitted estimates from unverified re-analysis |

**Source:** Submitted *SOST70011 Introduction to Statistical Modelling, Assessment 3* (two analyses and R appendix). This page is a later portfolio presentation of that work, including retrospective methodological reflection.

[← Quantitative portfolio](../../README.md)
