# Phase 2N: cumulative event-batched S08 histories

Version 1.0.0. Implemented offline in base R from clean `main` at `b3ec4ff1447fe194e14fdbfedc636dce6db692ef`, under the explicit Phase 2N prompt and [Phase 2L convention](source-label-event-batching-decision.md). The [Phase 2M membership inventory](event-batch-membership-audit.md) supplies every contribution and empty-history placeholder.

**SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** applies to every output row. Phase 2K remains **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**. These are provisional S08 development features, not final factors, weights or verified historical forecasts. S02 stays paused; S08 stays provisional.

## Implementation and input boundary

Nine Phase 2N literal SHA-256 pins cover the Phase 2M builder/tests/report/three outputs, batching decision, registered formula catalogue and Phase 2J implementation. Fourteen inherited Phase 2M pins cover instructions/context, saved evidence and Phase 2H code/report/test/six outputs. Verify both sets before reading records and before output installation. Only saved Phase 2M target/membership ledgers and Phase 2H membership/dispositions are record inputs; no annual source file or 2024/2025 file is opened. Phase 2M pure definitions are reused for metadata and exact membership validation, without running its historical suite or replacing any output.

The builder requires exact frozen targets, identities and the complete Phase 2M link/empty ledger. Duplicate, missing, substituted, excluded or same/later-batch contributions fail closed. The pinned effective Phase 2H counts preserve admitted Montreal overlays and every exclusion. Winner/loser count columns are mapped through saved neutral player identities and side provenance; no winner indicator, score or target outcome becomes a feature. Counts are checked as finite nonnegative integers with the relevant component inequalities. Invalid inputs stop the release, never repair or shrink it.

For each target-player slot, pool each contributor exactly once, across **all** admitted strictly earlier batches of the same tour. There is no last-K, elapsed-time or surface restriction. The sums are integer count sums; floating-point division happens only after pooling, with deterministic ordering. Same-date events remain simultaneous and have no within-batch contribution.

| Metric | Pooled numerator | Pooled denominator | Meaning |
| --- | --- | --- | --- |
| M03 | Own first-serve points won | Own first serves in | First-serve success; higher |
| M05 | Own double faults | Own service points minus first serves in | Conditional double-fault rate; lower |
| M11 | Opponent break points faced | Opponent service games | Break chances per return game; higher, can exceed one |
| M12 | Opponent break points faced minus saved | Opponent break points faced | Break-point conversion/execution; higher, not established resilience or clutch |

These preserve the [registered component formulas](post-otd-analytical-path.md#candidate-catalogue). Match-level rates are never averaged. A rate is calculated only when its pooled denominator is positive. Empty histories have undefined sums and rates, `EMPTY_HISTORY`, and retained Phase 2M empty reason/detail; zero history cardinality is not an imputed statistic. Nonempty histories with zero opportunities retain observed zero counts and `ZERO_POOLED_DENOMINATOR`, with an undefined rate. Valid zero numerators with positive denominators produce observed zero rates.

Target differences are **A minus B**, defined only when both slot rates exist. M05 is not sign-reversed; its lower-is-better interpretation is explicit. Undefined differences list every applicable slot reason. No normalization, weighting, model, uncertainty interval or initialization is introduced.

## Measured availability and anomalies

All **2,580 targets**, **5,160 slots**, **30 event cells/batches** and **56,999 memberships** are preserved. There are **805 empty slots** (356 ATP, 449 WTA); 541 targets have at least one empty slot and 264 have both empty. These are inventory cold starts, not career debuts.

M03/M05/M11 are each defined for **4,355 slots** and **2,039 A-minus-B differences**. M12 is defined for **4,336 slots** and **2,026 differences**. Complete S08 difference vectors are available for **612 ATP and 1,414 WTA targets**; all other targets remain present with reasons. M12 has 19 nonempty zero-opportunity slots (9 ATP, 10 WTA), so total undefined M12 slots are 824. M12 is undefined for 554 targets: 541 involve empty histories, 19 involve zero opportunities, and six involve both. Reason-count columns may therefore overlap; `undefined` counts each target once.

**Measured unusual values:** 178 M11 slot rates exceed one (7 ATP, 171 WTA), with maxima 1.4444444444 and 1.4651162791 respectively. These are permitted return-pressure intensities, not invalid probabilities, and are not capped. M03/M05/M12 stay within [0,1] where defined. No invalid effective-count relation, duplicate contribution, same/later-batch or excluded contribution was found. Zero pooled denominators among nonempty histories occur only for M12; all 19 affected slots have exactly one contributing prior match. No admission rule or raw count changed.

| Tour | Metric | Slot | Defined / total | Undefined | Empty reason | Zero opportunity reason |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| ATP | M03 | a | 688 / 846 | 158 | 158 | 0 |
| ATP | M03 | b | 648 / 846 | 198 | 198 | 0 |
| ATP | M03 | difference | 619 / 846 | 227 | 227 | 0 |
| ATP | M05 | a | 688 / 846 | 158 | 158 | 0 |
| ATP | M05 | b | 648 / 846 | 198 | 198 | 0 |
| ATP | M05 | difference | 619 / 846 | 227 | 227 | 0 |
| ATP | M11 | a | 688 / 846 | 158 | 158 | 0 |
| ATP | M11 | b | 648 / 846 | 198 | 198 | 0 |
| ATP | M11 | difference | 619 / 846 | 227 | 227 | 0 |
| ATP | M12 | a | 681 / 846 | 165 | 158 | 7 |
| ATP | M12 | b | 646 / 846 | 200 | 198 | 2 |
| ATP | M12 | difference | 612 / 846 | 234 | 227 | 9 |
| WTA | M03 | a | 1543 / 1734 | 191 | 191 | 0 |
| WTA | M03 | b | 1476 / 1734 | 258 | 258 | 0 |
| WTA | M03 | difference | 1420 / 1734 | 314 | 314 | 0 |
| WTA | M05 | a | 1543 / 1734 | 191 | 191 | 0 |
| WTA | M05 | b | 1476 / 1734 | 258 | 258 | 0 |
| WTA | M05 | difference | 1420 / 1734 | 314 | 314 | 0 |
| WTA | M11 | a | 1543 / 1734 | 191 | 191 | 0 |
| WTA | M11 | b | 1476 / 1734 | 258 | 258 | 0 |
| WTA | M11 | difference | 1420 / 1734 | 314 | 314 | 0 |
| WTA | M12 | a | 1539 / 1734 | 195 | 191 | 4 |
| WTA | M12 | b | 1470 / 1734 | 264 | 258 | 6 |
| WTA | M12 | difference | 1414 / 1734 | 320 | 314 | 10 |

## Every batch/event and history depth

The actual cohort has one event cell per batch. Synthetic tied events test simultaneous behavior. Surface is a target grouping, not a history filter. Detailed metric/slot/reason partitions for every tour, season, batch, event and surface are in the summary output.

| Tour | Source label | Event | Surface | Targets | Complete S08 differences | Empty slots | Nonempty M12 zero-opportunity slots |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: |
| ATP | 20230116 | Australian Open | Hard | 126 | 0 | 252 | 0 |
| ATP | 20230306 | Indian Wells | Hard | 91 | 69 | 19 | 4 |
| ATP | 20230320 | Miami | Hard | 89 | 85 | 4 | 0 |
| ATP | 20230424 | Madrid | Clay | 94 | 75 | 19 | 0 |
| ATP | 20230508 | Rome | Clay | 92 | 78 | 14 | 2 |
| ATP | 20230529 | Roland-Garros | Clay | 119 | 94 | 24 | 3 |
| ATP | 20230703 | Wimbledon | Grass | 56 | 48 | 8 | 0 |
| ATP | 20230807 | Canada | Hard | 54 | 48 | 6 | 0 |
| ATP | 20230814 | Cincinnati | Hard | 50 | 50 | 0 | 0 |
| ATP | 20230828 | US Open | Hard | 75 | 65 | 10 | 0 |
| WTA | 20210208 | Australian Open | Hard | 126 | 0 | 252 | 0 |
| WTA | 20210322 | Miami | Hard | 89 | 62 | 30 | 1 |
| WTA | 20210429 | Madrid | Clay | 58 | 53 | 3 | 3 |
| WTA | 20210510 | Rome | Clay | 51 | 51 | 0 | 0 |
| WTA | 20210531 | Roland-Garros | Clay | 119 | 96 | 23 | 2 |
| WTA | 20210628 | Wimbledon | Grass | 100 | 85 | 15 | 0 |
| WTA | 20210809 | Canada | Hard | 49 | 47 | 2 | 0 |
| WTA | 20210816 | Cincinnati | Hard | 49 | 48 | 1 | 0 |
| WTA | 20210830 | US Open | Hard | 93 | 80 | 13 | 0 |
| WTA | 20211006 | Indian Wells | Hard | 91 | 82 | 9 | 0 |
| WTA | 20230116 | Australian Open | Hard | 127 | 88 | 41 | 2 |
| WTA | 20230306 | Indian Wells | Hard | 91 | 84 | 6 | 2 |
| WTA | 20230320 | Miami | Hard | 92 | 85 | 7 | 0 |
| WTA | 20230424 | Madrid | Clay | 93 | 84 | 9 | 0 |
| WTA | 20230508 | Rome | Clay | 90 | 84 | 7 | 0 |
| WTA | 20230529 | Roland-Garros | Clay | 119 | 107 | 12 | 0 |
| WTA | 20230703 | Wimbledon | Grass | 92 | 83 | 9 | 0 |
| WTA | 20230807 | Canada | Hard | 53 | 51 | 2 | 0 |
| WTA | 20230814 | Cincinnati | Hard | 52 | 52 | 0 | 0 |
| WTA | 20230828 | US Open | Hard | 100 | 92 | 8 | 0 |

| Tour/season | Slots | Median prior matches (including empty) | Maximum prior matches | Complete target vectors / targets |
| --- | ---: | ---: | ---: | ---: |
| ATP 2023 | 1692 | 5 | 35 | 612 / 846 |
| WTA 2021 | 1650 | 5 | 32 | 604 / 825 |
| WTA 2023 | 1818 | 17 | 72 | 810 / 909 |

**Missing 2022 and unequal depth:** ATP contributes only 2023; WTA contributes 2021 and 2023. No 2022 match exists in this authorized cohort. WTA 2023 can pool admitted 2021 counts across that missing season. The all-slot median history cardinality is 5 ATP versus 9 WTA; maxima are 35 versus 72. These are unequal observed inventories, not equal exposure or evidence of inactivity. Absent matches and years are neither filled nor treated as zero performance. No elapsed-time or decay correction is authorized.

## Outputs and validation

Only these files are installed under the already ignored `data/pilot/s08-batched-histories/`:

- `slot-history-aggregates.csv`: 5,160 rows, one per target and neutral slot, with contributor cardinality, label bounds, pooled component counts, rates and reasons.
- `target-s08-features.csv`: 2,580 rows, one per frozen target, with A/B rates, unreversed A-minus-B differences, slot-specific reasons and complete-S08 flag. No target result is exported.
- `summary.csv`: 1,152 rows, with metric/slot availability, undefined reasons, valid ranges and history cardinalities by overall scope, tour, season, batch, event and target surface. ALL combines player slots; difference counts target pairs. Empty and zero-denominator reason counts are nonexclusive for differences. History-depth fields for differences and probability-range counts for differences are not applicable (`NA`).

A three-file staging directory is checked for exact scope and unchanged bytes, input pins are rechecked, and one directory rename installs the complete release. Interrupted/corrupted staging cannot expose a partial final release. Identical existing outputs are preserved; differing releases fail closed without overwrite. Scratch fault tests do not change historical artifacts.

All **166 focused checks passed**: input pins, exact membership, no duplicate contributions, independent reconstruction of every pooled numerator/denominator from effective winner/loser counts, opponent orientation, unequal-denominator pooling, all zero-denominator/empty cases, strict cutoffs, frozen exclusions, slot-swap sign behavior, complete target/slot accounting, row/within-batch permutations, target/later-count perturbations and earlier-count positive controls, summary partitions, byte-identical independent reruns, atomic interruption/corruption checks, output ignores and exact tracked scope. An initial test compared a matrix with a data frame and failed on type; all numeric values matched exactly (maximum difference zero). The assertion was corrected to compare matrices and the entire focused suite then passed. No production calculation changed in response.

Current documentation consistency, local links, whitespace and unchanged historical status content passed. All **276 other pre-existing tracked files and pilot artifacts retain their SHA-256 hashes**. Historical suites and pins were not rerun or rewritten. The installed outputs and full diff were inspected. The actual runner produced the same bytes as the independent tested build; reinstallation preserved the existing release.

| Installed output | SHA-256 |
| --- | --- |
| slot-history-aggregates.csv | `9f3e9fbc03883a13576d0adf176425f60ac15cbc0467a59d09d044e6c5bf1087` |
| target-s08-features.csv | `b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00` |
| summary.csv | `7102585037df76fb7f952e50a7cfe60cf0443a228e672a3d43854842b29b8ef4` |

## Remaining limits and one next step

Source-label ordering assumes availability: earlier-label matches may overlap later events or have statistics published retrospectively. The Phase 2K failure persists in every output. Frozen source presence, completion and valid-count selection are retrospective conditions. This feature release establishes neither deployable chronology nor predictive value, factor stability, model uncertainty or superiority to Elo. M12 remains opportunity-conditioned conversion/execution; no resilience claim follows. Unequal depth, cold starts and missing-year coverage remain visible rather than repaired.

No window selection, initialization, imputation, Elo, model fit, weights, target-outcome feature, timestamp inference, acquisition, new dependency, 2024/2025 access, OTD, portfolio work or publication occurred. Historical releases and completed-report recommendations remain intact.

Recommend **Phase 2O: a bounded decision for the simplest synchronous event-batched surface Elo baseline and common evaluation eligibility**, before any rating implementation. Initialization, surface pooling, update arithmetic, parameter-selection boundaries and handling the 554 targets with undefined S08 differences remain unapproved. The decision should preserve all-target accounting and avoid selecting a favorable subset or adding complexity without evidence.

Exact approval language: **“Approve Phase 2O: draft a bounded surface Elo and common-evaluation decision under SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY using saved evidence only. Specify the simplest initialization, surface pooling, synchronous batch updates, parameter-selection boundaries and common-cohort/cold-start reporting for user approval. Preserve all targets and exclusions. Do not implement ratings, fit models, impute, acquire data, infer timestamps, access 2024/2025 or modify the portfolio.”** The next prompt must define exact documentation scope; this recommendation grants no implementation authority.
