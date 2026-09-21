# Phase 1B: WTA anomaly verification and quarantine policy

Verified **2026-09-14**. Policy version **1.0.0**, adopted by the user's Phase 1B instructions. This milestone implements evidence comparison and quarantine, not a correction, complete draw reconciliation, canonical schema, or model.

## Purpose and historical scope

The earlier [pilot audit](pilot-acquisition-audit.md) detected an inconsistency using Sackmann bytes only; it did not inspect the official WTA match page. Phase 1B acquired four authorized references and compared this one match. Both untouched annual files and both pilot subsets remain unchanged. No other season was acquired.

Evidence labels: **Verified observation** means extracted saved bytes or directly inspected draw layout; **Source claim** means a publisher's displayed value, not independently established accuracy; **Implemented policy** means the authorized project rule; **Unresolved** means no correction or interpretation is selected; **Proposed next step** is unimplemented.

## Exact source observation

**Verified observation:** Source key `sackmann:WTA:2023-609:268`; tournament `Indian Wells`; winner Bianca Andreescu; loser Peyton Stearns; round `R64`; score `4-6 6-4 6-3`; service games `w_SvGms=11`, `l_SvGms=11`; source minutes `151`. The event-week label `20230306` is not an actual match date.

The preserved file and its original checksum are in the [pilot manifest](../data/manifests/pilot-source-files.csv), pinned to archive revision `83733587353df8a41f2fd4f516147d5aa83f5a8d`. Winner/loser orientation is retained; the official page instead displays Stearns first and Andreescu second. The extractor verifies that mapping before comparing counts.

## Acquired references and rights

**Verified observation:** The [reference manifest](../data/manifests/anomaly-reference-files.csv) records exact URLs, publisher, purpose, classification, first retrieval time, local ignored path, size and SHA-256. Only these four references were acquired:

| ID | Reference | Classification | Retrieved UTC | Bytes |
| --- | --- | --- | --- | --- |
| wta_match | [Official LS033 match page](https://www.wtatennis.com/tournaments/609/indian-wells/2023/scores/LS033) | official | 2026-09-14T12:47:50Z | 367834 |
| wta_draw_pdf | [Official singles draw PDF](https://wtafiles.wtatennis.com/pdf/draws/2023/609/MDS.pdf) | official | 2026-09-14T12:47:51Z | 834848 |
| wta_draw_page | [Official 2023 draws page](https://www.wtatennis.com/tournaments/609/indian-wells/2023/draws) | official | 2026-09-14T12:47:52Z | 2080027 |
| tennis_abstract | [Supplementary charted match](https://www.tennisabstract.com/charting/20230311-W-Indian_Wells-R64-Peyton_Stearns-Bianca_Andreescu.html) | supplementary | 2026-09-14T12:47:52Z | 349939 |

| ID | SHA-256 |
| --- | --- |
| wta_match | de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196 |
| wta_draw_pdf | 573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960 |
| wta_draw_page | 9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a |
| tennis_abstract | d42089908568a6a8a544dddaf6faf5dbef9e1679938ff71203843d21737b89cf |

Raw references live under `data/raw/reference/indian-wells-2023-anomaly/`; extracted evidence and a local PDF inspection image live under `data/pilot/anomaly/`. Both are ignored. No raw reference is committed.

**Source claim / rights limitation:** WTA reference pages carry WTA copyright. No open-data or republication permission is inferred. The [contract's previous WTA terms review](data-source-contract.md#6-licensing-and-redistribution-implications) remains relevant; the terms were not reacquired in this four-reference task. Tennis Abstract credits charting contributor **Zindaras**. Applicable project/source noncommercial share-alike conditions and attribution remain; a crowdsourced page is not an authorized replacement source. No new license interpretation required changing [DATA_LICENSE.md](../DATA_LICENSE.md). Reference caching is the user-authorized local audit scope, not a provider permission grant or publication approval.

The saved WTA HTML includes unrelated site navigation and news. The parser selects only the 2023 LS033 match card and whole-match statistics. It neither follows those links nor treats unrelated current-year content as evidence.

## Official field comparison

**Verified observation of published values:** All 18 required counts agree exactly between the saved WTA page and Sackmann. This is agreement between observations, not proof that the counts describe the complete match.

| Field | Sackmann winner / loser | WTA Andreescu / Stearns | Comparison |
| --- | --- | --- | --- |
| Aces | 3 / 1 | 3 / 1 | exact agreement |
| Double faults | 4 / 5 | 4 / 5 | exact agreement |
| Service points | 75 / 65 | 75 / 65 | exact agreement |
| First serves in | 43 / 41 | 43 / 41 | exact agreement |
| First-serve points won | 28 / 28 | 28 / 28 | exact agreement |
| Second-serve points won | 17 / 7 | 17 / 7 | exact agreement |
| Service games | 11 / 11 | 11 / 11 | exact agreement; structurally invalid |
| Break points faced | 8 / 5 | 8 / 5 | exact agreement |
| Break points saved | 5 / 1 | 5 / 1 | exact agreement |

Whole-match displayed fractions supply their original numerator/denominator counts; the script does not reverse-engineer rounded percentages. It explicitly excludes the separate set tabs.

| Context | Observation and assessment |
| --- | --- |
| Players/result | Andreescu winner, Stearns loser; abbreviated official names normalize to source identities. |
| Round | Official `Round of 64` normalizes to `R64`. |
| Score | Exact agreement, `4-6 6-4 6-3`, after retaining the official player-side mapping. |
| Status | Match-card attributes say `data-completed=true`, `data-status=F`; visible footer says Finished. Sackmann has no dedicated status field, so direct field comparison is unavailable. |
| Conflicting status metadata | Match-specific JSON-LD says `EventScheduled`. This conflicts with the completed card; record both, do not interpret generic hidden Upcoming/Suspended UI labels as additional outcomes. |
| Date | WTA match-specific startDate and visible Start Time supply `2023-03-12`; timezone and actual-play versus scheduled-date semantics are unresolved. Sackmann supplies no actual match date. |
| Duration | Source `151` minutes; official structured duration `02:31:40`, visible display `2:31`. Normalized agreement at hour/minute precision; not exact seconds agreement. |

The local `anomaly-source-comparison.csv` keeps raw observations, reference IDs/locators, comparison labels and a separate structural assessment. A value can agree exactly and still be structurally invalid. Missing source dates/statuses are labeled unavailable, with unresolved interpretation recorded separately.

## Draw and supplementary evidence

**Verified observation:** The official draws page's LS033 card confirms the same players, winner and score. Page 1 of the PDF was extracted and visually inspected at draw positions 6-8: Stearns advances to face seeded Andreescu, and Andreescu advances from their R64 match with `46 64 63`. The PDF's round columns identify the stage. This confirms this match's inventory presence and result, not every statistical count or the entire draw's completeness.

**Source claim:** The Tennis Abstract heading agrees on players, R64 and score. Its URL carries `20230311`, whereas WTA gives `2023-03-12`; no timezone explanation is established. Its whole-match break-point saves/faced are Andreescu `7/12` and Stearns `2/9`, differing from WTA/Sackmann `5/8` and `1/5`. The extractor retains all four differing counts as supplementary observations with `disagreement` labels. It does not reconstruct or substitute statistics from point logs or other tables.

**Unresolved:** Crowdsourcing and potentially different observation coverage do not establish which values are correct. The charted page's other-match context averages are not used.

## Structural validation and source dependence

**Verified calculation:** The score contains `10 + 10 + 9 = 29` completed games and no tie-break. A complete service-game bundle must total 29 here. Both published bundles total `11 + 11 = 22`, failing that equality. Their individual true service-game counts remain unknown.

**Implemented interpretation:** Quarantine the entire statistical bundle, not only the two visibly inconsistent fields. The mismatch can indicate incomplete coverage beyond those fields; the task does not establish its cause. Passing other arithmetic bounds does not authenticate the remaining statistics.

**Unresolved provenance:** Sackmann may preserve statistics from the same upstream record used by the official page. Exact agreement does not prove independent measurement, accuracy, or an authenticated feed lineage. The repeated error cannot be repaired by a majority vote across pages. The draw confirms result facts but does not validate count accuracy.

## Adopted quarantine policy, version 1.0.0

**Implemented policy:** Preserve every raw observation. Never replace missing or invalid counts with zero. Keep conflicting observations separate with provenance. A failed structural rule invalidates the whole statistical bundle. Keep the match in inventory and, when played, in the played-match denominator; exclude the bundle from the valid numerator, Four Factors, factor-weight estimation, and player-strength summaries.

Preserve result, players, score, round and source identifiers for audit. Quarantine does not authorize Elo updates or forecasting; chronology/status rules must be settled separately. Reconstructed corrections require future source/transform authorization. Never choose a correction because it improves coverage.

| Controlled reason code | Meaning |
| --- | --- |
| missing_required_counts | At least one required count is absent; missing is not zero. |
| structural_count_conflict | A count type, bound or applicable whole-match structural test fails. |
| cross_source_conflict | Comparable count observations disagree; preserve both and withhold correction. |
| status_unresolved | Status/eligibility evidence or the applicable status policy is unresolved. |
| chronology_unresolved | Date precision, actual-play semantics or completion order cannot support authorized chronological use. |
| identity_ambiguous | Required player identity is missing or cannot be linked unambiguously. |
| reference_unavailable | Required supporting reference could not be acquired or interpreted. |

Statistical invalidity and chronological restrictions are separate. A chronology reason alone does not turn present counts into missing counts. The current helper conservatively leaves all model-admission flags false: it is a validation policy, not authority to start analysis. `factor_statistics_candidate` is only a preliminary count/status screen; it does not settle retirement eligibility or grant model admission.

Each quarantine record contains source key, reason, affected fields, reference IDs, original/comparison values, structural test, disposition, permitted/prohibited uses, review status, and policy version. Versioned state also separates row presence, field presence, structural passage, inventory membership, played denominator, valid numerator, statistical candidacy and model-use eligibility. No canonical match schema was created.

## Final anomaly disposition and coverage

**Implemented disposition:** `quarantine_entire_statistical_bundle_preserve_inventory`. Reasons: `structural_count_conflict`, `cross_source_conflict`, `status_unresolved`, `chronology_unresolved`. The status reason records the completed-card/scheduled-metadata conflict without denying the draw's result evidence. Correct values remain unresolved; quarantine is adopted, not pending approval.

| Gate for Andreescu-Stearns | State |
| --- | --- |
| Source row present / required fields present | true / true |
| Structural checks passed / bundle quarantined | false / true |
| In event inventory / played denominator | true / true |
| In valid numerator / factor-statistics candidate | false / false |
| Factor analysis / rating updates / chronological forecasting | not authorized / not authorized / not authorized |

**Verified calculation from unchanged pilot rows:**

| Tour | Inventory | Walkovers | Played denominator | Jointly present | Played bundles quarantined | Valid numerator | Valid coverage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | 95 | 0 | 95 | 95 | 0 | 95 | 100% |
| WTA | 95 | 1 | 94 | 94 | 1 | 93 | 98.9362% |

WTA match 270 is the separate walkover: retained in inventory, all 18 counts missing, outside the played denominator. Match 268 stays in that denominator. Across all 95 WTA inventory rows, raw joint presence is 94/95 and valid count bundles are 93/95; those are different denominators from the played-match gate.

The percentages equal the earlier count-flag sensitivity calculation; Phase 1B formalizes its quarantine meaning. Both tours pass the provisional **90% numerical event floor**. **The 95% tour-season gate is not tested.** This remains an observed-source denominator until complete official inventory reconciliation.

Retirement rows remain present, including their partial statistics; this played-match sensitivity retains them. Those eligibility and update decisions were unresolved in Phase 1B. Phase 1L separately approves primary retirement/walkover exclusion in PROJECT_CONTEXT.md, without implementing a canonical selector or altering this quarantine policy. No current factor/rating/forecast admission follows from these percentages.

## Reproducibility, limits and next step

Run `R/download_anomaly_references.R` from the repository root for the four allowlisted references. Existing manifested bytes are validated before any request/write; mismatches stop without overwrite. `R/audit_wta_anomaly.R` reads only saved references and preserved annual files. It generates four ignored CSVs: source comparison, validation checks, disposition and coverage. `R/audit_pilot_data.R` adds the shared policy state to its existing row audit and regenerates the pilot report. Neither script alters annual bytes or subset values.

PDF extraction uses existing `pdftotext`, discovered on PATH or in the bundled runtime. `ANOMALY_PDFTOTEXT` can name another existing installation; none is installed by the script. Base R handles acquisition, HTML parsing, calculations and CSV writing. Parsing is deliberately scoped to this saved LS033 layout; structural layout changes fail or produce unavailable evidence rather than selecting unrelated fields.

In-memory regression tests are available through `R/audit_wta_anomaly.R --self-test`. They cover the real anomaly, a valid completed match, missing service games, conflicting count evidence and the separate walkover; they create no synthetic dataset files.

**Proposed next step:** Complete official match-inventory reconciliation for the **2023 Indian Wells ATP and WTA draws**. Do not expand the development panel yet. Chronology, retirement eligibility and eventual publication rights remain separate decisions. Require the next task to end with a written ChatGPT Handoff of approximately 2,000 words and strictly no more than 2,000 words.
