# Phase 2W: M05 incremental forecast ablation

## Prospective comparison registration

Registered before the first reduced-model fit in this task, under the explicit Phase 2W instruction from `654bf93c54a5c95ad59f253b5a792723d615cb33`.

Fit only separate ATP/WTA reduced logistic models using dM03, dM11 and dM12, zero intercept and training-fold sample-SD-only scaling. Reuse the eighteen Phase 2R attempted folds, their exact training IDs and cutoffs, and the 1,278 frozen scored target IDs. Do not expand eligibility when M05 is removed. Retain all 2,580 targets in coverage and copy the original reasons for twelve never-attempted folds. Read full-S08 probabilities from the frozen release; never refit the full model.

Preserve Phase 2R readiness, collinearity, convergence, warning, boundary, extreme-probability and separation safeguards without rescue; change only design rank from four to three. Withhold comparisons from failed reduced folds. Compare natural-log loss and Brier score on identical eligible IDs, by tour, batch, event, surface and season. Differences are **reduced minus full S08**: negative favors reduced; positive favors full. This explicit Phase 2W direction supersedes the opposite direction proposed, but not implemented, in Phase 2V. The Phase 2V report remains unchanged. No calibration model, extra factor combination or alternative model is fitted: this phase follows the user's two-loss and score-deletion scope.

Prespecified classification:

- `M05_FULL_MODEL_DESCRIPTIVELY_BETTER_BOTH_TOURS` only if both tour-level differences are strictly positive in both tours.
- `M05_REDUCED_MODEL_DESCRIPTIVELY_BETTER_BOTH_TOURS` only if both are strictly negative in both tours.
- `M05_ABLATION_MIXED` for every other pattern, including exact ties or failed tour comparisons. A tour comparison is incomplete if any of its frozen scored IDs lacks a reduced prediction; partial paired summaries remain descriptive but cannot qualify for either uniform classification.

No tolerance, practical-effect threshold, majority vote, interval or automatic factor-status change enters this classification. Leave-one-batch and leave-one-player deletions remove paired score rows only, including every match containing a player in either slot; they never refit. Retain `UNCERTAINTY_NOT_ESTABLISHED`, source-label sensitivity and the Phase 2K chronology failure. This comparison cannot establish superiority, final factor qualification or a causal interpretation for M05.

<!-- PROSPECTIVE_REGISTRATION_END -->

## Results and measured coverage

**M05_ABLATION_MIXED.** Reduced-minus-full losses are positive on ATP and negative on WTA for both metrics. This is the registered descriptive classification, not a superiority finding, practical-effect decision or factor-status change. The labels remain **Double-Fault Rate per Second-Serve Opportunity** for M05 and Second-Serve Security for its broader family; S02 stays paused and S08 provisional.

All eighteen reduced fits pass: four ATP and fourteen WTA, each with design rank three, finite coefficients, convergence and no fitting warnings, boundary flags, extreme training probabilities or detected separation indication. Maximum VIF is 1.167756, condition index 1.496186 and absolute Pearson/Spearman correlation 0.312832, below the unchanged gates. An absent separation indication is not a general proof of nonseparation. The remaining coefficients are reestimated in the reduced model; this is not merely setting the frozen M05 coefficient to zero.

All **2,580** targets remain. The twelve never-attempted folds retain their exact Phase 2R gate/reason strings, and their target reasons are copied unchanged. There are **211 ATP and 1,067 WTA paired predictions**, exactly the frozen 1,278 IDs, with no failed reduced fold or nonfinite target prediction. The 1,302 pre-existing nonpredictions remain visible: 554 incomplete full-S08 vectors and 748 complete-but-not-ready rows. Completeness remains defined by the full model; no row becomes eligible merely because M05 was removed. Frozen full probabilities are copied with their original text representation and numeric values.

| Tour | Targets | Attempted / passed reduced folds | Paired IDs | Full log loss | Reduced log loss | Reduced − full log loss | Full Brier | Reduced Brier | Reduced − full Brier |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 846 | 4 / 4 | 211 | 0.633750505129 | 0.633787457144 | +0.000036952014 | 0.220935581618 | 0.220959407532 | +0.000023825914 |
| WTA | 1,734 | 14 / 14 | 1,067 | 0.634624330248 | 0.633865180086 | −0.000759150161 | 0.221056614154 | 0.220647696567 | −0.000408917587 |

No row-independent uncertainty, p-value, interval or meaningful-effect margin is attached to these differences. Natural-log loss uses stable logit arithmetic without probability clipping; both models use the same paired mask for both metrics.

## Complete batch and event results

Every authorized batch appears below, including batches with zero paired predictions. These saved batches each correspond to one event cell; the output independently reports all event-family, surface, season, tour and completeness-stratum groups. Zero comparisons retain undefined scores, not zero loss. Positive differences favor full S08; negative favor reduced.


| Batch label | Event | Targets / paired | Reduced − full log loss | Reduced − full Brier |
| --- | --- | ---: | ---: | ---: |
| ATP / 20230116 | Australian Open | 126 / 0 | NA | NA |
| ATP / 20230306 | Indian Wells | 91 / 0 | NA | NA |
| ATP / 20230320 | Miami | 89 / 0 | NA | NA |
| ATP / 20230424 | Madrid | 94 / 0 | NA | NA |
| ATP / 20230508 | Rome | 92 / 0 | NA | NA |
| ATP / 20230529 | Roland-Garros | 119 / 0 | NA | NA |
| ATP / 20230703 | Wimbledon | 56 / 48 | -0.000538218 | -0.000194864 |
| ATP / 20230807 | Canada | 54 / 48 | +0.000316945 | +0.000149486 |
| ATP / 20230814 | Cincinnati | 50 / 50 | +0.000386863 | +0.000140889 |
| ATP / 20230828 | US Open | 75 / 65 | -0.000014233 | +0.000002477 |
| WTA / 20210208 | Australian Open | 126 / 0 | NA | NA |
| WTA / 20210322 | Miami | 89 / 0 | NA | NA |
| WTA / 20210429 | Madrid | 58 / 0 | NA | NA |
| WTA / 20210510 | Rome | 51 / 0 | NA | NA |
| WTA / 20210531 | Roland-Garros | 119 / 0 | NA | NA |
| WTA / 20210628 | Wimbledon | 100 / 0 | NA | NA |
| WTA / 20210809 | Canada | 49 / 47 | +0.005579064 | +0.002762662 |
| WTA / 20210816 | Cincinnati | 49 / 48 | +0.007077235 | +0.003418445 |
| WTA / 20210830 | US Open | 93 / 80 | +0.001589714 | +0.000220804 |
| WTA / 20211006 | Indian Wells | 91 / 82 | -0.002100889 | -0.000640066 |
| WTA / 20230116 | Australian Open | 127 / 88 | +0.006450737 | +0.002786917 |
| WTA / 20230306 | Indian Wells | 91 / 84 | -0.008326625 | -0.004805388 |
| WTA / 20230320 | Miami | 92 / 85 | -0.000528132 | +0.000304845 |
| WTA / 20230424 | Madrid | 93 / 84 | +0.002864129 | +0.000958319 |
| WTA / 20230508 | Rome | 90 / 84 | -0.000012691 | +0.000286488 |
| WTA / 20230529 | Roland-Garros | 119 / 107 | -0.008231664 | -0.003804934 |
| WTA / 20230703 | Wimbledon | 92 / 83 | -0.000404216 | -0.000165917 |
| WTA / 20230807 | Canada | 53 / 51 | -0.000796926 | -0.000438673 |
| WTA / 20230814 | Cincinnati | 52 / 52 | -0.003500408 | -0.001572770 |
| WTA / 20230828 | US Open | 100 / 92 | -0.003181481 | -0.001548269 |

## Season and surface results

| Tour / slice | Targets / paired | Reduced − full log loss | Reduced − full Brier |
| --- | ---: | ---: | ---: |
| ATP / 2023 | 846 / 211 | +0.000036952 | +0.000023826 |
| ATP / Clay | 305 / 0 | NA | NA |
| ATP / Grass | 56 / 48 | -0.000538218 | -0.000194864 |
| ATP / Hard | 485 / 163 | +0.000206327 | +0.000088226 |
| WTA / 2021 | 825 / 257 | +0.002166644 | +0.001008208 |
| WTA / 2023 | 909 / 810 | -0.001687458 | -0.000858549 |
| WTA / Clay | 530 / 275 | -0.002331881 | -0.001100233 |
| WTA / Grass | 192 / 83 | -0.000404216 | -0.000165917 |
| WTA / Hard | 1012 / 709 | -0.000190686 | -0.000169224 |

WTA 2021 favors full S08 on both metrics, while WTA 2023 favors reduced. ATP grass favors reduced and hard favors full; ATP clay has no paired forecasts. WTA's three surface aggregates favor reduced, but event-level differences vary. No favorable slice is selected, and the pooled tour result is not substituted for season/surface stability. ATP has no independent-season comparison; saved 2022 coverage remains absent.

## Score-deletion influence

Exactly 668 rows cover both losses under four ATP/fourteen WTA batch deletions and 120 ATP/196 WTA player deletions. Removing a player removes all paired matches involving that ID in either slot. These are deletions of already scored rows; no model or history is refitted. They do not measure training influence, unseen-player performance or sampling uncertainty.

| Tour | Deletion kind | Log-loss sign reversals | Brier sign reversals |
| --- | --- | ---: | ---: |
| ATP | Batch (4) | 2 | 2 |
| ATP | Player (120) | 33 | 29 |
| WTA | Batch (14) | 1 | 0 |
| WTA | Player (196) | 0 | 0 |

Omitting ATP Canada (20230807, 48 rows) or Cincinnati (20230814, 50 rows) reverses both small positive tour differences. Omitting Wimbledon instead produces the largest ATP batch change: log loss becomes +0.000206327307 and Brier +0.000088225506. ATP player 100644 (11 rows) gives the largest absolute player change for both losses, leaving +0.0003538162 log loss and +0.0001721125 Brier.

Omitting WTA Roland-Garros 2023 (20230529, 107 rows) changes log loss from −0.000759150161 to +0.00007372382; Brier remains negative at −0.00003040321. This is the largest absolute WTA batch change for both metrics. WTA player 211651 (26 rows) produces the largest absolute player change for both losses, leaving −0.001453555 log loss and −0.000727723 Brier. No WTA player omission reverses either sign. All deletion rows are retained, including non-reversals; counts are not independent replications or a stability threshold.

## Implementation and frozen boundaries

The runner verifies thirteen literal pins before loading outcomes: standing instructions, frozen Phase 2R code/protocol/report and five outputs, the Phase 2V decision, frozen history features, batch targets and admitted membership. Joins verify neutral identities, results, reduced features, original completeness and target/fold membership. Exact saved training-ID strings are checked against original complete rows in strictly earlier same-tour batches. The reduced feature pipeline then discards M05 values entirely while preserving the original cohort flags.

The Phase 2R numerical helpers are reused as reviewed copies, with only the predictor dimension and readiness rank adapted to three. Tests compare their parsed definitions to the frozen originals, with the two explicit readiness dimension substitutions. The full empirical runner is never executed. Training sample SDs are checked against the frozen corresponding Phase 2R SDs. Five contributing prior batches, 100 matches, 25 outcomes per class, rank/finite-SD, correlation/VIF/condition and fit safeguards retain their original thresholds and precedence. No rescue fit, calibration model, other predictor combination, window, Elo update or final weight is introduced.

Every output retains **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**, **UNCERTAINTY_NOT_ESTABLISHED** and the classification. No actual chronology or historical data availability is established. No missingness/exclusion rule, name, factor status, count, membership, raw value or historical result changes. No acquisition, dependency, inferred timestamp, 2024/2025 access, OTD work, portfolio modification or publication occurs. The reduced model is a diagnostic comparison, not a newly selected final factor set.

## Outputs and validation

Run `Rscript R/run_m05_ablation.R` and `Rscript R/test_m05_ablation.R` from the repository root. The base-R runner installs exactly five ignored local outputs under `data/pilot/m05-ablation/`:

| Output | Rows | Contents |
| --- | ---: | --- |
| fold-readiness.csv | 30 | Original attempted status, exact training IDs, cutoffs, copied unattempted reasons, reduced safeguards and counts |
| model-fits.csv | 18 | Only attempted reduced fits: coefficients, SDs, zero intercept and diagnostics |
| target-predictions.csv | 2,580 | Frozen full probabilities/reasons/cohort, reduced probabilities, paired mask and losses |
| paired-scores.csv | 6,344 | Complete tour/batch/event/surface/season/stratum scores and failure-reason counts, including zero groups |
| stability.csv | 668 | Both-slot player and whole-batch score-deletion influence |

All 1,553 focused checks passed, covering thirteen input pins, exact frozen training/target membership, cutoffs, dimension-only helper changes, rank-three design, training-only scaling, independent reduced formula fits, slot/global relabeling, failure precedence, identical masks, stable losses, all 668 deletions, complete group summaries, M05-value irrelevance, byte-identical reruns and atomic interruption/corruption handling. Full probabilities also match the original serialized values for all 2,580 targets. The before-fit registration hash remains unchanged. Twenty-four local links/anchors, document agreement, whitespace, exact six-file scope, five ignored outputs and historical status/contract preservation pass. All 307 other pre-existing tracked files and pilot artifacts retain their hashes. Outputs and the final diff were inspected; no historical suite was rerun or repinned.

The initial dry run emitted numeric-import warnings for literal saved `NA` values. Explicit missing-token parsing fixed those import warnings before release, with invalid tokens still rejected. A future-information test initially perturbed features used by later fits and correctly tripped frozen training-SD verification; the fixture was restricted to the earlier folds whose predictions it tests. Production safeguards were not weakened. Final execution has no unresolved import warning or empirical fit failure. Intentional malformed-input, separated-model and interrupted-install fixtures fail as expected.

## Limitations and one next approval

The ATP descriptive advantage for full S08 is deletion-sensitive; WTA's reduced advantage varies by season and its log-loss sign reverses under one event omission. These findings do not support a uniform M05 forecasting conclusion. The ablation reestimates other coefficients and measures the specified model comparison, not a causal double-fault effect or a weight. M05's positive historical WTA coefficient remains unqualified as a performance interpretation. Role clarification and an ablation do not waive the registered direction, interpretation or final qualification rules. Dependence-aware uncertainty remains unestablished, and no practical-effect threshold was supplied or invented.

Recommend **Phase 2X: a bounded pre-validation candidate decision** applying the existing scientific rules to the already-tested full S08 and reduced model. Decide which candidates, if any, may advance to a separately authorized 2024 protocol; explicitly address cross-tour interpretation, conflicting season/deletion evidence and unresolved uncertainty. This should make a scientific progression decision, not search additional models or relabel an unfavorable finding. The next prompt must define its documentation scope. No status change or validation access follows automatically here.

Exact approval: **“Approve Phase 2X: make a bounded pre-validation candidate decision from frozen Phase 2J–2W evidence, applying existing interpretation and selection rules to full S08 and the tested reduced model. Specify which candidates, if any, may advance to a separately approved 2024 protocol. Do not refit, tune, add thresholds, change frozen releases or access 2024/2025. Retain UNCERTAINTY_NOT_ESTABLISHED.”**

## Ignored output fingerprints

| File | SHA-256 |
| --- | --- |
| fold-readiness.csv | `2e1760014372e9f21b9acc6b62ca563fc51b8441623a54960f715297a0d891c9` |
| model-fits.csv | `b073d65c3eab9c037d7ddac31af19aa343028d435d5ad4d475cba75dc4445ee5` |
| paired-scores.csv | `834347cd90bed6c6a309e41da5791cdd27b6b6c3591faaa9f93e706b99371bac` |
| stability.csv | `6ab153e8e35a9550fba0252eed725ef8b484b8104c72ea1d6fbfcc1bcaa43f33` |
| target-predictions.csv | `1eb8ad350194e1ba8010ea714043ada297416bfb122e16015505ed6a55b6ca26` |
