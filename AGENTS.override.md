# Tennis Analytics: Active Codex Instructions

## Sources of truth

This repository owns the tennis research and reproducible outputs. The
portfolio repository is publication-only and requires explicit user approval.

Use progressive disclosure:

- Read `PROJECT_CONTEXT.md` for research-design, metric, model, evaluation or
  scope decisions.
- Read `docs/status.md` only through `CURRENT_SNAPSHOT_END` for routine work.
  Open older sections only when a named historical phase or artifact matters.
- For acquisition, transformation, eligibility, publication or licensing,
  search `docs/data-source-contract.md` and read the relevant section. Read the
  whole contract only for a contract-wide audit.
- Consult `tennis-analytics-public-data-research.pdf` only when introducing or
  reconsidering a source, tournament scope, tracking-data use or deliverable.
- `AGENTS.md` is the preserved detailed reference. Open a relevant section only
  if this file or a task-specific source does not answer the question.

Do not repeat standing repository rules in task prompts or handoffs.

## Work and approvals

Execute requested work directly. Start with the simplest statistically valid
approach. Add complexity only when it fixes a demonstrated problem or earns a
stable chronological validation improvement. Explain a non-obvious choice in
one sentence.

Inspect Git status before editing and committing. Preserve unrelated changes.
Never discard, reset, overwrite or delete work without explicit permission.
Complete and verify one coherent step, then commit it with a result-specific
message. Do not push unless the user asks.

Ask before adding a dependency; restructuring, moving or renaming files;
changing the tournament panel, chronological splits or an approved method;
introducing Python into the main analysis; adding scheduled collection;
modifying the portfolio; deleting work; publishing; deploying; or making a
licensing assumption that affects redistribution.

## Scientific non-negotiables

- Development is 2021–2023, validation/model selection is 2024, and 2025 is a
  locked final test. Freeze the pipeline before inspecting or tuning against
  2025.
- Use only information available before each predicted match. Build ratings and
  rolling features chronologically with outcome-neutral player orientation.
- Preserve retirements and walkovers in inventories, but exclude them and
  retirement partial statistics from primary Four Factors, Elo, histories and
  forecast evaluation.
- Never replace unavailable statistics with zero or impute outcomes.
- Four factors is a hypothesis. Report three if only three distinct, stable
  mechanisms survive. Same-match correlation alone cannot select a factor.
- Require manageable collinearity, stable incremental information and
  future-match value. Use interpretable standardized regression against Net
  Point Rating and account for shared variance before publishing weights.
- Build Elo chronologically. Do not award bonuses for tournament prestige or
  round reached. Added rules must solve a named problem or improve stable
  out-of-time performance.
- Compare models on the same eligible cohort. Calibration, Brier score and log
  loss are primary. Accuracy and ROC AUC are secondary.
- Do not claim Four Factors beat Elo unless the locked evaluation supports it.
- Report negative, unstable and partial findings. Never invent coverage,
  identities, statistics, weights, performance, findings or permissions.
- OTD remains paused until the user explicitly authorizes resumption.

## Implementation

R is the default language. Prefer tidyverse, ggplot2 and base R statistical
functions. Use small named functions and keep cleaning, metrics, modeling,
evaluation and exports separate. Explain why an unfamiliar tool is needed.

Keep raw sources unchanged. Preserve identifiers, spellings, missingness,
fingerprints, licenses and conflicts. Keep restricted raw and match-level
official data out of Git. Follow the data-source contract for provenance,
rights, checksums and admission rules.

## Token-efficient workflow

1. Start from the task prompt, current status snapshot, named prior commit and
   relevant diff.
2. Search headings or terms before opening a long document.
3. Reuse committed outputs and verification instead of restating their history.
4. Run affected checks first. Run the full historical suite only when shared
   behavior, a frozen boundary or a final gate requires it.
5. Do not create a readiness, planning or restatement document unless a specific
   unresolved blocker requires one.
6. Keep prompts to objective, authority, deliverables, task-specific acceptance
   checks and exclusions, commit message and handoff.

Use a delta-only `# ChatGPT Handoff`. Target 400–650 words and never exceed 800
words unless the user requests more. Include the result, ending commit, changed
files, material evidence, unresolved limitations, one next executable step and
the exact approval needed. Do not retell the full project history or invoke a
handoff tool.

## Completion

Keep decisions and implementations distinct. Update sibling claims when a
change makes them false. After meaningful work, update the current status
snapshot; add historical detail only when it preserves evidence needed later.

A step is complete when requested files exist, proportionate checks pass,
outputs were inspected, documentation matches reality, Git has no accidental
files, the step has a clear commit and remaining limitations are reported.
