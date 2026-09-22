# Tennis analytics status

Date: **2026-09-22**. **Phase 1P complete: STAGE_A_STOPPED_RIGHTS.** The one exact WTA terms GET returned readable HTTP 200 without redirect. Access for the proposed programmatic research mode is PROHIBITED; local retention for that mode remains AMBIGUOUS_STOP_REQUIRED. Request two was not permitted or attempted. A1–A4, A9 and A10 were approved only for Stage A; A5–A8 and all later stages remain pending. The [Stage A report](wta-2021-montreal-chronology-stage-a.md) records the evidence and checks. Chronology policy 1.0.0 remains ADOPTED; operational chronology NOT_IMPLEMENTED; chronology/model readiness BLOCKED; event admission NOT_EVALUATED; canonical population NOT_IMPLEMENTED; modeling authorization FALSE; publication BLOCKED_PENDING_RIGHTS_REVIEW. Inventory remains COMPLETE, 14/14 criteria; completed count coverage remains 49/49 with separate recovery bundles.

## Completed and verified

The flagship asks whether interpretable Four Factors capture player strengths and improve calibrated forecasts over surface-adjusted Elo. The ten-family ATP/WTA panel remains fixed. Challenger promotion readiness remains deferred until shared infrastructure is validated. This repository owns research; portfolio is reserved for separately authorized publication of completed reviewed work and was not modified.

The [Phase 1J inventory report](wta-2021-montreal-inventory-reconciliation.md) and its reproducible base-R implementation independently parse saved official HTML and PDF before linking source rows. No new URL, download or dependency was used. Both representations yield:

| Inventory measure | HTML | PDF |
| --- | --- | --- |
| Bracket positions | 64 | 64 |
| Entrants | 56 | 56 |
| Byes | 8 | 8 |
| Bracket blocks, including bye advancement | 63 | 63 |
| Non-bye results | 55 | 55 |
| Explicit walkovers | 1 | 1 |
| Explicit retirement markers | 0 | 5 |

Non-bye results by round are 24 R64, 16 R32, eight R16, four QF, two SF and one final. All 57 source rows link one-to-one to both official representations. There are zero unmatched records, duplicate keys, unresolved identities, round conflicts, winner conflicts or normalized numeric-score conflicts. Raw status differences remain separate from score agreement.

HTML has 62 unique supplied LS identifiers. The absent LS013 label corresponds to the sequence position of an **uncoded Gauff–Konta R16 walkover card**, which is present between LS012 and LS014. PDF and source independently corroborate that result. No missing match or LS013 code is synthesized. The reason the publisher omitted the code attribute remains unknown; byes do not explain this specific gap.

Event-scoped identities use deterministic exact roster resolution, preserving IDs and spellings. Explicit ñ-to-n normalization handles Muguruza's PDF spelling. Cori Gauff/Coco Gauff extends the existing LS006 linkage only within this event after all four opponent/round pairings agree. Alison Riske/Riske Amritraj is a bounded exact event-candidate decision corroborated by the R64 Sorana Cirstea pairing. No fuzzy matching or global alias was introduced.

## Inventory conflicts resolved in Phase 1L

| Official code | Full source audit ID | Evidence difference |
| --- | --- | --- |
| LS036 | sackmann:WTA:2021-806:266 | Sakkari–Bouzkova: source/PDF RET, HTML marker omitted |
| LS054 | sackmann:WTA:2021-806:248 | Konta–Zhang: source/PDF RET, HTML marker omitted |
| LS026 | sackmann:WTA:2021-806:276 | Gauff–Potapova: source/PDF RET, HTML marker omitted |

The advancing players and numeric scores agree. All five raw HTML retirement omissions remain preserved. The two LS042/LS049 resolutions remain under Phase 1I. The three entries above are now resolved only for inventory detail by [the separately adopted policy 1.0.0](wta-2021-montreal-inventory-status-policy.md); source RET, PDF RET/legend and HTML omissions/F metadata remain distinct. No unresolved identity, round, winner, numeric-score, duplicate, unmatched or retirement-detail conflict remains.

Saved evidence supports full extraction, linkage and the three approved derived resolutions. No new URL was needed. Approval and implementation are distinct: all policy evidence checks and all fourteen criteria now pass. The primary completed-match-only design excludes retirements and walkovers, but no canonical analytical population is implemented.

## Existing recovery layer preserved

[Recovery and status-evidence policy 1.0.0](wta-2021-montreal-recovery-policy.md) remains adopted and implemented. The unchanged ignored release contains seven bundles / 126 field decisions plus nine scoped status resolutions. Original source values remain missing; recovered counts were not merged into inventory or canonical inputs.

LS001–LS007 retain the scoped completed-evidence rule and preserved EventScheduled conflicts. LS042 records Martincova retired while preserving `6-1 4-3 RET+H64`; LS049 records Tomljanovic retired while preserving `2-6 6-2`. Their source counts/scores remain unchanged. H64/H61 meanings remain unresolved. New inventory labels distinguish 47 original source bundles, seven separate supplemental bundles and one walkover outside the apparent-play count denominator.

| Gate or measure | Current state |
| --- | --- |
| Historical apparent-play source-only presence | 47/54 = 87.0370% |
| Historical apparent-play source-plus-overlay presence | 54/54 = 100% |
| Inventory reconciliation | COMPLETE, 14/14 criteria |
| Completed-match source-only valid count coverage | 42/49 = 85.7143% |
| Completed-match source-plus-overlay valid count coverage | 49/49 = 100% |
| Numerical 90% completed-match event gate | PASS; 45 valid bundles required |
| Event admission | NOT_EVALUATED |
| Canonical analytical population | NOT_IMPLEMENTED |
| 95% tour-season coverage gate | NOT_TESTED |
| Actual chronology / same-day order | UNRESOLVED |
| Chronology policy | ADOPTED, version 1.0.0; D1–D13 APPROVED |
| Operational chronology | NOT_IMPLEMENTED |
| Chronology/model readiness | BLOCKED |
| Published match-page date evidence | 9/55 results; 7/49 completed matches |
| Verified actual start / completion dates and times | 0/55 each |
| Bracket precedence evidence | 54 player-relative edges; 45 completed-to-completed |
| Primary population design | Completed matches only; implemented for this event audit only |
| Modeling | Unauthorized |
| Publication | Blocked pending rights review |

Thresholds remain 90% event / 95% tour-season. Published match dates and match numbers are not chronology substitutes. Phase 1N revalidates the LS007 date discrepancy and differing overview/PDF tournament windows without resolving them. Its narrower player-relative bracket finding does not establish actual dates or a global order. Indian Wells policies, calculations and inventory states remain unchanged; they do not authorize Montreal admission.

## Standing future-model requirement

The user requires future factors and models to target performance on future matches, not reproduce one season or a few observed seasons. Use chronological development and validation and prevent later information entering earlier predictions. Preserve **2021–2023 development**, **2024 validation/model selection**, and the **locked 2025 final test**.

Specify the complete tuning/evaluation protocol before modeling begins. Favor stable, interpretable specifications and assess sensitivity across seasons, surfaces, events, ATP and WTA. Phase 1J records this requirement without designing tuning, regularization, calibration or evaluation methods. No 2025 data was inspected, acquired or evaluated.

## Reproduction and verification

From the repository root:

```sh
Rscript R/audit_montreal_chronology_evidence.R
Rscript R/test_montreal_chronology_evidence.R
Rscript R/audit_montreal_completed_match_coverage.R
Rscript R/test_montreal_completed_match_coverage.R
Rscript R/reconcile_montreal_inventory.R
Rscript R/test_montreal_inventory.R
```

The scripts use saved local evidence and existing R, SHA-256 and pdftotext tools. Full official draw tables, identity decisions, source inventory, reconciliation links, reference comparisons and provenance remain ignored under data/pilot/development-2021/montreal-inventory/. The committed report contains aggregate findings and minimum blocker identifiers, not a full official draw or recovered count table.

New tests cover independent parsing, singles isolation, bracket progression, byes/codes, statuses/scores, bounded identities, one-to-one keys, conflicts and policy scope. A positive synthetic COMPLETE fixture confirms that deletion, duplication, changed score or wrong round prevents false completion. Row reversal and source-row permutations preserve links; changing match numbers cannot alter player-pair linkage or create chronology. Immutability, deterministic output and restricted-data Git boundaries are checked. Relevant Phase 1E–1I checks run without weakening historical policies.

Historical Phase 1J PDF development checks exposed bye-text attributes, tie-break token syntax and a final-score coordinate that also occurred within semifinal scores. These were corrected with explicit parsing and bounded geometry, not inferred source rows. Word-level coordinates separate an adjacent-column extraction collision. Initial identity review exposed the Riske name difference and ñ transliteration; both now retain bounded auditable decisions. Those three status-detail conflicts were unresolved in Phase 1J/1K; Phase 1L resolves their inventory detail under the separately approved rule. Earlier milestone reports and saved outputs retain their phase-specific gates; the separate Phase 1M report governs current completed-match audit coverage.

## Phase 1K draft verification

Historical Phase 1K record: the following pending states describe the drafting milestone. Phase 1L subsequently approves and implements D1-D8, as recorded below.
The [inventory status-detail proposal 0.1.0](wta-2021-montreal-inventory-status-policy.md) is limited to LS036/266, LS054/248 and LS026/276. It recommends pdf_retirement_corroborated_html_omission_preserved only when pinned source/PDF RET, the PDF-named retiring player and source/HTML/PDF identity, round, winner and numeric score all agree. HTML omissions and raw metadata remain preserved. The proposal fails closed on missing or conflicting evidence. All eight approval decisions remain PENDING_USER_APPROVAL; no policy application or new status record occurred.

Phase 1K revalidated all twelve references, four annual files, three manifest pins and the unchanged Phase 1I reconstruction. Direct source/HTML/PDF review and full-page PDF inspection confirmed the three RET markers, HTML omissions and legend names (Marie Bouzkova, Shuai Zhang, Anastasia Potapova). No affirmative contrary status was found in the scoped HTML blocks; F/Finished does not explicitly assert normal completion. The read-only baseline and final audit retain the same three blockers, 12/14 passing criteria and unchanged gates.

All 18 Phase 1J tests and 38 Phase 1I checks passed. Evidence hashes, sizes and modification times, existing data-file membership, overlay bytes/timestamp, restricted-data Git boundaries, pending decisions, links/anchors, placeholders, whitespace and the complete diff were checked. Only the report generator's follow-up prose changed; its generated report was reproduced without changing findings. No new data file, implementation script, overlay, dependency or network request was created.

## Phase 1L implementation verification

The user approved PROJECT_CONTEXT.md at bded8069163d41c886cf1576ea0fdd4cc1054b7b. Dean Oliver-inspired distinct-factor development, evidence-driven revisions, chronological splits and anti-overfitting constraints are standing guidance. Retirements/partial histories and walkovers are excluded by the approved primary Four Factors/Elo/evaluation design; primary Elo has no round/prestige bonus. These analytical designs are not implemented as populations or models. AGENTS.md now requires the context, status and relevant data contract before substantive work.

The three new inventory decisions use pdf_retirement_corroborated_html_omission_preserved. Freshly parsed pinned source/HTML/PDF evidence, named PDF legend entries, exact scope, unique linkage and matching raw fields are required. A failure in any target withholds all three decisions. A separate ignored inventory-status-resolutions.csv retains policy/version, original scores/statuses/legend, fingerprints, locators and conflict history. No Phase 1I record or raw extraction is rewritten.

All 41 Phase 1J/1L checks and all 38 Phase 1I checks passed. Relevant Phase 1E/1F/1G suites, Phase 1H evidence checks and Phase 1K baseline/legend checks passed without weakened gates. All 123 protected pre-existing files, including 99 data files, retain hashes, sizes and timestamps; only four approved derived inventory tables changed and one separate resolution CSV was added. Raw extractions, source/manifest files and the Phase 1I overlay are unchanged. All 114 local links/anchors across 17 Markdown files, placeholders, whitespace, full diff and restricted-data Git boundaries passed. Active evidence paths are limited to saved 2021 references and 2021/2023 annuals; no 2025 input was accessed or evaluated.

The first development run withheld all three decisions because PDF roster attributes differed from record-only columns. Comparing every recorded field, with separate complete-bracket and fingerprint checks, fixed this. A heading edit temporarily broke a historical documentation anchor; the original anchor was retained. A synthetic PDF-mutation test initially included the uncoded card's NA identifier; exact which-based selection fixed the test, and the full suite passed. A final report guard and in-memory failure-report test prevent successful-run narrative from appearing after an insufficient or failed audit. A documentation-check expectation was updated from historical REVIEW_REQUIRED to current COMPLETE. A read-only scan noted README's pre-existing missing final newline, and a quoting error prevented one documentation-edit command from running; the edit was applied directly instead. No raw evidence changed and no partial policy was applied.

## Phase 1M implementation and verification

The [completed-match audit](wta-2021-montreal-completed-match-coverage.md) reconstructs current pinned source/reference evidence, the exact Phase 1I overlay and the Phase 1L inventory policy before calculating eligibility. A second current reconstruction binds every supplied observation and policy proof to the same immutable evidence. Missing/changed evidence stops execution before writing; reading an older successful output does not establish a fresh pass.

All 57 non-bye records have unique dispositions. Five validated retirements and one walkover remain present but excluded from the denominator, numerator and Four Factors, Elo-update, rolling-history and forecast-evaluation status flags. LS049/Ferro–Tomljanovic is correctly retired under Phase 1I while its raw source status remains unresolved. Completed results require corroborated source/HTML/PDF winner and complete numeric score evidence. Generic F metadata or available counts alone never implies completion. Missing/unknown status withholds the gate rather than silently improving coverage.

The count denominator is 49 regardless of count availability. Forty-two unchanged source bundles pass all 43 required checks per match; seven separately authorized overlay bundles pass all 51 checks each. All 18 counts per bundle are required. Source-only coverage is 85.7143%; combined coverage is 100%; ceiling(0.90 × 49) is 45. Structural consistency does not independently establish statistic accuracy. The excluded RET+H64 source row retains an unevaluable game/score check rather than being labeled invalid or silently repaired. Historical apparent-play presence stays 47/54 and 54/54.

New base-R code and tests produce four ignored tables under data/pilot/development-2021/montreal-completed-match-coverage/: dispositions.csv, count-links.csv, structural-checks.csv and summary.csv. The 55 dispositions preserve identifiers, official links/locators, raw scores/status markers, adopted decisions, exclusions, provenance and policy versions. Count origins remain separate; no combined filled-in source table, canonical player orientation or model input is created. The structural-check table contains 2,421 audit rows, including excluded observations whose results never enter coverage.

All **45 Phase 1M checks**, **41 Montreal inventory checks** and **38 recovery checks** passed. Phase 1E annual-source, Phase 1F source-review, Phase 1G feasibility, relevant Phase 1H evidence and Phase 1K historical baseline/legend regressions also passed. Mutation tests cover fingerprints, pins, raw metadata, linkage, identity, round, winner, score, retirement evidence, overlay scope/orientation/provenance, structural validation, duplicates, retired relabeling and walkover/history inclusion. Synthetic missing counts leave the denominator unchanged; removing five bundles yields 44/49 and fails the numerical floor. Unknown status cannot yield PASS. Public workflow reruns produce identical returned objects and output bytes/timestamps. Existing assertions were not weakened.

All **137 protected pre-existing files**, including **104 data files**, retain their SHA-256, size and modification time. Only the two authorized existing documents change; the only new data files are the four ignored audit tables. The Phase 1I overlay remains 760695 bytes with SHA-256 2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5 and unchanged timestamp. Local documentation links/anchors, placeholders, whitespace, restricted-data Git boundaries and the complete diff were checked. Evidence paths remain confined to saved 2021 references and 2021/2023 annuals; no 2025 data was accessed. AGENTS.md, PROJECT_CONTEXT.md, policies, prior calculated outputs and portfolio were not modified.

The first new test run exposed a mutation fixture that assigned F to a record already in round F, so it had not actually changed the evidence. The fixture now assigns an invalid round and the complete suite passes. This was a test-input correction, not a relaxed rule or evidence discrepancy. A preliminary output-directory listing occurred before the first validated write and found no directory; the later run created exactly the four authorized outputs. No unresolved execution error remains. No dependency, download, Net Point Rating, factor, Elo update, canonical population, event admission or publication was introduced.

## Phase 1N evidence and proposed decisions

Historical Phase 1N record: the chronology-evidence audit implemented extraction only. Proposal 0.1.0 was PROPOSED_NOT_APPROVED with thirteen decisions PENDING_USER_APPROVAL and implemented FALSE. Its pinned Git record and generated outputs preserve those states. Phase 1O separately adopts the [permanent policy](wta-2021-montreal-chronology-policy.md); no operational chronology or model is implemented.

Revalidated literals are the source event-week label 20210809, overview Aug 9–15 and PDF header August 7–15, 2021. Their differing windows remain unexplained. Exactly LS001–LS007, LS042 and LS049 supply date-only published startDate/endDate observations: August 9, 13, 14 and 15. Every targeted SportsEvent says EventScheduled despite a finished card. The extractor isolates the exact match block rather than unrelated current metadata. Published dates remain separate from verified scheduling, actual start, completion, result availability, timezone, suspension and resumption; those concepts remain missing with reasons. Retrieval timestamps remain acquisition provenance.

There are 46/55 records with only event-level dates and 9/55 with match-page published dates. Among the 49 completed matches, those counts are 42 and seven. No verified actual start date/time or completion date/time was established for any record. LS007 publishes August 14 while the other three saved QFs publish August 13; its advancement to LS003 creates one same-published-day player edge, not proof of actual same-day play. Duration cannot supply a clock-time anchor.

Matching feeder positions in independently parsed HTML/PDF yield 54 direct advancement edges across 56 fully accounted player chains; 45 edges have completed records at both ends. All 49 completed matches have their within-event player progressions represented. Edges involving retired or walkover records preserve advancement evidence without adding their partial statistics to histories. No edge orders unrelated matches, and no global processing sequence is constructed. Zero published-date reversals were observed among edges with two saved pages; sparse, semantically unverified dates do not prove actual chronological consistency.

The four compared options have zero fully sufficient completed-match inputs under the proposed full forecasting gate: exact timestamps, verified-date batching, raw published dates used operationally and bracket-only ordering. Their narrower evidence coverage differs: zero verified timing bundles, seven published-date candidates and all 49 completed matches with within-event progression evidence. Partial ordering could support a separately approved ordinal-only experiment, but calendar windows, inactivity, prediction cutoffs and cross-event boundaries remain unresolved. A missing global timestamp is not itself proof that player-local Elo requires arbitrary global ordering.

Proposed D1–D13 cover use-specific Elo precedence/cutoffs; lagged-history requirements; corroboration before operational use of published dates; prohibition of event-week substitution; scoped bracket edges; same-player same-day handling; conditional conservative batching; suspension/completion/availability; preserved date conflicts; fail-closed missingness; an event-level dependency gate; cross-event extension; and a separate acquisition plan. Each decision records options, recommendation, leakage rationale, drawbacks, outstanding evidence and pending approval.

### Phase 1N verification and preservation

All **38 new chronology checks**, **41 inventory checks**, **38 recovery checks** and **45 completed-match coverage checks** passed. Phase 1E annual-source, Phase 1F source-review, Phase 1G feasibility, relevant Phase 1H evidence and Phase 1K historical baseline/legend regressions also passed. No old assertion changed. New tests cover exact page scope, missing-value semantics, unchanged eligibility, source-row permutations, arbitrary identifier renumbering in a synthetic graph fixture, valid player progression, LS007, date reversals/duplicates, altered fingerprints/identities/rounds/winners/scores/locators, invented timing, proposal nonadoption and deterministic public reruns. No network request or 2025 data access occurred.

The ten new ignored tables contain 55 dispositions, 990 field observations, 54 edges, 56 player-chain checks, three event observations, nine page observations, six unresolved-issue categories, four option comparisons, one summary and thirteen pending decision records. Full local outputs were inspected through aggregate/contract checks; official match-level material remains outside Git. The four proposed approaches remain BLOCKED under the full forecasting gate even though their narrower evidence prerequisites differ.

All **144 protected pre-existing files**, including **108 data files**, retain their SHA-256, size and modification time. Only status and the data contract change among pre-existing files. The only new data artifacts are the ten authorized ignored chronology tables. The Phase 1I overlay remains 760695 bytes with SHA-256 2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5 and unchanged timestamp. All 131 local links/anchors across 19 Markdown files, pending decision labels, placeholders, whitespace, restricted-data boundaries and the complete diff were checked. AGENTS.md, PROJECT_CONTEXT.md, policies, earlier reports/outputs and portfolio remain unchanged.

An initial direct PDF-extraction command could not find pdftotext on the shell PATH. The existing bundled executable already used by repository functions was then used successfully; no dependency was added. Inspection also exposed unrelated 2026 structured event metadata in the saved draw page, reinforcing exact event/match scoping. No audit discrepancy required an invented date, policy adoption or methodological workaround. The final suites report no unresolved execution error.

## Phase 1O policy adoption

The user explicitly approves the Phase 1N recommendations and the permanent-policy rename. All thirteen decisions are APPROVED; operational chronology remains NOT_IMPLEMENTED. Last-K versus elapsed-time windows remain unselected; unknown same-day availability blocks the dependent result; daily batching remains an inactive candidate requiring separate approval; the gate requires safe evidence for each use-specific dependency without universal timestamps; acquisition planning grants no network or raw-file permission.

The historical chronology audit and all ten saved outputs retain their proposal-era states. Its test now reads the pinned original proposal from Git and retains every historical assertion; separate policy tests verify current adoption. Evidence findings, exclusions, thresholds and admission/publication gates do not change.

Before the adoption commit, all 38 historical chronology checks and the new policy contracts passed, including eleven rejected invalid-document mutations. All Phase 1N finding/evidence/partial-order paragraphs remain verbatim. A snapshot comparison verifies 154 protected files, including all 118 data files, unchanged in SHA-256, size and modification time; no data file was added or removed. All 131 local links/anchors across 19 Markdown files pass. The remaining historical regression suites are recorded with final Phase 1O verification below when complete.

## Phase 1O acquisition plan

Historical Phase 1O: the [bounded acquisition plan](wta-2021-montreal-chronology-acquisition-plan.md) was drafted as version 0.1.0, PROPOSED_NOT_APPROVED. Policy adoption commit: c2ce9416fd0d3ed0f49c98d54d8b4e69c3e4e1ec, Adopt Montreal chronology policy. No acquisition or operational chronology follows from it.

The plan assesses remaining WTA match pages, the uncoded walkover, daily order of play, official results/reports, WTA metadata semantics, Open Tennis Data with explicit upstream-dependence checks, and separately reviewed historical archives. Locally verified scope is 45 unsaved coded pages: 42 completed and three RET; the uncoded WO has no invented LS013 endpoint. An order-of-play href occurs in both saved overview/draw pages, but its target was not accessed and its content, accessibility and semantics are unverified.

Historical Phase 1O recommendation, subsequently addressed in Phase 1P: Stage A, at most two direct GET attempts for WTA terms then the exact locally linked 2021 order-of-play page, with the second conditional on the rights review. Stage B proposes at most three diagnostic documents for LS007/LS003/LS004; Stage C at most 42 completed pages plus seven daily documents after successful diagnostics; Stage D at most four OTD documents then one separately approved 2021-only payload. Later stages, optional semantic discovery and archives each require separate approval; ceilings are not automatic authority or quotas. No exact future daily-document URL or OTD payload is asserted to exist.

At Phase 1O completion, A1–A10 remained pending: provider/discovery scope; request/transport limits; storage/manifest; rights; diagnostic sample and evidence acceptance; expansion conditions; independent corroboration; archives; stopping/failure rules; review deliverables and subsequent authorization. Proposed directories were not created. More published dates alone cannot establish actual timing or historical result availability. All admission, modeling, publication and locked-test boundaries remain unchanged.

### Phase 1O final verification

All 38 historical chronology checks, 45 completed-match coverage checks, 38 recovery checks and 41 inventory checks passed. Phase 1E/F/G, relevant Phase 1H and historical Phase 1K regressions passed without relaxed assertions. The policy verification rejects eleven invalid-document mutations and checks all thirteen approved decisions, the five clarifications, unchanged blocked gates and preserved historical states. The plan verification rejects eight invalid-document mutations, checks all seven candidate groups and ten pending decisions, derives the 45/42/3 page scope locally, verifies the two saved order-of-play links and confirms no acquisition directories were created.

All 154 protected pre-existing files, including all 118 data files, retain SHA-256, size and modification time; no data file was added or removed. The ten Phase 1N outputs, raw evidence, manifests and Phase 1I overlay remain unchanged. The overlay remains 760695 bytes, SHA-256 2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5. All 140 local links/anchors across 20 Markdown files pass, alongside whitespace, affected-state, restricted-data Git and complete-diff checks. No portfolio change, dependency installation, network request, new raw file, 2025 data access or model work occurred.

Execution notes: historical source regressions invoke downloader entry points only for existing-cache reuse with request functions blocked; no network/download action occurred. Thus the requested prohibition on calling any download function was not literal at the legacy test-entry-point level, although acquisition remained entirely disabled. Read-only inspection probes used a nonexistent ancestor/file path and an unavailable process listing; existing repository paths, test logs and process completion supplied the checks. An initial exploratory CSV read treated blank date fields as nonmissing; explicit empty-string NA handling corrected it before deriving the verified 45/42/3 plan counts. No evidence or output changed, no production assertion was weakened, and no test remains failed.

## Phase 1P Stage A rights triage

The user explicitly approved only A1–A4, A9 and A10 for Stage A. The plan is now version 0.2.0, APPROVED_STAGE_A_ONLY; A5–A8 remain PENDING_USER_APPROVAL. Stages B/C/D and optional discovery/archive routes are UNAUTHORIZED. The new base-R acquisition workflow and offline test suite use existing tools only, with no dependency installation.

Request 1 was the exact WTA terms URL: GET at 2026-09-22T14:41:17Z; HTTP 200; curl exit 0; no redirect, login or bot check; text/html;charset=utf-8; 199865 original response bytes retained at 14:41:18Z. The conduct provisions restrict automated access; the limited personal/noncommercial-copy provision does not clear the programmatic method. Result: PROHIBITED access, AMBIGUOUS_STOP_REQUIRED retention for that method. User approval does not override provider terms. This operational stop is not a legal conclusion.

The Montreal 2021 order-of-play URL was NOT_ATTEMPTED_RIGHTS_GATE. One of two slots was consumed; no further request remained authorized. No daily-document link was newly established, and none was followed. All order-of-play content, schedule, actual-time, timezone, completion and availability questions remain unassessed at that target. The privacy-policy link seen in the terms was not requested. No search, redirect, retry, hidden API, browser, OTD, archive, organizer or provider contact occurred.

Exactly eight new ignored files were retained: one raw terms HTML; an attempt, response and manual review RDS record with three SHA-256 seals; and one final CSV manifest. The report pins the response and final manifest fingerprints. Reservation precedes the outbound call, failed attempts cannot retry, and request two requires a readable response plus affirmative access and retention review. Ordinary runs validate saved evidence without network access; an incomplete positive gate cannot publish a final manifest. No earlier evidence, overlay, historical decision table or analytical output is rewritten.

Execution corrections: the first live call emitted an R stdout/stderr capture warning, although HTTP 200 and body provenance were intact. Explicit capture removes that warning without retrying the request. A temporary documentation helper had an invalid escape and was corrected offline. Code review also added guards against finalizing a still-open positive gate or reconstructing a missing reviewed cache. These corrections did not change acquired bytes, provider interpretation or earlier research outputs.

### Phase 1P verification

All 57 new Stage A offline checks pass. Chronology policy verification rejects eleven invalid-document mutations; historical acquisition-plan verification rejects eight and retains its original 45/42/3 scope/link assertions against the pinned Phase 1O document. Current checks separately enforce six Stage A-only approvals, pending A5–A8 and unauthorized later stages. The superseded no-directories assertion now validates the authorized saved Stage A records.

All 38 chronology-evidence, 45 completed-match coverage, 38 recovery and 41 inventory checks pass. Phase 1E/F/G source-evidence, relevant Phase 1H and historical Phase 1K regressions pass. Historical annual/reference downloader entry points were invoked only for validated cache reuse with request functions blocked, as explicitly permitted for this task. The Stage A fixture suite also blocks its live transport. Real Stage A cached reruns made no requests and preserved all eight files in hash, size and modification time.

All 157 protected pre-existing files, including all 118 existing data files, remain identical in SHA-256, size and modification time. Exactly eight new data files exist, all confined to approved ignored Stage A roots and untracked. The Phase 1I overlay remains 760695 bytes, SHA-256 2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5, mtime 1789918672. No pre-existing data was removed. All 145 local links/anchors across 21 Markdown files pass. Whitespace, current-state consistency, ignored-file boundaries and the complete diff were inspected. No 2025 dataset/response, dependency, portfolio change, model, push or publication occurred.

Installed runtime checked directly: Rscript 4.6.0 and curl 8.7.1; base R only, no added packages. Two temporary documentation/check helpers had syntax errors (an invalid escape and a malformed file vector); both were corrected and passed before completion. No production test remains failed. The one live-request output-capture warning is described above; no second network attempt was used to correct it. Git warned that docs/ is ignored during staging; explicit report staging and the final staged-file list verified exactly the eight intended code/documentation files, with no raw or pilot files.

## Smallest recommended next task

Prepare an offline rights-resolution decision brief using the saved terms only, identifying the exact proposed access/retention method and questions for possible provider clarification. The user must decide whether to pursue provider clarification or separately approve a bounded alternative-source documentation review. Do not contact anyone, request another URL or invoke Stage B/C/D automatically. The unused request slot supplies no authority. This recommendation has not been implemented.

Prediction cutoff, last-K versus elapsed-time history, result availability, batching validation and cross-event history remain later decisions. Canonical eligibility, factor-data admission, models and publication remain blocked. No new dependency, wider structure, methodological replacement, licensing assumption, portfolio integration or publication is approved. Portfolio was not modified; no push occurred.

## Git and handoff

Historical Phase 1K began clean on main at `1243886891941f30263f56eb4feb4b1ab2fa45dd`, `Reconcile Montreal inventory offline`, thirteen ahead / zero behind the existing local origin/main. No remote refresh occurred. Completion message: `Draft Montreal inventory status policy`. The final response records the exact resulting hash and Git state. The Phase 1J report retains its historical start/commit description.

Every next task must finish with a response-only ChatGPT Handoff of approximately 2,000 words and strictly no more than 2,000 words. Do not invoke a handoff tool or create another task without a separate request.

Phase 1L began at bded8069163d41c886cf1576ea0fdd4cc1054b7b, Clarify model development principles, clean main, sixteen ahead / zero behind existing origin/main. Step 1: Adopt project research context. Step 2: Implement Montreal inventory status policy. No remote refresh or push. The final response records both exact hashes and final Git state.

Phase 1M began at 62cb0ba9c7224d27e01e1642cfb07c06a1313e65, Implement Montreal inventory status policy, clean main, eighteen ahead / zero behind existing origin/main. Completion message: Audit Montreal completed-match coverage. The final response records the resulting hash and final Git state. No remote refresh or push occurred.

Phase 1N began at 7ef2d68664ac671c3806b192d046c564d157dc3d, Audit Montreal completed-match coverage, clean main, nineteen ahead / zero behind existing origin/main. Completion message: Draft Montreal chronology policy. The final response records the resulting hash and final clean state. No remote refresh or push occurred; the commit does not adopt the proposal.

Phase 1O began clean on main at 5156ac2c34972bbef4584df62667f0bfda6f44c0, twenty ahead / zero behind the existing local origin/main. Separate completion messages: Adopt Montreal chronology policy; Draft Montreal chronology acquisition plan. No remote refresh or push. The final response records exact hashes and final state.

Phase 1P began clean on main at 10816b9f839d6e501674cc6efe3d2053a7826d5f, Draft Montreal chronology acquisition plan, twenty-two ahead / zero behind existing local origin/main. Completion message: Audit Montreal chronology Stage A sources. No remote refresh or push. The final response records the resulting exact hash and final Git state.
