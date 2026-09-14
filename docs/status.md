# Tennis analytics status

Date: **2026-09-14**. **Phase 1F is complete: offline WTA 2021 Montreal admission review. Seven statistical bundles remain missing; score suffix and completion evidence remain unresolved. No repair, imputation, acquisition or admission occurred.**

## Completed and verified

The flagship asks whether interpretable Four Factors improve match-forecast calibration over surface-adjusted Elo, separately for ATP and WTA. Challenger promotion readiness remains deferred. This repository owns research; portfolio publication requires completed, reviewed outputs and a separate request.

The [Montreal review](wta-2021-montreal-admission-review.md) selects exact WTA source ID 2021-806 and verifies it against Phase 1E candidates. Source observations remain Montreal, 20210809, Hard, P, draw size 64, 55 rows, 54 apparent-play rows, one walkover and four recognizable retirement markers. These are source observations, not verified official inventory or chronology.

All seven gaps are whole bundles affecting both players: four QFs (298, 297, 296, 295), two SFs (300, 299) and the final (238). Six have recorded minutes; the final does not. All eight affected players have complete bundles in earlier apparent-play rounds. Internal round progression is coherent, without asserting official coverage. Other nine WTA target events have no whole-bundle gaps in QF/SF/F rows. The cause of Montreal's round-concentrated pattern remains unknown.

## Score and count warnings

Anisimova–Martincova (260) retains raw score 6-1 4-3 RET+H64. RET remains recognizable and +H64 remains unresolved. The four local annual files contain only one analogous row: WTA Miami 2023-902:289, 7-6(0) 0-2 RET+H61. Similar syntax does not establish meaning.

An additional source observation explains different denominator sensitivities: Ferro–Tomljanovic (253) has 2-6 6-2 with no retirement marker. It remains apparent play, but not completion-consistent best-of-three syntax. No deciding set, retirement or corrected outcome is inferred.

The Gauff–Konta R16 walkover (289) has 18 populated zero counts. Existing checks flag zero service points; populated is not equivalent to valid played-match statistics. All other 47 complete bundles have no applicable count flags. Game/score reconciliation is not evaluable for the unresolved suffix, unmarked two-set score, missing bundles or walkover; no independent accuracy claim follows.

## Denominator sensitivities, not eligibility rules

| Scenario | Populated / denominator | Without applicable flags / denominator | Minimum additional acceptable bundles for 90% |
| --- | --- | --- | --- |
| All source rows | 48/55 (87.2727%) | 47/55 (85.4545%) | 3 |
| Non-walkover / Phase 1E apparent play | 47/54 (87.0370%) | 47/54 (87.0370%) | 2 |
| Numeric completed-score syntax | 42/49 (85.7143%) | 42/49 (85.7143%) | 3 |
| All rows excluding RET; retains walkover | 44/51 (86.2745%) | 43/51 (84.3137%) | 3 |
| Apparent play excluding RET | 43/50 (86%) | 43/50 (86%) | 2 |
| All rows excluding suffix; retains walkover | 47/54 (87.0370%) | 46/54 (85.1852%) | 3 |
| Apparent play excluding suffix | 46/53 (86.7925%) | 46/53 (86.7925%) | 2 |

The baseline needs 49 acceptable bundles; the completed-score cohort needs 45. These shortfalls are conditional lower bounds: unevaluable checks or later invalidations may increase them. Arithmetic is not evidence that recovery is possible. Complete-bundle-only diagnostics yield 48/48 populated (47/48 without flags) or 47/47 after filtering flags, but are circular and cannot establish coverage. All ten generated scenarios retain explicit inclusion/exclusion IDs. No 90% eligibility gate is approved; the 95% tour-season gate is untested.

## Review dispositions and choices

**WTA Montreal admission review 1.0.0** is a review specification, not an adopted repair/quarantine/eligibility policy. Nine dispositions distinguish seven missing bundles, one unresolved suffix and one numeric score lacking completion evidence. They permit source identity/result/score preservation, event annotations, descriptive inventory candidacy and local review. They prohibit Four Factors, weights, player factor summaries, missing-count-dependent uses, Elo, forecasting and modeling admission.

The report compares five unimplemented options: A investigate reference-based recovery; B retain result-only work while excluding Montreal from factors; C exclude the event from both models; D revise the 90% floor; E impute/reconstruct (prohibited without later evidence and separate policy approval). Different model populations would require an explicit evaluation design; excluding Canada or revising thresholds requires user approval. No license assumption was added.

## Existing evidence and policies preserved

All four ATP/WTA 2021/2023 annual files were verified against their manifests for size, SHA-256, Git blob and row count. Existing raw bytes, metadata, retrieval records and earlier generated evidence remain unchanged. Phase 1E still reports 20 found candidate cells and identical ordered 49-column schemas; no 2021 inventory gate passes.

ATP/WTA 2023 Indian Wells inventory gates remain PASS. ATP precedence policy 1.0.0 retains four resolved PDF conflicts in its two approved branches and three conflicting match links. WTA quarantine policy 1.0.0 still excludes Andreescu–Stearns' full bundle while retaining inventory/played-denominator membership and all four reasons. WTA remains 93/94 valid-count rows, ATP 95/95. The policies and Indian Wells outputs were not altered.

## Reproduction and verification

Run Rscript R/review_wta_2021_montreal.R --self-test from the repository root. Eight deterministic CSVs are written under ignored data/pilot/development-2021/montreal-review/, plus the generated Markdown report. The script makes no network requests and calls no acquisition function. Missing or invalid evidence stops before output.

Verification covers source identities, all 18 missing fields, QF/SF/F distribution, raw score/match-number preservation, partial/malformed/zero bundle cases, count bounds, suffix edge cases, selection failures, labeled denominators, threshold arithmetic, source progression, player history, prohibited admission and identical reruns. Phase 1E remains reproducible; its rerun test now hashes its own CSVs rather than the new review directory. Final checks cover 65 preserved files, no new raw files, ignore rules, documentation links/anchors, placeholders, paths, full diff and whitespace.

Development checks caught CSV type inference in a candidate comparison and missing-score vector names in a synthetic test. Both were corrected without changing raw data. Strict completed-score checking also exposed the previously unmarked two-set source score; it is documented, not repaired. No unresolved execution failure remains.

## Smallest recommended next task

**Proposed Phase 1G:** a separately authorized reference-feasibility investigation for the seven missing bundles, suffix row and unmarked two-set score. First obtain an exact URL allowance and permissible local-use scope. Then establish whether complete counts and inventory/status evidence exist, preserving provenance and conflicts without automatic substitution or admission. Option A investigation is preferred; the user must choose and source availability/rights remain unverified.

2022, 2024 and 2025 stay closed. New references, recovery/reconstruction rules, chronology, status eligibility, factor-data admission, evaluation populations, rating history, statistical specifications, dependencies/structures and public derived-output rights remain decisions. The fixed panel, 90%/95% thresholds and development/validation/test boundaries are unchanged.

No acquisition, repair, imputation, canonical table, model, factor, forecast, predictive evaluation or portfolio work occurred. Nothing was pushed, published or deployed. DATA_LICENSE.md remains unchanged.

## Git and handoff

Phase 1F began clean on main at d1da82252fd6b9516ca4c6281ed7514f17959190 (Acquire and audit 2021 annual tennis data), eight ahead of the existing local origin/main. No later Phase 1F commit existed. Commit message: Review WTA 2021 Montreal data gaps. The final response records the completed commit and final Git state; no remote refresh occurred.

Every next task must finish with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000, in the response only. Do not invoke a handoff tool or create another task without a separate request.
