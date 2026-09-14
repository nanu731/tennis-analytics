# Indian Wells ATP inventory reference-precedence policy 1.0.0

Date: **2026-09-14**. **User approved; implemented and verified in Phase 1D. ATP inventory gate: PASS.** This policy is distinct from the unchanged [WTA statistical-bundle quarantine policy 1.0.0](wta-anomaly-and-quarantine-policy.md).

## Approval and exact scope

The user's Phase 1D prompt explicitly approves using the agreeing ATP Tour HTML results and draw representations as controlling operational inventory evidence for **ATP, 2023 Indian Wells, main-draw singles, inventory identities, and only the Carreño Busta/Albot and Kudla/Wawrinka branches**. Approval did not require another confirmation.

The representations must agree on player identities, round, advancing player/winner, score and status. Preserve the ATP/ProTennisLive PDF as dissenting official evidence. Sackmann is a separate aggregate-source cross-check and is not the official conflict resolver.

Agreement does not prove that the two HTML representations are independent, use different upstream data, or are generally more reliable than PDFs. The cause of these contradictions remains unknown. This operational choice does not establish statistical accuracy, chronology, retirement eligibility, modeling eligibility, rating history, source rights or precedence elsewhere.

## Evidence and all four resolutions

All evidence is the unchanged saved Phase 1C material in the [inventory manifest](../data/manifests/inventory-reference-files.csv). No acquisition, external URL access or manifest change occurred in Phase 1D. The manifest retains exact URLs, retrieval/access times, sizes, hashes, failed HTTP requests and rights limitations. Browser-service text is not original HTML response bytes; access time is not origin retrieval time.

| Dissenting PDF observation | Selected HTML inventory | Separate Sackmann cross-check |
| --- | --- | --- |
| Page 1, R128 block 8, positions 15–16: Carreño Busta receives a bye | Radu Albot receives the bye; result locator L1763 | No source row expected for a bye |
| Page 1, R64 block 4: Murray faces Carreño Busta | Murray defeats Albot, `6-4 6-3`; L1379 | `2023-0404:266` |
| Page 1, R128 block 30, positions 59–60: Kudla defeats Vukic | Wawrinka defeats Vukic, `6-4 1-6 6-1`; L2377 | `2023-0404:208` |
| Page 1, R64 block 15: Kecmanovic/Kudla feeder pair advances S. Wawrinka, absent from that pair | Wawrinka defeats Kecmanovic, `7-6(8) 6-4`; L1237 | `2023-0404:255` |

All four are operationally resolved, yet remain source conflicts. No PDF identity or raw reference was overwritten. The complete PDF observations remain unchanged in the ignored `atp-pdf-observations.csv` output. No full third-party draw is committed.

## Implementation and controlled fields

[Reconciliation code](../R/reconcile_indian_wells_inventory.R) contains `inventory_precedence_policy()`, `inventory_apply_precedence()` and `inventory_gate_passes()`. Policy application uses official evidence before loading the Sackmann cross-check.

The existing reference comparison/conflict outputs retain original columns: reference identifier, round, locator, observed player/winner string, score and `passed`. In particular, **all four `passed` values remain FALSE**. The old `expected` text describes the original unmatched PDF-pair diagnostic, not the current resolution state.

Added reference fields:

| Field | Meaning |
| --- | --- |
| `source_conflict` | TRUE for the four retained disagreements |
| `conflict_type` | `official_reference_identity_conflict` for these four observations |
| `policy_name`, `policy_version` | Exact policy title above without version suffix; version `1.0.0` |
| `resolution_state` | `resolved_by_event_scoped_reference_precedence`; ordinary agreements use `not_required` |
| `dissenting_observation_state` | `preserved_dissenting_official_observation` |
| `scope_guard_passed` | TRUE only for the four authorized observations after checks |
| `selected_official_id`, `selected_player_one`, `selected_player_two`, `selected_winner`, `selected_score`, `selected_status` | Chosen HTML inventory record, kept separate from dissent |
| `controlling_reference_ids` | `atp_results_browser;atp_draw_browser` |
| `controlling_results_locator`, `controlling_draw_locator` | Exact saved-text source-line locators |
| `dissenting_official_id`, `dissenting_raw_text` | Original PDF record identity and unchanged observation text |

The three affected non-bye links remain **`matched_with_conflict`**, including corresponding source and official dispositions. `aggregate_source_disposition` separately retains the underlying exact/normalized Sackmann comparison. Links and inventory rows carry `resolution_state` and `reference_precedence_version`; these do not overwrite the source table's existing WTA `policy_version`. The selected bye also carries the reference-resolution state. New aggregate disagreements remain unresolved and block the gate.

The summary separately reports `official_reference_conflicts=4`, `resolved_reference_conflicts=4`, `unresolved_reference_conflicts=0`, policy name/version and `inventory_gate=PASS`. Four resolved reference observations correspond to three resolved conflicting match links, not four additional matches. `identity_ambiguous` remains available for future unresolved mappings.

## Agreement checks and fail-closed safeguards

Phase 1D strengthens the HTML comparison: draw advancement is extracted from the following round, and the final winner from its set scores, rather than borrowing the results winner. Both representations agree across all 127 entries on unordered pairs, round, advancement and scores. HTML-derived status agrees too. Four unrelated retirement cards lack explicit RET markers in both text representations; their HTML status remains unresolved on both sides, while the existing PDF supplies retirement evidence. **The affected policy records are three completed matches and one explicit bye; none requires this retirement supplementation.**

Resolution requires both controlling references, 127 unique comparisons, the exact approved event context, four exact PDF locators/IDs/raw observations, and the four expected HTML identities, scores and statuses. Unknown/missing conflicts, changed dissent, another tour/year/event/draw, or HTML disagreement abort before writing new reconciliation outputs. A failed run must not be treated as refreshing previously generated evidence.

The gate additionally requires 95 unique non-bye links, 95 source rows, no missing/extra/ambiguous mappings or duplicate accepted links, and all four retained resolutions. Unresolved aggregate discrepancies block it. The pilot report refuses stale reconciliation-code hashes, missing policy evidence or blocked gates rather than publishing hard-coded passing claims.

## Verified results and remaining gates

ATP: 128 positions, 32 byes, 96 entrants, 95 non-bye matches; 91 completed and four retired. Exact/normalized/conflicting links remain 77/15/3. WTA remains 95 normalized links: 92 completed, two retired and one walkover. Both inventory gates pass; both tours have 95/95 recall and precision, with zero unmatched or ambiguous result/source mappings and duplicate links.

ATP valid-count coverage remains 95/95; WTA remains 93/94 (98.9362%). Both pass only the 90% numerical event floor. WTA Andreescu–Stearns remains played and inventoried, with the whole statistical bundle quarantined and excluded from valid numerators and factors, ratings and forecasts. Its four reason codes and all Phase 1B evidence remain unchanged.

Retirement/default eligibility still prevents event factor-data admission; chronology/status policy blocks ratings and forecasts. The 95% tour-season gate is untested. Policy passage does not approve broader acquisition or modeling.

## Verification and limitations

Tests cover conflict preservation, expected HTML selections, dissenting values, conflict classifications, policy/version fields, other event/year/tour/draw contexts, unlisted conflicts, missing references, every HTML comparison field, duplicate/ambiguous mappings, unmatched rows and additional aggregate conflicts. Existing identity/score/status tests and both earlier audits are rerun. Reconciliation reruns are checked for identical bytes and modification times. Annual files, subsets, manifests, raw references and Phase 1B outputs are hash-checked; subsets are compared cell by cell. Documentation links/anchors, absolute paths, placeholders, ignore rules, authorized changes and whitespace are checked before commit.

During implementation, a generic version-field name initially overlapped the WTA field in generated output. It was separated as `reference_precedence_version` before final verification; the WTA field was restored and checked against the Phase 1C snapshot. A temporary documentation-edit command had a quoting syntax error before writing anything; the documents were then updated successfully. No raw bytes changed. Prior Phase 1C access/parser/rendering limitations remain documented in the [reconciliation report](indian-wells-inventory-reconciliation.md); no external availability was retested here.

Final checks passed: 19 preserved files retained hashes and modification times; all original official/source/PDF observation fields matched the Phase 1C snapshot; both repeated reconciliation outputs and earlier audits passed. Nine Markdown files yielded 45 valid local links and two valid anchors; 82 external links passed syntax checks only, with no network access. No machine-specific documentation paths, unapproved placeholders or whitespace errors were found.

## Recommended next milestone

**Historical Phase 1D recommendation:** the Phase 1E acquisition/audit proposed below was subsequently authorized and [completed](2021-annual-source-audit.md). See [current status](status.md) for the focused Phase 1F recommendation. This policy's scope and resolutions are unchanged.

**Recommendation, not authorization:** Phase 1E should separately authorize bounded ATP/WTA 2021 annual-file acquisition and schema/provenance auditing as the first additional development slice. Confirm exact pinned files, permissible local use and existing-path reuse before downloading. Indian Wells inventory no longer blocks that proposal, but this task grants no acquisition authority or multi-event admission. Keep 2024/2025 closed.

Later decisions include event inventory sources, final retirement/default eligibility, exact-date/completion-order evidence, rating-history scope, statistical specifications, dependencies and derived-publication rights. No additional season, model, analytical plot, portfolio integration, push, publication or deployment occurred. The next task must end with a response-only ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000.
