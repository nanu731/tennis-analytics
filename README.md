# Tennis Analytics

Can a few interpretable tennis statistics predict match winners as well as
surface-adjusted Elo? This R project tests a tennis version of basketball's
Four Factors using ATP and WTA match data.

**The 2025 test favored surface Elo on forecast loss.** Both the four-factor model
and a three-factor version had higher log loss and Brier scores in both tours.
Neither factor model showed a consistent calibration advantage. The study did
not estimate confidence intervals or p-values, so it does not establish a
statistically significant advantage for Elo.

## Start here

- Read the [descriptive point-phase study](docs/modern-point-phase-profiles.md)
  and [local viewer notes](docs/modern-point-phase-viewer.md) for the newer Match
  Charting Project work. Recorded actions and point endings do not establish
  player rankings, causal skills or forecasting gains.
- Read the [2025 results](docs/2025-locked-final-evaluation-results.md#result) for
  the main finding and its limits.
- Read [methodology and limitations](docs/methodology-and-limitations.md) for the
  study design, model definitions and evaluation rules.
- Compare the [2024 validation results](docs/2024-validation-results.md) to see
  why the study did not select either factor model before the final test.
- Start with [source provenance](data/manifests/) and the
  [data license](DATA_LICENSE.md) if you want to work with the data.

This repository documents the match-forecasting study. Its results do not assess
whether the factors explain player performance or provide useful player profiles.
The Four Factors framework remains provisional.

The separate descriptive study parses recorded Match Charting Project actions
and builds point-phase profiles and a local HTML viewer. Its raw inputs and
generated player/point-level exports remain outside Git. The viewer requires
those exact local exports; its source includes data checks, while actual browser
and assistive-technology verification remains incomplete. Read its notes for the
recorded font and input prerequisites.

This reviewed release consolidates the earlier local MCP code and research
records. Historical commit IDs in those records describe the original local
workflow; this release does not publish that full working history or its private
correspondence draft. Scientific source files and frozen specification hashes
retain their recorded values.

## What's included

| Location | Contents |
| --- | --- |
| `R/` | Data acquisition, audits, feature construction, Elo, model fitting and tests. |
| `docs/` | Research protocols, results and methodological limitations. |
| `data/manifests/` | Source versions and checksums. |

Raw match files and generated match-level outputs are not included. Scripts write
analysis outputs under `data/pilot/`, outside version control.

The study covers ATP and WTA main-draw singles at ten event families: the four
Grand Slams, Indian Wells, Miami, Madrid, Rome, Canada and Cincinnati. It accepts
source-reported normal completions with verified player identities, event context
and valid serve/return counts. It excludes retirements, walkovers and invalid
statistics without filling in missing values. Coverage means records present in
the source, not verified completeness against official tournament records.

| Split | Role | Admitted matches | Source |
| --- | --- | --- | --- |
| Development | Build and test candidate measures | 2,580 (ATP 2023: 846; WTA 2021 and 2023: 1,734); 2022 is missing | [Phase 2H audit](docs/source-defined-cohort-audit.md), [Elo baseline](docs/surface-elo-baseline-audit.md) |
| Validation | Compare prespecified models | 1,901 (ATP 944; WTA 957) | [2024 results](docs/2024-validation-results.md#implementation-and-coverage) |
| Locked final test | One frozen evaluation | 1,878 (ATP 1,011 in ten cells; WTA 867 in eight cells) | [2025 results](docs/2025-locked-final-evaluation-results.md#coverage-and-folds) |

WTA Canada and Cincinnati 2025 are excluded because their source event context
conflicts with the fixed inclusion rules. The WTA final test therefore covers
eight of the ten event families; see the
[conflict review](docs/2025-source-conflict-review.md#wta-context-and-independent-exclusions).

## Getting started

You can read the reports without installing anything. To inspect or run the
analysis, clone the repository and work from its root:

```sh
git clone https://github.com/nanu731/tennis-analytics.git
cd tennis-analytics
```

The original acquisition script uses base R and a system SHA-256 utility
(`shasum` or `sha256sum`). It downloads the pinned 2023 ATP and WTA source files:

```sh
Rscript --vanilla R/download_pilot_data.R
```

Read the [acquisition audit](docs/pilot-acquisition-audit.md) before using those
files. This command starts the original data pilot; it does not recreate the
whole study.

For the modeling code, follow these entry points:

| Stage | Script | Documentation |
| --- | --- | --- |
| Surface Elo | `R/build_surface_elo_baseline.R` | [Baseline design and audit](docs/surface-elo-baseline-audit.md) |
| Validation | `R/run_2024_validation.R` | [2024 results](docs/2024-validation-results.md) |
| Final evaluation | `R/run_2025_locked_evaluation.R` | [2025 protocol](docs/2025-locked-final-test-protocol.md) |

The later stages require exact upstream files and intermediate outputs, checked
by their recorded hashes. Those inputs are not all included in a fresh clone.
The final-evaluation tests also validate those inputs, including in their
synthetic-data mode. Use the phase reports to identify prerequisites before
running a stage; there is no single command that reproduces the complete study
from the checked-in files alone.
Some historical scripts also check documentation hashes, so reproducing those
runs requires the matching historical revision as well as the data.

## Methods and limitations

### Models

Net Point Rating measures point dominance:
`100 * (points won - points lost) / total points`. It guides the factor design;
the forecasting outcome is a match win.

The provisional factor set, S08, uses these measures:

| Code | Plain meaning | Candidate family |
| --- | --- | --- |
| M03 | Share of first-serve points won when the first serve goes in | Serve creation |
| M05 | Double faults per second-serve opportunity (lower is better) | One part of second-serve security |
| M11 | Break points the player creates per opponent service game | Return pressure |
| M12 | Share of those break points the player converts | Conversion |

Each player's measures pool earlier matches only. The forecast model uses the
difference between the two players. The full model uses all four factors; the
reduced model leaves out M05. Both use logistic regression without an intercept
and refit before each tournament batch using earlier matches.

Elo starts each player at 1,500 and updates ratings by 32 times the difference
between the result and expected result after each batch. The primary benchmark
averages overall and surface-specific ratings. Overall-only Elo is a sensitivity
check, with no round or prestige bonuses.

### Results

Lower log loss and Brier scores indicate better forecasts. The differences below
subtract surface Elo from each factor model, so positive values favor Elo.
Counts here are matches scored by all methods, rather than all admitted matches.

| Split | Tour | Full − Elo (log loss / Brier) | Reduced − Elo (log loss / Brier) | Label |
| --- | --- | --- | --- | --- |
| 2025 locked test | ATP (951 matches) | +0.0225 / +0.0087 | +0.0220 / +0.0085 | Surface Elo lower loss, for both candidates |
| 2025 locked test | WTA (826 matches) | +0.0207 / +0.0078 | +0.0224 / +0.0086 | Surface Elo lower loss, for both candidates |
| 2024 validation | ATP (871 matches) | +0.0162 / +0.0069 | +0.0159 / +0.0067 | Selection unresolved |
| 2024 validation | WTA (912 matches) | +0.0282 / +0.0123 | +0.0288 / +0.0126 | Selection unresolved |

Removing any single tournament batch from the 2025 scoring comparison left the
loss direction unchanged. Calibration was less clear: ATP factor models had
slopes closer to 1 but intercepts farther from 0; WTA Elo was closer on both.
Every method had a slope above 1, indicating predictions less extreme than the
outcomes supported. The 2024 full-versus-reduced comparison split by tour, so
neither candidate was preferred. See the
[2025 scores and calibration](docs/2025-locked-final-evaluation-results.md#scores-on-the-common-mask)
and [2024 scores](docs/2024-validation-results.md#paired-descriptive-scores).

### What the results cannot establish

- **Exact forecast timing:** source tournament dates define batches; actual
  match timing is unverified.
- **Statistical superiority:** deletion checks show sensitivity to individual
  batches, but they are not confidence intervals.
- **Complete coverage:** development lacks 2022 and ATP 2021. The 2025 WTA test
  covers eight events, and official tournament completeness is unknown.
- **A stable double-fault effect:** M05's 2024 coefficients were negative in
  5 ATP fits and positive in 5; WTA had 9 negative and 1 positive. That failed
  the requirement for a negative direction in every fold of both tours.
  All-negative 2025 coefficients do not reverse the failed validation result.
- **Causal or predictive importance weights:** the
  [factor-weight analysis](docs/factor-weights-results.md#result) describes shares
  of explained same-match Net Point Rating. These shares have no uncertainty
  intervals, and forecast coefficients are not factor weights.

The original plan still lacks a ranking baseline, reliability curves, player
factor profiles, interval estimates, full-panel WTA coverage, the Challenger
promotion-readiness model and website integration for this forecasting study.
The [full limitations](docs/methodology-and-limitations.md#limitations) give more detail.

## Data and license

The [MIT license](LICENSE) covers repository code. Tennis data and derived outputs retain separate terms.

Match data: **Jeff Sackmann / Tennis Abstract** ([ATP](https://github.com/JeffSackmann/tennis_atp), [WTA](https://github.com/JeffSackmann/tennis_wta)), read from the [Aneeshers archival mirror](https://github.com/Aneeshers/tennis-sackmann-archive/tree/83733587353df8a41f2fd4f516147d5aa83f5a8d) at commit `83733587353df8a41f2fd4f516147d5aa83f5a8d`. The saved source documentation identifies [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/): credit the creator, noncommercial use only, share adaptations alike. The mirror adds no rights. This project uses the data for noncommercial educational research. Raw files and match-level outputs stay out of Git, and nothing here is a public player-statistics dataset. Publication of derived ratings or exports needs a separate rights review. Details and per-year manifests: [DATA_LICENSE.md](DATA_LICENSE.md) and [data/manifests/](data/manifests/).
