# Phase 2Z: 2024 source acquisition and admission audit

## Terminal decision

**2024_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED.** Implemented from clean `a3735df1c6c3e3203cfdafa2fc81f6c05efb0a34` under explicit Phase 2Z authority. Both annual files pass provenance, byte and schema checks. All twenty expected cells are observed, eighteen contain admitted records, and two are wholly blocked: WTA Canada and Cincinnati. Their source level is `PM`, while the inherited context mapping requires `P`; all 110 rows remain excluded. This is a mismatch with the frozen rule, not a finding that the source or official tournament classification is wrong.

The [runner](../R/acquire_audit_2024_source.R) implements base-R acquisition/admission only. No histories, candidate metrics, ratings, fitting or scoring are authorized by this result. The [2024 validation protocol](2024-validation-protocol.md) remains frozen and unchanged.

## Provenance and bounded acquisition

Original creator: **Jeff Sackmann / Tennis Abstract**, via Aneeshers' preservation archive at **83733587353df8a41f2fd4f516147d5aa83f5a8d**. Before requests, verified literal fingerprints of DATA_LICENSE.md and the saved pilot manifest, their conditional **CC BY-NC-SA 4.0** noncommercial research basis, creator attribution and archive revision, alongside the protocol, historical admission/acquisition code and saved identity inputs. This reuses documented evidence; no fresh license request or legal review was performed. The mirror adds no rights, complete upstream provenance remains unestablished, and raw/derived publication remains unapproved.

The exact allowlist consists of each named file's direct raw URL at that revision and its file-specific GitHub contents endpoint with `?ref=` fixed to that revision. The [tracked manifest](../data/manifests/validation-2024-source-files.csv) records the four locators, retrieval times, creator, license, intended use, path, byte sizes, row counts, SHA-256 and Git blob IDs. No directory listing, clone, other revision, source substitution or 2025 endpoint was requested. Existing system curl refuses redirects, retries and user curl configuration; no dependency was installed.

Only verified bytes were installed under the existing ignored revision directory. Raw CSVs and matching `.metadata.json` responses retain source bytes; no metadata content was executed. API file type/name/path/revision-bound URLs, size and blob must match before the exact inherited 49-column header gate and record parsing. SHA-256 seals locally retained bytes; Git's blob calculation independently matches API blob identity. Absent/changed rights, metadata, bytes, schema or required provenance blocks the affected file before admission, with an explicit reason and no substitute.

| Tour | CSV bytes | Annual rows | CSV SHA-256 | Git blob ID |
| --- | ---: | ---: | --- | --- |
| ATP | 650136 | 3076 | `73aec32247a0db68d8aa8fd8003eefea132905177f1cb145502d9215b53311be` | `c401319bc1dec4633dd2c730aa5a7a7376e176f8` |
| WTA | 542425 | 2689 | `d9bba2a0b3793f63c737ef62a809b82b56b3ad0ee94e1f95e78cecfac7615ed2` | `2d3d70f3c076df89be88183638dd86627cea9da9` |

| Tour | Metadata bytes | Metadata SHA-256 | Metadata / raw retrieval UTC |
| --- | ---: | --- | --- |
| ATP | 896971 | `af908221f5839a016bc815fe32dd5f2da6025e5e365ece76943f69ea0f12812b` | 2026-10-03T02:24:50Z / 2026-10-03T02:24:50Z |
| WTA | 748571 | `ce86c233076494712989f0ac2e01157156f968a1f9fe3d7bdc3137f9250a5f42` | 2026-10-03T02:24:51Z / 2026-10-03T02:24:51Z |

Manifest SHA-256: `0b9cc7331a00577b190cdeb894ca4d7caad3ce533d7006d2d45a4450b2ab3a72`.

**Implementation failure and recovery:** the first four HTTP requests succeeded, but the isolated helper environment omitted `utils::count.fields`, preventing local CSV parsing. Both files were recorded BLOCKED and the initial staging bytes were not retained. A subsequent blocked-audit attempt also exposed missing `stats::setNames`. Both helper bindings were corrected; 55 local fixture checks and a separate all-files-blocked check passed before repeating the same four endpoints. The manifest preserves each initial failure and initial retrieval times. Total: eight requests to four distinct authorized URLs, no redirect, automated retry, new endpoint or network failure test. Final retrievals passed; no repeated acquisition is needed for offline reruns. The narrowly guarded recovery mode refuses any existing manifest except that exact initial local implementation failure, and refuses existing raw files.

Raw installation uses individual atomic same-filesystem renames plus an atomic **manifest-last commit marker**. The shared historical raw directory is not replaced. The quartet does not appear in one filesystem operation: an interruption may leave uncommitted files, but every reader requires the complete verified manifest and both members of each file pair. Unmanifested/conflicting files fail closed without overwrite or automatic reacquisition. Audit outputs install together by one directory rename; byte-identical existing outputs are retained and differing outputs are refused.

## Frozen admission rules and measured results

Reuse only allowlisted pure [Phase 2H helpers](source-defined-cohort-audit.md#admission-rules-implemented): score/status parsing, count bounds/game reconciliation, identity/duplicates, context dispositions and coverage. Historical runners, authority checks, pilot policies and recovery overlays are not executed. The panel retains the same family IDs/surfaces/levels/formats; year bindings become 2024. WTA Canada's already-approved Montreal/Toronto family binds to the Toronto edition label; this neither adds an event family nor verifies actual timing. Recognized labels with unexpected IDs remain conflicted candidates, not silently off-panel. The inherited `P` expectations for WTA Canada/Cincinnati are deliberately not changed to match new observations.

Require affirmative supported source-reported completion, exact identity/context and all eighteen count fields with inherited bounds. Preserve retirement, walkover, unfinished/unsupported, quarantine and service-game exclusions. No old pilot override transfers to a 2024 row. Cross-check same-tour identities against the frozen admitted development records; preserve all source fields and effective-count copies unchanged. Neutral A/B slots use lexical source-ID order, independent of outcome.

| Tour | Annual rows | Outside panel | Panel rows | Admitted | Excluded | Complete raw count bundles | Source-record retention |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 3,076 | 2,078 | 998 | 944 | 54 | 991 | 94.59% |
| WTA | 2,689 | 1,691 | 998 | 852 | 146 | 994 | 85.37% |
| Total | 5,765 | 3,769 | 1,996 | 1,796 | 200 | 1,985 | 89.98% |

Count availability is 991/998 ATP (99.30%) and 994/998 WTA (99.60%), using observed panel rows. These fractions are **source-record retention/count availability**, not official tournament coverage. Official recall is **UNKNOWN** for all cells and rounds; no new official denominator was acquired or assumed. The official-reconciliation 90%/95% gates retain their original meaning.

| Event | ATP admitted / observed | WTA admitted / observed |
| --- | ---: | ---: |
| Australian Open | 123/127 | 124/127 |
| Roland-Garros | 109/127 | 120/127 |
| Wimbledon | 119/127 | 122/127 |
| US Open | 118/127 | 120/127 |
| Indian Wells | 93/95 | 92/95 |
| Miami | 94/95 | 88/95 |
| Madrid | 91/95 | 94/95 |
| Rome | 93/95 | 92/95 |
| Canada | 52/55 | 0/55 |
| Cincinnati | 52/55 | 0/55 |

Both files VERIFIED; absent cells **0**; wholly blocked cells **2**; cells with admitted records **18/20**. No unresolved source-ID/family mapping, name/hand identity or duplicate conflict was found in the observed panel and saved identity comparison. The 110 source-level conflicts are the unresolved context issue. Do not infer complete tournament inventories from the expected-looking source counts.

## Exclusions and count availability

Completion dispositions: ATP 961 source-reported normal, 30 retirements, seven walkovers; WTA 965 source-reported normal, 29 retirements, three walkovers and one unfinished/inconsistent score. There are no observed default, abandonment or unsupported-extended-score cases; their exclusion behavior is covered by fixtures. No plausible source score establishes independent official completion.

| Applicable exclusion family | ATP rows | WTA rows |
| --- | ---: | ---: |
| Retirement | 30 | 29 |
| Walkover | 7 | 3 |
| Unfinished/inconsistent score | 0 | 1 |
| Service-game/score conflict | 15 | 6 |
| At least one count-component bound failure | 3 | 2 |
| At least one missing required count | 7 | 4 |
| Event-level context conflict | 0 | 110 |

These are overlapping reason counts, not additive totals. One ATP count-bound failure also has a service-game conflict; five WTA level-conflict rows are retirements. The eleven incomplete bundles consist of ten walkovers and one WTA retirement. Every applicable field-level missingness, status, bounds, context and reconciliation reason is retained in the ledger and summary rather than choosing one favorable exclusion. The 200 distinct exclusions comprise 70 nonnormal records plus 130 source-reported-normal records failing counts or context. No missing count is changed to zero and no source error is repaired.

## Ignored release and validation

Exactly four acquired files remain ignored under data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/: atp_matches_2024.csv, wta_matches_2024.csv and corresponding `.metadata.json` files. Exactly six audit outputs remain ignored under data/pilot/2024-source-admission/:

| Output | Rows | SHA-256 |
| --- | ---: | --- |
| provenance.csv | 2 | `829c64115dea539019e9dcc50499319891aca4ad6e99af10545c0bfdf7519867` |
| row-dispositions.csv | 5,765 | `34057fb28520cbfb02b01d2581fac818f7cee63ede6c45b5de8d2e5bd72c18a3` |
| membership.csv | 1,796 | `f7fd0163a49dc9e85f5d7b45736ac36bfe62c475cdd13bc5b381f11d2e9dcd52` |
| cell-summary.csv | 156 | `14e9ea5f88e29e9a133f66e991732ec19f8c8a0ab0c9d825b041516ca1dab8f5` |
| field-availability.csv | 2,808 | `e7ba1df9d14160726080cebf393d16784f98fcf82f1d1a2b7771a85436830ba1` |
| summary.csv | 79 | `01a5ab211a491dbb075318010bca5246277545d936aae07824aaf7f8793d571c` |

Provenance binds each file and saved evidence; the row ledger accounts for all annual rows with raw fields intact; membership contains only admitted neutral IDs. Cell summaries include all expected cells and observed rounds (156 rows), field availability covers each required field in those groups (2,808 rows), and the 79-row summary retains file states, completion and overlapping reasons. Off-panel rows receive scope-only dispositions. All outputs retain source-label and chronology/uncertainty limitation labels. No factor or forecast quantity is calculated.

[Focused tests](../R/test_2024_source_admission.R) use local fixtures for failures and never request the network. **4,775 focused checks passed**, including seven saved authority/evidence pins and the completed manifest pin; rights/provenance/endpoint, absent-file, metadata/header/schema, SHA-256/Git-blob failures; score/parser, mapping/context, identity/duplicate, counts and simultaneous-reason fixtures; all-row neutral ownership/raw preservation; all twenty cells and every field/reason summary; byte-identical offline reruns; raw/manifest interruption and staging-corruption guards; ignored paths and exact seven-file scope. Tests made no network requests. Thirty-three local links/anchors, current-document agreement, whitespace, report/output fingerprints and historical-body preservation pass. All 323 other pre-existing tracked files, pilot artifacts and previously manifested raw/metadata files retain their SHA-256 hashes. The current/completed contract label is the only historical-body change. The six installed summaries and final diff were inspected; historical suites and pins were not rerun or repinned.

## Limits and one next approval

The audit establishes compatibility with the frozen source-defined rules, not true match completeness, unbiased selection or forecast readiness. Context mismatches may reflect a legitimate changed source classification, but no approved 2024-specific level mapping exists here. Both WTA cells stay blocked pending a decision; count/status exclusions elsewhere also remain. Do not build histories from this partial release automatically. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist. S02 stays paused, S08 provisional, M05 remains Double-Fault Rate per Second-Serve Opportunity. Historical eligibility, releases, protocol and locked 2025 remain untouched; no model, dependency, OTD, portfolio or publication work occurred.

Recommend **Phase 2AA: bounded offline decision on the two WTA source-level context conflicts**, before any history build. This addresses the specific partial-cohort blocker without silently changing admission or expanding acquisition.

Exact approval: **“Approve Phase 2AA: conduct a documentation-only decision on the saved 2024 WTA Canada and Cincinnati source-level conflicts. Determine whether a bounded 2024-specific context mapping is defensible or must remain blocked. Use saved evidence only; preserve the frozen Phase 2Z release and validation protocol. Do not change membership, acquire data, access 2025, build histories, calculate ratings, fit or score models, add dependencies or modify the portfolio.”** The next prompt must specify its documentation scope; no membership revision or new release is authorized by this recommendation.
