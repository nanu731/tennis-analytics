# Phase 2AE: 2024 synchronous surface Elo benchmark

## Result and scope

**2024_SURFACE_ELO_BENCHMARK_BUILT**, release **2AE-1.0.0**, from `287974aa50c7fe76e2e19ee67fc32473c8f1cad5`. Both frozen benchmarks provide finite probabilities for all **1,901 admitted targets: 944 ATP and 957 WTA**, covering ten source-date batches and ten event cells per tour. No prediction loss, accuracy, calibration or candidate ranking is calculated.

The [builder](../R/build_2024_surface_elo_baseline.R) implements the [frozen 2024 protocol](2024-validation-protocol.md#rolling-prequential-source-label-chronology) using [Phase 2P arithmetic](surface-elo-baseline-audit.md) and [Phase 2AD completeness](2024-s08-batched-history-aggregation.md#measured-availability-and-history-depth). This is a **2024 source-label validation sensitivity**. Every output preserves **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED**.

## Development-state reconciliation and input boundary

Seventeen new literal pins protect Phase 2P code/tests/report/three outputs, Phase 2AC code/three outputs, Phase 2AD code/tests/report/three outputs and the frozen validation protocol. Twenty inherited Phase 2AC pins additionally protect admission, provenance and chronology authorities. Allowlisted pure helper definitions are imported; no historical runner, authority repinning or historical test suite executes.

Before parsing 2024 tables, reconstruct development metadata and outcome ownership from pinned admitted membership/dispositions. Replay the unchanged Phase 2P arithmetic over its 2,580 targets. Serialized predictions, all 5,532 ledger rows and summary reproduce the three saved files **byte-for-byte**. Validate unique state keys, finite states, positive contribution counts, count continuity, before-plus-delta identities and each player's successive state chain. A failure stops processing before 2024.

Derive the actual starting states from the last saved ledger row for each tour/player and tour/player/surface. ATP retains **193 overall and 388 surface states**; WTA retains **267 overall and 599 surface states**. Saved before/after chains have **zero residual**. The largest difference between parsed terminal CSV ratings and replay's in-memory values is **5.002221e-12**, consistent with serialization rounding and below the inherited **1e-10 numerical tolerance**. Saved ledger values, rather than a reset or fresh season initialization, seed 2024. This tolerance is an arithmetic check, not a scientific effect threshold.

Then require the frozen 2024 v2 membership, Phase 2AC target metadata, source-date labels, neutral identities, target surfaces and Phase 2AD feature flags to agree. Admitted outcome orientation must match frozen winner/loser ownership, source-reported normal completion, no quarantine and passed service-game reconciliation. Original and cohort-qualified target IDs are preserved. No raw annual data, source endpoint or 2025 path is opened. Phase 2AC prior-match counts must equal the carried-forward overall rating exposure at every target slot.

## Unchanged benchmark arithmetic

For each tour independently, unseen overall G and player-surface S states start at **1500**. With `P(A)=1/(1+10^((R_B-R_A)/400))`, primary R is **0.5G+0.5S** and the sole sensitivity uses G. Calculate the logistic probability of blended ratings, not an average of probabilities. Surface expectations for updates use S alone; overall expectations use G alone.

Within each same-tour/source-date batch, first freeze every target's states and both probabilities. Only then calculate `32*(outcome-component_expectation)` for each match/component; the opponent receives its negative. Sum canonical match-ID-ordered contributions per player and per player/surface, then apply them after the entire simultaneous batch. Sorting stabilizes floating-point summation only; it is not inferred chronology. Unused surfaces stay unchanged. No clipping, averaging, within-batch updates, reset, decay, inactivity, prestige, format, margin adjustment or tuning occurs.

All 1,901 admitted results update later states, including all 118 factor-incomplete targets. Frozen exclusions never predict or contribute. No missing S08 value is filled by Elo initialization. Current-batch outcomes cannot affect that batch's probabilities; earlier-batch outcomes can affect later probabilities as intended.

## Measured coverage and diagnostics

Probability ranges below refer to neutral **A**; B receives the exact complement, with no claim that A is the winner or favorite.

| Tour | Targets | Primary A probability range | Overall-only A probability range | Overall cold slots | Surface cold slots | S08 both / one / neither complete |
| --- | ---: | --- | --- | ---: | ---: | --- |
| ATP | 944 | 0.10581817–0.8822854 | 0.07137046–0.9080906 | 71 | 243 | 871 / 71 / 2 |
| WTA | 957 | 0.08218498–0.8929676 | 0.05674497–0.9125334 | 45 | 149 | 912 / 45 / 0 |

Overall cold-start target strata (both/one/neither cold) are ATP **2/67/875**, WTA **0/45/912**. Surface cold-start strata are ATP **36/171/737**, WTA **9/131/817**. Cold-slot counts are target-slot occurrences, not counts of distinct players; simultaneous matches can repeat the same initially unseen state.

Full-S08 completeness remains **1,783/116/2** both/one/neither complete histories, exactly Phase 2AD. Both later factor candidates require the same full-vector eligibility plus their separate frozen fit gates; Elo coverage does not establish factor prediction availability or create a larger reduced-model cohort. All 118 incomplete targets remain in coverage.

The ledger contains **3,962 update rows**: ATP 990 overall + 990 surface, WTA 991 + 991. Each component has **3,802 player-match contributions**, ATP 1,888 and WTA 1,914. ATP surface contributions are 586 Clay, 238 Grass and 1,064 Hard; WTA 612, 244 and 1,058. Maximum accumulated absolute delta is **125.45569 ATP** and **101.95802 WTA**. Batch sums may legitimately exceed K=32 and are not clipped. There are 149 ATP and 162 WTA accumulated changes above 32 in absolute value. Maximum batch/component/surface net residuals are **7.105427e-14 ATP** and **1.278977e-13 WTA**, below 1e-10. Maximum before-plus-delta residual is 1.136868e-13. No nonfinite or boundary probability occurs.

Coverage and update summaries include tour, season, source-date batch, event cell, surface and all three S08 strata, including zero-size strata. They describe admitted source-record availability, not official event coverage; official recall stays UNKNOWN.

## Outputs and validation

Exactly three ignored outputs under data/pilot/2024-surface-elo-baseline/:

- target-elo-probabilities.csv: 1,901 neutral target rows, pre-batch G/S/blended ratings, both A/B probabilities, overall/surface prior counts and cold flags, batch metadata and S08 stratum. **No outcome columns.**
- rating-update-ledger.csv: 3,962 player-batch/component rows with before state, prior matches, batch contribution count/IDs, accumulated delta, after state and after count. This ledger is outcome-derived and remains local.
- summary.csv: 252 (204 coverage and 48 update) coverage/update rows with development reconciliation fields on tour/ALL coverage rows. All rows carry version, chronology and uncertainty labels.

| Output | SHA-256 |
| --- | --- |
| target-elo-probabilities.csv | `3a945231e7e24bb866904958469b551662be6ec0bdb2b449a462720090127eca` |
| rating-update-ledger.csv | `6c46ac9a9ff93b5bf00cf9f6b959215426f7d9b7206c43373588a885a7c099a6` |
| summary.csv | `21931bd5b74e7e6d2c64ac7ab9da14d91b47032e24d5a50490fe6d82ef85ce35` |

The [focused tests](../R/test_2024_surface_elo_baseline.R) check input pins, exact development replay, corrupted-state failure, independent component delta reconstruction, before-state joins, complete target/update accounting, formulas, blend semantics, neutral swaps, cold states, exact S08 strata, actual-batch outcome perturbations, permutations and a same-date multi-event/multi-surface fixture. Atomic interruption, corrupted staging and conflicting existing releases fail without overwrite. Independent-process reruns must reproduce all three files byte-for-byte. **125 focused checks and four installed-release checks passed.** A fresh process reproduced all three installed files byte-for-byte; identical reinstallation retained their bytes. Every target/update record was inspected for missing values, and tour/batch coverage and surface updates were reviewed. All 252 summary rows were independently reconciled. Thirty-nine local links/anchors, current-document agreement, whitespace, exact six-file tracked scope and three-file ignored scope pass. All 359 other pre-existing tracked files, pilot artifacts and manifested raw/metadata files retain their SHA-256 hashes; historical status/contract bodies are unchanged. The outputs and complete diff were inspected. No historical suite was rerun or repinned; no unresolved data or arithmetic discrepancy was found.

## Limits and one next approval

Source labels do not establish actual match timing, nonoverlap or historical information availability. Missing 2022, unequal development depth, retrospective admission and source incompleteness persist. S02 stays paused; S08 provisional. M05 remains **Double-Fault Rate per Second-Serve Opportunity**, lower-is-better, with unresolved tour-specific forecast interpretation. No model fitting, scoring, tuning, acquisition, dependency, OTD, portfolio or publication work occurred; 2025 remains locked. No performance, uncertainty or superiority claim follows.

Recommend **Phase 2AF: implement the already frozen 2024 full/reduced whole-batch factor fits and paired validation**, using the existing histories and these Elo probabilities, with no candidate search or changed gate.

Exact approval: **“Approve Phase 2AF: implement the frozen 2024 rolling whole-batch full-S08 and reduced-model fits and paired descriptive evaluation using frozen histories and Phase 2AE Elo probabilities. Preserve identical full-S08-complete training eligibility, the four-model paired mask, all-target coverage, readiness/failure gates and the frozen selection/abstention map. Retain source-label and uncertainty limitations. Do not tune, rescue failed folds, change factors or eligibility, acquire data, access 2025, add dependencies, resume OTD or modify the portfolio.”** A next prompt must specify exact code, tests, report, ignored outputs and acceptance checks.
