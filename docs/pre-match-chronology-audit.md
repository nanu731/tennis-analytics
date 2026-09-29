# Phase 2K: pre-match chronology evidence audit

Version 1.0.0. Offline implementation from clean `main` at `23ebd592b30f7c107ef8d2ffd64850c9cb311c97`, under the explicit Phase 2K prompt. No operational chronology, history, rating, factor fit or forecast was created.

## Terminal decision

**NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**.

All **2,580 frozen Phase 2H admitted matches** are retained exactly once in the match ledger. There are **zero verified actual match starts, completion-time bounds, historical result/statistics availability bounds, or pre-match cutoffs** in this scoped saved evidence. All **30 event cells** lack an independently supported pre-play event cutoff and completion/availability release bounds. Consequently neither match-sequential nor event-entry-only forecasting receives a saved-evidence pass. This is a negative evidence-sufficiency finding, not proof that safe forecasting is impossible or that no external evidence exists.

S02 remains paused and S08 provisional. No factor decision, membership, exclusion, source value, recovery rule or historical release changed. Admitted normal-completion status remains distinct from knowing when completion occurred. No cohort shrinkage, label-based ordering or availability imputation is used to obtain a pass.

## Inputs and interpretation boundary

The runner verifies **93 literal SHA-256 input pins** before processing and again before release. These include Phase 2H membership/dispositions, Phase 2H–2J code/reports/releases, prior frozen supporting inputs, the adopted Montreal chronology policy, and scoped Montreal and event-boundary evidence tables. Each reused date-page or event-boundary observation is linked to a pinned saved source, its fingerprint and locator. The two cited historical inventory/coverage tables are also pinned. Old empirical suites are not executed.

This audit reuses the pinned prior evidence classifications and checks their source links; it does not claim a fresh exhaustive extraction of every historical HTML/PDF. The event-boundary table is filtered to the 30 admitted cells before interpretation. Its historical 40-cell inventory and old eligibility judgments are not applied as current membership. Only the existing Phase 2H membership is authoritative. The same three annual files remain the cohort source: ATP 2023, WTA 2021 and WTA 2023 at archive revision `83733587353df8a41f2fd4f516147d5aa83f5a8d`.

Nine saved Montreal match pages have literal date-only start/end values; seven belong to admitted matches and two (LS042 and LS049) to excluded retirements. Their scheduling/play/completion semantics and timezone are unverified; all nine have scheduled structured metadata beside finished result cards. These are not verified actual dates. `tourney_date`, event windows, round, `match_num`, source row, filename and page position are labels/locators. Match duration is elapsed duration, not a clock anchor. Retrieval in 2026 and a later archive snapshot are provenance, not availability in 2021/2023. The Indian Wells printed RELEASED footer is preserved as text, not authenticated publication of all final results.

The adopted Montreal policy permits use-specific precedence where sufficient; it does not require universal exact timestamps. However a feeder edge alone cannot certify availability at a chosen cutoff. A conservative, independently justified interval or attested pre-play boundary could suffice for a suitable approved use. None is established here. Unknown, ambiguous, equal, overlapping or conflicting required bounds fail closed.

## Measured match evidence

| Scope | Admitted | Saved pilot completion corroboration | Published match dates only | Verified actual timing / availability / cutoff | Supported forecasting matches |
| --- | ---: | ---: | ---: | --- | ---: |
| ATP 2023 | 846 | 91 | 0 | 0 / 0 / 0 | 0 |
| WTA 2021 | 825 | 49 | 7 | 0 / 0 / 0 | 0 |
| WTA 2023 | 909 | 91 | 0 | 0 / 0 / 0 | 0 |
| Total | 2,580 | 231 | 7 | 0 / 0 / 0 | 0 |

All 2,580 retain their frozen `source_reported_normal` disposition; 2,349 have source-reported completion without the scoped pilot corroboration above. The audit does not upgrade any status to an independently timed result. The 152 matches lacking a defined M12 difference in Phase 2J remain in this chronology audit; metric availability does not control its denominator.

All 49 admitted Montreal matches retain the unresolved event-window discrepancy (overview August 9–15 versus PDF August 7–15). Seven admitted matches additionally retain the scheduled/finished metadata conflict; one retains LS007's quarterfinal date difference. The LS007 → LS003 same-published-day edge is not evidence of actual same-day play, suspension or a timezone explanation. Three inherited ATP pilot identity/reference conflicts remain visible in the unchanged scoped resolution fields; their adopted resolution is not a new chronology conflict or license to repair identifiers. The quarantined Indian Wells match/date disagreement stays outside membership.

Montreal's 49 admitted matches have previously checked player-chain accounting. There are 54 direct feeder edges: 45 between admitted normally completed endpoints and nine involving an excluded endpoint. The nine remain audit-only. The 45 are positive evidence of limited player-relative precedence, not a global order, actual timing, information availability or a forecast-ready subset.

Every expected cell is reported below, with zero supported forecasting matches in each. These are frozen admitted counts, not complete-event coverage or official recall.

| Event | ATP 2023 | WTA 2021 | WTA 2023 |
| --- | ---: | ---: | ---: |
| Australian Open | 126 | 126 | 127 |
| Canada | 54 | 49 | 53 |
| Cincinnati | 50 | 49 | 52 |
| Indian Wells | 91 | 91 | 91 |
| Madrid | 94 | 58 | 93 |
| Miami | 89 | 89 | 92 |
| Roland-Garros | 119 | 119 | 119 |
| Rome | 92 | 51 | 90 |
| US Open | 75 | 93 | 100 |
| Wimbledon | 56 | 100 | 92 |

## Dependency inventory and gates

A history window, initialization rule and fitted-state dependency graph remain unselected. Therefore the ledger inventories **conditional dependency candidates**, not fabricated actual prior histories. Row order and endpoint A/B order are lexical serialization only. No date, time, sequence or prior event is inferred from a label.

For match-sequential use, the ledger contains every unordered pair of admitted matches sharing an exact player ID within a tour, including cross-event and cross-season pairs. A pair sharing both players occurs once for each player's possible dependency; those are player-pair memberships, not unique match pairs. No name-based or cross-tour identity join occurs. Direct saved bracket edges are attached to their corresponding pair without promoting them to temporal releases. Transitive closure is not computed; an unannotated pair means no direct edge was attached, not proof that no partial-order relation could ever be established.

| Dependency class | ATP | WTA | Total |
| --- | ---: | ---: | ---: |
| Target match-cutoff requirements | 846 | 1,734 | 2,580 |
| Shared-player unordered match pairs | 12,650 | 48,498 | 61,148 |
| Target event-cutoff requirements | 10 | 20 | 30 |
| Same-tour unordered event-release pairs | 45 | 190 | 235 |
| Initialization/history-scope requirements, two approaches | 2 | 2 | 4 |
| Fitted-state as-of/dependency-scope requirements, two approaches | 2 | 2 | 4 |
| Saved bracket edges, separate evidence rows | 0 | 54 | 54 |
| Total ledger rows | 13,555 | 50,500 | 64,055 |

The full admitted inventories contain 193 ATP and 267 WTA player IDs. Of the 61,148 player-pair memberships, **4,149 are within a cell and 56,999 cross cells**. The 235 event pairs include all same-tour cell combinations, including WTA cross-season combinations; they are not merely adjacent source-label pairs. No pair is silently discarded because an earlier phase lacked a reference. There are **zero supported temporal releases in either direction**. The separate bracket rows preserve source/PDF locators and hashes; they do not double-count match membership or add forecasting dependencies.

Match-sequential use needs a defensible target cutoff plus proof that each selected contributing result completed and became available before that cutoff. Ordering disjoint-player updates is not invented; fitted transformations, opponent adjustments or globally mutable state could add other dependencies and need an explicit future specification. Cold starts and an empty chosen history cannot establish a cohort pass by bypassing cutoff evidence.

Event-entry use needs a common cutoff independently demonstrated to precede the earliest relevant event play, a frozen information set at that cutoff, and separately justified completion and availability release bounds for each contributing prior event. No within-event result is admitted as an event-entry update. Prior-event update order and the history/fitted-state scope would still need specification; a boundary alone would not validate every possible model. An arbitrary lag or source-label gap cannot authenticate release.

The tested interval predicate requires the latest plausible completion and availability to be strictly before the earliest justified cutoff, with reconciled clock/precision semantics, and the cutoff to be independently pre-play. Equality and overlap fail. The predicate can accept an independently attested pre-play boundary without an exact start timestamp; bracket precedence does not supply that attestation. Synthetic positive fixtures establish that the software can distinguish sequential support, event-only support and neither; they are not empirical evidence for this cohort. The actual negative decision follows missing necessary prerequisites for every intended match/cell, independently of any later window choice.

## Outputs, validation and limitations

Only three ignored outputs are released under `data/pilot/pre-match-chronology-audit/`:

- `match-evidence-ledger.csv`: 2,580 neutral-orientation rows, retaining original source IDs/locators, source-order labels, completion status, separate timing/availability/cutoff fields, scoped literal evidence, chain evidence, conflicts and missing-evidence reasons.
- `dependency-evidence-ledger.csv`: 64,055 rows, distinguishing mandatory cutoff/scope requirements, conditional unordered candidates, limited feeder support and excluded-edge evidence.
- `chronology-summary.csv`: 588 rows, reporting the complete cohort, both tours, every cell, dependency counts, all 166 scoped historical boundary observations with provenance (including the two excluded-page literals, explicitly separate from cohort counts), and exactly one terminal decision.

The directory was already ignored before any release was attempted; the runner stops if its output paths cease to be ignored. Existing releases with different bytes are preserved rather than overwritten. **117 focused checks passed**, including input-pin failure, exact membership, evidence classification, forbidden chronology substitutions, equal/overlapping/unknown/conflicting bounds, dependency accounting, all three decision branches, cohort-shrinkage rejection, ignored destinations, exact five-file tracked scope and independent byte-identical full reruns. Every generated summary and flagged evidence class was inspected. All 93 input pins verified; 164 historical files retained identical hashes, sizes and modification times. The status history after `CURRENT_SNAPSHOT_END` is unchanged and the diff passes whitespace checks. The five tracked files are exactly the new runner, tests and this report, plus `docs/status.md` and `docs/data-source-contract.md`. `PROJECT_CONTEXT.md` and all Phase 2H–2J artifacts remain unchanged. Its Phase 2K recommendation is now fulfilled; current status and this report record the result without expanding that file's authorized edit scope.

No network, acquisition, new source/year, inferred timestamps, history, rating, refit, dependency, portfolio work or publication occurred. The historical 669/105/82/612-check records are preserved and their suites were not rerun. This audit depends on immutable saved data and prior evidence classifications, not execution of those suites. The evidence gap is broader than ordering: historical availability and independently defensible cutoffs are absent even where bracket precedence is supported. Official recall and statistical uncertainty remain separate unresolved questions.

Release SHA-256 fingerprints:

| Output | SHA-256 |
| --- | --- |
| match-evidence-ledger.csv | `ed0f6ff0eebad4f4e79ba50d8935532bcf3a91205893db8fad19984fc58367a8` |
| dependency-evidence-ledger.csv | `1aa373417c75f4be29c1a09c783de7978910e36a2f1dbc9667883dd5e3d87989` |
| chronology-summary.csv | `cf9b0847b6d736f3e5044189201321f78f71d0c1d6408b9306d2ff0d07997bd2` |

Development checks initially stopped on blank-string timing fields, two omitted cited-file pins and an empty conflict-list serialization case. These reader/manifest issues were corrected without changing saved inputs. A focused assertion also exposed the distinction between nine saved pages and seven admitted-page observations; two retirement pages remain excluded. The final saved scripts pass all checks, and no transient run was released as a result. No substantive timing conflict was resolved by these fixes.

## One bounded next step and exact approval

Recommend **Phase 2L: a documentation-only temporal-evidence specification for the candidate WTA Montreal/Cincinnati 2021 event pair**. Identify the minimum evidence needed for pre-play cutoff, completion, historical result/statistics availability and player-relative dependencies, plus acceptance tests and access/retention constraints. Do not assume that printed dates establish the transition or that an external source is accessible. Preserve the current cohort-wide negative result; a later bounded pilot would not establish broader readiness. A new specification is justified by this concrete evidence blocker, not a need to restate existing plans.

Exact approval language: **“Approve Phase 2L: draft a documentation-only, rights-first temporal-evidence specification for the candidate WTA Montreal/Cincinnati 2021 event pair. Define the evidence and acceptance tests needed for pre-play cutoffs, completion and historical result/statistics availability. Preserve all cohort and factor decisions. Do not browse, contact providers, acquire data, resume OTD, infer timestamps, build histories or fit models. Any subsequent evidence acquisition requires separate approval.”**
