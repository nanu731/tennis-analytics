# Phase 2R: S08 paired descriptive evaluation

**Terminal result: PAIRED_DESCRIPTIVE_EVALUATION_COMPLETE.** Version 1.0.0, implemented from clean `main` at `72780222565a6fb9e0ea04fe9b5f33955a2ea2ff`. All 2,580 targets are retained; 18 ready folds produce 1,278 paired predictions. Results are mixed across tours and sensitive to some deletions. No superiority claim, model selection or final Four Factors approval follows.

Every output carries **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**, and **UNCERTAINTY_NOT_ESTABLISHED**. These remain development sensitivities under assumed source-label availability, not verified historical or deployable forecasts.

## Prospective correction and implementation

Before reading outcome tables or fitting, the explicit Phase 2R instruction was recorded in [protocol version 1.1.0](s08-forecast-evaluation-protocol.md#phase-2r-prospective-structural-correction) and PROJECT_CONTEXT.md. Each tour's model now fixes its intercept at zero and divides dM03/dM05/dM11/dM12 by its training-fold sample SD **without mean-centering**. The rank gate is four. Since eta(-x)=-eta(x), isolated target-slot swaps complement probabilities. No alternative intercept, centering or model specification was fitted or compared.

All remaining protocol thresholds and rules were retained. Centered correlation/VIF/condition diagnostics keep their registered definitions; they do not center forecast inputs. Calibration retains its separate diagnostic intercept and slope. Coefficients are forecast parameters, not importance weights. S02 stays paused; S08 provisional.

[The runner](../R/run_s08_paired_evaluation.R) verifies 16 literal SHA-256 pins before reading any table: corrected protocol, standing instructions, relevant saved authority, frozen target/membership/features and Elo releases, and Phase 2H membership/dispositions. It joins exact IDs and neutral result ownership, checks exclusions and labels, and never invokes historical runners. The unchanged earlier authority versions remain in Git; no historical suite is repinned.

For each same-tour/source-date batch, all earlier complete rows enter one expanding training set with each row's original frozen history. Same-date events share one fit. Five contributing prior batches, 100 training rows, 25 outcomes per class, positive finite SDs, rank four, registered collinearity gates, convergence, finite coefficients and no warning/boundary/extreme/separation indication are required. Failed gates withhold predictions without rescue. Base R uses epsilon 1e-8 and maxit 25. Target outcomes cannot affect their own fit; later eligible outcomes may enter later training. Elo probabilities are read from Phase 2P, never replayed on the S08 subset.

## Readiness and coverage

| Tour | Targets | Complete vectors | Ready / total folds | Targets in ready folds | Paired predictions | No S08 prediction |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 846 | 612 | 4 / 10 | 235 | 211 | 635 |
| WTA | 1,734 | 1,414 | 14 / 20 | 1,191 | 1,067 | 667 |
| Total | 2,580 | 2,026 | 18 / 30 | 1,426 | 1,278 | 1,302 |

All 12 withheld folds lack five contributing prior batches; some also fail match/class minimums. They contain 1,154 targets: 748 complete and 406 incomplete. Another 148 incomplete targets are in ready folds. Thus 554 incomplete vectors plus 748 complete-but-not-ready targets account for all 1,302 nonpredictions, without double counting. Both/one/neither-complete strata remain 2,026/284/270; neither one-complete nor neither-complete targets receive S08 predictions. All Elo probabilities remain finite for the full cohort, but Elo losses are calculated only on the same 1,278 paired IDs as S08.

The first ready labels are ATP 20230703 (401 training matches, classes 197/204) and WTA 20210809 (347, classes 186/161). All 18 fitted designs have rank four. Maximum absolute Pearson/Spearman correlation is about 0.312832; maximum VIF 1.170878 and condition index 1.540522. No fitted fold has a convergence failure, fitting warning, boundary flag, extreme training probability or detected separation witness. Absence of a witness is not proof that separation is absent. S08 probabilities span 0.1773782–0.9298456 ATP and 0.0582029–0.8943388 WTA; none are nonfinite or exact boundaries.

| Slice | All targets | Paired predictions | Nonpredictions |
| --- | ---: | ---: | ---: |
| ATP 2023 | 846 | 211 | 635 |
| WTA 2021 | 825 | 257 | 568 |
| WTA 2023 | 909 | 810 | 99 |
| ATP Clay | 305 | 0 | 305 |
| ATP Grass | 56 | 48 | 8 |
| ATP Hard | 485 | 163 | 322 |
| WTA Clay | 530 | 275 | 255 |
| WTA Grass | 192 | 83 | 109 |
| WTA Hard | 1,012 | 709 | 303 |

Batch and event counts, zero-prediction slices, completeness strata and overlapping reason counts are fully enumerated in paired-scores.csv. Coverage means source-cohort prediction availability, never official recall. ATP has no scored clay comparison or independent season stability; no subset was chosen to improve performance.

**Coefficient-direction limitation:** M03, M11 and M12 coefficients are positive in all 18 fits. M05 is negative in all four ATP fits (-0.0332207 to -0.0068136) but positive in all fourteen WTA fits (+0.0360047 to +0.1409861). Its lower-is-better metric interpretation is unchanged. These unconstrained conditional forecast coefficients do not establish mechanism importance or justify a sign constraint, factor revision or model selection. The direction difference remains an unresolved substantive limitation.

## Identical-ID descriptive scores

Natural-log loss and Brier are primary. The table uses the same IDs for all three methods within each tour. Accuracy is secondary with half-credit for exact 0.5 ties. Lower losses are numerically smaller descriptive losses only, not evidence of established superiority.

| Tour (n) | Model | Log loss | Brier | Accuracy |
| --- | --- | ---: | ---: | ---: |
| ATP (211) | S08 | 0.6337505 | 0.2209356 | 0.6635071 |
| ATP (211) | Primary surface Elo | 0.6392438 | 0.2243585 | 0.6350711 |
| ATP (211) | Overall-only Elo | 0.6342847 | 0.2226287 | 0.6018957 |
| WTA (1,067) | S08 | 0.6346243 | 0.2210566 | 0.6626054 |
| WTA (1,067) | Primary surface Elo | 0.6306847 | 0.2201050 | 0.6513590 |
| WTA (1,067) | Overall-only Elo | 0.6190044 | 0.2150036 | 0.6513590 |

| Tour | Comparator | S08 minus Elo log loss | S08 minus Elo Brier |
| --- | --- | ---: | ---: |
| ATP | Primary surface Elo | -0.0054932645 | -0.0034228884 |
| ATP | Overall-only Elo | -0.0005341531 | -0.0016931644 |
| WTA | Primary surface Elo | +0.0039396039 | +0.0009516577 |
| WTA | Overall-only Elo | +0.0156199041 | +0.0060529830 |

Negative differences favor S08 descriptively. WTA 2021 log-loss differences are -0.0297222 / -0.0130705 against primary/overall Elo, versus +0.0146200 / +0.0247229 in 2023. This change is disclosed without selecting a favorable season. ATP grass S08-minus-overall log loss is +0.0240673 despite the slightly negative whole-tour difference. All batch/event/surface score rows remain in the ignored aggregate file. No practical-effect margin or new comparison is chosen.

## Calibration and deletion influence

Calibration support requires at least 100 paired matches, 25 outcomes per class, five scored batches, finite nonconstant logits, rank two and the unchanged fitting safeguards. ATP fails the batch gate for all three methods. WTA overall, WTA 2023 and WTA Hard pass; WTA 2021 and remaining slices do not meet all support gates. The ALL and BOTH_COMPLETE summaries refer to identical paired rows, not independent calibration estimates. No calibration is applied back to the predictions.

| WTA overall model | Calibration intercept | Calibration slope |
| --- | ---: | ---: |
| S08 | -0.001694209 | 1.182602 |
| Primary surface Elo | -0.008868553 | 1.744148 |
| Overall-only Elo | -0.008627199 | 1.416094 |

These are descriptive coefficients without confidence intervals, p-values or IID standard errors.

Deletion influence covers four ATP and fourteen WTA batches, and 120 ATP / 196 WTA players. A player deletion removes every scored match involving that ID in either slot across all batches. Frozen predictions are not refitted; training influence and histories are not removed. Each deletion retains identical comparison IDs. There are 1,336 comparator/metric deletion rows.

- Removing ATP Canada (source batch 20230807; 48 scored matches) changes S08-minus-overall log loss from -0.0005342 to +0.0129345 and Brier from -0.0016932 to +0.0043296. Removing player ID 200282 (12 matches) changes primary log loss from -0.0054933 to +0.0003853 and overall log loss to +0.0075409. Overall-Elo log-loss signs reverse in 46 ATP player deletions; primary-Elo signs reverse in one.
- WTA log-loss signs do not reverse under any single batch/player deletion. Removing the 2021 US Open batch has the largest absolute WTA batch log-loss change against primary Elo: +0.0039396 becomes +0.0084350. WTA primary-Elo Brier signs reverse for two batch deletions (20230306 and 20230828) and three player deletions (201615, 214544, 222258). Overall-Elo WTA signs do not reverse.

Ranges and sign changes are sensitivity descriptions, not uncertainty intervals or unseen-player performance. **UNCERTAINTY_NOT_ESTABLISHED** remains: whole-batch/event and recurring-player dependence have not been addressed by a justified interval method.

## Local outputs and validation

Exactly five ignored files are installed atomically in data/pilot/s08-paired-evaluation/. Match-level outcomes/probabilities are local research artifacts, not a redistribution approval.

| File | Rows | SHA-256 |
| --- | ---: | --- |
| fold-readiness.csv | 30 | b419e1883269201a70fa78bd0aa398d56b0a18456147f587780edf719f280ed9 |
| target-predictions.csv | 2,580 | d7d7b774c1ce7c4f303820208fbed196f38fe058b0d1ad763c02e0f6880ea433 |
| model-fits.csv | 762 | 46300fa049333fb36d0eec96ec6d51669f9f6e8742e36be0fe231cd94cfc9726 |
| paired-scores.csv | 4,636 | c2d419f8cfadd1a91da5bc4380b7d29d55af1fae1ea1b04f8da2846431790b4e |
| stability.csv | 1,336 | 08176292218802df34225159fabe984ac0abbbacf7909aa5b928a882570519ad |

The readiness file records exact training IDs, gates and failure precedence; target predictions preserve all targets, frozen predictors, outcomes, reasons, shared mask and per-match scores. Model fits contain forecast SDs/coefficients and supported/withheld calibration diagnostics. Paired scores contain aggregate coverage, reasons and identical-mask scores by tour, batch, season, event, surface and completeness stratum. Stability contains all deletion results. No sixth summary file exists.

[Focused tests](../R/test_s08_paired_evaluation.R) cover input pins/joins, exact accounting, labels/cutoffs, independent formula-interface fits, training-only SD scaling, zero intercept, isolated/global slot reversal, permutations and perturbations, readiness precedence, constant/rank-deficient/complete and quasi-separated fixtures, loss identities, exact paired masks, calibration support, every deletion calculation, deterministic serialization, interrupted/corrupted staging, protected existing releases, output ignores and historical preservation. Runtime: R 4.6.0 (2026-04-24), base R only. **All 232 focused checks passed**, with all 1,336 deletion rows and every aggregate score denominator additionally checked against independent calculations. Documentation agreement, 22 local links/anchors, whitespace and exact seven-file scope passed. All 288 other pre-existing tracked files and pilot artifacts retain their SHA-256 hashes; historical status/contract bodies are preserved apart from the current/completed contract label. The five installed output hashes agree with independently serialized reruns. All outputs and the full diff were inspected.

An initial input guard rejected duplicate empty IDs in the full Phase 2H disposition inventory. Direct inspection found 5,471 empty IDs, all OUTSIDE_PANEL, and zero duplicate target IDs. The guard was corrected to require uniqueness for target-linked dispositions while still enforcing exact included membership. This was an implementation fix before installation, not a membership change. No fitted-fold warning or empirical fitting failure occurred. Temporary validation files were cleaned; no historical suite was rerun or repinned.

## Limitations and one next step

Actual completion/availability timing and event overlap remain unverified. Missing 2022, unequal history depth, retrospective source/admission selection and only four ATP scored batches limit interpretation. Calibration and prediction coverage are conditional on the fixed readiness rule. Separation diagnostics are conservative indications, not a general mathematical certification. Deletion diagnostics do not account for training uncertainty. Source labels are not verified timestamps. The 2024 validation and locked 2025 test remain untouched. No model selection, factor approval, imputation, acquisition, dependency, OTD, portfolio change or publication occurred.

Recommend **Phase 2S: bounded dependence-aware uncertainty feasibility review** of the frozen Phase 2R evaluation, because uncertainty remains the unresolved inferential blocker. Exact approval language: **“Approve Phase 2S: assess whether the frozen Phase 2R scored cohort can support a defensible whole-batch and recurring-player uncertainty method. Recommend one bounded method with explicit sufficiency and validation requirements, or retain UNCERTAINTY_NOT_ESTABLISHED. Do not refit, tune, change eligibility, acquire data, add dependencies, access 2024/2025 or modify the portfolio.”** The next prompt must define its exact documentation scope. No method or interval is approved automatically by these descriptive results.
