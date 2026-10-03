# Phase 2AA: 2024 WTA PM context decision

## Decision and scope

**ADOPT_EXACT_2024_WTA_PM_CONTEXT_MAPPING.** Documentation-only decision from clean `2a9a351a54826b9c6e5046d1893657eaf61f46b2`, using the saved Phase 2Z source and release. The evidence uniquely links the two observed source contexts to the already frozen Canada and Cincinnati panel families. The Occam rule favors this explicit contextual exception over a global recoding or new source.

Adopt prospectively this exact rule: **tour = WTA, year = 2024, event_family in {Canada, Cincinnati}, raw level = PM → the corresponding existing frozen panel family**, subject to unchanged source-ID/name, surface, format, date-label, identity and other admission checks. Family identity must be established independently of the level exception. The two verified source contexts are specified below; an unknown or conflicting context still fails closed.

Preserve the literal source value **PM** in all raw and derived source fields. This decision neither defines PM's semantic meaning nor declares PM globally equivalent to P. It authorizes no recoding for another tour, year or family, no new alias, and no retrospective rewrite. The [Phase 2Z release](2024-source-admission-audit.md) remains **2024_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED**, with 1,796 admissions and all 110 reviewed rows excluded. Implementation requires separate approval for a new revised admission release. The [2024 validation protocol](2024-validation-protocol.md) remains byte-for-byte historical authority; this separately recorded exception changes only the prospective context policy, not its completion, identity, count, chronology, model or evaluation safeguards.

## Saved evidence and exact accounting

The [manifest](../data/manifests/validation-2024-source-files.csv) pins the WTA annual source to archive `83733587353df8a41f2fd4f516147d5aa83f5a8d`: 542,425 bytes, 2,689 rows, SHA-256 `d9bba2a0b3793f63c737ef62a809b82b56b3ad0ee94e1f95e78cecfac7615ed2`, Git blob `2d3d70f3c076df89be88183638dd86627cea9da9`. This review rechecked saved CSV/metadata hashes against the manifest; no fresh source or rights verification was requested. The conditional research-use and publication limitations are unchanged.

The ignored Phase 2Z `row-dispositions.csv` SHA-256 is `34057fb28520cbfb02b01d2581fac818f7cee63ede6c45b5de8d2e5bd72c18a3`; `membership.csv` is `f7fd0163a49dc9e85f5d7b45736ac36bfe62c475cdd13bc5b381f11d2e9dcd52`. All 49 raw fields of each reviewed row match its source-row locator exactly. Source-row numbers below are one-based data rows excluding the header, not chronology.

| Evidence | Canada | Cincinnati |
| --- | --- | --- |
| Raw tournament ID / name | 2024-806 / Toronto | 2024-1017 / Cincinnati |
| Raw date label | 20240805 | 20240812 |
| Surface / best-of / raw level | Hard / 3 / PM | Hard / 3 / PM |
| Raw draw_size | 64 | 64 |
| Annual source rows | 1795–1849 | 1850–1904 |
| Observed records / distinct player IDs | 55 / 56 | 55 / 56 |
| R64 / R32 / R16 / QF / SF / F rows | 24 / 16 / 8 / 4 / 2 / 1 | 24 / 16 / 8 / 4 / 2 / 1 |
| Source match_num range | 239–300 | 238–300 |
| Sole saved exclusion: level_conflict | 50 | 55 |
| Additional retirement exclusions | 5 | 0 |

Draw_size is retained as 64: 56 observed participants and 55 rows are separate measured quantities, not a raw-value repair or proof of complete official coverage. Rounds and match numbers are source labels, never verified match order. The source dates establish consistent edition labels only; they do not prove timing, availability or nonoverlap.

| Required question | Direct saved-evidence finding |
| --- | --- |
| Exact 110-record accounting | 55 Canada plus 55 Cincinnati; all remain excluded in the frozen ledger and absent from its admitted membership. |
| Unique family linkage | Frozen WTA family suffixes 806 and 1017 match the two source IDs. The existing 2024 registry already binds Canada to Toronto, retaining the established Montreal/Toronto family; Cincinnati's label is unchanged. Each cell has one ID, name, date, Hard surface, best-of-three format and the supported main-draw rounds above. |
| Competing records or mappings | Searching all 2,689 saved WTA rows by either source ID or Canada/Toronto/Montreal/Cincinnati name yields exactly these 110 PM rows. There are no competing P editions, extra candidate IDs or duplicated source keys. No duplicate event/date/round/unordered-player encounters or repeated player appearances within a round occur. |
| Player identity | The cells contain 79 distinct IDs together. Numeric, distinct opponent IDs and nonempty names are preserved. Names and recognized hands have no conflicting ID binding, and names have no competing ID, when checked against the saved WTA annual file and admitted WTA development rows. The frozen identity dispositions all pass. |
| Whole-cell block | Every reviewed row's context reason is exactly level_conflict. This is the sole universal blocker of these two cells; it is not the only exclusion on every row. |
| Independent exclusions | All 110 have complete raw count bundles. Fifty Canada and 55 Cincinnati rows have only level_conflict and pass saved service-game reconciliation. The other five Canada rows retain excluded_status:retirement, status_retirement and game_reconciliation_not_evaluable alongside level_conflict. No completion or count exception follows. |
| Outcome neutrality | The rule uses tour, year, established family and literal source level only. Source context and unordered player linkage, not winners, scores, player quality or model performance, justify it. Swapping player slots cannot change the predicate. |

The mapping and context checks were inspected in the [frozen admission helpers](../R/audit_source_defined_cohort.R) and [Phase 2Z runner](../R/acquire_audit_2024_source.R) without running or modifying either. The 105 sole-level exclusions are a count of existing reason records, **not** a new membership result or a guarantee of future admission. A revised release must rerun every independent frozen check and report all reasons; the five retirements cannot become eligible through this mapping.

## Limits, preservation and verification

The saved source supports family linkage, not the official meaning of PM, independent official completion, complete-event recall or historical information availability. Official recall remains **UNKNOWN**; source-record retention is not tournament coverage. No newly acquired reference is needed to make this narrow source-defined context decision, and none was accessed. No global category equivalence or source error is inferred.

S02 remains paused and S08 provisional; M05 remains Double-Fault Rate per Second-Serve Opportunity with its unchanged formula and interpretation limits. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist. Histories, ratings, fitting and scoring remain unauthorized. No 2025, OTD, dependency, portfolio or publication work occurred.

Verification used read-only base-R accounting and exact raw joins, manifest/source/release fingerprints, all-annual competing-context searches, round/player/source-key checks, saved identity comparisons, independent-reason and membership checks. No admission runner or historical suite was rerun. Documentation agreement, 33 local links/anchors, whitespace, exact four-file scope and historical document bodies pass; all 337 other pre-existing tracked files, pilot artifacts and manifested raw/metadata files retain their SHA-256 hashes. The Phase 2Z code, tests, manifest, report, four acquired files and six ignored tables remain byte-identical; no generated output was created.

## One next executable phase and exact approval

Recommend **Phase 2AB: implement only this exact context rule in a new revised admission release**, preserving Phase 2Z byte-for-byte. Use the same pinned sources, preserve PM, rerun all unchanged independent admission checks, compare dispositions by source ID, and report revised counts and all twenty cells. An unexpected changed disposition outside the exact context rule must fail review. This is not a history-build approval.

Exact approval: **“Approve Phase 2AB: implement only the adopted 2024 WTA Canada/Cincinnati PM context mapping in a new versioned admission release using the saved pinned sources. Preserve literal PM and every independent exclusion; preserve Phase 2Z code, tests, manifest, report and outputs byte-for-byte. Validate the disposition delta and all twenty cells. Do not acquire data, access 2025, build histories, calculate ratings, fit or score models, add dependencies, resume OTD or modify the portfolio.”** The implementation prompt must define its exact new code, tests, report and ignored-output scope; no historical release may be overwritten.
