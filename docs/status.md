# Tennis analytics status

Date: **2026-09-21**. **Phase 1K policy draft complete; proposal 0.1.0 is PROPOSED_NOT_APPROVED and policy_implemented is FALSE. Montreal inventory reconciliation remains REVIEW_REQUIRED.** The same three retirement-detail conflicts await user review of D1-D8. Event admission and analytical coverage remain NOT_EVALUATED; modeling_authorized remains FALSE. Committing the draft is not approval. A separate root `PROJECT_CONTEXT.md` draft awaits user review; it now records the Dean Oliver-inspired factor-selection goal, evidence-driven model revision, and anti-overfitting boundary. Its proposed retirement and Elo rules are not adopted project policy.

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

Non-bye results by round are 24 R64, 16 R32, eight R16, four QF, two SF and one final. All 55 source rows link one-to-one to both official representations. There are zero unmatched records, duplicate keys, unresolved identities, round conflicts, winner conflicts or normalized numeric-score conflicts. Raw status differences remain separate from score agreement.

HTML has 62 unique supplied LS identifiers. The absent LS013 label corresponds to the sequence position of an **uncoded Gauff–Konta R16 walkover card**, which is present between LS012 and LS014. PDF and source independently corroborate that result. No missing match or LS013 code is synthesized. The reason the publisher omitted the code attribute remains unknown; byes do not explain this specific gap.

Event-scoped identities use deterministic exact roster resolution, preserving IDs and spellings. Explicit ñ-to-n normalization handles Muguruza's PDF spelling. Cori Gauff/Coco Gauff extends the existing LS006 linkage only within this event after all four opponent/round pairings agree. Alison Riske/Riske Amritraj is a bounded exact event-candidate decision corroborated by the R64 Sorana Cirstea pairing. No fuzzy matching or global alias was introduced.

## Exact remaining blockers

| Official code | Full source audit ID | Evidence difference |
| --- | --- | --- |
| LS036 | sackmann:WTA:2021-806:266 | Sakkari–Bouzkova: source/PDF RET, HTML marker omitted |
| LS054 | sackmann:WTA:2021-806:248 | Konta–Zhang: source/PDF RET, HTML marker omitted |
| LS026 | sackmann:WTA:2021-806:276 | Gauff–Potapova: source/PDF RET, HTML marker omitted |

The advancing players and numeric scores agree. These remain three unresolved status-detail and HTML/PDF reference conflicts. Policy 1.0.0 covers only LS042 and LS049 retirement observations, so it was not extended. All five HTML omissions remain visible; two have existing scoped resolutions and three do not. The full reconciliation contract therefore does not permit COMPLETE.

Saved evidence was sufficient for full extraction and linkage. A further user decision is needed to resolve the three status-detail differences for inventory purposes. No additional URL is currently required to draft that decision. Retirement/walkover analytical eligibility remains a different question.

## Existing recovery layer preserved

[Recovery and status-evidence policy 1.0.0](wta-2021-montreal-recovery-policy.md) remains adopted and implemented. The unchanged ignored release contains seven bundles / 126 field decisions plus nine scoped status resolutions. Original source values remain missing; recovered counts were not merged into inventory or canonical inputs.

LS001–LS007 retain the scoped completed-evidence rule and preserved EventScheduled conflicts. LS042 records Martincova retired while preserving `6-1 4-3 RET+H64`; LS049 records Tomljanovic retired while preserving `2-6 6-2`. Their source counts/scores remain unchanged. H64/H61 meanings remain unresolved. New inventory labels distinguish 47 original source bundles, seven separate supplemental bundles and one walkover outside the apparent-play count denominator.

| Gate or measure | Current state |
| --- | --- |
| Source-only statistical presence | 47/54 = 87.0370% |
| Separate implemented source-plus-overlay presence | 54/54 = 100% |
| Inventory reconciliation | REVIEW_REQUIRED: three status-detail differences |
| Event admission | NOT_EVALUATED |
| Valid analytical coverage | NOT_EVALUATED |
| 95% tour-season coverage gate | NOT_TESTED |
| Actual chronology / same-day order | UNRESOLVED |
| Retirement/walkover analytical eligibility | UNRESOLVED |
| Modeling | Unauthorized |
| Publication | Blocked pending rights review |

Thresholds remain 90% event / 95% tour-season. Published match dates and match numbers are not chronology substitutes. The LS007 date discrepancy and differing overview/PDF tournament windows remain unresolved. Indian Wells policies, calculations and inventory states remain unchanged; they do not authorize Montreal admission.

## Standing future-model requirement

The user requires future factors and models to target performance on future matches, not reproduce one season or a few observed seasons. Use chronological development and validation and prevent later information entering earlier predictions. Preserve **2021–2023 development**, **2024 validation/model selection**, and the **locked 2025 final test**.

Specify the complete tuning/evaluation protocol before modeling begins. Favor stable, interpretable specifications and assess sensitivity across seasons, surfaces, events, ATP and WTA. Phase 1J records this requirement without designing tuning, regularization, calibration or evaluation methods. No 2025 data was inspected, acquired or evaluated.

## Reproduction and verification

From the repository root:

```sh
Rscript R/reconcile_montreal_inventory.R
Rscript R/test_montreal_inventory.R
```

The scripts use saved local evidence and existing R, SHA-256 and pdftotext tools. Full official draw tables, identity decisions, source inventory, reconciliation links, reference comparisons and provenance remain ignored under data/pilot/development-2021/montreal-inventory/. The committed report contains aggregate findings and minimum blocker identifiers, not a full official draw or recovered count table.

New tests cover independent parsing, singles isolation, bracket progression, byes/codes, statuses/scores, bounded identities, one-to-one keys, conflicts and policy scope. A positive synthetic COMPLETE fixture confirms that deletion, duplication, changed score or wrong round prevents false completion. Row reversal and source-row permutations preserve links; changing match numbers cannot alter player-pair linkage or create chronology. Immutability, deterministic output and restricted-data Git boundaries are checked. Relevant Phase 1E–1I checks run without weakening historical policies.

PDF development checks exposed bye-text attributes, tie-break token syntax and a final-score coordinate that also occurred within semifinal scores. These were corrected with explicit parsing and bounded geometry, not inferred source rows. Word-level coordinates separate an adjacent-column extraction collision. Initial identity review exposed the Riske name difference and ñ transliteration; both now retain bounded auditable decisions. All substantive uncertainty is reported as the three remaining status-detail conflicts.

## Phase 1K draft verification

The [inventory status-detail proposal 0.1.0](draft-wta-2021-montreal-inventory-status-policy.md) is limited to LS036/266, LS054/248 and LS026/276. It recommends pdf_retirement_corroborated_html_omission_preserved only when pinned source/PDF RET, the PDF-named retiring player and source/HTML/PDF identity, round, winner and numeric score all agree. HTML omissions and raw metadata remain preserved. The proposal fails closed on missing or conflicting evidence. All eight approval decisions remain PENDING_USER_APPROVAL; no policy application or new status record occurred.

Phase 1K revalidated all twelve references, four annual files, three manifest pins and the unchanged Phase 1I reconstruction. Direct source/HTML/PDF review and full-page PDF inspection confirmed the three RET markers, HTML omissions and legend names (Marie Bouzkova, Shuai Zhang, Anastasia Potapova). No affirmative contrary status was found in the scoped HTML blocks; F/Finished does not explicitly assert normal completion. The read-only baseline and final audit retain the same three blockers, 12/14 passing criteria and unchanged gates.

All 18 Phase 1J tests and 38 Phase 1I checks passed. Evidence hashes, sizes and modification times, existing data-file membership, overlay bytes/timestamp, restricted-data Git boundaries, pending decisions, links/anchors, placeholders, whitespace and the complete diff were checked. Only the report generator's follow-up prose changed; its generated report was reproduced without changing findings. No new data file, implementation script, overlay, dependency or network request was created.

## Smallest recommended next task

Review D1-D8 in the [draft policy](draft-wta-2021-montreal-inventory-status-policy.md#user-approval-checklist). After explicit approval, separately implement only the approved inventory-status decisions with fail-closed tests and all existing completion criteria. If the user requests revisions, revise the draft first. Do not infer approval from this commit or proceed to retirement eligibility, chronology, analytical coverage, admission or modeling.

Wider acquisition, new dependencies, structural changes, methodological choices and publication require appropriate authorization. No portfolio, source, manifest, Phase 1I overlay or historical calculated output was modified. No push, publication or deployment occurred.

## Git and handoff

Phase 1K began clean on main at `1243886891941f30263f56eb4feb4b1ab2fa45dd`, `Reconcile Montreal inventory offline`, thirteen ahead / zero behind the existing local origin/main. No remote refresh occurred. Completion message: `Draft Montreal inventory status policy`. The final response records the exact resulting hash and Git state. The Phase 1J report retains its historical start/commit description.

Every next task must finish with a response-only ChatGPT Handoff of approximately 2,000 words and strictly no more than 2,000 words. Do not invoke a handoff tool or create another task without a separate request.
