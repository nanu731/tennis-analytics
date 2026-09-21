# WTA 2021 Montreal inventory reconciliation

Phase 1L, 2026-09-21. **Inventory reconciliation: COMPLETE.** Source rows: 55. This is not event admission.

## Current boundaries

Event admission and analytical coverage remain NOT_EVALUATED; modeling_authorized remains FALSE. Actual chronology and same-day ordering remain unresolved. The approved PROJECT_CONTEXT.md excludes retirements and walkovers from primary Four Factors, Elo updates and evaluation; that population design is not implemented here. No canonical analytical table is created. Publication remains blocked pending rights review.

## Independent inventories

| representation | bracket_positions | entrants | byes | bracket_blocks | nonbye_results | walkovers | explicit_retirements | unresolved_status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| HTML | 64 | 56 | 8 | 63 | 55 | 1 | 0 | 5 |
| PDF | 64 | 56 | 8 | 63 | 55 | 1 | 5 | 0 |


HTML isolates main-draw singles, traversing all six rounds, byes and uncoded cards. PDF independently extracts the left roster and word-coordinate result columns, then follows bracket advancement. Neither parser uses source rows as its template. Original names, scores, markers, omissions, locators and reference fingerprints remain in unchanged local extraction tables.

| round | HTML_nonbye | PDF_nonbye |
| --- | --- | --- |
| R64 | 24 | 24 |
| R32 | 16 | 16 |
| R16 | 8 | 8 |
| QF | 4 | 4 |
| SF | 2 | 2 |
| F | 1 | 1 |


## Linkage and status resolution

| measure | value |
| --- | --- |
| one_to_one_source_links | 55 |
| source_only_unmatched | 0 |
| official_only_unmatched | 0 |
| duplicate_source_keys | 0 |
| duplicate_HTML_keys | 0 |
| duplicate_PDF_keys | 0 |
| unresolved_identities | 0 |
| winner_conflicts | 0 |
| numeric_score_conflicts | 0 |
| raw_HTML_retirement_omissions | 5 |
| Phase_1I_scoped_resolutions | 2 |
| Phase_1L_inventory_resolutions | 3 |
| unresolved_status_details | 0 |
| unresolved_reference_conflicts | 0 |


Links use event/draw, round and unordered player IDs, followed by winner, score and status comparison. Source row order and match_num never establish chronology. Numeric agreement is not raw-string equality; RET and suffix evidence remain separate.

Policy validation: all_three_resolved

[WTA Montreal inventory status-detail policy 1.0.0](wta-2021-montreal-inventory-status-policy.md) is separately adopted for LS036/266, LS054/248 and LS026/276. The resolution is pdf_retirement_corroborated_html_omission_preserved. All three must pass fresh pinned-byte validation, exact scope, source/PDF RET, named PDF legend identity, matching pair/round/advancement/score, unique linkage, unchanged HTML omission/F metadata and required locators. Any failed condition withholds all three derived resolutions.

Raw official extractions and source rows are not rewritten. The separate ignored inventory-status-resolutions.csv preserves source/PDF scores, PDF legend text/locator, named retiring player, HTML omission and F metadata, fingerprints, original conflict history and policy/version. All five original HTML retirement omissions remain visible. LS042/LS049 retain their two existing Phase 1I resolutions; LS001-LS007 recovery, H64/H61 and the immutable Phase 1I release are not altered.

## Completion criteria

COMPLETE requires all fourteen pre-existing criteria; no criterion was removed or weakened. Missing extraction evidence yields BLOCKED_INSUFFICIENT_LOCAL_EVIDENCE; unresolved comparisons yield REVIEW_REQUIRED. Completion is an inventory result only.

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
| status_differences_within_existing_policy_scope | TRUE |
| HTML_PDF_agree_or_existing_scoped_resolution | TRUE |
| code_gaps_accounted_for_without_inventing_codes | TRUE |
| source_reference_overlay_layers_separate | TRUE |


## Identity and code-sequence findings

The 56 event identities use deterministic normalization and exact roster decisions, including bounded Gauff/Cori-Coco and Riske/Riske Amritraj aliases, plus explicit ñ normalization. No fuzzy matching or global identity rule is introduced. The original HTML contains 62 unique LS codes and an uncoded Gauff-Konta R16 walkover card between LS012 and LS014. No LS013 identifier or missing match is synthesized; the publisher's reason for omitting the attribute remains unknown.

## Historical record

Phase 1J independently linked all 55 rows but returned REVIEW_REQUIRED: five HTML retirement omissions, two adopted Phase 1I resolutions and three unresolved details (LS036, LS054, LS026), with 12/14 criteria passing. Phase 1K drafted proposal 0.1.0 with D1-D8 pending; its commit was not approval. The Phase 1L user prompt explicitly approved those decisions and the project context. Current computed tables above, rather than approval alone, determine whether implementation passes.

## Evidence, preservation and rights

All twelve [Montreal references](../data/manifests/montreal-reference-files.csv), four relevant ATP/WTA 2021/2023 annual files and the three Phase 1I manifest pins are revalidated. Archive revision remains 83733587353df8a41f2fd4f516147d5aa83f5a8d. The Phase 1I release is reconstructed in memory and compared to the existing RDS; its bytes and timestamp remain unchanged. No new acquisition or dependency is used.

Historical source-only statistical presence remains 47/54 = 87.0370%; separate implemented source-plus-overlay presence remains 54/54 = 100%, from 47 original and seven supplemental bundles. These are apparent-play presence measures, not the approved completed-match population's analytical coverage. The 90% event and 95% tour-season thresholds remain unchanged; neither admission nor a new eligible denominator is calculated.

Raw pages, complete official extractions, identities, linkage/conflict tables and populated recovery/status decisions remain ignored and untracked. Only code, tests, aggregate findings, policy and minimum audit identifiers are committed. [DATA_LICENSE.md](../DATA_LICENSE.md) remains controlling. User approval is not provider permission; publication of match-level or aggregate outputs requires rights review. Portfolio is untouched.

## Reproduction and verification

```sh
Rscript R/reconcile_montreal_inventory.R
Rscript R/test_montreal_inventory.R
Rscript R/test_montreal_recovery.R
```

The existing ignored Montreal inventory directory retains its twelve Phase 1J tables and adds only inventory-status-resolutions.csv as a separate derived layer. The raw html-draw, pdf-draw, pdf-entrant-positions, identity-decisions, source-inventory and provenance tables remain unchanged. Links, reference comparisons, criteria and summary reflect approved policy resolution without erasing original statuses.

Tests retain the historical fourteen-criterion/no-new-policy controls and add the adopted 1.0.0 rule: exact scope and three resolutions, named legend evidence, unchanged observations, zero unresolved conflicts, all criteria passing, no partial application, fingerprint/identity/result/round/score/marker/legend/status/locator mutations, other-event/match rejection, deterministic reruns, overlay immutability and Git boundaries. Relevant Phase 1E-1K regressions are run; current verification is recorded in [status](status.md).

The initial Phase 1L record-equality check rejected PDF roster attributes even though the recorded fields matched. It was corrected to compare every field value while retaining separate full-bracket validation. No partial resolution was applied during that failed development run.

## Standing future-model requirement

[PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md) is adopted. Future factors and models must target future matches, not reproduce a few observed seasons. Preserve chronological 2021-2023 development, 2024 validation/model selection and locked 2025 final testing. Specify the complete tuning/evaluation protocol before modeling, prevent leakage, and assess stability across seasons, surfaces, events and tours. Phase 1L does not design that protocol or access 2025 data.

## Smallest recommended follow-up

A bounded offline audit of Montreal completed-match eligibility and count coverage under the approved context is recommended next, using existing saved evidence and separate recovery provenance. It must preserve every excluded audit record, report any remaining status/count blockers, and leave admission, chronology, canonical inputs and models unimplemented unless separately authorized. Actual dates/same-day ordering, wider data acquisition and publication rights remain separate decisions.

Phase 1L starts at bded8069163d41c886cf1576ea0fdd4cc1054b7b. Its commits are Adopt project research context and Implement Montreal inventory status policy; exact hashes and Git state are recorded in the final response. Every next task requires a response-only ChatGPT Handoff of approximately 2,000 words and no more than 2,000 words.
