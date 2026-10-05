# Phase 2AL: locked 2025 final evaluation results

## Result

**Primary surface Elo has lower locked-test loss than both factor candidates.** In both tours and on both log loss and Brier score, full S08 (M03/M05/M11/M12) and reduced M03/M11/M12 lose to the frozen primary surface Elo (0.5G+0.5S). Every whole-batch deletion keeps the same direction. Calibration does not separate the methods: neither candidate meets the descriptive calibration rule.

| Candidate | Loss label | Calibration label |
| --- | --- | --- |
| Full S08 | **SURFACE_ELO_HAS_LOWER_LOCKED_TEST_LOSS_THAN_CANDIDATE** | **CALIBRATION_COMPARISON_UNRESOLVED** |
| Reduced M03/M11/M12 | **SURFACE_ELO_HAS_LOWER_LOCKED_TEST_LOSS_THAN_CANDIDATE** | **CALIBRATION_COMPARISON_UNRESOLVED** |

This is release **2AL-1.0.0**, a **2025 locked source-label final-test sensitivity**. It was run once, from clean `cac6ff7`, under the unchanged [locked protocol](2025-locked-final-test-protocol.md), using the [Phase 2AK features and Elo probabilities](2025-feature-elo-construction-audit.md). The labels describe this cohort and split only. They do not select a model and do not qualify Four Factors. No rule, threshold, eligibility, feature or method changed after results appeared.

## Frozen code and inputs

The [runner](../R/run_2025_locked_evaluation.R) imports the frozen Phase 2AF walk, scoring, summaries and deletions, along with the Phase 2R/2W fitting, loss and calibration numerics, through pinned allowlists. Training for each 2025 batch uses all original complete development vectors (ATP 612 / WTA 1,414), all complete 2024 vectors (871 / 912) and complete 2025 vectors from strictly earlier whole batches only.

The runner and test fingerprints were recorded before any 2025 outcome was read:

| File | SHA-256 |
| --- | --- |
| `R/run_2025_locked_evaluation.R` | `7feaf8fc0ab9ec67e10fe7434198c8cb453f12696d312ecf1c7772254cab6a11` |
| `R/test_2025_locked_evaluation.R` | `ff7a03e072554f3f52040bb431a3fdcbcd28403a03e8562cfeaaa08c723b59bd` |

All 19 Phase 2AL pins and the 40 inherited Phase 2AF pins passed. They cover the protocol, the Phase 2AK audit, the frozen code and every 2025 input. Each pin equals the hash recorded in the protocol, the Phase 2AK audit table or the Phase 2AK builder. The development, 2024 and 2025 rating ledgers form one unbroken chain from 1,500, with residual 0. Terminal pre-2025 states match Phase 2AK (ATP 248 overall / 552 surface; WTA 298 / 695). Every 2025 pre-batch rating and probability reproduces from that chain within 5.23e-12, below the inherited 1e-10 tolerance.

## Coverage and folds

All 1,878 admitted targets remain in coverage. All 18 required batches (ATP 10, WTA 8) passed every gate for both models. No fold failed, so every complete target was predicted, and the shared four-method mask equals the complete full-S08 targets.

| Tour | Targets | Common mask | Not predicted by either candidate | Reasons |
| --- | ---: | ---: | ---: | --- |
| ATP | 1,011 | 951 | 60 (ONE_COMPLETE) | 59 empty slot histories; 1 M12 zero pooled denominator |
| WTA | 867 | 826 | 41 (39 ONE_COMPLETE, 2 NEITHER_COMPLETE) | Empty slot histories |

Both Elo methods predict all 1,878 targets but are scored only on the common mask. All twenty expected cells stay in the inventory. **WTA Canada and Cincinnati are wholly blocked**: zero targets and 95 excluded source records each. The WTA result covers eight of ten event families, so no full-panel WTA claim follows. Per-cell, batch, event, surface and stratum counts and reasons are in `paired-scores.csv`.

Fold diagnostics stayed far from every failure threshold: maximum absolute centered correlation 0.188, maximum VIF 1.053, maximum condition index 1.274, no correlation review flag and no registered separation indication. Training sizes ran from 1,483 to 2,323 ATP and 2,326 to 3,037 WTA matches.

## Scores on the common mask

Equal-match-weight means; lower log loss and Brier are better. Accuracy is secondary (threshold 0.5, half credit for ties).

| Tour | Method | Log loss | Brier | Accuracy |
| --- | --- | ---: | ---: | ---: |
| ATP (951) | Full S08 | 0.63275 | 0.22029 | 0.6467 |
| | Reduced | 0.63229 | 0.22007 | 0.6477 |
| | Primary surface Elo | 0.61025 | 0.21162 | 0.6730 |
| | Overall-only Elo (sensitivity) | 0.60591 | 0.20996 | 0.6698 |
| WTA (826) | Full S08 | 0.61570 | 0.21273 | 0.6913 |
| | Reduced | 0.61739 | 0.21353 | 0.6913 |
| | Primary surface Elo | 0.59502 | 0.20490 | 0.6804 |
| | Overall-only Elo (sensitivity) | 0.59194 | 0.20352 | 0.6804 |

Paired differences (candidate minus comparator; positive means the candidate's loss is higher):

| Tour | Comparison | Log loss | Brier | Batch-deletion range, log loss | Batch-deletion range, Brier |
| --- | --- | ---: | ---: | --- | --- |
| ATP | Full − primary | 0.022508 | 0.008669 | 0.017424 to 0.030101 | 0.006774 to 0.011743 |
| ATP | Reduced − primary | 0.022044 | 0.008453 | 0.017015 to 0.029767 | 0.006564 to 0.011588 |
| WTA | Full − primary | 0.020679 | 0.007832 | 0.017900 to 0.022895 | 0.006852 to 0.008737 |
| WTA | Reduced − primary | 0.022369 | 0.008629 | 0.019710 to 0.024640 | 0.007733 to 0.009541 |

There are no deletion ties, reversals or unevaluable deletions. Player deletions (374 ATP and 340 WTA rows per comparison and metric) also produce no reversals. Candidate-minus-primary log loss stays between 0.0145 and 0.0251 across every single-player deletion. Within individual batches, the full model has lower log loss than primary Elo in 2 of 18 batches and reduced in 1 of 18. Those within-batch results are descriptive and do not enter the labels.

Descriptive sensitivities: candidate minus overall-only Elo is positive in every tour and metric (full 0.026845 / 0.010325 ATP and 0.023763 / 0.009215 WTA; reduced 0.026381 / 0.010108 ATP and 0.025453 / 0.010011 WTA). Reduced minus full is −0.000464 / −0.000217 ATP and +0.001690 / +0.000797 WTA (log loss / Brier). That reduced-minus-full contrast is mixed across tours and is not a selection contest. Candidate accuracy is higher than primary Elo on WTA (0.6913 vs 0.6804) and lower on ATP. Accuracy is secondary and cannot change a loss or calibration label.

## Calibration

All eight tour-level fits pass the frozen support gates (951 or 826 pairs, at least 8 batches, no boundary probability). Here `a=|intercept|` and `s=|slope−1|`, so smaller is closer to perfect calibration.

| Tour | Method | Intercept | Slope | a | s |
| --- | --- | ---: | ---: | ---: | ---: |
| ATP | Full | −0.1555 | 1.1791 | 0.1555 | 0.1791 |
| ATP | Reduced | −0.1543 | 1.1946 | 0.1543 | 0.1946 |
| ATP | Primary Elo | −0.1083 | 1.3214 | 0.1083 | 0.3214 |
| WTA | Full | −0.2608 | 1.5798 | 0.2608 | 0.5798 |
| WTA | Reduced | −0.2505 | 1.5676 | 0.2505 | 0.5676 |
| WTA | Primary Elo | −0.2172 | 1.3037 | 0.2172 | 0.3037 |

For both candidates the ATP comparison is a tradeoff: slope closer to one, intercept farther from zero. On WTA, Elo is closer on both measures. Both results give CALIBRATION_COMPARISON_UNRESOLVED. All slopes exceed one, which means every method's forecasts were less extreme than the 2025 outcomes supported. This is descriptive; no method was recalibrated. Overall-only Elo calibration (ATP −0.0980 / 1.0797; WTA −0.2263 / 1.0569) is a sensitivity and is not part of either label.

## M05 fold signs

All required full-model M05 coefficients are negative: ATP 10 of 10 and WTA 8 of 8, with no missing fits. This is replication evidence only. Phase 2AF recorded 5 negative / 5 positive ATP and 9 negative / 1 positive WTA folds. **M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED stays binding.** Negative conditional coefficients are forecast parameters, not importance weights. They do not show that double faults cause losses.

## Required disclosures

- The labels hold only for this 2025 locked source-label final-test sensitivity: 1,878 admitted records, ATP ten cells, WTA eight cells. NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE applies, official recall is UNKNOWN, 2022 is missing and history depths are unequal.
- **UNCERTAINTY_NOT_ESTABLISHED.** Deletion ranges are influence checks, not intervals. No p-value, bootstrap, interval or statistical-superiority claim is made.
- SELECTION_UNRESOLVED, S02 paused, S08 provisional and reduced-as-three-factor-comparator are unchanged. Neither label selects a model. **No final Four Factors qualification follows.**
- Overall-only Elo stays a descriptive sensitivity. It cannot replace the primary comparison.
- No coding defect was found after results appeared, and there is no corrected release. Before the code freeze, one synthetic test fixture was changed: it had simulated missing M05 fits with a zero-row training set, which the runner's training-composition integrity check correctly rejected. The fixture now blanks coefficients instead. This changed no runner rule.

## Outputs and verification

Six ignored outputs were installed atomically under `data/pilot/2025-locked-evaluation/`. Match-level files stay out of Git. Calibration fits sit in `stability.csv` next to the deletions.

| Output | Rows | SHA-256 |
| --- | ---: | --- |
| fold-readiness.csv | 36 | `db1944b0d7cd56a6cae595efbd257a07340323138896fa5c8a5a95b9f14ae250` |
| target-predictions.csv | 1,878 | `5fdfd4eb8c0f234b916e88ed8c1b5cfe0a62a415b461175d1ab669101d838527` |
| model-fits.csv | 36 | `2c463ee44709a01d2da83ba0b23f2f8673fc42ee3df832ba47aab86f09134456` |
| paired-scores.csv | 3,152 | `5dea6356aed78e488228f5a03a50ecdc2f428906de37621ebb71e1d7bc38a646` |
| stability.csv | 4,486 | `23117119caa2ef2b24f35bf5d971a317c6f250fbc7be9681f95528dfc7b8c839` |
| final-conclusions.csv | 4 | `6f46d403e114fc92cd2aaed625cf521e5b5a5a40c70634fba7fb52fb57f4091e` |

Before the run, **4,440 synthetic checks** passed without reading any 2025 outcome. They cover exact training universes and cutoffs, training-only scaling, zero-intercept reconstruction, every gate in precedence order, single-fold and single-model failures, missing M05 fits, permutations, current- and later-outcome invariance, positive controls for earlier outcomes, global slot swaps, one common mask, independent stable losses, calibration support and a 243-case calibration truth table, every deletion, a 2,268-case loss-label truth table, favorable-candidate and favorable-Elo positive controls, ledger chain failure, atomic installation and a byte-identical independent rerun.

After the run, **18 installed-output checks** passed. These include an independent-process rerun on the real inputs that reproduced all six files byte for byte, and an independent recomputation of losses, paired differences and both labels. The 59 pinned inputs were unchanged afterward. No historical suite was rerun or repinned.

## Limits and one next step

The locked comparison is finished, and its result is negative for both factor candidates as forecasters: on this cohort they did not match surface Elo's predictive loss, and calibration was not descriptively better. This evaluation does not assess their descriptive or explanatory use; any such claim needs separate evidence. TODO_USER_COPY: personal interpretation of what this result means for the project. Partial WTA coverage, the source-label chronology, unequal histories and the unestablished uncertainty all bound the result. Nothing was published, and no portfolio, OTD or data-acquisition work happened.

Recommended next step, which requires separate approval: **Phase 2AM, a documentation-only flagship closeout.** It would record the locked negative forecast result, its scope and its limitations in the README and methodology, with `TODO_USER_COPY` markers wherever interpretation is needed. It would include no new analysis, no tuning, no rerun and no publication.
