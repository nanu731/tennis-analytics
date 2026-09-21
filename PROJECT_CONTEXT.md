# Tennis Analytics Project Context

**Draft for user review.** This file records the stable purpose and research design of the project. It does not replace `AGENTS.md`, the current status report, or the data-source contract. Decisions labeled for confirmation remain proposals until the user approves them.

## Central question

The flagship project asks:

> Can an interpretable Four Factors model capture tennis player strengths and produce better-calibrated match forecasts than surface-adjusted Elo?

The goal is a model that generalizes to future matches and explains player strengths. The project does not need Four Factors to beat Elo on every metric to succeed. A stable, well-calibrated model that adds useful interpretation can still produce a meaningful result. If the evidence does not support four distinct and stable factors, report that finding instead of forcing the framework.

The Challenger promotion-readiness project remains secondary. Begin it only after the flagship data, identity, rating, and evaluation infrastructure has passed validation.

## Fixed research scope

Analyze ATP and WTA separately across these ten event families:

- Australian Open
- Roland-Garros
- Wimbledon
- US Open
- Indian Wells
- Miami
- Madrid
- Rome
- Canada, retaining Montreal and Toronto as edition cities
- Cincinnati

Use main-draw singles. Preserve qualifying, doubles, juniors, team events, Challenger events, and ITF events outside the flagship cohort unless the user approves a scope change.

Use these chronological periods:

- **Development:** 2021–2023
- **Validation and model selection:** 2024
- **Locked final test:** 2025

Do not inspect 2025 performance while choosing formulas, thresholds, features, Elo settings, factor definitions, or model parameters. Freeze the complete pipeline before the first final-test evaluation.

## Generalization and leakage

Design every method for future use rather than for reproducing the observed seasons. Every prediction must use only information available before the match.

Required protections include chronological processing, lagged features, pre-match ratings, outcome-neutral player orientation, and tests that fail when future information enters a feature. Choose among reasonable specifications with development data and 2024 validation. Do not keep changing the method after seeing 2025 results.

Assess stability across seasons, surfaces, events, ATP, and WTA. Report uncertainty, negative results, and unstable coefficients. Prefer a simpler stable specification when added complexity does not produce a repeatable validation improvement.

## Match eligibility

### Proposed for confirmation in this draft

The primary models estimate performance conditional on a match reaching normal completion.

- Preserve retirement matches in the raw inventory and status audit.
- Exclude retirement matches from Four Factors calculations, Elo updates, and the primary forecast evaluation.
- Exclude partial statistics from retired matches from player histories and rolling factor inputs.
- Preserve walkovers in the event inventory but exclude them from Four Factors, Elo updates, and forecast evaluation because no match play occurred.
- Report excluded retirement and walkover counts by tour, season, event, and surface.

This project will not attempt to predict retirement. Injury onset, health, workload, recovery, weather exposure, and other relevant inputs are not available with enough consistency for the current scope. A future project may study availability risk under a separate outcome and data contract.

## Net Point Rating and Four Factors

Use Net Point Rating as the primary explanatory outcome:

`100 * (points_won - points_lost) / total_points`

Treat match win as the separate forecasting outcome. Retain equal-phase Net Point Rating as a sensitivity outcome so unequal service-point totals do not silently control the result.

The four current candidate families are:

1. Serve Creation
2. Second-Serve Security
3. Return Pressure
4. Conversion and Recovery

These names describe hypotheses, not guaranteed final factors. Build candidate measures from auditable tennis counts, use missing values when a denominator is unavailable, and account for opponent strength, surface, sample size, and correlated predictors.

Begin factor weighting with interpretable multiple linear regression. Do not publish raw coefficients as importance weights when predictors use different scales or share variance. Estimate relative importance with uncertainty and test whether weights remain stable across tours and surfaces.

## Elo benchmark

Build Elo in chronological order. Start with overall Elo, surface-specific Elo, and a documented blend that shrinks surface ratings toward overall ratings.

### Proposed for confirmation in this draft

Do not award extra Elo credit for reaching a later tournament round or for playing in a more prestigious tournament. Elo should update from the opponent's pre-match strength and the match result. A player who reaches a final already accumulates updates from the matches won along the way. Round or prestige bonuses would mix achievement ranking with predictive strength and could count the same tournament run twice.

Account for surface and match format where justified. Document the initial rating, K-factor, surface blend, inactivity rule, best-of-three versus best-of-five treatment, and all eligibility rules before final evaluation. Add margin-of-victory or tournament weighting only as a prespecified comparison that earns a stable validation improvement.

## Forecast comparison

Compare at least:

- Official ranking or ranking-points baseline
- Overall Elo
- Surface-adjusted Elo
- Four Factors
- Surface-adjusted Elo plus Four Factors

Evaluate ATP and WTA separately. Report Brier score, log loss, calibration intercept, calibration slope, and reliability curves. Use accuracy and ROC AUC as secondary measures. Use the same eligible completed-match evaluation cohort for the Elo and Four Factors comparison.

The primary claim concerns out-of-sample calibration. Do not claim Four Factors outperform Elo unless the locked evaluation supports that statement under the prespecified metrics. Comparable predictive performance with clearer player explanations remains a useful result.

## Data and publication boundaries

Keep raw observations unchanged. Preserve source identifiers, source spellings, missingness, provenance, fingerprints, licenses, and conflicts. Never replace an unavailable statistic with zero. Keep source observations, official references, recovery overlays, and future canonical analytical records as separate layers.

Free access does not establish permission to redistribute data or publish derived products. Keep restricted raw and match-level official data outside Git. Review rights before publishing aggregates, ratings, charts, JSON, or website material.

The `tennis-analytics` repository owns the research and reproducible outputs. The `portfolio` repository receives reviewed, website-ready outputs only after the user requests integration.

## Sources of truth

- `AGENTS.md` defines how Codex must work in this repository.
- `PROJECT_CONTEXT.md` defines the stable research purpose and methodological direction.
- `docs/status.md` records the current completed phase, blockers, and next decision.
- `docs/data-source-contract.md` defines data provenance, validation, rights, and eligibility boundaries.
- Adopted policy documents govern only their stated versions and scopes.

Read `docs/status.md` before starting a new phase. When a decision in this draft receives approval, remove the draft label, update every affected source-of-truth document, and keep the distinction between approval and implementation explicit.
