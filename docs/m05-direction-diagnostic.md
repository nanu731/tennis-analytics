# Phase 2T: frozen M05 direction diagnostic

## Conclusion and scope

**MEASURED_M05_PATTERN_IDENTIFIED:** WTA's fourteen positive conditional M05 coefficients coexist with weak positive marginal training associations in every fold, different cross-factor correlations from ATP, and changing opportunity/history and event composition. ATP's four negative coefficients coexist with near-zero marginal Pearson associations. This is a measured descriptive pattern, not a causal explanation of the sign difference.

The evidence **requires a bounded factor review** of M05's forecast interpretation. It does not authorize a sign constraint, changed definition, replacement or status change. M05 remains lower-is-better; S02 stays paused and S08 provisional. A positive WTA coefficient cannot establish that double faults help winning. No verified implementation or saved-count reconstruction defect was found within this audit; underlying source accuracy beyond the frozen admission checks is not newly established.

Version 1.0.0 uses only authorized saved evidence from starting commit `715c1c59f77566bdee96c999f41256f9dcb3fa0f`. The [Phase 2R release](s08-paired-evaluation-results.md), [history aggregation](s08-batched-history-aggregation.md) and [uncertainty assessment](dependence-aware-uncertainty-feasibility.md) remain immutable. **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED** persist.

## Arithmetic and denominators

The runner verifies fifteen literal SHA-256 pins before reading analysis tables. It checks all 2,580 frozen targets and 5,160 slots, independently pools 56,999 eligible prior-match contributions using each prior player's own count orientation, and retains 805 empty slots. Own M05 equals pooled double faults divided by pooled service points minus first serves in. It is not an opponent statistic, a match-rate average or a rate per all service points. Zero/empty rates remain undefined; no eligibility or count is changed.

Exactly eighteen ready folds and 1,278 scored targets (four/211 ATP; fourteen/1,067 WTA) enter this diagnostic. The remaining 1,302 Phase 2R nonpredictions are not newly discarded or assigned coefficients. Training rows are the exact saved earlier complete IDs at each fold. Their original feature histories, outcomes, sample SDs and all four frozen coefficients are reused. No fitted model is calculated.

For each row, M05's log-odds contribution is `beta_M05 * dM05 / sd_train_M05`, without mean-centering. The four component contributions sum to the saved linear predictor and reproduce the frozen probability for every scored target. A target slot swap negates the differences and contributions and complements the probability. Training SDs use the sample denominator n−1. Frozen coefficients are conditional forecast parameters, not importance weights or causal effects.

Class summaries compare mean A-minus-B M05 for outcome A-loss versus A-win. Pearson and Spearman summaries use those same oriented rows. For binary outcomes, Pearson sign agrees with the difference in class means when defined. Spearman can differ because it uses ranks. Correlations are descriptive; no p-values, intervals or dependence assumptions are added.

## Complete fold results

All eighteen folds are shown below. Training correlation columns are Pearson; the output also contains both class means, their difference, Spearman associations and every cross-factor Pearson/Spearman correlation. Contributions refer to scored targets and are in log-odds units.

| Tour/date | Train / target n | Beta | SD | Train M05–outcome r | Target M05–outcome r | Target contribution min / max |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP|20230703 | 401 / 48 | -0.021595 | 0.061172 | 0.011778 | -0.004617 | -0.057583 / 0.039724 |
| ATP|20230807 | 449 / 48 | -0.006814 | 0.060468 | 0.011097 | -0.126283 | -0.017856 / 0.010186 |
| ATP|20230814 | 497 / 50 | -0.028407 | 0.059194 | 0.000371 | 0.002572 | -0.042874 / 0.049134 |
| ATP|20230828 | 547 / 65 | -0.033221 | 0.057987 | -0.000790 | -0.007487 | -0.053955 / 0.091201 |
| WTA|20210809 | 347 / 47 | 0.050275 | 0.087008 | 0.004536 | 0.301111 | -0.072386 / 0.069021 |
| WTA|20210816 | 394 / 48 | 0.108879 | 0.084963 | 0.034557 | 0.133526 | -0.189527 / 0.142051 |
| WTA|20210830 | 442 / 80 | 0.136414 | 0.082857 | 0.045684 | 0.001298 | -0.310319 / 0.233603 |
| WTA|20211006 | 522 / 82 | 0.133541 | 0.080377 | 0.044521 | -0.029397 | -0.240746 / 0.208322 |
| WTA|20230116 | 604 / 88 | 0.113582 | 0.077744 | 0.036316 | 0.190540 | -0.158118 / 0.240431 |
| WTA|20230306 | 692 / 84 | 0.140986 | 0.075990 | 0.053303 | -0.045396 | -0.379628 / 0.335232 |
| WTA|20230320 | 776 / 85 | 0.104035 | 0.076032 | 0.041398 | 0.024117 | -0.213337 / 0.160717 |
| WTA|20230424 | 861 / 84 | 0.096294 | 0.074697 | 0.039920 | 0.075568 | -0.225050 / 0.167915 |
| WTA|20230508 | 945 / 84 | 0.103208 | 0.074408 | 0.043381 | 0.037542 | -0.285924 / 0.205097 |
| WTA|20230529 | 1029 / 107 | 0.098723 | 0.074304 | 0.042865 | -0.178700 | -0.247948 / 0.172517 |
| WTA|20230703 | 1136 / 83 | 0.057797 | 0.073473 | 0.024487 | 0.006839 | -0.177439 / 0.171009 |
| WTA|20230807 | 1219 / 51 | 0.053807 | 0.073508 | 0.023349 | -0.017050 | -0.128325 / 0.093916 |
| WTA|20230814 | 1270 / 52 | 0.049945 | 0.073064 | 0.021800 | -0.135675 | -0.080376 / 0.060522 |
| WTA|20230828 | 1322 / 92 | 0.036005 | 0.072522 | 0.016605 | -0.246839 | -0.102526 / 0.075357 |

Training relationships and history depth, with every fold retained:

| Tour/date | r with M03 | r with M11 | r with M12 | Median opportunities A / B | Median prior matches A / B |
| --- | ---: | ---: | ---: | ---: | ---: |
| ATP|20230703 | 0.208688 | 0.002978 | -0.082135 | 170 / 171 | 5 / 5 |
| ATP|20230807 | 0.150498 | -0.011252 | -0.053114 | 178 / 189 | 5 / 5 |
| ATP|20230814 | 0.136160 | -0.009272 | -0.039406 | 191 / 214 | 6 / 6 |
| ATP|20230828 | 0.136123 | -0.010633 | -0.036760 | 200 / 231 | 6 / 7 |
| WTA|20210809 | -0.092022 | 0.002362 | 0.148786 | 120 / 124 | 5 / 5 |
| WTA|20210816 | -0.077026 | -0.003183 | 0.131555 | 132 / 139.5 | 5 / 5 |
| WTA|20210830 | -0.077080 | -0.010235 | 0.127402 | 142 / 158 | 6 / 6 |
| WTA|20211006 | -0.057730 | 0.010174 | 0.132587 | 150 / 168 | 6 / 6 |
| WTA|20230116 | -0.066522 | -0.001707 | 0.137821 | 170.5 / 177 | 7 / 6.5 |
| WTA|20230306 | -0.060737 | 0.007187 | 0.145807 | 197 / 192 | 8 / 7 |
| WTA|20230320 | -0.050193 | 0.007978 | 0.134975 | 208 / 201 | 8 / 7 |
| WTA|20230424 | -0.040914 | 0.013155 | 0.126285 | 221 / 212 | 9 / 8 |
| WTA|20230508 | -0.037529 | 0.022525 | 0.113359 | 234 / 217 | 9 / 8 |
| WTA|20230529 | -0.033848 | 0.019472 | 0.110973 | 253 / 229 | 10 / 8 |
| WTA|20230703 | -0.034549 | 0.017127 | 0.110694 | 274 / 237 | 10 / 9 |
| WTA|20230807 | -0.032245 | 0.015668 | 0.122524 | 290 / 245 | 11 / 9 |
| WTA|20230814 | -0.028405 | 0.014387 | 0.116666 | 298.5 / 257 | 11 / 10 |
| WTA|20230828 | -0.023343 | 0.018521 | 0.110102 | 310.5 / 270 | 12 / 10 |

ATP training Pearson associations span −0.000790 to +0.011778; its class-mean differences span −0.000092 to +0.001439. All four Spearman associations are positive (+0.036620 to +0.062764). WTA training Pearson associations are +0.004536 to +0.053303, class-mean differences +0.000790 to +0.008097, and Spearman associations +0.033226 to +0.080292. Therefore a simple reversal from negative marginal to positive conditional association does **not** describe WTA. Suppression remains a hypothesis about conditional relationships, not a demonstrated mechanism.

Across all scored targets, marginal Pearson correlations are −0.034760 ATP and +0.001724 WTA; class-mean differences are −0.003412 and +0.000227. WTA's positive training pattern does not uniformly transfer to target events: its target correlations include both signs, from −0.246839 to +0.301111. These dependent descriptive comparisons do not select a model or establish a stable population relationship.

## Composition, opportunities and extremes

The 568-row group table reports every fold × training/target sample × all/season/surface/event category observed anywhere in that tour's frozen cohort, including absent categories with n=0 and undefined associations. No favorable subgroup is selected for inclusion. Counts and match shares describe composition; pooled rates describe opportunity-weighted exposure. Each row has separate A/B double-fault totals, opportunity totals, rates, and mean/minimum/quartiles/maximum for denominators, counts and prior-match depth.

Training surfaces change alongside coefficients: ATP first-to-last ready-fold Clay/Grass/Hard counts are 247/0/154 to 247/48/252. Its M05–M03 correlation falls from +0.208688 to +0.136123 while the coefficient remains negative. WTA starts at 200/85/62 and ends at 475/168/679. Its maximum positive coefficient occurs at Indian Wells 2023, with surface counts 200/85/407 and a hard-court training marginal correlation of +0.077375. This describes coincident composition, not a surface effect estimated separately.

WTA's first five ready folds train entirely on 2021; later 2023 training counts grow through 88, 172, 257, 341, 425, 532, 615, 666 and 718, alongside 604 retained 2021 rows. The coefficient rises and falls within 2021-only training and peaks after 88 new 2023 rows, then generally declines. No single season transition explains its sign. ATP has only 2023 evidence, and 2022 is absent. Training medians deepen over the folds, while SDs decrease; the complete tables preserve nonmonotonic coefficient changes rather than attributing them to one of these simultaneous shifts.

Scored-target history distributions:

| Measure | ATP A | ATP B | WTA A | WTA B |
| --- | ---: | ---: | ---: | ---: |
| Opportunities minimum | 50 | 17 | 12 | 12 |
| Opportunities Q1 | 262 | 244.5 | 223 | 183 |
| Opportunities median | 400 | 440 | 442 | 386 |
| Opportunities Q3 | 597 | 590 | 732 | 693 |
| Opportunities maximum | 924 | 917 | 1,929 | 1,929 |
| Prior matches minimum / median / maximum | 1 / 12 / 35 | 1 / 13 / 35 | 1 / 17 / 72 | 1 / 15 / 72 |
| Summed double-fault exposure | 8,115 | 8,129 | 74,939 | 72,017 |
| Summed opportunity exposure | 90,055 | 91,273 | 556,482 | 516,299 |

These summed exposures repeat prior observations when they occur in multiple target histories. They are **not** counts of unique underlying matches or independent observations. Training folds also overlap; the summary separately identifies unique training-row unions of 547 ATP and 1,322 WTA rows, without pooling repeated folds as independent samples.

To examine sparse-history concentration without a new cutoff, `summary.csv` supplies cumulative match, absolute-difference and absolute-contribution shares at **every observed** minimum-of-two-slots opportunity count and prior-match depth, per fold and tour. Target diagnostics include within-fold ranks with average ties. Minimums refer to the weaker-supported slot; both original slot values remain visible. Within a fold, absolute contribution is exactly proportional to absolute M05 difference; these are not independent pieces of evidence.

Across scored targets, Spearman correlations of absolute difference with minimum opportunities are −0.167300 ATP / −0.059927 WTA; with minimum depth −0.157279 / −0.061813. For absolute contributions the corresponding correlations are −0.160603 / −0.144158 and −0.143697 / −0.141906. Lower support has a modest descriptive association with larger absolute contributions, but does not identify a sole sparse-history cause or justify an exclusion. The largest absolute M05 differences have minimum opportunities/depth 127/4 ATP and 253/9 WTA. The largest absolute contributions have 237/6 and 107/4 respectively. These extremes are not confined to the smallest observed opportunity/depth values. No low-opportunity threshold or dominance criterion was introduced.

## Hypotheses and limits

Conditional suppression, aggressiveness, tour style, unmeasured opponent strength, selection, opportunity mix and measurement differences remain hypotheses. Saved counts measure DF/opportunities and history composition, not aggression or style. Correlation shifts and concurrent composition changes cannot identify causes. A formula and orientation reconciliation does not validate every provider statistic independently. Neutral-slot class means are cohort summaries, not intervention effects.

No refit, rescue method, sign constraint, threshold, exclusion, imputation, interval, replacement factor, source repair or prediction change occurred. All uncertainty and source-label availability/overlap limitations remain. Small dependent cohorts, unequal history depth, absent 2022 and lack of independent-season ATP evidence prevent stronger conclusions. No 2024/2025 access, acquisition, new dependency, OTD work, portfolio modification, publication or push is authorized by this diagnostic.

## Reproduction, outputs and verification

Run `Rscript R/diagnose_m05_direction.R` and `Rscript R/test_m05_direction.R` from the repository root. Both use base R and existing SHA-256/Git utilities. The diagnostic makes no fitting, optimization, resampling or model-selection calls. Changed/missing inputs, wrong count ownership, altered frozen coefficients/scaling or conflicting releases fail closed.

Exactly four ignored local CSVs are installed atomically under `data/pilot/m05-direction-diagnostic/`: fold-diagnostics (18 rows), target-diagnostics (1,278), group-summary (568), summary (1,994). Every row retains convention, chronology and uncertainty labels. Match-level values remain local; no redistribution permission follows. Staging corruption/interruption cannot install a partial release; an existing release must reproduce byte-for-byte. The committed change is exactly the two R files, this report, PROJECT_CONTEXT.md, current status and data-source contract.

All 2,301 focused checks passed: fifteen pins, exact fold/target/slot and prior-membership accounting, own M05 formula and denominators, sample-SD scaling, frozen coefficient/probability reconstruction, slot-swap behavior, complete groups and cumulative profiles, corruption failures, input permutation invariance, byte-identical reruns and atomic installation. Twenty-three local links/anchors, cross-document agreement, whitespace, exact six-file scope and four ignored outputs were checked. All 298 other pre-existing tracked files and pilot artifacts retain their hashes; historical status/contract content is preserved. Outputs and the diff were inspected. No historical suite was rerun or repinned. No execution failure or unresolved implementation warning occurred; deliberate invalid-input/interruption fixtures failed as expected.

## One next executable step

Recommend **Phase 2U: documentation-only M05 factor interpretation review**, using the complete frozen Phase 2R/2T evidence and existing factor-selection rules. Its deliverable should decide whether M05's second-serve-security interpretation remains defensible provisionally or requires a separately authorized revision phase, with explicit tour-specific limitations and no mechanical coefficient-sign rule. It must not refit, change factor status automatically, search for favorable subgroups, or implement replacements. The next task must define its exact documentation scope.

Exact approval: **“Approve Phase 2U: a documentation-only M05 factor interpretation review using frozen Phase 2R and Phase 2T evidence and existing selection rules. Assess whether to retain the provisional interpretation or propose a separately approved revision, without refitting, changing factors or predictions, adding thresholds, acquiring data, or accessing 2024/2025.”**

## Ignored output fingerprints

| File | SHA-256 |
| --- | --- |
| fold-diagnostics.csv | `72047fb77fa2f65444f0810c6df33968f0b7417463905a71efca41d60c800a84` |
| group-summary.csv | `99baf971da9edd1396854c33e9ad349ac952ace87832a03ea5773fe95fbe2dd8` |
| summary.csv | `2106f3e3d0c54a1b080630cc2cb9615ae446b0027a803c433fa5791982b73a2d` |
| target-diagnostics.csv | `0ac441bf190ba00872d63611eb0cc93498b813ef841a54c0cdb82315f2df157d` |
