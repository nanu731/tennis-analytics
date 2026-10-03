# Phase 2AF: rolling 2024 validation results

## Terminal result and authority

**SELECTION_UNRESOLVED**, release **2AF-1.0.0**, from `58549ebf11f3114e3e139313e589227ca7301a9b`. All twenty required batches pass both factor models' gates: **40 successful fits**, with **871 ATP and 912 WTA common pairs**. Reduced-minus-full log loss/Brier is negative in ATP and positive in WTA. The frozen cross-tour selection condition therefore fails, despite no whole-batch reversal. Retain both specifications; do not choose a tour-specific winner, introduce a practical-effect threshold or search another model.

The [frozen protocol](2024-validation-protocol.md#complete-prespecified-selection-map) and numerical [Phase 2R](../R/run_s08_paired_evaluation.R) / [Phase 2W](../R/run_m05_ablation.R) definitions were read and pinned before loading outcomes. The protocol remains byte-for-byte unchanged. Forty literal pins protect numerical authority, protocol, development inputs, both admissions and the [Phase 2AD histories](2024-s08-batched-history-aggregation.md) / [Phase 2AE Elo release](2024-surface-elo-baseline-audit.md). No historical runner or suite executes; allowlisted pure readiness, fitting, collinearity, loss, calibration and installation helpers retain their original definitions.

This is **2024 source-label validation sensitivity** under **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**. **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED** remain in every output. No confidence interval, p-value, significance, practical superiority or final Four Factors qualification is reported.

## Implementation and coverage

The [runner](../R/run_2024_validation.R) validates admitted identities, disposition ownership, source-label/cutoff metadata, original slot rates/differences, completeness and exact frozen Elo joins before analysis. Phase 2R input checks are reused with only the separately authorized 2024 year/cardinality adapter. Qualified DEVELOPMENT/VALIDATION_2024 keys preserve original match IDs without cross-cohort collision. No feature or Elo state is rebuilt.

The initial full-vector training inventory is all **2,026 complete development rows**, split **612 ATP / 1,414 WTA**. Each tour uses its own original pre-batch development vectors, not only previously scored rows. At each 2024 source-date cutoff, add only complete same-tour earlier 2024 rows. Full M03/M05/M11/M12 and reduced M03/M11/M12 receive identical training and complete-target keys. Both fit once per simultaneous batch, with zero intercept and each training fold's sample SD division, without centering. Current outcomes can enter only subsequent batches' training. Reducing the predictor set never expands eligibility.

Preserve count gates (five contributing batches, 100 matches, 25 outcomes per class), finite positive SDs, rank four/three, registered centered collinearity diagnostics and thresholds, then unchanged convergence/warning/boundary/extreme/separation checks. Record earlier gate failures with later stages NOT_RUN; no rescue. Failed-model predictions remain absent even if the other model is available. Registered correlation review flags do not become new exclusions.

All 1,901 targets remain: 944 ATP / 957 WTA. Both factor models predict exactly the 871/912 complete vectors; both Elo benchmarks remain available for all targets but are scored only on the shared 871/912 IDs. Structural nonpredictions are **73 ATP / 45 WTA**: ATP 69 targets with an empty player history plus four additional M12 zero-opportunity targets; WTA 45 with an empty history. ATP empty-target breakdown is 26 A-only, 41 B-only, two both; WTA 11 A-only and 34 B-only. Simultaneous metric/slot reasons are preserved. There are no readiness, fit, numerical, boundary-probability or input failures in the measured release; no detected separation or fitting warning.

Maximum full-model absolute Pearson/Spearman correlations are 0.1235093/0.1300329 ATP and 0.2195162/0.1832917 WTA; maximum VIF/condition index is 1.026963/1.188527 ATP and 1.086702/1.358415 WTA. Reduced maxima are 0.1025074/0.09233518 and 1.014210/1.126551 ATP; 0.2195162/0.1832917 and 1.084874/1.333276 WTA. No correlation review/warning threshold is reached.

The complete batch table below reports shared training counts, common pairs and full-model M05 coefficients. Both models pass in every row; coefficients are forecast parameters, not importance weights.

| Tour | Event | Training rows / prior batches | Common pairs | M05 coefficient |
| --- | --- | ---: | ---: | ---: |
| ATP | Australian Open | 612 / 9 | 104 | -0.03113332 |
| ATP | Indian Wells | 716 / 10 | 92 | -0.01555661 |
| ATP | Miami | 808 / 11 | 86 | +0.01360201 |
| ATP | Madrid | 894 / 12 | 85 | +0.01158953 |
| ATP | Rome | 979 / 13 | 89 | +0.03384971 |
| ATP | Roland-Garros | 1,068 / 14 | 99 | +0.00075480 |
| ATP | Wimbledon | 1,167 / 15 | 106 | -0.00465910 |
| ATP | Canada | 1,273 / 16 | 52 | +0.00779151 |
| ATP | Cincinnati | 1,325 / 17 | 51 | -0.01646894 |
| ATP | US Open | 1,376 / 18 | 107 | -0.01526976 |
| WTA | Australian Open | 1,414 / 19 | 107 | +0.00796618 |
| WTA | Indian Wells | 1,521 / 20 | 89 | -0.00034815 |
| WTA | Miami | 1,610 / 21 | 85 | -0.01662394 |
| WTA | Madrid | 1,695 / 22 | 94 | -0.01879130 |
| WTA | Rome | 1,789 / 23 | 89 | -0.02764018 |
| WTA | Roland-Garros | 1,878 / 24 | 114 | -0.03821309 |
| WTA | Wimbledon | 1,992 / 25 | 119 | -0.04834206 |
| WTA | Canada | 2,111 / 26 | 49 | -0.04450022 |
| WTA | Cincinnati | 2,160 / 27 | 55 | -0.04467617 |
| WTA | US Open | 2,215 / 28 | 111 | -0.04982257 |

## Paired descriptive scores

All four methods use one identical eligible-ID mask per tour, the same neutral outcome and the same source-label cutoff. Natural-log loss and Brier are primary; accuracy uses the frozen 0.5 threshold with half-credit ties. The unrounded output values, not this display rounding, determine selection.

| Tour | Method | Log loss | Brier | Accuracy |
| --- | --- | ---: | ---: | ---: |
| ATP | Full S08 | 0.63283069 | 0.22086656 | 0.6463835 |
| ATP | Reduced | 0.63248325 | 0.22071809 | 0.6406429 |
| ATP | Primary Elo | 0.61660791 | 0.21399565 | 0.6544202 |
| ATP | Overall-only Elo | 0.60801003 | 0.21089770 | 0.6498278 |
| WTA | Full S08 | 0.64223224 | 0.22478667 | 0.6513158 |
| WTA | Reduced | 0.64287450 | 0.22513571 | 0.6589912 |
| WTA | Primary Elo | 0.61407889 | 0.21252961 | 0.6644737 |
| WTA | Overall-only Elo | 0.60676248 | 0.20949565 | 0.6732456 |

| Tour | Paired difference | Log loss | Brier |
| --- | --- | ---: | ---: |
| ATP | Reduced − full | -0.0003474321 | -0.0001484733 |
| WTA | Reduced − full | +0.0006422503 | +0.0003490372 |
| ATP | Full − primary Elo | +0.0162227716 | +0.0068709097 |
| ATP | Full − overall Elo | +0.0248206547 | +0.0099688667 |
| ATP | Reduced − primary Elo | +0.0158753395 | +0.0067224364 |
| ATP | Reduced − overall Elo | +0.0244732226 | +0.0098203934 |
| WTA | Full − primary Elo | +0.0281533508 | +0.0122570603 |
| WTA | Full − overall Elo | +0.0354697605 | +0.0152910218 |
| WTA | Reduced − primary Elo | +0.0287956011 | +0.0126060975 |
| WTA | Reduced − overall Elo | +0.0361120108 | +0.0156400591 |

Negative candidate-minus-Elo differences would favor the candidate; every observed tour-level comparison above is positive. Elo has lower descriptive losses on this conditional cohort. No all-target Elo score is substituted, tours are not pooled, and these results establish neither significance nor a final superiority conclusion. Full/reduced differences are small dependent descriptive results with no practical-effect threshold.

## Calibration and deletion diagnostics

Calibration is assessable descriptively for every method in each tour overall, the synonymous 2024 season group and Hard; ALL/BOTH_COMPLETE strata repeat the same scored rows. All other groups fail the frozen support gates and retain reasons. Of 800 calibration records, 48 are supported and 752 withheld. The diagnostic intercept/slope does not recalibrate predictions or override the zero-intercept forecast specification.

| Tour | Method | Overall calibration intercept | Slope |
| --- | --- | ---: | ---: |
| ATP | Full | -0.0717330 | 1.3238583 |
| ATP | Reduced | -0.0721163 | 1.3295028 |
| ATP | Primary Elo | -0.0720233 | 1.5794263 |
| ATP | Overall Elo | -0.0672231 | 1.2445403 |
| WTA | Full | -0.1629001 | 1.2004261 |
| WTA | Reduced | -0.1588523 | 1.1858613 |
| WTA | Primary Elo | -0.0964631 | 1.4064741 |
| WTA | Overall Elo | -0.0991559 | 1.1433935 |

Delete each of ten scored batches per tour and each of **167 ATP / 177 WTA players**, removing every match involving the player in either slot. Predictions, histories and fits remain frozen; prior training influence is not removed. The resulting 3,640 comparison/metric records (200 batch, 3,440 player) are all evaluable. **No sign reversal or tie occurs in any of the five paired comparisons for either primary metric.** These are conditional influence checks, not confidence intervals or independent replications.

| Tour | Deletion | Reduced − full log-loss range | Reduced − full Brier range |
| --- | --- | --- | --- |
| ATP | Batch | -0.0005248828 to -0.0000769353 | -0.0002274451 to -0.0000127768 |
| ATP | Player | -0.0004282974 to -0.0002168291 | -0.0001843825 to -0.0001016220 |
| WTA | Batch | +0.0005068598 to +0.0008160049 | +0.0002912019 to +0.0004120111 |
| WTA | Player | +0.0003932466 to +0.0008230355 | +0.0002394681 to +0.0004360298 |

Largest reduced/full batch influences arise from ATP Rome and WTA Wimbledon for both metrics. Largest player influence is ATP ID 207925 for log loss and 209260 for Brier; WTA ID 216347 for both. These IDs identify score influence only, not a cause or a player-performance conclusion. Player deletion and calibration cannot break the cross-tour selection conflict.

## Selection and separate interpretation

Every required fold/numerical gate passes and all required batch deletions are evaluable. Nevertheless, the four reduced-minus-full tour/metric differences have mixed signs, so **SELECTION_UNRESOLVED** with **MIXED_TOUR_OR_METRIC_DIRECTIONS** is mandatory. Retain full S08 as the provisional four-component hypothesis and reduced as a three-factor comparator for a later separately authorized final test. A deletion tie would be disclosed rather than treated as reversal; no tie occurs here. Failure, missing/nonfinite comparison or unevaluable batch deletion would independently block preference.

**M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED:** ATP has five negative and five positive required-fold M05 coefficients; WTA has nine negative and one positive. No coefficient is missing or zero. The protocol requires negative direction in every required full-model fold across both tours; it cannot be rescued by an average sign, a favorable later period or forecast losses. Positive coefficients do not mean double faults improve performance. M05 remains Double-Fault Rate per Second-Serve Opportunity, lower-is-better for one error component. No factor definition/status changes: S02 paused, S08 provisional; neither specification receives final Four Factors qualification.

## Release and verification

Exactly six ignored CSVs are installed atomically under data/pilot/2024-validation/:

| Output | Rows | Content |
| --- | ---: | --- |
| fold-readiness.csv | 40 | All required model/batch gates, scales, coefficients, training/target keys and cutoffs |
| target-predictions.csv | 1,901 | Every neutral target, frozen predictors/outcome, four-method availability, probabilities, reasons, common mask and paired losses |
| model-fits.csv | 840 | 40 forecast records and 800 calibration records |
| paired-scores.csv | 3,400 | Complete tour/season/batch/event/surface/stratum coverage, model scores, paired differences and failure reasons |
| stability.csv | 3,640 | Every frozen-prediction batch/player deletion, five comparisons and two metrics |
| selection-decision.csv | 2 | Tour evidence, common terminal decision, failed M05 direction requirement and no-qualification label |

| Output | SHA-256 |
| --- | --- |
| fold-readiness.csv | `4f4270c26bd269c97cebaeeac3c3c49fb65e1bd6636b70c5666d765e33928a62` |
| target-predictions.csv | `91db2312a404033c11a51f33d2ab289e2b450e500f347fa2c299e1e596a9c29b` |
| model-fits.csv | `a6c29e4a5a4e2780fc15351d1160160844fd984736bda5ec7a0c55f5aa0e2d06` |
| paired-scores.csv | `0588d52ecb4a2fd0661e5691aee0cadf1710fbd028aa84e85bcaa1d3ec598d6d` |
| stability.csv | `4a212cd329661b2b77a861833513d2b7ab7765c76df48d4a1ec5439774c9d779` |
| selection-decision.csv | `c7bf32f522056974b9f77e45d3fb8113b6d8d16697cf774643d4abfe5dd1297c` |

The [focused suite](../R/test_2024_validation.R) passes **4,568 checks**, including exact pins/joins, 1,901-target accounting, every training universe and sample SD, identical model IDs, original development vectors, all readiness stages and failure precedence, rank/constant/separated fixtures, slot complements/global relabeling, permutations, simultaneous-event fixtures, all twenty current/later-outcome perturbations and an earlier-outcome positive control. It tests shared masks, stable extreme-logit losses, calibration gates, every deletion, all **648 selection truth-table cases**, missing/nonfinite/empty cases, independent-process byte-identical reruns and atomic failure/refusal behavior. Historical numerical code and protocol were never edited after or before outcome loading.

Seven installed-release checks passed: a fresh process reproduced all six installed files byte-for-byte, and identical reinstallation retained them. Every one of the 3,400 score/coverage rows and 800 calibration rows was independently reconciled. Forty-two local links/anchors, current-document agreement, whitespace, exact six-file tracked scope and six-file ignored-output scope pass. All 365 other pre-existing tracked files, pilot artifacts and manifested raw/metadata files retain their SHA-256 hashes; historical status/contract bodies and the frozen protocol are unchanged. Outputs and the complete diff were inspected. No historical suite was rerun or repinned; no protocol or input mismatch was found.

## Limitations and one next approval

The estimand is conditional on admitted source-present 2024 records, shared full-vector completeness and successful frozen gates, under source-label batching. Actual availability and event nonoverlap remain unverified. Missing 2022, unequal development history, retrospective exclusions, unknown official recall and repeated-player/batch dependence persist. No interval or p-value resolves uncertainty. Neither interpretation nor forecast evidence authorizes a final superiority claim. Historical releases, raw sources, membership, histories and Elo remain unchanged. No tuning, rescue, acquisition, 2025 access, new dependency, OTD, portfolio or publication work occurred.

Recommend **Phase 2AG: documentation-only pipeline freeze and locked final-test protocol**, retaining both scientific roles and the failed M05 interpretation requirement before any final-test access. No new candidate-selection phase or empirical tuning.

Exact approval: **“Approve Phase 2AG: freeze both validated specifications and write the locked final-test protocol using saved evidence only. Preserve the unresolved selection, failed M05 interpretation requirement, common cohort, chronological gates and uncertainty limitations. Do not access any 2025 data, URL, metadata, schema or result; refit, tune, acquire data, add dependencies, resume OTD or modify the portfolio.”** The next prompt must define exact documentation scope and acceptance checks; this recommendation grants no further execution authority.
