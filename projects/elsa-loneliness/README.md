# Loneliness Across Five ELSA Waves

**Longitudinal Data Analysis (SOST70022) · University of Manchester · Coursework re-analysis**

## Research question

How is participation in organisations associated with loneliness among older adults in England? Does participation also relate to the rate at which loneliness changes across survey waves?

## Analytical reasoning — question first, technique second

1. **Construct a comparable longitudinal dataset.** Harmonise variables across ELSA Waves 7–11; distinguish individuals from repeated person-wave records; quantify missingness and panel imbalance.
2. **Ask whether people differ in their loneliness levels.** Start with a random-intercept null model and calculate the intraclass correlation (ICC).
3. **Ask whether loneliness changes over time, and whether trajectories differ.** Add wave and individual random slopes.
4. **Test the substantive question.** Add organisational participation and controls; then test its interaction with time.
5. **Challenge the original implementation.** Verify denominators, variable codes, random-effects interpretations, and model comparisons against actual input data.

The model sequence followed the taught course framework. The choice of recent ELSA waves and the debugging of an initially incorrect five-wave import were part of the student's active decisions. Research design and writing involved AI assistance.

## Data and measures

**ELSA Waves 7–11**, English adults aged 50 and older. Outcome: three-item UCLA loneliness score (3–9). Main predictor: count of eight types of organisational participation (0–8). Controls: age, sex, relationship status, self-rated health. Time is initially represented by survey wave number.

The dataset is an **unbalanced panel**. The re-analysis under the submitted complete-case rules yielded **33,462 person-wave records from 12,500 distinct participants**. The original submission stated 8,259 participants and included a descriptive table summing to 26,717 records. These differences are openly documented in [the audit](../../docs/elsa-audit.md) rather than treated as verified original findings.

## Findings and interpretation

An independent Python mixed-model audit found a negative association between organisational participation and loneliness (M2 coefficient approximately **−0.0571** under the submitted coding). The participation-by-time interaction was **not statistically significant** (estimate approximately **−0.00194**, Wald p ≈ 0.539). Reclassifying marital status as a nominal factor produced an interaction estimate of approximately **−0.00215** (Wald p ≈ 0.496). These do **not** establish a causal effect.

The original final paper reported somewhat different coefficients; these were **not reproduced exactly**. R code has been prepared for independent reproduction, but **was not executed in an R runtime** during the audit. See [audit notes](../../docs/elsa-audit.md) for open issues.

## Skills demonstrated

- Cross-wave variable harmonisation and longitudinal data structure
- Mixed-effects random intercept / random slope growth modelling
- ICC and nested model comparisons
- Interpretation of main effects versus time interactions
- Reproducibility checks and correcting a categorical-variable specification

## Repository contents

- [R reproduction / validation script](../../scripts/elsa_reproduce.R)
- [Audit findings and remaining checks](../../docs/elsa-audit.md)
- [Portfolio index](../../README.md)

## How to reproduce

Obtain appropriately licensed ELSA Waves 7–11 `.dta` files via the [UK Data Service](https://ukdataservice.ac.uk/). Do **not** upload these files publicly. Place the five files in a local `data/` folder, using the names specified in the script, and run it from the repository root.

The script generates sample summaries and model outputs in `outputs/`. The outputs should be verified in R and compared to the independent Python audit before reporting final point estimates as R-reproduced results.

## Limitations and open checks

The submitted coding treated marital status numerically and discarded negative age disclosure codes. A CES-D sensitivity analysis was not independently verified. Wave spacing is not strictly equal because of COVID-related fieldwork disruption. Organisational-participation coefficients combine within- and between-person information unless modelled separately. These issues are addressed or flagged in the audit and should be resolved before claiming final substantive robustness.