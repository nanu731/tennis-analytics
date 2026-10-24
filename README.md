# tennis-analytics

## Overview

Can a small set of interpretable tennis statistics (a tennis version of basketball's "Four Factors") forecast match winners as well as, or better than, a surface-adjusted Elo rating?

This repository contains the data audits, R code, tests and reports for that question. The [methodology and limitations](docs/methodology-and-limitations.md) describe the research question, study design and evidence boundaries.

TODO_USER_COPY: why this question matters to you and what you wanted to learn from it.

### Result summary

On the locked 2025 final test, **both factor models had higher forecast loss than surface Elo** in the ATP and WTA cohorts, measured by log loss and Brier score. Removing any single tournament batch left that direction unchanged. The calibration comparison remained **unresolved**: neither factor model came closer to perfect calibration than Elo in both tours.

This result concerns forecasting in one cohort. Without intervals or p-values, it does not establish a statistically significant advantage for Elo. It also does not assess whether the factors describe or explain player performance. The evaluation selected no model and gave the Four Factors framework no final qualification. Source: [2025 results](docs/2025-locked-final-evaluation-results.md#result).

TODO_USER_COPY: your interpretation of what this result means for the project.

## Project details

### Data and splits

- **Source.** Jeff Sackmann / Tennis Abstract ATP and WTA annual match files, read from a pinned archival mirror (see [Data attribution and licensing](#data-attribution-and-licensing)).
- **Panel.** ATP and WTA main-draw singles at ten event families: the four Grand Slams, Indian Wells, Miami, Madrid, Rome, Canada and Cincinnati ([scope](docs/methodology-and-limitations.md#design)).
- **Admission.** A match enters only if the source reports a normal completion, the player identities and event context check out, and all needed serve and return counts are valid. Retirements, walkovers and invalid statistic bundles are excluded, never imputed. Coverage is "present in the source", not verified official tournament coverage.

| Split | Role | Admitted matches | Source |
| --- | --- | --- | --- |
| Development | Build and test candidate measures | 2,580 (ATP 2023: 846; WTA 2021 and 2023: 1,734); 2022 is missing | [Phase 2H audit](docs/source-defined-cohort-audit.md), [Elo baseline](docs/surface-elo-baseline-audit.md) |
| Validation | Compare prespecified models | 1,901 (ATP 944; WTA 957) | [2024 results](docs/2024-validation-results.md#implementation-and-coverage) |
| Locked final test | One frozen evaluation | 1,878 (ATP 1,011 in ten cells; WTA 867 in eight cells) | [2025 results](docs/2025-locked-final-evaluation-results.md#coverage-and-folds) |

The locked rules exclude all WTA Canada and Cincinnati 2025 matches because they do not permit repairs to the source event-context conflicts ([conflict review](docs/2025-source-conflict-review.md#wta-context-and-independent-exclusions)). The 2025 WTA result therefore covers eight of ten events.

### What the models use

**Net Point Rating** is the project's net-performance outcome: points won minus points lost, as a share of all points, times 100 ([definition](docs/methodology-and-limitations.md#features-and-models)). It is the explanatory outcome for factor design. The forecasts below predict match wins.

**S08** is the provisional factor set. The model pools each player's values from earlier matches only, then uses the difference between the two players ([pooling table](docs/2025-feature-elo-construction-audit.md#frozen-implementation)):

| Code | Plain meaning | Candidate family |
| --- | --- | --- |
| M03 | Share of first-serve points won when the first serve goes in | Serve creation |
| M05 | Double faults per second-serve opportunity (lower is better) | One part of second-serve security |
| M11 | Break points the player creates per opponent service game | Return pressure |
| M12 | Share of those break points the player converts | Conversion |

The evaluation tested two candidates: the **full** model with all four factors and a **reduced** model without M05 (three factors). Both use logistic regression with no intercept. Each refit occurs before a tournament batch and uses earlier matches only.

**Elo benchmark.** Every player starts at 1,500. After each tournament batch, the rating moves by 32 times the gap between the result and the expected result, with separate overall and surface ratings. The primary benchmark averages the two ratings; overall-only Elo is a sensitivity check. There are no bonuses for round or prestige ([Elo design](docs/surface-elo-baseline-audit.md)).

### Results

Lower log loss and Brier scores indicate better forecasts. Each difference subtracts primary surface Elo from the factor model; a positive value favors Elo.

| Split | Tour | Full − Elo (log loss / Brier) | Reduced − Elo (log loss / Brier) | Label |
| --- | --- | --- | --- | --- |
| 2025 locked test | ATP (951 matches) | +0.0225 / +0.0087 | +0.0220 / +0.0085 | Surface Elo lower loss, for both candidates |
| 2025 locked test | WTA (826 matches) | +0.0207 / +0.0078 | +0.0224 / +0.0086 | Surface Elo lower loss, for both candidates |
| 2024 validation | ATP (871 matches) | +0.0162 / +0.0069 | +0.0159 / +0.0067 | Selection unresolved |
| 2024 validation | WTA (912 matches) | +0.0282 / +0.0123 | +0.0288 / +0.0126 | Selection unresolved |

Calibration on 2025 was unresolved for both candidates: in ATP the factor models had a slope closer to 1 but an intercept farther from 0, and in WTA Elo was closer on both. Every method had a calibration slope above 1, meaning its forecasts were less extreme than the outcomes supported. In 2024, the full-versus-reduced comparison split by tour, so neither model was preferred. Sources: [2025 scores and calibration](docs/2025-locked-final-evaluation-results.md#scores-on-the-common-mask), [2024 scores](docs/2024-validation-results.md#paired-descriptive-scores).

### Limitations

- **Forecast chronology is approximate.** Matches are grouped by the source's tournament date, and real-world timing is not verified.
- **Uncertainty is not estimated.** Deletion checks show the direction is stable, but they are not confidence intervals.
- **Coverage is partial.** Development lacks 2022 and ATP 2021. The 2025 WTA cohort covers eight of ten events, and official tournament coverage is unknown.
- **M05 failed its direction test.** Its 2024 coefficients were mixed in sign (ATP 5 negative / 5 positive; WTA 9 / 1), so the requirement for a negative direction in every fold of both tours is not met. The all-negative 2025 signs do not reverse that ([2024 M05 signs](docs/2024-validation-results.md#selection-and-separate-interpretation)).
- **Factor weights are descriptive only.** Same-match shares of explained Net Point Rating now exist ([factor weights](docs/factor-weights-results.md#result)), but they are not forecast importance or causal effects and have no uncertainty intervals. Forecast-model coefficients are not factor weights.

The full list is in [methodology and limitations](docs/methodology-and-limitations.md#limitations).

### Not completed

The following parts of the original plan remain incomplete:

- Official ranking or ranking-points baseline
- Uncertainty intervals for factor weights (descriptive point shares exist; intervals are not established)
- Reliability curves
- Player factor profiles
- Interval estimates (confidence intervals or equivalent)
- Full-panel WTA coverage
- The Challenger promotion-readiness project
- Portfolio website integration

### Working-record exposure

Local contributor instructions and internal working records are excluded from
the current public snapshot. Earlier public commits remain available by design;
ignore rules and current-file removal do not erase that earlier exposure.

## Usage

### Repository layout

- `R/`: phase scripts, mostly paired with a test file. Generated outputs go to `data/pilot/`, which is not tracked.
- `docs/`: public phase reports, protocols and [methodology](docs/methodology-and-limitations.md).
- `data/manifests/`: source provenance and checksums. No match rows are tracked.

## License

### Data attribution and licensing

The [MIT license](LICENSE) covers repository code. Tennis data and derived outputs retain separate terms.

Match data: **Jeff Sackmann / Tennis Abstract** ([ATP](https://github.com/JeffSackmann/tennis_atp), [WTA](https://github.com/JeffSackmann/tennis_wta)), read from the [Aneeshers archival mirror](https://github.com/Aneeshers/tennis-sackmann-archive/tree/83733587353df8a41f2fd4f516147d5aa83f5a8d) at commit `83733587353df8a41f2fd4f516147d5aa83f5a8d`. The saved source documentation identifies [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/): credit the creator, noncommercial use only, share adaptations alike. The mirror adds no rights. This project uses the data for noncommercial educational research. Raw files and match-level outputs stay out of Git, and nothing here is a public player-statistics dataset. Publication of derived ratings or exports needs a separate rights review. Details and per-year manifests: [DATA_LICENSE.md](DATA_LICENSE.md) and [data/manifests/](data/manifests/).
