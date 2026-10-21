# ELSA longitudinal modelling — independent audit

[← ELSA case study](../projects/elsa-loneliness/README.md) · [R reproduction script](../scripts/elsa_reproduce.R) · [Quantitative portfolio](../README.md)

**Scope:** Submitted SOST70022 final assignment, its R appendix, and the user's supplied five ELSA wave files. The subsequent check was implemented in Python, *not* yet run end-to-end in R. This document is a re-analysis, not a claim that these checks were performed during the original assessment.

## Sample count discrepancies

| Wave | Raw rows | Rows retained under submitted rules | N printed in submitted Table 1 |
| --- | ---: | ---: | ---: |
| 7 | 9,666 | 7,526 | 7,346 |
| 8 | 8,445 | 6,622 | 6,265 |
| 9 | 8,736 | 6,894 | 5,643 |
| 10 | 7,589 | 6,070 | 3,921 |
| 11 | 7,842 | 6,350 | 3,542 |
| **Total** | **42,278** | **33,462** | **26,717** |

Distinct persons under the re-applied complete-case rules: **12,500**, not the **8,259** stated in the submitted narrative. The original flowchart and tables used hard-coded values and need regeneration from one locked sample.

## Mixed-model comparison (independent Python ML audit)

| Quantity | Submitted paper | Re-analysed submitted coding | Marital-status categorical correction |
| --- | ---: | ---: | ---: |
| M0 intercept | 4.120 | 4.171 | — |
| M1 wave slope | 0.069 | 0.0621 | — |
| M2 participation coefficient | −0.060 | −0.0571 | −0.0576 |
| M3 participation × wave | −0.003 (p=0.363 reported) | −0.00194 (Wald p≈0.539) | −0.00215 (Wald p≈0.496) |

The M2-versus-M3 likelihood-ratio test in the independent original-coding audit was approximately p=0.537. These checks suggest the interaction remains nonsignificant in the tested specifications, but **other unresolved coding issues could change the results**.

## Model integrity issues and next steps

1. **Marital status:** three nominal categories must be treated as a factor rather than a numeric linear score.
2. **Age 90+ disclosure:** `indager=-7` is not equivalent to ordinary missingness; verify ELSA documentation and implement a principled sensitivity approach.
3. **CES-D:** original code added four items without checking positive/negative direction; especially recheck `PScedD` (happiness), and avoid treating this as a validated full eight-item CES-D.
4. **Participation measure:** the Wave 7 `scorg09` category represents no organisation, and should not be added as a ninth participating organisation.
5. **Time:** `wave - 7` imposes equal wave steps despite disruption around COVID.
6. **Interpretation:** a time-varying participation coefficient is not automatically a pure *baseline* or between-person effect; consider a within/between decomposition.
7. **Inference:** a joint comparison that adds both a fixed time slope and a random slope cannot on its own establish a random-slope variance p-value.
8. **Reproducibility:** execute the accompanying R script in R, confirm all outputs and update the README with any divergences. No protected ELSA microdata should be committed.

The student selected Waves 7–11 and persisted with debugging of erroneously duplicated wave imports. The model-building sequence was course-guided and involved AI assistance.