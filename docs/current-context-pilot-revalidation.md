# Phase 2E: current-context pilot eligibility and count revalidation

**CURRENT_CONTEXT_PILOTS_REVALIDATED.** Release 1.0.0 reconstructs the three previously approved saved pilot populations and agrees exactly with frozen membership evidence. It does not calculate tennis performance metrics or establish valid Four Factors, forecast value or superiority to Elo.

## Authority and implementation

Started clean on main at f3861494dc72b432479a0ac748e5204b25514690, `Define Package B evidence route`, 31 commits ahead / zero behind the existing local origin/main. No remote refresh or push. The approved scope is ATP Indian Wells 2023, WTA Indian Wells 2023 and WTA Montreal 2021 only.

[The new base-R script](../R/revalidate_current_context_pilots.R) is inert when sourced. It pins current [PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md), the [Phase 2B protocol](four-factors-definition-protocol.md), the [current source contract](data-source-contract.md), [Phase 2D's stop decision](package-b-evidence-route-proposal.md), all six saved Phase 2D planning outputs and every source/reference/manifest/overlay/policy/comparison it consumes. Literal pins cannot refresh themselves. [Input provenance](../data/pilot/current-context-pilot-revalidation/input-provenance.csv) records all 97 content-input paths, roles, SHA-256 hashes and byte sizes. A separate literal preservation allowlist in the script protects all 241 prior files (including all 175 prior data files), excluding only the two authorized mutable documents.

Annual bytes are authenticated, then literal tournament-ID prefixes select the approved records before CSV parsing. Only ATP 2023-0404, WTA 2023-609 and WTA 2021-806 records are parsed. Unselected annual records remain opaque. Empty in-memory placeholders preserve the original Montreal physical row locators required by the historical recovery builder; they are not observations and never enter eligibility comparisons. No other event is investigated. Saved manifests may describe earlier acquisitions beyond these pilots, but those paths are not followed for analysis. Historical files outside content scope receive hash/size/mtime preservation checks only; no OTD resource is investigated.

The script reuses immutable inventory, status, quarantine and structural-count validators in a private environment. It replaces only broad annual loaders with the bounded loader and replaces old writers with equality checks or in-memory serialization. It independently reparses saved official Indian Wells references and Montreal HTML/PDF, reconstructs the entire seven-bundle recovery overlay, compares it identically with the saved RDS, and applies all adopted event-specific rules. Historical source code is not edited. The copied eligibility adapter contains count bounds and outcome-neutral identity ordering only; no Phase 2A metric or outcome function is loaded by production.

## Reconstructed evidence and frozen comparison

| Pilot | Non-bye inventory | Byes | Normal completion | Retirements | Walkovers | Accepted bundles | Quarantined | Original accepted | Recovered accepted |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP Indian Wells 2023 | 95 | 32 | 91 | 4 | 0 | 91 | 0 | 91 | 0 |
| WTA Indian Wells 2023 | 95 | 32 | 92 | 2 | 1 | 91 | 1 | 91 | 0 |
| WTA Montreal 2021 | 55 | 8 | 49 | 5 | 1 | 49 | 0 | 42 | 7 |
| Total | 245 | 72 | 232 | 11 | 2 | 231 | 1 | 224 | 7 |

These are reconstructed results compared with historical targets, not targets assigned as observations. Including bye advancement there are 127, 127 and 63 bracket blocks respectively (317 total). Byes do not become match records. The retirement and walkover categories preserve event-specific exclusions; all eleven retirements and both walkovers remain outside analytical bundles. The completed WTA Indian Wells quarantine remains outside the 231 accepted bundles. Montreal's seven recovered bundles remain separate from its 42 original accepted bundles; its 126 field decisions retain their source orientation and adopted proof.

Internally, full source-ID sets are compared for inventory, normal completion, all exclusions, accepted bundles, retirements, walkovers, quarantine, recovery and original bundles. Bye sets use their full official record IDs. Unknown statuses and invalid/missing completed bundles cannot silently become empty sets. Equality requires both full set equality and equal SHA-256 set fingerprints; equal counts with substituted members fail. Every frozen eligibility field is also compared, including source/player orientation, statuses, provenance, policy and preserved conflict details. Fingerprints sort IDs in byte order and hash the cardinality followed by newline-delimited IDs.

The existing inventory gates and Montreal policy criteria pass before missing/duplicate links or unresolved conflicts can be reported as zero. Adopted source disagreements remain preserved in memory and their affected-record counts remain visible; resolved evidence disagreement is not relabeled as missing history. No unexplained eligibility or bundle discrepancy remains.

## Aggregate outputs and release behavior

The seven ignored, untracked CSVs under data/pilot/current-context-pilot-revalidation/ are:

- input-provenance.csv: pinned input roles, hashes and sizes.
- pilot-comparison.csv: one row per pilot, counts, fingerprints and exact-agreement state.
- exclusion-comparison.csv: nine exclusion/evidence categories per pilot, including byes and failed-link/conflict categories.
- bundle-comparison.csv: five bundle categories per pilot, distinguishing original, recovered, invalid, quarantined and accepted.
- rights-scope.csv: one scoped-use assessment per pilot.
- decisions.csv: one terminal decision, all three pilot states, stopped/paused boundaries and the exact next approval.
- summary.csv: aggregate counts and release version/status.

No output contains player names, match-level rows, scores or source records. Full IDs stay inside reconstruction and comparisons. All seven files are staged and validated before one directory rename installs the complete release. Missing/changed inputs, altered membership, unknown status, ambiguous orientation, changed recovery/quarantine, rights conflict, incomplete pilot scope or historical-file mutation fail closed. Existing releases must match byte-for-byte; differing or partial releases are preserved for review. Identical reruns preserve modification times. No failed pilot can be dropped to pass the others.

## Saved rights-scope evidence and unresolved conditions

All three pilots return **SCOPED_LOCAL_USE_SUPPORTED_BY_SAVED_RECORD** for this user-approved local eligibility/count revalidation. The saved basis is [DATA_LICENSE.md](../DATA_LICENSE.md), the source/reference manifests, adopted event policies and the present task's recorded source-contract authority. Original Sackmann attribution and applicable noncommercial/share-alike conditions remain. The Montreal layer remains a user-authorized local recovery artifact, not a provider redistribution grant.

This is not a new legal conclusion, external terms check, permission to resume collection or approval to publish derivatives. Phase 1P's recorded WTA programmatic-access prohibition and retention ambiguity remain unresolved for that proposed mode; they have not been erased by a local audit. Publication stays BLOCKED_PENDING_RIGHTS_REVIEW. A required unresolved scoped-use comparison would produce CURRENT_CONTEXT_PILOTS_INCONCLUSIVE; an explicit scoped conflict or failed prerequisite would produce CURRENT_CONTEXT_PILOTS_BLOCKED. Both prevent a passing release and require one review of the named discrepancy.

## Verification and historical preservation

[The new tests](../R/test_current_context_pilot_revalidation.R) exercise allowlisted/pinned reads, exact scope, forbidden operations, exact sets, orientation, exclusions, quarantine/recovery, unknown and rights states, deterministic serialization, atomic failure handling, historical preservation, links, anchors and Git boundaries. The final verification record is in [status](status.md).

Both final Phase 2E runs passed all 409 checks with identical logs, blocked R network transports and blocked common model/statistical functions. Independent readback confirmed every table shape and aggregate count. All 241 protected historical files and all seven first-published release files retain their hashes, sizes and timestamps. All 30 Markdown documents, 214 local links and 13 anchors pass. The public revalidation entry point also completed. Development guard corrections and the full-build inconclusive-rights reporting correction are disclosed in status; no evidence or output was changed to manufacture a pass.

The unchanged Phase 2D suite passed all 200 checks on the clean baseline before current-authority edits. After edits, its historical authority contract and frozen artifact pins are checked without changing its older headline or data-universe assertions. Phase 2A's actual verifier must still return `Phase 2A BLOCKED: input hash mismatch`; that refusal is not an empirical audit pass. Its fourteen output pins and all prior tracked files remain protected. No Phase 2A empirical function is invoked.

## Analytical limitations and unchanged decisions

All three pilots are hard-court convenience samples. ATP contains one event-season; WTA event and season remain confounded. They cannot establish surface stability, broad temporal stability, final factor definitions or predictive superiority over Elo. Later same-match empirical diagnostics remain exploratory and subject to mechanical coupling, correlated ingredients and overfitting concerns.

Package B remains STOPPED. OTD remains PAUSED_BY_USER_AFTER_PHASE_1S. Q6 and Q8-Q10 remain PENDING_USER_APPROVAL. The panel, 2021-2023 development / 2024 validation / locked 2025 split, retirement and walkover exclusions, missing-data policy, 90% event and full-panel 95% tour-season gates are unchanged. No 2022/2024/2025 data, new source, metric, factor selection, imputation, model, rating, Elo, history, forecast, dependency, publication or portfolio change is authorized or implemented. Canonical admission and operational chronology remain separate unfinished work. Challenger promotion readiness remains deferred until flagship infrastructure is validated.

## Next approval

Approve **one bounded exploratory empirical pilot analysis** limited to ATP Indian Wells 2023, WTA Indian Wells 2023 and WTA Montreal 2021. It may reproduce and extend descriptive candidate-metric diagnostics under current context with explicit same-match coupling and convenience-sample limitations. No forecasts, new cells, acquisition or Package B expansion. Require a response-only ChatGPT handoff of no more than 2,000 words. This recommendation is not implemented or automatically approved; no further readiness plan or evidence-route proposal is recommended.
