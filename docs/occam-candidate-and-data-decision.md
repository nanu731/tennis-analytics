# Occam candidate refinement and broader-data decision

**Phase 2G: ADOPT_SOURCE_DEFINED_MODELING_COHORT.** Adopt the permanent Occam rule and retain exactly two provisional primary alternatives: **S02 = M01 + M05 + M11 + M12** and **S08 = M03 + M05 + M11 + M12**. These are approved design decisions, not a new admitted population, empirical result or final factor selection. The next executable phase is a bounded offline source-record admission audit, requiring the approval below.

## Evidence and Occam decision

This decision uses the saved [Phase 2F report](exploratory-four-factors-pilot-analysis.md) and its frozen local tables only for empirical evidence. Phase 2F found six primary sets eligible for refinement in 231 valid hard-court pilot matches, with conditional sign instability and no out-of-time evidence. No new metrics, correlations, models or performance comparisons were calculated here.

Standing rule, adopted in [PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md#occams-razor):

> Start with the simplest method that can answer the research question. Add a feature, rule, adjustment, data source, or model component only when it fixes a demonstrated problem or earns a stable out-of-time improvement. Remove complexity that does not earn its place.

This applies to factor selection, Elo design, imputation, data sources, testing and future model extensions. Three supported factors are better than four forced factors. Simplicity does not waive validity, rights, exclusion or leakage checks.

## Provisional shortlist

| Component | Decision and reason |
| --- | --- |
| M05: double faults / second-serve opportunities | Retain in both sets. It is the clearest second-serve-security candidate: an interpretable failure rate on the relevant opportunity base, including double faults. Lower is better. This is an interpretation decision, not proof that M05 predicts better. |
| M11: break chances created per return game | Retain as provisional return pressure. It describes opportunities generated, shares same-match counts and needs future validation. |
| M12: break-point conversion | Retain as provisional conversion or execution. It is not established recovery, resilience or clutch performance and is not conversion above expectation. Zero opportunities remain undefined. |
| M01: ace rate, S02 | Retain the more mechanism-focused serve alternative. Its incremental evidence was weak or unstable, especially in WTA. An ace rate does not measure all serve creation. |
| M03: first-serve points won, S08 | Retain the more outcome-coupled alternative. It performed more strongly within the pilot but includes the outcome of points following first serves. Chronological validation must decide whether its additional value is stable. |

Saved full-tour unique NPR R-squared increments for the serve term were **S02/M01: .01727 ATP and .0003505 WTA**, versus **S08/M03: .04639 and .04449**. These are copied Phase 2F descriptive findings, not new estimates, weights or practical-effect thresholds. M01 reversed sign between WTA event-season cells in S02. Neither alternative is a final winner.

Pause **S01, S03, S07 and S09**: M04 (second-serve points won) adds point-outcome coupling, while M06 (double faults per service point) introduces first-serve-frequency dependence into the security interpretation. Neither has demonstrated stable out-of-time value over the simpler M05 interpretation. Some had higher pilot fit; the pause does not assert equal in-sample performance or statistical inferiority. Preserve every definition and result.

Keep **M02 and its primary sets S04–S06 paused** because its conditional direction reversed between ATP and WTA. **M07 remains sensitivity-only**, with no automatic reactivation of the M02-based T02 set; **M08/M15 remain benchmarks**. The duplicate/complement exclusions remain. No formula, weight, composite or practical-effect threshold is selected or changed. Reopening paused alternatives needs a named problem or prespecified chronological evidence, not a better same-match score.

## Broader-data decision, in required priority order

The selected standard is **ADOPT_SOURCE_DEFINED_MODELING_COHORT**. It defines the development target as eligible records present in an authorized, pinned source, conditional on source inclusion, conservatively established source-reported normal completion, unambiguous identity/context and valid required statistics. Later forecasting additionally requires safe pre-match information and chronology. This is narrower than all completed matches in the tournament panel and does not estimate source recall.

| Priority | Assessment supporting the decision |
| --- | --- |
| 1. Rights and provenance | Phase 2F preserves a pinned archive, manifests, hashes and a saved-use record. This supports a bounded route using existing files, not a new provider grant or blanket broader-use permission. The next phase must verify each file and the applicable saved research-use conditions before processing; unresolved rights stop that file. No additional official-page acquisition or OTD access is assumed. Public derivatives remain separately blocked. |
| 2. Exclusion reliability | Apply explicit status, score, identity and whole-bundle checks; exclude known RET/WO/incomplete/invalid records and quarantine all ambiguity. Retain adopted pilot overrides and conflicts. A clean score alone is not independent proof of actual completion: the saved pilots show why source omissions and conflicts matter. The cohort must be labeled source-reported, with residual undetected-status error disclosed. If normal-completion classification cannot be supported consistently, the affected records are not admitted. |
| 3. Reproducibility | Pin file versions, retain original values and identifiers, and give each source row a reproducible disposition and all exclusion reasons. Reject unexplained duplicates or mapping conflicts rather than manually selecting favorable observations. |
| 4. Attainable breadth | Existing annual source containers offer a route to auditing more panel events and surfaces without acquiring new references. Actual eligible breadth is unverified: Phase 2F validated only three hard-court cells. The next bounded inputs cover ATP 2023 and WTA 2021/2023; independent ATP-season breadth and 2022 remain absent from that next step. Do not assert clay/grass or event completeness before audit. |
| 5. Continuing burden | A source-record audit can apply reusable rules instead of requiring a new official reference chain for every match. Unresolved records stay excluded; this is not permission for endless manual recovery or new source collection. The official-reference route remains available for stronger future claims but is not the development default. |
| 6. Honest estimand | Results concern the observed, eligible source subset. Missing matches remain absent and are neither imputed nor represented as complete tournament coverage. Report selection, missingness and exclusion patterns by tour, season, event, surface and round where supported. No population-wide or future predictive claim follows from adopting this design. |

Keeping official reconciliation as the sole admission route would preserve a stronger coverage claim but retain the unresolved reference/rights burden documented in the saved evidence. A pilot-only endpoint would be premature while a reproducible, explicitly narrower source-defined audit is feasible to attempt. Neither rejected option is a claim that more data are available, that rights have been newly cleared, or that the broader cohort will pass.

## Admission contract and unchanged historical gates

For the source-defined lane, require all of the following before including a record:

- An authorized, immutable source file with verified provenance, hash and applicable saved-use basis; preserve raw observations.
- An unambiguous in-panel main-draw singles event, tour, source season, surface and two distinct source player identities. Unsupported event mapping, format or conflicting metadata is excluded pending review. Do not infer official level from draw size.
- No explicit or adopted retirement, walkover, abandonment, default, unfinished score, unknown marker or unresolved status conflict. Require affirmative source-reported normal-completion evidence under a documented, validated score/match-format parser; absence of a RET marker alone is insufficient. Existing pilot reference decisions take precedence and cannot be overwritten by a source-only classification.
- A valid complete two-player nine-count bundle, including nonnegative integers, count bounds and applicable score/game reconciliation. Missing or invalid bundles remain excluded from factor eligibility; preserve separate status and statistics dispositions. Unknown checks do not pass. No invented repairs, imputation of absent matches or automatic recovery transfers.
- Stable IDs, duplicate/conflict checks and explicit inclusion/exclusion reasons. Separate metric opportunity gaps, such as M12 zero chances, from invalid/missing raw counts. Model comparison eventually requires a common eligible cohort and its own authorization.

Report total observed in-scope source rows, source-reported status dispositions, count-valid rows, exclusions by reason and their overlap, and every expected panel cell including absent cells. A fraction using observed rows is a **source-record retention/count-availability fraction**, not complete-event coverage. Do not count known missing matches as observed source rows, invent missing identities or impute them. Where saved official denominators already exist, retain and display the reconciled comparison separately; elsewhere official recall is **UNKNOWN**. Do not expand the three-pilot recovery overlay beyond its adopted scope.

**Explicit prospective change:** official reconciliation is no longer a universal prerequisite for this separately labeled source-defined development lane. The historical **90% event / 95% full-panel tour-season** gates are not lowered, passed by a new denominator or retroactively rewritten. They continue to govern complete-event/full-panel admission claims under the official-reconciliation standard. No replacement numerical gate or practical threshold is introduced. An absent cell is reported as a breadth limitation, never hidden or described as representative full-panel development. If the audited breadth cannot support the intended comparison, report the limitation and stop that comparison.

The ten-family panel and 2021–2023 / 2024 / locked-2025 split stay fixed. Package B's official-reference acquisition route stays stopped; this new source-defined route does not reopen it. Chronology, rights, quarantine, retirement exclusions and publication safeguards survive the estimand change. The source contract records the same prospective distinction.

## One executable next phase: Phase 2H source-record admission audit

**Not executed or authorized by this document.** Following explicit approval, implement one offline, versioned base-R admission/disposition audit using only the Phase 2F-pinned archive revision `83733587353df8a41f2fd4f516147d5aa83f5a8d` files `atp_matches_2023.csv`, `wta_matches_2023.csv` and `wta_matches_2021.csv`, plus their saved provenance and applicable existing pilot policies/references. No other file/year/source is implicitly admitted.

The executable work is to verify saved-use authority and hashes; parse only the unchanged ten-family main-draw panel; apply the admission contract above; and emit an ignored local row-disposition ledger, source-cohort membership, cell/field/exclusion summaries and a concise report. Use existing source IDs and maintain outcome-neutral orientation. Test the important parser/status/count invariants, known pilot conflicts and deterministic reruns without invoking a historical empirical runner. Do not calculate candidate metrics, fit models or build histories in this step.

Proposed Phase 2H file scope, requiring that next approval: create `R/audit_source_defined_cohort.R`, `R/test_source_defined_cohort.R` and `docs/source-defined-cohort-audit.md`; update only status and the source contract. Create the new ignored release directory `data/pilot/source-defined-cohort-admission/` with `input-provenance.csv`, `row-dispositions.csv`, `cohort-membership.csv`, `cell-coverage.csv`, `field-availability.csv` and `summary.csv`. Keep match-level artifacts local and preserve historical releases. These files are not created in Phase 2G.

The deliverable is actual auditable source-record dispositions and measured breadth, not another readiness plan. Accept only records satisfying all gates; return explicit exclusions and blocked-file reasons otherwise. Missing rights/provenance, unsupported completion semantics or unresolved mappings cannot be rescued through acquisition, assumed status, relaxed checks or data repair. Existing pilot agreement is a regression check, not proof that unseen cells are valid. No broader cell is admitted in Phase 2G, and completing Phase 2H will not itself authorize forecasting.

**Exact approval required:** Approve Phase 2H: implement a versioned offline base-R source-record admission audit of the saved, pinned ATP 2023 and WTA 2021/2023 annual files within the unchanged ten-family main-draw singles panel, verifying saved-use rights and provenance, applying conservative status/identity/count exclusions and existing pilot overrides, and producing local ignored dispositions, membership and honest coverage summaries with targeted checks; no acquisition, new source/year, metrics, model fitting, histories, forecasting, historical-output changes or publication. Authorize only the Phase 2H code, focused checks, report, status/contract updates and six-file ignored output location explicitly listed in this decision.

## Validation and version boundary

Phase 2G changes exactly this decision document, PROJECT_CONTEXT.md, docs/status.md and docs/data-source-contract.md. Targeted checks passed for all four document contracts, shortlist definitions and quoted evidence against frozen aggregates, 59 local links and eight anchors, whitespace, all fourteen Phase 2F CSV hashes/sizes/mtimes, and 78 other tracked files against starting commit `543e505f524c3f3b80e849b1ff35beb378c91748`. The original coverage-gate section remains verbatim after its explicit prospective scope note. Final staged-scope inspection confirms only the four intended documents. No script, persistent test, research data, metric, model or dependency is created in this phase.

Changing current context/contract intentionally crosses the Phase 2F input-pin boundary. Preserve its code, pins, 669-check historical record and outputs; do not rerun or repin that empirical suite under new authority. A future implementation needs its own version and authority pins. The status snapshot records completed verification; historical phase sections remain historical.
