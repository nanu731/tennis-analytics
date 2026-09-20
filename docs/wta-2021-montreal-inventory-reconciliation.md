# WTA 2021 Montreal inventory reconciliation

Phase 1J, 2026-09-20. **Inventory reconciliation: REVIEW_REQUIRED.** Source rows: 55. This is not an event-admission pass.

## Contract fixed before comparison

The implementation defines fourteen criteria before comparing totals. COMPLETE requires every criterion: independent singles isolation and bracket traversal; entrants/byes/round advancement; resolved event identities; unique keys and one-to-one non-bye links in both directions; agreeing rounds, winners and scores; status/reference differences covered by an existing exact scoped policy; accounted code gaps; immutable evidence and separate recovery layers. Parser insufficiency yields BLOCKED_INSUFFICIENT_LOCAL_EVIDENCE; unresolved comparisons yield REVIEW_REQUIRED. Source row totals are not parser targets.

Event admission and analytical coverage remain NOT_EVALUATED; modeling_authorized remains FALSE. Chronology and retirement/walkover analytical eligibility remain unresolved. Publication remains blocked pending rights review.

## Independently extracted official inventories

| representation | bracket_positions | entrants | byes | bracket_blocks | nonbye_results | walkovers | explicit_retirements | unresolved_status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| HTML | 64 | 56 | 8 | 63 | 55 | 1 | 0 | 5 |
| PDF | 64 | 56 | 8 | 63 | 55 | 1 | 5 | 0 |


HTML extraction isolates the data-event-type=LS tab, excluding LD doubles and RS qualifying. It traverses every round container and match table, including byes and cards with no LS code. IDs, abbreviations, full player slugs, winner indicators, score cells, tie-break superscripts, status attributes, markers/omissions and DOM locators remain separate observations.

PDF extraction uses the pinned one-page MAIN DRAW SINGLES header, Montreal/year checks, independently read left-column entrants and measured result-column coordinates. Word-level segments separate adjacent columns that pdftotext merges into one line. Feeder pairs are constructed from prior PDF advancement, never Sackmann. Entrant/result coordinates and original compact scores remain local. The complete PDF layout was visually inspected. Neither parser receives source rows as a template.

| round | HTML_nonbye | PDF_nonbye |
| --- | --- | --- |
| R64 | 24 | 24 |
| R32 | 16 | 16 |
| R16 | 8 | 8 |
| QF | 4 | 4 |
| SF | 2 | 2 |
| F | 1 | 1 |


## Linkage and comparison results

| measure | value |
| --- | --- |
| one_to_one_source_links | 55 |
| source_only_unmatched | 0 |
| official_only_unmatched | 0 |
| duplicate_source_keys | 0 |
| duplicate_HTML_keys | 0 |
| duplicate_PDF_keys | 0 |
| ambiguous_or_unmatched_identities | 0 |
| winner_conflicts | 0 |
| score_conflicts | 0 |
| raw_status_detail_differences | 5 |
| existing_scoped_resolutions | 2 |
| unresolved_status_differences | 3 |
| unresolved_HTML_PDF_conflicts | 3 |


Links use the event/draw, round and unordered resolved source-player ID pair. Winner, score and status comparisons occur afterward. Source match_num is retained only in the audit identifier; row order and match number are not dates, sequencing or linkage keys.

HTML and PDF each yield 63 bracket blocks: eight bye advancements and 55 non-bye results. The latter include one walkover; 54 describe apparent play. Score agreement here means normalized winner-oriented numeric score agreement, with RET/WO/suffix detail retained and separately evaluated; it does not mean the raw strings agree.

## Identity decisions

The event-scoped table records all 56 entrants, source candidate IDs/names, official IDs, both original labels, normalization method and opponent/round corroboration. No fuzzy matching is used. Case, punctuation, name order and explicit ñ-to-n normalization are formatting rules. General transliteration on this runtime split Garbiñe incorrectly; the explicit character rule preserves Garbine without changing originals.

Cori Gauff/Coco Gauff extends the already documented LS006 linkage only within this event, after all four opponent/round pairings agree, including the uncoded walkover. Alison Riske/Alison Riske Amritraj is a bounded exact candidate decision corroborated by the shared R64 Sorana Cirstea pairing in both official representations and source. It is not a global alias or a claim about the reason for the name change. All other full event-roster names resolve by deterministic normalization.

## LS-code sequence

| unique_codes | duplicate_codes | absent_code_labels | uncoded_records | uncoded_record_ids | state | cause |
| --- | --- | --- | --- | --- | --- | --- |
| 62 | FALSE | LS013 | 1 | draw_html:R16:6 | code_gap_accounted_for_by_uncoded_walkover_card_no_code_assigned | Underlying reason for omitted code attribute unknown; no LS013 code synthesized |


The HTML contains 62 unique supplied LS codes in the LS001–LS063 range. The uncoded R16 block at position 6, between coded LS012 and LS014 blocks, contains Gauff versus Konta and an explicit WO advancement. The PDF independently shows the same pair and walkover, and the source has its corresponding row. Thus an uncoded card accounts for the result at the code-sequence gap; no match is synthesized and no LS013 code is assigned. The publisher's reason for omitting the attribute remains unknown. Eight bye cards are retained separately; they do not explain this particular gap.

## Remaining blockers

| source_audit_id | official_code | round | source_status | html_status | pdf_status | comparison_state |
| --- | --- | --- | --- | --- | --- | --- |
| sackmann:WTA:2021-806:276 | LS026 | R32 | retirement | unresolved | retirement | linked_with_status_detail_difference |
| sackmann:WTA:2021-806:248 | LS054 | R64 | retirement | unresolved | retirement | linked_with_status_detail_difference |
| sackmann:WTA:2021-806:266 | LS036 | R64 | retirement | unresolved | retirement | linked_with_status_detail_difference |


LS036 (Sakkari–Bouzkova), LS054 (Konta–Zhang) and LS026 (Gauff–Potapova) have RET in source/PDF but no retirement marker in the HTML draw; numeric scores and advancing players agree. They remain unresolved status-detail/reference conflicts. The saved PDF also names the retiring players in its retirement legend. No new match-page evidence was acquired, and the existing LS042/LS049 policy was not extended to these matches.

The adopted policy resolves only LS042/Martincova and LS049/Tomljanovic in this audit, preserving their raw HTML omissions, source scores and EventScheduled observations in the unchanged Phase 1I layer. H64/H61 remain unexplained. The seven completed-match recovery resolutions are neither rewritten nor generalized. There are no remaining identity, round, winner, normalized numeric score, duplicate or unmatched conflicts; the three status differences prevent COMPLETE.

## Criterion results

| criterion | passed |
| --- | --- |
| pinned_evidence_and_overlay_unchanged | TRUE |
| main_draw_singles_isolated | TRUE |
| HTML_bracket_positions_entrants_byes_progression | TRUE |
| PDF_bracket_positions_entrants_byes_progression | TRUE |
| event_scoped_identities_resolved | TRUE |
| unique_source_keys | TRUE |
| unique_official_keys | TRUE |
| every_source_has_one_official_nonbye | TRUE |
| every_official_nonbye_has_one_source | TRUE |
| round_winner_score_agree | TRUE |
| status_differences_within_existing_policy_scope | FALSE |
| HTML_PDF_agree_or_existing_scoped_resolution | FALSE |
| code_gaps_accounted_for_without_inventing_codes | TRUE |
| source_reference_overlay_layers_separate | TRUE |


## Evidence, separation and rights

All twelve files in [the Montreal manifest](../data/manifests/montreal-reference-files.csv), relevant annual files and the three Phase 1I manifest pins are revalidated. Archive revision remains 83733587353df8a41f2fd4f516147d5aa83f5a8d. The Phase 1I release is rebuilt in memory and compared with the existing RDS; its bytes, size and timestamp remain unchanged. No recovered count is merged into this inventory. The audit labels 47 original bundles and seven supplemental bundles separately, and retains no analytical eligibility decision.

Source-only statistical presence remains 47/54 = 87.0370%; the separate implemented source-plus-overlay presence remains 54/54 = 100%. Neither is valid analytical coverage. The 90% event and 95% tour-season thresholds are unchanged; no admission gate or tour-season coverage test was performed.

Raw pages, full draw extractions, event identity decisions, linkage/conflict tables and the recovery release remain ignored and untracked. Only code, tests, aggregate findings and the minimum blocker identifiers are committed. Local research authorization is not provider permission. [DATA_LICENSE.md](../DATA_LICENSE.md) and [recovery policy 1.0.0](wta-2021-montreal-recovery-policy.md) continue to govern; match-level and aggregate publication require separate rights review. Portfolio is untouched.

## Reproduction and verification

Run from the repository root with existing base R, SHA-256 tools and pdftotext:

```sh
Rscript R/reconcile_montreal_inventory.R
Rscript R/test_montreal_inventory.R
```

Generated local tables live in data/pilot/development-2021/montreal-inventory/: html-draw.csv, pdf-draw.csv, pdf-entrant-positions.csv, identity-decisions.csv, source-inventory.csv, reconciliation-links.csv, reference-comparisons.csv, official-only.csv, criteria.csv, code-sequence.csv, summary.csv and provenance.csv. No new dependency or network access is used. Missing fingerprints stop before output; parser insufficiency is reported explicitly.

Tests cover singles isolation; independent HTML/PDF rounds and bracket traversal; doubles/qualifying contamination; code uniqueness/gaps; entrants/byes/progression; walkover and retirement omissions; tie-break/incomplete scores; reversed orientation; exact names and bounded aliases; ambiguous/unmatched identities; unmatched/duplicate keys; winner/score/reference conflicts; exact existing-policy scope; one-to-one gates; source-order independence; separate overlay; immutable files; deterministic outputs; Git ignore/tracking boundaries. Synthetic deletion, duplication and changed-match cases must never report COMPLETE. Existing relevant Phase 1E–1I tests are run without weakening historical gates.

**Phase 1J verification:** all 18 new named tests and all 38 existing Phase 1I checks passed. Relevant Phase 1E/1F/1G suites and Phase 1H evidence checks passed without weakening gates. All 117 protected pre-existing files, including 91 existing data files and the Phase 1I release, retain SHA-256, size and modification time. Documentation links/anchors, whitespace, restricted-data staging/tracking and the full diff are checked before commit. The initial preflight printed an oversized validation object; later checks suppress object printing. This affected tool output only, not data or verification.

Development checks stopped on PDF bye text attributes, tie-break tokens, and a final-column coordinate that also matched part of a semifinal score. The parser now uses explicit bye text, complete tie-break tokens and the bounded final-box vertical range. Word coordinates separate the overlapping Pavlyuchenkova/adjacent-score line. No source record was used to fill a PDF gap. The first identity pass exposed the Riske label difference and platform-specific ñ transliteration; both received explicit bounded handling with original observations preserved.

## Standing future-model requirement

User requirement: future factors and models must target performance on future matches, not reproduce one season or a few observed seasons. Use chronological development/validation and prevent later information entering earlier predictions. Preserve 2021–2023 development, 2024 validation/model selection and locked 2025 final testing. Specify the complete tuning/evaluation protocol before modeling. Favor stable interpretable specifications and assess sensitivity across seasons, surfaces, events, ATP and WTA. Phase 1J neither designs that protocol nor accesses 2025 data.

## Smallest recommended follow-up

Saved evidence suffices for full bracket extraction and one-to-one linkage, but not for declaring all status differences resolved under current policy. The next bounded task should draft a user-reviewable inventory-only status-detail policy for precisely LS036, LS054 and LS026 using the saved HTML/PDF and source evidence. Preserve every omission and leave retirement eligibility, chronology, analytical coverage, admission and models blocked. This is a recommendation, not an adopted precedence extension. No new URL is currently required to draft that decision; any later acquisition needs its own exact allowlist and authorization.

Phase 1J starts at 13be0fd3f8d2d222e51c972319a540f8db798429. Completion commit message: Reconcile Montreal inventory offline. The final response records the resulting hash and Git state. Every next task requires a response-only ChatGPT Handoff of approximately 2,000 words and no more than 2,000 words.
