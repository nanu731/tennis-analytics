# WTA 2021 Montreal reference feasibility

Review specification: **WTA Montreal reference-feasibility review 1.0.0**. **SUPPORTED_PENDING_RECOVERY_POLICY**. This is a local reference investigation, not an adopted recovery, precedence, eligibility or admission policy.

## Scope and authorization

The user selected Phase 1F Option A investigation and authorized these exact twelve URLs for local noncommercial educational research and source auditing. No other URLs, searches, hidden APIs, player pages or events were accessed. Toronto in two allowed URL slugs does not identify the edition city: both pages display National Bank Open - Montreal, Canada, match IDs 0806-2021 and Montreal match metadata.

| reference_id | url | retrieval_class | http_result | byte_size | retrieved_at_utc |
| --- | --- | --- | --- | --- | --- |
| overview | https://www.wtatennis.com/tournaments/806/montreal/2021 | original_response_bytes | 200 | 278544 | 2026-09-15T00:36:44Z |
| draw_html | https://www.wtatennis.com/tournaments/806/montreal/2021/draws | original_response_bytes | 200 | 1388142 | 2026-09-15T00:36:44Z |
| draw_pdf | https://wtafiles.wtatennis.com/pdf/draws/2021/806/MDS.pdf | original_response_bytes | 200 | 176067 | 2026-09-15T00:36:44Z |
| LS001 | https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS001 | original_response_bytes | 200 | 341999 | 2026-09-15T00:36:45Z |
| LS002 | https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS002 | original_response_bytes | 200 | 342155 | 2026-09-15T00:36:46Z |
| LS003 | https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS003 | original_response_bytes | 200 | 367437 | 2026-09-15T00:36:47Z |
| LS004 | https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS004 | original_response_bytes | 200 | 342132 | 2026-09-15T00:36:47Z |
| LS005 | https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS005 | original_response_bytes | 200 | 342199 | 2026-09-15T00:36:48Z |
| LS006 | https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS006 | original_response_bytes | 200 | 342031 | 2026-09-15T00:36:49Z |
| LS007 | https://www.wtatennis.com/tournaments/806/montreal/2021/scores/LS007 | original_response_bytes | 200 | 367460 | 2026-09-15T00:36:50Z |
| LS042 | https://www.wtatennis.com/tournaments/806/toronto/2021/scores/LS042 | original_response_bytes | 200 | 342083 | 2026-09-15T00:36:50Z |
| LS049 | https://www.wtatennis.com/tournaments/806/toronto/2021/scores/LS049 | original_response_bytes | 200 | 341954 | 2026-09-15T00:36:52Z |

All twelve acquisitions succeeded on the first direct attempt with HTTP 200. Saved files are original response bytes, not browsing-service representations. The [provenance manifest](../data/manifests/montreal-reference-files.csv) records exact URL, purpose, publisher, media type, local path, size, SHA-256, attempt/retrieval times and rights limitations. Acquisition occurred on September 15 UTC, September 14 in the user's local time. No crawl/access time was invented. Redirects and nonallowlisted requests are rejected; matching manifested files are reused without changes.

**Rights:** existing [WTA rights analysis](../DATA_LICENSE.md) still governs. User authorization for local caching does not grant publication or redistribution rights. Public access supplies no open-data license. Raw references and extracted match tables remain ignored. No new verified licensing fact arose, so DATA_LICENSE.md is unchanged. Only code, manifest and compact audit documentation are committed.

## Identity and targeted draw checks

| audit_id | match_code | source_round | source_winner | source_loser | advancing_side | identity_result | score_result |
| --- | --- | --- | --- | --- | --- | --- | --- |
| sackmann:WTA:2021-806:238 | LS001 | F | Camila Giorgi | Karolina Pliskova | b | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:300 | LS002 | SF | Karolina Pliskova | Aryna Sabalenka | b | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:299 | LS003 | SF | Camila Giorgi | Jessica Pegula | a | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:298 | LS004 | QF | Aryna Sabalenka | Victoria Azarenka | a | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:297 | LS005 | QF | Karolina Pliskova | Sara Sorribes Tormo | a | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:296 | LS006 | QF | Camila Giorgi | Coco Gauff | a | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:295 | LS007 | QF | Jessica Pegula | Ons Jabeur | a | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:260 | LS042 | R64 | Amanda Anisimova | Tereza Martincova | b | verified | exact_numeric_agreement |
| sackmann:WTA:2021-806:253 | LS049 | R64 | Fiona Ferro | Ajla Tomljanovic | b | verified | exact_numeric_agreement |

Match identity is checked before count orientation: WTA/source event, 806/2021 match code, displayed Montreal metadata, round, unordered pair, source names, page abbreviations/full slugs, winner and numeric set score. Page a/b order is saved separately. WTA player IDs are retained; no global identity crosswalk is created. Source Coco Gauff is linked only within this verified target to WTA cori-gauff / C. Gauff and the PDF branch; the source spelling is preserved.

Nine target branches of the one-page official PDF were visually reviewed, then checked offline with fixed bounding-box locators for entrants, advancement and score; retirement legend names have separate locators. All nine PDF player/round/result/numeric-score checks agree with the corresponding pages and source. HTML draw checks agree on the same nine pairs, rounds, advancements and scores. This is not complete Montreal inventory reconciliation and does not pass an inventory gate.

| match_code | identity_result | score_result | retirement |
| --- | --- | --- | --- |
| LS001 | verified | exact_numeric_agreement | FALSE |
| LS002 | verified | exact_numeric_agreement | FALSE |
| LS003 | verified | exact_numeric_agreement | FALSE |
| LS004 | verified | exact_numeric_agreement | FALSE |
| LS005 | verified | exact_numeric_agreement | FALSE |
| LS006 | verified | exact_numeric_agreement | FALSE |
| LS007 | verified | exact_numeric_agreement | FALSE |
| LS042 | verified | exact_numeric_agreement | TRUE |
| LS049 | verified | exact_numeric_agreement | TRUE |

The overview displays Aug 9–15, 2021; PDF header displays August 7–15 2021, MONTREAL, CAN and Hard. These distinct published windows are preserved; their scope difference is not explained or used to establish actual match chronology.

## Exact counts and structural checks

| official_match_code | required_fields_displayed | required_fields_exactly_parsed | structural_check_result | source_comparison_result |
| --- | --- | --- | --- | --- |
| LS001 | 18 | 18 | passed_all_applicable_checks | source_missing_official_present |
| LS002 | 18 | 18 | passed_all_applicable_checks | source_missing_official_present |
| LS003 | 18 | 18 | passed_all_applicable_checks | source_missing_official_present |
| LS004 | 18 | 18 | passed_all_applicable_checks | source_missing_official_present |
| LS005 | 18 | 18 | passed_all_applicable_checks | source_missing_official_present |
| LS006 | 18 | 18 | passed_all_applicable_checks | source_missing_official_present |
| LS007 | 18 | 18 | passed_all_applicable_checks | source_missing_official_present |
| LS042 | 18 | 18 | passed_all_applicable_checks | source_and_official_exact |
| LS049 | 18 | 18 | passed_all_applicable_checks | source_and_official_exact |

Each of LS001–LS007 contains all 18 required exact counts: ace, double fault, service points, first serves in, first-serve points won, second-serve points won, service games, break points faced and saved, for both players. Each status-review page also supplies 18 counts. Two extra return-game observations per match support cross-player checks: 180 observations total, including 162 required-field comparisons. These are separate reference observations; the seven Sackmann bundles remain entirely missing.

Only the unique whole-match Match tab is used. Service and Return sections are scoped separately from Featured Stats and set panels. Integers and displayed numerator/denominator fractions supply values; rounded percentages never reconstruct counts. Every field retains raw text, fraction components, locator, reference ID, scope, extraction method, page orientation and source-side mapping. The saved statistics name-bar is empty; ordering is tied to the page's a/b columns and bar classes, after the scoped match card verifies players. It is not independently confirmed by populated statistics-header names.

Each of nine bundles passes 51 applicable checks, with zero flagged or unevaluable checks: nonnegative integers; existing count bounds (including second-serve wins plus double faults); service games versus score; cross-player return/service games; and displayed fraction denominator consistency. No existing quarantine or admission state is transferred.

Completed tie-break games are excluded from service-game totals. LS006 and LS007 each include one tie-break set. Retirement handling permits zero or one current unfinished service game: LS042 has 15 service games against 14 finished scored games; LS049 has 16 against 16. This handles count structure without declaring eligibility or reconstructing missing points.

Of 162 required comparisons, 126 are source_missing_official_present and 36 are source_and_official_exact. LS042 and LS049 agree with all 18 populated source counts each. No required-count disagreement was found; agreement cannot establish independence or eliminate shared upstream errors.

## Status, dates and duration discrepancies

| match_code | source_score | status_result | draw_evidence_state |
| --- | --- | --- | --- |
| LS001 | 6-3 7-5 | completed_card_numeric_score_supported | agreement |
| LS002 | 6-3 6-4 | completed_card_numeric_score_supported | agreement |
| LS003 | 6-3 3-6 6-1 | completed_card_numeric_score_supported | agreement |
| LS004 | 6-2 6-4 | completed_card_numeric_score_supported | agreement |
| LS005 | 6-4 6-0 | completed_card_numeric_score_supported | agreement |
| LS006 | 6-4 7-6(2) | completed_card_numeric_score_supported | agreement |
| LS007 | 1-6 7-6(4) 6-0 | completed_card_numeric_score_supported | agreement |
| LS042 | 6-1 4-3 RET+H64 | official_retirement_confirmed_suffix_meaning_unresolved | numeric_agreement_HTML_retirement_marker_omitted |
| LS049 | 2-6 6-2 | official_retirement_confirmed_source_marker_missing | numeric_agreement_HTML_retirement_marker_omitted |

LS042 identifies Tereza Martincova as retired in the match card; its structured score also says Ret'd. The PDF has RET plus Martincova in its retirement legend. HTML draw has the same numeric score/advancement but omits RET. Source 6-1 4-3 RET+H64 is unchanged. Retirement is supported; neither H64 nor H61 has an established meaning.

LS049 identifies Ajla Tomljanovic as retired in the match card and Ret'd structured score; PDF RET/retirement legend corroborate her identity. HTML draw again omits RET. Source 2-6 6-2 remains literal source text; no marker or deciding set is inserted. No retirement-use policy follows from either finding.

| match_code | official_published_start_date | source_minutes | official_duration | duration_comparison |
| --- | --- | --- | --- | --- |
| LS001 | 2021-08-15 | not evaluable | 01:40:31 | source_missing_official_present |
| LS002 | 2021-08-14 | 81 | 01:21:13 | same_integer_minutes_seconds_not_in_source |
| LS003 | 2021-08-14 | 131 | 02:11:00 | same_integer_minutes_seconds_not_in_source |
| LS004 | 2021-08-13 | 79 | 01:19:45 | same_integer_minutes_seconds_not_in_source |
| LS005 | 2021-08-13 | 80 | 01:20:44 | same_integer_minutes_seconds_not_in_source |
| LS006 | 2021-08-13 | 99 | 01:39:45 | same_integer_minutes_seconds_not_in_source |
| LS007 | 2021-08-14 | 88 | 01:28:29 | same_integer_minutes_seconds_not_in_source |
| LS042 | 2021-08-09 | 46 | 00:46:00 | same_integer_minutes_seconds_not_in_source |
| LS049 | 2021-08-09 | 84 | 01:24:14 | same_integer_minutes_seconds_not_in_source |

Eight recorded source durations agree with the hours/minutes component of official durations; seconds are absent from the source, so exact second-level agreement is not claimed. The final's source minutes are missing while WTA records 01:40:31. Official published match dates differ in granularity from source tournament date 20210809 and are not verified actual-play dates. LS007 metadata is dated August 14 while other quarterfinal metadata is August 13; time zone and scheduling semantics remain unresolved.

All nine match-specific SportsEvent blocks say EventScheduled despite completed=true/status=F and visible Finished cards. This conflict is retained for every target. It does not negate exact count presence or corroborated retirement evidence, but any recovery/status precedence rule must explicitly address it. Generic hidden Upcoming UI labels are not match-status evidence.

## Coverage scenarios and feasibility

| scenario | denominator | source_complete_bundles | official_candidate_bundles | structurally_acceptable_official_candidates | remaining_missing_bundles | coverage_pct | could_reach_90pct | adopted_policy |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| original_source_only | 54 | 47 | 0 | 0 | 7 | 87.037 | FALSE | FALSE |
| separate_candidate_availability | 54 | 47 | 7 | 7 | 0 | 100.000 | TRUE | FALSE |
| hypothetical_passing_bundle_recovery | 54 | 47 | 7 | 7 | 0 | 100.000 | TRUE | FALSE |
| conservative_excluding_conflicted_candidates | 54 | 47 | 0 | 0 | 7 | 87.037 | FALSE | FALSE |

The declared denominator is the unchanged 54 source apparent-play rows, not a reconciled official population. Source-only coverage remains 47/54 = 87.0370%, leaving seven missing bundles. Forty-nine bundles would reach 90%, so two acceptable later recoveries could close the arithmetic shortfall. All seven count candidates are complete and structurally acceptable, giving 54/54 potential availability and hypothetical recovery coverage. Neither scenario represents filled source cells or adopted coverage.

The strict conservative scenario excludes candidates with any retained conflict, including EventScheduled metadata: all seven are excluded, leaving 47/54. This intentionally differs from count-only hypothetical arithmetic. Resolving or approving treatment of these status metadata conflicts is a prerequisite for later use. The 95% tour-season gate was not tested; thresholds and panel remain unchanged.

## Review dispositions and next decision

The nine feasibility dispositions preserve IDs, reference links, identity/score/status outcomes, field availability, structural result, comparison state, rights, permitted/prohibited uses and review version. Seven are official_counts_present_pending_recovery_policy; two retain their specific retirement finding. Every row prohibits source substitution, canonical recovery, model admission and publication. Review specification 1.0.0 is implemented; a recovery policy is not.

**Recommendation, not implementation:** a documentation-first Phase 1H should propose a bounded Montreal recovery and status-evidence policy for user review, explicitly handling the empty statistics name-bar mapping, scheduled metadata conflicts, missing draw RET markers, retirement eligibility, provenance and permitted local use. Prefer preserving source and candidate observations separately. Before any canonical recovery/admission, approve the policy and resolve complete inventory, chronology and analytic population requirements. Newly accessed evidence needs a new exact URL allowance. Public derived-output rights remain unsettled.

No source repair, substitution, admission, factor computation, Elo, forecast, predictive evaluation, wider data acquisition, dependency, portfolio edit, push, publication or deployment occurred. 2022/2024/2025 remain closed. Four Factors versus surface-adjusted Elo remains the flagship; Challenger promotion readiness remains deferred until shared infrastructure is validated.

## Reproduction and verification

From the repository root, run `Rscript R/download_montreal_references.R`, then `Rscript R/audit_montreal_reference_feasibility.R --self-test`. The audit uses saved files only and never calls a network function. It requires base R, existing SHA-256 tooling and existing pdftotext (optionally selected with ANOMALY_PDFTOTEXT); no dependency was added. Missing or mismatched bytes stop before overwrite; affected identity/parse failures are retained without source orientation/substitution.

Fresh-machine limits: third-party HTML may change or become unavailable. Downloading the same URL later does not reproduce these exact bytes; use an authorized copy matching the manifest, or document a new acquisition separately. There was no browsing-service fallback. PDF locators deliberately target this saved revision, not arbitrary future draw layouts. Earlier pinned annual files and Phase 1E outputs are prerequisites.

Generated ignored files under data/pilot/development-2021/montreal-reference-feasibility/: reference-match-inventory.csv, official-stat-observations.csv, field-comparisons.csv, structural-checks.csv, status-evidence.csv, feasibility-dispositions.csv, coverage-scenarios.csv, reference-checks.csv and pdf-target-evidence.csv. No full source/official combined match table is generated.

Synthetic checks cover allowlist and identity rejection, orientation reversal, whole-match isolation and duplicate Match-tab rejection, repeated set-panel isolation, integer/fraction parsing, percentage-only and missing values, hidden values, field comparison states, count failures, tie-break and retirement handling, preserved status/source text, draw conflicts, denominator accounting and prohibited adoption. Reruns must preserve output bytes and modification times, and downloader reruns must preserve saved reference bytes/times. Earlier raw/manifests/policies/generated CSVs are checked separately against the pre-acquisition snapshot.

Development checks exposed overly broad or exact assumptions: decorative aria-hidden bars initially suppressed visible counts; an empty statistics name-bar could not independently identify players; and Return-section/PDF-date labels differed from the first parser patterns. Parsers were narrowed to actual saved labels and visible value containers, with a/b class checks. A footer locator initially selected an earlier noncard occurrence and was corrected to the full card anchor. The reference-only validation adapter initially omitted required event context; existing source context now satisfies that interface without copying/filling a source match row or exporting mixed records. The report correctly switched to REVIEW_REQUIRED during that failure and was regenerated after correction. No retrieval failed, alternate source or set reconstruction was used.

Every next task must end with a response-only ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000.
