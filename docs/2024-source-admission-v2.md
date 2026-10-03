# Phase 2AB: revised 2024 source admission release

## Result and implementation

**2024_SOURCE_COHORT_READY_FOR_HISTORY_BUILD.** Release **2AB-2.0.0**, implemented from clean `6212fd583202970bc93141a84ed04db20d27e00a` under explicit Phase 2AB approval. This label reports source-cohort readiness only; it does not authorize histories, ratings, fitting or scoring.

The [runner](../R/release_2024_source_admission_v2.R) imports an explicit allowlist of offline functions from the pinned Phase 2Z code, never acquisition functions or the historical runner. It verifies saved rights/provenance/code/decision pins, the frozen manifest, raw/metadata hashes, Git blobs and schema. It then reruns every frozen admission check and requires all six reconstructed Phase 2Z tables to match the saved release byte-for-byte before applying the exception. A second admission pass removes only the exact level_conflict token in the approved context and recalculates panel disposition and membership from the remaining reasons. Coverage and summaries use the unchanged inherited routines.

The [Phase 2AA rule](2024-wta-pm-context-decision.md) requires all four keys: **WTA**, **2024**, frozen family **Canada or Cincinnati**, literal raw level **PM**. The inherited context mapping first establishes the family; source-ID/name, date-label, surface, format, identity, duplicate, completion, count and service-game checks remain unchanged. Other context conflicts still exclude. PM remains literal in every source-value field; no global PM=P rule or semantic definition is introduced. The rule uses no winner, count, model or player-performance criterion. No pilot override expands to these rows.

The row-level audit_version remains 2Z-1.0.0 to identify the unchanged admission engine and avoid altering unrelated rows. The new release is identified by its directory and by release_version 2AB-2.0.0 in provenance and summary, with parent release and decision/release evidence pins. The historical manifest and all Phase 2Z files remain immutable.

## Measured disposition delta

| Measure | Result |
| --- | ---: |
| Annual source rows retained | 5,765 |
| Exact context records | 110: 55 Canada + 55 Cincinnati |
| Removed level-conflict reasons | 110 |
| Newly admitted records | 105: 50 Canada + 55 Cincinnati |
| Independently excluded context records | 5 Canada retirements |
| Changed ATP or other WTA records | 0 |
| Added, deleted, reordered or repaired source rows | 0 |

The five Toronto retirements retain excluded_status:retirement, status_retirement and game_reconciliation_not_evaluable. Every other reason, raw field, effective count and neutral player identifier is preserved. Exactly four derived ledger fields may change within the context: context_reasons, exclusion_reasons, panel_disposition and membership. The first three change on 110 rows; membership changes on 105. No outside row changes, including its audit-version field.

These are measured results from rerunning the source audit, not assigned totals. Assertions compare them with the authorized expected delta and stop before installation on any discrepancy. The existing Phase 2Z cohort remains 1,796 admitted; the new release has 1,901. No old membership or partial-review result is overwritten.

| Tour | Annual | Panel | Admitted | Excluded | Source-record retention | Complete raw count bundles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 3,076 | 998 | 944 | 54 | 94.59% | 991 |
| WTA | 2,689 | 998 | 957 | 41 | 95.89% | 994 |
| Total | 5,765 | 1,996 | 1,901 | 95 | 95.24% | 1,985 |

All twenty cells have admitted records; none are absent or wholly blocked. Canada WTA is 50/55 retained and Cincinnati WTA 55/55. Every other cell matches the [Phase 2Z table](2024-source-admission-audit.md#frozen-admission-rules-and-measured-results). Counts are source-record retention and count availability, **not official tournament coverage**. Official recall remains **UNKNOWN** throughout; complete-event gates are not established.

Other exclusions remain: ATP 30 retirements, seven walkovers, 15 service-game conflicts and three rows with count-bound failures; WTA 29 retirements, three walkovers, one unfinished score, six service-game conflicts and two count-bound failures. Reasons overlap. Missing bundles remain seven ATP and four WTA; no missing value is imputed. The level-conflict reason disappears only for the 110 approved records.

## Inputs, release and verification

Use only the already saved ATP/WTA 2024 annual sources at archive `83733587353df8a41f2fd4f516147d5aa83f5a8d`, with unchanged [manifest](../data/manifests/validation-2024-source-files.csv) and [Phase 2Z provenance](2024-source-admission-audit.md#provenance-and-bounded-acquisition). Their saved conditional CC BY-NC-SA 4.0 research-use basis, source limitations and unapproved publication status remain. No request or new acquisition occurred.

Exactly six ignored CSVs reside under data/pilot/2024-source-admission-v2/: provenance.csv (2 rows), row-dispositions.csv (5,765), membership.csv (1,901), cell-summary.csv (156), field-availability.csv (2,808) and summary.csv (82). All carry the existing chronology/uncertainty labels. Field availability is byte-identical to Phase 2Z. Provenance adds release identity and evidence pins; all original source provenance stays intact.

| Output | SHA-256 |
| --- | --- |
| provenance.csv | `430074a631dd7d7b3d9d459741dbb1c482ce0424839f219504994a57dc2c593b` |
| row-dispositions.csv | `ed80d3f9a5c8c7b4dbf41b1fb49d1567fd9e275a9f5e6330dcb340971bd508a2` |
| membership.csv | `81c3f1079dd5af0dd0bc7cc4d8d055ab2d685c055e509073e8248e29cdf2ae83` |
| cell-summary.csv | `38b375114ced0de355c873fbe5179200a049abb9765dc8a5b49595e54d467d16` |
| field-availability.csv | `e7ba1df9d14160726080cebf393d16784f98fcf82f1d1a2b7771a85436830ba1` |
| summary.csv | `2f0c7f3d1b48891f6cf1761c68428f88d3d9539029992dc4ffa2477cc88abfa5` |

Installation requires the six paths to be ignored. Tables are staged in a temporary sibling directory, fingerprinted, checked for exact scope and installed together through one directory rename. An identical existing release is retained; a conflicting release or corrupted stage is refused without overwrite. Temporary files used by verification are cleaned. Production accepts no network or acquisition arguments.

The [focused tests](../R/test_2024_source_admission_v2.R) cover pins, exact scope and deltas, raw/source-row identity, retained reasons, missing or nonmatching rule keys, unchanged independent gates, neutral player swaps, twenty-cell accounting, independent fresh-process byte-identical reruns, interruption/corruption/idempotence/overwrite guards, ignored outputs, exact tracked scope and Phase 2Z preservation. **142 focused checks passed**, including installed-output verification. All six outputs and the disposition diff were inspected. Thirty-five local links/anchors, documentation agreement, whitespace and exact six-file tracked scope pass; all 338 other pre-existing tracked files, pilot artifacts and manifested raw/metadata files retain their SHA-256 hashes. Historical document bodies are preserved. No historical test suite is rerun or repinned.

During the first dry build, the total-count assertion compared integer and double storage types with identical(), rejecting equal counts before any release installation. It was corrected to compare numeric values; no source discrepancy or policy change was involved.

## Limits and one next approval

S02 remains paused; S08 remains provisional; M05 remains Double-Fault Rate per Second-Serve Opportunity. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist. Source dates do not establish actual timing, event nonoverlap or historical availability. No histories, factors, Elo, fitting, scoring, 2025 access, dependency, OTD, portfolio or publication work occurred.

Recommend **Phase 2AC: bounded 2024 batch-key and candidate history-membership audit only**, under the frozen validation protocol. Start from the new 1,901-record admission cohort and frozen admitted development records, include only strictly earlier same-tour source batches, preserve same-date simultaneity and cold starts, and compute no features or ratings.

Exact approval: **“Approve Phase 2AC: build and audit only source-label batch keys and candidate history memberships for the frozen 2024 v2 cohort, using the frozen admitted development records and strictly earlier admitted 2024 batches. Preserve same-date simultaneity, neutral slots, exclusions and both admission releases. Do not aggregate factors, calculate ratings, fit or score models, acquire data, access 2025, add dependencies, resume OTD or modify the portfolio.”** A subsequent prompt must define exact implementation and output scope. Cohort readiness alone grants no implementation authority.
