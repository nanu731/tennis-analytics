# Phase 2AC: 2024 event-batch membership audit

## Result and scope

**2024_EVENT_BATCH_MEMBERSHIP_BUILT**, release **2AC-1.0.0**, from clean `9537249390fcc3d9b59060feeca66ed6b1d4af6f`. The [builder](../R/build_2024_event_batch_membership.R) inventories candidate histories for all **1,901 frozen 2024 targets and 3,802 neutral player slots**. It aggregates no factors, fits no model and calculates no rating.

Every output carries **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED**. This is the [2024 protocol's](2024-validation-protocol.md#rolling-prequential-source-label-chronology) source-label validation sensitivity, not verified historical availability. Actual timing, overlaps and historical releases remain unverified.

## Selection, identity and safeguards

The [Phase 2M definitions](event-batch-membership-audit.md#implemented-selection-and-input-boundary) and [batching contract](data-source-contract.md#phase-2l-source-label-development-sensitivity-boundary) are retained. One batch is exactly (tour, source tourney_date). For each target slot, include all admitted same-tour development records involving that exact player, plus admitted 2024 records involving that player from strictly earlier source dates. All saved development labels are checked to precede validation. No surface restriction, history window, inferred timing, inactivity, decay, imputation or within-batch ordering applies. Same-tour equal-date events cannot contribute to one another.

Record inputs are only frozen Phase 2H membership/dispositions and the [Phase 2AB](2024-source-admission-v2.md) v2 membership/dispositions. Literal pins also preserve Phase 2M code/tests/report/outputs, the batching decision, validation protocol, saved license evidence, and Phase 2AB code/tests/report/six outputs. No annual data or network endpoint is opened. Historical runners and suites are not executed or repinned. Small pure Phase 2M label, sorting, summary and atomic-installation helpers are imported by explicit allowlist; the new preparation step extends the same linkage/label safeguards to the separately authorized 2024 cohort.

All 2,580 admitted development records and 1,901 admitted 2024 records form the candidate universe; a player/date filter determines actual contributions. Membership must join exactly to each frozen admitted ledger. Completion/exclusion/quarantine dispositions are checked as frozen admission metadata; score, winner/loser and count fields are outside the selection whitelist. No admission is recomputed from target outcomes. All source rows in an admitted cell, including exclusions, must have valid same-season and consistent date labels. Missing, invalid, conflicting or mismatched labels/identities stop the build without repair or cohort narrowing.

Original match IDs remain unchanged. Every record additionally has a cohort-qualified key, DEVELOPMENT|match_id or VALIDATION_2024|match_id; every link carries its prior cohort, original ID, qualified key, player slot, source label, batch, cell and count-origin tag. The actual original-ID sets are disjoint, but explicit qualification prevents a future join from confusing their roles. A synthetic collision tests this safeguard. Target outcomes and counts cannot select memberships; neutral slot IDs are inherited and checked. A match may correctly contribute to both target players when both participated, once per target-player-prior key.

Empty slots retain one EMPTY_HISTORY placeholder with blank prior identifiers, NO_EARLIER_ADMITTED_MATCH_IN_FROZEN_COHORT and inherited tour-first/player-first observed-batch detail. Zero history depth is an inventory count, not an imputed statistic or career-debut claim. All frozen retirements, walkovers, quarantines and other exclusions remain outside the candidate universe. Existing development recovery scope is unchanged.

## Measured results

There are **20 target batches**, ten per tour, with one event cell per batch in these saved records. Synthetic tied-date events exercise the required simultaneity behavior. There are **101,983 eligible memberships** plus **116 empty placeholders**, giving **102,099 candidate-ledger rows**. All 3,802 slots remain represented; no duplicate target-slot-prior contribution occurs.

| Tour | Targets / slots | Batches | Development links | Earlier-2024 links | Total links | Empty slots A / B | Median / maximum depth |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 944 / 1,888 | 10 | 26,324 | 14,814 | 41,138 | 28 / 43 | 19 / 71 |
| WTA | 957 / 1,914 | 10 | 46,625 | 14,220 | 60,845 | 11 / 34 | 27 / 115 |

Depth is measured per target-player slot, including empties; minima are zero in both tours. ATP has 1,817 nonempty slots, 69 targets with either slot empty and two with both empty. WTA has 1,869 nonempty slots, 45 targets with either slot empty and none with both empty. All-target totals are 3,686 nonempty slots, 114 targets with either slot empty and two with both empty. Cold-start counts refer only to this saved inventory. Missing 2022 and unequal ATP/WTA development depth remain; neither is filled or treated as inactivity.

All 116 empty slots have PLAYER_FIRST_OBSERVED_BATCH detail; none is tour-first once development is included. All 105 newly admitted WTA records contribute at least once where the exact player and strict source-date cutoff permit: **768 links**, reaching 156 target matches / 239 target-player slots. Canada contributes 166 links to Cincinnati and 267 to US Open; Cincinnati contributes 335 to US Open and zero to its own batch. The five excluded Toronto retirements contribute zero links. These are memberships, not unique-match coverage or verified availability.

The summary retains overall, tour, season, batch, event-cell and target-surface partitions with ALL/A/B slot views, membership origin totals, empty/nonempty slots and minimum/median/maximum depth. Surface is descriptive of the target, not a filter on history. No availability threshold is selected from these counts.

## Outputs and validation

Only target-batches.csv (1,901 rows), candidate-history-membership.csv (102,099 rows) and summary.csv (153 rows) are installed under the already ignored data/pilot/2024-event-batch-membership/ directory. Target rows include both slot counts and empty reasons; the candidate ledger preserves explicit source-cohort linkage; summary counts are inventories only. All rows retain sensitivity, chronology and uncertainty labels plus the new release version.

| Output | SHA-256 |
| --- | --- |
| target-batches.csv | `d5baad965f192dc4a0c7fe93cbfded6bd3be9c0f7caa9c58cfdefb1499442162` |
| candidate-history-membership.csv | `c3d1e7c570ac9791517117044abe00faee9ae6b1b53f5fc5a5f43b78074f9fe0` |
| summary.csv | `661334dfa6697454ccbdb421323cea39829e488fc0c9d9d360c3525efe7bd435` |

The inherited installer verifies pins and Git-ignore coverage, stages exactly three nonempty CSVs, checks staged fingerprints and installs the directory in one rename. An identical existing release is preserved; differing bytes, extra files, interruption or corruption fail without overwriting a historical or existing release. Tests isolate temporary fault fixtures from the production ignore guard.

The [focused tests](../R/test_2024_event_batch_membership.R) check pins and frozen membership, complete targets/slots, exact player/tour/date joins, an independent all-pairs join for membership completeness, exclusions, the newly admitted WTA contexts, simultaneous events, cross-cohort ID collision, both prior slots, cold starts, invalid/conflicting labels, permutations, outcome/count invariance and an eligible-linkage positive control. Independent fresh-process reruns and atomic failure tests protect deterministic installation. All historical Phase 2M and Phase 2AB releases remain unchanged. **91 focused checks passed**, including installed-byte comparisons against independent reruns. All three outputs, tour/batch/surface summaries and the final diff were inspected. Thirty-six local links/anchors, documentation agreement, whitespace and exact six-file scope pass. All 347 other pre-existing tracked files, pilot artifacts and manifested raw/metadata files retain their SHA-256 hashes; historical status/contract bodies are preserved. No data discrepancies were found. No historical suite is rerun.

## Limits and one next approval

Source-label membership is not proof of historical data availability or freedom from real-time leakage. Admission/source-selection limitations and official recall UNKNOWN remain; the inventory supplies no official tournament-coverage claim or model result. S02 stays paused, S08 provisional and canonical M05 unchanged. No factor aggregation, Elo, fit, scoring, acquisition, 2025, dependency, OTD, publication or portfolio work occurs.

Recommend **Phase 2AD: cumulative S08 count-history aggregation only** from these frozen memberships, reusing registered Phase 2N formulas. Pool counts before division; keep empty and zero-opportunity rates undefined, preserve all neutral targets and defer ratings and models.

Exact approval: **“Approve Phase 2AD: aggregate cumulative S08 count histories for the frozen 2024 targets using only Phase 2AC memberships and pinned admitted effective counts. Preserve neutral slots, strictly earlier batches, pooled numerator/denominator formulas and undefined empty or zero-opportunity rates. Do not choose windows, impute, calculate Elo, fit or score models, acquire data, access 2025, add dependencies, resume OTD or modify the portfolio.”** A subsequent prompt must specify exact code, report, test and output scope.
