# Tennis analytics status

Date: **2026-09-14**. Milestone: **Phase 1 data-source contract documented; acquisition and modeling not started.**

## Completed

- Read the repository instructions and all 20 pages of the research PDF.
- Investigated each requested source family through documentation, license/terms pages, official references, or recorded failed retrievals.
- Created [data-source-contract.md](data-source-contract.md): provisional classifications, rights constraints, fixed tournament panel, raw-field and derived-measure requirements, nine proposed tables, quality gates, and unresolved decisions.
- Created this status document. No existing repository files were changed.

## Verified directly

- Starting repository: `tennis-analytics`, branch `main`, clean at `f4d5ecad8f1e96ab3076fbef2b1d9eda673e1e92`; three commits existed, with the branch two ahead of its local `origin/main` reference. No remote synchronization was performed.
- Research PDF present and readable; source-count claims were not reproduced.
- Readable archive dictionaries and preserved licenses; IBM repository license; Live Tennis academic conditions; conflicting TennisData.app provisions; Open Tennis Data schema/data terms; selected WTA metadata and ITF category guidance. The contract specifies the exact evidence and retrieval limits.
- Existing `.gitignore` ignores `docs/`; explicit staging of these two authorized documents is required. The ignore rule is unchanged.

## Unimplemented

No tennis data acquisition, raw manifests, canonical tables, R/Python code, package installation, environment setup, data cleaning, computed statistics, Elo, Four Factors, forecasts, or performance evaluation. The portfolio repository was not modified. Nothing was published, deployed, or pushed.

## Blockers and decisions

Before acquisition, resolve or explicitly bound contract decisions U1–U5: intended noncommercial use and source rights; initial source/pin; main-draw/status eligibility; proposed coverage thresholds; and date-evidence policy. ATP historical calendar verification and tennis-data.co.uk availability/terms remain incomplete. No provider access grant exists for Live Tennis or TennisData.app.

Before forecasting, resolve exact match chronology, same-day/suspended-match handling, rating-history scope, and later statistical choices. A tournament-week date does not establish match order. These issues do not invalidate completion of this documentation milestone, but they prevent claiming acquisition/model readiness.

## Recommended next milestone

Review the contract and resolve the listed decisions. Then authorize a small pinned development-season ATP/WTA acquisition pilot with exact event/year, local-only storage, provenance records, and permitted tooling specified. Test schema/status/date feasibility before broad acquisition. If rights/date evidence remain blocked, do a focused documentation clarification step first.

Keep the ten-family 2021–2025 panel and 2021–2023 / 2024 / 2025 split unchanged. Every future completion prompt should request a written ChatGPT Handoff of approximately 2,000 words, with a strict maximum of 2,000 words. Do not send the handoff or create another task without an explicit user request.

## Commit record

This milestone's commit is identified by the exact message `Document Phase 1 tennis data source contract` and contains only this file and `docs/data-source-contract.md`. The final response reports the resulting hash and post-commit Git status; no self-referential hash is embedded in the files being committed.
