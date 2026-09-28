# Phase 2A: Four Factors candidate-metric feasibility

**Development-only descriptive audit. Decision: GO_TO_FACTOR_DEFINITION_PROTOCOL.** This supports designing a later protocol, not selecting four factors, fitting regressions, clearing forecasting chronology or claiming generalization.

## Scope and provenance

Started clean at `baf27f397d18481e374b0e7ce528ffe5dc5a74eb`, `Define analytical path after pausing OTD`. The user approved the revised Phase 2A scope. Exactly 86 immutable input/code/contract files are fingerprint-checked; the complete local provenance table records paths, SHA-256, sizes and roles.
Four annuals only: ATP/WTA 2021 and 2023 at archive 83733587353df8a41f2fd4f516147d5aa83f5a8d. Saved annual/reference manifests retain source URLs, access dates, licensing and original hashes. No external state was refreshed. Prior event inventories and Montreal policy layers are reconstructed from pinned evidence, not accepted from old summary labels alone. The separate overlay is reconstructed and compared with its existing release.
The audit uses ATP/WTA Indian Wells 2023 and WTA Montreal 2021, main-draw singles, hard courts. All 40 source candidate cells remain in the inventory; 37 remain UNVETTED_NONPILOT with missing completed denominators and source-field availability only. Source numeric scores never establish their eligibility.

## Eligibility and coverage

| cell_id | source_rows | inventory_rows | completed_denominator | retirements | walkovers | quarantine | valid_bundles | original_valid_bundles | recovery_bundles | event_90pct |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ATP / 2023 / Indian Wells | 95.00 | 95.00 | 91.00 | 4.000 | 0 | 0 | 91.00 | 91.00 | 0 | PASS_NUMERICAL_ONLY |
| WTA / 2021 / Canada | 55.00 | 55.00 | 49.00 | 5.000 | 1.000 | 0 | 49.00 | 42.00 | 7.000 | PASS_NUMERICAL_ONLY |
| WTA / 2023 / Indian Wells | 95.00 | 95.00 | 92.00 | 2.000 | 1.000 | 1.000 | 91.00 | 91.00 | 0 | PASS_NUMERICAL_ONLY |

The 245 inventory records remain auditable: 232 completed, 11 RET and two WO. One completed WTA Indian Wells bundle remains wholly quarantined, leaving 231 valid bundles. No statistics or derived win indicator from the quarantined record enter diagnostics. Its verified raw result remains in the inventory and completed denominator. Montreal preserves 42 original and seven separately supported bundles, with all 126 original source fields still missing. No recovery is imputation or raw-source repair.
Unresolved conflicts would stop the entire audit. Adopted ATP PDF dissent, Montreal status omissions/scheduled metadata and WTA quarantine reasons remain preserved. No conflict is silently voted away. The 90% event numerical floor is unchanged; 95% tour-season coverage is NOT_TESTED and event admission remains NOT_EVALUATED. Local orientation orders stable source IDs, preserves original winner/loser sides and is not a global canonical identity table.

## Methods fixed before diagnostics

M01–M15 follow the unchanged [Phase 1T formula catalogue](post-otd-analytical-path.md#candidate-catalogue). U1 distinguishes zero_opportunities, missing_input and invalid_bundle; known invalidity takes precedence over missingness. Incomplete whole bundles are withheld. RET/WO use separate eligibility exclusion reasons. Lower-is-better metrics retain their original sign. No value is imputed.
Primary associations use one A-minus-B row per match. Pearson (point-biserial for binary same-match win) and Spearman correlations report exact pair counts plus a common-complete sensitivity. Correlations require at least three finite pairs and nonconstant variables. For Spearman only, inputs are rounded to 12 decimal places before average-tie ranking so floating-point noise cannot split algebraically equal rates; metric values and Pearson inputs retain full precision. Repeated players remain dependent; no p-values, significance tests, causal effects or forecast scores are estimated.
Small denominators are described by their observed positive minimum and quantiles, never an eligibility threshold. A fixed descriptive sensitivity removes values at or below the within-group lower quartile (type 1) of the smaller A/B denominator. Absolute correlation at least 0.95 labels possible near duplication only; every pair is reported and no candidate is selected by that label. Numerical near-constant tolerance is sqrt(machine epsilon) times max(1, absolute mean). SVD rank uses max(n,p) times machine epsilon times the largest singular value. These are computational/diagnostic conventions, not tuned factor choices.

## Metric availability and missingness

Counts below are defined player-side values, so the maximum is twice the valid match count. Association sample sizes below remain match counts. All unavailable completed statistical values outside the quarantine are zero-opportunity ratios, not missing-count imputations.
| group | metric | defined | zero_opportunities | missing_input | invalid_bundle |
| --- | --- | --- | --- | --- | --- |
| cell:ATP / 2023 / Indian Wells | M01 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M01 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M01 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M02 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M02 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M02 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M03 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M03 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M03 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M04 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M04 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M04 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M05 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M05 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M05 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M06 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M06 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M06 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M07 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M07 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M07 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M08 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M08 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M08 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M09 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M09 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M09 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M10 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M10 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M10 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M11 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M11 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M11 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M12 | 170.0 | 12.00 | 0 | 0 |
| cell:WTA / 2021 / Canada | M12 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M12 | 178.0 | 4.000 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M13 | 170.0 | 12.00 | 0 | 0 |
| cell:WTA / 2021 / Canada | M13 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M13 | 178.0 | 4.000 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M14 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M14 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M14 | 182.0 | 0 | 0 | 2.000 |
| cell:ATP / 2023 / Indian Wells | M15 | 182.0 | 0 | 0 | 0 |
| cell:WTA / 2021 / Canada | M15 | 98.00 | 0 | 0 | 0 |
| cell:WTA / 2023 / Indian Wells | M15 | 182.0 | 0 | 0 | 2.000 |

Raw field and metric missingness are reported separately by cell/tour, season, event, surface, side and count origin. Original Montreal omissions remain visible even after separate recovery supports a metric. Missing source-field causes in the 37 unvetted cells are not invented. Missingness classes distinguish opportunity-related structural NA, unknown-cause raw missingness, invalid quarantine and eligibility exclusions.

## Denominator and distribution findings

| group | metric | slot | min | q1 | median | max | zero_opportunities | sample_minimum_positive_count |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| tour:ATP | M01 | a | 34.00 | 56.00 | 67.00 | 124.0 | 0 | 1.000 |
| tour:ATP | M01 | b | 41.00 | 58.00 | 68.00 | 131.0 | 0 | 1.000 |
| tour:ATP | M02 | a | 34.00 | 56.00 | 67.00 | 124.0 | 0 | 1.000 |
| tour:ATP | M02 | b | 41.00 | 58.00 | 68.00 | 131.0 | 0 | 1.000 |
| tour:ATP | M03 | a | 18.00 | 32.50 | 39.00 | 93.00 | 0 | 1.000 |
| tour:ATP | M03 | b | 23.00 | 33.00 | 41.00 | 87.00 | 0 | 2.000 |
| tour:ATP | M04 | a | 5.000 | 21.00 | 28.00 | 44.00 | 0 | 1.000 |
| tour:ATP | M04 | b | 12.00 | 21.00 | 28.00 | 50.00 | 0 | 1.000 |
| tour:ATP | M05 | a | 5.000 | 21.00 | 28.00 | 44.00 | 0 | 1.000 |
| tour:ATP | M05 | b | 12.00 | 21.00 | 28.00 | 50.00 | 0 | 1.000 |
| tour:ATP | M06 | a | 34.00 | 56.00 | 67.00 | 124.0 | 0 | 1.000 |
| tour:ATP | M06 | b | 41.00 | 58.00 | 68.00 | 131.0 | 0 | 1.000 |
| tour:ATP | M07 | a | 5.000 | 20.00 | 24.00 | 43.00 | 0 | 1.000 |
| tour:ATP | M07 | b | 12.00 | 18.50 | 25.00 | 45.00 | 0 | 1.000 |
| tour:ATP | M08 | a | 41.00 | 58.00 | 68.00 | 131.0 | 0 | 1.000 |
| tour:ATP | M08 | b | 34.00 | 56.00 | 67.00 | 124.0 | 0 | 1.000 |
| tour:ATP | M09 | a | 23.00 | 33.00 | 41.00 | 87.00 | 0 | 2.000 |
| tour:ATP | M09 | b | 18.00 | 32.50 | 39.00 | 93.00 | 0 | 1.000 |
| tour:ATP | M10 | a | 12.00 | 21.00 | 28.00 | 50.00 | 0 | 1.000 |
| tour:ATP | M10 | b | 5.000 | 21.00 | 28.00 | 44.00 | 0 | 1.000 |
| tour:ATP | M11 | a | 7.000 | 9.000 | 10.00 | 18.00 | 0 | 4.000 |
| tour:ATP | M11 | b | 7.000 | 9.000 | 10.00 | 18.00 | 0 | 1.000 |
| tour:ATP | M12 | a | 1.000 | 4.000 | 6.000 | 20.00 | 9.000 | 6.000 |
| tour:ATP | M12 | b | 1.000 | 4.000 | 6.000 | 17.00 | 3.000 | 6.000 |
| tour:ATP | M13 | a | 1.000 | 4.000 | 6.000 | 17.00 | 3.000 | 6.000 |
| tour:ATP | M13 | b | 1.000 | 4.000 | 6.000 | 20.00 | 9.000 | 6.000 |
| tour:ATP | M14 | a | 7.000 | 9.000 | 10.00 | 18.00 | 0 | 1.000 |
| tour:ATP | M14 | b | 7.000 | 9.000 | 10.00 | 18.00 | 0 | 4.000 |
| tour:ATP | M15 | a | 34.00 | 56.00 | 67.00 | 124.0 | 0 | 1.000 |
| tour:ATP | M15 | b | 41.00 | 58.00 | 68.00 | 131.0 | 0 | 1.000 |
| tour:WTA | M01 | a | 35.00 | 57.00 | 72.50 | 137.0 | 0 | 1.000 |
| tour:WTA | M01 | b | 36.00 | 58.00 | 73.50 | 125.0 | 0 | 1.000 |
| tour:WTA | M02 | a | 35.00 | 57.00 | 72.50 | 137.0 | 0 | 1.000 |
| tour:WTA | M02 | b | 36.00 | 58.00 | 73.50 | 125.0 | 0 | 1.000 |
| tour:WTA | M03 | a | 17.00 | 33.75 | 45.00 | 90.00 | 0 | 1.000 |
| tour:WTA | M03 | b | 17.00 | 34.00 | 45.50 | 75.00 | 0 | 1.000 |
| tour:WTA | M04 | a | 10.00 | 22.00 | 29.00 | 67.00 | 0 | 1.000 |
| tour:WTA | M04 | b | 8.000 | 23.00 | 29.00 | 56.00 | 0 | 1.000 |
| tour:WTA | M05 | a | 10.00 | 22.00 | 29.00 | 67.00 | 0 | 1.000 |
| tour:WTA | M05 | b | 8.000 | 23.00 | 29.00 | 56.00 | 0 | 1.000 |
| tour:WTA | M06 | a | 35.00 | 57.00 | 72.50 | 137.0 | 0 | 1.000 |
| tour:WTA | M06 | b | 36.00 | 58.00 | 73.50 | 125.0 | 0 | 1.000 |
| tour:WTA | M07 | a | 7.000 | 19.00 | 25.00 | 66.00 | 0 | 1.000 |
| tour:WTA | M07 | b | 7.000 | 18.75 | 25.00 | 50.00 | 0 | 1.000 |
| tour:WTA | M08 | a | 36.00 | 58.00 | 73.50 | 125.0 | 0 | 1.000 |
| tour:WTA | M08 | b | 35.00 | 57.00 | 72.50 | 137.0 | 0 | 1.000 |
| tour:WTA | M09 | a | 17.00 | 34.00 | 45.50 | 75.00 | 0 | 1.000 |
| tour:WTA | M09 | b | 17.00 | 33.75 | 45.00 | 90.00 | 0 | 1.000 |
| tour:WTA | M10 | a | 8.000 | 23.00 | 29.00 | 56.00 | 0 | 1.000 |
| tour:WTA | M10 | b | 10.00 | 22.00 | 29.00 | 67.00 | 0 | 1.000 |
| tour:WTA | M11 | a | 7.000 | 9.000 | 11.00 | 18.00 | 0 | 6.000 |
| tour:WTA | M11 | b | 6.000 | 9.000 | 11.00 | 18.00 | 0 | 1.000 |
| tour:WTA | M12 | a | 1.000 | 6.000 | 8.000 | 22.00 | 3.000 | 2.000 |
| tour:WTA | M12 | b | 1.000 | 6.000 | 8.000 | 29.00 | 1.000 | 2.000 |
| tour:WTA | M13 | a | 1.000 | 6.000 | 8.000 | 29.00 | 1.000 | 2.000 |
| tour:WTA | M13 | b | 1.000 | 6.000 | 8.000 | 22.00 | 3.000 | 2.000 |
| tour:WTA | M14 | a | 6.000 | 9.000 | 11.00 | 18.00 | 0 | 1.000 |
| tour:WTA | M14 | b | 7.000 | 9.000 | 11.00 | 18.00 | 0 | 6.000 |
| tour:WTA | M15 | a | 35.00 | 57.00 | 72.50 | 137.0 | 0 | 1.000 |
| tour:WTA | M15 | b | 36.00 | 58.00 | 73.50 | 125.0 | 0 | 1.000 |

Second-serve denominators include double faults; M07 alone explicitly conditions them out. No double subtraction occurs in M04. Break-point zero opportunities mean undefined performance, not poor performance. M11/M14 are opportunities per game and can exceed one. All selected bundles pass nonnegative-integer, count-bound and applicable service-game/score/tie-break checks; paired point reconciliation is algebraic and does not independently prove source accuracy.
A-minus-B distributions follow (full side-specific and origin-specific tables remain local):

| group | metric | n | min | q1 | median | mean | q3 | max | sd |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| tour:ATP | M01 | 91.00 | -0.1816 | -0.06442 | -0.008756 | -0.006509 | 0.04628 | 0.2500 | 0.07837 |
| tour:ATP | M02 | 91.00 | -0.2222 | -0.06693 | -0.01321 | -0.001781 | 0.06244 | 0.3281 | 0.1066 |
| tour:ATP | M03 | 91.00 | -0.3886 | -0.1093 | -0.03587 | -0.006598 | 0.07955 | 0.4783 | 0.1680 |
| tour:ATP | M04 | 91.00 | -0.5452 | -0.1528 | 0.02632 | -0.0007195 | 0.1303 | 0.4107 | 0.1966 |
| tour:ATP | M05 | 91.00 | -0.3215 | -0.05417 | 0.009524 | 0.01333 | 0.07276 | 0.2857 | 0.1020 |
| tour:ATP | M06 | 91.00 | -0.1799 | -0.02096 | 0.007384 | 0.005508 | 0.03269 | 0.1384 | 0.04686 |
| tour:ATP | M07 | 91.00 | -0.5000 | -0.1272 | 0.03728 | 0.007702 | 0.1485 | 0.4494 | 0.1981 |
| tour:ATP | M08 | 91.00 | -0.2632 | -0.1141 | -0.03095 | -0.004284 | 0.1150 | 0.4412 | 0.1473 |
| tour:ATP | M09 | 91.00 | -0.3886 | -0.1093 | -0.03587 | -0.006598 | 0.07955 | 0.4783 | 0.1680 |
| tour:ATP | M10 | 91.00 | -0.5452 | -0.1528 | 0.02632 | -0.0007195 | 0.1303 | 0.4107 | 0.1966 |
| tour:ATP | M11 | 91.00 | -1.455 | -0.4091 | -0.05417 | -0.05498 | 0.4444 | 1.222 | 0.5779 |
| tour:ATP | M12 | 79.00 | -0.8750 | -0.2500 | 0 | 0.03066 | 0.2500 | 1.000 | 0.3686 |
| tour:ATP | M13 | 79.00 | -0.8750 | -0.2500 | 0 | 0.03066 | 0.2500 | 1.000 | 0.3686 |
| tour:ATP | M14 | 91.00 | -1.222 | -0.4444 | 0.05417 | 0.05498 | 0.4091 | 1.455 | 0.5779 |
| tour:ATP | M15 | 91.00 | -0.2632 | -0.1141 | -0.03095 | -0.004284 | 0.1150 | 0.4412 | 0.1473 |
| tour:WTA | M01 | 140.0 | -0.1198 | -0.03533 | -0.0002904 | -0.002301 | 0.03202 | 0.1325 | 0.05287 |
| tour:WTA | M02 | 140.0 | -0.2936 | -0.07224 | -0.0006389 | -0.001134 | 0.07225 | 0.2639 | 0.1176 |
| tour:WTA | M03 | 140.0 | -0.4250 | -0.09585 | -0.01483 | -0.0004796 | 0.09632 | 0.4444 | 0.1610 |
| tour:WTA | M04 | 140.0 | -0.6167 | -0.08866 | 0.01326 | -0.01171 | 0.09472 | 0.3628 | 0.1618 |
| tour:WTA | M05 | 140.0 | -0.3121 | -0.1081 | -0.007474 | -0.01303 | 0.07225 | 0.3000 | 0.1310 |
| tour:WTA | M06 | 140.0 | -0.1397 | -0.04131 | -0.006756 | -0.004477 | 0.03343 | 0.1088 | 0.05677 |
| tour:WTA | M07 | 140.0 | -0.6571 | -0.1056 | 0.01279 | -0.02070 | 0.09363 | 0.4186 | 0.1795 |
| tour:WTA | M08 | 140.0 | -0.3746 | -0.09554 | -0.006713 | -0.004648 | 0.08026 | 0.3206 | 0.1303 |
| tour:WTA | M09 | 140.0 | -0.4250 | -0.09585 | -0.01483 | -0.0004796 | 0.09632 | 0.4444 | 0.1610 |
| tour:WTA | M10 | 140.0 | -0.6167 | -0.08866 | 0.01326 | -0.01171 | 0.09472 | 0.3628 | 0.1618 |
| tour:WTA | M11 | 140.0 | -2.000 | -0.3801 | -0.06667 | -0.07193 | 0.2516 | 1.336 | 0.5416 |
| tour:WTA | M12 | 136.0 | -0.7143 | -0.1522 | 0.02916 | 0.02790 | 0.2049 | 0.8889 | 0.3139 |
| tour:WTA | M13 | 136.0 | -0.7143 | -0.1522 | 0.02916 | 0.02790 | 0.2049 | 0.8889 | 0.3139 |
| tour:WTA | M14 | 140.0 | -1.336 | -0.2516 | 0.06667 | 0.07193 | 0.3801 | 2.000 | 0.5416 |
| tour:WTA | M15 | 140.0 | -0.3746 | -0.09554 | -0.006713 | -0.004648 | 0.08026 | 0.3206 | 0.1303 |

## Associations and mathematical coupling

| group | metric | pair_count | common_complete_matches | correlation | expected_direction | direction_agrees |
| --- | --- | --- | --- | --- | --- | --- |
| tour:ATP | M01 | 91.00 | 79.00 | 0.4518 | positive | TRUE |
| tour:ATP | M02 | 91.00 | 79.00 | 0.2303 | positive | TRUE |
| tour:ATP | M03 | 91.00 | 79.00 | 0.8080 | positive | TRUE |
| tour:ATP | M04 | 91.00 | 79.00 | 0.7356 | positive | TRUE |
| tour:ATP | M05 | 91.00 | 79.00 | -0.3311 | negative | TRUE |
| tour:ATP | M06 | 91.00 | 79.00 | -0.3261 | negative | TRUE |
| tour:ATP | M07 | 91.00 | 79.00 | 0.6871 | positive | TRUE |
| tour:ATP | M08 | 91.00 | 79.00 | 0.9822 | positive | TRUE |
| tour:ATP | M09 | 91.00 | 79.00 | 0.8080 | positive | TRUE |
| tour:ATP | M10 | 91.00 | 79.00 | 0.7356 | positive | TRUE |
| tour:ATP | M11 | 91.00 | 79.00 | 0.8059 | positive | TRUE |
| tour:ATP | M12 | 79.00 | 79.00 | 0.4179 | positive | TRUE |
| tour:ATP | M13 | 79.00 | 79.00 | 0.4179 | positive | TRUE |
| tour:ATP | M14 | 91.00 | 79.00 | -0.8059 | negative | TRUE |
| tour:ATP | M15 | 91.00 | 79.00 | 0.9822 | positive | TRUE |
| tour:WTA | M01 | 140.0 | 136.0 | 0.3314 | positive | TRUE |
| tour:WTA | M02 | 140.0 | 136.0 | 0.1778 | positive | TRUE |
| tour:WTA | M03 | 140.0 | 136.0 | 0.8495 | positive | TRUE |
| tour:WTA | M04 | 140.0 | 136.0 | 0.6971 | positive | TRUE |
| tour:WTA | M05 | 140.0 | 136.0 | -0.1772 | negative | TRUE |
| tour:WTA | M06 | 140.0 | 136.0 | -0.2438 | negative | TRUE |
| tour:WTA | M07 | 140.0 | 136.0 | 0.6580 | positive | TRUE |
| tour:WTA | M08 | 140.0 | 136.0 | 0.9946 | positive | TRUE |
| tour:WTA | M09 | 140.0 | 136.0 | 0.8495 | positive | TRUE |
| tour:WTA | M10 | 140.0 | 136.0 | 0.6971 | positive | TRUE |
| tour:WTA | M11 | 140.0 | 136.0 | 0.7090 | positive | TRUE |
| tour:WTA | M12 | 136.0 | 136.0 | 0.5046 | positive | TRUE |
| tour:WTA | M13 | 136.0 | 136.0 | 0.5046 | positive | TRUE |
| tour:WTA | M14 | 140.0 | 136.0 | -0.7090 | negative | TRUE |
| tour:WTA | M15 | 140.0 | 136.0 | 0.9946 | positive | TRUE |

The following complete tour-level comparison shows NPR versus equal-phase NPR, Pearson versus Spearman, and the external same-match win check. None measures future forecasting.

| group | metric | NPR_Pearson | equal_phase_Pearson | NPR_Spearman | same_match_win_Pearson | same_match_win_Spearman |
| --- | --- | --- | --- | --- | --- | --- |
| tour:ATP | M01 | 0.4518 | 0.4630 | 0.4279 | 0.2882 | 0.3068 |
| tour:ATP | M02 | 0.2303 | 0.1967 | 0.2082 | 0.1725 | 0.1482 |
| tour:ATP | M03 | 0.8080 | 0.8263 | 0.7760 | 0.5932 | 0.6136 |
| tour:ATP | M04 | 0.7356 | 0.7590 | 0.7648 | 0.6971 | 0.7492 |
| tour:ATP | M05 | -0.3311 | -0.3430 | -0.3054 | -0.3071 | -0.2717 |
| tour:ATP | M06 | -0.3261 | -0.3286 | -0.3125 | -0.2960 | -0.2641 |
| tour:ATP | M07 | 0.6871 | 0.7048 | 0.7024 | 0.6478 | 0.6773 |
| tour:ATP | M08 | 0.9822 | 1.000 | 0.9827 | 0.8099 | 0.8455 |
| tour:ATP | M09 | 0.8080 | 0.8263 | 0.7760 | 0.5932 | 0.6136 |
| tour:ATP | M10 | 0.7356 | 0.7590 | 0.7648 | 0.6971 | 0.7492 |
| tour:ATP | M11 | 0.8059 | 0.8508 | 0.8370 | 0.6929 | 0.7319 |
| tour:ATP | M12 | 0.4179 | 0.3184 | 0.4625 | 0.3620 | 0.3885 |
| tour:ATP | M13 | 0.4179 | 0.3184 | 0.4625 | 0.3620 | 0.3885 |
| tour:ATP | M14 | -0.8059 | -0.8508 | -0.8370 | -0.6929 | -0.7319 |
| tour:ATP | M15 | 0.9822 | 1.000 | 0.9827 | 0.8099 | 0.8455 |
| tour:WTA | M01 | 0.3314 | 0.3428 | 0.3509 | 0.3274 | 0.3375 |
| tour:WTA | M02 | 0.1778 | 0.1733 | 0.1705 | 0.06196 | 0.05391 |
| tour:WTA | M03 | 0.8495 | 0.8589 | 0.8187 | 0.6591 | 0.6957 |
| tour:WTA | M04 | 0.6971 | 0.6903 | 0.7211 | 0.5824 | 0.6139 |
| tour:WTA | M05 | -0.1772 | -0.1683 | -0.1823 | -0.1260 | -0.1227 |
| tour:WTA | M06 | -0.2438 | -0.2315 | -0.2270 | -0.1544 | -0.1449 |
| tour:WTA | M07 | 0.6580 | 0.6560 | 0.6513 | 0.5605 | 0.5909 |
| tour:WTA | M08 | 0.9946 | 1.000 | 0.9953 | 0.7727 | 0.8384 |
| tour:WTA | M09 | 0.8495 | 0.8589 | 0.8187 | 0.6591 | 0.6957 |
| tour:WTA | M10 | 0.6971 | 0.6903 | 0.7211 | 0.5824 | 0.6139 |
| tour:WTA | M11 | 0.7090 | 0.7371 | 0.7081 | 0.5869 | 0.6196 |
| tour:WTA | M12 | 0.5046 | 0.4724 | 0.4519 | 0.3755 | 0.3639 |
| tour:WTA | M13 | 0.5046 | 0.4724 | 0.4519 | 0.3755 | 0.3639 |
| tour:WTA | M14 | -0.7090 | -0.7371 | -0.7081 | -0.5869 | -0.6196 |
| tour:WTA | M15 | 0.9946 | 1.000 | 0.9953 | 0.7727 | 0.8384 |

Equal-phase NPR equals 100*dM15 and 100*dM08 exactly: perfect association there is an identity. Ordinary NPR also shares service/return point counts but weights the phases by opportunities. A high correlation with either outcome is not evidence of independent factor validity. Source-ID orientation is reproducible but arbitrary; these signed associations must not be interpreted as player-level causal effects.

## Redundancy and matrix diagnostics

Exactly: dM03=dM09, dM04=dM10, dM08=dM15, dM11=-dM14, dM12=dM13. Opponent complements therefore collapse several proposed serve/return and conversion/recovery measures into identical differences. M06=M05*(1-M02), M04=M07*(1-M05), and M15=M02*M03+(1-M02)*M04 where defined are additional nonlinear within-side identities. They do not imply corresponding linear identities between differences.
| group | common_complete_n | columns | constant_columns | near_constant_columns | rank | condition_number | effective_condition | state |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| tour:ATP | 79.00 | 15.00 |  |  | 10.00 |   Inf | 34.51 | rank_deficient |
| tour:WTA | 136.0 | 15.00 |  |  | 10.00 |   Inf | 40.28 | rank_deficient |
| cell:ATP / 2023 / Indian Wells | 79.00 | 15.00 |  |  | 10.00 |   Inf | 34.51 | rank_deficient |
| cell:WTA / 2021 / Canada | 49.00 | 15.00 |  |  | 10.00 |   Inf | 41.52 | rank_deficient |
| cell:WTA / 2023 / Indian Wells | 87.00 | 15.00 |  |  | 10.00 |   Inf | 42.25 | rank_deficient |

Infinite condition numbers denote rank deficiency; effective condition describes only the nonzero singular subspace. No regression or factor weights were fitted. Pair counts for every metric pair are retained in redundancy-map.csv. Additional abs(Pearson r)>=0.95 pairs without a proved exact difference identity:

| group | metric_a | metric_b | pair_count | correlation |
| --- | --- | --- | --- | --- |
| tour:ATP | M05 | M06 | 91.00 | 0.9722 |

## Sensitivity findings

Maximum absolute NPR Pearson-correlation changes across the full candidate set are summarized below; all candidates, outcomes and both methods remain in the local sensitivity table. No favorable sensitivity was selected. Leave-one-match results store correlation ranges and maximum changes without exposing match identities in this report. Dropping the sole event from an event-specific group is explicitly insufficient, not zero effect.

| group | scenario | max_abs_change |
| --- | --- | --- |
| tour:WTA | exclude_event:WTA / 2021 / Canada | 0.08886 |
| tour:WTA | exclude_event:WTA / 2023 / Indian Wells | 0.2049 |
| tour:ATP | exclude_lower_denominator_quartile | 0.2380 |
| tour:WTA | exclude_lower_denominator_quartile | 0.2267 |
| tour:ATP | exclude_recovery | 0 |
| tour:WTA | exclude_recovery | 0.01527 |
| tour:ATP | leave_one_match_range | 0.04703 |
| tour:WTA | leave_one_match_range | 0.04179 |

Recovery exclusion removes seven Montreal matches while preserving source provenance. It also removes the later-round source gap, so any difference is confounded with round/player selection, not a causal recovery effect. Leave-event comparisons in WTA confound event with season. Denominator-tail removal changes the analyzed population and is diagnostic only.

## Interpretation and limits

All 15 formulas are computable and auditable where their denominators exist. Serve Creation and Second-Serve Security contain distinguishable measured quantities (serve frequency, aces, double faults and conditional point success); this does not establish distinct latent mechanisms or future utility. Return success differences repeat opponent serve success differences exactly. Conversion and Recovery does not yield two independent difference measures: conversion and saving are identical; pressure exposure also duplicates opponent break-chance generation with opposite sign. Non-perfect correlations with general service success do not establish incremental clutch skill. The nine counts cannot supply expected conversion/saving residuals or point-level leverage.
ATP/WTA comparisons above are observable descriptions of these hard-court pilot samples only. WTA combines two events/seasons and ATP one. Sampling, opponents, repeated players, round coverage, statistical-source dependence and mathematical coupling prevent broad inference. Uncertainty intervals and opponent adjustment are not estimated.
Surface stability: NOT_ASSESSABLE. Independent ATP season stability: NOT_ASSESSABLE. Independent WTA event-versus-season stability: NOT_ASSESSABLE. Clay/grass generalization, out-of-time factor stability, forecast calibration, superiority to Elo, canonical panel coverage and causal/clutch interpretation are not established.
Four distinct factors are not demonstrated. The successful audit and explicit redundancies support designing a later factor-definition protocol that can reject or replace candidates rather than force four. The decision is not that these are the final four factors.

## Decision and exact next user decision

**GO_TO_FACTOR_DEFINITION_PROTOCOL** means documentation/design next, not model implementation. Exact next approval question: "Do you approve an offline factor-definition protocol, using the Phase 2A findings to specify nonredundant candidate comparisons, opportunity/missingness rules, uncertainty and later chronological validation, while selecting no final factors, fitting no coefficients, acquiring no data and leaving forecasting blocked?"
The protocol must distinguish conditional point outcomes from serve creation/pressure mechanisms and specify how Conversion and Recovery could fail. No new formula replacement, sample threshold, history window, dependency or method is approved by this audit.
OTD remains PAUSED_BY_USER_AFTER_PHASE_1S. Q6/Q8/Q9/Q10 remain PENDING_USER_APPROVAL; Q1/Q2/Q11 remain pending; Q3/Q4 are completed documentation-only approvals and Q5/Q7/Q12 completed specification/feasibility only. Match-sequential forecasting remains primary; all 2,377 previously identified conditional dependencies still lack verified release support.
Later missing-data comparisons remain complete cases/no imputation, mean, justified mean-plus-indicator and PMM multiple imputation, fitted only inside chronological training/resamples. No outcomes are imputed. Freeze all selection/settings before 2025; documented safeguards are not proof of avoiding overfitting. No 2022/2024/2025 data, network, source acquisition, Elo, histories, forecasts, portfolio edit, publication or push occurred.

## Outputs and reproduction

| output | rows |
| --- | --- |
| input-provenance.csv | 86.00 |
| cell-coverage.csv | 40.00 |
| eligibility-audit.csv | 245.0 |
| candidate-dictionary.csv | 15.00 |
| match-metrics.csv | 245.0 |
| metric-availability.csv | 360.0 |
| missingness-summary.csv | 1080. |
| denominator-summary.csv | 360.0 |
| distribution-summary.csv | 540.0 |
| association-summary.csv | 900.0 |
| redundancy-map.csv | 1050. |
| matrix-diagnostics.csv | 5.000 |
| sensitivity-summary.csv | 1890. |
| summary.csv | 18.00 |

All CSVs are local and ignored under data/pilot/four-factors-candidate-metric-feasibility/. Eligibility and match-metric rows are restricted and never committed. CSV diagnostics use 12 significant digits, decimal point, explicit NA, stable order and no timestamps; calculations retain double precision. Existing identical outputs retain bytes and modification times. Changed existing outputs are refused pending review, never partially replaced. Input/mapping failures stop before publication of a new audit.
```sh
Rscript R/audit_four_factors_candidate_metrics.R
Rscript R/test_four_factors_candidate_metrics.R
```

See [current status](status.md), [source contract](data-source-contract.md), [standing research guidance](../PROJECT_CONTEXT.md) and [tests](../R/test_four_factors_candidate_metrics.R). Verification results are recorded in status. This private audit report grants no public derivative-data permission. Future response-only ChatGPT handoffs remain no more than 2,000 words.
