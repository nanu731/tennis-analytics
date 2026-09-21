# Tennis analytics status

Date: **2026-09-21**. **Phase 1M complete: the bounded offline WTA Montreal completed-match eligibility/count audit derives 49 normally completed matches, five excluded retirements and one excluded walkover. Valid count coverage is 42/49 source-only and 49/49 with seven separate approved overlay bundles; the numerical 90% event threshold passes (45 required).** Inventory remains COMPLETE, 14/14 criteria. Event admission remains NOT_EVALUATED; canonical analytical population NOT_IMPLEMENTED; chronology unresolved; modeling_authorized FALSE; publication blocked.

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
| Primary population design | Completed matches only; implemented for this event audit only |
| Modeling | Unauthorized |
| Publication | Blocked pending rights review |

Thresholds remain 90% event / 95% tour-season. Published match dates and match numbers are not chronology substitutes. The LS007 date discrepancy and differing overview/PDF tournament windows remain unresolved. Indian Wells policies, calculations and inventory states remain unchanged; they do not authorize Montreal admission.

## Standing future-model requirement

The user requires future factors and models to target performance on future matches, not reproduce one season or a few observed seasons. Use chronological development and validation and prevent later information entering earlier predictions. Preserve **2021–2023 development**, **2024 validation/model selection**, and the **locked 2025 final test**.

Specify the complete tuning/evaluation protocol before modeling begins. Favor stable, interpretable specifications and assess sensitivity across seasons, surfaces, events, ATP and WTA. Phase 1J records this requirement without designing tuning, regularization, calibration or evaluation methods. No 2025 data was inspected, acquired or evaluated.

## Reproduction and verification

From the repository root:

```sh
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

All 55 non-bye records have unique dispositions. Five validated retirements and one walkover remain present but excluded from the denominator, numerator and Four Factors, Elo-update, rolling-history and forecast-evaluation status flags. LS049/Ferro–Tomljanovic is correctly retired under Phase 1I while its raw source status remains unresolved. Completed results require corroborated source/HTML/PDF winner and complete numeric score evidence. Generic F metadata or available counts alone never implies completion. Missing/unknown status withholds the gate rather than silently improving coverage.

The count denominator is 49 regardless of count availability. Forty-two unchanged source bundles pass all 43 required checks per match; seven separately authorized overlay bundles pass all 51 checks each. All 18 counts per bundle are required. Source-only coverage is 85.7143%; combined coverage is 100%; ceiling(0.90 × 49) is 45. Structural consistency does not independently establish statistic accuracy. The excluded RET+H64 source row retains an unevaluable game/score check rather than being labeled invalid or silently repaired. Historical apparent-play presence stays 47/54 and 54/54.

New base-R code and tests produce four ignored tables under data/pilot/development-2021/montreal-completed-match-coverage/: dispositions.csv, count-links.csv, structural-checks.csv and summary.csv. The 55 dispositions preserve identifiers, official links/locators, raw scores/status markers, adopted decisions, exclusions, provenance and policy versions. Count origins remain separate; no combined filled-in source table, canonical player orientation or model input is created. The structural-check table contains 2,421 audit rows, including excluded observations whose results never enter coverage.

All **45 Phase 1M checks**, **41 Montreal inventory checks** and **38 recovery checks** passed. Phase 1E annual-source, Phase 1F source-review, Phase 1G feasibility, relevant Phase 1H evidence and Phase 1K historical baseline/legend regressions also passed. Mutation tests cover fingerprints, pins, raw metadata, linkage, identity, round, winner, score, retirement evidence, overlay scope/orientation/provenance, structural validation, duplicates, retired relabeling and walkover/history inclusion. Synthetic missing counts leave the denominator unchanged; removing five bundles yields 44/49 and fails the numerical floor. Unknown status cannot yield PASS. Public workflow reruns produce identical returned objects and output bytes/timestamps. Existing assertions were not weakened.

All **137 protected pre-existing files**, including **104 data files**, retain their SHA-256, size and modification time. Only the two authorized existing documents change; the only new data files are the four ignored audit tables. The Phase 1I overlay remains 760695 bytes with SHA-256 2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5 and unchanged timestamp. Local documentation links/anchors, placeholders, whitespace, restricted-data Git boundaries and the complete diff were checked. Evidence paths remain confined to saved 2021 references and 2021/2023 annuals; no 2025 data was accessed. AGENTS.md, PROJECT_CONTEXT.md, policies, prior calculated outputs and portfolio were not modified.

The first new test run exposed a mutation fixture that assigned F to a record already in round F, so it had not actually changed the evidence. The fixture now assigns an invalid round and the complete suite passes. This was a test-input correction, not a relaxed rule or evidence discrepancy. A preliminary output-directory listing occurred before the first validated write and found no directory; the later run created exactly the four authorized outputs. No unresolved execution error remains. No dependency, download, Net Point Rating, factor, Elo update, canonical population, event admission or publication was introduced.

## Smallest recommended next task

Conduct a bounded offline Montreal chronology-evidence inventory and policy proposal using existing local references. Distinguish observed dates from actual play/completion dates, identify same-day/suspended-match and LS007/date-window gaps, and present decisions for review. Do not implement ordering, acquire more evidence, admit Montreal, construct canonical model inputs or model. This is a recommendation, not an implemented or approved chronology policy.

Wider acquisition, new dependencies, structural changes, methodological choices and publication require appropriate authorization. No portfolio, source, manifest, Phase 1I overlay or historical calculated output was modified. No push, publication or deployment occurred.

## Git and handoff

Historical Phase 1K began clean on main at `1243886891941f30263f56eb4feb4b1ab2fa45dd`, `Reconcile Montreal inventory offline`, thirteen ahead / zero behind the existing local origin/main. No remote refresh occurred. Completion message: `Draft Montreal inventory status policy`. The final response records the exact resulting hash and Git state. The Phase 1J report retains its historical start/commit description.

Every next task must finish with a response-only ChatGPT Handoff of approximately 2,000 words and strictly no more than 2,000 words. Do not invoke a handoff tool or create another task without a separate request.

Phase 1L began at bded8069163d41c886cf1576ea0fdd4cc1054b7b, Clarify model development principles, clean main, sixteen ahead / zero behind existing origin/main. Step 1: Adopt project research context. Step 2: Implement Montreal inventory status policy. No remote refresh or push. The final response records both exact hashes and final Git state.

Phase 1M began at 62cb0ba9c7224d27e01e1642cfb07c06a1313e65, Implement Montreal inventory status policy, clean main, eighteen ahead / zero behind existing origin/main. Completion message: Audit Montreal completed-match coverage. The final response records the resulting hash and final Git state. No remote refresh or push occurred.
