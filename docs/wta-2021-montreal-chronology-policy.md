# WTA Montreal 2021 chronology policy

**Phase 1O, 2026-09-21. Policy version 1.0.0: ADOPTED.** The user explicitly approved all thirteen Phase 1N recommendations, subject to the five clarifications recorded below. Policy adoption establishes requirements; operational chronology is NOT_IMPLEMENTED and chronology/model readiness remains BLOCKED.

## Approval and historical record

The Phase 1O user prompt authorizes this rename and adoption, followed by drafting a separate acquisition plan. It does not authorize requests, downloads, scraping, hidden APIs, browser automation, new raw files, canonical model inputs, event admission, Elo, Four Factors, forecasting or publication. User approval does not establish provider permission.

The original proposal 0.1.0 remains preserved in Git at commit `5156ac2c34972bbef4584df62667f0bfda6f44c0`, path `docs/wta-2021-montreal-chronology-policy-proposal.md`, blob `6e383568aaac82d235c2a4f13f6683fb09c3545a`. That commit did not approve the proposal. Phase 1N audit code and its ten ignored tables deliberately retain historical PROPOSED_NOT_APPROVED / PENDING_USER_APPROVAL / NOT_ADOPTED states. They reproduce the evidence and decision state of that milestone, not current approval. The permanent policy and current status govern approval now; neither retroactively rewrites those artifacts.

Approval clarifications: no last-K or elapsed-time window is selected; unknown same-day availability defaults to blocking the dependent result; daily batching is a candidate only and needs separate approval; the dependency gate is use-specific rather than universally timestamp-based; acquisition planning grants no discovery, access or download permission.

Predictions and updates may use only information available before the applicable prespecified cutoff. Source tourney_date, event windows, retrieval times, CSV row order, match_num, filenames and HTML/PDF layout order cannot substitute for match chronology. Corroborated bracket feeder relationships are evidence about one player only; they do not order unrelated matches or establish calendar dates. Retirements, their partial statistics and walkovers remain excluded from statistical histories and Elo updates under the approved primary population design. Missing or conflicting evidence fails closed.

## Finding

Existing evidence supports the event's complete player-relative bracket progression, but it does not establish actual match dates, actual start times, completion times or historical result-publication times. Chronology/model readiness remains **BLOCKED**. A missing global timestamp alone is not the decisive problem: the unresolved prediction cutoff, calendar semantics and cross-event boundaries also matter.

| Directly audited measure | All results | Normally completed |
| --- | --- | --- |
| Preserved inventory | 55 | 49 |
| Source event-level date label available | 55 | 49 |
| Only event-level dates; no saved match-page dates | 46 | 42 |
| Saved match-page published start/end dates | 9 | 7 |
| Verified actual start date | 0 | 0 |
| Verified actual start time | 0 | 0 |
| Verified completion date | 0 | 0 |
| Verified completion time | 0 | 0 |
| Within-event player chains fully accounted for | 55 records across 56 players | All 49 records represented |

The five retirements and one walkover remain in the audit with their unchanged Phase 1M exclusions. Completed-match count coverage remains 42/49 source-only and 49/49 with seven separate approved recovery bundles. Historical apparent-play presence remains 47/54 and 54/54. Neither eligibility nor the numerical 90% gate supplies chronology.

## Evidence and its semantic limits

The audit revalidates the existing manifests, twelve saved official references, four ATP/WTA 2021/2023 annual files, complete Montreal inventory and Phase 1I overlay. Archive revision remains 83733587353df8a41f2fd4f516147d5aa83f5a8d. It reconstructs Phase 1M eligibility without changing its outputs.

The source supplies tourney_date = **20210809** for this event. This is an event-week label, not a demonstrated match date. The saved overview displays **Aug 9 - Aug 15, 2021**; the PDF's TOURNAMENT DATES header displays **August 7-15 2021**. The scope or cause of the differing windows is unknown; qualifying is a possible explanation, not a verified one. No match is assigned either window's opening day.

Only LS001–LS007, LS042 and LS049 have saved match pages. Their specifically linked SportsEvent blocks contain date-only startDate/endDate values on August 9, 13, 14 and 15. Each page's startDate equals its endDate; this does not demonstrate same-day actual completion. All nine blocks say EventScheduled despite finished result cards. The adopted recovery/status policy resolves its stated count/status questions only; it does not authenticate scheduling or play-date semantics.

LS007's quarterfinal page publishes August 14; the other three saved quarterfinal pages publish August 13. Its advancing player also appears in LS003, whose semifinal page publishes August 14. This produces one same-published-day player progression. It does not prove same-day actual play, a timezone explanation, a postponement, a suspension or a corrected date. The difference remains visible without selecting a preferred date.

No verified timezone, scheduled clock time, actual start timestamp, completion timestamp, suspension interval or resumption timestamp was established in the scoped source/date metadata and result evidence. Scheduled date remains semantically unverified, separately from its preserved published value. Duration is elapsed match duration, not a clock-time anchor; it cannot recover start or completion time here. Result-availability time also remains unknown. Missingness is explicit, never midnight, zero or an event-week substitution.

Source/reference retrieval timestamps record acquisition in 2026, not historical play or result availability in 2021. The saved draw page also contains unrelated 2026 structured event metadata; extraction isolates the exact 2021 event/match scope. Generic hidden Upcoming/Suspended UI labels are not affirmative suspension records. This is a bounded evidence finding, not a claim that no better historical evidence exists elsewhere.

## Supported partial ordering

The independently reconciled HTML and PDF brackets support **54 direct player-relative advancement edges**. Every edge links a result's advancing player to that same player's next-round appearance through matching feeder positions in both representations. **45 edges have normally completed records at both endpoints.** Nine involve an excluded retirement or walkover endpoint and remain audit evidence only. All 56 players' observed within-event chains are accounted for, including players with one appearance and no edge.

All 49 completed matches are represented in these checked chains. No global sequence, timestamp or processing rank is produced. Byes are bracket structure, not match observations. An excluded result can explain advancement without supplying any statistical history or Elo update.

This uses validated feeder relationships and player identities, not a blanket sort by round. A player's earlier-round advancement must precede their next-round participation in the bracket; unrelated matches remain unordered. There are zero reversals between published dates on edges with two saved pages, but limited date coverage cannot prove absence of real scheduling anomalies. The single same-published-day edge is LS007 → LS003.

**Analytical reasoning, not a computed model result:** for a fixed, player-local Elo algorithm, disjoint-player updates generally commute, so an arbitrary global ordering adds no meaningful information. That property must be tested when Elo is implemented. It can fail when shared parameters, global recalibration or other mutable cross-player state are updated online. Bracket evidence does not establish calendar-based inactivity, lookback windows, cross-event history or the availability of information at a scheduled prediction cutoff.

## Historical Phase 1N option comparison

| Option | Narrow evidence among 49 completed matches | Fully sufficient for the proposed forecasting gate now | Main limitation |
| --- | --- | --- | --- |
| Exact start/completion/result-availability timestamps | 0 | 0/49 | Required timing evidence absent |
| Verified-date conservative daily batches | 0 verified play/completion-day bundles | 0/49 | Dates, timezone and completion-day semantics unverified |
| Published dates used operationally | 7 published-date candidates; LS007 flagged | 0/49 | Metadata is not verified play/completion evidence; 42 pages absent |
| Bracket partial order only | 49 with within-event player chains accounted for | 0/49 under the full gate | Useful ordinal evidence; prediction-cutoff and cross-event/calendar requirements unresolved |

The last row does not claim that 49 records lack local relative-order evidence. It distinguishes that supported ordinal prerequisite from full chronology sufficiency. A deliberately restricted within-event, result-order-only Elo experiment could use that prerequisite after separate approval and explicit assumptions; it would not establish readiness for the full calendar-based forecasting pipeline. The user has now adopted use-specific evidence requirements; no operational option or model is executed here. The table preserves the Phase 1N evidence comparison.

## Approved decisions

### D1. Minimum Elo chronology and prediction cutoff

Options: require exact timestamps everywhere; permit proven player-relative precedence where sufficient; or sort by convenient identifiers. **Adopted choice: the second option**, with a prespecified prediction cutoff and evidence that every included result was available before it. Exact times are necessary only when the intended use cannot be established by validated precedence or an approved conservative boundary. Reject identifier order. This prevents future-result updates without inventing global precision. Drawback: some uses remain blocked even with a complete bracket. Still required: cutoff semantics, cross-event history boundaries and later implementation tests for independent-update behavior.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D2. Lagged Four Factors histories

Options: last-K completed-match windows; elapsed-time windows; or current/full-event totals. **Adopted choice: prespecifying the window and requiring each contributing match to have completed and become available before the prediction cutoff.** Ordinal windows can use adequate partial-order evidence; elapsed-time windows additionally need reliable calendar dates. Exclude retirement statistics and walkovers under the approved population design. Drawback: stronger evidence requirements reduce usable history. Still required: window choice, availability rule, opponent-adjustment timing and valid cross-event boundaries. No metric or feature is calculated here.

**Clarification:** last-K versus elapsed-calendar-time windows remain UNSELECTED until the later prespecified modeling and evaluation protocol. Last-K needs safe ordinal dependencies and availability; elapsed-time needs those plus verified calendar boundaries. This approval selects neither window.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D3. Published or scheduled dates as operational dates

Options: accept raw metadata; require corroboration of date meaning; or permit a separately labeled sensitivity assumption. **Adopted choice: corroboration for primary use; keep current metadata as observations only.** A sensitivity assumption would need separate approval and could not be presented as verified chronology. EventScheduled plus a finished card does not authenticate actual start/completion dates. Drawback: all seven completed-page candidates remain operationally blocked now. Still required: source semantics, date attribution, completion-day evidence and timezone treatment.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D4. Event-week date substitution

Options: substitute tourney_date; use a tournament-window boundary as a match date; or prohibit both substitutions. **Adopted choice: prohibition.** Event-week labels and event windows remain separate context fields, never actual-match dates or midnight timestamps. This prevents artificial ties and false chronology. Drawback: many rows remain undated. Still required: independent match-specific evidence wherever a calendar date is needed.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D5. Bracket progression

Options: ignore bracket evidence; accept exact same-player feeder edges; or treat all round labels as global chronology. **Adopted choice: exact corroborated feeder edges only**, retaining identities, source links and locators. Edges establish player-relative advancement precedence, not dates or ordering between unrelated matches. Drawback: they do not resolve calendar timing or external events. Still required: validated complete inventory, unique identities and results, acyclic progression and an approved interpretation at the chosen cutoff. Preserve excluded-result edges without converting them into history updates.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D6. Same-player matches on one date

Options: arbitrary tie-break; corroborated within-day precedence; or conservative exclusion/batching. **Adopted choice: using prior results only when their availability before the chosen cutoff is established; otherwise use an approved conservative fallback or block.** A bracket edge can support a pre-start precedence interpretation but cannot establish availability before an earlier scheduled cutoff. Drawback: useful earlier results may be omitted. Still required: actual-day semantics and the LS007/LS003 case review; do not infer actual same-day play from their metadata.

**Clarification:** when availability of an earlier same-day result cannot be established, the default is BLOCK_DEPENDENT_RESULT: block it from the dependent history or update. No arbitrary tie-break is allowed. Preserve the missing dependency and report its effect; do not silently claim a complete history or a passed event gate.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D7. Conservative daily batching

Options: sequential within-day processing; freeze histories at the prior verified day boundary; or block uncertain dates. **Adopted choice: considering prior-day batching as a separately approved fallback only after play/completion dates and the time basis are verified.** All forecasts in a batch would use only eligible results available before that boundary. This avoids uncertain within-day leakage but deliberately discards genuinely available earlier same-day results. Still required: a documented common time basis, completion-day handling, cross-event comparison and prespecified sensitivity analysis. Current date-only metadata cannot activate batching.

**Clarification:** daily batching is CANDIDATE_ONLY, NOT_ACTIVATED. It requires verified date semantics, a defined time basis, validation and separate approval. Adoption of this policy does not activate any fallback.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D8. Suspensions, resumptions and availability

Options: update at original start; update at resumed start; or wait for final completion and result availability. **Adopted choice: the last option.** Keep original start, suspension, resumption, final completion and availability separate. For a primary pre-match forecast, freeze features at its prespecified original cutoff; a resumption forecast would be a different target requiring approval. Drawback: uncertain completion can delay or prevent updates. Still required: reliable timing/status evidence; absence of a suspension marker is not proof of no suspension.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D9. Conflicting or ambiguous dates

Options: choose the convenient value; infer a timezone or scheduling correction; or preserve and block dependent uses. **Adopted choice: preserving observations and blocking chronology-dependent use until an explicit evidence-backed resolution.** Keep LS007 and the differing event windows as distinct issues. Do not assign all QFs August 13 or explain the PDF window as qualifying without evidence. Drawback: unresolved cases remain unavailable. Still required: exact corroborating evidence and a narrowly scoped resolution proposal.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D10. Missing evidence and failure behavior

Options: fill gaps; silently omit uncertain histories; or preserve records and fail closed with reasons. **Adopted choice: the third option.** Missing, duplicate, contradictory or changed evidence prevents a readiness claim for the dependent use. Preserve excluded and unknown records; do not shrink the apparent universe to manufacture completeness. Drawback: deliberate blocking and explicit history limitations. Still required: agreed reason codes and tests at the later model-input boundary. Existing statistical coverage thresholds remain unchanged.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D11. Minimum event-level chronology gate

Options: accept partial chronology coverage as admission; require exact timestamps universally; or require use-specific chronology for every intended prediction/update dependency. **Adopted choice: the third option**, with a complete inventory, preserved exclusions, valid identities, a declared cutoff, safe dependencies for all 49 intended completed predictions and no unresolved conflict affecting a selected dependency. Calendar-dependent operations need calendar evidence; ordinal-only operations need defensible precedence. Drawback: narrower experiments cannot be mistaken for full-event readiness. Still required: explicit history initialization/cross-event boundaries and passing implementation tests. Current gate remains BLOCKED.

**Clarification:** this is a USE_SPECIFIC_DEPENDENCY_GATE. Safe evidence is required for every dependency used by an intended forecast or update. Universal exact timestamps are not required when corroborated player-relative precedence is sufficient for that particular use; the relevant cutoff and availability still must be defensible.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D12. Extension beyond Montreal

Options: generalize this bracket automatically; extend after event-specific audits; or require timestamps only. **Adopted choice: event-specific evidence audits plus explicit cross-event chronology.** Handle overlapping/adjacent tournaments, timezone/date boundaries, calendar anomalies, suspended matches and selected rating-history scope before combining player histories. Disjoint matches need no invented relative order where the model truly permits independence. Drawback: additional evidence and validation work. Still required: relevant panel inventories, source semantics, common timing rules and approval for any broader acquisition or historical warm-up scope.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

### D13. Additional acquisition

Options: stop at current evidence; immediately fetch more pages; or separately propose a bounded acquisition plan. **Adopted choice: a separate plan after policy review.** Identify exact candidate resources, unresolved questions, intended semantic evidence, rights constraints, paths and stopping conditions before requesting acquisition. More pages with the same ambiguous fields may not resolve chronology. Drawback: a plan may conclude the required evidence is unavailable. No URL has been newly checked and no future resource is assumed to exist or be usable.

**Clarification:** PLANNING_ONLY. Further acquisition requires a separately approved bounded plan. No URL requests, downloads, scraping, hidden API use, browser automation or new raw-data files are authorized by adoption.

Approval: APPROVED; operational chronology: NOT_IMPLEMENTED.

## Reproduction, safeguards and local artifacts

Run from the repository root using existing base R and existing PDF/checksum tooling:

```sh
Rscript R/audit_montreal_chronology_evidence.R
Rscript R/test_montreal_chronology_evidence.R
```

The audit compares two current validated reconstructions, not saved output existence. It preserves source/official bytes and prior outputs. A changed baseline, duplicate observation, contradictory progression/date, changed identity/result/locator or missing policy evidence stops current success. It does not generate a processing sequence or update histories.

Ten detailed tables remain ignored under data/pilot/development-2021/montreal-chronology-evidence/: dispositions.csv, observations.csv, edges.csv, players.csv, event-observations.csv, match-page-observations.csv, conflicts.csv, options.csv, summary.csv and decisions.csv. They retain observed values, semantic roles, locators, precision, timezone state, verification state, missingness reasons and fingerprints. Full official material is not committed. This permanent policy is handwritten adopted guidance; the aggregate findings above are checked against the reproducible audit.

Tests exercise all 55 dispositions, unchanged eligibility, exact page scope, no date borrowing/substitution, row permutation, identifier independence, retrieval semantics, missing times/timezones, LS007, valid player progressions, duplicates/conflicts, changed fingerprints and linkage, proposal nonadoption, immutable deterministic reruns and ignored-data boundaries. Existing inventory, recovery, completed-match and source-evidence suites remain unchanged. See [status](status.md) for the completed run record.

## Unchanged boundaries and next action

| Gate | State |
| --- | --- |
| Event admission | NOT_EVALUATED |
| Canonical analytical population | NOT_IMPLEMENTED |
| Chronology policy | ADOPTED, version 1.0.0 |
| Operational chronology | NOT_IMPLEMENTED |
| Chronology/model readiness | BLOCKED |
| 95% tour-season gate | NOT_TESTED |
| Modeling authorization | FALSE |
| Publication | BLOCKED_PENDING_RIGHTS_REVIEW |

The flagship Four Factors versus surface-adjusted Elo question, ATP/WTA separation, fixed panel and 2021–2023 / 2024 / locked 2025 split remain unchanged. Challenger work remains deferred. No Net Point Rating, factor, rating, forecast, canonical A/B record or operational chronology was produced. Portfolio was not modified. Local user authorization does not establish publication rights, including rights over aggregates.

**Follow-up:** Phase 1O drafted the separate [chronology-acquisition plan](wta-2021-montreal-chronology-acquisition-plan.md). Phase 1P separately approved Stage A only (A1–A4, A9, A10) and [stopped after its one terms request](wta-2021-montreal-chronology-stage-a.md) because programmatic access was assessed PROHIBITED. A5–A8 and all later stages remain pending. Policy adoption itself grants no acquisition, operational chronology or model authority. Require another response-only ChatGPT Handoff of no more than 2,000 words.

Related standing guidance: [project context](../PROJECT_CONTEXT.md), [data contract](data-source-contract.md), [inventory](wta-2021-montreal-inventory-reconciliation.md), [recovery policy](wta-2021-montreal-recovery-policy.md), [status policy](wta-2021-montreal-inventory-status-policy.md), [reference feasibility](wta-2021-montreal-reference-feasibility.md) and [completed-match coverage](wta-2021-montreal-completed-match-coverage.md).
