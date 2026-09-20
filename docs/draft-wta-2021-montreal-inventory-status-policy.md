# WTA Montreal inventory status-detail policy 0.1.0

Phase 1K proposal, 2026-09-20. **Draft for user review only. Committing this draft does not constitute approval.**

## Current state

| Field | Current value |
| --- | --- |
| policy_status | PROPOSED_NOT_APPROVED |
| policy_implemented | FALSE |
| inventory_reconciliation | REVIEW_REQUIRED |
| event_admission | NOT_EVALUATED |
| analytical_coverage | NOT_EVALUATED |
| modeling_authorized | FALSE |
| chronology | UNRESOLVED |
| retirement_walkover_analytical_eligibility | UNRESOLVED |
| publication | BLOCKED_PENDING_RIGHTS_REVIEW |

The [Phase 1J inventory audit](wta-2021-montreal-inventory-reconciliation.md) independently extracts 64 bracket positions, 56 entrants, eight byes and 55 non-bye results from each saved official representation. All 55 source rows link uniquely to both. Twelve of fourteen completion criteria pass. The remaining status-policy and HTML/PDF-reference criteria fail for precisely the three matches below. This draft changes none of those findings or criteria and creates no status records.

## Verified evidence and exact proposed scope

Scope is WTA, season 2021, Montreal, source event 2021-806, main-draw singles. The following allowlist binds each code to its full source audit identifier, pair, round, advancing player, score and retiring player. No other event, season, draw or match is eligible for the proposed rule.

| Code | Source audit ID | Round | Advancing player / opponent | Source score; normalized PDF score | HTML numeric score | PDF legend identifies retiring player |
| --- | --- | --- | --- | --- | --- | --- |
| LS036 | sackmann:WTA:2021-806:266 | R64 | Maria Sakkari / Marie Bouzkova | 6-4 3-1 RET | 6-4 3-1 | Marie Bouzkova |
| LS054 | sackmann:WTA:2021-806:248 | R64 | Johanna Konta / Shuai Zhang | 4-6 5-2 RET | 4-6 5-2 | Shuai Zhang |
| LS026 | sackmann:WTA:2021-806:276 | R32 | Cori Gauff (official); Coco Gauff (source) / Anastasia Potapova | 5-0 RET | 5-0 | Anastasia Potapova |

The original PDF scores are respectively `64 31 RET`, `46 52 RET` and `50 RET`. Normalization inserts game separators without changing score direction or retirement evidence. Source strings remain unchanged. The already verified event-scoped Gauff identity decision is retained; this draft introduces no alias or identity rule.

The saved PDF's combined **RETIREMENTS/WALKOVERS** legend names each listed player. The legend alone does not distinguish retirement from walkover: the corresponding bracket result's explicit RET marker, the source RET marker, and the exact pair/advancement linkage supply that distinction. Medical reasons are not needed for this inventory decision and are not republished here.

Direct inspection of each saved HTML match block found `data-status="F"`, a matching winner ID/class, numeric score cells and no retirement marker or retirement title. The markup includes generic Upcoming, Suspended and Finished label elements; their mere text presence is not three affirmative match-status observations. No explicit normal-completion, non-retirement, walkover or contrary retiring-player statement was found in these three draw blocks. The generic F/Finished state is preserved and is not treated as an explicit assertion that a full normal match was completed. This is a bounded interpretation of the inspected draw evidence, not a claim about unsaved match pages or a general WTA status specification.

## Provenance and locators

All evidence remains in its original local file. The [Montreal reference manifest](../data/manifests/montreal-reference-files.csv), [development source manifest](../data/manifests/development-source-files.csv), and [pilot source manifest](../data/manifests/pilot-source-files.csv) retain URLs, retrieval metadata and existing pins; no URL was accessed in Phase 1K. Archive revision remains `83733587353df8a41f2fd4f516147d5aa83f5a8d`.

| Observation file | Bytes | SHA-256 |
| --- | --- | --- |
| data/raw/reference/montreal-2021-feasibility/draw_html.html | 1388142 | 58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d |
| data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf | 176067 | 3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c |
| data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv | 531828 | 3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f |

The WTA annual source Git blob is `ca104914fcb353366e43f49face349960c15ec87`. Locate source rows by tour/event and the audit identifier's match number, never by row order or chronology. HTML locators are within `data-event-type=LS`; the official code must agree with the stated block. PDF coordinates below are page-one word-segment x/y minima from the existing pdftotext extraction, not image pixels.

| Code | HTML locator | PDF advancement; score locator | PDF legend name locator |
| --- | --- | --- | --- |
| LS036 | R64 block 5; data-match-counter=28; draw_html:R64:5 | draw_pdf:R64:5; (250.7688,169.91412); (250.76856,178.4178) | RETIREMENTS/WALKOVERS; (494.3688,650.1954) |
| LS054 | R64 block 23; data-match-counter=10; draw_html:R64:23 | draw_pdf:R64:23; (250.7688,466.0578); (250.76856,474.4578) | RETIREMENTS/WALKOVERS; (494.3688,671.0754) |
| LS026 | R32 block 11; data-match-counter=6; draw_html:R32:11 | draw_pdf:R32:11; (318.5688,441.71412); (318.5688,449.7378) | RETIREMENTS/WALKOVERS; (494.3688,678.4194) |

The existing ignored Phase 1J extraction, identity, source-inventory, linkage and reference-comparison tables retain full original observations and provenance. No new data file or status overlay is created by this proposal.

## Recommended rule, not implemented

Proposed machine-readable resolution name: **`pdf_retirement_corroborated_html_omission_preserved`**. This name describes controlling PDF evidence and a preserved HTML omission; it does not imply HTML contains retirement evidence.

For exactly LS036, LS054 and LS026, recommend that the explicit retirement marker and retiring-player identification in the saved official PDF may control **inventory status detail only**, if every condition below passes:

1. The exact tour, season, event, draw, official code and source audit ID are allowlisted. Existing event-scoped player IDs and spellings resolve unambiguously.
2. Required source, HTML, PDF and manifest fingerprints and locators are present and match the pinned evidence. Revalidate the existing Phase 1I overlay separately; its observations cannot substitute for these matches' evidence.
3. The source score explicitly contains RET. The PDF result independently contains RET, and its legend explicitly identifies the expected retiring player in the allowlist.
4. Source, HTML and PDF agree on the unordered player pair, round and advancing player; normalized winner-oriented numeric scores agree exactly. Preserve every original score and orientation.
5. The PDF legend's named retiring player maps uniquely to the non-advancing player in the same bracket result. Do not infer that identity merely from losing or from an incomplete score.
6. The HTML retirement marker is absent, and inspection finds no affirmative contrary status. Preserve the absence, raw F/Finished metadata and reference-conflict flag. A missing marker is not affirmative non-retirement evidence.
7. Record any later approved derived resolution separately from raw observations, with policy version, exact evidence locators and validation results. Do not overwrite a source or reference value or erase the original discrepancy.

**Fail closed:** missing or changed fingerprints; missing evidence or locators; ambiguous identity; different pair, round, winner or score; absent RET; missing or different retiring player; affirmative non-retirement, walkover or other contradictory status; duplicate linkage; or scope mismatch must prevent this resolution. Unrecognized status semantics require review, not assumed compatibility. Preserve the conflict and keep reconciliation non-COMPLETE. Do not pick a preferred source merely to make counts agree.

## Effect of possible future approval

Approval would authorize only the specified inventory-status interpretation. A separate implementation milestone must enforce all conditions, preserve raw disagreements, and pass positive and synthetic failure tests before the Phase 1J audit may classify these conflicts as resolved. The audit may report COMPLETE only after approval, implementation and passage of every existing completion criterion. Approval or this drafting commit alone cannot change REVIEW_REQUIRED.

No general source precedence is proposed. This proposal neither amends nor extends [Phase 1I recovery and status-evidence policy 1.0.0](wta-2021-montreal-recovery-policy.md): LS042/LS049 stay under their existing retirement observations, and LS001-LS007 stay under their existing completed-match recovery rule. H64/H61 remain unresolved.

The existing seven-bundle / 126-field recovery overlay remains a separate layer. Its verified size is 760695 bytes and SHA-256 is `2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5`; its timestamp is preserved. Source-only statistical presence remains 47/54, and separate source-plus-overlay presence remains 54/54. Neither is an analytical eligibility or coverage finding.

Retirement occurrence and analytical eligibility are separate decisions. This proposal does not select Four Factors, Elo, rating or forecasting populations; decide retirement/walkover treatment; establish analytical coverage; admit Montreal; resolve dates or same-day chronology; alter the 90% event or 95% tour-season thresholds; create canonical inputs; or authorize modeling or publication. Publication remains blocked pending rights review. User approval is not provider permission. Portfolio is untouched.

The [standing future-model requirement](status.md#standing-future-model-requirement) remains unchanged: target future matches, use chronological development/validation, preserve 2021-2023 development, 2024 validation/model selection and locked 2025 testing, prevent leakage, and specify the full tuning/evaluation protocol before modeling. This draft neither designs that protocol nor accesses 2025 data.

## Verification and reproduction

Phase 1K began clean on main at `1243886891941f30263f56eb4feb4b1ab2fa45dd`, `Reconcile Montreal inventory offline`, thirteen ahead / zero behind existing local origin/main. No remote refresh occurred.

The baseline read-only call `reconcile_montreal_inventory(write_outputs=FALSE)` revalidated all twelve Montreal references, four relevant annual files, three manifest pins and the Phase 1I reconstruction. It returned the same three blockers and twelve passing criteria. Source/PDF RET, matching pair/round/advancement/numeric scores, HTML omissions and all three PDF legend names were checked directly. The saved one-page PDF was rendered and visually inspected. No affirmative contradictory status was found in the scoped HTML blocks.

From the repository root, existing scripts reproduce the audit and exercise its boundaries:

```sh
Rscript R/test_montreal_inventory.R
Rscript R/test_montreal_recovery.R
```

The Phase 1J report's follow-up text is updated through its generator; extraction, matching, criteria and policy-application functions are unchanged. The implementation task is not started. Final test, preservation, documentation and Git checks are recorded in the current [status](status.md#phase-1k-draft-verification) and final response. No new dependency, network acquisition or restricted tracked data is introduced.

## User approval checklist

Every decision below is a recommendation awaiting the user. **Committing this draft does not constitute approval.** After review, the smallest recommended task is implementation of only the explicitly approved decisions, with evidence revalidation and failure tests; if revisions are requested, revise the draft first. No automatic adoption or implementation follows from this document.

| Decision | Recommendation | State |
| --- | --- | --- |
| D1 | Approve exactly WTA Montreal 2021 main-draw singles LS036/266, LS054/248 and LS026/276 with the full IDs, pairs, rounds, scores and retiring players above. | PENDING_USER_APPROVAL |
| D2 | Let explicit PDF RET plus the named retiring player control inventory status only when every source/HTML/PDF corroboration condition passes; use pdf_retirement_corroborated_html_omission_preserved. | PENDING_USER_APPROVAL |
| D3 | Preserve each HTML retirement omission as missing/conflicting status detail, together with original source/PDF scores, HTML metadata, locators, fingerprints and conflict flags. | PENDING_USER_APPROVAL |
| D4 | Fail closed on any fingerprint, missing evidence, identity, round, winner, score, retiring-player, duplicate-link or affirmative-status conflict. | PENDING_USER_APPROVAL |
| D5 | Prohibit extension beyond the exact three-match allowlist or inventory reconciliation; keep Phase 1I rules and H64/H61 uncertainty unchanged. | PENDING_USER_APPROVAL |
| D6 | Keep retirement occurrence separate from analytical eligibility for Four Factors, Elo, ratings and forecasts. | PENDING_USER_APPROVAL |
| D7 | Preserve all admission, chronology, analytical-coverage, modeling and publication restrictions and existing thresholds. | PENDING_USER_APPROVAL |
| D8 | Require explicit approval followed by a separate implementation with passing tests and all existing criteria before REVIEW_REQUIRED may become COMPLETE. | PENDING_USER_APPROVAL |
