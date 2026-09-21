# Tennis analytics status

Date: **2026-09-21**. **Phase 1L complete: PROJECT_CONTEXT.md adopted; WTA Montreal inventory status-detail policy 1.0.0 adopted and implemented. Montreal inventory reconciliation is COMPLETE, with 14/14 criteria passing.** All 55 source rows link uniquely to both official representations; the three new scoped resolutions preserve every raw observation. Event admission and analytical coverage remain NOT_EVALUATED; chronology unresolved; modeling_authorized FALSE; publication blocked.

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
| Source-only statistical presence | 47/54 = 87.0370% |
| Separate implemented source-plus-overlay presence | 54/54 = 100% |
| Inventory reconciliation | COMPLETE, 14/14 criteria |
| Event admission | NOT_EVALUATED |
| Valid analytical coverage | NOT_EVALUATED |
| 95% tour-season coverage gate | NOT_TESTED |
| Actual chronology / same-day order | UNRESOLVED |
| Primary population design | Completed matches only, APPROVED_NOT_IMPLEMENTED |
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

PDF development checks exposed bye-text attributes, tie-break token syntax and a final-score coordinate that also occurred within semifinal scores. These were corrected with explicit parsing and bounded geometry, not inferred source rows. Word-level coordinates separate an adjacent-column extraction collision. Initial identity review exposed the Riske name difference and ñ transliteration; both now retain bounded auditable decisions. Those three status-detail conflicts were unresolved in Phase 1J/1K; Phase 1L resolves their inventory detail under the separately approved rule.

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

## Smallest recommended next task

Conduct a bounded offline Montreal completed-match eligibility and count-coverage audit under the approved context. Preserve all excluded records and separate recovery provenance; report remaining count/status blockers without admitting Montreal, resolving chronology, constructing canonical model inputs or modeling. Broader acquisition, chronological policy and publication rights remain separate decisions.

Wider acquisition, new dependencies, structural changes, methodological choices and publication require appropriate authorization. No portfolio, source, manifest, Phase 1I overlay or historical calculated output was modified. No push, publication or deployment occurred.

## Git and handoff

Historical Phase 1K began clean on main at `1243886891941f30263f56eb4feb4b1ab2fa45dd`, `Reconcile Montreal inventory offline`, thirteen ahead / zero behind the existing local origin/main. No remote refresh occurred. Completion message: `Draft Montreal inventory status policy`. The final response records the exact resulting hash and Git state. The Phase 1J report retains its historical start/commit description.

Every next task must finish with a response-only ChatGPT Handoff of approximately 2,000 words and strictly no more than 2,000 words. Do not invoke a handoff tool or create another task without a separate request.

Phase 1L began at bded8069163d41c886cf1576ea0fdd4cc1054b7b, Clarify model development principles, clean main, sixteen ahead / zero behind existing origin/main. Step 1: Adopt project research context. Step 2: Implement Montreal inventory status policy. No remote refresh or push. The final response records both exact hashes and final Git state.
