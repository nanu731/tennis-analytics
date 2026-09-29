# Phase 2O: surface Elo and common-evaluation specification

Version 1.0.0. Documentation completed from clean `main` at `3e181b4134e73a487523da570e1330d825b2115a`. This is **one recommended specification awaiting implementation approval**, not an implemented rating system or an empirical parameter selection. The [Phase 2L convention](source-label-event-batching-decision.md) governs it: **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**. Phase 2K remains **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**.

## Authority, evidence and Occam choice

The [project Elo and Occam rules](../PROJECT_CONTEXT.md#elo-benchmark) call for an interpretable overall/surface benchmark with no unearned complexity. [Phase 2N](s08-batched-history-aggregation.md) supplies frozen S08 features and availability; [Phase 2M](event-batch-membership-audit.md) supplies neutral targets, batch labels and eligible history membership. Neither establishes optimal Elo initialization, K, scale or blending. No saved outcome or performance evidence was inspected to choose these parameters.

**Fixed benchmark conventions:** 1500 initial ratings, the base-10 logistic probability with a 400-point scale, K=32 for both components, a constant 50:50 blend of ratings, and independent component updates. These values are transparent starting choices, not evidence-supported optima, calibrated probabilities or established tennis-specific corrections. Equal initialization encodes no prior player ranking; the shared additive level is arbitrary because probabilities use differences. The equal-weight blend supplies simple partial pooling toward overall strength without an estimated weight or a history-dependent rule.

**Evidence-supported constraints:** frozen admission/exclusions, separate tours, strictly earlier source-label batches, same-date simultaneity, undefined S08 opportunities and the measured availability partitions. Actual completion/availability timing remains unverified. The inspected saved evidence does not establish a necessary round, prestige, margin-of-victory, inactivity, time-decay or best-of format correction. Include none of these in the initial baseline. No ranking, seed, age, experience-dependent K, shrinkage schedule, rating cap or season reset is added.

## One primary specification

Maintain independent rating states keyed by `(tour, player_id)` for overall rating G and `(tour, player_id, surface)` for surface rating S. Use the frozen Hard, Clay and Grass labels without inferring or merging surfaces. ATP and WTA never share state or parameters learned from outcomes; the same fixed conventions apply to both.

| Component | Recommended convention |
| --- | --- |
| Initial overall rating | G=1500 before the player's first admitted batch in that tour |
| Initial surface rating | S=1500 on every surface until an admitted result on that surface updates it |
| Scale and probability | `P(A beats B \| R)=1/(1+10^((R_B-R_A)/400))`; `P(B)=1-P(A)` |
| Overall update factor | K=32, constant per admitted match |
| Surface update factor | K=32, constant per admitted match on that surface |
| Primary blended rating | `R=0.5*G+0.5*S` for the target surface |
| Sole sensitivity | Overall-only probability from G (surface weight zero), with identical G state, K, targets and cutoffs |

The primary probability is the logistic transform of the **blended rating difference**, not an average of overall and surface probabilities. Surface states are independent of G after initialization: do not copy the current G into an unseen surface or change S when another surface is played. The fixed blend already supplies overall information. No additional cold-surface fallback is used. Component surface probabilities exist only for update/audit arithmetic, not a second sensitivity comparison.

Carry state between authorized seasons without reset, decay or elapsed-time adjustment. In this cohort WTA 2023 carries admitted 2021 updates; no 2022 result is manufactured. ATP starts within its saved 2023 panel, not at the beginning of a player's career. Missing pre-panel and out-of-panel matches remain missing.

## Exact synchronous arithmetic

For each tour, process batch keys `(tour, source tourney_date)` by increasing source label. Group all same-tour, same-date events together, regardless of event or surface. Unknown, invalid or conflicting labels/surfaces must fail closed without replacing them or shrinking the target cohort. Labels do not establish verified dates or historical availability.

For a batch b, initialize unseen player/surface states at 1500, then freeze **all pre-batch states** G^- and S^-. For each admitted match m on surface s, retain neutral slots A and B and define y_A=1 if A won, otherwise 0; y_B=1-y_A. A target outcome is used only in the post-batch update, never its own probability.

- Overall expectation: `p_G=1/(1+10^((G_B^- - G_A^-)/400))`. Overall deltas: `delta_G,A=32*(y_A-p_G)`; `delta_G,B=-delta_G,A`.
- Surface expectation: `p_S=1/(1+10^((S_B,s^- - S_A,s^-)/400))`. Surface deltas: `delta_S,A=32*(y_A-p_S)`; `delta_S,B=-delta_S,A`.
- Primary pre-batch probability uses `R_A^-=0.5*G_A^-+0.5*S_A,s^-` and the corresponding B rating. Do **not** substitute this blended probability for either component's update expectation.
- After every match in the simultaneous batch has been accounted for, apply `G_i^+=G_i^-+sum_m(delta_G,i,m)`, summing **all** admitted batch matches containing i. Apply `S_i,s^+=S_i,s^-+sum_(m on s)(delta_S,i,m)`. Untouched surface states retain their prior value.

Sum deltas; do not average them by matches played, divide K by batch size, clip the accumulated change or run a hidden sequential update after the batch. A player appearing in several same-date events reads the same frozen state in every match. Overall deltas include every surface represented in that batch, while surface deltas remain within each surface. No later round receives updated ratings from an earlier round of its own batch.

The arithmetic is invariant to match/event order. A later implementation must use a canonical match-ID order solely for deterministic floating-point summation; it is not a chronology substitution. Test row/event permutations, player-slot probability complements and delta signs, zero-sum component updates, same-date multi-event/multi-surface fixtures and later-batch perturbations. Accumulated changes can be larger for players with many admitted matches; this is disclosed behavior, not authorization for an adaptive correction.

## Cold starts and complete accounting

An unseen player receives the fixed G/S priors. If both players have no admitted earlier results, the primary and overall-only probabilities are 0.5. If one player is new, compare that prior with the opponent's frozen state; do not force 0.5. A previously observed player with no results on the target surface retains S=1500 and uses the same blend. Record both overall and target-surface prior-match counts and cold-start flags, without choosing minimum-history thresholds.

These are explicit **Elo initialization conventions**, not S08 imputation. Preserve all Phase 2N undefined values and reasons. A complete S08 player history means all four saved M03/M05/M11/M12 rates are finite; nonempty history alone is insufficient because M12 can have zero opportunities. No target is removed from the reporting universe.

| Tour | All-target Elo reporting | Both S08 histories complete (common feature cohort) | Exactly one complete | Neither complete |
| --- | ---: | ---: | ---: | ---: |
| ATP | 846 | 612 | 103 | 131 |
| WTA | 1,734 | 1,414 | 181 | 139 |
| Total | 2,580 | 2,026 | 284 | 270 |

**Verified availability, not Elo results:** these strata were counted from the unchanged, SHA-256-verified Phase 2N target feature file (`b5f78b4d905a43d6c4685bde1543121f4addae43457bbb2f8f4e6825d0eccb00`), using only slot feature completeness; its saved complete-vector flag agrees. No match outcomes were loaded. The 554 targets outside the common feature cohort remain reported. Retain empty-history versus zero-opportunity reasons, including overlaps; these three mutually exclusive strata are not the earlier both/one/neither-*empty* strata.

The **all-target Elo reporting cohort** is all 2,580 admitted targets, including initialized players and incomplete S08 histories. A correctly implemented fixed Elo should assign a finite probability to each; any failure is an implementation blocker, not permission to delete a row. Subsequent scoring requires its own authorization. All admitted results may update later Elo states, including matches outside the common S08 feature cohort. S08 likewise uses its unchanged all-admitted earlier-batch inventory. Do not train/replay Elo on only the 2,026 common targets.

The **common feature cohort** is the 2,026 targets with complete four-feature A-minus-B differences, 612 ATP and 1,414 WTA. Any later Four Factors versus Elo performance comparison must use identical match IDs and held-out folds, identical source-label cutoffs and identical outcome definitions. Report Elo separately on all targets and on the common cohort; never compare all-target Elo scores with common-only S08 scores as evidence of superiority.

The common feature cohort is not yet a scored or model-ready sample: S08 forecast coefficients, training sufficiency, fold schedule and failure handling are unimplemented. A later paired scored cohort must intersect common-feature availability with predeclared chronological training/prediction readiness. Report every further nonprediction and reason against the full 2,580 denominator, and score both methods on exactly the same retained IDs. Do not silently call a smaller scored sample the full 2,026 common cohort. Missing S08 predictions cannot be replaced with initialized rates, zeros or Elo predictions.

Report availability and later authorized scores separately by tour, season, batch, event, surface and all three S08-completeness strata; keep neutral-slot and cause-specific counts. Use both the all-target and applicable stratum denominators. Coverage means retention/prediction availability within this source-defined cohort, not official event recall. Later scores prioritize calibration, Brier score and log loss; accuracy and ROC AUC remain secondary. No scores, reliability curves or uncertainty estimates are computed here.

## Parameter-selection limits and unresolved choices

Freeze this primary and the **single overall-only sensitivity** before rating implementation. No K/blend/initialization grid, tour-specific parameter search, alternate history window or correction is authorized. No outcome inspection selected the recommended constants. The sensitivity isolates the surface blend's contribution with no extra rating state or fitted parameter; higher development fit alone cannot promote it or justify a claim about future value.

Any later tuning or learned preprocessing must occur only inside chronological training folds of an explicitly approved development protocol, with whole simultaneous batches assigned together. Hyperparameters, feature scaling, S08 coefficients and changes to the benchmark cannot use held-out fold outcomes. Fold-specific replay must use only earlier batches. After a held-out batch is predicted, its admitted results may enter later state updates under a prespecified sequential evaluation protocol; that is updating state, not refitting/tuning on held-out results. Never use an aggregate held-out score to adapt the ongoing fold's parameters.

Preserve development **2021–2023**, **2024 validation/model selection**, and **2025 locked final test**. Future 2024 comparison may select among already frozen candidates under separate authorization; it cannot be recycled as their training data while reporting the same predictions as validation. Freeze the full pipeline before any 2025 inspection. Neither 2024 nor 2025 is opened or newly authorized here. Missing 2022 and unequal history depth remain constraints, not reasons to change the split.

**User decisions still required:** approve these fixed conventions and the scoped implementation; later approve the S08 forecast model, chronological folds, training sufficiency and paired scoring/uncertainty protocol. No defensible player/event-aware uncertainty method is established by this specification. An approved method change would require a new named problem or stable chronological evidence, a documented decision and a separate scope—not automatic expansion of this task. S02 stays paused; S08 stays provisional; no final weights or factor qualification follow.

## Next executable phase and historical boundary

Recommend **Phase 2P: offline synchronous Elo implementation and probability/coverage audit only**, over the frozen 2,580 targets. Emit frozen pre-batch component/blended ratings, primary and overall-only probabilities, accumulated component updates and S08 availability strata under an exact future file/output scope. Validate formulas, initialization, zero-sum updates, strict cutoffs, synchronous accumulation, permutations, slot complements, exclusion preservation, complete accounting, deterministic reruns and ignored outputs. Do not fit S08 or score/tune either method in that phase.

Exact approval language: **“Approve Phase 2P: implement the Phase 2O fixed Elo specification offline in base R: 1500 overall/surface priors, 400-point logistic scale, K=32 for independent overall/surface updates, a 50:50 rating blend and the sole overall-only sensitivity. Sum deltas from frozen pre-batch states and apply them after each complete simultaneous batch. Preserve all 2,580 targets, frozen exclusions and S08 completeness strata. Produce a probability/coverage audit under SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY. Do not tune, score performance, fit S08, impute, acquire data, infer timestamps, access 2024/2025 or modify the portfolio.”** The next prompt must specify exact tracked and ignored-output scope.

This phase updates current guidance in PROJECT_CONTEXT.md, status and contract; completed phase reports and their recommendations remain historical evidence. Because PROJECT_CONTEXT.md changes, earlier suites that pin its historical bytes must not be rerun against the new version or silently repinned. Future implementation must pin this new authority and the unchanged prior releases, isolating any reused pure definitions from historical runners. No code, generated output, rating, model, dependency or portfolio change is created here.

## Validation record

**89 focused documentation/availability checks passed**, including seven local links and the Elo-section anchor, matching constants/formulas/cutoffs/cohorts across current documents, exact four-file scope, whitespace and unchanged historical status/contract content (apart from the contract current/completed label). The saved feature hash was verified; independent completeness and reason-flag counts agreed. Availability strata are read-only verification of saved features, not parameter fitting. A wording-only assertion initially expected the literal phrase “not implemented”; it was corrected to recognize the decision’s explicit “awaiting implementation approval” boundary, with no specification change.

All **281 other pre-existing tracked files and pilot artifacts retain their SHA-256 hashes**. The only new file is this decision; no generated output was added or changed. The full diff was inspected. No ratings, outcome-driven choices, empirical/historical suites, acquisition, dependencies, 2024/2025 access or portfolio changes occurred. This validation checks the specification and saved availability, not unimplemented rating arithmetic.
