# Tennis Analytics Project Context

**Adopted standing research guidance, 2026-09-21.** The Phase 1L prompt explicitly approved the context at commit `bded8069163d41c886cf1576ea0fdd4cc1054b7b`. This file records stable purpose and approved research-design decisions; it does not replace AGENTS.md, current status or the data-source contract. Approval of a design is separate from its later implementation. No canonical analytical population or model is created by this adoption.

## Central question

The flagship project asks:

> Can an interpretable Four Factors model capture tennis player strengths and produce better-calibrated match forecasts than surface-adjusted Elo?

The goal is to identify four interpretable tennis metrics that capture distinct ways a player creates an advantage, estimate how much each contributes to success, and test whether those metrics improve future match forecasts. The project follows the essence of Dean Oliver's basketball Four Factors: define a net-performance outcome, identify a small set of meaningful components, estimate their relative importance together, and validate the result outside the data used to create it.

The project does not need Four Factors to beat Elo on every metric to succeed. A stable, well-calibrated model that adds useful interpretation can still produce a meaningful result. If the evidence does not support four distinct and stable factors, report that finding instead of forcing the framework.

The Challenger promotion-readiness project remains secondary. Begin it only after the flagship data, identity, rating, and evaluation infrastructure has passed validation.

## Research approach

Codex should do more than complete assigned implementation steps. During model development, it should examine whether each statistical choice answers the research question, expose weak assumptions, test plausible alternatives, and revise mistakes.

Being wrong during development is acceptable. Concealing a failed idea, keeping a weak specification for convenience, or selecting only favorable results is not. Record each material revision, why the earlier version failed, what changed, and whether the change improved chronological validation or interpretation.

Iteration must stay inside the evaluation design. Develop candidate measures and models with 2021–2023, compare prespecified choices with 2024, and freeze the full pipeline before viewing 2025 outcomes. A coding defect discovered after freezing should be fixed and disclosed. Do not use the locked test results to redesign the model and then present the same test as untouched evidence.

## Occam’s razor

> Start with the simplest method that can answer the research question. Add a feature, rule, adjustment, data source, or model component only when it fixes a demonstrated problem or earns a stable out-of-time improvement. Remove complexity that does not earn its place.

**Adopted in Phase 2G.** Apply this rule to factor selection, Elo design, imputation, data sources, testing and future model extensions. Retain the smallest interpretable candidate comparison; add Elo rules or model components only for a named defect or stable chronological gain; introduce imputation only for an actual eligible missingness problem; add sources only for an unresolved evidence need. Test substantive invariants and affected behavior, and preserve historical version boundaries instead of repeatedly rerunning unrelated full suites. Simplicity never waives rights, scientific validity, retirement exclusions or leakage safeguards. Three supported factors are better than four forced factors.

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

Design every method for future use rather than for reproducing the observed seasons. Verified historical or operational predictions must use only information available before the match. Phase 2L separately adopts the source-label development sensitivity below: earlier source batches define assumed availability solely for that labeled analysis, without establishing actual pre-match availability or relaxing verified-forecast evidence gates.

Required protections include chronological processing, lagged features, pre-match ratings, outcome-neutral player orientation, and tests that fail when future information enters a feature. Choose among reasonable specifications with development data and 2024 validation. Do not keep changing the method after seeing 2025 results.

Assess stability across seasons, surfaces, events, ATP, and WTA. Report uncertainty, negative results, and unstable coefficients. Prefer a simpler stable specification when added complexity does not produce a repeatable validation improvement. Revisit an assumption when diagnostics or validation reveal a weakness, but do not search indefinitely for a specification that flatters one validation slice.

## Overfitting and missing-data comparisons

**Approved standing guidance, Phase 1S, 2026-09-28; not implemented.** Avoiding overfitting is a requirement to demonstrate through chronological out-of-sample validation, not a result to claim in advance. Factor selection, transformations, weights, Elo settings, and imputation choices must use development data and 2024 validation only. Freeze the complete pipeline before inspecting 2025 outcomes.

Future missing-data analysis must distinguish structural, sporadic, and eligibility-related missingness. Phase 2G prospectively refines the earlier blanket comparison requirement: begin with no imputation or appropriate complete cases. Only an actual admitted sporadic-missingness problem justifies further comparison, using the simplest defensible alternatives from the approved menu below; do not automatically implement every method. Structural opportunity gaps, excluded records and absent matches are not imputation targets. When such a comparison is separately authorized, its menu remains:

- No imputation or appropriate complete-case analysis.
- Mean imputation.
- Mean imputation with a missingness indicator where justified.
- Multiple imputation using predictive mean matching (PMM).

Fit every imputation procedure inside the chronological training sample or resample only. Never use future matches, validation/test outcomes, or the full dataset to construct imputed values. Never impute match outcomes or convert unavailable statistics to zero. These comparisons do not override eligibility exclusions, statistical quarantine, undefined denominators, coverage gates, or chronology and rights requirements.

Evaluate alternatives using out-of-sample calibration, Brier score, log loss, coefficient/factor stability, and sensitivity across tours, surfaces, seasons, and events. Do not preselect mean imputation or PMM. Prefer the simplest method whose performance and assumptions remain stable. Surface-adjusted Elo normally should not require statistical imputation because its core inputs are eligible match results.

No imputation procedure, factor selection, weight estimation, Elo calculation, or model is implemented or authorized by this guidance. Any required dependency still needs separate approval.

## Match eligibility

### Approved primary analytical population design

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

These names describe hypotheses, not guaranteed final factors. Begin with a broader candidate pool of auditable tennis metrics. Select the final four by their tennis meaning, relationship with Net Point Rating and winning, incremental information when modeled together, stability across chronological samples, and usefulness for describing players. Do not select the four largest univariate correlations if they measure the same underlying skill.

The selected factors should cover distinct mechanisms in the same way that effective field-goal percentage, turnover percentage, offensive-rebound percentage, and free-throw rate describe different parts of basketball performance. Tennis factors need not copy those categories. They should play the same analytical role.

Use missing values when a denominator is unavailable. Account for opponent strength, surface, sample size, and correlated predictors. Test whether a proposed factor remains informative after the other candidates enter the model. Remove, redefine, or replace a factor when development diagnostics and chronological validation show that it is redundant, unstable, poorly measured, or disconnected from future success.

Begin factor weighting with interpretable multiple linear regression, using Net Point Rating as the tennis analogue of net performance. Standardize predictors before comparing their contributions. Do not publish raw coefficients as importance weights when predictors use different scales or share variance. Estimate each factor's share of explained variation with uncertainty, then test whether the weights remain stable across ATP, WTA, surfaces, seasons, and reasonable model specifications.

Use match winning as a separate external check and forecasting outcome. A factor can correlate with same-match Net Point Rating yet fail to improve future forecasts. The final supported factor set and its weights must satisfy both interpretation and out-of-time validation rather than maximize in-sample fit.

## Final Four Factors success criteria

**User-approved goals, Phase 2B; not established findings.** Seek four interpretable, auditable tennis metrics representing distinct mechanisms of creating an advantage. They must have no exact or near-duplicate relationship, manageable multicollinearity, distinct interpretation and stable incremental information after accounting for the other factors. Require meaningful relationships with Net Point Rating and match winning, direction and usefulness that replicate separately across ATP/WTA, seasons, surfaces and events, and out-of-time evidence of future-match value rather than reproduction of the construction sample.

Zero correlation is neither realistic nor required. Practical modeling independence means no algebraic duplication, no near-redundancy, manageable multicollinearity and stable incremental information; it does not assert probabilistic independence or causality. High same-match correlation alone is insufficient because a candidate can share counts directly with NPR or match outcomes. Normally use one auditable metric per mechanism; any composite requires separate justification and user approval.

Current hypothesis families remain Serve Creation, Second-Serve Security, Return Pressure, and Conversion and Recovery. These names do not guarantee four factors or require one factor per family. If evidence supports only three distinct, stable mechanisms, report three. Revise, replace, split or remove a failed family transparently rather than forcing four.

Historical Phase 2A evidence: the hard-court convenience pilots contain 15 candidate-difference columns but rank 10, five exact identities, broad NPR decompositions and no assessable surface or independent season stability. Four independent factors, stable incremental value and freedom from overfitting have not been demonstrated. Later success requires valid broader admitted development evidence, nonredundancy and collinearity checks, multivariable contributions, event/player-aware uncertainty, stability across intended contexts, 2024 validation and the locked 2025 evaluation, followed by the already-prespecified forecasting comparison.

The [Phase 2B definition and selection protocol](docs/four-factors-definition-protocol.md) specifies these future gates and transparent Shapley/LMG-style R-squared allocation; it selects no final factors and fits no coefficients, weights or imputation. Existing eligibility, chronology, overfitting and locked-2025 safeguards remain in force. Phase 2G explicitly refines the imputation-comparison trigger above and the prospective admission estimand below; historical protocol text and results remain unchanged. Design approval is separate from implementation authority.

## Phase 2G provisional candidates and data standard

**Historical Phase 2G shortlist; Phase 2H admission and Phase 2J descriptive revalidation are now implemented as described below.** Phase 2G retained only **S02 = M01 + M05 + M11 + M12** and **S08 = M03 + M05 + M11 + M12** as provisional primary alternatives; Phase 2J subsequently pauses S02. M05 is the clearest second-serve-security interpretation; M11 is provisional return pressure; M12 is break-point conversion or execution, not established recovery, resilience or clutch performance. M01 is more mechanism-focused but had weak or unstable incremental evidence; M03 was stronger in the pilot but is more outcome-coupled. Chronological validation must decide whether its extra value is stable.

Pause S01/S03/S07/S09 because M04/M06 add interpretive complexity without demonstrated stable out-of-time value over M05; preserve their definitions and results. M02 and S04–S06 stay paused for the ATP/WTA conditional-sign reversal. M07 remains a sensitivity, M08/M15 benchmarks, and no final factors, weights or practical-effect thresholds are selected. The historical Conversion and Recovery family name does not confer those properties on M12.

**ADOPT_SOURCE_DEFINED_MODELING_COHORT:** future development may target eligible records present in an authorized, pinned source, conditional on source inclusion, conservatively classified source-reported normal completion, reliable identity/context and valid required statistics. Missing matches remain absent and cannot be imputed or presented as complete tournament coverage. Require reproducible inclusion/exclusion reasons and honest cell/field/selection reporting. Source-reported completion is not independent official confirmation; known conflicts, ambiguous status, retirements, walkovers, incomplete matches and invalid bundles remain excluded. Safe chronology remains a separate prerequisite for forecasting.

This is an explicit prospective estimand change, not a lower historical threshold. The official-reconciliation standard and 90% event / 95% full-panel tour-season gates remain for complete-event/full-panel admission claims; their frozen results are unchanged and source-row denominators cannot pass them. No replacement percentage gate, new source, panel change or split change is adopted. Phase 2G itself admitted no new cell. The subsequent approved Phase 2H audit admitted 2,580 records in 30 cells under this source-defined standard; it did not establish complete-event coverage.

The [Phase 2G decision](docs/occam-candidate-and-data-decision.md) preserves the ordered rationale and its historical Phase 2H approval boundary. The approved [Phase 2H audit](docs/source-defined-cohort-audit.md) used only saved Phase 2F-pinned ATP 2023 and WTA 2021/2023 files within the ten-family panel. Phase 2I diagnosed the 237 service-game conflicts without admitting them. Both releases and all exclusions remain frozen.

## Phase 2J descriptive revalidation

**Implemented under the explicit Phase 2J prompt.** The [broader shortlist report](docs/broader-shortlist-revalidation.md) reconstructs the five shortlisted metrics and both NPR outcomes for all 2,580 frozen admitted rows. Common-complete fitting uses 773 ATP and 1,655 WTA rows; 152 have structurally undefined M12 and receive no imputation. Source-record eligibility and metric computability remain separate. This authorization covers descriptive fitting only and does not authorize histories, ratings or forecasting.

**S02_PAUSED_FOR_PRESPECIFIED_FAILURE; S08 remains provisional.** S02's M01 conditional winning coefficient is negative in the warning-free ATP primary logistic fit (−0.041131), versus positive in WTA; it stays negative in 8/10 event deletions and 185/189 player deletions. This applies the registered direction requirement, not a practical-effect threshold or proof of statistical significance. The report discloses the decision-mapping correction after results inspection. Both sets pass primary NPR directions and numerical gates, and all NPR/equal-phase deletion fits preserve signs and positive numerical increments. Higher R-squared cannot select S08. Event-level reversals and unstable small-cell logistic fits prevent a blanket stability claim.

M03 remains outcome-coupled, M05 second-serve security, M11 provisional return pressure and M12 conversion/execution. No shared-family revision, final factor selection or weights are implemented. `UNCERTAINTY_NOT_ESTABLISHED` applies: no validated player-and-event-aware intervals, IID inferential substitutes or practical-effect margin. ATP season stability and future-match value are unavailable. Source-defined sampling, count exclusions and zero-opportunity selection remain limitations.

**Completed successor:** the [Phase 2K audit](docs/pre-match-chronology-audit.md) returned **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** for all 2,580 matches. Its evidence finding and historical recommendations remain unchanged. Phase 2L adopts only the separate source-label sensitivity convention below; no history or forecast implementation follows from that adoption.

## Phase 2L source-label development convention

**SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY — adopted; membership, S08 histories and Elo implemented in Phases 2M/2N/2P; S08 paired development evaluation implemented in Phase 2R.** The explicit Phase 2L prompt approves [the convention and acceptance criteria](docs/source-label-event-batching-decision.md). Analyze ATP and WTA separately. Each `(tour, source tourney_date)` is one event batch; events sharing a source date are simultaneous. Freeze every target match's features before its batch and use only eligible information from strictly earlier source dates. No within-event rating or factor-history updates; update eligible results after the complete batch, processing same-date events together without order-dependent intermediate state. Four Factors and surface Elo must use identical information cutoffs.

Retirements, walkovers, quarantined records and all other frozen exclusions cannot update histories/ratings. Do not calculate elapsed-time features, inactivity adjustments or time decay. Fit preprocessing and later model choices inside chronological training folds only, with entire batches kept together. Label all results as source-label development sensitivities, never verified historical or deployable forecasts. Missing/invalid labels and empty histories must be explicit; no inferred timestamps or raw repairs.

This is an assumed information schedule. Different-label events may overlap and historical result/statistics availability remains unknown; Phase 2K's **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** still governs verified forecasting. Preserve S02's pause, S08's provisional status, all frozen membership/exclusions and historical releases. No new source/year, OTD work, dependency, history, model or portfolio work is authorized in this documentation phase. Separate implementation approval remains necessary.

**Completed implementation and next boundary:** [Phase 2M](docs/event-batch-membership-audit.md) inventories all 56,999 eligible earlier-batch memberships for 2,580 targets; [Phase 2N](docs/s08-batched-history-aggregation.md) pools counts into provisional S08 histories without imputation. Complete four-feature differences exist for 2,026 targets. [Phase 2P](docs/surface-elo-baseline-audit.md) implemented the fixed Phase 2O Elo benchmark, with finite probabilities for all targets and no performance scoring. [Phase 2Q](docs/s08-forecast-evaluation-protocol.md) specifies the S08 model and paired evaluation below; [Phase 2R](docs/s08-paired-evaluation-results.md) implements the explicitly authorized zero-intercept, SD-only correction and paired descriptive evaluation. There are 211 ATP and 1,067 WTA scored targets; this is no operational forecast or superiority finding. Completed reports retain historical recommendations and authority pins.

## Elo benchmark

Build verified-forecast Elo in evidenced chronological order. Any separately approved Phase 2L development sensitivity instead follows its simultaneous source-label batch convention and identical cutoffs for the comparison models. Start with overall Elo, surface-specific Elo, and a documented blend that shrinks surface ratings toward overall ratings.

Treat the first Elo implementation as a benchmark, not an untouchable final model. Check rating initialization, update size, surface blending, inactivity, match format, calibration, and cold-start behavior. Correct implementation errors when found. Compare justified alternatives with development and 2024 validation, record unsuccessful changes, and keep an added rule only when it produces a stable improvement or fixes a documented conceptual problem.

Do not improve Elo by repeatedly fitting small details to the same matches. Prefer a transparent model whose gains hold across time, tours, surfaces, and events. Freeze the selected Elo specification before evaluating 2025.

### Approved primary Elo design

Do not award extra Elo credit for reaching a later tournament round or for playing in a more prestigious tournament. Elo should update from the opponent's pre-match strength and the match result. A player who reaches a final already accumulates updates from the matches won along the way. Round or prestige bonuses would mix achievement ranking with predictive strength and could count the same tournament run twice.

Account for surface and match format where justified. Document the initial rating, K-factor, surface blend, inactivity rule, best-of-three versus best-of-five treatment, and all eligibility rules before final evaluation. Add margin-of-victory or tournament weighting only as a prespecified comparison that earns a stable validation improvement.

### Phase 2O fixed development baseline — implemented in Phase 2P

The [Phase 2O specification](docs/surface-elo-common-evaluation-decision.md), implemented in [Phase 2P](docs/surface-elo-baseline-audit.md), fixes **1500** initial overall G and each surface S rating, a **400-point** base-10 logistic scale, and **K=32** for both independent components. For neutral slots, `P(A)=1/(1+10^((R_B-R_A)/400))`. The primary rating is **`R=0.5*G+0.5*S`** on the target surface; blend ratings, not probabilities. The sole sensitivity uses overall G only. These are fixed benchmark conventions, not empirically selected or demonstrated optimal choices.

Overall match deltas are `32*(y-p_G)`; surface deltas are `32*(y-p_S)`, using their own component expectations and frozen pre-batch ratings. Sum every player's match-level deltas across the complete simultaneous batch, then apply the accumulated overall and corresponding-surface updates. Never average, clip or sequentially recompute within a batch. Initialize unseen overall/surface states at 1500; an unseen surface is not copied from current G. Tours remain separate; states carry across saved seasons without resets. No round, prestige, margin-of-victory, inactivity, decay, best-of adjustment or K schedule is included. This scoped baseline does not activate the broader future-extension possibilities above.

All **2,580** admitted targets form the all-target Elo reporting cohort (846 ATP; 1,734 WTA). The common S08 feature cohort has **2,026** targets (612 ATP; 1,414 WTA). Both/one/neither complete S08 histories partition ATP as **612/103/131**, WTA as **1,414/181/139**, total **2,026/284/270**. A history is complete only if all four saved slot rates are finite. Retain all 554 other targets and undefined reasons in coverage; Elo priors do not impute S08. All admitted results, including noncommon targets, may update later Elo state. Later paired scores must use identical matches, cutoffs and held-out folds, with any training-readiness failures explicitly reducing both methods' scored cohort. Never compare all-target Elo scores against common-only S08 scores.

No parameter grid is approved. Any later tuning/preprocessing stays inside chronological training folds with whole batches kept together. Preserve 2021–2023 development, 2024 validation/model selection and locked 2025; no 2024/2025 access follows here. Missing 2022 and unequal ATP/WTA history depth persist. S02 remains paused; S08 provisional; **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** still applies. Phase 2P is complete. Phase 2Q specifies S08 fitting/evaluation; Phase 2R implements the prospectively corrected model under explicit approval. Current documentation supersedes pending-implementation wording in completed reports without rewriting their bytes or historical pins.

## Forecast comparison

The longer-term comparison remains the following list; Phase 2Q scopes the next proposed implementation to S08 versus the frozen primary surface blend and sole overall-only Elo sensitivity, without authorizing ranking or combined models:

- Official ranking or ranking-points baseline
- Overall Elo
- Surface-adjusted Elo
- Four Factors
- Surface-adjusted Elo plus Four Factors

Evaluate ATP and WTA separately. Report Brier score, log loss, calibration intercept, calibration slope, and reliability curves. Use accuracy and ROC AUC as secondary measures. Use the same eligible completed-match evaluation cohort for the Elo and Four Factors comparison.

The primary claim concerns out-of-sample calibration. Do not claim Four Factors outperform Elo unless the locked evaluation supports that statement under the prespecified metrics. Comparable predictive performance with clearer player explanations remains a useful result.

## Phase 2Q protocol and Phase 2R paired development evaluation

**Implemented in Phase 2R under explicit approval.** [The protocol](docs/s08-forecast-evaluation-protocol.md) recommends separate ATP/WTA unpenalized logistic regressions for neutral A-win, with a zero intercept and historical A-minus-B M03/M05/M11/M12 predictors. Use training-fold sample SDs only, without mean-centering; require four-predictor rank four. This prospective Phase 2R structural correction was explicitly authorized before loading outcomes or fitting, with every other gate unchanged. No interactions, surface/event indicators, nonlinear terms, sign constraints, Elo feature or imputation. M05 stays lower-is-better; coefficients are forecast parameters, not Dean Oliver importance weights. Zero intercept and SD-only scaling guarantee complementarity under isolated target-slot swaps; also test global relabeling.

Expanding whole-batch walk-forward uses strictly earlier source-date batches only, no within-batch refit, and immutable histories as of each row's own batch. Readiness requires **five prior contributing batches**, **100 complete training matches**, **25 outcomes per class**, finite nonconstant predictors, full rank, registered collinearity review gates, convergence and no detected separation. Training batches count only if they contribute complete rows. The protocol fixes numerical controls and conservative separation/warning diagnostics; absence of detection is not proof of absence. Failed folds yield no S08 prediction with explicit reasons; no rescue model or threshold relaxation. Saved availability permits at most four ATP folds / 211 complete targets and fourteen WTA folds / 1,067 complete targets before class/fit gates; Phase 2R measured all 18 as passing, with those exact scored counts.

Retain all **2,580** targets and **2,026/284/270** both/one/neither-complete strata in coverage. Score S08, Phase 2P primary Elo and overall-only Elo on one identical-ID cohort: complete S08 vector, passing fold, finite valid probabilities for all methods. Never compare all-target Elo scores with common-only S08. Primary metrics are log loss and Brier; paired differences are S08 minus Elo. Report coverage, failures and scores by tour, season, batch, event and surface. Calibration intercept/slope are descriptive only when the protocol's sample/class/batch and fit gates pass; secondary accuracy uses a fixed 0.5 threshold with half-credit for ties. No model or factor is selected from favorable development scores.

**UNCERTAINTY_NOT_ESTABLISHED:** intervals must account jointly for whole batches/events and recurring players in either slot; no IID or event-only interval substitute. Leave-one-batch and leave-one-player deletion of frozen paired score rows measures influence, not training refits or unseen-player performance. The explicit Phase 2Q instruction permits this bounded descriptive comparison while interval methodology remains pending; final factor/weight and locked-evidence requirements are unchanged. S02 stays paused; S08 provisional. **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** both remain. The [Phase 2R report](docs/s08-paired-evaluation-results.md) records exact results and validation. Primary/overall Elo paired log-loss differences (S08 minus Elo) are -0.0054933 / -0.0005342 ATP and +0.0039396 / +0.0156199 WTA; Brier differences are -0.0034229 / -0.0016932 and +0.0009517 / +0.0060530 respectively. ATP calibration is withheld; WTA overall calibration is descriptive. Some batch/player deletions reverse score-difference signs. M05 coefficients are negative in all four ATP folds but positive in all fourteen WTA folds; the lower-is-better definition is unchanged and no sign constraint is imposed. These mixed dependent development results authorize no superiority claim or model selection. The next bounded recommendation is Phase 2S uncertainty feasibility review, requiring the report's exact approval and an explicit documentation scope. No further fitting, tuning, new data or 2024/2025 access follows.

## Data and publication boundaries

Keep raw observations unchanged. Preserve source identifiers, source spellings, missingness, provenance, fingerprints, licenses, and conflicts. Never replace an unavailable statistic with zero. Keep source observations, official references, recovery overlays, and future canonical analytical records as separate layers.

Free access does not establish permission to redistribute data or publish derived products. Keep restricted raw and match-level official data outside Git. Review rights before publishing aggregates, ratings, charts, JSON, or website material.

The `tennis-analytics` repository owns the research and reproducible outputs. The `portfolio` repository receives reviewed, website-ready outputs only after the user requests integration.

## Sources of truth

- `AGENTS.override.md` supplies active workflow instructions; `AGENTS.md` is the preserved detailed reference.
- `PROJECT_CONTEXT.md` defines the stable research purpose and methodological direction.
- `docs/status.md` records the current completed phase, blockers, and next decision.
- `docs/data-source-contract.md` defines data provenance, validation, rights, and eligibility boundaries.
- Adopted policy documents govern only their stated versions and scopes.

Read docs/status.md only through CURRENT_SNAPSHOT_END for routine work, then consult named historical sections when needed. Keep every affected source-of-truth document current and distinguish approved design, implemented behavior and remaining decisions. The completed-match-only population and primary Elo rules are approved; their analytical implementation remains future work.
