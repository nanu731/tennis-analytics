# Tennis analytics status

Date: **2026-09-14**. Milestone: **Phase 1B WTA anomaly verification and quarantine policy complete. Correct statistics, full inventory and model readiness remain unresolved.**

## Completed and directly verified

- Began Phase 1B clean on `main` at `dec1b67c9d3713ea03835ebb22671d3b56d0ae75`, four ahead of the existing local `origin/main`. Confirmed instructions, five commits, existing documents/scripts and both annual-file hashes. No remote synchronization occurred.
- Acquired only the four authorized 2023 anomaly references: official WTA match page, official draw PDF, official draws HTML, and the supplementary Tennis Abstract charted match. Exact URLs, timestamps, hashes and rights notes are in the [reference manifest](../data/manifests/anomaly-reference-files.csv).
- Official WTA counts agree with Sackmann on all 18 required fields, including service games 11/11. The score has 29 completed games without a tie-break, so published agreement still fails the structural rule. The official draw confirms this match's presence/result only. Supplementary break-point counts disagree; no corrected value was adopted.
- Implemented offline comparison and shared quarantine policy 1.0.0. WTA match 268 retains inventory/result facts and its played denominator membership, but its entire statistical bundle leaves the valid numerator and factor-statistics candidate population. Reasons are `structural_count_conflict`, `cross_source_conflict`, `status_unresolved`, and `chronology_unresolved`. See [full evidence and policy](wta-anomaly-and-quarantine-policy.md).
- Recalculated WTA valid coverage: 93/94 = 98.9362%; its walkover remains separate, within the 95-row inventory and outside the played denominator. ATP remains 95/95 = 100%. Both exceed the provisional 90% numerical event floor. The 95% tour-season gate was not tested; retirement eligibility is not settled.
- Regenerated the [pilot report](pilot-acquisition-audit.md) through its generator and updated the [contract](data-source-contract.md), preserving the distinction between the original pilot and this official-reference follow-up. Annual files and both source subsets remain unchanged.

## Verification and warnings

Reference downloader reruns preserved bytes, hashes, retrieval timestamps and modification times. An in-memory mismatch test stopped before network/write activity. Anomaly audit reruns produced byte-identical outputs. Tests covered the real flagged row, a valid completed match, missing service games, cross-source count conflict and the separate walkover. The pilot audit was rerun, and both subsets were compared cell-by-cell with the unchanged annual source rows. No synthetic records were persisted.

All four reference acquisitions succeeded with base R. Existing bundled `pdftotext` handled the PDF; no dependency was installed. Browser-readable Tennis Abstract content omitted script-embedded tables, so the offline parser read the saved whole-match overview. Official HTML contains conflicting scheduled JSON-LD and completed match-card status; both are retained. The WTA date and charted URL date differ, with no timezone resolution. Earlier pilot network/font warnings remain historical findings in its report, not failures of Phase 1B acquisition.

## Unresolved issues and approval boundaries

- Quarantine is adopted; correct counts and any reconstruction policy remain unresolved. Shared upstream dependence may explain repeated published values, but feed lineage is not established.
- WTA's match-associated date is 2023-03-12; the supplementary URL says 20230311. No canonical actual date, same-day order or completion-time policy is selected. One match's reference evidence does not solve event-wide chronology.
- Complete official ATP/WTA inventory reconciliation, final retirement/default/unknown-status eligibility, historical rating scope and publication rights remain unresolved. Factor analysis, Elo updates and forecasting remain unauthorized.

## Recommended next milestone

Complete official match-inventory reconciliation for the **2023 Indian Wells ATP and WTA draws**. This was not started in Phase 1B beyond confirming the target match. Do not acquire the full development panel yet. Keep other seasons closed; preserve quarantine and the unresolved chronology/retirement boundaries.

No packages, canonical tables, Elo, Four Factors, player ratings, forecasts, analytical plots, or performance evaluations were created. No other-season dataset was acquired or analyzed. The authorized 2023 HTML contains unrelated navigation/news, which was excluded from the analysis. Raw annual files, raw references and generated pilot/anomaly outputs remain outside Git. The portfolio repository was not modified. Nothing was pushed, published, or deployed.

## Commit and handoff

Phase 1B uses commit message `Document WTA anomaly quarantine policy`; the final response records its exact hash and final Git status. The earlier acquisition commit remains in history. Future new documents still require explicit staging because the existing `docs/` ignore rule is preserved.

Every next task must end with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000. Do not send it, invoke a handoff tool, or create another task without a separate request.
