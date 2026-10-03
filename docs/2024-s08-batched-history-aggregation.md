# Phase 2AD: 2024 cumulative S08 batch histories

## Result and scope

**2024_S08_BATCH_HISTORIES_AGGREGATED**, version **2AD-1.0.0**, implemented from clean `a31d675cf310b47f75eb678d91d146c0ba6e045e`. All **1,901 targets and 3,802 neutral slots** remain. The [builder](../R/aggregate_2024_s08_batch_histories.R) pools the **101,983** contributions in the frozen [Phase 2AC membership release](2024-event-batch-membership-audit.md), without selecting a window or changing eligibility.

Every output retains **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED**. These are provisional S08 features for a source-label validation sensitivity, not fitted models, final factors or verified historical forecasts.

## Inputs and reused formulas

The [Phase 2N implementation](../R/aggregate_s08_batch_histories.R) and [report](s08-batched-history-aggregation.md#implementation-and-input-boundary) supply the unchanged component, count-ownership, pooling, difference, summary and installation functions. They are imported through an explicit pure-function allowlist: no historical top-level verification, runner or suite executes. New literal pins protect Phase 2N code/tests/report/outputs, Phase 2AC code/tests/report/outputs and the [frozen 2024 protocol](2024-validation-protocol.md#factor-construction-and-fitting-safeguards); inherited Phase 2AC pins protect admitted effective-count ledgers, both source-cohort origins and admission evidence. No historical pin is replaced.

Before aggregation, rebuild Phase 2AC metadata and the complete membership/empty ledger from its pinned admissions and require exact agreement. Missing, extra, duplicate, substituted or same/later-batch links fail closed. Raw annual files and network endpoints are not opened. Qualified DEVELOPMENT/VALIDATION_2024 keys disambiguate count joins internally; original match IDs are restored in both output tables alongside the qualified key. The historical Phase 2M-only validator is replaced at the adapter boundary by this complete Phase 2AC validator; no membership safeguard is waived.

Only records actually referenced as eligible prior contributors enter count parsing. For each, frozen neutral player IDs and a_original_side must agree with the effective winner/loser columns, admitted status and game reconciliation. Required counts must be finite nonnegative integers and satisfy the inherited component inequalities. The same player's own counts and opponent counts are oriented before pooling. Target-only outcomes and counts are not parsed for its feature. A 2024 match's counts can properly affect later-batch targets once that match is an eligible prior contributor. Admission is frozen, not re-evaluated in perturbation tests.

| Component | Pooled numerator | Pooled denominator |
| --- | --- | --- |
| M03 | Own first-serve points won | Own first serves in |
| M05 | Own double faults | Own service points minus first serves in |
| M11 | Opponent break points faced | Opponent service games |
| M12 | Opponent break points faced minus saved | Opponent break points faced |

Sum counts before division; never average match rates. **M05 is Double-Fault Rate per Second-Serve Opportunity**, lower-is-better, with A-minus-B differences left unreversed. It measures one error component, not total second-serve effectiveness or aggression; its tour-specific forecast interpretation remains unresolved. M11 is an intensity that may exceed one; no cap applies. M12 remains conversion/execution, not established resilience or clutch performance. No smoothing, weighting, window, decay, sign transform, imputation or new threshold is introduced.

Empty histories have undefined sums/rates with EMPTY_HISTORY and the inherited empty detail. A nonempty pooled zero denominator retains its observed numerator/denominator and ZERO_POOLED_DENOMINATOR, with an undefined rate. Differences require both slot rates and retain every applicable slot reason. No target outcome is exported.

## Measured availability and history depth

| Tour | Targets / slots | Empty histories | M03/M05/M11 defined slots, each | M12 defined slots | M03/M05/M11 differences, each | M12 / full-S08 / reduced-component complete targets |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 944 / 1,888 | 71 | 1,817 | 1,813 | 875 | 871 / 871 / 871 |
| WTA | 957 / 1,914 | 45 | 1,869 | 1,869 | 912 | 912 / 912 / 912 |
| Total | 1,901 / 3,802 | 116 | 3,686 | 3,682 | 1,787 | 1,783 / 1,783 / 1,783 |

Four additional nonempty ATP slots have zero pooled M12 opportunity; WTA has none. All four are B slots with one prior match each: two Australian Open targets and two Miami targets. M03/M05/M11 have no nonempty zero-denominator case. M12 therefore has 120 undefined slot rates, including 116 empty histories, and 118 undefined target differences: 73 ATP and 45 WTA. Empty histories affect 69 ATP and 45 WTA targets; the four additional zero-opportunity target cases do not overlap those empty-target cases. Undefined rates stay NA in the CSVs.

Complete full-S08 vectors cover **871/944 ATP** and **912/957 WTA**, total **1,783/1,901**; the 118 incomplete targets remain present with reasons. Reduced-component availability is reported as a diagnostic only. The output both_candidates_feature_complete flag equals full-S08 completeness exactly: both future candidates must use that same feature-eligible set plus the protocol's later readiness and numerical gates. There is no enlarged reduced-model cohort, and feature completeness does not establish prediction availability. The both/one/neither complete-player-history strata are ATP 871/71/2 and WTA 912/45/0, or 1,783/116/2 overall.

Thirty WTA M11 slot rates exceed one, maximum **1.25**; ATP has none above one, maximum **0.9230769231**. These valid intensities remain uncapped. M03/M05/M12 remain within [0,1] where defined. No count repair, missing-value replacement or new exclusion is made.

History depths retain Phase 2AC inventory counts, including empty slots: ATP minimum/median/maximum **0/19/71**, WTA **0/27/115**. Contributions remain 41,138 ATP and 60,845 WTA. Missing 2022 and unequal development depth persist: ATP has admitted 2023 records, WTA admitted 2021 and 2023, plus each tour's eligible earlier 2024 batches. Missing records are not inactivity or zero performance. There is no surface filter; surface summaries describe targets only.

## Outputs and verification

Exactly three ignored outputs reside under data/pilot/2024-s08-batched-history-aggregation/:

- slot-history-aggregates.csv: 3,802 rows, pooled numerators/denominators, rates, undefined reasons, prior-match counts and first/last source labels per neutral slot.
- target-s08-features.csv: 1,901 rows, original and qualified IDs, A/B rates, A-minus-B differences, reasons, full/reduced-component availability and the shared full-S08 feature-completeness flag. No target outcome.
- summary.csv: 816 rows, metric/slot/difference availability, undefined reasons, value ranges and depth by overall scope, tour, season, batch, event cell and target surface. Repeated group-level full/reduced counts are labels for that group, not additive across metric/slot rows. Difference reason counts can overlap; undefined counts each target once.

| Output | SHA-256 |
| --- | --- |
| slot-history-aggregates.csv | `18d8f6f9a1bf2422e1a083479d00be64336cabb0d5f3303a5ca962f22942e65d` |
| target-s08-features.csv | `712cb89b5acd85af54306019a4c160171d9cd443777cba5587ad3e8975e7b883` |
| summary.csv | `ca293aa88c380ebcdc5d0e70c5b6404a23e1207339343360164638208fbde61f` |

All outputs retain source-label, chronology and uncertainty warnings, the new release version and canonical M05 name. The inherited atomic installer checks ignore coverage and input pins, stages exactly three nonempty files, rechecks bytes/pins, then renames the complete directory. Identical reruns are retained; differing existing outputs or corrupted/interrupted stages fail without overwrite.

The [focused tests](../R/test_2024_s08_batch_histories.R) independently reconstruct every pooled numerator/denominator directly from effective winner/loser columns through player-ID joins and grouped sums, then every rate and difference. They cover ownership, strict ledger agreement, exclusions/cutoffs, empty/zero opportunities, unequal-denominator pooling, uncapped M11, full-S08 eligibility, row permutations, target-slot swaps, target/later count-outcome irrelevance for the target batch, and an earlier-count positive control. Independent processes and atomic failure fixtures validate deterministic installation. **117 focused checks plus four installed-release checks passed**; a fresh process reproduced all three installed files byte-for-byte and identical reinstallation preserved them. All outputs, tour/batch summaries and the diff were inspected. Thirty-seven local links/anchors, documentation agreement, whitespace and exact six-file scope pass. All 353 other pre-existing tracked files, pilot artifacts and manifested raw/metadata files retain their SHA-256 hashes; historical status/contract bodies are preserved. No data discrepancy was found and no historical suite was rerun or repinned.

## Limits and one next approval

S02 stays paused and S08 provisional; canonical M05 and its unresolved forecast direction remain unchanged. Source labels do not prove actual match timing, nonoverlap or historical statistic availability. Retrospective source/completion/count admission, missing seasons, unequal histories and official recall UNKNOWN remain. These features provide no model performance, weights, uncertainty estimate or superiority claim. No Elo, fitting, scoring, acquisition, 2025, dependency, OTD, publication or portfolio work occurred.

Recommend **Phase 2AE: implement only the frozen 2024 synchronous surface-Elo benchmarks and coverage audit**, carrying forward verified Phase 2P terminal states and applying the unchanged 2024 protocol. Produce no model scores or factor fits.

Exact approval: **“Approve Phase 2AE: implement the frozen 2024 event-batched surface Elo and overall-only benchmarks, carrying forward verified Phase 2P terminal states and using the frozen admitted v2 cohort. Preserve pre-batch probabilities, synchronous updates, all-target coverage and full-S08 completeness strata. Do not tune, fit S08, score models, acquire data, access 2025, add dependencies, resume OTD or modify the portfolio.”** The next prompt must define exact files, ignored outputs and acceptance tests.
