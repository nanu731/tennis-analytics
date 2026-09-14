# Tennis analytics status

Date: **2026-09-14**. **Phase 1D is complete: ATP and WTA 2023 Indian Wells inventory gates pass. Four ATP PDF conflicts remain preserved and operationally resolved. Modeling remains unauthorized.**

## Completed and verified

The flagship compares interpretable Four Factors with surface-adjusted Elo, separately for ATP and WTA. Challenger promotion readiness remains deferred. Phase 1D used only saved evidence for 2023 Indian Wells main-draw singles.

Both inventories contain 95 non-bye matches, each mapped uniquely to one source row. Each bracket has 128 positions, 32 byes and 96 entrants. ATP has 91 completed matches and four retirements. WTA has 92 completed matches, two retirements and one walkover; the walkover remains inventoried but outside its 94-match played denominator.

The user approved and Codex implemented **Indian Wells ATP inventory reference-precedence policy 1.0.0**. The agreeing ATP Tour HTML results and draw representations control inventory identities only in the Carreño Busta/Albot and Kudla/Wawrinka branches. All four contradictory PDF observations remain in the audit with operational resolutions: one bye, Murray–Albot, Wawrinka–Vukic and Wawrinka–Kecmanovic. The PDF values were not edited or relabeled as agreement. See the [focused policy](atp-inventory-reference-precedence-policy.md) and [complete reconciliation](indian-wells-inventory-reconciliation.md).

ATP still has 77 exact links, 15 normalized links and three links classified as matched with conflict. Four reference conflicts are preserved, four are operationally resolved and zero remain unresolved. WTA still has 95 normalized links. Neither tour has unmatched rows, ambiguous result-to-source mappings or duplicate accepted links.

HTML agreement does not prove independence or general PDF inferiority. Sackmann is a separate aggregate cross-check, not the official conflict resolver. The cause of the PDF discrepancy remains unknown.

## Statistics and modeling remain separate

Required counts are present for every played source row: ATP 95/95 and WTA 94/94. Structural checks invalidate one WTA bundle, leaving **93/94 = 98.9362%** valid; ATP remains 95/95. Both pass the 90% numerical event floor. The **95% tour-season gate is not tested**.

[Phase 1B quarantine policy](wta-anomaly-and-quarantine-policy.md) remains unchanged. Andreescu–Stearns (`2023-609:268`, LS033) remains in inventory and the played denominator, but the entire bundle is excluded from valid numerators, factors, ratings and forecasts. The 22 service games versus 29 score games inconsistency, cross-source conflict, scheduled metadata and unresolved chronology remain recorded. No statistical correction occurred.

Final retirement/default eligibility still blocks event factor-data admission. Actual match dates, same-day order and completion order remain unresolved; tournament-week dates and source match numbers do not solve them. Ratings, rolling features, Four Factors and forecasts remain unauthorized.

## Reproduction and verification

No new data or external URLs were accessed. Annual files, pilot subsets, raw references and manifests remain unchanged. Phase 1B audit evidence and quarantine were reverified. The two ATP browser-service captures remain necessary for offline reproduction; they are not original HTTP bytes. The saved WTA PDF predates the final; earlier extraction limitations remain documented.

The strengthened HTML comparison independently checks draw advancement, scores and status evidence before applying precedence. Missing controlling references, changed evidence or out-of-scope conflicts stop resolution. Duplicate, unmatched and ambiguous mappings still block inventory admission. The four unrelated ATP retirements retain existing PDF status support; the three affected completed matches and bye do not need it.

Reconciliation generates the same 14 ignored CSVs with extended policy fields; the four existing PDF review images remain ignored. Repeated runs preserve output bytes and modification times. The [pilot report](pilot-acquisition-audit.md) is regenerated only after reconciliation and checks the reconciliation-code hash and policy evidence. Existing and new tests, source hashes, cell-by-cell subset agreement, links/anchors, ignore rules and Git checks are verified before commit. No dependency was added.

## Smallest recommended next task

**Phase 1E: separately authorized ATP/WTA 2021 annual-file acquisition and schema/provenance audit**, the first additional development slice. Confirm exact pinned files, permissible local use and existing-path reuse before downloading. This is a recommendation, not approval to acquire anything now. Indian Wells inventory no longer blocks the proposal; broader event inventories and tour-season admission remain unverified. Keep 2024/2025 closed.

Retirement eligibility and chronology are modeling/admission blockers, not reasons to claim that raw acquisition itself has been authorized. Later user decisions also include event-specific reference sources, rating history, statistical methods/dependencies and derived-output publication rights.

No additional season, canonical production dataset, model, rating, feature, forecast, analytical plot or website output was created. Portfolio was not modified. Nothing was pushed, published or deployed.

## Git and handoff

Phase 1D began clean on `main` at `7ea17df0d8ac82b256af58ecc0315ff9c188cbfc`, six ahead of the existing local `origin/main` reference. No newer Phase 1D commit existed. Commit message: `Resolve Indian Wells ATP reference precedence`. The final response records the completed commit and final Git state; no remote refresh occurred.

Every next task must finish with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000, in the response only. Do not invoke a handoff tool or create another task without a separate request.
