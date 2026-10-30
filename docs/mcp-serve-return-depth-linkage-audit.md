# MCP Serve–Return depth linkage audit

## Prospective schema and dispositions — frozen before linkage calculation

Release `MCP_SERVE_RETURN_DEPTH_LINKAGE_1.0.0`, baseline
`889abe6512d79b62bd70bf5024031ee6415ec397`. Use only the unchanged
`MCP_EXPANDED_RECURRING_1.0.0` sample, actions, observable states, point
reconciliation and completion eligibility. Reuse saved verification helpers;
no parser, completion or full-point QA rule changes.

Six flat ignored outputs use `data/pilot/mcp-serve-return-depth-v1-`:
`point-linkage.csv`, `depth-cells.csv`, `context-support.csv`,
`repeated-pair-support.csv`, `coverage-summary.csv`, `summary.csv`.

One point-ledger row per inventoried service point preserves match/point IDs,
source row/file, raw sequences, server/receiver source and neutral identities,
delivering-Serve/first-Return action IDs, raw action tokens/spans, recorded
FIRST/SECOND context, literal serve direction and return depth with their
source missingness statuses, +1 disposition, completion and point QA flags.
Observed prefixes remain audit evidence; they cannot enter the pair denominator
when the full point is withheld. Never skip an error/unknown first response
and link a later stroke. Administrative challenges add no response stroke.

A valid pair requires unchanged completion eligibility, full-point sequence and
score QA, unique supported delivering Serve and first in-play Return, exact
player/opponent ownership, correct incoming action linkage and serve number,
recorded direction 4/5/6 and recorded Return depth 7/8/9. Return winners remain
eligible pairs with known absent +1; no next-stroke-survival filter is allowed.
Return errors are separate from in-play responses, always Return-owned. Ace,
double fault, collapsed unreturnable and supported administrative point without
a returned ball have structural absence of an in-play pair. An unresolved
boundary cannot establish structural absence.

Primary dispositions are mutually exclusive, in this order: completion
exclusion; withheld point QA (authority conflict, unsupported notation or other
missing/conflicting observation as subtypes); QA-valid unknown response
observation without supported absence evidence; supported structural absence;
Return error; omitted/explicit-unknown/unsupported attributes; valid pair.
Keep simultaneous diagnostic flags independently, including failures in excluded
matches. Attribute flags apply to observed pair candidates, not structurally
absent balls. Structural absence is not an execution success or depth zero;
withheld observations never become OTHER or known absences. Unsupported grammar
is preserved, not extended.

Pinned MatchChart 0.3.2 Instructions A46–48 define serve direction 4/5/6 as
wide/body/T; 0 means unknown. A170–180 define optional in-play Return depth:
7 in the service boxes, 8 behind the service line nearer that line, 9 nearer
the baseline. Omitted depth and 0 are not measured depth. Check meanings
against the pinned workbook and saved evidence manifest before processing.
Do not infer coordinates, shot quality or advantageous depth.

Generate a complete match × neutral server slot × FIRST/SECOND × 4/5/6 × 7/8/9
count grid, retaining zero cells. Each numerator is the number of valid pairs
with that depth; the compatible direction denominator is their sum. Zero
opportunity rates remain undefined. Also report match/category retention
against all inventory points, QA-valid eligible points and observed in-play
pair candidates, with denominators explicitly named. Unknown contexts and
missing directions/depths stay in the point ledger and coverage counts.

Context support is one row per receiver–server–match–FIRST/SECOND unit, including
empty units, with three direction counts, observed-direction count, single-pair
cells and missing/withheld exposure. Multiple-direction support means at least
two represented directions, an algebraic condition for comparison rather than
a chosen adequacy threshold. Single-pair counts describe sparsity, not eligibility.
Repeated-pair support groups exact ordered server/receiver identities and
FIRST/SECOND within category across matches; report distinct matches and
source-date batches, multiple-direction matches and strictly earlier-batch
exposure. Same-date batches remain simultaneous. Preserve all inventory matches
and both player perspectives; no outcome, error-rate or QA-selected replacement.

This is a support audit only. No profile differences, comparative losses,
probabilities, NPR associations or attributed advantage are assessed. Proceed
only to a bounded descriptive response-profile experiment if independently
reconciled pairs and within-context multiple-direction exposure actually exist;
otherwise stop for missing support. No post-results adequacy cutoff may be added.
Existence of support does not establish statistical adequacy, attribution,
independence or factor qualification. Serve owns delivery, Return owns response
and depth, and Serve +1 remains exclusively Rally-owned.

## Measured support and decision

**BOUNDED_RESPONSE_PROFILE_EXPERIMENT_SUPPORTED.** Both categories contain
independently linked pairs and within-receiver–server–match–serve-number
exposure to multiple directions. This permits a bounded descriptive profile
comparison, not an adequately powered test, chronological transfer claim,
server-attributed advantage estimate or qualified Serve factor. No comparative
profile differences were calculated in this audit.

### Inventory, denominator and retention

Historical ATP/WTA file labels below mean men's/women's categories; they do not
newly verify early-chart tour membership. All 223 charts and 43,310 points remain
inventoried, with the unchanged three completion exclusions. Official completion
remains unverified; the frozen gate establishes internal chart consistency.

| Accounting unit | Men | Women |
| --- | ---: | ---: |
| Inventoried / completion-eligible matches | 106 / 104 | 117 / 116 |
| Inventoried / eligible service points | 26,318 / 25,902 | 16,992 / 16,829 |
| QA-valid eligible points | 22,910 | 13,637 |
| Observed eligible in-play pair candidates, including withheld prefixes | 17,510 | 11,987 |
| QA-valid eligible in-play pair candidates | 15,029 | 8,997 |
| Valid direction/depth pairs | 12,958 | 8,565 |
| Valid pairs / all inventory points | 49.24% | 50.41% |
| Valid pairs / QA-valid eligible in-play candidates | 86.22% | 95.20% |
| Eligible match inventory-point pair-yield range | 0%–88.95% | 0%–87.33% |
| Eligible matches with no valid pair | 5 | 4 |
| Matches with a valid pair | 99 | 112 |
| Valid Return-winner pairs, retained despite absent +1 | 531 | 429 |
| All valid pairs with known absent +1 | 533 | 432 |

Inventory-point pair yield includes serves with no in-play Return and Return
errors in its denominator. It is not an annotation-completeness rate. Attribute
retention conditional on QA-valid in-play candidates answers a different
question. Neither is official event coverage. Observed prefixes in withheld
points are retained as evidence, never promoted into the numerator.

### Exclusive dispositions and overlapping flags

| Primary point disposition | Men | Women |
| --- | ---: | ---: |
| Completion excluded | 416 | 163 |
| Withheld: authority conflict | 50 | 20 |
| Withheld: unsupported notation | 2,496 | 3,032 |
| Withheld: other point QA | 446 | 140 |
| QA-valid unknown response observation | 0 | 1 |
| Supported structural absence | 3,174 | 1,626 |
| Return error | 4,707 | 3,013 |
| Unsupported attributes | 0 | 0 |
| Explicit unknown attributes | 3 | 4 |
| Omitted attributes | 2,068 | 428 |
| Valid pair | 12,958 | 8,565 |

These rows partition each category's inventory. Independent flags retain
simultaneous problems even when another primary disposition wins: authority
conflicts flag 51/22 points, omitted attributes flag 2,444/573 observed candidates,
and unknown attributes flag 5/8. Excluded and QA-withheld observations can retain
those flags; they do not become usable pairs. No unsupported attribute is
interpreted, and no unsupported suffix or unknown is repaired.

### FIRST/SECOND, direction and depth support

Each tuple below is the count at literal depths **7 / 8 / 9**, with no favorable
ordering. The complete 8,028-row depth grid also records zero cells and undefined
zero-denominator rates at match/server/context/direction level.

| Category | Serve context | Direction | Valid depth counts 7 / 8 / 9 | Eligible observed-candidate denominators 7 / 8 / 9 |
| --- | --- | --- | --- | --- |
| Men | FIRST | 4 | 990 / 1,687 / 743 | 1,170 / 1,934 / 917 |
| Men | FIRST | 5 | 300 / 487 / 192 | 352 / 572 / 258 |
| Men | FIRST | 6 | 938 / 1,397 / 614 | 1,078 / 1,610 / 771 |
| Men | SECOND | 4 | 479 / 1,182 / 489 | 530 / 1,283 / 588 |
| Men | SECOND | 5 | 428 / 1,093 / 450 | 512 / 1,256 / 562 |
| Men | SECOND | 6 | 363 / 814 / 312 | 408 / 898 / 376 |
| Women | FIRST | 4 | 495 / 1,067 / 669 | 622 / 1,342 / 901 |
| Women | FIRST | 5 | 198 / 532 / 335 | 292 / 819 / 551 |
| Women | FIRST | 6 | 474 / 840 / 551 | 597 / 1,088 / 744 |
| Women | SECOND | 4 | 208 / 622 / 392 | 250 / 747 / 504 |
| Women | SECOND | 5 | 210 / 759 / 416 | 293 / 1,027 / 605 |
| Women | SECOND | 6 | 139 / 424 / 234 | 175 / 530 / 326 |

For each depth, retained pairs divided by the corresponding observed eligible
coded-candidate denominator gives retention. The depth grid exports this as
`candidate_retention_eligible`, separately from its within-direction depth
fraction (`rate`). Candidate prefixes in withheld points can enter the diagnostic
denominator, never the valid-pair numerator. Omitted or unknown depth cannot be
assigned to a depth category and stays outside these coded-depth denominators.
Direction-specific observed and QA-candidate denominators in `context-support`
also include missing/unknown depth, so that annotation loss is not concealed by
conditioning on a known depth. All empty retention denominators remain undefined.
These reporting fields do not change any existing pair/disposition or rate.

| Context coverage | Men FIRST | Men SECOND | Women FIRST | Women SECOND |
| --- | ---: | ---: | ---: | ---: |
| Inventory points | 16,107 | 9,764 | 10,305 | 6,544 |
| QA-valid eligible in-play candidates | 8,616 | 6,413 | 5,435 | 3,562 |
| Valid pairs | 7,348 | 5,610 | 5,161 | 3,404 |
| Pairs / inventory context points | 45.62% | 57.46% | 50.08% | 52.02% |
| Pairs / QA-valid eligible candidates | 85.28% | 87.48% | 94.96% | 95.56% |
| Multiple-direction match/server contexts | 194 | 188 | 214 | 213 |

Unknown serve context retains 447/143 inventory points with zero valid pairs.
Unsupported-context summary cells are explicitly empty, with undefined rates.
Do not recode unknown contexts into FIRST or SECOND.

### Within-match and repeated-match support

The 892-row context grid retains both neutral server perspectives and both
serve numbers in every match, including exclusions and empty contexts. Men's
393 and women's 446 contexts contain pairs; 382/427 have multiple directions,
11/19 have only one direction, and 23/18 eligible contexts are empty. There are
80/138 single-pair direction cells. No sparse cell is removed or called adequate.
The depth grid contains 1,113/1,429 zero numerators; it distinguishes observed
zero at positive denominator from undefined empty-direction cells. Eligible
empty-direction cells account for 387/507 depth-grid rows.

The 780-row ordered server/receiver/context inventory has 52/28 context units
with paired observations across multiple matches, representing 26/14 distinct
ordered matchups. Supported repeated units span only 2–3 men's or 2–4 women's
matches. All these repeated units also span distinct source-date batches.
Only 68/40 supported match/context targets have strictly earlier support from
the same ordered pair and serve context. These are exposure counts, not transfer
eligibility or predictions. The builder preserves same-date-only recurrence as
a separate possible disposition; a fixture verifies it supplies no earlier
history. No repeated-player adequacy threshold is introduced.

## Selection limits and ownership

The sample remains outcome-neutral convenience selection of recurring players
and their linked early charts, not representative tennis coverage. Depth is
optional and QA retention depends on the whole point, including later notation.
Returned-ball eligibility conditions on both players' actions; errors, terminal
serves and withheld suffixes select different opportunity sets. Within-match
receiver comparisons do not make missing depth random or remove serve-choice,
receiver intent, court-side, era and annotation differences. Wide/body/T labels
supply no ball speed, exact placement, movement, pressure or shot-quality data.

Serve owns delivery, Return owns response/depth and errors, and +1 is exclusively
Rally-owned. Direction is post-delivery/prior-Return context; depth is the
post-Return response, never a pre-Serve predictor. A Return winner remains in the profile when its depth is supported;
known absence of +1 is not missing observation or a reason to drop it. Depth
labels receive no favorable/unfavorable orientation. Ownership does not prove
statistical independence or transfer Return credit to Serve. Coarse recorded
depth cannot establish advantageous next-stroke opportunity or isolate the
server's contribution. The missing ball/player-state evidence named in the
[construct decision](serve-creation-construct-decision.md) remains necessary
for attributable Serve Creation.

First-serve-fault, direct terminal distribution and terminal balance remain
descriptive/exploratory, with their frozen negative/mixed results unchanged.
This audit tests no NPR association, incremental information or factor validity.
Direct terminal summaries retain arithmetic point-outcome coupling. All acquired
years including 2026 are exposed; source dates are not verified historical
availability. `UNCERTAINTY_NOT_ESTABLISHED` remains.

## Implementation disclosures, verification and release

The first reconciliation attempt stopped because one QA-valid women's
administrative challenge point has no Return stroke but frozen Return observation
`UNKNOWN`. The primary unknown-response disposition was clarified **before the
first successful release**, preserving that source label rather than asserting
absence. The initial prospective fingerprint was
`e36164593a33f2ddec4bf6c9c6fe600d274aa66ab1db718fc34ade8d11ffc316`;
the clarified, implemented fingerprint is
`53582fe2508e84f53126cab608b95e12394f99ae397d592bd617efc7944aa52c`.
No parser, eligibility, QA or valid-pair definition changed. A permutation check
also exposed coverage-export row-order dependence. Canonical category/date/match
ordering corrected this implementation defect; provisional row values were
unchanged. No historical release was affected.

All **9,226 focused linkage checks passed**, including independent parser-ledger
pair/count reconstruction, exact ownership and raw spans, completion and QA
withholding, Return-winner retention, omitted/unknown/unsupported attribute
fixtures, duplicate/identity/authority failures, same-date recurrence, neutral
slot swaps, outcome-label independence, input permutations and byte-identical
independent reruns. Atomic per-file installation, differing-release refusal and
rollback of newly created files on injected failure passed. No historical
numerical suite was rerun.

All **735 documentation, measured-value and release-integrity checks passed**,
plus **12 saved depth-table crosschecks**.
They confirm all **638 historical artifacts and three document tails** remain
byte-for-byte unchanged, current-document agreement, local links, whitespace,
exactly six new ignored outputs and no forbidden fitting/scoring calls. The
final tracked scope is one builder, its tests, this report and the three current
source-of-truth documents. No new directory structure was created.

All six outputs were inspected: 43,310 point rows, 8,028 depth cells, 892 context
units, 780 repeated-pair units, 233 coverage rows and two category summaries.
Source rights/provenance and frozen inputs are verified through the existing
helper chain. The pinned workbook and saved notation evidence establish code
meanings; unsupported grammar remains untouched. No acquisition, dependency,
model, rating, loss, NPR association or portfolio work occurred.

## One next executable step and exact approval

Proceed only to a bounded **descriptive within-context response-profile
comparison** using the frozen linkage release. This advances the central factor
question by testing an observable intermediate Serve–Return relationship before
calling it created advantage. It does not authorize a transfer run or factor
qualification. Report all three depth categories and all direction pairs; do
not choose a favorable depth or retrospectively restrict contexts.

Exact approval:

“Execute one prespecified descriptive Serve–Return response-profile experiment
using MCP_SERVE_RETURN_DEPTH_LINKAGE_1.0.0 without changing sample, QA or
eligibility. Before calculation freeze all three direction-pair contrasts
(4–5, 4–6, 5–6) for each literal depth category within receiver–server–match–
FIRST/SECOND units, using only positive denominators on both sides. Preserve
all inventory and unavailable contrasts; report categories and serve contexts
separately, pool no incompatible denominators, and specify match weighting and
match/both-slot-player deletion arithmetic before execution. Label contrasts
as conditional descriptive response differences, not advantageous depth,
server-attributed value, transferable skill or qualified factors. Acquire
nothing, expand no sample, add no dependency or threshold, fit or score no
model, and calculate no comparative loss or NPR association. Preserve historical
releases and UNCERTAINTY_NOT_ESTABLISHED.”
