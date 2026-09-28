# Phase 2B: Four Factors definition and selection protocol

**Decision: PROTOCOL_READY_FOR_DEVELOPMENT_EXPANSION.** Version 1.0.0, 2026-09-28. Approved authority: offline protocol design only. Final factors: NOT_SELECTED. Model fitting: NOT_AUTHORIZED. This document specifies future methods; none is fitted or executed here.

Starting state: clean main at `9986c03932af845e3e5bba96ceef79983481d50b`, `Audit Four Factors candidate metrics`. The flagship asks whether interpretable tennis factors explain player advantages and improve calibrated future forecasts relative to surface-adjusted Elo. Challenger promotion readiness remains deferred. The research repository owns analysis; portfolio integration remains separately authorized future work.

## Final success criteria

**Goals, not established findings:** seek four auditable, interpretable metrics representing distinct mechanisms, without exact or near duplication, with manageable multicollinearity, stable incremental information after the other factors enter, meaningful relationships with NPR and winning, and useful future-match interpretation. Require direction and usefulness to replicate separately in ATP and WTA, across relevant seasons, surfaces, events and out-of-time evaluation.

Zero correlation is neither realistic nor required. Practical independence means no algebraic duplication, no near-redundancy, manageable multicollinearity, distinct interpretation and stable incremental information; it is not a claim of probabilistic independence or causality. High same-match correlation alone is insufficient because candidates can share counts directly with NPR or match outcomes.

Serve Creation, Second-Serve Security, Return Pressure, and Conversion and Recovery remain hypothesis families, not guaranteed final factors. Normally use one auditable metric per mechanism. A composite factor requires separate justification and user approval because combining measures changes the Dean Oliver-style interpretability goal. Do not force one factor from each family. If evidence supports three mechanisms, report three; replace, remove, split or redefine a failed family only through a documented revision. See the durable [success criteria](../PROJECT_CONTEXT.md#final-four-factors-success-criteria).

## Current evidence versus the eventual goal

The unchanged [Phase 2A audit](four-factors-candidate-metric-feasibility.md) is evidence of computability and diagnostic limitations, not factor selection. Its saved aggregate tables were checked directly; no alternative candidate set was calculated in Phase 2B.

- Four pinned annuals are ATP/WTA 2021 and 2023 at archive `83733587353df8a41f2fd4f516147d5aa83f5a8d`. The 40 candidate cells contain 3,832 source rows; 37 remain UNVETTED_NONPILOT.
- Three hard-court convenience pilots: ATP/WTA Indian Wells 2023 and WTA Montreal 2021. They are not a representative modeling cohort. Inventory totals are 245, including 232 completed, 11 RET and two WO. One completed WTA bundle remains quarantined; 231 bundles are valid. Montreal retains 42 original plus seven separately recovered bundles, with 126 original omissions preserved.
- Fifteen candidate-difference columns have rank 10 in every reported matrix. Five exact identities are listed below. Full condition numbers are infinite; effective nonzero-subspace condition numbers are 34.51–42.25. Those effective values do not prove a reduced candidate set would pass a condition-index rule.
- ATP M05/M06 Pearson r is 0.9722. M08/M15 NPR correlations are 0.9822 ATP and 0.9946 WTA, largely mathematical decomposition. Equal-phase NPR is exactly 100*dM15 and 100*dM08.
- M12/M13 provide one identical difference dimension, not separate conversion and saving dimensions. Each has 12 zero-opportunity side values in ATP Indian Wells, four in WTA Indian Wells and none in Montreal. Common-complete samples are 79 ATP and 136 WTA matches.
- Surface stability: NOT_ASSESSABLE. Independent ATP season stability: NOT_ASSESSABLE. Independent WTA event-versus-season stability: NOT_ASSESSABLE. WTA event and season are confounded; ATP has one event-season.

Later success requires broader admitted development coverage, independent validation and chronologically valid forecasting evidence. No generalization, four independent mechanisms, causal interpretation or absence of overfitting is established.

## Algebraic equivalence classes

Use the unchanged [M01–M15 formula catalogue](post-otd-analytical-path.md#candidate-catalogue). For side i and opponent j, A=ace, D=df, S=svpt, I=1stIn, F=1stWon, Q=2ndWon, G=SvGms, B=bpFaced and V=bpSaved. `dMxx = Mxx_a - Mxx_b` on one outcome-neutral match row. Relations apply where all relevant denominators exist. Count symbols in each class refer to both sides unless stated otherwise.

| Class | Members | Exact relationship | Shared source counts | Hypothesis families | Coexistence and later representation rule | Role |
| --- | --- | --- | --- | --- | --- | --- |
| E1 | M03, M09 | dM03 = dM09; M09_i = 1-M03_j | F, I | Serve Creation; Return Pressure | First-serve success and opposing return success cannot be separate difference factors. Later choose the directly interpretable serve or return label for the declared mechanism under rule R below. | Narrower conditional point-outcome candidate; not benchmark-only by decree |
| E2 | M04, M10 | dM04 = dM10; M10_i = 1-M04_j | Q, S, I | Second-Serve Security; Return Pressure | Ordinary second-serve success and opposing return success cannot coexist as separate difference factors. Choose the declared mechanism's direct representation under R; include double faults in opportunities. | Narrower conditional point-outcome candidate |
| E3 | M08, M15 | dM08 = dM15; M08_i = 1-M15_j | S, F, Q | Return Pressure; Serve Creation | Broad return and service success cannot coexist as separate difference factors. Retain complementary labels for descriptive display only; choose one benchmark representation under R. | BENCHMARK_ONLY under this protocol; promotion requires a protocol revision |
| E4 | M11, M14 | dM11 = -dM14; M11_i = M14_j | B, G | Return Pressure; Conversion and Recovery | Chances created and pressure faced cannot count as two mechanisms. Choose generation or exposure framing under R, preserving its sign. | Exposure candidate; not recovery skill |
| E5 | M12, M13 | dM12 = dM13; M12_i = 1-M13_j | B, V | Conversion and Recovery | Conversion and saving cannot be separate difference factors. Choose one opportunity-conditioned framing under R; keep zero opportunities undefined. | Conditional conversion candidate, contingent on incremental information |
| E6 | M01 | Singleton; no exact pair identity established | A, S; ace wins overlap F+Q | Serve Creation | No within-class competitor. Retain ace-rate interpretation; do not call it all unreturned serves. Apply R if later alternatives are proposed. | Mechanistically narrower event rate, still outcome-coupled |
| E7 | M02 | Singleton; service-success mixture weight | I, S | Serve Creation | No within-class competitor. Retain first-in frequency and its quality/security tradeoff; apply R to any later alternative. | Frequency candidate, not pure serve quality |
| E8 | M05 | Singleton; M06_i = M05_i*(1-M02_i) | D, S, I | Second-Serve Security | Not exactly equivalent to M06. Compare alternatives under R and near-redundancy rules, not as an automatic second factor. | Conditional error rate |
| E9 | M06 | Singleton; same nonlinear relationship as E8 | D, S, with I through M02 | Second-Serve Security | Not exactly equivalent to M05. Later justify total-point burden versus conditional error interpretation under R. | Exposure-mixed error burden; alternative to M05 |
| E10 | M07 | Singleton; M04_i = M07_i*(1-M05_i) | Q, S, I, D | Second-Serve Security | Remains a non-double-fault sensitivity; cannot silently replace M04. R plus explicit approval is needed to promote or redefine it. | SENSITIVITY_ONLY under this protocol |

These are ten algebraic classes, not ten demonstrated mechanisms. Singleton status is not proof of independence. Exact duplicates or signed complements cannot both enter a candidate model or final factor set. This applies to the match-difference design; future player histories need fresh algebra checks because different opportunity weighting and windows may change the relationships. Do not assume a history transformation creates a distinct tennis mechanism.

**Rule R, fixed before comparison:** first require valid measurement and a distinct tennis interpretation; then prefer direct counts and a denominator matching that interpretation, auditable provenance, reliable opportunities, transparent missingness and stable measurement across intended contexts. If alternatives remain indistinguishable, retain them as mutually exclusive unresolved alternatives until an approved comparison resolves the choice. Never choose a representative by the largest observed correlation. No representatives are selected in Phase 2B.

Also preserve M15_i = M02_i*M03_i + (1-M02_i)*M04_i where defined. These nonlinear identities do not automatically become linear difference identities. Map shared numerators, denominators and part-whole relationships even when absolute correlation falls below a threshold.

## Candidate-role and comparison rules

Keep distinct labels for exact duplicate/complement, empirical near duplicate, broad outcome decomposition, narrower metric, exposure, opportunity-conditioned conversion, diagnostic benchmark and sensitivity-only alternative. A class can carry several labels; its name cannot determine admission.

M08/M15 remain broad service/return outcome benchmarks, not automatic final factors. They directly decompose equal-phase NPR, so no selection credit follows from perfect fit. Aces omit other unreturned serves; first-in frequency can trade off against serve quality; conditional success includes opponent/rally effects; break chances depend on opportunities and repeated deuce points. No unobserved tactical variable or fitted clutch proxy is invented.

Conversion and Recovery must show incremental information after general service and return performance and the other proposed factors are accounted for. Prespecify a separate benchmark-adjusted comparison and a future comparison using valid pre-match service/return histories; do not put both E3 representations into a model. If controls algebraically determine the outcome, mark incremental explanatory information NOT_IDENTIFIABLE_UNDER_DECOMPOSITION rather than interpreting a forced zero residual as a clutch finding. Distinct future information still has to be established. Without it, remove or replace the family. No residualization, control model or history is implemented now.

## Prespecified collinearity rules

The user supplied these boundaries before broader development fitting. They are diagnostic boundaries, not universal laws, and must not change merely because a favored candidate fails. Use Pearson and Spearman separately; a boundary reached by either triggers its review. Report exact pair counts, common-complete comparisons and all relevant slices. Isolated small-sample flags require an uncertainty/sufficiency review, not quiet exemption or a claim of passing.

| Diagnostic | Boundary | Required disposition |
| --- | --- | --- |
| Exact identity or signed complement | Any | Cannot coexist in a candidate model or final factor set |
| Absolute pairwise correlation | >= 0.95 | NEAR_REDUNDANT: cannot both enter the final four without a formally documented protocol revision |
| Absolute pairwise correlation | >= 0.90 | SENSITIVITY_WARNING: report the 0.90 warning band and compare mutually exclusive alternatives |
| Absolute pairwise correlation | >= 0.80 | PRACTICAL_REVIEW: review interpretation, shared counts and multivariable stability |
| Variance inflation factor | >= 5 | PRIMARY_CONCERN: stop automatic progression; review unstable coefficients/contributions |
| Variance inflation factor | >= 10 | UNACCEPTABLE: cannot pass without a protocol revision |
| Maximum standardized condition index | >= 30 | FAILURE_REVIEW: no pass until the cause is resolved and documented |
| Rank deficiency | Any | AUTOMATIC_FAILURE of that candidate set |

Apply the strongest applicable rule. Low pairwise correlations do not override a VIF, condition-index or rank failure. Report constant and near-constant columns and insufficient samples separately; neither is a zero-correlation pass. Do not use a generalized inverse, drop inconvenient rows, or change scaling to conceal rank deficiency.

Future calculations use a common analysis sample and centered, unit-standard-deviation predictors within tour and the prespecified surface context, with training-derived scaling reused on held-out data. Define VIF_j = 1/(1-R_j^2), where R_j^2 comes from regressing predictor j on the other predictors in the actual proposed design. Define condition indices as sqrt(lambda_max/lambda_j) of the standardized predictor cross-product matrix, excluding the intercept; the maximum equals the singular-value condition number for that design. Check the factor-only design and the actual design including prespecified adjustment covariates; report categorical coding and any intercept convention. No VIF regression is executed in Phase 2B.

ATP and WTA diagnostics are required separately. Pooled descriptive sensitivity may supplement them only with explicit tour/context handling and sample counts. Acceptability only after pooling does not satisfy the final goal. Check each sufficiently supported season/surface and event-omission sensitivity; insufficient slices remain NOT_ASSESSABLE. A protocol revision must name the failed rule, rationale, affected scope and new prospective validation plan and receive user approval before implementation.

## Association and incremental-value rules

| Outcome | Role | What it cannot establish |
| --- | --- | --- |
| Net Point Rating | Primary explanatory outcome; retain 100*(points won-points lost)/total points | Large same-match association does not establish distinctness, causality or forecasting |
| Equal-phase NPR | Sensitivity to unequal service-point opportunities | Its identity with 100*dM15 and 100*dM08 is not independent validation |
| Same-match win | Separate external same-match check, using verified winner and neutral orientation | Same-match statistics cannot serve as pre-match predictors |
| Future match win | Later chronological forecasting outcome, evaluated by log loss, Brier and calibration | Not available until identity, history, eligibility, cutoff and release gates pass |

High univariate correlation alone cannot select a factor. Retain lower-is-better signs; record expected direction before fitting, including M02's tradeoff caveat. Later require Pearson and rank associations, standardized multivariable coefficient direction, partial and semi-partial contributions, change in NPR R-squared, and stable information after all other proposed factors enter. Report both pairwise and common-complete samples so a sample change cannot masquerade as added information.

For a fixed cohort and fixed controls, the future leave-one-factor-out comparison uses semi-partial R-squared = R2_full - R2_without_j and partial R-squared = (R2_full - R2_without_j)/(1-R2_without_j), when defined. Preserve coefficient/partial-correlation signs alongside these nonnegative in-sample quantities. Neither a positive training increment nor an interval/p-value alone qualifies a factor. Held-out R-squared can decrease or be negative and must be reported without truncation.

For winning, prespecify paired model comparisons with/without each factor, reporting change in log loss and Brier score plus calibration. Define improvement as reduced held-out loss. Same-match binary associations remain descriptive; only properly lagged, cutoff-valid predictors may establish future value. Require no material degradation on the other primary loss/calibration criteria and repeatable incremental value under the prespecified comparison, rather than choosing whichever metric favors a candidate. A strong same-match association with no stable incremental or future value cannot qualify for the final framework.

Do not choose a post-hoc "high correlation" threshold. Before fitting, the later modeling specification must register a finite list of candidate sets, comparator models, meaningful NPR/R-squared and loss differences, acceptable calibration changes, sign-consistency criteria, precision targets and the decision treatment of inconclusive intervals. These practical margins require domain justification and user approval; they are not calibrated to the three pilots. Until registered, the scorecard remains PENDING_SPECIFICATION, not PASS. This is a prerequisite to fitting, not a blocker to planning broader development evidence.

Assess incremental information on identical evaluation matches and resamples; separately disclose extra coverage supplied by a missing-data method. Compare simpler subsets and plausible mutually exclusive alternatives, not just a full model against nothing. Require denominator, missingness, event-omission and influential-match sensitivities without selecting the most flattering result. Adjustment for opponent/schedule, surface, season and sample size must be specified using information valid for the declared explanatory or predictive estimand; those models are not approved for execution here.

## Dean Oliver-style weighting method

**SPECIFICATION_ONLY: no coefficients or empirical weights are calculated.** Begin later with interpretable ordinary multiple linear regression of NPR on standardized factor measures, separately for ATP and WTA. Keep NPR in its published units; a predictor-standardized coefficient expresses NPR points per training SD. If also standardizing NPR for a sensitivity, label that different coefficient scale. Scaling and all nuisance/adjustment specifications must be frozen for each comparison.

Distinguish raw unit-dependent coefficients, standardized conditional slopes, unique partial/semi-partial contribution, shared explained variance, total model R-squared and forecast performance. Raw coefficients are not importance weights. Standardized coefficients are not variance shares either. Negative coefficient direction is retained even when an explained-variance allocation is nonnegative; variance allocation is not causal importance.

Primary decomposition: exact Shapley/LMG allocation of model R-squared across all k! predictor orderings (24 for four factors; six if three are supported). On the same rows, scaling, outcome and model class, average each factor's incremental ordinary R-squared when added after its predecessors. Do not use stepwise order or choose the ordering giving desired weights. With fixed controls C, use v(S) = R2(C+S) - R2(C), keeping C in every subset model. The mean increments phi_j sum to R2(C+all factors) - R2(C). Without controls beyond the intercept, they sum to the factor model's total ordinary R-squared. Adjusted R-squared is not the allocation target.

Publish absolute R-squared contributions, the control-only contribution, full-model R-squared and unexplained variation separately. If the factor increment is positive, normalized shares are 100*phi_j/sum(phi), summing to 100% of that explicitly labeled factor-attributable increment. If the increment is zero or too uncertain to support normalization, shares are undefined; do not fabricate percentages. Shared variance is allocated transparently by averaging orderings, not ignored or described as uniquely explained by each factor.

Require uncertainty intervals for absolute contributions, normalized shares and their differences, obtained by repeating the entire permitted estimation/selection process within the approved resampling design. Distinguish conditional intervals for a fixed selected set from selection uncertainty; report selection frequency, failed resamples and absent factors rather than coding their absence as zero importance. Inference must preserve the same target and comparison rows within each replicate; held-out negative R-squared is reported separately and not normalized into explanatory weights.

Estimate weights separately for ATP and WTA; pooling requires later evidence and explicit approval. Check seasons, surfaces and reasonable model specifications, including rank ordering and overlapping intervals. Weights remain provisional until chronological validation, never tuned using 2025. The exact decomposition requires no new dependency in principle; any later dependency, implementation or method replacement needs approval.

## Stability and uncertainty plan

Follow this evidence hierarchy; an unavailable level does not inherit a pass from an earlier one:

1. Formula and measurement validity.
2. Nonredundancy.
3. Development-sample association.
4. Incremental multivariable information.
5. Stability across tours, seasons, surfaces and events.
6. 2024 validation and model selection.
7. Locked 2025 evaluation of the frozen pipeline.
8. Future forecasting comparison with surface-adjusted Elo.

Forecast development and 2024 comparisons must be designed before the freeze; the final evidence claim in steps 7–8 uses the already-frozen forecast comparison, not new tuning after 2025.

One match is the analytical unit. Preserve both opponents and outcome-neutral orientation; two player rows are not independent observations. Require slot-swap tests for formulas, predictions and attribution. Repeated players connect matches across events; matches within an event also share conditions. Resampling one player slot or clustering only player_a fails to represent that dependence. Naive independent-row p-values are prohibited.

The later modeling protocol must choose and justify an event-aware and player-aware resampling or clustered-uncertainty design before fitting. Require intact match pairs; event-edition clusters/blocks within appropriate tour-season/surface strata; explicit dependence for either shared opponent across events; and time-respecting outer evaluation slices. Event-only resampling is insufficient for recurring players. A dyadic/multiway player-and-event procedure or justified crossed-cluster bootstrap is a candidate, not a selected implementation. Validate it with synthetic dependence cases and document small-cluster limitations. Never resample future observations into an earlier training window.

Prespecify replicate count, seed, interval construction, sufficient event/player counts and precision goals in the later implementation specification. Report match, unique-player and event counts for every estimate. Repeat scaling, imputation and candidate selection inside each training/resample; preserve paired comparisons. Use leave-event-out, leave-season-out and supported surface/tour comparisons as stability evidence, not IID folds masquerading as forecasting. Within development, forecasting validation uses forward time and authorized historical information.

Report coefficient signs, association signs, selection frequency, attribution ranks, contribution/loss differences and intervals by slice and resample. Material sign reversal, rank changes or loss of incremental information in reasonable slices yields UNSTABLE, not an averaged universal weight. Imprecision yields INCONCLUSIVE or NOT_ASSESSABLE, not stability. Tour- or surface-specific results may be reported honestly but do not establish the universal framework; narrowing the claim requires user review.

## Missing-data and denominator plan

Preserve the categories structural missingness, genuinely sporadic missingness, eligibility-related missingness, zero opportunities, and invalid or quarantined bundles. Structural, eligibility, invalid and quarantined cases cannot be repaired through statistical imputation. Zero opportunities remain undefined, not a poor-performance zero and not an imputable opportunity. Unknown missingness causes remain unresolved rather than presumed sporadic.

Keep Phase 2A's whole-bundle rules and separate seven-match recovery authority unchanged. Statistical imputation cannot bypass source validation, quarantine, 90% event or 95% tour-season gates. A future sporadic-missingness comparison needs a separately approved modeling cohort and policy allowing incomplete otherwise valid predictor records; it cannot retroactively admit excluded Phase 2A bundles. Official evidence recovery remains distinct from imputation.

For genuinely sporadic predictor gaps later compare appropriate complete-case analysis, mean imputation, mean imputation with justified missingness indicators, and multiple imputation using predictive mean matching (PMM). No method is preselected. Fit every imputation procedure inside chronological training samples or resamples only. Validation and test data cannot influence fitted imputation rules, donor pools or model selection within an earlier training fold. Apply frozen training rules to held-out predictors without learning from held-out outcomes. Never impute outcomes; unavailable statistics never become zero. Predictor availability at the actual forecast cutoff still governs use.

Prespecify imputation units, allowable predictors/donors, bounds and count identities, number of imputations and pooling/uncertainty treatment before execution. Imputed raw counts must not violate integer/count-universe constraints; failed constraints block that method rather than prompting silent clipping. No PMM or mean implementation occurs in Phase 2B.

Compare selected classes, directions, collinearity, incremental contributions, uncertainty, normalized weights and chronological losses across all four methods. Use both a common evaluable cohort and separately labeled coverage results, with excluded counts and reasons. A factor depending on one imputation choice is METHOD_DEPENDENT and cannot receive a stable-factor pass without revision. Prefer the simplest method that meets the registered criteria; do not crown a method from the pilot.

Keep positive small denominators visible. A later minimum-volume, shrinkage or weighting rule needs a tennis/precision justification and a finite prespecified development comparison, not a cutoff chosen for favorable correlations. Report raw numerator/denominator availability and retained/excluded populations. Any new rule must preserve the original completed denominator and distinguish opportunity-based target restrictions from missing data. No eligibility threshold is introduced now.

## Chronological validation and overfitting controls

Development: **2021–2023**. Validation and model selection: **2024**. Locked final test: **2025**. Phase 2B accesses no 2022, 2024 or 2025 data. A documented future split grants no present access authority.

Pilot findings may shape hypotheses but cannot prove generalization. Algebraic equivalence reduction is allowed because it is mathematical, not performance tuning. Record empirically motivated changes as exploratory proposals; compare a finite, registered set only inside development and 2024 validation. Keep an unsuccessful-choice log. A new alternative requires a versioned rationale, user approval when changing method/scope, and a new prospective validation plan, not an indefinite search over a reused validation season.

Freeze the complete pipeline before inspecting 2025 results: eligibility, candidate formulas, deduplication, denominator rules, missing-data handling, scaling, factor selection, weight estimation, Elo settings, calibration, thresholds and sensitivity definitions. Record code/data versions, chosen set, comparison cohorts, seeds, dependency versions, practical margins, uncertainty design and the planned locked-test report. Hold out 2024 from every earlier fit except its separately authorized role in model selection; any final pre-2025 refit on development plus validation must itself be prespecified before the freeze.

A 2025 failure must be reported, not repaired and reevaluated on the same locked test as fresh evidence. A coding defect after freezing may be fixed only with disclosure, the original and corrected results/version history, and no use of the locked outcome to redesign the method. Hypotheses motivated by that test require new untouched evaluation evidence. Documented safeguards do not prove overfitting has been avoided.

Chronological forecasting still needs eligible identities, supported order, completion and historical availability at each cutoff. Source event dates, match numbers and retrieval dates are not substitutes. All 2,377 conditional dependencies remain unsupported. Match-sequential forecasting stays primary; no event-entry lag, K, inactivity rule, warm-up history or operational chronology is selected. Compare ranking, overall Elo, surface-adjusted Elo, factors, and Elo plus factors only under later authorization and a common eligible evaluation cohort.

## Factor-selection scorecard

Create no empirical scorecards now. The future record key includes candidate/class, formula version, role, tour, season/surface/event slice, sample/denominators, evaluation stage and evidence version. Each field stores its measure, uncertainty, evidence locator, status and reason. Allowed statuses are NOT_TESTED, NOT_ASSESSABLE, PENDING_SPECIFICATION, CONCERN, FAIL, UNSTABLE, INCONCLUSIVE, or PASS for a named stage. A development PASS is never a final-success label.

| Field | Required future evidence |
| --- | --- |
| Tennis interpretation | One distinct, explainable mechanism and known confounding |
| Measurement validity | Audited fields, universes, source provenance and pairing |
| Availability | Defined/eligible counts and origins in every intended slice |
| Denominator stability | Opportunity distribution and prespecified sensitivity |
| Exact redundancy | Algebraic class and no coexisting duplicate/complement |
| Near redundancy | Both correlation methods and 0.95/0.90 boundaries |
| Pairwise collinearity | 0.80 review plus shared numerator/denominator map |
| Multivariable collinearity | VIF, standardized condition indices, rank and design coding |
| NPR association | Direction, Pearson/rank effect, exact/common pair counts |
| Match-win association | Separate same-match external check, not forecasting |
| Incremental NPR information | Conditional direction, partial/semi-partial and held-out R-squared change |
| Incremental match-win information | Paired loss/calibration changes with valid predictors |
| ATP stability | Within-ATP replication, not a pooled substitute |
| WTA stability | Within-WTA replication, not a pooled substitute |
| Season stability | Independent supported season slices and forward evaluation |
| Surface stability | Hard/clay/grass where supported; otherwise explicit missing evidence |
| Event sensitivity | Leave-event-out and repeated-player dependence |
| Missing-data sensitivity | All approved sporadic-gap alternatives and sample changes |
| Uncertainty | Event/player-aware intervals, failed resamples and selection uncertainty |
| Future forecasting value | Chronologically held-out incremental utility and interpretable contribution |
| Decision and reason | Stage, failed gates, comparison alternatives and next evidence required |

No arbitrary total score. Decision precedence is: authority/eligibility and measurement validity first; interpretation and nonredundancy second; collinearity and denominator/missingness defensibility third; incremental information fourth; stability and uncertainty fifth; chronological validation and future utility last. Earlier failures cannot be compensated by a large correlation, weight or predictive score. Unavailable evidence blocks a final success claim without declaring a negative scientific result prematurely.

## Failure and revision rules

The later framework may conclude: FOUR_SUPPORTED, FEWER_THAN_FOUR_SUPPORTED, FAMILY_REPLACED, FAMILY_SPLIT_OR_REDEFINED, BENCHMARK_ONLY, or FRAMEWORK_NOT_SUPPORTED. These are permitted future outcomes, not current findings. Selecting a fifth proxy to preserve four labels is not a remedy.

Stop the four-factor success claim if fewer than four defensible distinct mechanisms survive development and validation; report the supported smaller framework rather than force four. Stop progression of any candidate set with persistent rank deficiency or unacceptable multicollinearity. Reject final qualification for no stable incremental relationship with NPR or winning, failure of signs/contributions to replicate, or dependence on one event, surface, season, imputation method or denominator choice. Distinguish true inconsistency from insufficient precision and unobserved comparisons.

If simpler baselines provide equal or better forecasting with no meaningful interpretability advantage from factors, report FRAMEWORK_NOT_SUPPORTED for the proposed scope. Comparable calibrated performance with independently justified clearer interpretation may still be useful; superiority to Elo on every measure is not required. The additional interpretation must be documented, not asserted to excuse any failed validity/nonredundancy gate.

A family split/redefinition, new field/proxy, composite, altered threshold, changed panel/split or statistical-method replacement requires a versioned proposal and user approval before implementation. Record the failure, all tested alternatives, reasoning, changed estimand and future validation implications. Do not revise thresholds to rescue a favorite or re-use 2025 as an untouched test. Stop the affected stage when required evidence is unavailable; do not fetch replacements without a new authorization.

## Authority matrix

| Area | Phase 2B state | Next authority or prerequisite |
| --- | --- | --- |
| Protocol and durable success criteria | APPROVED_DESIGN_ONLY | Implemented as documentation/tests, not empirical selection |
| Phase 2A evidence | FROZEN_UNCHANGED | Saved aggregates and baseline regression only; no new candidate calculations or output revisions |
| Broader development cohort | NOT_ADMITTED | Separate cell-specific inventory, status, provenance and coverage approval |
| 90% event / 95% tour-season gates | UNCHANGED | Event admission NOT_EVALUATED; tour-season NOT_TESTED |
| Final factors, coefficients and weights | NOT_IMPLEMENTED | Later modeling authorization and complete preregistration |
| Missing-data methods | SPECIFICATION_ONLY | Approved sporadic-gap cohort/rules, chronological fitting and method comparison |
| Q1/Q2/Q11 | PENDING_USER_APPROVAL | No contact, expansion or readiness bypass |
| Q3/Q4 | APPROVED_DOCUMENTATION_PREFLIGHT_ONLY | Completed Phase 1S scope; no remaining-slot authority |
| Q5/Q7/Q12 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY | Completed Phase 1R scope; no operational implementation |
| Q6/Q8/Q9/Q10 | PENDING_USER_APPROVAL | No forecasting role, lag, window or inactivity choice |
| OTD | PAUSED_BY_USER_AFTER_PHASE_1S | New explicit exact authorization and sufficient rights basis to resume |
| New data, 2022/2024/2025, search/network | NOT_AUTHORIZED | Separate scope and rights authorization; 2025 stays locked |
| Dependencies or structural changes | NOT_AUTHORIZED | Separate user approval |
| Elo, histories, forecasts, chronology | BLOCKED_NOT_IMPLEMENTED | Safe pre-match information and separate implementation approval |
| Publication and portfolio | BLOCKED_PENDING_RIGHTS_REVIEW | Reviewed outputs, rights and explicit integration request |

## Final decision and exact next approval

**PROTOCOL_READY_FOR_DEVELOPMENT_EXPANSION** means the selection rules are ready to guide planning and later implementation on a broader, properly admitted development cohort. It does not authorize acquisition, final factor selection, regression fitting, Elo, forecasting, imputation, 2024 access or 2025 access. Operational modeling details identified above must be registered and approved before any fitting; no final scientific success is declared.

The smallest next milestone is a bounded **offline development-cohort expansion readiness plan**, using existing 2021/2023 coverage and provenance to identify the exact missing inventory/status/rights evidence for broader season/surface coverage. Keep all 40 cells visible; do not promote the 37 unvetted cells, invent official denominators or name a best event from source counts alone. End with one proposed cell or bounded comparison set and its explicit prerequisites, or a blocked finding if none is supportable. Planning neither acquires evidence nor admits a cohort.

**Exact next user approval:** "Do you approve an offline development-cohort expansion readiness plan using only saved ATP/WTA 2021/2023 coverage, provenance and reference inventories, to identify the smallest bounded expansion and its missing status, measurement, coverage and rights prerequisites, without acquiring or searching for data, admitting new cells, calculating new metrics, selecting factors, fitting models or imputation, changing Phase 2A outputs, accessing 2022/2024/2025, resuming OTD or modifying the portfolio?"

Subsequent data acquisition, admission, preregistered practical-effect margins, resampling details, denominator policy, adjustment/history choices, dependencies, composites or implementation each need their applicable separate approval. Do not treat this protocol decision as blanket authority. The next task must finish with a response-only ChatGPT Handoff of no more than 2,000 words; do not invoke a handoff tool or create another task.

## Verification and historical reproduction

[R/test_four_factors_definition_protocol.R](../R/test_four_factors_definition_protocol.R) performs offline document/authority, mutation, saved-aggregate, pin and preservation checks. It executes no candidate calculation, regression, decomposition, imputation or acquisition and creates no research data output. [Status](status.md) records actual run results; [the data contract](data-source-contract.md) retains eligibility and rights boundaries. All method statements above are specifications, not execution claims.

Phase 2A pins PROJECT_CONTEXT.md at its earlier SHA-256. The authorized additive Phase 2B section changes that hash; the immutable Phase 2A entry point therefore fails closed against the new context. Do not rewrite its pins or outputs to hide this expected version boundary. Its full regression is run before that addition at the required baseline. Reproduce the frozen empirical audit with the baseline code/context and unchanged saved evidence in an isolated historical environment, not by resetting the user's current tree. Phase 2B tests separately verify the additive context change, unchanged historical code/reports and exact saved output hashes. A future current-context auditor would need a separately scoped version, not a silent modification of Phase 2A.
