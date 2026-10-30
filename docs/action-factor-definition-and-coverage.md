# Action ownership and measured MCP coverage — Stage 1

**Result: `ACTION_OWNERSHIP_PROPOSED_MCP_COVERAGE_AUDITED`.** Release
`MCP_STAGE1_1.0.0`, audited 2026-10-08. This implements the coverage audit and
proposes measurement definitions under the [transition](action-factor-workflow-transition.md).
It does not validate three or four factors, admit a modeling cohort, or estimate
probabilities, values, weights, ratings or model performance.

## Proposed ownership and accounting

Use the point's server as the canonical probability reference:
`q = P(server wins point | supported state)`. Each recorded, nonvoid action has
one before-state, one after-state, one actor and one owner domain. A prospective
transition ledger contains `delta = q_after - q_before`; an actor-facing display
uses `delta` for the server and `-delta` for the receiver. Retain the canonical
sign separately: actor-facing values do not telescope without converting signs
back. No `q` is estimated in Stage 1. Supported state variables and opponent
adjustment must be frozen within a later training design.

| Proposed domain | Exclusive action ownership | Denominators to retain |
| --- | --- | --- |
| Serve | Each legal serve attempt, first fault, second fault and source-coded terminal serve | All service points for point-normalized contribution; recorded attempts for attempt-level execution; first/second attempts separately |
| Return | Receiver's first recorded response, including a recorded failed return | All receiving points for point-normalized contribution; observed return actions/opportunities for conditional execution |
| Rally | Every subsequent stroke by either player: groundstrokes, volleys, overheads and server's first post-return stroke (+1) | All relevant points for point-normalized contribution; observed post-return actions for per-action execution; +1 opportunities separately |
| Movement | **Unresolved**: movement surrounds all three domains, with no separately identifiable ownership here | No invented exposure, coordinate or movement measure |

One point remains one point even with two serve attempts. First-fault after-state
is the second-serve state, not a lost point. Double fault terminates in Serve.
A coded ace or unreturned serve with no distinct return action terminates in
Serve; inability to separate delivery from the opponent's unrecorded response is
a measurement limit. A recorded return error belongs to Return; later stroke
errors belong to Rally. Forced/unforced labels describe source annotations, not
causal responsibility. Do not award a second terminal transition to the opponent
for the same error: prior stroke credit concerns its earlier state transition.
A recorded winner terminates in its stroke's domain; do not invent another
negative non-contact action. Retain ambiguous collapsed events as such.

Serve-and-volley approach annotation does not create an extra stroke. The serve
belongs to Serve; the subsequent server volley, if present, is Rally/+1. Lets,
voided challenges and replay annotations carry no duplicated action credit.
Administrative point penalties require a separate flagged residual, not forced
assignment to a tennis domain. Unobserved point/shot codes, unknown actors and
unresolved challenge/penalty notation remain missing or unresolved. Future
primary analysis must exclude retirements, walkovers and their partial points;
absence of a retirement note does not prove normal completion.

**Serve +1:** server's first stroke after the return; ownership is Rally. A
Serve +1 tactical display may combine the separately owned serve and +1 values,
but must never add that composite again to the domain total. Retain both all
service points and observed +1 opportunities. Aces, double faults, unreturned
serves and terminal returns have no +1 action. Confirmed absence is zero in that
action ledger; unknown/unobserved action is missing. A conditional rate with zero
opportunities is undefined. Eventual point outcome is descriptive context, not
isolated +1 skill. No interaction or synergy model is proposed now.

For any future match aggregation, retain action counts, point denominators and
missingness separately by player/domain. Do not drop missing actions and describe
the resulting sum as complete. NPR remains `100*(won-lost)/total_points` on the
same eligible completed points. Exact transition sums can reconstruct the point
outcome algebraically; that is accounting, not independent factor validation.
Structural nonoverlap, empirical collinearity, incremental information and future
usefulness still require separate tests. Three domains may be sufficient;
movement requires coordinates, timing and a defensible stroke/movement separation.

## Source authority and release

Direct origin is [Jeff Sackmann's MCP](https://github.com/JeffSackmann/tennis_MatchChartingProject),
revision **`1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`**. Its pinned README identifies
The Tennis Abstract Match Charting Project and licenses the data under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).
The intended use is local noncommercial research, with origin/contributor
attribution retained. This task authorizes no public redistribution or commercial
use. Any derivative publication needs the project's separate approval and
applicable attribution, change identification and share-alike review.

The revision-bound README, dictionary and Git tree were inspected before match
and point acquisition. The exact required file paths, sizes and Git blob IDs were
pinned first; staged downloads were verified before installation. The
[manifest](../data/manifests/mcp-source-files.csv) records retrieval UTC, direct
and metadata URLs, revision, creator, license, intended use, bytes, Git blobs and
SHA-256 for **11 files / 193,314,931 bytes**: README, dictionary, notation workbook,
two match files, and men's/women's point shards for pre-2010, 2010s and 2020s.
No aggregate statistics files or mirror were substituted.

Raw files use `data/raw/reference/mcp-stage1-` prefixes; the saved revision tree
is `mcp-stage1-source-tree.json` in that same existing ignored directory. The
workbook's filename spaces become underscores locally; its bytes stay unchanged.
The offline [audit](../R/audit_mcp_coverage.R) verifies all pins before processing.
The manifest SHA-256 is
`189efcee4ea4a315ae177149e48e3b71a7d6f40301e6f64c264c6b575c967a18`;
tree SHA-256 is
`8c6164fcf5ead9d25c62b177706987d7851185ec321dcf66e5aebbe16ebd1454`.

## Measured inventory

ATP/WTA below designate men's/women's **source files**, not independently
certified tour membership. These files include qualifiers, lower-level,
team/exhibition and malformed contexts. There is no uniform tour-level or
verified completion field. All records remain inventoried; nothing is repaired.

| Measured item | ATP file | WTA file |
| --- | ---: | ---: |
| Metadata rows / distinct match IDs | 7,566 / 7,565 | 4,264 / 4,257 |
| Exact player-name strings, not resolved people | 1,003 | 739 |
| Valid source-date range | 1960-05-29–2026-05-21 | 1979-09-28–2026-09-09 |
| Observed valid years / raw event labels | 59 / 430 | 48 / 284 |
| Hard / Clay / Grass metadata rows | 4,850 / 1,877 / 837 | 2,848 / 912 / 495 |
| Invalid surface / invalid date rows | 2 / 1 | 9 / 18 |
| Major main-draw label-supported rows | 2,064 | 1,359 |
| Other main-draw round labels, tour level unverified | 4,599 | 2,420 |
| Lower-level/junior labels | 423 | 188 |
| Team/exhibition/other review labels | 420 | 182 |
| Non-main-draw/unknown round labels | 60 | 115 |
| Point rows / distinct linked point-match IDs | 1,284,276 / 7,532 | 593,481 / 4,253 |
| Metadata rows with no point file | 33 | 4 |
| Rows involved in duplicate metadata IDs | 2 | 14 |
| Point rows involved in duplicate `(match_id, Pt)` keys | 4,222 | 1,028 |
| Repeated entire point rows, after first occurrence | 1,625 | 504 |
| Matches with duplicate point keys / noncontiguous numbering | 11 / 11 | 3 / 3 |
| Matches with status-note cues, not adjudicated statuses | 32 | 8 |
| Structurally screened ordinary terminal-score patterns | 6,178 | 3,838 |

No orphan point rows or match IDs spanning point shards were found. All observed
`Svr`/`PtWinner` values are 1 or 2. One WTA chart does not start at zero; no ATP
chart has that condition. Date/ID prefix disagreements number 1 ATP and 18 WTA.
These flags overlap and must not be added as disjoint exclusions.

Major support requires an exact normalized Australian Open, Roland Garros,
Wimbledon or US Open label and a main-draw round label; normalization only trims
spaces and replaces underscores. Major main-draw counts by event are ATP
602/428/491/543 and WTA 426/262/309/362 in that order. Misspellings are not
silently mapped. Broader tour membership remains unresolved; heuristic review
labels are not final admission decisions. All **3,686 coverage rows** include
complete observed year, event, surface and tour/year/event/surface partitions,
plus totals. No event universe or official denominator was acquired: missing
source matches, official event recall and full-tour coverage remain unknown.

| Source year | ATP metadata / major main-draw | WTA metadata / major main-draw |
| --- | ---: | ---: |
| 2021 | 374 / 96 | 313 / 81 |
| 2022 | 648 / 126 | 363 / 92 |
| 2023 | 621 / 171 | 339 / 128 |
| 2024 | 769 / 167 | 456 / 148 |
| 2025 | 579 / 155 | 565 / 112 |
| 2026 | 184 / 32 | 355 / 119 |

Completion screening checks unique metadata linkage, valid metadata, one point
shard, contiguous numbering from one, initial zero score, valid owners, no
status-note cue and an ordinary final game/set score pattern. Tiebreak and
nonstandard endings remain unresolved. It does **not** validate every score
transition or establish official normal completion. The 10,016 positive patterns
are explicitly `SOURCE_TERMINAL_PATTERN_ONLY_NOT_OFFICIAL_COMPLETION`; all other
1,814 metadata rows remain unresolved. There is no analytical admission release.

## Temporal and Serve +1 availability

All six point exports have **14 columns**, giving 84 field-availability rows.
The dictionary describes convenience fields such as `isAce`, `isDouble`, `Ret`,
`TB?` and `rallyCount` that are absent from these actual exports. Reconstructing
those requires a tested parser; dictionary presence is not measured availability.

There are 4,094 ATP and 1,769 WTA nonblank `Time` labels. Date, time, round and
source point numbering are not verified start/completion timestamps or historical
data availability. No point/action timestamps, tracking coordinates, or measured
movement exposures exist in these files. Source player 1 means first server,
not winner; derived sample slots use exact-name lexical order. Aliases are not
resolved into global player IDs.

The following counts are **lexical availability candidates across raw point
rows**, including duplicates and unresolved matches. They are neither validated
action counts nor rates on an admitted cohort. The scan uses the second sequence
when recorded, otherwise the first, and recognizes supported prefixes from the
pinned workbook notation.

| Recorded pattern | ATP | WTA |
| --- | ---: | ---: |
| Nonblank selected sequence | 1,284,276 | 593,481 |
| Outcome-only/point-penalty code | 14,026 | 2,668 |
| Unknown shot/direction code (`q`/`0`) | 2,567 | 957 |
| Serve direction 4/5/6 | 1,269,344 | 590,160 |
| Return shot prefix / return direction | 1,089,905 / 1,049,916 | 533,210 / 519,750 |
| Return depth | 774,359 | 422,253 |
| +1 shot prefix / direction | 836,612 / 821,647 | 413,611 / 407,485 |
| +1 terminal winner / error pattern | 68,404 / 116,152 | 23,550 / 63,144 |

Prefixes support a prospective shot-type/direction and terminal-code display.
They do not prove that every string is valid or that an unmatched string has no
+1 opportunity. Eventual point-owner labels exist on every row, but Stage 1
calculates no point-win rates or performance relationship. Direction and return
depth are categorical annotations, not tracking coordinates or movement values.

## Proposed sample and evaluation options

A **44-match parser-validation sample: 20 ATP, 24 WTA**, is proposed from 1,707
ATP and 1,225 WTA major-label rows passing the structural terminal screen. Within
each source-tour × surface × era group, take at most two matches ranked by SHA-256
of date, event, round and neutral player names. Eras are pre-2010, 2010–2019,
2020–2025 and exposed 2026. Both tours contribute two per hard/clay/grass group
in the first three eras. In 2026, ATP supplies only two hard-court candidates;
WTA supplies two per surface. Empty ATP clay/grass strata stay empty.

Quality eligibility is conditional on completion-pattern evidence, symmetrically
with respect to winner. Ranking uses no outcome, ranking, player strength or
model fit. This balances notation exercises, not population inference. The
crowdsourced convenience sample and exact-name identities remain limitations.
Parser validation must adjudicate unknown strings and reconcile complete score
transitions before any analytical admission. No sample is selected for fitting.

**Options requiring user choice before estimation:** (A) retrospective whole-year
walk-forward within the exposed inventory, keeping same-source-date matches and
all points of a match together; or (B) freeze a retrospective early/late comparison,
for example 2010–2019 development versus 2020–2025 transfer, with supported
surface/tour coverage disclosed. These are options, not adopted periods. Neither
is an untouched final test, and source-date order does not establish actual
availability. The entire acquired snapshot is exposed; **the acquired 2026 records are now
exposed too**. A new prospective or independently unexposed final sample requires
user input and a frozen exposure/access plan. Select no final year by assumption.

## Official access route and unsent request

Reviewed TDI's [platform page](https://www.tennisdata.com/tennis-data-platform)
and its [official contact section](https://www.tennisdata.com/home/).
The platform describes a historical archive, sandbox and ball-tracking inputs;
these statements do not confirm free external research access, WTA coverage,
exportable coordinates or derivative rights. No application was submitted, no
agreement accepted and no outreach sent.

Unsent request (identity gaps deliberately unfilled):

> I am TODO_USER_NAME, affiliated with TODO_AFFILIATION, contact
> TODO_CONTACT_EMAIL. I am researching interpretable tennis action measurement
> for noncommercial research. Is zero-fee research/sandbox access available to
> historical ATP/WTA singles ball/player coordinates, timestamps and linked
> point events? Please specify coverage, coordinate definitions, permitted local
> retention, derived-analysis publication and attribution conditions. I do not
> request biometric, health or private wearable information. Please confirm any
> restrictions before providing access; I cannot accept fees or agreements here.

Movement remains unresolved while that evidence is unavailable. Sending requires
user identity/contact details and an explicit instruction; it is not a dependency
for continuing the MCP parser.

## Outputs, validation and next step

Five ignored CSVs use the existing `data/pilot/mcp-stage1-` prefix:
`match-inventory`, `coverage`, `field-availability`, `prototype-sample` and
`audit-summary`. They retain source IDs/values, flags and release labels.
Installation stages bytes, refuses differing existing outputs, and renames each
file atomically with the summary last; this is not a multi-file transaction.

The [focused tests](../R/test_mcp_coverage.R) cover source/tree pins, rights and
schema failures, linkage, duplicate/accounting checks, conservative completion,
notation examples, exact partitions, outcome-neutral sampling, ignored scope,
independent byte-identical reruns and preservation. An initial lexical regular
expression failed locally before output installation; correcting its character
class restored the intended scan. No raw repair or source rule changed.
Validation totals and preservation are recorded in the current status snapshot.
Historical suites were not rerun. No new dependency or directory was added.

**One next executable step:** Stage 2, a bounded base-R action parser on the
pinned notation and proposed 44-match sample, with unique Serve/Return/Rally
ownership, explicit unknown/administrative cases, full point/score reconciliation
and Serve +1 opportunity accounting. Report failures; do not silently repair or
turn this sample into an admitted modeling cohort. No estimation, ratings,
weights or scoring yet.

Exact approval: “Implement Stage 2's action parser on the pinned MCP inputs and
44-match proposed parser sample, preserving raw notation, explicit unknowns and
unique Serve/Return/Rally ownership; reconcile point totals and Serve +1 cases
without fitting, weighting, rating or scoring.” Separately, before Stage 3 the
user must choose a retrospective evaluation option and identify how an untouched
final sample will be protected.
