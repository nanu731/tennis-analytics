# Phase 1C: 2023 Indian Wells official match inventories

Verified **2026-09-14**. **Implementation complete; WTA inventory passes, ATP inventory remains blocked by conflicting official identities.** No development-panel expansion or modeling occurred.

## Purpose and evidence labels

Reconcile ATP and WTA 2023 Indian Wells main-draw singles against the two unchanged Sackmann pilot subsets. The flagship asks whether interpretable Four Factors can improve calibration over surface-adjusted Elo; this milestone establishes coverage, not predictive performance. The later Challenger project remains deferred.

**Verified** means inspected bytes, rendered pages or executed calculations. **Source observation** means what a publisher displays, without assuming independent accuracy. **Implemented** describes code/adopted rules. **Proposed** and **user decision required** identify unfinished choices.

The starting state was clean `main` at `ff701d0d0c2d6e57ca6765aeddee4c26b7fd7915` (`Document WTA anomaly quarantine policy`), five ahead of the existing local remote reference. Applicable instructions, five commits, the contract, pilot report, Phase 1B policy, status, licensing notice, manifests and preceding scripts were read. Annual and Phase 1B reference hashes were recalculated before editing. No remote synchronization occurred.

## Official references and rights

The [manifest](../data/manifests/inventory-reference-files.csv) has eight records for six allowlisted URLs: four original files, two failed HTTP acquisitions and two browser-service representations of the failed URLs. Browser access times are not origin retrieval times; the service reported a crawl age of two months.

| ID | Reference | Retrieved/accessed UTC | Bytes |
| --- | --- | --- | --- |
| atp_draw_pdf | [ATP/ProTennisLive PDF](https://www.protennislive.com/posting/2023/404/mds.pdf) | 2026-09-14T13:16:31Z | 218947 |
| atp_results_browser | [ATP results](https://www.atptour.com/en/scores/archive/indian-wells/404/2023/results), browser representation | 2026-09-14T14:09:34Z | 371115 |
| atp_draw_browser | [ATP draws](https://www.atptour.com/en/scores/archive/indian-wells/404/2023/draws), browser representation | 2026-09-14T14:09:36Z | 287421 |
| wta_draw_pdf | [WTA PDF](https://wtafiles.wtatennis.com/pdf/draws/2023/609/MDS.pdf), reused | 2026-09-14T12:47:51Z | 834848 |
| wta_draw_page | [WTA draw HTML](https://www.wtatennis.com/tournaments/609/indian-wells/2023/draws), reused | 2026-09-14T12:47:52Z | 2080027 |
| wta_match | [WTA LS033 HTML](https://www.wtatennis.com/tournaments/609/indian-wells/2023/scores/LS033), reused | 2026-09-14T12:47:50Z | 367834 |

| ID | SHA-256 of retained file |
| --- | --- |
| atp_draw_pdf | `0aee08d0f6d621604eff83f5b7ade187999a5d87e957f19ba2db38e9eb1e7fc5` |
| atp_results_browser | `1a23f1673b6ddbf52922a5cb44f5ae3ec476813853751b41944d5e918fcdb58f` |
| atp_draw_browser | `aa507a95a12556fc143ca23149669b1815ebcd02d3503573daa3a11e8e4a5513` |
| wta_draw_pdf | `573778a54fb6168a4d0dd731ca0426dcd4c2afb31606af948f8b314a93f0e960` |
| wta_draw_page | `9ab3bdc0816ebeabe050c6c97f363cfc9d2bda0d2958b141341d38361cc4575a` |
| wta_match | `de52fe2f62ce94acfaa34ee368a69560b2deb3fb0e9539a2c46df71d8e8b3196` |

Direct ATP results/draw attempts at **2026-09-14T13:16:32Z** returned **403 Forbidden**. Their rows have no invented file size, hash or successful retrieval time. Failed states are preserved without repeated requests. WTA paths, timestamps, sizes and hashes match Phase 1B; no WTA redownload occurred. The supplementary Phase 1B reference was reverified but does not define official inventory.

**Rights limitation:** User authorization to cache references is not a provider grant. Official pages/PDFs remain copyrighted; no open-data or republication rights are inferred. ATP extraction/redistribution rights remain unestablished, and the contract's previous WTA terms review still applies. No new terms were acquired or accepted. Raw references and complete tables remain ignored. No new licensing finding required changing [DATA_LICENSE.md](../DATA_LICENSE.md). Sackmann attribution and applicable CC BY-NC-SA obligations remain separate from MIT code licensing.

## Inventory and extraction

Every non-bye main-draw singles encounter is expected, including walkovers. Byes remain separate bracket observations. A walkover belongs to inventory but is unplayed; retirement matches are played with partial statistics, without settling model eligibility.

**ATP:** The parser reads saved, overlapping browser-service views, checks agreement of repeated source lines and requires consecutive line coverage within the main-draw sections. Qualifying and navigation are excluded. Both results and draw representations supply 127 entries including byes; all 127 unordered pairs and winner-oriented set values agree.

Existing `pdftotext` supplies PDF coordinates. A layout-specific parser traverses both halves through all rounds, checks both champion boxes and preserves 127 PDF observations. Of 127 comparisons with HTML, 123 agree and four contradict identities. The first strict traversal stopped where Wawrinka advances from a pair that does not contain him. Visual review confirmed the source contradiction. The parser now preserves that inconsistency without repairing it. The HTML inventory is a candidate denominator; ATP gate approval remains withheld.

**WTA:** The first seven singles round containers contain 64/32/16/8/4/2/1 entries. Player links supply full-name slugs, while displayed names and both sides' set/tie-break cells remain in raw text. All 128 PDF entrant/bye positions agree with HTML.

The saved PDF was released **17 Mar 2023 7:49 PM** and has blank champion boxes. The final comes from saved HTML LS001, including the first-set 13–11 tie-break evidence. PDF `61 RET` and `30 RET` supply explicit retirement markers for LS037 (Cirstea–Keys) and LS058 (Peterson–Zhang); HTML only marks them finished. The Tsurenko–Sabalenka walkover has visible `WO` but no HTML match code. Its audit ID is `WTA-HTML:R32:block16`, not an invented LS031 ID.

**Manual review:** Both halves of both PDFs were rendered and inspected, covering early rounds/byes, semifinals, champion boxes, all four ATP retirements, both WTA retirements, the walkover and ATP conflict branches. No full table was hand-transcribed. Manual interpretations and page/round locators are recorded in `normalization-decisions.csv`. WTA PDF result cells beyond these selected checks were not individually reconciled; complete WTA matching uses HTML. Visual samples do not independently validate match statistics.

## Name, round, score and status normalization

Normalize capitalization, whitespace, punctuation/apostrophes, diacritics and comma-separated surname-first names. Joined tokens handle `J.J. Wolf`/`J J Wolf` and `Xinyu Wang`/`Xin Yu Wang`; `Xiyu Wang` remains distinct. Initial/prefix matching requires compatible remaining surname tokens and exactly one event-roster candidate. Surname-only and ambiguous matches are withheld.

One reviewed event-local alias maps official `Albert Ramos-Vinolas` to source `Albert Ramos`, corroborated by the unique given name, opponent and round. Both labels remain recorded; no source values change.

Normalize round labels to R128/R64/R32/R16/QF/SF/F. Preserve score order, unfinished games and losing tie-break points: `76(5)` becomes `7-6(5)`, `Ret'd` becomes `RET`, `W/O` becomes `WO`; spacing and dash variants normalize. Original cell text, including both WTA tie-break totals, remains in `raw_text`. For cell-based pages, `raw_score` is the extracted winner-oriented serialization, not a claim of a single literal page string. Empty or incomplete unmarked scores never become completed matches.

Match on **tour + Indian Wells edition + main-draw singles + round + unordered linked player-ID pair**. Only then compare winner, loser, score, status and played state. Source match numbers are locators, not official IDs. This event-local audit crosswalk is not a canonical production table.

Every official non-bye entry and source row receives one disposition: exact, normalized, matched with conflict, unmatched on its side, identity ambiguous, or status unresolved. Exact compares extracted identity/score serialization; normalized requires documented conversion. Conflicting official evidence overrides an otherwise exact match. Duplicate candidates are never resolved by nearest name or score.

## Verified results

| Measure | ATP | WTA |
| --- | --- | --- |
| Positions / byes / entrants | 128 / 32 / 96 | 128 / 32 / 96 |
| Non-bye results / source rows | 95 / 95 | 95 / 95 |
| Played / completed / retired / walkovers | 95 / 91 / 4 / 0 | 94 / 92 / 2 / 1 |
| Exact / normalized / conflicting matches | 77 / 15 / 3 | 0 / 95 / 0 |
| Official-only / source-only | 0 / 0 | 0 / 0 |
| Ambiguous result-to-source mappings / unresolved denominator statuses | 0 / 0 | 0 / 0 |
| Duplicate accepted links | 0 | 0 |
| Results-inventory recall | 95/95 = 100% | 95/95 = 100% |
| Source precision against results inventory | 95/95 = 100% | 95/95 = 100% |
| Contradictory secondary official observations | 4: three matches, one bye | 0 identified |
| Inventory gate | **BLOCKED** | **PASS** |

Zero ambiguous ATP result-to-source mappings does not erase PDF-versus-HTML identity conflicts. Recall/precision describe correspondence to the candidate results inventory, not acceptance of all official evidence.

| Round | ATP official / source | WTA official / source |
| --- | --- | --- |
| R128 | 32 / 32 | 32 / 32 |
| R64 | 32 / 32 | 32 / 32 |
| R32 | 16 / 16 | 16 / 16 |
| R16 | 8 / 8 | 8 / 8 |
| QF | 4 / 4 | 4 / 4 |
| SF | 2 / 2 | 2 / 2 |
| F | 1 / 1 | 1 / 1 |

The 32 additional byes per tour occur in R128. ATP retirements occur in R128 (one), R64 (two), R16 (one). WTA has two R64 retirements and one R32 walkover. These statuses agree with source markers. Round totals supplement record-level matching.

## Every unresolved official conflict

1. **PDF page 1 positions 15–16, R128 block 8:** Carreño Busta has a bye; HTML identifies Albot. This is a bye observation, not an additional non-bye match.
2. **PDF page 1 R64 block 4:** Murray faces Carreño Busta in the feeder pair, versus Albot in HTML and source `2023-0404:266`. Score agrees: `6-4 6-3`.
3. **PDF page 1 positions 59–60, R128 block 30:** Kudla defeats Vukic, versus Wawrinka in HTML and source `2023-0404:208`. Score agrees: `6-4 1-6 6-1`.
4. **PDF page 1 R64 block 15:** Kecmanovic/Kudla advances `S. WAWRINKA`, absent from that pair. HTML and source `2023-0404:255` identify Wawrinka–Kecmanovic, `7-6(8) 6-4`.

All four remain in `reference-conflicts.csv`; the three non-bye matches are `matched_with_conflict` on both reconciliation sides. No identities were merged or corrected. Cause and reference precedence remain unresolved. No exception was approved. No primary-results-only or source-only rows remain.

## Separate coverage and admission gates

| Gate | ATP | WTA |
| --- | --- | --- |
| Inventory | Blocked by PDF conflicts | Pass |
| Aggregate-source presence | 95/95 against results inventory | 95/95 |
| Numerical joint presence, played denominator | 95/95 | 94/94 |
| Structural checks, played bundles | 95 valid, 0 flagged | 93 valid, 1 invalid |
| Valid-count coverage / 90% event floor | 100%; numerical pass | 98.9362%; numerical pass |
| Event factor-data admission | Blocked: inventory and retirement policy | Not admitted: retirement policy |
| 95% tour-season factor-data gate | Not tested | Not tested |
| Rating readiness | Blocked: chronology/status policy | Blocked: chronology/status policy |
| Forecast readiness | Blocked: chronology/status policy | Blocked: chronology/status policy |

ATP numerical coverage remains conditional on the candidate results inventory. WTA all-row joint presence is 94/95; the walkover lacks counts and is outside the 94-match played denominator. Retirements remain in the reported sensitivity; final eligibility is unapproved.

**Phase 1B preserved:** `2023-609:268` / LS033 is present, played, numerically populated, structurally invalid and wholly quarantined. It leaves the valid numerator and remains ineligible for factors, ratings and forecasts. All four reasons remain: structural count conflict, cross-source conflict, unresolved status metadata and chronology. Completed result evidence resolves inventory denominator status without erasing scheduled JSON-LD metadata. The 22-versus-29 service-game inconsistency is not corrected. Statistical agreement does not prove independent accuracy.

Tournament-week dates and source numbers do not establish actual match dates, same-day order or completion order. No chronology implementation occurred.

## Reproduction, outputs and checks

[Downloader](../R/download_inventory_references.R) verifies/acquires only allowlisted references, preserves bytes and failed HTTP states, and validates restored browser captures. The existing browsing tool supplied those captures after direct HTTP failure. **Fresh-machine limitation:** base R cannot obtain browsing-service snapshots itself; restore exact manifested captures or separately authorize replacement evidence. Offline reconciliation makes no network requests.

[Reconciliation](../R/reconcile_indian_wells_inventory.R) generates 14 ignored CSVs under `data/pilot/inventory/`: official-matches, source-matches, match-reconciliation, official-only, source-only, conflicts, identity-review, status-summary, inventory-summary, normalization-decisions, round-summary, reference-comparison, reference-conflicts and atp-pdf-observations. Four ignored page PNGs support visual review. New ATP references stay under `data/raw/reference/indian-wells-2023-inventory/`; WTA paths are reused.

The pilot generator consumes the inventory summary and checks its manifest hashes; run reconciliation before regenerating the report. Phase 1B audit code is unchanged. R 4.6.0, base R and existing Poppler/checksum tools were used; no dependency was installed.

Verification covers downloader reruns preserving bytes/hashes/timestamps/mtimes; byte-identical reconciliation reruns; pilot and Phase 1B audit reruns; source/subset hashes and cell-by-cell comparisons; one-disposition and unique-link assertions; and in-memory tests for unordered pairs, reversed winners, name/round/score normalization, meaningful tie-break differences, byes, walkovers, retirements, unknown scores/statuses, conflicts, unmatched rows and duplicate/ambiguous identities. No synthetic dataset was persisted.

Failed approaches: direct ATP HTML 403; PDF traversal exposed a genuine contradiction; initial browser parsing mishandled source-line boundaries and bye records; a whitespace rule joined sets after parenthesized tie-breaks; empty-table testing exposed a zero-row assignment bug; one report edit briefly had an extra parenthesis. These were corrected before final verification. Initial rendering emitted font/cache errors and was interrupted; existing font configuration plus a temporary writable cache produced inspected pages. A process-list diagnostic was unavailable. Raw reference bytes were never edited to fix a parser.

## Recommended next milestone

**Do not proceed to bounded 2021–2023 acquisition yet.** Phase 1D should review and explicitly approve an event-scoped reference-precedence decision for the two ATP branches, implement that decision, preserve dissenting PDF observations, rerun reconciliation and update gate documentation. The agreeing HTML records are the recommended candidate authority; that recommendation is **not implemented as gate approval**. Acquire no additional season during that step.

Broader acquisition later needs separately authorized files/paths. Chronology source/order, final retirement/default rules, rating-history scope, statistical choices/dependencies and public derived-data licensing remain user decisions. Portfolio was not modified; nothing was pushed, published or deployed.

Require the next task to finish with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000, in the response only.
