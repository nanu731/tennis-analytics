# Tennis analytics status

Date: **2026-09-20**. **Phase 1I complete. WTA Montreal recovery and status-evidence policy 1.0.0 is ADOPTED. D1–D10 were explicitly approved in the Phase 1I prompt. Recovery and scoped status precedence are implemented. Event admission and valid analytical coverage are NOT_EVALUATED; modeling remains unauthorized.**

## Completed and verified

The flagship asks whether interpretable Four Factors improve match-forecast calibration over surface-adjusted Elo, separately for ATP and WTA. Challenger promotion readiness remains deferred until shared infrastructure is validated. This repository owns research; portfolio publication requires completed, reviewed outputs and a separate request.

The [adopted policy](wta-2021-montreal-recovery-policy.md) preserves four separate layers: immutable Sackmann observations, immutable official observations, an implemented derived overlay and a future canonical analytical layer. No canonical table exists from this task. Proposal 0.1.0 and its Phase 1H commit were not approval; the Phase 1I prompt supplied approval for D1–D10 exactly as proposed.

The atomic local release contains seven bundles, all 18 required fields each, **126 unique field decisions**, with disposition `recovered_in_derived_overlay_source_preserved`. Source mappings are 238→LS001, 300→LS002, 299→LS003, 298→LS004, 297→LS005, 296→LS006 and 295→LS007, all `sackmann:WTA:2021-806:`. Original source fields remain missing. Source player spellings/IDs, exact official displays/fractions, orientation, locators, methods, hashes, retrieval metadata, validation and rights remain attached to each decision.

The populated release is ignored: `data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds`. It holds separate field decisions and status-resolution tables, supporting checks/observations and manifests. All validation finishes before one atomic file rename; no subset can be released. A failed rerun preserves any earlier immutable release without reporting it as newly validated. Revalidate before treating a saved file as current.

Only saved evidence was used. Twelve Montreal references and all four ATP/WTA 2021/2023 annual files pass pinned fingerprints. The archive remains `83733587353df8a41f2fd4f516147d5aa83f5a8d`. Fresh in-memory extraction reproduces every Phase 1G CSV without rewriting it. All nine targeted identities, rounds, winners and numeric scores agree with HTML draw and PDF branches. This is not complete inventory reconciliation. All 459 applicable structural checks pass, including 357 for the seven recovery bundles.

## Status resolutions and unresolved evidence

LS001–LS007 use `completed_match_evidence_controls_for_scoped_recovery_scheduled_metadata_preserved`. Visible finished cards, completed=true/status F, source result/score, HTML advancement, PDF results and whole-match statistics must agree. All original EventScheduled values, locators, hashes and conflict flags remain explicit.

LS042 separately records Tereza Martincova retired, `official_retirement_confirmed_suffix_meaning_unresolved`; LS049 records Ajla Tomljanovic retired, `official_retirement_confirmed_source_marker_missing`. Their 36 populated counts agree exactly and are not overwritten. Source scores remain `6-1 4-3 RET+H64` and `2-6 6-2`. Both HTML draw cards omit RET; this and EventScheduled remain preserved. H64/H61 meanings remain unknown. Neither retirement receives a model eligibility decision.

Saved statistics name-bars are empty. Orientation uses pinned match-card identities and ordered a/b statistic columns. Coco Gauff / Cori Gauff is a bounded linkage, not a global identity crosswalk. Published dates are not actual-play chronology: LS007 is dated August 14, other quarterfinal metadata August 13. Overview August 9–15 and PDF August 7–15 windows remain unexplained. Final match number 238 cannot determine ordering.

## Coverage and continuing boundaries

| Measure | Current state |
| --- | --- |
| Historical source-only presence | 47/54 = 87.0370% |
| Implemented source-plus-overlay presence | 54/54 = 100%; 47 original and seven supplemental official-reference bundles |
| Valid analytical coverage | NOT_EVALUATED |
| Event admission | NOT_EVALUATED |
| 95% tour-season gate | NOT_TESTED |
| Modeling | Unauthorized |

The source apparent-play denominator stays 54 out of 55 rows, excluding one walkover. Four literal source retirement markers and the unmarked corroborated retirement remain separate observations. Presence does not establish analytical eligibility or pass an admission gate. Thresholds remain 90% event / 95% tour-season. Historical [Phase 1G](wta-2021-montreal-reference-feasibility.md) candidate/hypothetical 54/54 and strict-exclusion 47/54 scenarios retain their original nonadopted review state.

Indian Wells 2023 inventory gates and policies remain unchanged: ATP precedence 1.0.0 retains its resolved PDF conflicts; WTA quarantine 1.0.0 still excludes Andreescu–Stearns' whole count bundle for all four reasons while preserving inventory/played membership. Historical valid-count coverage stays 95/95 ATP and 93/94 WTA. These policies do not admit Montreal.

No raw WTA page, full extracted match table or populated recovery release is tracked or staged. WTA publication remains blocked pending rights review, including review before aggregate exports. DATA_LICENSE.md is unchanged; user approval is not provider permission. No source correction, imputation, chronology, canonical analytical table, feature, factor, rating, forecast or evaluation was created. Portfolio was not modified; nothing was pushed, published or deployed.

## Reproduction and verification

From the repository root, using existing R and local command-line utilities:

```sh
Rscript R/implement_montreal_recovery.R
Rscript R/test_montreal_recovery.R
```

These use no network or added dependency. The new [verification report](wta-2021-montreal-recovery-verification.md) records the new failure-path tests, existing Phase 1E–1G regressions and relevant Phase 1H evidence checks. The Phase 1G generator now supports read-only `write_outputs=FALSE`; its calculated outputs and tests remain unchanged. The report adds historical labels and a current follow-up paragraph.

The first Phase 1I validation withheld output because a completion check expected “Finished” rather than the observed “Finished: duration.” The implementation was corrected to require the recorded format together with all other completion evidence. No partial release escaped. The final verification report records remaining execution notes and final checks.

## Smallest recommended next task

A separately authorized **offline complete Montreal inventory reconciliation** against saved HTML/PDF draw evidence, using original source IDs and the overlay only as a separately labeled recovery layer. Produce a match-level reconciliation audit with any unmatched/duplicate/status-disputed entries and a bounded proposal for remaining admission gates. Do not admit Montreal, construct chronology, choose retirement eligibility or create canonical model inputs. If existing evidence is insufficient, report exactly what is missing before requesting acquisition.

Unresolved decisions include retirement/walkover/unknown-status analytical populations, actual dates and same-day ordering, event/tour-season admission, common Elo/Four Factors populations, pre-2021 history and publication rights. New data, dependencies, broader structure or methodological changes require authorization. The ten-family panel and 2021–2023 development / 2024 validation / locked 2025 test split remain unchanged; 2022/2024/2025 acquisition remains closed.

## Git and handoff

Phase 1I began clean on main at `a22cb2179daa27541ddd94ae5de8bef88dba0d1b`, `Draft Montreal recovery policy for review`, eleven ahead / zero behind the existing local origin/main. No remote refresh occurred. Completion message: `Implement Montreal recovery overlay policy`. The final response records the exact resulting commit and Git state.

Every later task must finish with a response-only ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000. Do not invoke a handoff tool or create another task without a separate request.
