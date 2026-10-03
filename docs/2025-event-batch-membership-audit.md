# Phase 2AJ: locked 2025 event-batch membership audit

## Result and authority

**2025_EVENT_BATCH_MEMBERSHIP_BUILT**, release **2AJ-1.0.0**, from clean `cbc619885c2b825641bf4c8ebe8245bf161fcc36`. All **1,878 frozen targets and 3,756 neutral slots** are preserved. The [builder](../R/build_2025_event_batch_membership.R) constructs membership only, under the [locked protocol](2025-locked-final-test-protocol.md) and [Phase 2AI scoped-cohort decision](2025-source-conflict-review.md). It changes no admission or historical release and computes no factor, rating, prediction or performance relationship.

Every output row is labeled **2025 locked source-label final-test sensitivity**, with SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY, NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE and UNCERTAINTY_NOT_ESTABLISHED. The cohort is conditional on 1,011 ATP targets across ten cells and 867 WTA targets across eight. **WTA Canada and Cincinnati remain wholly excluded**; no full-ten-family WTA claim is permitted.

## Implemented membership and input boundary

The [Phase 2AC definitions](2024-event-batch-membership-audit.md#selection-identity-and-safeguards) extend to three distinct frozen namespaces: DEVELOPMENT, VALIDATION_2024 and FINAL_TEST_2025. Original match IDs remain unchanged alongside cohort-qualified keys. Each link records target/prior identities, player slot, tour, source-date batch, event cell and count-origin metadata. Qualification prevents cross-cohort collisions, including the synthetic three-way collision fixture.

The admitted universe contains 2,580 development, 1,901 2024 v2 and 1,878 final-test records. For each target slot, select every exact-player same-tour admitted record with a strictly earlier source date. The builder verifies that all development/2024 labels precede the target tour's 2025 labels. Same-tour equal-date events form one simultaneous batch and cannot contribute to one another. There is no surface filter, history window, decay, inferred timestamp, imputation or within-batch order. Surface summaries describe targets only.

Thirty-eight literal SHA-256 pins guard authorities and inputs, including Phase 2AC, Phase 2AH, the locked protocol and frozen earlier admissions. Only allowlisted context/admission columns are loaded from saved membership, disposition and cell-summary files. CSV column classes skip outcome, score and statistical-component fields; source hashes treat bytes opaquely. No annual source is parsed and no historical runner executes. Existing pure Phase 2M sorting, date-label, summary and atomic-installation helpers are imported by explicit allowlist, preserving Phase 2AC safeguards without refactoring historical code.

Membership must exactly reconcile to frozen included dispositions and neutral IDs. Missing, invalid, wrong-season or conflicting date labels, mismatched identities, duplicate qualified records or changed pins stop the build. All rows in an admitted event cell, including exclusions, must retain one consistent valid date/tour label. Exclusions never enter the candidate universe. A prior match can contribute once to each target slot if it involves both players; duplicate target-slot-prior links are forbidden.

An empty slot has one EMPTY_HISTORY placeholder, blank prior fields, NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT and an observed-batch detail. Zero depth means no eligible match in this inventory, not an imputed statistic or a career debut.

## Measured memberships and history depth

There are **18 target batches**, ten ATP and eight WTA, with one admitted event cell per observed batch. Synthetic same-date events verify simultaneity. **146,374 links plus 102 empty placeholders produce 146,476 candidate-ledger rows.** Every target appears once in the target table; every slot has exactly one inventory represented by its links or placeholder.

| Tour | Targets / slots | Development links | 2024 v2 links | Earlier-2025 links | Total links | Empty slots A / B |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 1,011 / 2,022 | 23,435 | 30,204 | 14,965 | 68,604 | 18 / 41 |
| WTA | 867 / 1,734 | 39,213 | 26,738 | 11,819 | 77,770 | 7 / 36 |
| Total | 1,878 / 3,756 | 62,648 | 56,942 | 26,784 | 146,374 | 25 / 77 |

| Tour / slot | Minimum | 25th percentile | Median | 75th percentile | Maximum |
| --- | ---: | ---: | ---: | ---: | ---: |
| ATP / both | 0 | 13 | 30 | 49 | 108 |
| ATP / A | 0 | 18 | 33 | 52 | 108 |
| ATP / B | 0 | 9 | 26 | 47 | 108 |
| WTA / both | 0 | 19 | 39 | 63 | 163 |
| WTA / A | 0 | 27 | 49 | 69 | 163 |
| WTA / B | 0 | 13 | 31 | 52 | 163 |

Depth distributions include empty slots and use base-R type-7 quartiles. ATP has 1,963 nonempty slots, 59 targets with either slot empty and none with both empty. WTA has 1,691 nonempty slots, 41 targets with either empty and two with both empty. All 102 placeholders have PLAYER_FIRST_OBSERVED_BATCH detail; none is tour-first. Repeated appearances of a player yield repeated target-specific inventories, not unique-player counts.

All **105 eligible 2024 Canada/Cincinnati PM-context records** remain available and each contributes at least once: **3,533 links**, comprising 1,540 from Canada and 1,993 from Cincinnati. Their five frozen Toronto retirement exclusions contribute zero. This exact year-specific history retention does not transfer the exception to 2025.

All **190 blocked 2025 WTA PM records** and **six ATP format-conflict records** contribute zero targets and zero links. Every other frozen exclusion is also absent. All twenty expected event cells appear in summaries; WTA Canada/Cincinnati each retain 95 excluded panel records, zero admitted targets and zero memberships. These absent target slots are not counted as cold starts. Depth is undefined for their empty cell populations. Phase 2AH's partial-review admission label remains unchanged.

The 147-row summary includes overall, tour, season, batch, event and target-surface partitions with ALL/A/B slot views, origin totals, empty/nonempty counts and depth distributions. Surface link totals are ATP Clay 20,238 / Grass 8,228 / Hard 40,138 and WTA Clay 28,665 / Grass 11,318 / Hard 37,787. No threshold is selected from these inventories.

## Outputs and verification

Exactly three files are installed under the already ignored data/pilot/2025-event-batch-membership/ directory. They contain context and membership metadata, not target outcomes, scores or count components.

| File | Rows | Bytes | SHA-256 |
| --- | ---: | ---: | --- |
| target-batches.csv | 1,878 | 1,398,674 | `55c4cb37255b368f2760262fc3ffb0500904738fd1f29696c023fbf0f8219de3` |
| candidate-history-membership.csv | 146,476 | 110,169,308 | `ed9616954b4df7cb50fb4c5bee1381ef72842ee0abbd6f64f3f47fa1d86b9350` |
| summary.csv | 147 | 84,573 | `a7bc3d3a3dfa117d2c8a30cfe8b4ce803df054c88d6fc58f0950529bc5ecb360` |

**559 focused checks pass** in the [test script](../R/test_2025_event_batch_membership.R), followed by **four installed-output checks** against another independent process. Tests independently reconstruct all eligible links through a player/tour join; verify frozen IDs, all targets/slots, strict cutoffs, excluded records, retained 2024 PM links, complete summary partitions and limitations; and exercise cohort collisions, same-date events, both player slots, empty histories and invalid/conflicting labels. Row/event/within-batch permutations preserve the release. Synthetic outcome/score/count perturbations and skipped-column reader fixtures demonstrate their irrelevance without reading actual target values. Changing an eligible identity supplies a positive control.

Two independent fresh-process builds are byte-identical. Atomic tests cover interruption, changed staged bytes, idempotence and refusal to overwrite a differing existing release. The installer checks the exact three-file scope and performs one directory rename. All three installed outputs and their tour/batch/event/surface summaries were inspected. Documentation agreement, local links/anchors, whitespace and exact six-file tracked scope pass; **390 historical fingerprints** remain unchanged, including Phase 2AC, Phase 2AH, the locked protocol, raw files and prior ignored releases. No historical suite was rerun or repinned. No membership discrepancy or new admission issue was found.

## Limits and one combined next approval

Membership is not verified historical availability or evidence of real-time leakage safety. Unverified event overlap and data-release timing, source selection, missing 2022 and unequal history depth persist. Official recall remains UNKNOWN. Retain S02 paused, S08 provisional, reduced as a three-factor comparator, canonical M05 and M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED; no final Four Factors qualification or uncertainty claim follows. No admission change, aggregation, rating, fit, score, acquisition, dependency, OTD, portfolio or publication work occurred.

Recommend one combined **Phase 2AK** implementation: aggregate frozen S08 count histories and construct both frozen Elo probability benchmarks. Reuse Phase 2N/2AD pooled formulas and Phase 2P/2AE synchronous arithmetic; reconcile Phase 2AE terminal states including untouched development states before continuation. Preserve all targets and full-S08 eligibility, undefined empty/zero-opportunity rates, neutral differences, all-admitted Elo updates and the two missing WTA contexts. Define its exact code/report/output scope before work. Fitting and scoring remain outside this phase.

Exact approval: “Approve Phase 2AK to aggregate frozen S08 histories from Phase 2AJ memberships and construct the frozen primary surface Elo and overall-only probabilities for the unchanged 1,878 admitted 2025 targets, carrying forward reconciled Phase 2AE terminal states. Preserve all locked rules, exclusions, source-label and partial-cohort limitations. Do not fit or score models, tune, change eligibility, acquire data or publish.”
