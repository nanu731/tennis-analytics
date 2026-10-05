# Methodology and limitations

This page summarizes how the flagship Four Factors versus surface Elo comparison was built and where its evidence stops. It links to the phase reports instead of restating them. Research design authority is [PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md); current progress is in [status](status.md).

## Status

The locked 2025 evaluation is complete. Primary surface Elo has lower log loss and Brier score than both factor candidates in both tours, and every whole-batch deletion keeps that direction. The calibration comparison is unresolved for both candidates ([results](2025-locked-final-evaluation-results.md#result)). In this cohort the factor models did not match Elo's forecast loss. Their descriptive or explanatory value was not assessed. No model was selected, no significance or superiority is claimed, and Four Factors received no final qualification.

TODO_USER_COPY: your interpretation and any conclusions you draw for future work.

## Design

| Element | Method | Source |
| --- | --- | --- |
| Question | Can interpretable factors match or beat surface-adjusted Elo as calibrated forecasts? | [Central question](../PROJECT_CONTEXT.md#central-question) |
| Panel | ATP and WTA separately; main-draw singles at ten event families | [Fixed scope](../PROJECT_CONTEXT.md#fixed-research-scope) |
| Splits | Development 2021–2023, validation 2024, locked test 2025 | [Fixed scope](../PROJECT_CONTEXT.md#fixed-research-scope) |
| Admission | Source-present records with source-reported normal completion, verified identity/context and valid counts; retirements, walkovers and invalid bundles excluded; nothing imputed | [Source-defined cohort decision](../PROJECT_CONTEXT.md#phase-2g-provisional-candidates-and-data-standard), [2025 protocol](2025-locked-final-test-protocol.md#frozen-panel-and-admission) |
| Chronology | Same-tour matches sharing a source tournament date form one simultaneous batch; nothing within a batch updates another | [Batching decision](source-label-event-batching-decision.md), [2025 protocol](2025-locked-final-test-protocol.md#carry-forward-state-and-simultaneous-batches) |

Admitted cohorts: development 2,580 (ATP 2023 and WTA 2021/2023 files only) ([Phase 2H](source-defined-cohort-audit.md), [Elo baseline](../PROJECT_CONTEXT.md#phase-2o-fixed-development-baseline--implemented-in-phase-2p)); 2024 1,901 ([2024 results](2024-validation-results.md#implementation-and-coverage)); 2025 1,878 across ten ATP and eight WTA cells ([2025 admission](2025-source-admission-audit.md), [conflict review](2025-source-conflict-review.md)).

## Features and models

- **Outcome for factor design.** Net Point Rating, `100 * (points won − points lost) / total points` ([definition](../PROJECT_CONTEXT.md#net-point-rating-and-four-factors)).
- **Candidate set S08.** M03, M05, M11 and M12, pooled from each player's earlier admitted matches by summing counts before dividing. Empty histories and zero denominators stay undefined ([pooling](2025-feature-elo-construction-audit.md#frozen-implementation), [M05 terminology](m05-role-clarification-decision.md)). Its selection history is in the [Phase 2G decision](occam-candidate-and-data-decision.md) and the [pre-validation decision](pre-validation-candidate-decision.md).
- **Forecast models.** Full (M03/M05/M11/M12) and reduced (M03/M11/M12) zero-intercept logistic regressions on player-A-minus-player-B differences. Each predictor is scaled by its training-fold standard deviation, and each model is refit once per batch on strictly earlier complete matches. Fits must pass count, design, collinearity and fit gates, with no rescue ([numerical spec](2025-locked-final-test-protocol.md#numerical-specification-and-failure-precedence)).
- **Elo benchmark.** Initial rating 1500, scale 400, K=32. The primary rating is 0.5 × overall + 0.5 × surface; overall-only Elo is a sensitivity. Updates are summed per batch, with no round, prestige, margin or inactivity rules ([Elo design](../PROJECT_CONTEXT.md#phase-2o-fixed-development-baseline--implemented-in-phase-2p), [Phase 2P audit](surface-elo-baseline-audit.md)).

## Evaluation

- **Common mask.** All four methods are scored on the same matches: those with a complete S08 vector whose folds passed for both models ([forecast comparison](../PROJECT_CONTEXT.md#forecast-comparison)).
- **Primary metrics.** Natural-log loss and Brier score, by tour. Accuracy is secondary.
- **Loss labels.** A candidate gets a directional label only if all four tour/metric differences against primary surface Elo share a strict sign and every whole-batch deletion keeps it. Otherwise the result is unresolved ([final loss conclusions](2025-locked-final-test-protocol.md#common-evaluation-and-final-loss-conclusions)).
- **Calibration.** Descriptive intercept and slope. A candidate is "better" only if, in each tour, it is no farther from 0 and 1 on both measures and strictly closer on one ([calibration rule](2025-locked-final-test-protocol.md#calibration-influence-and-interpretation-boundaries)).
- **Influence checks.** Batch and player deletions without refitting. These are not intervals.

Phase results: [development paired evaluation](s08-paired-evaluation-results.md), [M05 ablation](m05-ablation-results.md), [2024 validation](2024-validation-results.md), [2025 locked evaluation](2025-locked-final-evaluation-results.md).

## Limitations

- **Chronology.** No verified forecast chronology exists: NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE. Source date labels define batches, and actual match timing and event overlap are unverified ([chronology audit](pre-match-chronology-audit.md)).
- **Uncertainty.** UNCERTAINTY_NOT_ESTABLISHED. No interval, p-value or bootstrap was produced, and deletion ranges are influence checks only ([uncertainty feasibility](dependence-aware-uncertainty-feasibility.md)).
- **Coverage.** Admission is conditional on source presence and official recall is unknown. Development lacks 2022 and ATP 2021 ([Phase 2H inputs](source-defined-cohort-audit.md#inputs-and-saved-use-verification)). History depth differs by tour. The 2025 WTA cohort excludes Canada and Cincinnati ([conflict review](2025-source-conflict-review.md#mandatory-scope-of-every-final-result)).
- **Eligibility.** Matches where a player has no prior admitted history get no factor prediction. In 2025 that left 101 of 1,878 targets unscored for all methods ([2025 coverage](2025-locked-final-evaluation-results.md#coverage-and-folds)).
- **Factor status.** SELECTION_UNRESOLVED from 2024 stands. S02 is paused and S08 remains provisional. M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED is binding: 2024 M05 signs were ATP 5 negative / 5 positive and WTA 9 / 1 ([2024 results](2024-validation-results.md#selection-and-separate-interpretation)). The all-negative 2025 signs are replication evidence only ([2025 M05](2025-locked-final-evaluation-results.md#m05-fold-signs)).
- **Interpretation.** Coefficients are forecast parameters, not importance weights. Nothing here shows that a factor causes winning.
- **Rights.** Use is noncommercial research under the saved CC BY-NC-SA 4.0 basis. Publication of derived outputs needs a separate review ([DATA_LICENSE.md](../DATA_LICENSE.md)).

## Not completed

- Official ranking or ranking-points baseline
- Factor weights with uncertainty (for example, shares of explained Net Point Rating variation)
- Reliability curves
- Player factor profiles
- Interval estimates
- Full-panel WTA coverage
- Challenger promotion-readiness project
- Portfolio integration
