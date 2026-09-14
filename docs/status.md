# Tennis analytics status

Date: **2026-09-14**. **Phase 1C reconciliation is implemented. WTA passes inventory; ATP remains blocked by conflicting official identities. Do not expand the development panel or begin modeling yet.**

## Completed and verified

The flagship compares interpretable Four Factors with surface-adjusted Elo, separately for ATP and WTA. Challenger promotion readiness remains a later project. Phase 1C audited only 2023 Indian Wells main-draw singles.

Every HTML results-inventory match has one corresponding source row: **95/95 per tour**, with no missing rows or duplicate accepted links. Each bracket has 128 positions, 32 byes and 96 entrants. ATP has 91 completed matches and four retirements. WTA has 92 completed matches, two retirements and one walkover; that walkover remains in inventory but outside the 94-match played denominator.

WTA has 95 normalized agreements and passes inventory. ATP has 77 exact agreements, 15 normalized agreements and three conflicting matches. Both ATP HTML pages agree on all 127 entries including byes, but the PDF disagrees in two branches:

- Carreño Busta versus Albot: a bye entry and Murray's second-round opponent.
- Kudla versus Wawrinka: the first-round winner against Vukic and the next-round feeder identity against Kecmanovic. The PDF itself advances Wawrinka from a pair that does not contain him.

These are four conflicting PDF observations, covering three non-bye matches and one bye. Cause and source precedence remain unknown/unapproved. No identities were merged or corrected; ATP's gate stays blocked. See the [complete evidence and reconciliation](indian-wells-inventory-reconciliation.md).

## Statistics and modeling remain separate

Required counts are present for every played source row: ATP 95/95, WTA 94/94. Structural checks invalidate one WTA bundle, leaving **93/94 = 98.9362%** valid; ATP remains 95/95 numerically against its candidate inventory. Both clear the 90% numerical event floor. The **95% tour-season gate is not tested**.

[Phase 1B quarantine policy](wta-anomaly-and-quarantine-policy.md) remains active. Andreescu–Stearns (`2023-609:268`, LS033) stays in inventory and the played denominator but its entire statistical bundle remains excluded from the valid numerator. Published service games total 22 versus 29 score games. No correction occurred. Cross-source disagreement, completed-card/scheduled-metadata conflict and unresolved chronology remain recorded.

Final retirement/default eligibility is unsettled. Tournament-week dates and source match numbers do not establish actual chronology. Four Factors, Elo updates, rolling features and forecasts remain unauthorized, including WTA despite inventory passage.

## Reproduction and limitations

New acquisition/reconciliation scripts, an [inventory manifest](../data/manifests/inventory-reference-files.csv), 14 ignored CSVs and four ignored PDF images document the work. The [pilot report](pilot-acquisition-audit.md) is regenerated through its updated generator after reconciliation. Annual files, both pilot subsets and Phase 1B references remain unchanged; subsets were checked cell by cell.

Direct ATP HTML returned 403. Saved browsing-service representations supplied results/draw evidence, with explicit hashes and access times; these are not original HTTP bytes. Fresh reproduction requires restoring these exact captures or separately approving replacement evidence. WTA files were reused without redownloading. Its saved PDF predates the final, so saved HTML supplies that result. PDF evidence supplies missing retirement markers, and the walkover's missing HTML match ID receives a locator-based audit ID.

Downloader reruns preserve bytes/mtimes; reconciliation reruns are byte-identical. Tests cover identities, unordered pairs, orientation, scores/statuses, duplicate/unmatched/ambiguous rows and quarantine. Both earlier audits were rerun. Parsing/rendering failures were fixed and documented; no dependency was added.

## Smallest next task and user decisions

**Phase 1D: approve and implement an event-scoped official-reference precedence rule for the two ATP branches, then close or explicitly retain the ATP inventory block.** Start with existing evidence. The recommendation is to consider the two agreeing HTML pages authoritative while preserving the dissenting PDF. That recommendation is not approved or implemented as gate passage.

Do not acquire another season in that step. Broader development acquisition requires separate authorization after inventory review. Later choices include actual-date/completion-order evidence, retirement/default treatment, rating history, statistical methods/dependencies and derived-output publication rights.

No canonical production tables, ratings, factors, models, forecasts, analytical plots or website outputs were created. No other-season data was acquired. Unrelated navigation and qualifying sections in reference pages were excluded from analysis. Portfolio was not modified. Nothing was pushed, published or deployed.

## Git and handoff

Phase 1C started clean on `main` at `ff701d0d0c2d6e57ca6765aeddee4c26b7fd7915`. Commit message: `Reconcile Indian Wells official match inventories`. The final response records the exact new commit and final status; no remote refresh occurred.

Every next task must finish with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000, in the response only. Do not invoke a handoff tool or create another task without a separate request.
