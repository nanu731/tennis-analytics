# Phase 2AI: locked 2025 source-conflict review

## Decisions and evidence boundary

From clean `2d5438d1f93d347b14bbf98dc49342aa494488eb`, using saved context, disposition reasons and the unchanged [locked protocol](2025-locked-final-test-protocol.md):

- **RETAIN_2025_WTA_PM_EXCLUSIONS_FOR_LOCKED_TEST**.
- **RETAIN_2025_ATP_FORMAT_EXCLUSIONS_NO_MEMBERSHIP_EFFECT**.
- **LOCKED_PARTIAL_COHORT_MAY_PROCEED_WITH_SCOPED_CLAIMS**.

These are governance decisions, not a revised admission release or authorization to model. [Phase 2AH](2025-source-admission-audit.md) remains 2025_SOURCE_COHORT_PARTIAL_REVIEW_REQUIRED with exactly 1,878 admitted records and eighteen admitted cells. No source, rule, membership or historical artifact changes. The expected panel remains twenty cells, including the two wholly excluded WTA contexts.

Read-only verification selected only audit/source identifiers, tour/year, event/cell, tournament name/ID/date label, surface, level, best-of label, membership and reason fields. All other CSV columns were skipped using base-R column selection; no player outcome, score, count component, prediction or performance relationship was inspected or analyzed. Retirement/walkover and missing-bundle findings below come only from saved exclusion tokens, not fresh parsing of scores or statistics. Preservation checks hash opaque file bytes without interpreting their contents. No acquisition, admission runner or historical test suite was executed; no code or generated output was created.

## WTA context and independent exclusions

| Saved context | Canada | Cincinnati |
| --- | --- | --- |
| Source ID / name | 2025-806 / Montreal | 2025-1017 / Cincinnati |
| Source date label | 20250727 | 20250807 |
| Surface / literal level | Hard / PM | Hard / PM |
| Conflicted rows | 95 | 95 |
| Sole exclusion level_conflict | 93 | 89 |
| Independent exclusions as well | 2 | 6 |
| Admitted from this context | 0 | 0 |

The 190 unique source-row locators reconcile to the raw context fields, including unchanged literal PM. Every context reason is exactly level_conflict; identity and duplicate reason fields are empty. The saved audit therefore records no competing identity, duplicate, surface, date-label, event-family or edition conflict in these contexts. This verifies the frozen audit's findings; it does not independently resolve identities, establish official category semantics or verify actual event timing.

The eight independently excluded rows consist of Canada one retirement and one walkover; Cincinnati four walkovers and two rows with missing-bundle/reconciliation-not-evaluable reasons. Thus 182 level-only plus eight independently excluded equals 190. Every reviewed row is EXCLUDED and absent from the frozen membership. No membership counterfactual is implemented and no claim that all 190 could become eligible is made.

Protocol precedence is explicit. Under [Frozen panel and admission](2025-locked-final-test-protocol.md#frozen-panel-and-admission):

> A 2025 PM conflict stays excluded.

> Any proposed rule/source/parser change requires separate review and would fall outside this locked protocol; do not apply it to obtain a passing final-test result.

The [2024 decision](2024-wta-pm-context-decision.md#decision-and-scope) used an exact year key of 2024. It neither supplies a 2025 exception nor establishes PM=P globally. Even outcome-neutral evidence linking 2025 source contexts to Canada/Cincinnati cannot make a post-access eligibility change part of the pre-access locked specification. The block is retained because the frozen rule requires it, not because this review found a new identity problem.

An exact WTA/2025/Canada-or-Cincinnati/PM mapping could only be a separately authorized and separately labeled **post-lock sensitivity outside the primary locked test**. It is not recommended for implementation before the primary locked test, cannot repair or replace this cohort, and receives no implementation approval here. PM's semantic meaning remains unestablished; preserve the literal value.

## ATP format conflicts

All six reviewed ATP Roland-Garros records retain raw best_of=3 and context reason match_format_conflict. Source-row joins verify that label unchanged. Their saved independent reasons are four excluded_status:retirement and two excluded_status:walkover; every row remains EXCLUDED and absent from membership.

**RETAIN_2025_ATP_FORMAT_EXCLUSIONS_NO_MEMBERSHIP_EFFECT** means leaving the format conflict untouched cannot remove an otherwise eligible row from the existing admitted cohort: all six already have independent exclusions. It does not approve removing the format reason, changing best_of or rerunning admission. No cause is inferred from the status co-occurrence and no format exception is created.

## Why the partial cohort may proceed

The frozen protocol separates the expected inventory panel from admitted evaluation targets. Its controlling passages are:

| Frozen authority | Exact text | Consequence for this review |
| --- | --- | --- |
| [Frozen panel and admission](2025-locked-final-test-protocol.md#frozen-panel-and-admission) | “Report annual/panel/admitted/excluded counts, all exclusion reasons, count availability, all twenty cells including absent/wholly blocked cells, and supported round/surface breakdowns.” | Twenty cells remain in reporting; admitted status for every cell is not stated as an evaluation prerequisite. |
| Same section | “Do not shrink the planned panel to conceal missing evidence.” | Keep both blocked WTA cells visible; do not redefine the panel as eight WTA families. |
| Same section | “An incomplete/blocked acquisition or admission review cannot support a blanket panel-wide conclusion; resolve its scope before any separately authorized modeling, without loosening gates.” | This review resolves claim scope while retaining every gate and exclusion. Blanket panel-wide claims remain prohibited. |
| [Common evaluation and final loss conclusions](2025-locked-final-test-protocol.md#common-evaluation-and-final-loss-conclusions) | “Retain every admitted 2025 target in coverage, with both/one/neither complete-S08 slot strata and model-specific availability/failure reasons.” | Coverage starts from the frozen admitted cohort, not a requirement to manufacture admissions in blocked cells. |
| Same section | “Required folds are every admitted 2025 tour/source-date batch fixed before fitting, including batches with no complete targets; both factor models and all required input/Elo/prediction numerical gates must pass.” | All eventual admitted batches remain required; no gate or failed fold may be dropped to obtain a passing result. |

The full locked protocol contains no rule requiring all twenty cells to contain admissions as a condition of this conditional evaluation. Its requirement is to report the planned panel honestly, resolve incomplete scope and evaluate admitted targets under every frozen gate. The acquisition audit's stricter all-cells-populated condition for its ready label is not silently substituted or waived: **its partial-review label stays unchanged**. Both files were verified, neither tour is missing, and the frozen membership contains 1,011 ATP records across ten cells and 867 WTA records across eight cells. All 1,878 membership IDs match the existing INCLUDED dispositions, with none of the 196 reviewed conflicts present.

Accordingly choose **LOCKED_PARTIAL_COHORT_MAY_PROCEED_WITH_SCOPED_CLAIMS**, conditional on later separate implementation approvals. This resolves the scope question anticipated by the original protocol; it changes no eligibility or scientific method. It is not a declaration that future readiness, common-mask availability, calibration support or final comparison gates will pass. Any later missing comparison, failed required gate or unevaluable deletion retains the frozen unresolved consequence.

## Mandatory scope of every final result

Every final results table, chart, comparison label and narrative must display or directly accompany this disclosure:

> Conditional on the unchanged Phase 2AH source-defined cohort: 1,878 admitted records, comprising 1,011 ATP records across ten admitted event cells and 867 WTA records across eight. WTA Canada and Cincinnati are wholly excluded by the frozen 2025 PM rule. The expected twenty-cell panel remains reported; the final paired evaluation may be smaller under the frozen common mask.

Retain the complete twenty-cell inventory and all 2,156 observed panel records in admission/coverage reporting, including 278 exclusions and the two zero-admission WTA cells. Preserve all 1,878 admitted targets in later model-availability reporting. Report actual paired IDs/counts separately and identically for full S08, reduced and both Elo methods; no availability or prediction count is established here.

Permitted final conclusions concern only the actual common-mask records within this unchanged source-defined cohort, separately by tour and under the source-label batching assumption. No claim may cover the full ten-family WTA panel, the excluded 2025 Canada/Cincinnati contexts, complete official tournament coverage, all 2025 tennis or operational forecasting. Apply this scope even to any favorable locked loss/calibration label. Missing 2025 contexts also limit subsequent eligible histories; their excluded rows cannot contribute to updates. Previously admitted development/2024 records remain governed by their own frozen releases and the existing carry-forward policy.

Official recall remains UNKNOWN. SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY, NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE and UNCERTAINTY_NOT_ESTABLISHED persist. SELECTION_UNRESOLVED retains full S08 and reduced scientific roles and both frozen Elo comparators. S02 paused, S08 provisional; M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED still prevents final Four Factors qualification. No superiority claim, interval, outcome relationship or final-test result is established by this review.

## Verification and preservation

Restricted-column base-R checks passed for all 190 WTA and six ATP context conflicts, unique source-row accounting, 95/95 and 182/8 splits, independent retirement/walkover/missing-bundle reason groups, empty saved identity/duplicate reasons, literal PM and best-of raw joins, and exact unchanged 1,878-ID membership with 10 ATP / 8 WTA admitted cells. No restricted analytical field was loaded for these checks.

All seven quoted protocol passages match the saved locked document exactly. Its distinction between twenty-cell inventory reporting and admitted-batch evaluation was checked across the full protocol; no all-twenty-admitted gate was found or weakened. Current decisions agree across the review, project context, current status and current contract boundary. All 45 local links/anchors, whitespace and exact four-file scope pass; the full documentation diff was inspected.

All 389 other historical files/artifacts retain SHA-256 fingerprints, including the locked protocol, Phase 2AH code/tests/manifest/report, four acquired raw/metadata files and six outputs. Output hashes also match the unchanged Phase 2AH report. The historical status suffix and prior contract body remain intact apart from marking its prior current header completed. No admission rerun, historical test execution, new code/data/output, mapping, repair, exception, model or source request occurred.

## One bounded next approval

Recommend **Phase 2AJ: batch-key and candidate-history membership construction only** for the unchanged 1,878 admitted 2025 records. Reuse the frozen tour/source-date batch convention, simultaneous same-date events, neutral slots, exact source IDs, admitted development/2024 records and strictly earlier admitted 2025 records; preserve explicit empty histories and exclusions. Do not aggregate any features or build rating/model states. A subsequent prompt must specify its exact implementation/output scope and focused tests.

Exact approval: **“Approve Phase 2AJ: construct and audit only source-label batch keys and candidate-history memberships for the unchanged 1,878 Phase 2AH admitted 2025 records. Use frozen admitted development/2024 records and strictly earlier admitted same-tour 2025 batches; preserve simultaneous dates, neutral slots, empty histories and all exclusions. Disclose the two blocked WTA contexts. Do not change admission, acquire data, aggregate factors, calculate ratings, fit or score models, add dependencies, resume OTD or modify the portfolio.”**
