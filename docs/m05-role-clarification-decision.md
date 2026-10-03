# Phase 2V: adopted M05 role clarification

## Decision and current terminology

**M05_ROLE_CLARIFICATION_ADOPTED.** Under the explicit Phase 2V instruction from clean `52146a38e776e6c3505f409994ae268fb168f238`, M05's canonical metric name in current and future work is **Double-Fault Rate per Second-Serve Opportunity**. This adopts the role clarification recommended by the [Phase 2U review](m05-factor-interpretation-review.md); it does not adopt a new factor, model or qualification result.

| Element | Adopted or preserved meaning |
| --- | --- |
| Canonical metric name | Double-Fault Rate per Second-Serve Opportunity |
| Metric identifier and code field | `M05`, unchanged; existing variables and columns retain their names |
| Formula | Own double faults / own second-serve opportunities; the saved count denominator is own service points minus own first serves in |
| Performance orientation | Lower is better for this error-rate component |
| Construct | One error component of second-serve performance; not total second-serve effectiveness, aggression or comprehensive security |
| Candidate family | Second-Serve Security, unchanged; a broad candidate family is not the name or validated scope of one metric |
| Historical aggregation | Pool eligible earlier-batch own counts before dividing; preserve existing undefined denominators and empty histories |
| Neutral comparison | Existing A-minus-B differences, including the `dM05` field, remain unchanged |
| Status | S02 paused; S08 provisional; no M05 or other factor-status change |

Use the canonical name when newly describing the metric, even when displaying an unchanged `M05` code field. Use Second-Serve Security when referring to the broader candidate family. Do not use either the family name or a fitted coefficient to imply that M05 measures every aspect of second-serve performance. The name change introduces no transformation, complement, sign flip, rescaling, alternative denominator, threshold or imputation.

## Performance meaning versus forecast evidence

The performance interpretation concerns the frequency of a specific observed error conditional on a second-serve opportunity. It does not claim that minimizing this rate alone maximizes overall effectiveness or winning. Other outcomes after successfully putting a serve in play are outside this numerator.

The forecast association remains **tour-specific and unqualified**. All four saved ATP Phase 2R M05 coefficients are negative; all fourteen WTA coefficients are positive. The expected negative performance direction remains unchanged. Positive WTA coefficients do not imply that double faults improve performance. Neither changing the metric's display name nor separating its roles resolves the forecast direction conflict, establishes stable usefulness, or qualifies M05. Coefficients remain conditional forecast parameters, not performance weights or causal effects.

The [Phase 2J report](broader-shortlist-revalidation.md#numerical-gates-and-descriptive-npr-fits) provides supporting contemporaneous evidence: S08 M05 NPR slopes are −0.978541 ATP / −1.448609 WTA, with full-minus-reduced R² increments 0.006606 / 0.009638. These are same-match findings, not future-value evidence. The [Phase 2R report](s08-paired-evaluation-results.md#readiness-and-coverage) records the opposite tour directions despite passing numerical safeguards. The [Phase 2T diagnostic](m05-direction-diagnostic.md#conclusion-and-scope) verifies frozen ownership/scaling arithmetic and identifies the descriptive pattern without establishing its cause. The [Phase 2U evidence matrix](m05-factor-interpretation-review.md#evidence-matrix) distinguishes direct measurement, contemporaneous increments and unqualified forecasting; this clarification implements only its proposed label/role distinction.

The remaining scientific question is whether M05 supplies useful incremental future-match information beyond M03, M11 and M12 on the authorized development cohort. Frozen S08-versus-Elo results do not isolate that contribution. No final pass, superiority claim, sign constraint, replacement, family redefinition or automatic tour-specific exception follows. Existing direction, incremental-information, stability, uncertainty and validation requirements remain in force.

## Historical and operational boundaries

Historical reports, code, coefficients, probabilities, results, raw/effective counts, memberships, exclusions and output fingerprints remain byte-for-byte unchanged. Prior terminology in those reports records the language used at the time; it is not current naming authority. Existing historical headings, file names, variables and columns are not renamed. New explanatory text can identify legacy terminology by reference to this decision without rewriting a historical release. Historical test authority pins are not repinned to the new documents, and historical suites are not rerun.

The Phase 2U terminology proposal is now adopted, but its unresolved scientific concerns are not closed. **UNCERTAINTY_NOT_ESTABLISHED**, **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** remain. Missing 2022, unequal histories, dependent observations and unverified timing/availability remain limitations. The 2024 validation and locked 2025 test boundaries are untouched. No code, generated output, fit, tuning, new statistic, threshold, dependency, acquisition, OTD resumption, portfolio modification or publication occurs in Phase 2V.

## One next executable scientific phase

Recommend **Phase 2W: bounded development-only M05 ablation**, meaning a comparison that omits just M05. The purpose is to measure its incremental forecast contribution before deciding whether a future validation candidate should retain it. This is a recommendation for separately authorized implementation, not fitting authority from this decision.

The bounded comparison should reuse frozen Phase 2R full-S08 predictions and fit only one reduced specification per ready fold: M03 + M11 + M12, separately by tour, zero intercept and training-fold sample-SD-only scaling. Use the exact eighteen saved full-model training ID sets and earlier-batch cutoffs, without expanding the training sample when M05 is omitted. Retain all 2,580 targets in coverage and use the frozen 1,278 scored IDs as the comparison universe; score only identical IDs with finite predictions from both specifications and disclose every reduced-fold failure. No extra complete-case cohort or extra forecast batch is created to favor the reduced model.

Preserve the existing readiness, numerical and fit safeguards, with the design-rank check explicitly adapted to three predictors for the proposed reduced model. Withhold failed folds without rescue. Report full-S08 minus reduced-model paired log-loss and Brier differences (negative favors retaining M05), supported calibration diagnostics under existing gates, and frozen-score batch/player deletion influence without refitting for those deletions. Keep uncertainty unestablished, no intervals or p-values, no practical-effect threshold and no automatic factor/model selection. A numerical gain would not cure the WTA performance-direction conflict or grant final qualification; a lack of gain would inform the scientific decision without imposing an invented cutoff.

The next prompt must define exact implementation files, ignored outputs, preservation checks and focused validation for training IDs, rank-three handling, cutoffs, slot symmetry, common masks, failures and deterministic reproduction. No family search, replacement metric, parameter grid, new source, window or 2024/2025 access belongs in that phase.

Exact approval: **“Approve Phase 2W: implement a bounded development-only M05 ablation against frozen Phase 2R S08 predictions. Fit only the M03/M11/M12 reduced model on the same training IDs and cutoffs, preserving safeguards with rank three. Report identical-ID paired losses, coverage and failure reasons without tuning, new thresholds, factor-status changes, acquisition or 2024/2025 access. Retain UNCERTAINTY_NOT_ESTABLISHED.”**

## Verification

Checked the cited Phase 2J NPR coefficients/increments against frozen artifact rows, all eighteen Phase 2R/2T M05 coefficient/SD pairs and their tour directions, and the Phase 2U review against the starting commit. All fourteen Phase 2J/2R/2T release-output hashes match the frozen reports. No statistics were recomputed. Current-document agreement, 28 local links/anchors, whitespace, exact four-file scope and unchanged existing historical headings pass. Historical status/contract bodies are preserved apart from the current/completed contract label. All 306 other pre-existing tracked files and pilot artifacts retain their SHA-256 hashes, including all historical reports; no code or generated output was created. The diff was inspected. Historical suites were not rerun or repinned.
