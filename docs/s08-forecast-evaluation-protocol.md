# Phase 2Q: S08 forecasting and paired evaluation protocol

Version 1.0.0. Specification only, from clean `main` at `8caaa5600949867a47b43d7ca122c9b4749e0596`. No model, score or generated output is created. This protocol recommends one model under **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**. **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** remains in force. S02 stays paused; S08 provisional.

## Authority and frozen inputs

Use [Phase 2N histories](s08-batched-history-aggregation.md), [Phase 2P probabilities](surface-elo-baseline-audit.md), the [batch convention](source-label-event-batching-decision.md), and the [Four Factors protocol](four-factors-definition-protocol.md). Preserve all 2,580 Phase 2H targets, identities, neutral slots, exclusions, historical releases and pins. These are eligible source records, not complete tournaments or independently verified historical availability.

The fixed Elo comparator is Phase 2P's 1500 priors, scale 400, K=32 and `R=0.5G+0.5S`; overall-only G is its sole sensitivity. Use the existing frozen probabilities, without refitting, recalibration or restricted-cohort replay. All admitted matches can update later histories/Elo, including matches without a complete S08 vector. No extra comparator or parameter search is introduced.

A later implementation must verify provenance, literal input hashes, unique IDs and exact metadata/slot joins before fitting. Join the neutral A-win label from the frozen admitted result orientation only; Phase 2N features and Phase 2P probability exports contain no outcomes. Pin the new authority separately; do not rerun historical runners against changed PROJECT_CONTEXT.md or repin their suites.

## One parsimonious model

Fit separate unpenalized ATP and WTA binomial logistic regressions with an intercept. For match i, `y_i=1` when the frozen neutral player A won and 0 otherwise. Predictors, in fixed order, are `dM03`, `dM05`, `dM11`, `dM12`, the saved A-minus-B histories. For each training fold, use `z_ij=(dM_j-mean_train_j)/sd_train_j`, with sample SD (n−1 denominator). Then `eta_i=beta_0+sum_j(beta_j*z_ij)` and `p_A=plogis(eta_i)`. Freeze those training means, SDs and coefficients for the entire target batch.

Keep the Phase 2N pooled-count formulas: M03 own first-serve points won / first serves in; M05 own double faults / second-serve opportunities; M11 opponent break points faced / opponent service games; M12 opponent break points converted / faced. M05 remains lower-is-better without reversing its saved difference or imposing a coefficient sign. M12 is conversion/execution, not established resilience or clutch performance. Empty histories and zero-opportunity rates stay undefined. Never recompute a training row's history using information available only at the later fitting cutoff.

Include no interactions, surface/event indicators, nonlinear terms, sign constraints, Elo feature, imputation or history-window choice. Coefficients are forecast parameters, not Dean Oliver importance weights, variance shares or final factor qualifications. Report coefficient signs without selecting a preferred sign after fitting.

Preserve neutral IDs rather than orienting winners into slot A. Because the requested intercept is free, swapping only a target's slots under a fixed fitted model need not complement its probability: this is an explicit orientation limitation. Test global relabeling of both training and target slots, reversing outcomes and differences together, which must complement predictions and preserve paired losses. Do not duplicate matches, suppress the intercept or silently symmetrize predictions. A later change to this convention requires approval.

## Whole-batch folds and fixed readiness

Within each tour, sort distinct source labels and form `(tour, source tourney_date)` batches. Same-date events are simultaneous, even across surfaces. For every target batch, use all complete-feature admitted training matches from strictly earlier batches; never target-batch or later outcomes, means, SDs or diagnostics. Fit once, then predict every complete target in that batch with that fit. Incomplete targets remain explicit nonpredictions. After the entire batch, its eligible rows may join subsequent training sets. A row whose own forecast failed can still enter later training if its saved feature vector is complete.

The following fixed gates are conventions chosen before fitting, not performance-supported optima:

1. At least **five prior contributing batches**: each counted batch contains at least one complete training match. Empty-feature batches do not count.
2. At least **100 complete training matches** and **25 outcomes in each A-win class**.
3. All four predictors finite and nonconstant; finite positive training SDs; intercept-plus-predictor design rank five using base R QR tolerance `1e-7`.
4. Apply the registered training-design collinearity diagnostics without changing thresholds: absolute correlation 0.80/0.90 warnings, 0.95 near-redundancy, VIF 5 concern / 10 unacceptable, condition index 30 failure review. For this automatic walk-forward runner, any absolute correlation >=0.95, VIF >=5 or condition index >=30 withholds the fold pending review. Lower warning bands are disclosed, not used to remove features. Record Pearson and Spearman and the strongest applicable disposition. These are conservative forecast-readiness rules, not retrospective changes to Phase 2J.
5. One base-R `glm(..., family=binomial(link="logit"))` attempt with `epsilon=1e-8`, `maxit=25`; require convergence, full fitted rank, finite coefficients/linear predictors, no boundary flag, no fitting warning, and no detected separation.

Use the saved diagnostic approach prospectively: record warnings, convergence, boundary/extreme probabilities, and signed-linear-predictor separation witnesses. For finite fitted eta, let `m_i=(2*y_i-1)*eta_i`. If all margins are >= `-1e-8` and at least one is > `1e-8`, flag a complete/quasi separation indication and fail the fold; report the tolerance as numerical, not a practical-effect threshold. Also fail training fits with any fitted probability <= `1e-8` or >= `1-1e-8` as `EXTREME_TRAINING_PROBABILITY`, without claiming that extremes alone prove separation. Diagnostic errors or unavailable checks fail closed. Test complete and quasi-separated fixtures. A passing status means **NO_SEPARATION_DETECTED_BY_REGISTERED_DIAGNOSTICS**, not a mathematical certificate that separation is absent; finite convergence alone is insufficient. No general separation solver or new dependency is assumed to exist.

Every failed fold emits no S08 prediction for any of its targets. Keep all applicable evaluated reasons in fixed gate order, and mark downstream checks `NOT_RUN` when an earlier gate blocks fitting. Distinguish insufficient batches, matches, class counts, predictor validity, rank, collinearity review, nonconvergence, fitting warnings, nonfinite fit, boundary, extreme probabilities and separation indication. Target-level missing-feature reasons are separate and may overlap a fold failure. A valid fit with a nonfinite target predictor/linear predictor/probability withholds that target and records the numeric failure; it cannot silently delete the target or contaminate another fold. No ridge, Firth, feature removal, coefficient clipping, iteration escalation or other rescue is authorized.

## Saved feasibility, not a fitted result

Read-only verification of the pinned Phase 2N feature file (`b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00`) confirms the following. No outcomes were loaded for these counts.

| Tour | All targets | Complete vectors | Batches total | Folds possibly passing batch/count gates | Complete targets in those folds |
| --- | ---: | ---: | ---: | ---: | ---: |
| ATP | 846 | 612 | 10 | 4 | 211 |
| WTA | 1,734 | 1,414 | 20 | 14 | 1,067 |
| Total | 2,580 | 2,026 | 30 | 18 | 1,278 |

The first possible ATP batch is source label 20230703, with 401 complete training rows in five contributing batches; WTA is 20210809, with 347 in five. The 18 possible folds contain 1,426 total targets, including 148 incomplete vectors. Across all targets, 748 complete vectors are before this structural readiness point, and 554 are incomplete. These are pre-fit upper bounds: class balance, collinearity, separation, convergence and actual score availability remain unverified. Do not weaken readiness if any tour loses additional folds or all folds. ATP has only four possible scored batches, no independent season comparison and limited uncertainty/calibration support. Missing 2022 and unequal ATP/WTA history depth persist.

## Identical paired cohort and scoring

Keep a coverage ledger with exactly one row per each of the 2,580 targets. Preserve both/one/neither complete-history strata **2,026/284/270** (ATP 612/103/131; WTA 1,414/181/139). Report target completeness, fold readiness, probability validity and every applicable nonprediction reason separately. Coverage uses all-target and complete-vector denominators; reason totals may overlap. Source-record prediction availability is not official event coverage.

Use one shared paired mask per tour: complete S08 vector, passing training fold, finite S08 linear predictor/probability and finite frozen probabilities for **both** primary Elo and overall-only Elo, with valid probabilities in [0,1] and a verified binary outcome. Score the three methods on exactly the same IDs and cutoffs. A missing comparator is an audit failure, never permission to use differing comparison cohorts. Preserve zero-scored batches/slices explicitly. Do not score all-target Elo for a comparison with common-only S08, or call the smaller paired set the full 2,026 feature cohort.

Primary metrics are per-match natural-log loss and Brier score `(p-y)^2`. Calculate logistic log loss stably from finite eta as `max(eta,0)-y*eta+log1p(exp(-abs(eta)))`; use stable log/log1p for frozen interior Elo probabilities. Do not clip probabilities. Unexpected exact Elo boundaries receive the mathematically defined loss (including infinity for a wrong certain prediction) and an explicit warning, not fabricated finite loss. Rounded S08 probabilities retain their finite eta for stable loss. Report nonfinite scores, not a silently reduced score sample.

For each Elo comparator define paired differences **S08 minus Elo**: negative favors S08. Report match-weighted means of each primary score and paired difference separately by tour, season, event and surface, alongside batch-level results, total/paired counts and failure reasons. Do not pool tours to conceal failure or choose whichever primary loss looks favorable. No practical-improvement margin or model selection is introduced.

Secondary accuracy uses a fixed 0.5 threshold, with half-credit for an exact tie to avoid a slot preference. AUC is deferred in this smallest implementation; it is not an extra selection criterion. Calibration uses the same paired IDs and joint logistic `y ~ logit(p)` per method, only with >=100 evaluation matches, >=25 outcomes each class, >=5 distinct scored batches, finite nonconstant logits, full rank and the same convergence/separation safeguards. Otherwise report `CALIBRATION_NOT_ASSESSABLE` with reasons. Do not drop boundary probabilities to make calibration pass. Report intercept/slope as descriptive diagnostics without IID standard errors or intervals, never apply them as a recalibration to the forecasts being evaluated. ATP cannot meet the five-scored-batch calibration gate on the saved design.

## Dependence, stability and limits on inference

**UNCERTAINTY_NOT_ESTABLISHED.** Saved evidence has not established a defensible interval method accounting jointly for whole simultaneous batches/events and recurring players in either slot. No IID intervals/p-values, match bootstrap, event-only intervals or player-A-only clusters are permitted. A future interval proposal must preserve pairs and chronological cutoffs, represent both opponents across events, justify cluster sufficiency and validate synthetic dependence cases before approval.

For this bounded development comparison, the explicit Phase 2Q instruction permits descriptive point estimates with uncertainty pending. This is a narrow exception to the older Four Factors protocol's requirement to settle uncertainty before fitting, not a relaxation of its final factor/weight or locked-evidence gates. There is no inference of superiority, final factor qualification or uncertainty-supported improvement.

Define two deletion diagnostics on the frozen paired out-of-batch prediction ledger, separately per tour and comparator:

- Leave one whole batch out: delete all its scored matches, recompute paired score differences, and report retained sample, changes and sign reversals. Never split simultaneous events.
- Leave one player out: for every represented player, delete every scored match containing that ID in either slot, across every batch. Recompute the same differences; report deleted/retained counts, changes and sign reversals.

Keep paired IDs identical for all three models within each deletion. Zero retained samples remain undefined with reasons. Report the range and individual failures, not a confidence interval. These are **score-influence stability diagnostics conditional on frozen predictions**, not training refits, unseen-player tests or a substitute for dependence-aware inference. Do not alter frozen histories/Elo or claim that deleting evaluation rows removes a player's earlier training influence. Report match, unique-player and batch/event counts for each reported estimate; no magnitude threshold is selected after seeing results.

Unknown actual timing, event overlap and historical availability remain; earlier source labels are an assumption. Retrospective source inclusion/admission, unequal coverage and short ATP history limit generalization. Preserve 2021–2023 development, 2024 validation/model selection and locked 2025. Any later preprocessing, tuning or approved model choice belongs inside chronological training folds; this fixed protocol performs no tuning. No 2024/2025 access or deployable forecasting claim follows.

## Next executable phase and approval

Recommend **Phase 2R: implement the fixed S08 walk-forward runner and paired descriptive evaluation offline in base R**. Freeze input pins and readiness before fitting. Validate training-only scaling/labels, same-date cutoffs, frozen row histories, failure precedence, separated/constant/rank-deficient fixtures, global slot relabeling, stable losses, exact paired masks, both-slot player deletion, full coverage, deterministic reruns and historical preservation. If no fold passes, deliver measured failures and zero scored coverage rather than rescue the model. A next prompt must specify exact tracked files and ignored output scope before execution.

Exact approval language: **“Approve Phase 2R: implement the fixed Phase 2Q S08 model, whole-batch walk-forward readiness gates and paired descriptive evaluation offline in base R on the frozen 2,580 targets. Fit only earlier-batch complete training rows, apply training-only scaling, withhold failed folds without rescue, and compare S08 with both frozen Phase 2P Elo probabilities on identical eligible IDs. Report all-target coverage, primary losses, supported calibration, secondary accuracy and batch/player score-deletion stability; retain UNCERTAINTY_NOT_ESTABLISHED. Preserve source-label sensitivity labeling and historical releases. Do not tune, impute, add dependencies, acquire data, infer timestamps, access 2024/2025 or modify the portfolio.”**

Phase 2Q authorizes this specification only. It creates no code, model, score, dependency or generated output. Completed reports retain their historical recommendations and authority fingerprints. Implementation, performance and separation diagnostic adequacy are not claimed verified here.

## Validation record

Focused checks passed for agreement across the four current documents, **17 local links/anchors**, whitespace, exact four-file scope, and unchanged historical status/contract content (apart from the contract current/completed label). The pinned Phase 2N features and Phase 2P probability files retain their SHA-256 hashes and exactly matching 2,580 unique IDs. Independent checks of slot/vector completeness and batch/count readiness reproduce the counts above without loading outcomes, fitting or scoring.

All **288 other pre-existing tracked files and pilot artifacts retain their SHA-256 hashes**; no pilot output was created or changed. The full four-file diff was inspected. No historical empirical suite was rerun or repinned. A wording assertion initially treated “Log loss” versus “log loss” as different; correcting that case-sensitive documentation check required no protocol change. No research computation failed, because no model or score was computed. Statistical readiness, diagnostic performance and forecast performance remain unverified until the separately approved implementation.
