
# Tennis Analytics

## Project purpose

This repository contains the research, data preparation, statistical modeling, validation, documentation, and export code for Narayan Lekhi’s tennis analytics projects.

The flagship research question is:

> Can an interpretable Four Factors model capture tennis player strengths and produce better-calibrated match forecasts than surface-adjusted Elo?

A secondary project will study Challenger promotion readiness:

> Which Challenger-level performance factors predict future success on the ATP Tour?

Complete the flagship project first. Reuse its validated data and rating infrastructure for the Challenger project.

## Repository roles

This `tennis-analytics` repository is the primary workspace.

All tennis research work belongs here, including:

- Data-source documentation
- Data ingestion and validation
- Tournament and player standardization
- R functions
- Statistical models
- Tests
- Quarto analyses
- Figures and tables
- Website-ready data exports
- Methodology and project documentation

The `portfolio` repository is a secondary workspace used only for publishing completed work.

Do not modify the portfolio repository until:

1. The relevant analysis is complete.
2. The findings and limitations have been reviewed.
3. Website-ready outputs have been finalized.
4. The user explicitly requests website integration.

Before modifying the portfolio repository, read its root `AGENTS.md` completely and follow it. Instructions in the portfolio repository govern all website work.

## Research foundation

The main research reference is:

`tennis-analytics-public-data-research.pdf`

Read that report before making decisions about:

- Data sources
- Tournament coverage
- Licensing
- Four Factors definitions
- Surface Elo
- Forecast evaluation
- Challenger expansion
- Point-by-point or tracking data
- Website deliverables

The recommended initial dataset is the shared ATP and WTA ten-event panel from 2021 through 2025:

- Australian Open
- Roland-Garros
- Wimbledon
- US Open
- Indian Wells
- Miami
- Madrid
- Rome
- Canada, with Montreal and Toronto retained as edition cities under one event family
- Cincinnati

Use 2021-2023 for development, 2024 for validation and model selection, and 2025 as the locked final test season.

Do not inspect or optimize against final 2025 performance before the formulas, preprocessing rules, and model settings are frozen.

## Working preferences

Execute requested work directly. Do not hand the user commands to run when Codex can run them.

Use the simplest statistically valid approach first. Add complexity only when the simple version demonstrably fails or when the more complex version represents a planned comparison.

When making a non-obvious technical or statistical choice, explain the reason in one sentence. The user is learning, so explanations should be concrete without becoming tutorials.

Complete one coherent step at a time. Verify it before moving to the next step.

Commit every completed step without waiting to be asked. Commit messages must name the result, such as:

- `Document tennis data sources`
- `Add canonical tournament registry`
- `Validate 2021 ATP match coverage`
- `Implement chronological surface Elo`
- `Add Four Factors candidate metrics`

Never use vague commit messages such as `Update files`.

Preserve unrelated user changes. Inspect Git status before editing and before committing. Never discard, reset, overwrite, or delete existing work without explicit permission.

## Ask before

Ask the user before:

- Adding an R, Python, JavaScript, or system dependency
- Creating a substantially new directory structure
- Moving or renaming files or directories
- Changing the selected tournament panel
- Changing the development, validation, or test periods
- Replacing a documented statistical method
- Introducing Python into the main analysis
- Adding automated scheduled data collection
- Modifying the portfolio repository
- Deleting data, code, documentation, or outputs
- Publishing or deploying anything
- Making a licensing assumption that affects redistribution

Small files inside an already approved structure do not require a new question.

## R conventions

R is the default language for the flagship and Challenger projects.

The user is a beginner in R. Prefer:

- `tidyverse`
- `readr`
- `dplyr`
- `tidyr`
- `stringr`
- `lubridate`
- `purrr`
- `ggplot2`
- Base R statistical functions when practical

Do not introduce `data.table` or unfamiliar programming styles unless the tidyverse approach has a demonstrated limitation. Explain why another approach is required.

Use small named functions instead of placing the full analysis in one notebook.

Keep data cleaning, metric construction, modeling, evaluation, and export logic separate.

Potential later tools include `targets`, `renv`, `testthat`, `lme4`, `boot`, `relaimpo`, and `yardstick`. Do not install or initialize them without user approval.

Use Arrow or DuckDB only if ordinary R workflows cannot handle the point-level data efficiently.

Use Python only for a separate computer-vision or tracking project, unless a specific technical limitation requires it and the user approves.

## Data governance

Use only free data that permits the intended research use.

Free access does not automatically permit copying, redistribution, publication, or derivative products.

For every data source, record:

- Source name
- Direct URL
- Access date
- Repository commit, release, or version
- File name
- File size
- SHA-256 checksum
- License or terms URL
- Permitted research use
- Redistribution restrictions
- Transformations applied
- Known coverage limitations

Keep raw data out of Git unless its license explicitly permits redistribution and committing it serves a documented purpose.

Prefer reproducible download or import instructions over committed raw files.

Do not trust a mirror’s declared license when the data originated elsewhere. Trace licensing obligations to the original source where possible.

Do not use TennisData.app without written permission because its download language and formal terms conflict.

Treat tennis-data.co.uk as a local benchmark source unless permission for public derivative use is established.

The archived Jeff Sackmann data is subject to its applicable attribution and noncommercial share-alike requirements. Pin the exact archive commit and preserve checksums.

IBM’s public Wimbledon repository uses Apache 2.0, but record the exact source and notices for every file used.

Do not redistribute Live Tennis API academic raw data. Follow its academic-access and citation requirements if that source is used.

## Research integrity

Never invent:

- Data coverage
- Tournament classifications
- Player identities
- Match statistics
- Model results
- Factor weights
- Forecast performance
- Project findings
- Licensing permissions

Use visible markers such as `TODO_USER_DECISION` when information requires a decision from the user.

Distinguish:

- What a source states
- What the local audit verifies
- What the analysis estimates
- What remains unknown

Report negative, unstable, and partial findings.

Do not force the data to produce four meaningful factors. Four is the design hypothesis. If the evidence does not support four stable dimensions, report that result and explain the consequences.

Do not claim that Four Factors beat Elo unless they improve the locked out-of-sample evaluation under the prespecified metrics.

## Canonical data design

Raw source files must remain unchanged.

Build standardized tables for:

- Events
- Players
- Matches
- Match statistics
- Pre-match ratings
- Predictions
- Source provenance

Use stable internal identifiers.

Do not join players only by normalized name after identity linkage is established. Preserve every source identifier and source spelling.

Create an outcome-neutral match orientation using `player_a` and `player_b`. Do not construct predictive features from winner and loser columns after orienting a row by its result.

Maintain both the original tournament label and the canonical tournament identity.

A tournament record should distinguish:

- Tour
- Season
- Event family
- Edition city
- Country
- Start date
- Surface
- Official level
- Draw size
- Source tournament ID

Use official season calendars to establish tournament levels. Do not infer ATP 250 versus ATP 500 or WTA categories from draw size alone.

Treat Montreal and Toronto as edition cities within the Canada event family.

## Data validation

Before modeling, test:

- Required columns
- Column types
- Unique match identifiers
- Unique event editions
- Player identity linkage
- Valid dates and chronological order
- Valid surfaces and rounds
- Nonnegative statistical counts
- Numerators that do not exceed denominators
- Reconciliation of both players’ point totals where possible
- Duplicate matches
- Walkovers
- Retirements
- Incomplete matches
- Missing-statistics rates by tour, event, season, and field
- Unexpected changes in source coverage
- Tournament-panel membership
- Stable train, validation, and test assignments

Never convert an unavailable statistic to zero.

Publish a field-availability matrix by source, tour, event, and season before selecting factor definitions.

Stop the modeling phase if the required data fails the agreed coverage threshold.

## Net tennis outcomes

The primary explanatory outcome is Net Point Rating:

`100 * (points_won - points_lost) / total_points`

This is equivalent to:

`200 * point_win_percentage - 100`

Also test the equal-phase sensitivity outcome:

`100 * (service_point_win_percentage + return_point_win_percentage - 1)`

Net Point Rating explains point dominance. Match win is the separate forecasting outcome.

Do not choose between these outcomes based only on which produces more favorable final results.

## Candidate Four Factors

Treat these as candidate factor families rather than predetermined finished formulas.

### 1. Serve Creation

Candidate ingredients include:

- Ace rate
- First-serve-in rate
- First-serve points won
- Unreturned serve rate when point data supports it

### 2. Second-Serve Security

Candidate ingredients include:

- Second-serve points won
- Double-fault rate
- Performance after missing the first serve

### 3. Return Pressure

Candidate ingredients include:

- First-serve return points won
- Second-serve return points won
- Break chances created per return game
- Opponent-adjusted return performance

### 4. Conversion and Recovery

Candidate ingredients include:

- Break-point conversion above expectation
- Break-point saving above expectation
- Performance on high-leverage points after controlling for ordinary point strength

Raw break-point percentage is noisy and must not automatically be labeled clutch performance.

Compare reasonable definitions within each family using development and validation data. Freeze the final definitions before evaluating 2025.

## Factor weighting

Begin with an interpretable multiple linear regression relating candidate factor families to Net Point Rating.

Do not convert raw regression coefficients directly into published weights when predictors use different units or share explained variance.

The weighting workflow should include:

1. Standardizing predictors within the relevant tour and surface context
2. Opponent and schedule adjustment
3. Surface and season adjustment
4. Sample-size shrinkage
5. Player-clustered uncertainty
6. Correlated-predictor importance through LMG, Shapley, or dominance analysis
7. Player-level bootstrap intervals
8. Stability analysis across ATP, WTA, and surfaces

Publish weights as estimated shares of explained variation with uncertainty.

If the factor ordering changes materially across tours or surfaces, report separate weights instead of forcing one universal system.

## Elo benchmark

Implement Elo chronologically and transparently.

Start with:

1. Overall Elo
2. Surface-specific Elo
3. Surface-adjusted Elo that combines overall and surface ratings with documented shrinkage

Document:

- Initial rating
- K-factor
- Surface update rules
- Inactivity treatment
- Retirement treatment
- Walkover treatment
- Best-of-three versus best-of-five treatment
- Any margin-of-victory adjustment

Do not add a margin-of-victory adjustment unless it is a planned and validated comparison.

Every prediction must use ratings calculated before the match.

## Forecast comparison

Compare at minimum:

- Official ranking or ranking-points baseline
- Overall Elo
- Surface-adjusted Elo
- Four Factors
- Surface Elo plus Four Factors

Use:

- Brier score
- Log loss
- Calibration intercept
- Calibration slope
- Reliability curves

Use accuracy and ROC AUC as secondary measures.

Evaluate ATP and WTA separately.

Evaluate hard, clay, and grass separately where sample size permits.

Quantify uncertainty with an appropriate tournament-level, week-level, or player-aware resampling method.

A model that improves calibration without improving accuracy can still provide a meaningful result.

A Four Factors model that matches Elo’s prediction performance while providing clearer player explanations can still provide a meaningful result.

## Leakage prevention

Every predictive feature must reflect information available before the match being predicted.

Required safeguards include:

- Chronological processing
- Lagged rolling statistics
- Ratings updated only after predictions are recorded
- Frozen final test data
- Outcome-neutral player orientation
- Player-slot swap tests
- No use of final-season rankings as earlier features
- No tuning against 2025 results
- Explicit retirement and walkover rules
- Tests that fail when future information enters a feature

Treat leakage prevention as part of the model, not as a final cleanup step.

## Challenger promotion-readiness project

Begin this project only after the main Four Factors and Elo infrastructure is validated.

Reuse the shared player identities, event registry, match tables, ratings, validation rules, and evaluation functions.

The initial recommended outcome is whether a player reaches the ATP top 100 within 12 months of an eligible Challenger evaluation date.

Alternative outcomes may be tested, but they must be defined before model evaluation.

Candidate predictors include:

- Challenger Elo
- Surface-adjusted Elo
- Four Factors ratings
- Strength of schedule
- Surface versatility
- Recent improvement
- Age
- Match volume
- Performance against top-200 opponents

Construct player timelines chronologically. Do not allow later ATP performance to enter earlier Challenger features.

Account for players whose complete 12-month outcome window has not elapsed.

The Challenger model should first compare itself with simple baselines such as ranking, age plus ranking, and Challenger Elo.

## Reproducibility

The finished project should be reproducible from documented source acquisition through final tables, figures, and website exports.

Use deterministic seeds for resampling and modeling where randomness is involved.

Record package versions.

Keep generated outputs separate from hand-written source code.

Do not manually edit generated tables, figures, or website JSON.

Every published number should trace back to a reproducible pipeline stage.

Tests should cover important data contracts, metric denominators, chronological rating updates, player-slot symmetry, and train-test isolation.

## Expected flagship outputs

The Four Factors versus surface-Elo project should eventually produce:

- A validated canonical match dataset
- A documented tournament registry
- A data-coverage report
- Overall and surface-adjusted Elo ratings
- Four Factors player ratings
- ATP and WTA factor weights with uncertainty
- Surface-specific comparisons
- Pre-match probability files
- Forecast evaluation tables
- Calibration plots
- Player factor profiles
- A reproducible Quarto research report
- Website-ready versioned JSON
- Static SVG figures
- A complete methodology and limitations section

The portfolio integration should eventually include:

- A dedicated project page
- An explanation of Net Point Rating
- A Four Factors weight visualization
- ATP and WTA comparisons
- Surface comparisons
- Elo versus Four Factors evaluation
- Calibration results
- Interactive player comparison
- Selected player profiles
- A GitHub repository link

Do not build the website presentation before the research outputs exist.

## Expected Challenger outputs

The Challenger project should eventually produce:

- A documented promotion definition
- Player-month development histories
- Challenger Elo
- Challenger Four Factors profiles
- Promotion-readiness probabilities
- Historical validation
- Calibration results
- Feature-effect summaries
- False-positive and false-negative case studies
- A prospect leaderboard
- Player development trajectories
- Website-ready JSON
- A separate portfolio project page or a clearly separated project extension

## Documentation

Keep the README accurate as the project evolves.

Document decisions when they become settled, including:

- Data scope
- Tournament panel
- Outcome definitions
- Factor formulas
- Elo parameters
- Missing-data rules
- Retirement rules
- Validation periods
- Final model versions

A decision and an implementation are separate events. Documentation must state which one has occurred.

When a change makes an earlier statement false, search for and update every related statement.

At the end of a meaningful work session, leave a concise status document that tells the next reader:

- What is complete
- What was verified
- What remains incomplete
- What is blocked
- What decision is needed next

Do not claim external data, licensing, deployment, or website states were verified unless they were checked directly.

## Writing standards

Write clearly and directly.

- Start with the research question or result.
- Use active voice.
- Avoid inflated claims.
- Avoid vague statements about what “the data shows.”
- Name the sample, period, model, and evaluation split.
- State uncertainty and limitations beside the relevant finding.
- Do not hide methodological problems to create a cleaner story.
- Do not invent explanatory copy that should come from the user.
- Use a visible `TODO_USER_COPY` marker when personal interpretation or narrative is required.

## Definition of done

A step is complete only when:

- The requested files exist.
- Relevant checks pass.
- Outputs were inspected.
- Documentation matches the current state.
- Git status contains no accidental files.
- The completed step has a clear commit.
- Remaining limitations are reported.

