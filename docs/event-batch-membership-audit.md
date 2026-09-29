# Phase 2M: event-batched candidate history membership

Version 1.0.0. Implemented offline in base R from clean `main` at `13718231cb6c04144d2235030142a9438d39662a`, under the explicit Phase 2M approval and [Phase 2L convention](source-label-event-batching-decision.md).

**SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** applies to every output row. Phase 2K remains **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**. This release inventories candidate dependencies under assumed source-label availability; it is not a verified historical information set, aggregated feature history, rating or forecast. S02 stays paused and S08 provisional.

## Implemented selection and input boundary

Fourteen literal SHA-256 pins cover the active instructions/context, adopted convention, Phase 2H code/test/report and six audit outputs, and the Phase 2J/2K reports. The runner verifies them before processing and installation. It reads only the frozen Phase 2H membership and disposition CSVs, retaining exactly 2,580 admitted targets and 30 event cells. The disposition ledger preserves the original source `tourney_date`; no annual file, 2024/2025 data or external source is opened. Saved-use authority is inherited from the frozen audit and current task, not a new rights grant.

The pure builder verifies exact membership, neutral player IDs, context and original source locators. It checks every disposition row in a target cell, including excluded rows, for missing/invalid labels, label/year mismatch and conflicting event labels. A failure stops the whole new release with a reason; it never repairs labels or shrinks the cohort. Calendar syntax is validated only to compare the eight-digit labels. No actual date/time, timezone, duration, elapsed interval or inactivity feature is inferred.

Each batch is exactly `(tour, source tourney_date)`. For each target and each neutral player slot, select every admitted match in the same tour involving that exact player in either prior slot, with a strictly earlier source label. All earlier eligible batches are inventoried; no last-K, elapsed-time, surface-only or other window is selected. A source match can appear in many target histories, and can appear for both target players when both participated: these are distinct target-player memberships, not duplicate source records.

A direct earlier-label filter avoids mutable intermediate state. Same-date and later records cannot enter a target's inventory; same-tour same-date events share the cutoff even if their names or surfaces differ. Row, event and within-batch serialization order cannot affect membership. Scores, winners/losers, counts, rankings and outcomes are outside the builder's selection/output-field whitelist. Frozen admission is not re-evaluated from perturbed score/count fields in semantic tests; changed real input bytes would separately fail the pin guard.

All frozen exclusions remain unavailable as contributions, including retirements/partial statistics, walkovers, quarantines and service-game conflicts. The existing seven admitted Montreal recovery bundles retain their count-origin tag; no count aggregation or expanded recovery occurs. The 152 Phase 2J targets with undefined same-match M12 differences remain among the 2,580 targets because metric computability does not change membership.

## Measured results and units

There are **30 batches: 10 ATP and 20 WTA**, one event cell per batch in this saved cohort. No same-tour same-date event ties occur empirically; synthetic shared-player, same-date events test that required behavior. Matching ATP/WTA date labels remain separate keys.

There are **56,999 candidate memberships**, plus **805 explicit empty-history rows**, for **57,804 rows** in the candidate ledger. These cover all **5,160 target-player slots**. A zero history count is an observed inventory cardinality, not a zero statistic, initialized rating or imputed feature.

| Tour | Targets | Target-player slots | Memberships A / B | Empty slots A / B | Targets with either slot empty | Both empty |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 846 | 1,692 | 5,568 / 5,706 | 158 / 198 | 227 | 129 |
| WTA | 1,734 | 3,468 | 24,053 / 21,672 | 191 / 258 | 314 | 135 |
| Total | 2,580 | 5,160 | 29,621 / 27,378 | 349 / 456 | 541 | 264 |

Thus ATP has 11,274 memberships and 356 empty slots; WTA has 45,725 and 449. There are 4,355 nonempty slots, 2,039 targets with both slots nonempty, and 277 with exactly one empty slot. The largest inventories contain 35 ATP or 72 WTA prior matches for a target-player slot. No threshold, warm-up eligibility rule or initialization is chosen from those counts.

Each empty slot gets `EMPTY_HISTORY`, a blank prior-match/batch identifier and `NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT`. The detail is `TOUR_FIRST_OBSERVED_BATCH` for 504 slots (252 per tour) or `PLAYER_FIRST_OBSERVED_BATCH` for 301 (104 ATP, 197 WTA). Cold starts mean no earlier admitted record in this saved inventory, not a career debut or proof that no earlier match was played. Repeated targets for one player in their first batch remain cold throughout that batch.

| Tour | Surface of target | Targets | Memberships A / B | Empty slots A / B |
| --- | --- | ---: | ---: | ---: |
| ATP | Clay | 305 | 1,994 / 2,167 | 17 / 40 |
| ATP | Grass | 56 | 543 / 560 | 2 / 6 |
| ATP | Hard | 485 | 3,031 / 2,979 | 139 / 152 |
| WTA | Clay | 530 | 6,870 / 6,184 | 22 / 32 |
| WTA | Grass | 192 | 3,016 / 2,465 | 7 / 17 |
| WTA | Hard | 1,012 | 14,167 / 13,023 | 162 / 209 |

Surface groups describe targets; membership is not restricted to prior matches on that surface. WTA 2023 inventories can include admitted WTA 2021 matches because the approved inventory uses all earlier labels. Missing 2022 data and unobserved matches are not filled or interpreted as inactivity.

## Every batch and event

Every event cell is shown below. Dates are **source labels only**. A/B counts refer to neutral target slots. No same-batch, later-batch, cross-tour or excluded contribution was found.

| Tour | Source label | Event | Surface | Targets | Memberships A / B | Empty slots A / B |
| --- | --- | --- | --- | ---: | ---: | ---: |
| ATP | 20230116 | Australian Open | Hard | 126 | 0 / 0 | 126 / 126 |
| ATP | 20230306 | Indian Wells | Hard | 91 | 183 / 195 | 5 / 14 |
| ATP | 20230320 | Miami | Hard | 89 | 391 / 356 | 1 / 3 |
| ATP | 20230424 | Madrid | Clay | 94 | 433 / 488 | 4 / 15 |
| ATP | 20230508 | Rome | Clay | 92 | 654 / 652 | 4 / 10 |
| ATP | 20230529 | Roland-Garros | Clay | 119 | 907 / 1027 | 9 / 15 |
| ATP | 20230703 | Wimbledon | Grass | 56 | 543 / 560 | 2 / 6 |
| ATP | 20230807 | Canada | Hard | 54 | 642 / 725 | 4 / 2 |
| ATP | 20230814 | Cincinnati | Hard | 50 | 731 / 825 | 0 / 0 |
| ATP | 20230828 | US Open | Hard | 75 | 1084 / 878 | 3 / 7 |
| WTA | 20210208 | Australian Open | Hard | 126 | 0 / 0 | 126 / 126 |
| WTA | 20210322 | Miami | Hard | 89 | 173 / 180 | 9 / 21 |
| WTA | 20210429 | Madrid | Clay | 58 | 239 / 271 | 1 / 2 |
| WTA | 20210510 | Rome | Clay | 51 | 292 / 309 | 0 / 0 |
| WTA | 20210531 | Roland-Garros | Clay | 119 | 643 / 608 | 9 / 14 |
| WTA | 20210628 | Wimbledon | Grass | 100 | 776 / 733 | 5 / 10 |
| WTA | 20210809 | Canada | Hard | 49 | 526 / 555 | 1 / 1 |
| WTA | 20210816 | Cincinnati | Hard | 49 | 646 / 634 | 0 / 1 |
| WTA | 20210830 | US Open | Hard | 93 | 1018 / 968 | 5 / 8 |
| WTA | 20211006 | Indian Wells | Hard | 91 | 1213 / 1010 | 2 / 7 |
| WTA | 20230116 | Australian Open | Hard | 127 | 1708 / 1343 | 12 / 29 |
| WTA | 20230306 | Indian Wells | Hard | 91 | 1476 / 1319 | 2 / 4 |
| WTA | 20230320 | Miami | Hard | 92 | 1506 / 1515 | 1 / 6 |
| WTA | 20230424 | Madrid | Clay | 93 | 1710 / 1440 | 3 / 6 |
| WTA | 20230508 | Rome | Clay | 90 | 1632 / 1560 | 3 / 4 |
| WTA | 20230529 | Roland-Garros | Clay | 119 | 2354 / 1996 | 6 / 6 |
| WTA | 20230703 | Wimbledon | Grass | 92 | 2240 / 1732 | 2 / 7 |
| WTA | 20230807 | Canada | Hard | 53 | 1565 / 1571 | 2 / 0 |
| WTA | 20230814 | Cincinnati | Hard | 52 | 1798 / 1569 | 0 / 0 |
| WTA | 20230828 | US Open | Hard | 100 | 2538 / 2359 | 2 / 6 |

## Outputs and acceptance checks

Only three ignored files are installed under `data/pilot/event-batch-membership/`:

- `target-batches.csv`: 2,580 rows, one per frozen target, with batch key, source-label/context/provenance, neutral player IDs and per-slot membership counts/empty reasons.
- `candidate-history-membership.csv`: 57,804 rows, containing 56,999 eligible links and 805 explicit empty placeholders. Each link identifies the target slot/player and prior match, batch, label, cell and matching prior slot. Empty placeholders do not count as contributions.
- `summary.csv`: 216 rows, partitioning membership and cold-start counts by overall scope, tour, season, batch, event cell and target surface, with ALL/A/B slot views. Match-level either/both-empty counts are `NOT_APPLICABLE` in the single-slot summaries.

The output location was already ignored before work began. The runner refuses an unignored destination. It writes all three files to a temporary sibling staging directory, verifies their complete scope, sizes and unchanged staged bytes plus input pins, then installs the complete directory with a single rename. Interrupted/corrupted staging cannot expose a partial final directory. An existing identical release is preserved; different bytes or extra files cause a stop, never overwrite. Scratch fault tests exercise these behaviors separately from the real Git-ignore guard.

Focused validation covers all required invariants, including an independent all-pairs player join for exact membership completeness, synthetic same-date events and cross-tour player-ID collisions, both target/prior slots, empty reasons, frozen exclusions, label failures, row/event/batch permutations, slot swapping, outcome/count perturbations and a positive earlier-linkage control. Tests also cover deterministic complete reruns, atomic failure/corruption injection, exact five-file tracked scope and prior-artifact preservation. All **90 focused checks passed**. The installed outputs were inspected; all 270 other pre-existing tracked files and pilot artifacts retained their SHA-256 hashes. The historical status body remains unchanged. Documentation consistency, local links, whitespace, exact five-file tracked scope and exactly three ignored outputs were checked. No historical suite was rerun or repinned. A post-install inspection command initially called a nonexistent hash-helper name; the corrected inspection succeeded and required no output changes. The existing broad `docs/` ignore rule produced a staging warning; the intended documents were confirmed staged without changing ignore rules.

Installed SHA-256 fingerprints:

| Output | SHA-256 |
| --- | --- |
| target-batches.csv | `2a3f48b2a94eb416e730f5cbbc00f0f1a4798599141426a04b9a29c489407ea0` |
| candidate-history-membership.csv | `3aeb1496ffac182de49497d537bc0a38b952f26656560e0d0d1270e630682156` |
| summary.csv | `04d0cc5dfc1984d3d3aeb4641f08b195756669a29a58791a4958e52fd5ea9246` |

Only the new R builder, R tests, this report, current status and contract are changed. `PROJECT_CONTEXT.md`, the Phase 2L decision and all completed reports/recommendations remain unchanged; their implementation recommendation is now fulfilled to this bounded membership stage. Future phase tests must respect their historical authority hashes rather than silently refresh them.

## Remaining limits and one next step

The availability assumption is unchanged: different-label events may overlap and earlier results/statistics may not actually have been available before later play. Phase 2K's chronology failure remains visible in every output. Frozen source-defined selection, absent matches, unequal tour/season breadth, structural opportunities and retrospective completion conditioning remain limitations. No membership row establishes verified historical availability, feature adequacy or operational readiness. Fold-safe model preprocessing and rating updates are not implemented or tested as models here; these batch keys only provide a common information-cutoff interface.

No factor aggregation, Elo, initialization, imputation, model fitting, timestamp inference, new dependency/source/year, acquisition, 2024/2025 access, OTD, publication or portfolio modification occurred. S02 stays paused, S08 provisional, and uncertainty is not established by this inventory.

Recommend **Phase 2N: bounded cumulative count aggregation for provisional S08**, using these frozen earlier-batch memberships. Prespecify pooling eligible historical numerators and denominators rather than averaging match ratios; retain cold starts and zero-opportunity rates as undefined. This would implement an explicit all-earlier-batch descriptive baseline, not choose a last-K window, fit weights or validate forecasting.

Exact approval language: **“Approve Phase 2N: implement offline cumulative earlier-batch count aggregation for provisional S08 from the frozen Phase 2M memberships under SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY. Pool the approved component numerators and denominators, preserve all targets and neutral slots, and keep empty histories and zero-opportunity rates undefined. Validate formulas, strict cutoffs, permutations and deterministic outputs. Do not acquire data, infer timestamps, impute, calculate Elo, fit models, choose weights, access 2024/2025 or modify the portfolio.”** The next prompt must define the exact tracked and ignored-output scope before implementation.
