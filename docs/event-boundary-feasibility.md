# Phase 1R: event-boundary feasibility

Generated from saved evidence by `R/audit_event_boundary_feasibility.R`. Base R; no acquisition or analytical histories. The narrative specifies a candidate, not an adopted forecasting protocol.

**Recommendation: REVISE_AND_TARGET_EVIDENCE**. Event-entry freezing reduces the required timing resolution, but no saved event cell has a verified pre-play cutoff, completion upper bound or historical result-availability upper bound. Match-sequential forecasting remains the intended primary target.

## Authority and unchanged gates

The Phase 1R user prompt approves Q5, Q7 and Q12 for specification and feasibility only. Q1–Q4, Q6 and Q8–Q11 remain PENDING_USER_APPROVAL. No primary/fallback/sensitivity role, lag, K, last-K implementation, inactivity adjustment, provider contact or alternative-source review is selected or authorized. The Phase 1Q brief and its pending-decision table remain the historical proposal; this report records the subsequent limited approvals.

| decision | approval | operational_implementation_authorized |
| --- | --- | --- |
| Q1 | PENDING_USER_APPROVAL | FALSE |
| Q2 | PENDING_USER_APPROVAL | FALSE |
| Q3 | PENDING_USER_APPROVAL | FALSE |
| Q4 | PENDING_USER_APPROVAL | FALSE |
| Q5 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY | FALSE |
| Q6 | PENDING_USER_APPROVAL | FALSE |
| Q7 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY | FALSE |
| Q8 | PENDING_USER_APPROVAL | FALSE |
| Q9 | PENDING_USER_APPROVAL | FALSE |
| Q10 | PENDING_USER_APPROVAL | FALSE |
| Q11 | PENDING_USER_APPROVAL | FALSE |
| Q12 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY | FALSE |


Operational chronology: NOT_IMPLEMENTED; event-entry batching: NOT_IMPLEMENTED; canonical analytical population: NOT_IMPLEMENTED; event admission: NOT_EVALUATED; modeling authorization: FALSE; publication: BLOCKED_PENDING_RIGHTS_REVIEW. Existing Montreal and Indian Wells policies, exclusions, quarantine and unresolved conflicts remain intact. Q7 is a specification gate, not operational adoption.

## Verified input scope and mapping

Exactly four saved annual CSVs are parsed: ATP/WTA 2021 and ATP/WTA 2023, at archive commit `83733587353df8a41f2fd4f516147d5aa83f5a8d`. Their respective annual row counts are 2,733, 2,597, 2,986 and 2,810. SHA-256, byte size, Git blob and recorded row counts are rechecked. Two saved 2021 API metadata responses and both annual manifests are validated. No 2022, 2024 or 2025 data, response or source document is opened; historical mentions in required project documents do not constitute new data access.

The existing bounded literal event aliases derive the mapping anew. Each tour-season yields one unambiguous candidate for each of Australian Open, Roland-Garros, Wimbledon, US Open, Indian Wells, Miami, Madrid, Rome, Canada and Cincinnati. Canada retains Montreal/Toronto as edition-city concepts; this audit does not infer a city absent from the source identity. Source surfaces and raw levels are retained, without inferring official classifications.

| tour | season | expected_cells | unambiguous | missing | ambiguous | source_rows | pilot_inventory_cells |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | 2021 | 10 | 10 | 0 | 0 | 910 | 0 |
| ATP | 2023 | 10 | 10 | 0 | 0 | 998 | 1 |
| WTA | 2021 | 10 | 10 | 0 | 0 | 926 | 1 |
| WTA | 2023 | 10 | 10 | 0 | 0 | 998 | 1 |


Total: **40 candidate cells and 3,832 source rows**, with no missing or ambiguous family in the current saved files. Missing/ambiguous mutation fixtures remain explicit in the full expected universe. These are source candidates, not 40 officially complete or admitted events.

The ignored matrix preserves exact tournament IDs, names, labels, surfaces, levels, row counts, mapping/inventory states, boundary fields and separate reason codes. A separate candidate table preserves every metadata variant if a family becomes ambiguous. No field is filled from a conventional tournament duration or a later event label.

## Evidence strength and unresolved boundaries

Three cells have stronger event-scoped inventory evidence: ATP and WTA Indian Wells 2023 and WTA Montreal 2021. The other 37 have source identities only and inventory NOT_TESTED. This audit fingerprints the prior saved inventory/status outputs and their raw references; the existing offline regression suites separately reconstruct those audits. It does not regrant analytical eligibility or independently authenticate a publisher’s claims.

Montreal supplies 49 normally completed, five retired and one walkover result; Indian Wells supplies ATP 91 completed/four retired and WTA 92 completed/two retired/one walkover. The WTA Indian Wells statistical quarantine remains excluded. Those statuses support a status-only screen, not an operational history. Nonpilot rows remain UNVETTED_NONPILOT, including rows with numeric score syntax; explicit source RET/WO markers remain separate observations.

The boundary-evidence table distinguishes SOURCE_LABEL, PINNED_PRIOR_AUDIT, PUBLISHED_LITERAL_NOT_ACTUAL_BOUND and MISSING_EVIDENCE. Every affirmative observation has a saved path, SHA-256 and locator. All 40 cutoffs and both kinds of release bound remain unknown. Reason codes are NO_INDEPENDENT_PREPLAY_BOUND, NO_VERIFIED_COMPLETION_UPPER_BOUND and NO_HISTORICAL_AVAILABILITY_UPPER_BOUND; unknown precision/timezone is retained.

Montreal’s source label is 20210809; its saved overview says August 9–15, while the PDF header says August 7–15. That discrepancy is preserved, with no assumed qualifying explanation. Nine match pages publish date-only intervals, without established actual-play/completion semantics or timezone, alongside finished-card/scheduled-metadata conflicts. Fifty-four corroborated same-player bracket edges include 45 normally-completed-to-normally-completed edges; none establishes an event release time.

Indian Wells’ source labels are 20230306. The saved ATP PDF prints March 6–19, 2023, and the WTA PDF prints March 8–19, 2023. The WTA PDF has a RELEASED footer dated 17 Mar 2023 7:49 PM, without a verified timezone or historical publication guarantee; its incomplete final branches cannot establish availability of all final results. Printed release text is preserved rather than promoted to an authenticated full-event bound. The existing WTA match-date/supplementary URL discrepancy also remains unresolved.

The annuals are later archive snapshots, and the official captures were retrieved in 2026. Neither the archive revision nor those access timestamps proves that the values used were available in 2021/2023. No retrieval timestamp is repurposed as historical publication time. No saved literal here establishes the earliest relevant main-draw play or a reliable conservative upper bound for all completed results.

## Exact-ID dependency inventory

Within each tour-season, all 45 unordered candidate event pairs are retained. Output row order is lexical serialization only. A distinct subset consists of nine adjacent source-label pairs; label ties remain unordered, and any missing/ambiguous family prevents an asserted consecutive-label chain. No rows are dropped to improve feasibility. The unusual 2021 Indian Wells October position is derived from the saved labels.

| tour | season | all_pairs | disjoint_pairs | label_adjacent_pairs | adjacent_player_pair_memberships | distinct_adjacent_player_ids | conditional_dependency_memberships | supported_dependency_memberships | blocked_dependency_memberships |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | 2021 | 45 | 0 | 9 | 540 | 134 | 540 | 0 | 540 |
| ATP | 2023 | 45 | 0 | 9 | 650 | 127 | 648 | 0 | 648 |
| WTA | 2021 | 45 | 0 | 9 | 549 | 133 | 548 | 0 | 548 |
| WTA | 2023 | 45 | 0 | 9 | 642 | 126 | 641 | 0 | 641 |


All 180 real pairs share at least one exact source player ID; therefore the disjoint-set claim is exercised by synthetic fixtures, not observed in this panel. The 36 adjacent-label pairs contain **2,381 player-pair memberships**. A player can occur in several pairs; this is not a count of unique people across seasons or tours.

Four memberships have only already-excluded prior pilot results. The remaining **2,377 conditional dependencies are all blocked**: zero have verified completion/availability before a verified next cutoff. Across the complete membership inventory there are 378 status-only candidate prior-result appearances, 4,639 unvetted appearances and 17 excluded/quarantined appearances. These are appearances, not deduplicated matches or features.

“Required” is conditional on a future history including that prior event; no history window or K is selected. Each ignored membership preserves the exact ID, source spellings on both sides, source match locators, scoped status provenance and its blocker. Names never create a link. Player IDs are not joined across tours. Match numbers identify source records only and never supply order.

Disjoint events need no arbitrary ordering for direct player-local updates. That limited statement does not establish commutativity for globally fitted transformations, schedule/opponent adjustments or every Elo variant. Shared-player auditing is a necessary direct-dependency inventory, not a complete future model dependency graph. Even with verified event boundaries, within-prior-event Elo update order and last-K ties would still require design/evidence.

## Candidate protocol: specification only

Process ATP and WTA separately. For each event e, choose a common cutoff C_e demonstrably before its earliest relevant main-draw play. Freeze player ratings, factor histories, opponent adjustments, fitted transformations and all other features at that cutoff. No earlier-round result or statistic from e may enter a later-round prediction in e. This yields an event-entry forecasting estimand and intentionally discards in-event learning; adopting its research role requires Q6.

For prior event j, retain separately supported completion and historical availability upper bounds. The effective A_j is at least their maximum. Require A_j < C_e. Conservative interval handling compares the latest plausible prior completion/availability against the earliest justified cutoff, with reconciled timezone and precision. Equality, overlap, unknown semantics or unknown bounds fail closed. A common cutoff also needs evidence that it is genuinely pre-play; an arbitrary numerical value is insufficient.

The pure test predicate illustrates that necessary condition; it neither computes times from source labels nor builds a release schedule. Retirements, partial retirement statistics and walkovers remain excluded from primary statistics and Elo updates; the Indian Wells quarantine remains. Nonpilot status candidates require separate verification. Eligible status, inventory, chronology, coverage, history scope, authorization and rights are separate gates.

All compared models must use the same information cutoff and compatible status/population rules. Symmetric withholding is necessary for fairness, but does not make stale or nearly empty histories scientifically useful. An event-entry result cannot be reported as superiority to ordinary sequential surface Elo without the separately specified comparison.

## Unselected boundary strategies

### 1. Evidence-triggered release

Requires: Verified event completion AND historical availability upper bounds plus target pre-play cutoff. Saved support: NO_VERIFIED_RELEASE_BOUNDS.

Leakage: None from temporal inclusion if upper bounds and pre-play cutoff are valid; remaining gates separate. Information discarded: Same-event updates and results not proved available. Consecutive-event players: Prior event used only when supported before next cutoff.

Elo: Only eligible prior results could update; within-event order/update rule unresolved. Last-K: Released events still need within-event inclusion/tie policy; K unset.

Elapsed time/inactivity: Separate actual-time and inactivity policy required; ordinal events cannot measure elapsed days. Comparison fairness: Same supported cutoff, population/status rules and release information for Elo and Four Factors; symmetric withholding alone does not establish validity.

Recommendation status: unselected and unimplemented. A delay is an assumption, never substitute evidence.

### 2. Next verified event boundary

Requires: Same prior bounds plus verified next boundary before target play. Saved support: NO_VERIFIED_RELEASE_BOUNDS.

Leakage: Safe only when the boundary is verified; a next source label is not proof. Information discarded: Also results known after the last release boundary but before cutoff. Consecutive-event players: May delay a just-completed event until a later verified boundary.

Elo: Stale event-entry ratings until next release; update order unresolved. Last-K: Batch release changes sample; partial-event last-K selection unresolved.

Elapsed time/inactivity: Separate actual-time and inactivity policy required; ordinal events cannot measure elapsed days. Comparison fairness: Same supported cutoff, population/status rules and release information for Elo and Four Factors; symmetric withholding alone does not establish validity.

Recommendation status: unselected and unimplemented. A delay is an assumption, never substitute evidence.

### 3. One-event lag

Requires: Verified boundaries and prior availability; intervening event identity/order must be supported. Saved support: NO_VERIFIED_RELEASE_BOUNDS.

Leakage: Unknown availability remains unknown; an ordinal gap can still leak. Information discarded: Most recent event even if actually complete and available. Consecutive-event players: Immediately prior event withheld even for consecutive entrants.

Elo: Extra stale ratings; lag and event-update semantics unselected. Last-K: Drops recent event; K, minimum sample and batch tie handling unresolved.

Elapsed time/inactivity: Separate actual-time and inactivity policy required; ordinal events cannot measure elapsed days. Comparison fairness: Same supported cutoff, population/status rules and release information for Elo and Four Factors; symmetric withholding alone does not establish validity.

Recommendation status: unselected and unimplemented. A delay is an assumption, never substitute evidence.

### 4. One-week lag

Requires: Verified availability/completion origin, actual calendar and timezone, target cutoff. Saved support: NO_VERIFIED_RELEASE_BOUNDS.

Leakage: Seven days cannot establish historical publication; scheduled dates can mislead. Information discarded: At least the chosen recent week if independently timed. Consecutive-event players: Recent entrants lose recent results; exact affected set unknown.

Elo: Calendar-dependent stale ratings; no update algorithm implemented. Last-K: Recent-calendar exclusions alter available last-K; K unset.

Elapsed time/inactivity: Separate actual-time and inactivity policy required; ordinal events cannot measure elapsed days. Comparison fairness: Same supported cutoff, population/status rules and release information for Elo and Four Factors; symmetric withholding alone does not establish validity.

Recommendation status: unselected and unimplemented. A delay is an assumption, never substitute evidence.

### 5. Longer conservative lag

Requires: Verified origin, specified lag, calendar/timezone and target cutoff; length unselected. Saved support: NO_VERIFIED_RELEASE_BOUNDS.

Leakage: Longer delay reduces assumed exposure but proves nothing without bounds. Information discarded: More recent evidence; amount unselected and unquantifiable here. Consecutive-event players: Potentially several prior events lost; affected set unknown.

Elo: Greater staleness; no lag or update algorithm selected. Last-K: Can severely reduce sample; K and retained population unresolved.

Elapsed time/inactivity: Separate actual-time and inactivity policy required; ordinal events cannot measure elapsed days. Comparison fairness: Same supported cutoff, population/status rules and release information for Elo and Four Factors; symmetric withholding alone does not establish validity.

Recommendation status: unselected and unimplemented. A delay is an assumption, never substitute evidence.

### 6. Permanent exclusion of unknown availability

Requires: Missing evidence suffices to withhold; independently verified bounds still needed for retained results. Saved support: CAN_SPECIFY_WITHHOLDING_ONLY_ZERO_RELEASES.

Leakage: No unknown result is included; missing history and selection bias remain. Information discarded: Every result with unknown availability; all current event releases withheld. Consecutive-event players: All currently unsupported dependencies withheld.

Elo: No current updates; meaningful warm-up not established. Last-K: No usable current event-release history; never shrink denominator to hide this.

Elapsed time/inactivity: Separate actual-time and inactivity policy required; ordinal events cannot measure elapsed days. Comparison fairness: Same supported cutoff, population/status rules and release information for Elo and Four Factors; symmetric withholding alone does not establish validity.

Recommendation status: unselected and unimplemented. A delay is an assumption, never substitute evidence.

## Separate scenario accounting

| scenario | expected_cells | adjacent_player_pair_universe | asserted_verified_releases | readiness_permitted | ready | directly_supported_ordinal_edges | normally_completed_ordinal_edges | hypothetical_label_pair_candidates | hypothetical_dependency_candidates | interpretation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| strict_verified | 40 | 2381 | 0 | TRUE | FALSE | 0 | 0 | 0 | 0 | No release satisfies verified strict bounds; full universe retained |
| player_relative_ordinal_only | 40 | 2381 | 0 | FALSE | FALSE | 54 | 45 | 0 | 0 | Montreal player-relative within-event precedence only; no cross-event timing or availability proof |
| source_label_hypothetical | 40 | 2381 | 0 | FALSE | FALSE | 0 | 0 | 36 | 2377 | Source-label adjacency exposes potential dependencies only; zero evidence-supported releases |
| assumed_lag | 40 | 2381 | 0 | FALSE | FALSE | 0 | 0 | 36 | 2377 | Event/week/longer lag unselected; no numerical delay fabricated; all candidates retained but unsupported |


Only strict verified bounds can support readiness. Ordinal edges remain within Montreal; they do not support any cross-event release. Label-based and lag scenarios retain all 40 cells and all 2,381 adjacent memberships. Their 36 pairs and 2,377 conditional dependencies are hypothetical candidates, not “passes.” No one-week, one-event or longer delay is used to manufacture numerical coverage. Permanent exclusion can avoid including unknown results, but zero current releases is not a ready research dataset.

## Decision criteria and next user decision

GO requires unambiguous mapping and independently justified cutoffs/completion/availability for the retained cells and dependencies of the proposed design. Passing that test would authorize nothing beyond recommending another offline design step. STOP is warranted if event freezing offers no material reduction or its changed estimand is rejected. REVISE applies when freezing reduces timing granularity but named evidence remains absent. The predicate compares event-cell versus source-row units only as a design burden indicator, never as a claim that within-event rating mathematics is solved.

Current result: **REVISE_AND_TARGET_EVIDENCE**. Forty event-boundary units could reduce the timing burden compared with 3,832 match rows, but zero independent cutoffs or release bounds exist here. The strict gate fails for every conditional dependency. The research-role decision is unresolved, so no favorable fallback interpretation is imposed.

Smallest recommended next milestone, not authorized: a bounded four-document OTD documentation preflight exactly as proposed in Phase 1Q, focused first on research-access/retention rights, historical result-availability semantics and whether a pinned development-only extract could ever meet these requirements. Stop at rights or semantic failure; acquire no match payload, install nothing and expand no source inventory. Published match-day fields alone would not answer the availability question.

Exact next user decision: approve or decline Q3/Q4 for that specifically bounded four-document review. If declined, pause chronology acquisition rather than substitute an assumed lag. Q6 must separately decide primary/fallback/sensitivity role before any event-entry adoption; Q8–Q10 must separately settle release strategy, history/K and inactivity design before implementation. All remain pending now. Provider contact needs separate Q1/Q2 authorization. No new dependency, directory structure beyond this task’s one ignored directory, data source, statistical method replacement or licensing assumption is approved by the finding.

## Reproduction, outputs and safeguards

Run from the repository root with existing R and local Git/SHA/PDF tools:

```sh
Rscript R/audit_event_boundary_feasibility.R
Rscript R/test_event_boundary_feasibility.R
```

The audit pins 37 existing input files and fails before writing on changed/missing bytes. It writes only this report and ten CSVs under ignored `data/pilot/event-boundary-feasibility/`: event-cells, source-candidates, event-boundary-evidence, event-pairs, player-event-dependencies, strategy-comparison, scenarios, summary, decisions and input-provenance. Those tables inventory evidence; none is a canonical match, feature, operational history, rating, factor or forecasting table. No restricted row-level material is committed.

Tests exercise exact input scope, missing/ambiguous mappings, row permutation and match-number renumbering, exact-ID versus name matching, disjoint/tied-label cases, scoped statuses, same-event exclusion, unknown/equal/overlapping bounds, timezone uncertainty, hypothetical/lag isolation, decision authority, output scope and ignored status. Runtime guards block live transport and unauthorized subprocesses. Unchanged reruns must preserve output bytes and modification times. Current validation totals and regression outcomes are recorded in status.md; they are software/evidence checks, not statistical validation.

Only the new auditor, test and report plus status.md and data-source-contract.md change. Prior policies, reports, raw bytes, manifests and generated evidence remain preserved. The portfolio repository is not modified. No network request, contact, new source retrieval, other-season data access, operational chronology, batching, model, publication or push is part of Phase 1R. Future response-only ChatGPT handoffs remain at most 2,000 words.
