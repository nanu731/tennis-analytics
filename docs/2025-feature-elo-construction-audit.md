# Phase 2AK: locked 2025 feature and Elo construction

## Result and scope

**2025_FEATURES_AND_ELO_CONSTRUCTED**, release **2AK-1.0.0**, from clean `433c12f689dee1fa080647b3132ba89d7c6a9785`. All **3,756 player slots and 1,878 neutral targets** are preserved. Full-S08 feature availability is **951 ATP / 826 WTA**; both frozen Elo benchmarks provide finite probabilities for every target. No factor model was fitted or scored.

This is a **2025 locked source-label final-test sensitivity**, conditional on the unchanged 1,878 Phase 2AH admissions: 1,011 ATP targets across ten cells and 867 WTA across eight. **WTA Canada and Cincinnati remain wholly excluded.** All twenty expected cells remain in the summary inventory; no full-ten-family WTA or official complete-event claim follows. The [locked protocol](2025-locked-final-test-protocol.md) and [Phase 2AI scope decision](2025-source-conflict-review.md) remain unchanged.

## Frozen implementation

The [builder](../R/build_2025_features_elo.R) imports explicitly allowlisted pure functions from the [Phase 2AD aggregation](../R/aggregate_2024_s08_batch_histories.R), Phase 2N component helpers, [Phase 2AE Elo](../R/build_2024_surface_elo_baseline.R) and Phase 2P arithmetic. No historical runner or test suite is executed or repinned. Sixty-eight literal input/authority fingerprints are checked before processing and before installation. The approved five-output location must already be ignored.

Before any 2025 processing, replay the entire saved development and 2024 Elo releases and compare all three outputs from each with their frozen serialized bytes. Join development and 2024 update chains; check before/delta/after, exposure counts, unique state keys, contribution membership and terminal values under the inherited 1e-10 tolerance. Carry states untouched in 2024 instead of treating them as unseen. Reconciliation fails closed without a reset or repair.

The reconstructed terminal inventory is ATP 248 overall / 552 surface states and WTA 298 / 695. It retains 42 ATP and 102 WTA overall states, plus 107 ATP and 251 WTA surface states, untouched since development. Combined saved-chain and serialized Phase 2AE replay residuals are zero. The required predecessor replay also passes its unchanged numerical tolerance. No prior state or feature vector is rewritten.

The [Phase 2AJ membership release](2025-event-batch-membership-audit.md) is independently reconstructed and compared exactly before count pooling. Cohort-qualified keys distinguish development, 2024 v2 and 2025 while preserving original match IDs. Only admitted effective counts belonging to actual prior contributors enter pooling. Match and player-side joins are checked against frozen ownership; outcomes select original count orientation, never target feature eligibility. Target-only counts do not enter that target's features.

Pool counts across each exact frozen target-slot membership before dividing:

| Metric | Pooled numerator | Pooled denominator |
| --- | --- | --- |
| M03 | Own first-serve points won | Own first serves in |
| M05 | Own double faults | Own service points minus first serves in |
| M11 | Opponent break points faced | Opponent service games |
| M12 | Opponent break points faced minus saved | Opponent break points faced |

Empty-history counts and rates stay undefined. Nonempty zero-denominator rates retain ZERO_POOLED_DENOMINATOR. M11 remains uncapped; M05 remains **Double-Fault Rate per Second-Serve Opportunity**, lower-is-better, measuring one error component. Target features are neutral A-minus-B differences without reversing M05. Reduced-component availability is diagnostic only: both future factor candidates retain full-S08-complete eligibility. No imputation, smoothing, weighting, window, surface restriction or decay is introduced.

Elo uses unseen G/S initialization 1500, base-10 logistic scale 400, K=32, primary rating 0.5G+0.5S and overall-only G. Each component's update uses its own pre-batch expectation. Freeze all probabilities for each tour/source-date batch, canonically sum match-level deltas per player/component, then apply after the entire simultaneous batch. Never average, clip or update sequentially. All admitted records update, including factor-incomplete matches; excluded records never predict or update. Overall exposure counts reconcile to Phase 2AJ history depths. Target surfaces select the applicable saved surface state; unused surfaces persist.

## Measured availability and diagnostics

All 146,374 Phase 2AJ membership links enter the corresponding pooled components exactly once per target slot. Empty histories remain 59 ATP / 43 WTA slots. Their history depths retain the Phase 2AJ median/maximum of 30/108 ATP and 39/163 WTA.

| Tour | Full-S08 both / one / neither complete | Complete full-vector targets | Reduced-component complete targets | Overall / surface cold slots |
| --- | --- | ---: | ---: | --- |
| ATP | 951 / 60 / 0 | 951 | 951 | 59 / 154 |
| WTA | 826 / 39 / 2 | 826 | 826 | 43 / 106 |

Thus 1,777 targets have complete full-S08 vectors; all 101 incomplete targets remain in coverage and update Elo. Reduced availability happens to equal full availability, but both candidates' eligibility is explicitly tied to the full vector, not inferred from that equality. Completeness does not establish future fit readiness or scored coverage.

| Tour / component | Defined slot rates | Undefined: empty / zero denominator | Defined A-minus-B differences |
| --- | ---: | --- | ---: |
| ATP M03 | 1,963 / 2,022 | 59 / 0 | 952 / 1,011 |
| ATP M05 | 1,963 / 2,022 | 59 / 0 | 952 / 1,011 |
| ATP M11 | 1,963 / 2,022 | 59 / 0 | 952 / 1,011 |
| ATP M12 | 1,962 / 2,022 | 59 / 1 | 951 / 1,011 |
| WTA each of M03/M05/M11/M12 | 1,691 / 1,734 | 43 / 0 each | 826 / 867 each |

One nonempty ATP history has zero pooled opponent break-point opportunities; M12 stays undefined. Six WTA slot-level M11 rates exceed one, maximum 1.1470588, and remain uncapped. These are expected denominator/intensity behaviors, not repairs or exclusions. No other nonempty zero-denominator case occurs.

| Tour | Primary probability range | Overall-only range | Update rows | Player-match contributions per component | Maximum batch balance residual |
| --- | --- | --- | ---: | ---: | ---: |
| ATP | 0.04350516–0.9359782 | 0.03197426–0.9520380 | 2,126 | 2,022 | 1.740830e-13 |
| WTA | 0.05688785–0.9347542 | 0.04663970–0.9516224 | 1,774 | 1,734 | 1.492140e-13 |

No nonfinite or boundary probability occurs. The ledger has 3,900 player-batch/component updates and 3,756 player-match contributions per component. Maximum absolute accumulated deltas are 114.62350 ATP overall / 110.06731 surface and 109.85620 WTA overall / 126.91889 surface: sums are intentionally allowed to exceed K=32. In-memory batch balances are shown above. After CSV serialization, the largest before/delta/after residual is 1.005063e-11, below the unchanged 1e-10 tolerance.

All 190 blocked 2025 WTA PM records and six ATP format conflicts contribute zero feature links, probabilities or updates. The exact 2024 PM admissions remain historical contributors; no 2025 exception transfers. Eighteen admitted source-date batches are processed. The twenty-cell inventory retains 95 excluded records and zero targets for each blocked WTA cell; absent targets are not manufactured or counted as cold starts.

## Outputs and verification

Exactly five ignored outputs under data/pilot/2025-feature-elo-construction/ contain slot aggregates, target S08 features, target Elo probabilities, the player-batch update ledger and a combined summary. Slot/feature/probability outputs omit outcomes. Every output carries the source-label sensitivity, chronology failure, uncertainty, provisional-factor and failed M05 interpretation labels. The summary combines component availability, S08 strata, Elo coverage/update diagnostics, terminal reconciliation and all twenty admission cells; zero-target WTA cells remain explicit rather than becoming cold-start observations.

| Output | Rows | SHA-256 |
| --- | ---: | --- |
| slot-history-aggregates.csv | 3,756 | `8794843f9aa1fdb304c764faac025b6d4ecaec94f66a537676d8f760bd6db7f1` |
| target-s08-features.csv | 1,878 | `2a356f435dfa1863fc9383b24e923d86c68d3e5baaf917504b78f99628475882` |
| target-elo-probabilities.csv | 1,878 | `2ec3df6b8214f3f878b468001784d4bd3363f68b3accb95a31badaf33f2ca4d0` |
| rating-update-ledger.csv | 3,900 | `3033a245a534ba8b6e07b0c87238a52c64d15564fe2fba2cea4126d5435a24c4` |
| summary.csv | 1,008 | `07a9461734c56040fbdd3c3c56c0847ad8219047fe3010e4faea9dbd19e46a90` |

The [focused tests](../R/test_2025_features_elo.R) independently reconstruct every pooled component and rate through a player-owned count join and grouped sums; verify neutral differences, undefined rates, uncapped intensity, exact membership and all exclusions; and exercise invalid memberships, slot swaps, permutations and earlier-count positive controls. Current/later batch count and outcome corruption cannot enter the selected batch's features. Separate outcome perturbations in every actual batch preserve all probabilities through that batch. Independent ledger arithmetic checks every component expectation, summed delta, contributing ID, prior state and count; a simultaneous multi-event/multi-surface fixture tests unclipped accumulation and an untouched surface. Global slot swaps complement probabilities and preserve updates.

Fresh R processes independently reconcile prior releases and rebuild all outputs. Atomic tests cover interruption, staged-byte corruption, identical reinstall and refusal to overwrite differing releases. Pre-release test development corrected a generated helper-name typo and a local test helper that shadowed base R's get(); neither changed numerical rules or historical artifacts. No protocol/input mismatch or statistical rescue was introduced.

**263 focused checks pass**, followed by **six installed-output checks** against another independent process. All five outputs and tour/batch/surface/cell summaries were inspected. Exact six-file tracked and five-file ignored scope, documentation agreement, 48 local links/anchors and whitespace pass. All **396 historical fingerprints** remain unchanged, including Phase 2AJ, Phase 2AD, Phase 2AE, admissions, the locked protocol, raw sources and historical outputs. Historical status and contract bodies are preserved. No historical suite was rerun or repinned.

## Limits and one next approval

Membership and probability construction do not establish actual historical availability or resolve event overlaps. Retain NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE, UNCERTAINTY_NOT_ESTABLISHED, official recall UNKNOWN, missing 2022 and unequal histories. S02 stays paused, S08 provisional and reduced remains a three-factor comparator. M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED remains binding; favorable future replication cannot qualify full S08 as final Four Factors. Neither factor model was fitted or scored; no loss, accuracy, calibration or ranking was calculated. Admission, exclusions, prior releases, raw sources and the portfolio are unchanged. No acquisition, dependency, OTD or publication work occurred.

Recommend **Phase 2AL: locked 2025 factor fitting and four-method final evaluation**, using these frozen features/probabilities and original development/2024 training vectors. Retain every admitted target in coverage, identical full-S08 eligibility and one common four-method scoring mask. Preserve separate tours, rolling whole-batch training, frozen readiness/failure precedence and every locked loss, calibration and deletion decision rule. This recommendation grants no fitting or scoring permission by itself.

Exact approval: “Approve Phase 2AL to fit the frozen full S08 and reduced models and evaluate all four methods on the unchanged 1,878 admitted 2025 targets under the locked protocol, using Phase 2AK features and Elo probabilities. Preserve identical eligibility, all failure and comparison rules, partial-WTA disclosures and the binding M05 limitation. Do not tune, rescue, change eligibility, acquire data or select a model.”
