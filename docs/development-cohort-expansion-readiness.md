# Phase 2C: development-cohort expansion readiness

**Decision: READY_FOR_BOUNDED_EVIDENCE_PROPOSAL.** Version 1.0.0. Planning only: Package B is a scientifically defensible evidence target, not an admitted or analysis-ready cohort.

Started clean on main at 3c59ca275be163facdf7504acba3f94f7cfed662 (Define Four Factors selection protocol). The flagship compares interpretable factors with surface-adjusted Elo; Challenger remains deferred. No portfolio modification, publication or push.

## Authority and evidence boundary

Phase 2C implements aggregate saved-evidence planning, not expansion. No raw match-row parsing occurs in the planner. No acquisition, search, browser, contact, OTD resumption, 2022/2024/2025 data access, reconciliation of unvetted cells, new metric/outcome, model, factor selection, weights, imputation, history, Elo or forecast is performed.

The [Phase 2B protocol](four-factors-definition-protocol.md) and [project context](../PROJECT_CONTEXT.md) remain unchanged. Four distinct mechanisms and freedom from overfitting are goals, not findings. Zero correlation is not required. The ten-family panel and 90% event / 95% tour-season gates are unchanged. Q6/Q8/Q9/Q10 remain PENDING_USER_APPROVAL; OTD remains PAUSED_BY_USER_AFTER_PHASE_1S.

## Exact saved input scope

The planner pins 27 aggregate/manifest/document inputs. input-provenance.csv records every exact path, SHA-256, byte size and role; every read is allowlisted, hash-checked and traced. It does not follow raw paths or URLs contained in manifests.

Source scope remains the four ATP/WTA 2021/2023 annuals at archive 83733587353df8a41f2fd4f516147d5aa83f5a8d. This planner reads their saved metadata summaries and acquisition manifests, not the annual rows. No current external rights or provider availability is verified.

| path | role |
| --- | --- |
| .gitignore | REPOSITORY_DOCUMENT |
| AGENTS.md | REPOSITORY_DOCUMENT |
| DATA_LICENSE.md | REPOSITORY_DOCUMENT |
| data/manifests/anomaly-reference-files.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/manifests/development-source-files.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/manifests/inventory-reference-files.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/manifests/montreal-reference-files.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/manifests/pilot-source-files.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/pilot/development-2021/montreal-completed-match-coverage/summary.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/pilot/development-2021/montreal-inventory/summary.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/pilot/development-2021/required-field-summary.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/pilot/event-boundary-feasibility/event-cells.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/pilot/event-boundary-feasibility/source-candidates.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/pilot/four-factors-candidate-metric-feasibility/cell-coverage.csv | SAVED_AGGREGATE_OR_MANIFEST |
| data/pilot/inventory/inventory-summary.csv | SAVED_AGGREGATE_OR_MANIFEST |
| docs/2021-annual-source-audit.md | REPOSITORY_DOCUMENT |
| docs/atp-inventory-reference-precedence-policy.md | REPOSITORY_DOCUMENT |
| docs/event-boundary-feasibility.md | REPOSITORY_DOCUMENT |
| docs/four-factors-candidate-metric-feasibility.md | REPOSITORY_DOCUMENT |
| docs/four-factors-definition-protocol.md | REPOSITORY_DOCUMENT |
| docs/indian-wells-inventory-reconciliation.md | REPOSITORY_DOCUMENT |
| docs/post-otd-analytical-path.md | REPOSITORY_DOCUMENT |
| docs/wta-2021-montreal-completed-match-coverage.md | REPOSITORY_DOCUMENT |
| docs/wta-2021-montreal-inventory-reconciliation.md | REPOSITORY_DOCUMENT |
| docs/wta-2021-montreal-recovery-verification.md | REPOSITORY_DOCUMENT |
| docs/wta-anomaly-and-quarantine-policy.md | REPOSITORY_DOCUMENT |
| PROJECT_CONTEXT.md | REPOSITORY_DOCUMENT |

## Forty-cell readiness findings

All 40 candidate cells and 3,832 source rows remain visible. Exactly three are CURRENT_RECONCILED_PILOT; exactly 37 remain UNVETTED_NONPILOT. The ten selected new targets are BLOCKED_MULTIPLE; the other 27 are SAVED_SOURCE_ONLY_UNVETTED with selection role NOT_PROPOSED. No completed denominator or valid-count numerator is supplied for any unvetted cell.

Readiness vocabulary also permits BLOCKED_INVENTORY, BLOCKED_STATUS, BLOCKED_COUNTS, BLOCKED_RIGHTS and NOT_PROPOSED. A planning classification does not change evidence_state or admission. CURRENT_RECONCILED_PILOT records inherited event-local work, not current model readiness. No unknown becomes a pass.

Nine count suffixes on both sides are structurally present according to the 196-row saved four-annual field summary. Presence or completeness does not establish normal completion, validity, independent accuracy or rights. Surface labels come from saved source metadata, not a newly verified official calendar. Canada remains one family: WTA source labels identify Montreal; ATP generic Canada labels leave edition city NA. Other unsupported city fields remain NA, not invented.

The inherited pilots retain 245 inventory records, 232 completed results and 231 valid bundles. ATP Indian Wells preserves four scoped PDF dissent resolutions; WTA Indian Wells preserves one quarantined completed bundle; Montreal preserves 42 original plus seven separately recovered bundles and raw status conflicts. No global canonical player linkage exists. The planner does not re-establish these facts by parsing matches.

| tour | season | event_family | surface | saved_source_rows | evidence_state | selection_role | completed_denominator |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | 2021 | Australian Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2021 | Canada | Hard | 47 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2021 | Cincinnati | Hard | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2021 | Indian Wells | Hard | 95 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| ATP | 2021 | Madrid | Clay | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2021 | Miami | Hard | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2021 | Roland-Garros | Clay | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| ATP | 2021 | Rome | Clay | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2021 | US Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2021 | Wimbledon | Grass | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| ATP | 2023 | Australian Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2023 | Canada | Hard | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2023 | Cincinnati | Hard | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2023 | Indian Wells | Hard | 95 | RECONCILED_PILOT | B_EXISTING_CORE | 91 |
| ATP | 2023 | Madrid | Clay | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2023 | Miami | Hard | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2023 | Roland-Garros | Clay | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| ATP | 2023 | Rome | Clay | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2023 | US Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| ATP | 2023 | Wimbledon | Grass | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| WTA | 2021 | Australian Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2021 | Canada | Hard | 55 | RECONCILED_PILOT | SUPPLEMENTARY_EXISTING | 49 |
| WTA | 2021 | Cincinnati | Hard | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2021 | Indian Wells | Hard | 95 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| WTA | 2021 | Madrid | Clay | 63 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2021 | Miami | Hard | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2021 | Roland-Garros | Clay | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| WTA | 2021 | Rome | Clay | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2021 | US Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2021 | Wimbledon | Grass | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| WTA | 2023 | Australian Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2023 | Canada | Hard | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2023 | Cincinnati | Hard | 55 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2023 | Indian Wells | Hard | 95 | RECONCILED_PILOT | B_EXISTING_CORE | 92 |
| WTA | 2023 | Madrid | Clay | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2023 | Miami | Hard | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2023 | Roland-Garros | Clay | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |
| WTA | 2023 | Rome | Clay | 95 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2023 | US Open | Hard | 127 | UNVETTED_NONPILOT | NOT_PROPOSED | NA |
| WTA | 2023 | Wimbledon | Grass | 127 | UNVETTED_NONPILOT | B_PROPOSED_NEW | NA |

## Package definitions and comparison

Package A: ATP/WTA Indian Wells, Roland-Garros and Wimbledon in 2023, plus the existing Montreal 2021 pilot as supplementary evidence. Four new clay/grass cells are the minimum for a two-tour surface probe. A 2021-only probe also needs four additions but lacks the existing ATP hard pilot in that season; 2023 aligns both existing Indian Wells pilots without inventing stronger evidence.

Package B: the same three families crossed with both tours and 2021/2023: 12 core cells, two existing core pilots, ten new cells. Montreal 2021 is retained separately, producing 13 total retained/target cells and three existing pilots. It does not replace the matched Indian Wells hard anchor.

Package C: all ten families in both tours and both saved seasons: 40 cells, three existing pilots, 37 additions. This is the broader saved slice of the eventual panel, not the complete development period; 2022 remains inaccessible. More within-surface event replication is useful later, but the larger burden is not the minimum initial anchor.

| package | core_cells | core_existing | supplementary_existing | total_cells | existing_reconciled | new_unvetted | new_source_rows | core_ATP | core_WTA | core_2021 | core_2023 | core_hard | core_clay | core_grass | matched_families_both_seasons |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A | 6 | 2 | 1 | 7 | 3 | 4 | 508 | 3 | 3 | 0 | 6 | 2 | 2 | 2 | 0 |
| B | 12 | 2 | 1 | 13 | 3 | 10 | 1206 | 6 | 6 | 6 | 6 | 4 | 4 | 4 | 3 |
| C | 40 | 3 | 0 | 40 | 3 | 37 | 3587 | 20 | 20 | 20 | 20 | 24 | 12 | 4 | 10 |

Every source-row burden is a workload indicator, never a completed-match count or forecast sample size. Required references, valid bundles and work-hours are unknown.

| package | scientific_gap | remaining_confounding | entirely_offline_reconciliation | recommendation |
| --- | --- | --- | --- | --- |
| A | Initial non-hard measurement probe | One core season; event equals surface; Montreal confounds season/event | FALSE | NOT_SELECTED_INADEQUATE_SEASON_CROSSING |
| B | Within-family season replication and tour-separated surface-context contrasts | One family per surface; event/surface and ATP format remain confounded; two seasons only; IW 2021 autumn versus 2023 spring | FALSE | RECOMMENDED_EVIDENCE_TARGET_ONLY |
| C | Broader within-surface event sensitivity and panel coverage | Grass only Wimbledon; two saved seasons; chronology and repeated-player dependence unresolved | FALSE | DEFER_BROADER_BURDEN |

## Selection order, alternatives and minimality

1. Named scientific gap
2. ATP/WTA separation
3. Balanced season and surface contrasts
4. Matched families across seasons
5. Fewest new unvetted cells
6. Usable saved evidence
7. Rights and reference burden
8. Informative failure
9. No favorable assumptions about missing evidence

This is a precedence order, not a weighted convenience score. A is minimal for its surface-probe objective but fails the preferred season crossing. B addresses that gap with fewer additions than C. No rights failure is offset by scientific utility: B remains only an evidence proposal.

A balanced minimum has 2 tours x 2 seasons x 3 surfaces = 12 core cells. Enumerating all 18 combinations of six hard families, three clay families and the sole grass family confirms a ten-addition lower bound under the matched-family objective. Indian Wells reuses two reconciled cells; Canada would reuse one and other hard families none. Mixing IW 2023 with Montreal 2021 would sacrifice matched-family crossing; it is not an equivalent smaller anchor.

Roland-Garros, Madrid and Rome tie at ten additions with Indian Wells/Wimbledon. Roland-Garros is the proposed clay representative because its saved G classification and 128 draw-size labels match Wimbledon across all four tour-season cells, yielding a more comparable clay/grass bracket context. This is a stated design preference, not evidence of better data, rights, more eligible matches or verified match-format rules. Those labels and actual competition formats require later confirmation. No missing rights/reference state is assumed favorable.

| hard | clay | grass | new_cells |
| --- | --- | --- | --- |
| Indian Wells | Madrid | Wimbledon | 10 |
| Indian Wells | Roland-Garros | Wimbledon | 10 |
| Indian Wells | Rome | Wimbledon | 10 |
| Canada | Madrid | Wimbledon | 11 |
| Canada | Roland-Garros | Wimbledon | 11 |
| Canada | Rome | Wimbledon | 11 |
| Australian Open | Madrid | Wimbledon | 12 |
| Australian Open | Roland-Garros | Wimbledon | 12 |
| Australian Open | Rome | Wimbledon | 12 |
| Cincinnati | Madrid | Wimbledon | 12 |
| Cincinnati | Roland-Garros | Wimbledon | 12 |
| Cincinnati | Rome | Wimbledon | 12 |
| Miami | Madrid | Wimbledon | 12 |
| Miami | Roland-Garros | Wimbledon | 12 |
| Miami | Rome | Wimbledon | 12 |
| US Open | Madrid | Wimbledon | 12 |
| US Open | Roland-Garros | Wimbledon | 12 |
| US Open | Rome | Wimbledon | 12 |

Even B does not isolate a general causal surface effect: one event family represents each surface, ATP match-format differences need review, and Indian Wells moved from autumn 2021 to spring 2023 according to saved labels. It begins within-family season comparisons, not independent causal season effects. Montreal offers a WTA hard-event sensitivity in 2021 after IW 2021 reconciliation; comparable ATP within-surface event replication is absent. Two seasons cannot establish broad stability. C adds hard/clay event replication but still has only Wimbledon for grass.

If separately admitted and authorized, B could begin tour-specific measurement, opportunity/missingness and nonredundancy checks across surface contexts and matched seasons, followed by separately approved incremental NPR/winning analysis. It cannot establish final factors, forecasting, 2024 validation or locked-2025 performance. Event/player-aware uncertainty and Phase 2B selection rules still apply.

## Recommended cells

| tour | season | event_family | surface | source_event_id | saved_source_rows | readiness |
| --- | --- | --- | --- | --- | --- | --- |
| ATP | 2021 | Indian Wells | Hard | 2021-0404 | 95 | BLOCKED_MULTIPLE |
| ATP | 2021 | Roland-Garros | Clay | 2021-520 | 127 | BLOCKED_MULTIPLE |
| ATP | 2021 | Wimbledon | Grass | 2021-540 | 127 | BLOCKED_MULTIPLE |
| ATP | 2023 | Roland-Garros | Clay | 2023-520 | 127 | BLOCKED_MULTIPLE |
| ATP | 2023 | Wimbledon | Grass | 2023-540 | 127 | BLOCKED_MULTIPLE |
| WTA | 2021 | Indian Wells | Hard | 2021-609 | 95 | BLOCKED_MULTIPLE |
| WTA | 2021 | Roland-Garros | Clay | 2021-520 | 127 | BLOCKED_MULTIPLE |
| WTA | 2021 | Wimbledon | Grass | 2021-540 | 127 | BLOCKED_MULTIPLE |
| WTA | 2023 | Roland-Garros | Clay | 2023-520 | 127 | BLOCKED_MULTIPLE |
| WTA | 2023 | Wimbledon | Grass | 2023-540 | 127 | BLOCKED_MULTIPLE |

Existing core cells: ATP Indian Wells 2023 and WTA Indian Wells 2023. Supplementary only: WTA Montreal 2021. No cell is admitted by this list.

## Cell-level prerequisites and evidence routes

cell-prerequisites.csv supplies 592 records: 16 explicit prerequisites for each of the 37 cells proposed in A/B/C, with package membership, selected-B flag, current state, saved basis, required evidence, route and stage. All ten B targets carry every requirement below. Missing evidence remains missing; an available annual file is not a complete evidence package.

| prerequisite | saved_basis | required_evidence | evidence_route | required_stage |
| --- | --- | --- | --- | --- |
| INVENTORY | Source aggregate cell only | Complete final official bracket/results independently traversed; account for all rounds entrants and byes | MISSING_REFERENCE_THEN_SEPARATELY_APPROVED_OFFLINE_CHECK | BEFORE_NEW_CELL_METRICS |
| MAIN_DRAW_SINGLES | Source file family and report scope only | Edition tour and main-draw singles scope independently confirmed; exclude other competitions | MISSING_REFERENCE_THEN_SEPARATELY_APPROVED_OFFLINE_CHECK | BEFORE_NEW_CELL_METRICS |
| NONBYE_DENOMINATOR | Source-row total only; no official denominator | All official non-bye results linked; completed denominator only after status resolution, never source rows minus score markers | MISSING_REFERENCE_THEN_SEPARATELY_APPROVED_OFFLINE_CHECK | BEFORE_NEW_CELL_METRICS |
| IDENTITY | Source identifiers documented; no official crosswalk | Unique stable event/round/player-pair links and preserved source spellings/IDs; no name-only or match-number chronology joins | MISSING_REFERENCE_THEN_SEPARATELY_APPROVED_OFFLINE_CHECK | BEFORE_NEW_CELL_METRICS |
| STATUS | Source syntax summaries only; not completion evidence | Corroborated normal completion, retirement, walkover and explicit unresolved/default disposition; unknowns block | MISSING_REFERENCE_THEN_SEPARATELY_APPROVED_OFFLINE_CHECK | BEFORE_NEW_CELL_METRICS |
| CONFLICTS | No new-cell conflict review | Compare identity winner round score and status across references; retain dissent; new precedence needs scoped approval | MISSING_REFERENCE_THEN_SEPARATELY_APPROVED_OFFLINE_CHECK | BEFORE_NEW_CELL_METRICS |
| BUNDLE_VALIDITY | Nine fields in saved schema; populated fields not validation | All nine integer nonnegative counts on both sides; full missing/invalid bundles withheld; accuracy not proved by presence | SAVED_ANNUALS_REQUIRE_LATER_APPROVED_VALIDATION_AFTER_STATUS | BEFORE_NEW_CELL_METRICS |
| QUARANTINE | Existing whole-bundle principle only | Whole-bundle quarantine on failed validity, preserved completed denominator; no extrapolation of scoped IW policy resolutions | LATER_OFFLINE_POLICY_APPLICATION_NEW_RESOLUTIONS_NEED_APPROVAL | BEFORE_NEW_CELL_METRICS |
| COUNT_UNIVERSE | Existing contract specification only | Verified definitions and numerator bounds, paired point universe and applicable game/score/tie-break checks; distinguish tautology from independent accuracy | SAVED_CONTRACT_PLUS_REFERENCE_CONVENTIONS_REQUIRED | BEFORE_NEW_CELL_METRICS |
| RECOVERY_IF_NEEDED | No assessed new-cell need or approved recovery layer | Assess actual gaps first; any separate whole-bundle recovery requires exact evidence, provenance and specific policy approval; never impute or fill raw NA | UNKNOWN_NEED_MAY_REQUIRE_SEPARATE_EVIDENCE_AND_POLICY | BEFORE_NEW_CELL_METRICS |
| PROVENANCE | Pinned annual manifests and aggregate provenance locally available | Revalidate saved source manifests plus exact new reference versions, fingerprints, retrieval representation and transformation lineage | SAVED_PROVENANCE_RECHECK_POSSIBLE_NEW_REFERENCES_MISSING | BEFORE_NEW_CELL_METRICS |
| LOCAL_RIGHTS | Saved archive CC BY-NC-SA statement; no new reference clearance | Review conditional archive noncommercial attribution/share-alike obligations and reference access, local retention and extraction rights for exact proposed use | SEPARATE_RIGHTS_REVIEW_OR_CLARIFICATION_NOT_AUTHORIZED | BEFORE_NEW_CELL_METRICS |
| PUBLICATION_RIGHTS | BLOCKED_PENDING_RIGHTS_REVIEW | Separate derived-output/redistribution and portfolio rights review; no inference from MIT, free access or user approval | SEPARATE_PUBLICATION_REVIEW_NOT_AUTHORIZED | BEFORE_PUBLICATION_STATUS_RECORDED_BEFORE_METRICS |
| SUCCESSOR_PIN | Current context and protocol locally available; no successor | Separately approved versioned successor with current context/protocol hashes, inherited validation and comparison, and unsupported-cell refusal | SEPARATE_VERSIONED_IMPLEMENTATION_NOT_AUTHORIZED | BEFORE_NEW_CELL_METRICS |
| COVERAGE_GATES | Existing 90%/95% rules only; no new denominator | Independently reconciled completed denominator then 90% event floor; fixed ten-family 95% tour-season gate remains NOT_TESTED by partial package | SEPARATE_RECONCILIATION_AND_FULL_SCOPE_GATE_WORK | BEFORE_NEW_CELL_METRICS |
| USER_AUTHORITY | Phase 2C planning only | Explicit separate authority for evidence route, acquisition if viable, reconciliation, successor, descriptive calculations and later modeling | USER_DECISION_REQUIRED | BEFORE_NEW_CELL_METRICS |

Already saved aggregate scope/schema and source provenance can be checked offline now. Future count checks might use saved annuals after separate raw-row/reconciliation authority and status evidence. Required new-cell final inventories, reference provenance, official linkage and completion/status evidence are not present in the saved reference inventories. Obtaining or clarifying them requires a separately approved route with rights clearance; this phase drafts no URLs, searches, requests, contacts or request ceilings.

Recovery need is unknown. Do not extrapolate Montreal recovery or Indian Wells precedence to new cells. Keep invalid/quarantined bundles and genuine missingness distinct. No source correction, imputation or score-syntax completion rule is proposed.

## Rights and coverage limitations

Saved documentation describes conditional CC BY-NC-SA 4.0 archive use for noncommercial research with attribution and applicable share-alike obligations; the mirror adds no rights. This is inherited documentation, not a new legal verification. Official/reference access, retention and extraction rights for expanded cells are not cleared. Existing pilot caching scope does not grant expansion permission. The saved WTA automated-access stop remains in force; ATP extraction rights remain unresolved. No substitute provider is approved.

Publication and derivative rights remain BLOCKED_PENDING_RIGHTS_REVIEW for every cell. A later properly authorized private audit need not claim public-release clearance, but its local research/reference rights must pass independently. Retention/disposition of existing OTD evidence remains unresolved and no OTD action follows.

Compute no new completed denominator or coverage percentage. Later reconciliation must preserve the non-bye universe and independently classify status before computing the 90% event gate. A partial anchor cannot satisfy or redefine the fixed ten-family 95% tour-season gate. Any later descriptive exception needs explicit bounded authority; factor-model admission remains blocked. No gate, panel or split is changed.

## Historical Phase 2A and future current-context successor

Historical Phase 2A pins PROJECT_CONTEXT.md before the Phase 2B success-criteria addition. Its unchanged entry point now correctly refuses the current context hash. The historical release is reproduced only with its original baseline code/context and saved evidence in an isolated historical environment. Do not rerun it under altered inputs, weaken its pin, overwrite its outputs or claim the current-context entry point passes.

| requirement | specification | phase_2c_state |
| --- | --- | --- |
| NEW_VERSION | Use a new audit version and separately approved output location; never overwrite Phase 2A | DESIGN_ONLY_NOT_IMPLEMENTED |
| CURRENT_CONTEXT | Pin exact current PROJECT_CONTEXT.md and Phase 2B protocol plus applicable current data contract and approved cohort specification | DESIGN_ONLY_NOT_IMPLEMENTED |
| INHERITED_INPUTS | Revalidate every inherited source/reference/overlay/code input against provenance; schema, identities, statuses, conflicts, counts and scope | DESIGN_ONLY_NOT_IMPLEMENTED |
| HISTORICAL_RELEASE | Preserve all historical Phase 2A bytes and its original context hash; never silently repin | DESIGN_ONLY_NOT_IMPLEMENTED |
| PILOT_COMPARISON | Reconstruct inherited pilots independently and compare exact membership, exclusions, values and diagnostics with frozen output; investigate differences before extension | DESIGN_ONLY_NOT_IMPLEMENTED |
| NEW_CELL_ADMISSION | Add cells only after separate inventory, identity, status, count, provenance, local-rights and coverage prerequisites pass | DESIGN_ONLY_NOT_IMPLEMENTED |
| FAIL_CLOSED | Missing changed or unsupported evidence blocks the proposed release; never silently drop a failed proposed cell or substitute a source | DESIGN_ONLY_NOT_IMPLEMENTED |
| GATES | Preserve 90% event and 95% tour-season gates, quarantine, separate recovery, unadmitted states, locked 2025 and forecasting chronology restrictions | DESIGN_ONLY_NOT_IMPLEMENTED |
| AUTHORITY | Successor is NOT_IMPLEMENTED in Phase 2C; coding, calculations, locations and new evidence each need separate approved scope | DESIGN_ONLY_NOT_IMPLEMENTED |

These are requirements only; no successor is implemented. Current Phase 2B protocol/context are immutable inputs to this plan. Their future successor hashes must be fixed at its approved starting state. A difference in inherited pilot results must be investigated rather than overwritten or accepted because correlations improve.

## Final decision and exact next user decision

**READY_FOR_BOUNDED_EVIDENCE_PROPOSAL.** B is scientifically defensible, but required inventory, identity, status, count and reference-rights evidence is missing. It is not READY_FOR_OFFLINE_RECONCILIATION. The gaps are specific enough for a responsible bounded proposal, so this is not a no-defensible-expansion finding.

The smallest next milestone is an offline evidence-route proposal for B, identifying a staged diagnostic first step, required evidence classes, rights prerequisites and explicit stop conditions. It may recommend stopping if no permissible route exists. Proposal approval would not authorize that route to be executed.

**Exact next user approval:** Do you approve a bounded evidence-route proposal for the ten unvetted Package B cells (ATP/WTA Indian Wells 2021 and ATP/WTA Roland-Garros and Wimbledon 2021/2023), using saved evidence only to specify missing inventory, identity, status, count and rights evidence and a staged stop-or-proceed decision, without browsing, searching, acquisition, contact, OTD work, reconciliation, cell admission, successor implementation, metric calculation, modeling, 2022/2024/2025 access or publication?

No final factors, weights, practical margins, resampling implementation, denominator policy, dependency, acquisition, reconciliation, successor, model or publication is approved by this decision. Keep Q6/Q8-Q10 pending and OTD paused. The next task must end with a response-only ChatGPT Handoff of no more than 2,000 words.

## Reproduction and verification

Run Rscript R/plan_development_cohort_expansion.R and Rscript R/test_development_cohort_expansion_readiness.R from the repository root. The planner is inert when sourced. It reads only exact pinned aggregates/manifests/documents, rejects raw/row-level and forbidden-season paths, and permits only bounded local Git/hash subprocesses. No network-capable function is called.

Seven CSVs remain ignored under data/pilot/development-cohort-expansion-readiness/: input-provenance, cell-readiness, package-comparison, cell-prerequisites, current-context-requirements, decisions and summary. These are aggregate planning artifacts, not player/match tables. NA is explicit, ordering and formatting are deterministic. Existing identical releases retain bytes and timestamps; changed or partial releases fail before replacement. An initial installation failure removes only newly created files and preserves any previous release.

See [tests](../R/test_development_cohort_expansion_readiness.R), [status](status.md) and [data contract](data-source-contract.md) for actual verification results and current authority. Historical reports keep their milestone-specific recommendations; the current next-step record supersedes them. No fresh external state or research performance is verified.
