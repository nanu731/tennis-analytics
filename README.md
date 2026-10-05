# tennis-analytics

Can a small set of interpretable tennis statistics (a tennis version of basketball's "Four Factors") forecast match winners as well as, or better than, a surface-adjusted Elo rating?

This repository holds the data audits, R code, tests and reports for that question. The question and design are set out in [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md#central-question).

TODO_USER_COPY: why this question matters to you and what you wanted to learn from it.

## Result in one paragraph

On the locked 2025 final test, **both factor models had higher forecast loss than surface Elo**, in both the ATP and WTA cohorts, on both log loss and Brier score. Removing any single tournament batch did not change that direction. The calibration comparison was **unresolved**: neither factor model was closer to perfect calibration than Elo in both tours. This is a forecasting result for one cohort. It does not show that Elo is significantly better, because no intervals or p-values were computed, and it does not assess whether the factors describe or explain player performance. No model was selected and the Four Factors framework received no final qualification. Source: [2025 results](docs/2025-locked-final-evaluation-results.md#result).

TODO_USER_COPY: your interpretation of what this result means for the project.

## Data and splits

- **Source.** Jeff Sackmann / Tennis Abstract ATP and WTA annual match files, read from a pinned archival mirror (see [Data attribution and licensing](#data-attribution-and-licensing)).
- **Panel.** ATP and WTA main-draw singles at ten event families: the four Grand Slams, Indian Wells, Miami, Madrid, Rome, Canada and Cincinnati ([scope](PROJECT_CONTEXT.md#fixed-research-scope)).
- **Admission.** A match enters only if the source reports a normal completion, the player identities and event context check out, and all needed serve and return counts are valid. Retirements, walkovers and invalid statistic bundles are excluded, never imputed. Coverage is "present in the source", not verified official tournament coverage.

| Split | Role | Admitted matches | Source |
| --- | --- | --- | --- |
| Development | Build and test candidate measures | 2,580 (ATP 2023: 846; WTA 2021 and 2023: 1,734); 2022 is missing | [Phase 2H audit](docs/source-defined-cohort-audit.md), [Elo baseline](PROJECT_CONTEXT.md#phase-2o-fixed-development-baseline--implemented-in-phase-2p) |
| Validation | Compare prespecified models | 1,901 (ATP 944; WTA 957) | [2024 results](docs/2024-validation-results.md#implementation-and-coverage) |
| Locked final test | One frozen evaluation | 1,878 (ATP 1,011 in ten cells; WTA 867 in eight cells) | [2025 results](docs/2025-locked-final-evaluation-results.md#coverage-and-folds) |

WTA Canada and Cincinnati 2025 are wholly excluded because of source event-context conflicts that the locked rules do not allow to be repaired ([conflict review](docs/2025-source-conflict-review.md#wta-context-and-independent-exclusions)). The 2025 WTA result therefore covers eight of ten events.

## What the models use

**Net Point Rating** is the project's net-performance outcome: points won minus points lost, as a share of all points, times 100 ([definition](PROJECT_CONTEXT.md#net-point-rating-and-four-factors)). It is the explanatory outcome for factor design. The forecasts below predict match wins.

**S08** is the provisional factor set. Each player's value is pooled from their earlier matches only, and the model uses the difference between the two players ([pooling table](docs/2025-feature-elo-construction-audit.md#frozen-implementation)):

| Code | Plain meaning | Candidate family |
| --- | --- | --- |
| M03 | Share of first-serve points won when the first serve goes in | Serve creation |
| M05 | Double faults per second-serve opportunity (lower is better) | One part of second-serve security |
| M11 | Break points the player creates per opponent service game | Return pressure |
| M12 | Share of those break points the player converts | Conversion |

Two candidates were tested: the **full** model (all four) and a **reduced** model without M05 (three factors). Both are logistic regressions with no intercept, refit before each tournament batch using only earlier matches.

**Elo benchmark.** Every player starts at 1,500. After each tournament batch, the rating moves by 32 times the gap between the result and the expected result, with separate overall and surface ratings. The primary benchmark averages the two ratings; overall-only Elo is a sensitivity check. There are no bonuses for round or prestige ([Elo design](PROJECT_CONTEXT.md#phase-2o-fixed-development-baseline--implemented-in-phase-2p)).

## Results

Lower log loss and Brier mean better forecasts. Differences are factor model minus primary surface Elo, so a positive number means Elo did better.

| Split | Tour | Full − Elo (log loss / Brier) | Reduced − Elo (log loss / Brier) | Label |
| --- | --- | --- | --- | --- |
| 2025 locked test | ATP (951 matches) | +0.0225 / +0.0087 | +0.0220 / +0.0085 | Surface Elo lower loss, for both candidates |
| 2025 locked test | WTA (826 matches) | +0.0207 / +0.0078 | +0.0224 / +0.0086 | Surface Elo lower loss, for both candidates |
| 2024 validation | ATP (871 matches) | +0.0162 / +0.0069 | +0.0159 / +0.0067 | Selection unresolved |
| 2024 validation | WTA (912 matches) | +0.0282 / +0.0123 | +0.0288 / +0.0126 | Selection unresolved |

Calibration on 2025 was unresolved for both candidates: in ATP the factor models had a slope closer to 1 but an intercept farther from 0, and in WTA Elo was closer on both. Every method had a calibration slope above 1, meaning its forecasts were less extreme than the outcomes supported. In 2024, the full-versus-reduced comparison split by tour, so neither model was preferred. Sources: [2025 scores and calibration](docs/2025-locked-final-evaluation-results.md#scores-on-the-common-mask), [2024 scores](docs/2024-validation-results.md#paired-descriptive-scores).

## Limitations

- **Forecast chronology is approximate.** Matches are grouped by the source's tournament date, and real-world timing is not verified.
- **Uncertainty is not estimated.** Deletion checks show the direction is stable, but they are not confidence intervals.
- **Coverage is partial.** Development lacks 2022 and ATP 2021. The 2025 WTA cohort covers eight of ten events, and official tournament coverage is unknown.
- **M05 failed its direction test.** Its 2024 coefficients were mixed in sign (ATP 5 negative / 5 positive; WTA 9 / 1), so the requirement for a negative direction in every fold of both tours is not met. The all-negative 2025 signs do not reverse that ([2024 M05 signs](docs/2024-validation-results.md#selection-and-separate-interpretation)).
- **Factor importance is not estimated.** Model coefficients are forecast parameters, not factor weights.

The full list is in [methodology and limitations](docs/methodology-and-limitations.md#limitations).

## Not completed

These parts of the original plan were not done:

- Official ranking or ranking-points baseline
- Factor weights with uncertainty
- Reliability curves
- Player factor profiles
- Interval estimates (confidence intervals or equivalent)
- Full-panel WTA coverage
- The Challenger promotion-readiness project
- Portfolio website integration

## Repository layout

- `R/`: phase scripts, mostly paired with a test file. Generated outputs go to `data/pilot/`, which is not tracked.
- `docs/`: phase reports, protocols and the current [status](docs/status.md).
- `data/manifests/`: source provenance and checksums. No match rows are tracked.

## Data attribution and licensing

Repository code is under the [MIT license](LICENSE). That license does not cover the tennis data or outputs derived from it.

Match data: **Jeff Sackmann / Tennis Abstract** ([ATP](https://github.com/JeffSackmann/tennis_atp), [WTA](https://github.com/JeffSackmann/tennis_wta)), read from the [Aneeshers archival mirror](https://github.com/Aneeshers/tennis-sackmann-archive/tree/83733587353df8a41f2fd4f516147d5aa83f5a8d) at commit `83733587353df8a41f2fd4f516147d5aa83f5a8d`. The saved source documentation identifies [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/): credit the creator, noncommercial use only, share adaptations alike. The mirror adds no rights. This project uses the data for noncommercial educational research. Raw files and match-level outputs stay out of Git, and nothing here is a public player-statistics dataset. Publication of derived ratings or exports needs a separate rights review. Details and per-year manifests: [DATA_LICENSE.md](DATA_LICENSE.md) and [data/manifests/](data/manifests/).
