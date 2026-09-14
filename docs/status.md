# Tennis analytics status

Date: **2026-09-14**. **Phase 1E is complete: ATP/WTA 2021 annual files acquired and audited. All 20 target cells have source candidates; none has official inventory confirmation or modeling admission. WTA Canada/Montreal needs a focused availability review.**

## Completed and verified

The flagship compares interpretable Four Factors with surface-adjusted Elo, separately for ATP and WTA. Challenger promotion readiness remains deferred. This repository is the research workspace; portfolio publishing requires completed, reviewed outputs and a separate user request.

Phase 1E accessed only the two user-authorized 2021 annual CSV URLs and their two pinned GitHub API metadata URLs. At archive revision 83733587353df8a41f2fd4f516147d5aa83f5a8d, ATP contains 2,733 rows / 573,056 bytes; WTA contains 2,597 rows / 531,828 bytes. Both sizes, Git blobs, SHA-256 hashes and complete CSV parses pass. The [development manifest](../data/manifests/development-source-files.csv) records two new entries; the 2023 manifest was preserved. Saved API JSON and raw CSVs remain ignored.

All four 2021/2023 annual files share the same ordered 49-column header, including 36 required fields. Each tour has ten found, zero missing and zero ambiguous source candidate cells. Full provenance, required-field missingness, source metadata, status vocabularies and all 20 cells appear in the [2021 source audit](2021-annual-source-audit.md).

## Findings requiring further review

WTA Canada/Montreal has all 18 counts in **47/54 apparent-play rows (87.0370%)**, below the provisional 90% event floor. Seven late-round matches lack entire count bundles: four quarterfinals, two semifinals and the final. The other 19 cells have 100% joint presence in the descriptive apparent-play cohort. These fractions measure presence, not structural validity or official inventory coverage; no 2021 gate passed or was finalized as failed.

WTA Montreal score 2021-806:260 contains the unexplained suffix RET+H64. The retirement marker is retained; the suffix is neither corrected nor assigned meaning. Existing WTA 2023 Miami also contains RET+H61. Bracketed match tie-break formats and walkovers with populated counts are separately reported. Raw bytes remain unchanged; no eligibility or missing-data policy was implemented for these findings.

Tournament date labels do not establish actual match dates, within-day order or completion order. Source draw sizes and match-row totals do not establish official entrants or inventory denominators. No official 2021 references were acquired. Common headers do not establish that ATP/WTA can share every transformation.

## Existing Indian Wells policies preserved

ATP and WTA **2023 Indian Wells inventory gates remain PASS**, each with 95 non-bye matches. ATP has 77 exact, 15 normalized and three matched-with-conflict links. The [ATP precedence policy 1.0.0](atp-inventory-reference-precedence-policy.md) preserves four resolved PDF conflicts, scoped only to the two approved branches; no general source precedence is inferred. WTA has 95 normalized links. See the [reconciliation report](indian-wells-inventory-reconciliation.md).

The [WTA quarantine policy 1.0.0](wta-anomaly-and-quarantine-policy.md) still excludes the complete Andreescu–Stearns statistical bundle (2023-609:268 / LS033) while preserving inventory and played-denominator membership. All four quarantine reasons remain; 22 recorded service games disagree with 29 score games. WTA remains 93/94 structurally valid (98.9362%); ATP remains 95/95. Final retirement/default eligibility still blocks factor-data admission. Both policies and their generated evidence remain unchanged.

## Reproduction and verification

Run Rscript R/download_2021_annual_data.R, then Rscript R/audit_2021_annual_data.R --self-test from the repository root. The downloader reuses verified files without requests or changed timestamps; the audit is offline and produces nine ignored CSVs plus its tracked Markdown report. Existing base R, curl, Git and SHA-256 utilities are used; no package or environment was added.

Checks cover exact URL/pin/API paths, file integrity, malformed/HTML/header rejection, required-column failure, schema differences, alias collisions, explicit missing/ambiguous cells, wrong-year exclusion, score evidence, unique annual/tour row namespaces and deterministic reruns. Final verification also checks existing file hashes and modification times, unchanged policies, allowed raw inventory, Git ignore rules, local documentation links/anchors, paths/placeholders, full diff and whitespace. The 2023 pilot was rerun to regenerate only its historical next-step note; its subsets and audit tables retain their bytes.

The initial sandboxed request failed DNS resolution; the authorized network-enabled retry used the same four URLs and succeeded. No mirror, revision or source fallback occurred. Parser newline handling, a single-row simplification bug and temporary report-assembly syntax errors were corrected during development. No unresolved acquisition or test failure remains. Metadata parsing deliberately rejects unexpected API formatting.

## Smallest recommended next task

**Proposed Phase 1F:** review WTA 2021 Canada/Montreal's seven missing count bundles, score suffix and descriptive denominator using saved local evidence. Produce a focused anomaly inventory and admission-review plan without repairing values, assuming eligibility or changing gates. Any new official-reference acquisition requires a separately authorized URL scope.

**User decisions still required:** any 2022 acquisition; official inventory/reference sources; final retirement/default/unknown-status treatment; exact dates and ordering; rating-history scope; later factor/Elo/statistical specifications; new dependencies or structures; and public derived-output rights. The 95% tour-season gate is untested and the 2021–2023 development panel remains incomplete. Keep 2022, 2024 and 2025 closed. No canonical tables, Four Factors, Elo, forecasts or predictive evaluation are authorized.

Portfolio was not modified. No unauthorized data, analytical plots, models or website outputs were created. Nothing was pushed, published or deployed. Existing licensing cautions and the fixed ten-family panel / development-validation-test split remain unchanged.

## Git and handoff

Phase 1E began clean on main at 3ac54d2a6118f665856668dd130c2925d552b49f (Resolve Indian Wells ATP reference precedence), seven commits ahead of the existing local origin/main reference. No later Phase 1E commit existed. Commit message: Acquire and audit 2021 annual tennis data. The final response records the completed commit and final Git state; no remote refresh occurred.

Every next task must finish with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000, in the response only. Do not invoke a handoff tool or create another task without a separate request.
