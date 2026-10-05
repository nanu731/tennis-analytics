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

**Current M05 terminology (Phase 2V): Double-Fault Rate per Second-Serve Opportunity.** Preserve `M05` and existing code fields, own double faults / own second-serve opportunities, and lower-is-better performance orientation. It measures one error component, not total second-serve effectiveness, aggression or comprehensive security. The broader Second-Serve Security candidate family is unchanged. The [adopted role decision](docs/m05-role-clarification-decision.md) governs current and future terminology; older reports retain their historical wording.

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

**Historical Phase 2G shortlist; Phase 2H admission and Phase 2J descriptive revalidation are now implemented as described below.** Phase 2G retained only **S02 = M01 + M05 + M11 + M12** and **S08 = M03 + M05 + M11 + M12** as provisional primary alternatives; Phase 2J subsequently pauses S02. Phase 2G described M05 as the clearest second-serve-security interpretation; M11 is provisional return pressure; M12 is break-point conversion or execution, not established recovery, resilience or clutch performance. M01 is more mechanism-focused but had weak or unstable incremental evidence; M03 was stronger in the pilot but is more outcome-coupled. Chronological validation must decide whether its extra value is stable.

Pause S01/S03/S07/S09 because M04/M06 add interpretive complexity without demonstrated stable out-of-time value over M05; preserve their definitions and results. M02 and S04–S06 stay paused for the ATP/WTA conditional-sign reversal. M07 remains a sensitivity, M08/M15 benchmarks, and no final factors, weights or practical-effect thresholds are selected. The historical Conversion and Recovery family name does not confer those properties on M12.

**ADOPT_SOURCE_DEFINED_MODELING_COHORT:** future development may target eligible records present in an authorized, pinned source, conditional on source inclusion, conservatively classified source-reported normal completion, reliable identity/context and valid required statistics. Missing matches remain absent and cannot be imputed or presented as complete tournament coverage. Require reproducible inclusion/exclusion reasons and honest cell/field/selection reporting. Source-reported completion is not independent official confirmation; known conflicts, ambiguous status, retirements, walkovers, incomplete matches and invalid bundles remain excluded. Safe chronology remains a separate prerequisite for forecasting.

This is an explicit prospective estimand change, not a lower historical threshold. The official-reconciliation standard and 90% event / 95% full-panel tour-season gates remain for complete-event/full-panel admission claims; their frozen results are unchanged and source-row denominators cannot pass them. No replacement percentage gate, new source, panel change or split change is adopted. Phase 2G itself admitted no new cell. The subsequent approved Phase 2H audit admitted 2,580 records in 30 cells under this source-defined standard; it did not establish complete-event coverage.

The [Phase 2G decision](docs/occam-candidate-and-data-decision.md) preserves the ordered rationale and its historical Phase 2H approval boundary. The approved [Phase 2H audit](docs/source-defined-cohort-audit.md) used only saved Phase 2F-pinned ATP 2023 and WTA 2021/2023 files within the ten-family panel. Phase 2I diagnosed the 237 service-game conflicts without admitting them. Both releases and all exclusions remain frozen.

## Phase 2J descriptive revalidation

**Implemented under the explicit Phase 2J prompt.** The [broader shortlist report](docs/broader-shortlist-revalidation.md) reconstructs the five shortlisted metrics and both NPR outcomes for all 2,580 frozen admitted rows. Common-complete fitting uses 773 ATP and 1,655 WTA rows; 152 have structurally undefined M12 and receive no imputation. Source-record eligibility and metric computability remain separate. This authorization covers descriptive fitting only and does not authorize histories, ratings or forecasting.

**S02_PAUSED_FOR_PRESPECIFIED_FAILURE; S08 remains provisional.** S02's M01 conditional winning coefficient is negative in the warning-free ATP primary logistic fit (−0.041131), versus positive in WTA; it stays negative in 8/10 event deletions and 185/189 player deletions. This applies the registered direction requirement, not a practical-effect threshold or proof of statistical significance. The report discloses the decision-mapping correction after results inspection. Both sets pass primary NPR directions and numerical gates, and all NPR/equal-phase deletion fits preserve signs and positive numerical increments. Higher R-squared cannot select S08. Event-level reversals and unstable small-cell logistic fits prevent a blanket stability claim.

At Phase 2J, M03 was described as outcome-coupled, M05 as second-serve security, M11 as provisional return pressure and M12 as conversion/execution. M05 now uses the canonical name Double-Fault Rate per Second-Serve Opportunity under Phase 2V; the historical report is unchanged. No shared-family revision, final factor selection or weights are implemented. `UNCERTAINTY_NOT_ESTABLISHED` applies: no validated player-and-event-aware intervals, IID inferential substitutes or practical-effect margin. ATP season stability and future-match value are unavailable. Source-defined sampling, count exclusions and zero-opportunity selection remain limitations.

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

**UNCERTAINTY_NOT_ESTABLISHED:** intervals must account jointly for whole batches/events and recurring players in either slot; no IID or event-only interval substitute. Leave-one-batch and leave-one-player deletion of frozen paired score rows measures influence, not training refits or unseen-player performance. The explicit Phase 2Q instruction permits this bounded descriptive comparison while interval methodology remains pending; final factor/weight and locked-evidence requirements are unchanged. S02 stays paused; S08 provisional. **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** both remain. The [Phase 2R report](docs/s08-paired-evaluation-results.md) records exact results and validation. Primary/overall Elo paired log-loss differences (S08 minus Elo) are -0.0054933 / -0.0005342 ATP and +0.0039396 / +0.0156199 WTA; Brier differences are -0.0034229 / -0.0016932 and +0.0009517 / +0.0060530 respectively. ATP calibration is withheld; WTA overall calibration is descriptive. Some batch/player deletions reverse score-difference signs. M05 coefficients are negative in all four ATP folds but positive in all fourteen WTA folds; the lower-is-better definition is unchanged and no sign constraint is imposed. These mixed dependent development results authorize no superiority claim or model selection. Phase 2S has completed that uncertainty feasibility review with the retained boundary below; the Phase 2R report keeps its historical recommendation. No further fitting, tuning, new data or 2024/2025 access follows.

## Phase 2S dependence-aware uncertainty boundary

**UNCERTAINTY_NOT_ESTABLISHED_RETAINED.** The [read-only feasibility assessment](docs/dependence-aware-uncertainty-feasibility.md) defines eight paired mean contrasts in total (four per tour): S08 minus primary/overall Elo log loss and Brier, conditional on the frozen scored development cohort, predictions and source-label convention. No population-generalization or training-uncertainty estimand is added. An inferential repetition law is not established by the observed finite-cohort means.

ATP has 211 scored matches, four batches and 120 players; WTA 1,067, fourteen and 196. Respectively 73 and 161 players recur across batches. The batch–player graphs have 255/1,163 incidence edges and **one connected component per tour**; every batch pair shares players (6/6 ATP, 91/91 WTA). Largest batch shares are 30.81%/10.03%; player match counts range 1–14/1–52. Concentration summaries do not count independent observations. Some small net contrasts remain deletion-sensitive.

Only the joint batch–player connected-component block bootstrap of frozen paired scores was assessed. It preserves paired rows, whole batches and player identity in either slot without refitting or changing folds, but has only one available block per tour and therefore degenerates. Credible independent replication, a justified conditional repetition law and synthetic coverage/false-positive/small-cluster validation are absent. No interval or alternative method is authorized; no IID, event-only, one-slot or standard two-way substitute is assumed valid. This is a failure of the assessed route, not proof that all future methods are impossible.

Phase 2T has completed the bounded descriptive M05 diagnostic below; the Phase 2S report preserves its historical recommendation. It does not repair uncertainty or change factors automatically. S02 stays paused; S08 provisional; **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** remain. No refit, tuning, interval, generated output, source/year access or portfolio change occurred in Phase 2S.

## Phase 2T M05 direction boundary

**MEASURED_M05_PATTERN_IDENTIFIED.** The [frozen diagnostic](docs/m05-direction-diagnostic.md) reconstructs all own double-fault/second-serve opportunity histories and all 1,278 scored linear predictors without refitting. All four ATP coefficients remain negative; all fourteen WTA coefficients positive. ATP training marginal Pearson correlations are near zero (−0.000790 to +0.011778); WTA's are weakly positive in every fold (+0.004536 to +0.053303). WTA's pattern is therefore not a simple negative-marginal/positive-conditional reversal. Cross-factor associations and composition differ by tour and change with expanding histories; suppression, aggression, style and measurement explanations remain unverified hypotheses. A positive coefficient does not establish that double faults help winning.

Own M05, frozen sample-SD scaling, zero-intercept component arithmetic, prior ownership and strict cutoffs reconcile. No verified implementation or saved-count reconstruction defect was found within this scope. Minimum-slot opportunities/depth have modest negative rank associations with absolute contributions, but extremes are not confined to the sparsest histories. Complete fold, event, surface, season and exact-value opportunity/depth tables are retained; no low-opportunity threshold or exclusion is introduced.

The evidence requires a bounded factor interpretation review, not automatic revision: M05 stays lower-is-better, S02 paused and S08 provisional. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist. All historical predictions, memberships, exclusions and releases remain frozen. Phase 2U has completed that interpretation review below; the Phase 2T report retains its historical recommendation. No further fit, factor change, sign constraint, threshold, acquisition or 2024/2025 access follows from completion.

## Phase 2U M05 role review

**M05_REVISION_REQUIRED_BEFORE_VALIDATION.** The [documentation-only review](docs/m05-factor-interpretation-review.md) distinguishes construct measurement from forecast utility. M05 directly measures own double faults per second-serve opportunity, one error component rather than comprehensive second-serve security. Its Phase 2J S08 NPR slopes are negative on both tours (−0.978541 ATP; −1.448609 WTA), with numerical R² increments 0.006606/0.009638 and negative same-match winning coefficients. This supports a narrower descriptive interpretation, not final factor qualification or stable future value.

All four ATP historical forecast coefficients are negative and all fourteen WTA coefficients positive. Within-tour sign repetition does not meet the common prespecified lower-is-better direction across tours. Collinearity passes and arithmetic reconciliation do not resolve the interpretation conflict; positive WTA coefficients cannot establish that double faults improve performance. Suppression, aggression, style and measurement explanations remain hypotheses. Whole-model S08-versus-Elo results do not isolate M05's incremental forecast contribution. No new statistics, score, threshold or majority-vote rule is introduced.

Phase 2U recommended an explicit performance label separated from its unqualified, tour-specific historical forecast association. Phase 2V now adopts that clarification below; the Phase 2U report preserves its proposal-stage wording. Only the current metric name and role explanation change. The formula, factor statuses, model and predictions remain unchanged; S02 stays paused and S08 provisional. Existing direction, incremental-value and final qualification gates are not waived by role separation.

Phase 2V completes the terminology adoption. It does not establish future utility, resolve forecast instability, authorize fitting or unlock 2024; the remaining scientific comparison is described below. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**, and the untouched 2024/locked-2025 boundaries persist. No historical release or portfolio is changed.

## Phase 2V adopted M05 roles

**M05_ROLE_CLARIFICATION_ADOPTED.** [The decision](docs/m05-role-clarification-decision.md) establishes **Double-Fault Rate per Second-Serve Opportunity** as the canonical name in current and future work. Own double faults / own second-serve opportunities, lower-is-better orientation, metric ID/code field `M05`, neutral differences, undefined values and the broader Second-Serve Security candidate family are preserved. M05 measures one error component, not total second-serve effectiveness, aggression or comprehensive security. No variable, column, file or historical heading is renamed.

ATP historical forecast coefficients are negative and WTA coefficients positive. This association remains tour-specific and unqualified; positive WTA coefficients do not imply that double faults improve performance. The clarification does not resolve forecast instability or qualify M05. S02 stays paused and S08 provisional. All historical models, coefficients, predictions, results and terminology remain preserved; only current naming/role guidance changes.

Phase 2W now implements that bounded development-only ablation under its explicit instruction, as recorded below. The Phase 2V decision preserves its historical recommendation and proposed difference orientation; Phase 2W explicitly registers reduced minus full S08 before fitting. No factor-status change, qualification waiver or new threshold follows automatically.

**UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist, with 2024 validation and locked 2025 untouched. No model is refitted or score recomputed by the clarification.

## Phase 2W M05 ablation

**M05_ABLATION_MIXED.** [The results](docs/m05-ablation-results.md) compare one reduced M03/M11/M12 model with frozen full-S08 predictions, separately by tour. The user-approved classification was registered before empirical fitting: both losses positive in both tours means full descriptively better; both negative means reduced descriptively better; ties, mixed directions or failed tour comparisons mean mixed. Differences are **reduced minus full S08**; negative favors reduced. No practical margin, new sign rule or superiority inference is introduced.

All eighteen reduced fits pass the unchanged safeguards with rank three, zero intercept and training-SD-only scaling. The exact Phase 2R training IDs, eighteen attempted folds, 1,278 scored IDs and source-batch cutoffs are preserved. All 2,580 targets remain in coverage; original reasons for twelve never-attempted folds and 1,302 nonpredictions remain visible. No new row becomes eligible because M05 is removed. No full model is refitted.

ATP (211 pairs) reduced-minus-full log loss/Brier are **+0.000036952014 / +0.000023825914**; WTA (1,067) **−0.000759150161 / −0.000408917587**. ATP signs reverse under two batch deletions and 33/29 player deletions (log loss/Brier). WTA log loss reverses under one batch deletion; Brier under none, and neither under any player deletion. WTA 2021 favors full on both losses while 2023 favors reduced. These are dependent descriptive score deletions, not refits or uncertainty intervals.

M05 remains **Double-Fault Rate per Second-Serve Opportunity**, lower-is-better within the broader Second-Serve Security candidate family; no label, formula, status or historical prediction changes. S02 stays paused and S08 provisional. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** remain. The mixed ablation does not resolve the WTA performance-direction conflict, establish a causal effect or qualify either candidate for final use. 2024 validation and locked 2025 remain untouched.

**Completed successor:** the Phase 2X decision below advances both tested specifications to a separately approved validation protocol in distinct scientific roles. This supersedes the current next-step recommendation only; the historical Phase 2W report and its evidence remain unchanged.

## Phase 2X pre-validation candidate decision

**ADVANCE_BOTH_AS_PRESPECIFIED_2024_CANDIDATES.** The [decision](docs/pre-validation-candidate-decision.md) applies the existing nonsummed rules to saved evidence. Full S08 (M03/M05/M11/M12) tests the interpretable four-component hypothesis with M05's unresolved tour-specific forecast interpretation. The reduced M03/M11/M12 model is a three-factor parsimonious comparator testing whether M05 adds forecast value, not a Four Factors model. Two frozen scientific roles advance, not an ongoing model search or a final model selection.

Both must use identical eligible validation IDs and information cutoffs against the frozen Phase 2P surface-adjusted and overall-only Elo specifications. Removing M05 admits no additional comparison rows. Preserve separate ATP/WTA models, neutral differences, zero intercept, training-SD-only scaling and existing safeguards with rank four/full and three/reduced. No 2024 probabilities, cohort or result is established here.

Measurement and numerical checks support a testable comparison; they do not override interpretation failures. M05 remains **Double-Fault Rate per Second-Serve Opportunity**, own double faults / own second-serve opportunities, lower-is-better and one error component within the broader Second-Serve Security family. Its ATP-negative/WTA-positive forecast association remains unqualified. Positive WTA coefficients do not imply a beneficial performance effect. Phase 2W's small dependent loss differences and season/deletion sensitivity do not establish practical equivalence, stable incremental value or superiority. No score, new threshold or uncertainty method selects a winner. Advancement does not waive direction, interpretation or final qualification requirements.

S02 stays paused, S08 provisional; the reduced comparator receives no final factor status. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist. Missing 2022, unequal histories, absent ATP season/clay comparisons and unverified timing/availability remain limitations. Frozen memberships, exclusions and all historical releases are unchanged. Advancement grants no acquisition, 2024 access, validation result, final factor approval or operational forecast claim; 2025 remains locked.

**Completed successor:** Phase 2Y below freezes the 2024 protocol under its explicit user instruction. The historical Phase 2X decision and its next-step recommendation remain unchanged; data access and implementation still need separate authority.

## Phase 2Y frozen 2024 validation protocol

**2024_VALIDATION_PROTOCOL_FROZEN_PENDING_DATA_AUTHORIZATION.** The [protocol](docs/2024-validation-protocol.md) freezes full S08 (M03/M05/M11/M12), reduced M03/M11/M12, primary surface Elo and overall-only Elo sensitivity. Full tests the four-component hypothesis; reduced is a three-factor comparator of M05's added forecast value. This documentation approval accesses no 2024/2025 file, URL, metadata, schema or result, and authorizes no acquisition or empirical implementation.

Future 2024 validation is rolling prequential **source-label validation sensitivity**, retaining **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** for lineage. Each tour/source-date batch is simultaneous; use only earlier batches, fit preprocessing and both models within each training fold, and freeze every target prediction before post-batch history/training/Elo updates. Earlier admitted 2024 results can train later batches. Carry frozen development histories/training vectors and Phase 2P terminal Elo states forward, without resetting seasons or filling missing 2022. Actual timing, overlap and historical availability remain unverified: **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** is unchanged.

Both factor models use the full-S08-complete training and target cohort, zero intercept, training sample-SD-only scaling and the unchanged readiness/fit safeguards, with rank four/full and three/reduced. Elo keeps initial states 1500, scale 400, K=32, rating blend 0.5G+0.5S, independent component expectations and synchronous accumulated deltas. All admitted matches update later histories/Elo, including factor-incomplete rows. Every admitted target remains in coverage; one identical paired mask requires valid full, reduced and both Elo probabilities on the same outcome and cutoff. No imputation, rescue, clipping, extra feature or tuning is permitted.

**User-prespecified forecasting selection:** one candidate is preferred for the frozen 2025 forecasting specification only if it has strictly lower natural-log loss and Brier in both tours, neither direction reverses under any whole-batch score deletion, and every required fold/numerical safeguard passes. Required folds are all admitted 2024 tour/date batches, not the successful subset. Full-sample ties, mixed metrics/tours, failed or missing comparisons, reversals and unevaluable whole-batch deletions mean **SELECTION_UNRESOLVED**, retaining both candidates for the locked test. A deletion tie is disclosed but is not a reversal. Player deletions and calibration remain limitations, never tie-breakers. No practical margin, pooled score or superiority inference is introduced; Elo comparisons stay descriptive pending locked-2025 evidence.

Forecast preference cannot confer Four Factors interpretation support: M05 must also satisfy its expected negative direction across both tours, without a nonnegative or missing required full-fold coefficient, and existing interpretation/qualification requirements still apply. M05 remains **Double-Fault Rate per Second-Serve Opportunity**, unchanged formula and lower-is-better error-component meaning. S02 stays paused, S08 provisional; **UNCERTAINTY_NOT_ESTABLISHED** persists. Missing years, unequal histories, source selection and chronology limits remain; no 2024 result or forecast claim exists.

**Completed successor:** Phase 2Z below acquires and audits only the two approved 2024 annual sources under explicit authority. The historical Phase 2Y protocol remains unchanged; histories, ratings, fitting and scoring remain unauthorized, and 2025 inaccessible.

## Phase 2Z 2024 source admission audit

**2024_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED.** The [audit](docs/2024-source-admission-audit.md) verifies saved conditional CC BY-NC-SA 4.0 research-use evidence and acquires only ATP/WTA 2024 annual files plus their file-specific metadata at archive 83733587353df8a41f2fd4f516147d5aa83f5a8d. Both files pass provenance/byte/schema checks: ATP 3,076 annual / 998 panel / 944 admitted / 54 excluded; WTA 2,689 / 998 / 852 / 146. All twenty cells are observed; eighteen have admissions, zero are absent, and WTA Canada/Cincinnati are wholly blocked. Their source code is PM versus inherited expected P; all 110 rows remain excluded without declaring the source or official level wrong.

The unchanged ten-family admission rules, conservative completion, identity/duplicate/context checks, count bounds and service-game reconciliation apply. No historical pilot override transfers to 2024; raw fields stay intact and A/B orientation remains outcome-neutral. Count bundles are present for 991/998 ATP and 994/998 WTA panel rows. Retention is 944/998 and 852/998, not official coverage; official recall remains UNKNOWN. Retirement/walkover/unfinished, count and context reasons overlap and remain fully recorded.

Only the seven authorized tracked files, four ignored acquired files and six ignored audit tables are created/updated. The initial local helper-binding failure and bounded same-endpoint recovery are disclosed in the report and manifest; final files passed all checks. The frozen validation protocol and every historical release remain unchanged. S02 paused, S08 provisional, canonical M05 Double-Fault Rate per Second-Serve Opportunity and its interpretation limits persist. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** remain. No histories, factors, ratings, fitting, scoring, OTD, portfolio or publication work is authorized by this admission result; 2025 remains inaccessible.

**Completed successor:** Phase 2AA below adopts a prospective exact context mapping. The frozen Phase 2Z release and validation protocol remain unchanged; a new revised admission release requires separate approval.

## Phase 2AA 2024 WTA PM context decision

**ADOPT_EXACT_2024_WTA_PM_CONTEXT_MAPPING.** The [decision](docs/2024-wta-pm-context-decision.md) adopts only WTA / 2024 / already established Canada or Cincinnati family / raw level PM, subject to all unchanged context and independent admission checks. Preserve literal PM; no global PM=P equivalence, semantic meaning, new family or alias is established. Implementation must be a separately approved new revised admission release, never a rewrite of Phase 2Z.

Saved evidence uniquely links 55 Toronto records (2024-806, source date 20240805) and 55 Cincinnati records (2024-1017, 20240812) to the frozen families. Both are Hard, best-of-three, raw draw_size 64, with 56 observed player IDs and round counts 24/16/8/4/2/1 from R64 through F. All-annual candidate searches find no competing P edition or extra mapping; source keys, encounters and saved identity checks have no conflicts. These are source-context observations, not verified timing or official completeness.

All 110 retain level_conflict in Phase 2Z. Of these, 105 have no other saved exclusion; five Toronto retirements also retain status and unevaluable-game reasons. This reason accounting does not create new admissions. The frozen release remains 1,796 admitted with two wholly blocked cells and official recall UNKNOWN. No membership, code, data, manifest, test, factor or model changes. S02 paused, S08 provisional; M05 naming/formula unchanged. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist; 2025 remains inaccessible.

**Completed successor:** Phase 2AB below implements this exact exception in a separate release, preserving Phase 2Z and all independent gates.

## Phase 2AB revised 2024 source admission

**2024_SOURCE_COHORT_READY_FOR_HISTORY_BUILD.** The [report](docs/2024-source-admission-v2.md) documents release 2AB-2.0.0 from the same verified saved sources. All four exception keys must match: WTA, 2024, frozen Canada/Cincinnati family, raw PM. Literal PM is retained without semantic or global-equivalence claims. Every other admission rule is rerun unchanged; the original six Phase 2Z tables must reproduce byte-for-byte first.

Measured delta: exactly 110 level-conflict reasons removed, 105 newly admitted, five Toronto retirements still excluded with all independent reasons; zero changed ATP or other WTA rows. Revised ATP 944 admitted / 54 excluded and WTA 957 / 41 give 1,901 admissions and 95 exclusions from 1,996 panel records. All twenty cells contain admissions; no absent or wholly blocked cell. Retention 94.59% ATP / 95.89% WTA is source-record retention, not official coverage; official recall UNKNOWN. Phase 2Z remains frozen at 1,796 admissions and its historical partial-review result.

Only the new runner, tests, report and six ignored v2 outputs are created, alongside these current-document updates. Existing code, tests, manifest, raw files, protocol, reports and releases remain unchanged. S02 paused, S08 provisional, canonical M05 unchanged; **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** persist. No history, rating, fit, score, 2025, acquisition, dependency, OTD or portfolio work.

**Completed successor:** Phase 2AC below implements only candidate membership for the frozen v2 targets. Factor aggregation, ratings and models remain separate work.

## Phase 2AC 2024 candidate history membership

**2024_EVENT_BATCH_MEMBERSHIP_BUILT.** The [audit](docs/2024-event-batch-membership-audit.md) covers all 1,901 targets / 3,802 neutral slots in twenty tour/source-date batches. All admitted same-tour development matches involving the player, plus strictly earlier admitted 2024 batches, are eligible candidates. Equal-date events are simultaneous; no window, surface restriction or within-batch order applies. Original match IDs stay intact with additional DEVELOPMENT/VALIDATION_2024-qualified keys. Selection uses frozen linkage and labels, not target outcomes or statistics.

Measured: ATP 41,138 links (26,324 development / 14,814 earlier-2024), 71 empty slots, median/max depth 19/71; WTA 60,845 (46,625 / 14,220), 45 empty slots, median/max 27/115. Total 101,983 contributions plus 116 explicit empty placeholders; no exclusion, same/later batch or cross-tour record contributes. Frozen cohorts and releases are preserved. Missing 2022 and unequal tour history depth remain.

Three ignored outputs contain target batches, candidate memberships and summaries. This is **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**; **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED** persist. Membership is not verified historical availability. S02 paused, S08 provisional, canonical M05 unchanged; no aggregation, rating, fit, scoring, acquisition, 2025, OTD or portfolio work.

**Completed successor:** Phase 2AD below aggregates the frozen memberships with registered S08 formulas. Ratings and models remain separate work.

## Phase 2AD 2024 S08 cumulative histories

**2024_S08_BATCH_HISTORIES_AGGREGATED.** The [report](docs/2024-s08-batched-history-aggregation.md) preserves all 1,901 targets / 3,802 neutral slots and 101,983 frozen earlier-batch contributions. Phase 2N component/ownership/pooling functions are reused after exact Phase 2AC validation. Qualified count keys preserve cohort distinction; original output IDs remain unchanged. Pool own first-serve wins/in (M03), own double faults/second-serve opportunities (M05), opponent break points faced/service games (M11), and opponent break points converted/faced (M12), then form neutral A-minus-B differences.

ATP: M03/M05/M11 each available for 1,817 slots / 875 differences; M12 1,813 slots / 871 differences. WTA: all four available for 1,869 slots / 912 differences. Full-S08 and reduced-component completeness are both 871 ATP / 912 WTA (1,783 total); both future candidates retain the full-S08-complete feature criterion, plus later fold gates. All 118 incomplete targets remain. Empty histories: 71 ATP / 45 WTA; four additional ATP M12 zero-opportunity slots stay undefined. Thirty WTA M11 rates exceed one (maximum 1.25), uncapped. Median/max history depths remain 19/71 ATP and 27/115 WTA.

M05 remains **Double-Fault Rate per Second-Serve Opportunity**, lower-is-better and unreversed, with unresolved tour-specific forecast interpretation. No weight, smoothing, imputation, window, decay or replacement factor is introduced. S02 paused, S08 provisional; **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED** persist. Frozen admissions, memberships and historical releases are unchanged. No rating, fit, scoring, acquisition, 2025, dependency, OTD or portfolio work.

**Completed successor:** Phase 2AE below carries verified Phase 2P terminal states into the frozen 2024 benchmarks. Factor fitting and scoring remain separate work.

## Phase 2AE 2024 synchronous Elo benchmarks

**2024_SURFACE_ELO_BENCHMARK_BUILT.** The [audit](docs/2024-surface-elo-baseline-audit.md) implements the unchanged primary 0.5G+0.5S and overall-only G benchmarks. Both provide finite probabilities for all 1,901 admitted targets (944 ATP / 957 WTA), across twenty tour/date batches. No loss, accuracy, calibration or ranking is computed.

Before processing 2024, the complete Phase 2P replay reproduces its three saved outputs byte-for-byte. Terminal saved states carry forward: ATP 193 overall / 388 surface; WTA 267 / 599. Saved chains reconcile exactly; maximum terminal serialization residual 5.002221e-12 is below the existing 1e-10 arithmetic tolerance. No reset or missing-season fill. Unseen G/S states initialize at 1500, scale 400, K=32 independently. Freeze all batch probabilities, sum each component's match deltas, then apply after the simultaneous batch; no clipping or within-batch update.

Overall cold slots: 71 ATP / 45 WTA; surface cold slots: 243 / 149. Full-S08 both/one/neither strata remain 871/71/2 ATP and 912/45/0 WTA. All 118 factor-incomplete targets predict and update Elo. The ledger has 3,962 state updates and 3,802 player-match contributions per component. Phase 2AC prior exposure and Phase 2AD completeness agree exactly; exclusions and historical artifacts remain frozen.

All outputs retain **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED**. S02 paused, S08 provisional; canonical lower-is-better M05 and its unresolved forecast interpretation persist. Source-label availability/overlap, missing 2022, unequal depth, retrospective admission and official recall UNKNOWN remain limitations. No S08 fit, score, tuning, acquisition, 2025, dependency, OTD, portfolio or publication work.

**Completed successor:** Phase 2AF below implements the frozen validation protocol; Elo and histories remain unchanged.

## Phase 2AF rolling 2024 validation

**SELECTION_UNRESOLVED.** The [results](docs/2024-validation-results.md) implement the unchanged frozen protocol with original development features, strictly earlier complete 2024 rows and identical full/reduced training and target IDs. All twenty required batches pass both models: forty zero-intercept, training-SD-only fits. Full/reduced ranks remain four/three; no numerical, warning, boundary or separation gate fails. No protocol, threshold, eligibility or candidate was changed after outcomes were loaded.

All 1,901 admitted targets remain in coverage. Common four-method pairs: 871 ATP / 912 WTA; 73/45 structurally incomplete targets are unscored. Both Elo methods retain all-target availability, but scoring uses the exact factor-common IDs. Reduced-minus-full log loss/Brier: ATP **-0.0003474321 / -0.0001484733**, WTA **+0.0006422503 / +0.0003490372**. Both factor candidates have higher descriptive losses than both Elo benchmarks. No final superiority or practical-significance claim follows.

All 20 batch and 344 both-slot player deletions are evaluable; no paired comparison reverses or ties for either loss. The tours nevertheless favor different factor models, so the frozen selection rule retains both specifications. Calibration is supported descriptively for each method at tour/2024-season/Hard scopes, not as a forecast correction or selection tie-breaker.

**M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED:** full-model M05 coefficients are negative in five of ten ATP folds and nine of ten WTA folds; the remainder are positive. M05 remains Double-Fault Rate per Second-Serve Opportunity, lower-is-better. Positive conditional coefficients do not mean double faults improve performance. No sign averaging, constrained rescue or Four Factors qualification. S02 paused, S08 provisional; reduced remains three factors.

**SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**, **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** and **UNCERTAINTY_NOT_ESTABLISHED** persist. No confidence intervals or p-values. Source selection, unverified availability/overlap, missing 2022 and unequal histories remain. Protocol, admissions, histories, Elo and historical releases are immutable. No tuning, rescue, acquisition, 2025 access, dependency, OTD, portfolio or publication work.

**Completed successor:** Phase 2AG below freezes the final-test pipeline without accessing 2025; the Phase 2AF release and interpretation failure remain unchanged.

## Phase 2AG locked final-test freeze

**2025_LOCKED_FINAL_TEST_PROTOCOL_FROZEN_PENDING_DATA_AUTHORIZATION.** The [locked protocol](docs/2025-locked-final-test-protocol.md) freezes full S08, reduced M03/M11/M12, primary surface Elo and overall-only sensitivity. SELECTION_UNRESOLVED persists; 2025 evaluates both scientific roles without selecting, tuning or redesigning them. S02 paused, S08 provisional. M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED remains binding even if future signs, losses or calibration are favorable; this pipeline cannot confer final Four Factors qualification.

The same panel/admission gates apply; the exact 2024 WTA PM exception cannot transfer to 2025. Source-label same-date batches remain simultaneous. Carry admitted development/2024 histories without reset, original complete training vectors, and reconciled Phase 2AE terminal overall/surface states including untouched development states. Add eligible 2025 results only after complete earlier batches. Both factor models use full-S08 eligibility, zero intercept and training-SD-only scaling with frozen readiness/numerical gates; Elo parameters and synchronous updates are unchanged. No imputation, rescue, decay or within-batch updates.

Use one four-method common mask, separate tours, natural-log loss and Brier. Each candidate receives a lower locked-test loss label versus primary surface Elo only when both losses are strictly lower in both tours, all required gates pass and every whole-batch deletion preserves strict direction; the symmetric condition favors Elo. Any mixed result, tie (including deletion ties), failure, missing/nonfinite comparison or unevaluable deletion yields LOCKED_TEST_LOSS_COMPARISON_MIXED_OR_UNRESOLVED. This prospective rule preserves the historical 2024 convention unchanged. Overall-only remains sensitivity, never a replacement primary benchmark.

Calibration remains descriptive under frozen support gates: DESCRIPTIVELY_BETTER_CALIBRATION_THAN_SURFACE_ELO requires no larger absolute intercept or absolute slope deviation from one, with at least one strictly closer in each tour. Otherwise CALIBRATION_COMPARISON_UNRESOLVED. All-target coverage, fixed-.5 accuracy, batch and both-slot player deletions, failures and coding-defect disclosures remain required. No statistical-superiority claim or final factor approval; UNCERTAINTY_NOT_ESTABLISHED and source-label/chronology limitations persist.

At the Phase 2AG freeze, planned ATP/WTA 2025 names extended the saved naming convention at revision 83733587353df8a41f2fd4f516147d5aa83f5a8d; existence, rights recheck, metadata, schema, hashes, coverage and contents were NOT_ACCESSED_PENDING_AUTHORIZATION. That documentation phase performed no probe or generated-output work; the separately authorized Phase 2AH below records subsequent source access.

**Completed successor:** Phase 2AH below implements only the separately authorized acquisition/admission audit; the locked protocol and comparison rules remain unchanged.

## Phase 2AH locked-source admission audit

**2025_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED.** The [audit](docs/2025-source-admission-audit.md) acquired only the ATP/WTA 2025 annual files and revision-bound metadata at 83733587353df8a41f2fd4f516147d5aa83f5a8d. Saved rights/provenance and twelve authority pins were checked before requesting data. Code/tests and admission rules were frozen after 167 fixture checks; their recorded hashes remain unchanged. Four requests succeeded without redirects or retries. Both files pass metadata, size, SHA-256, Git-blob and fixed-schema verification; no post-access correction or rule change occurred.

All 5,739 annual rows are retained once: 2,156 panel and 3,583 outside-panel. ATP admits 1,011/1,078 with 67 exclusions; WTA admits 867/1,078 with 211 exclusions. All twenty cells are observed, eighteen contain admissions, none are absent, and WTA Canada/Cincinnati are wholly blocked by 190 literal PM records (95 each). The 2024 exception is not transferred. Among them, 182 have only level_conflict and eight have independent status/count exclusions; none is admitted. Six ATP Roland-Garros best-of conflicts remain excluded alongside four retirements/two walkovers. No identity, duplicate or source-edition conflict was found. Source-record retention is not official coverage; official recall UNKNOWN.

The seven-file change creates acquisition code, focused tests, a source manifest and report, with only context/status/contract updates. Four acquired files and six audit CSVs remain ignored. All 5,040 focused offline checks pass, including exact raw values and memberships, overlapping reasons, all cells/fields, neutral orientation, independent byte-identical reruns and atomic installation. Historical releases and the locked protocol remain unchanged. No histories, factors, ratings, fitting, scoring or outcome relationships were calculated.

SELECTION_UNRESOLVED, S02 paused, S08 provisional, canonical M05 and M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED persist. SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY, NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE and UNCERTAINTY_NOT_ESTABLISHED remain; no final-test performance claim follows from admission.

**Completed successor:** Phase 2AI below resolves conflict/claim scope without changing Phase 2AH's partial admission release or the locked protocol.

## Phase 2AI conflict and final-test scope review

The [review](docs/2025-source-conflict-review.md) records **RETAIN_2025_WTA_PM_EXCLUSIONS_FOR_LOCKED_TEST**, **RETAIN_2025_ATP_FORMAT_EXCLUSIONS_NO_MEMBERSHIP_EFFECT** and **LOCKED_PARTIAL_COHORT_MAY_PROCEED_WITH_SCOPED_CLAIMS**. Restricted context/reason checks verify 95 Canada and 95 Cincinnati PM rows: 182 sole-level exclusions and eight with independent exclusions. No saved identity, duplicate, surface, date, family or edition conflict accompanies their level conflicts. All six ATP Roland-Garros best_of=3 conflicts independently retain four retirement/two walkover exclusions. No outcomes, scores, count values or performance evidence were analyzed.

The locked protocol explicitly keeps 2025 PM conflicts excluded. Outcome-neutral context evidence cannot convert a post-access mapping into the original test; no exception or repair is implemented. A possible mapping is outside the primary test and cannot be recommended for implementation before it. No ATP cause or format exception is inferred.

The protocol requires twenty-cell inventory reporting, permits resolution of incomplete claim scope without loosening gates, and defines required folds over admitted batches. It does not require twenty populated admission cells for a conditional evaluation. Phase 2AH therefore remains 2025_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED with unchanged 1,878 admitted records: 1,011 ATP across ten cells and 867 WTA across eight. All future results must disclose excluded WTA Canada/Cincinnati and condition claims on this cohort and the later four-method common mask. No blanket ten-family WTA, complete-event or operational claim; all frozen readiness, comparison and failure gates still apply. This is no prediction-availability or performance result.

SELECTION_UNRESOLVED, S02 paused, S08 provisional, M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED and UNCERTAINTY_NOT_ESTABLISHED persist, with source-label/chronology limitations. Membership, raw sources, admission rules, protocol and historical releases remain unchanged.

**Completed successor:** Phase 2AJ below implements the approved membership inventory without changing the admission or claim-scope decision.

## Phase 2AJ locked 2025 candidate history membership

**2025_EVENT_BATCH_MEMBERSHIP_BUILT**, release 2AJ-1.0.0. The [audit](docs/2025-event-batch-membership-audit.md) accounts for all 1,878 targets / 3,756 neutral slots. Exact-player, same-tour memberships use all frozen admitted development and 2024 v2 records plus strictly earlier admitted 2025 source-date batches. Original IDs and three cohort-qualified namespaces coexist; equal-date events are simultaneous. Context-only readers skip outcomes, scores and statistical components. No admission or historical release changes.

Measured: 146,374 links and 102 empty placeholders. ATP has 68,604 links (23,435 development / 30,204 2024 / 14,965 earlier-2025) and 59 empty slots; WTA has 77,770 (39,213 / 26,738 / 11,819) and 43 empties. Median/maximum slot depths are 30/108 ATP and 39/163 WTA. All 105 eligible 2024 PM-context records contribute, totaling 3,533 links; the five historical Toronto retirements contribute zero. All 190 blocked 2025 WTA PM and six ATP format-conflict rows contribute zero.

There are eighteen admitted batches/cells, with all twenty expected cells retained in summaries. WTA Canada/Cincinnati each have zero targets and 95 exclusions; no full-ten-family WTA claim. Every output states **2025 locked source-label final-test sensitivity**, NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE and UNCERTAINTY_NOT_ESTABLISHED. Source-label timing/availability, missing 2022, unequal histories and official recall UNKNOWN remain. S02 paused, S08 provisional and the failed M05 cross-tour requirement remain binding.

The three ignored outputs are target-batches.csv, candidate-history-membership.csv and summary.csv. The 559 focused checks and four installed-output checks pass; no membership issue was found. No factor aggregation, rating, fitting, scoring, acquisition, dependency, OTD, portfolio or publication work occurred.

**Completed successor:** Phase 2AK below implements both approved constructions without fitting or scoring.

## Phase 2AK locked 2025 features and Elo

**2025_FEATURES_AND_ELO_CONSTRUCTED**, release 2AK-1.0.0. The [audit](docs/2025-feature-elo-construction-audit.md) pools all 146,374 frozen Phase 2AJ links into 3,756 slots / 1,878 targets and constructs both frozen Elo benchmarks. The complete development and Phase 2AE replays match saved bytes; combined terminal chains reconcile exactly, including untouched development states. No prior vector, admission or historical release changes.

Full-S08 both/one/neither strata are **951/60/0 ATP and 826/39/2 WTA**. Reduced-component completeness equals 951/826, with both candidates still restricted to full-S08-complete eligibility. Empty histories remain 59/43 slots; one additional ATP M12 zero denominator remains undefined. Six WTA M11 rates exceed one (maximum 1.1470588), uncapped. M05 stays lower-is-better with unreversed neutral differences. No imputation, window or weighting.

Both Elo probabilities are finite for all 1,878 targets, including 101 factor-incomplete targets. Overall/surface cold slots are 59/154 ATP and 43/106 WTA. Saved states continue without reset; initialization 1500, scale 400, K=32, blend 0.5G+0.5S and independent component expectations remain frozen. Every simultaneous batch uses pre-batch ratings and summed post-batch deltas. The 3,900 update rows balance within the existing 1e-10 tolerance; no clipping, fit, loss or calibration calculation occurs.

All twenty expected cells remain reported; WTA Canada/Cincinnati have zero targets. The 2025 locked source-label final-test sensitivity label, NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE, UNCERTAINTY_NOT_ESTABLISHED, S02 paused, S08 provisional and M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED remain binding. No full-panel WTA claim or final Four Factors qualification. Five ignored outputs are installed; 263 focused plus six installed-output checks pass, with historical artifacts preserved.

**Completed successor:** Phase 2AL fitted both frozen candidates and scored all four methods on the unchanged cohort ([results](docs/2025-locked-final-evaluation-results.md)). Surface Elo has lower locked-test log loss and Brier than both full S08 and reduced M03/M11/M12 in both tours, and every batch deletion holds that direction. Calibration comparisons are unresolved. No model is selected, and Four Factors receives no final qualification.

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
