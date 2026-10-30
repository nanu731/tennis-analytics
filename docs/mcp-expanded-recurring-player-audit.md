# Expanded recurring-player MCP support audit

## Fixed scope and selection

Baseline: `c3217b1d4294e216cec8883fd3d041fcd69207f4`. Keep the exact forty
selected identities. Extend five to ten context/link-eligible charts per player,
or all available when fewer; include every tenth-date tie, deduplicate original
match IDs and retain both players. Opponent appearances can exceed the selection
cap. Ten is not a history window or adequacy threshold.

Reuse [frozen source/context selection](mcp-repeated-player-sample-audit.md#selection-rules-fixed-before-sequences-were-loaded)
and the [completion gate](mcp-broader-return-transfer-protocol.md#inventory-and-completion-gate).
Selection uses only identities, context, dates and linkage before completion or
parsing. Failed charts remain inventoried without replacement or later fill-in.
Unavailable completion evidence fails closed; internal chart consistency does not
certify official completion. Parser 1.1.0 and observable-state rules are unchanged.

Support dictionary: Serve = nonvoid physical SERVE/SERVE_FAULT attempts by recorded
number, excluding lets/administrative forfeits; Return = owned STROKE attempts by
pre-action FIRST/SECOND context; Rally = existing owned STROKE attempts. +1 reuses
the observed-prefix, validated-attempt, absence and unknown ledger with score QA.
It overlaps Rally and earns no additional domain credit. No execution frequency,
transfer estimate, factor or skill is calculated.

Histories pool eligible same-category/player/domain/context attempts from strictly
earlier source-date batches; equal dates are simultaneous. Zero target exposure,
empty histories, unknown contexts and withholding stay explicit. Inherited seed
labels describe the earliest eligible inventory, not an approved evaluation period.
Compare original targets and added targets separately. All acquired years,
including 2026, are exposed.

## Measured selection and source authority

The source revision remains `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`.
The existing verification chain checks saved CC BY-NC-SA 4.0 research-use evidence,
manifest, source sizes, SHA-256 and Git blobs, parser/notation evidence and frozen
state rules before processing. [Source manifest](../data/manifests/mcp-source-files.csv).
No acquisition or new rights assumption occurred.

All 11,830 candidate records retain context/linkage dispositions; 3,377 pass the
unchanged context gate. The same forty selected identities retain their exact
UTF-8 hash input `MCP_REPEATED_PLAYER_V1|category|exact source name`, SHA ordering
and identity spelling. Major event, main-draw round, source-ID, format, date,
surface and point linkage evidence is required; file gender alone is insufficient.
ATP/WTA file labels below denote historical men's/women's categories, including
early charts, and do not independently certify governing-tour membership.

| Inventory | Men | Women |
| --- | ---: | ---: |
| Five-match charts | 75 | 84 |
| Expanded charts | 106 | 117 |
| Additional charts | 31 | 33 |
| Expanded points | 26,318 | 16,992 |
| Source-date batches | 104 | 111 |
| Distinct identities, selected plus opponents | 89 | 97 |
| Newly inventoried identities (all opponents) | 11 | 18 |
| Selected players with ten charts | 5 | 6 |
| Selected players with fewer than ten available | 15 | 14 |
| Player-selection links before match deduplication | 106 | 120 |

The expanded dates span 1960-07-04–2026-01-23 for men and
1993-07-02–2026-07-02 for women. No observed tenth-date boundary adds more than
ten charts for a selected player; an explicit tied-date fixture tests inclusion.
The union has 223 charts / 446 neutral player slots / 43,310 points, adding
64 charts and 12,092 points (40.25% and 38.73%). Only eleven selected players
reach ten; source supply limits the other twenty-nine. Opponent appearances can
create more inventory appearances than a player's own selection cap.

## Implementation correction disclosed

An initial trial stopped before output installation because the context-only
loader preserves boolean completion evidence as text while the frozen completion
helper expects logical fields. The adapter now types only the derived evidence
frame exactly as the historical CSV loader does; raw fields stay unchanged.
Original completion dispositions were checked independently before the corrected
full build. An obsolete concurrent trial with the old adapter was stopped without
installing output. No admission rule, parser interpretation or scientific method
changed.

## Completion, notation and action coverage

All 223 charts remain in the inventory. The completion gate admits 104 men /
116 women and excludes only the same three original charts. All 64 additions
pass; no chart is replaced. Exclusions remain:

- Chung–Federer, 2018 Australian Open: incomplete chart.
- Michelsen–Harris, 2024 Wimbledon: terminal-outcome conflict.
- Gasparyan–Svitolina, 2019 Wimbledon: incomplete chart.

No independent official completion certification is added. All 43,310 points
and 222,141 unique action/state rows remain observable audit records.

| Category | Parsed | Parsed with explicit unknowns | Administrative | Missing actions | Unsupported/unresolved | Terminal conflicts |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 23260 | 61 | 2 | 445 | 2549 | 1 |
| WTA | 13651 | 27 | 0 | 140 | 3174 | 0 |

Failure reasons overlap and cannot be summed as distinct points. Every parser
reason and explicit unknown is exported in reason-summary, with raw notation and
locations in the action/point ledgers. No supported prefix grants full-point
validation. The additional charts introduce no terminal-outcome conflict; their
notation/observation failures remain withheld under the same rules.

## Compatible attempt support and retention

These are completion-eligible observed/QA-usable physical counts. They are not
execution success rates. Unknown unobserved action multiplicity remains
NOT_IDENTIFIABLE; retention is conditional on observed attempts, not all actual
actions. +1 observed prefixes overlap Rally and are never additional domain credit.

| Category / domain / context | Observed | Usable | Withheld | Retention | Prior attempts min / median / max |
| --- | ---: | ---: | ---: | ---: | --- |
| ATP / Rally / ALL | 73872 | 62564 | 11308 | 84.69% | 4 / 780 / 4690 |
| ATP / Return / FIRST | 13633 | 12028 | 1605 | 88.23% | 15 / 146.5 / 584 |
| ATP / Return / SECOND | 8619 | 7708 | 911 | 89.43% | 7 / 88 / 453 |
| ATP / Serve / FIRST | 25447 | 22910 | 2537 | 90.03% | 39 / 276 / 1195 |
| ATP / Serve / SECOND | 9621 | 8683 | 938 | 90.25% | 7 / 97.5 / 525 |
| ATP / Serve +1 / ALL | 16890 | 14479 | 2411 | 85.73% | 4 / 183.5 / 826 |
| WTA / Rally / ALL | 46928 | 33259 | 13669 | 70.87% | 1 / 387 / 2591 |
| WTA / Return / FIRST | 9415 | 7497 | 1918 | 79.63% | 10 / 84 / 537 |
| WTA / Return / SECOND | 5612 | 4513 | 1099 | 80.42% | 4 / 52 / 356 |
| WTA / Serve / FIRST | 16663 | 13637 | 3026 | 81.84% | 26 / 154 / 985 |
| WTA / Serve / SECOND | 6497 | 5366 | 1131 | 82.59% | 6 / 64 / 402 |
| WTA / Serve +1 / ALL | 11513 | 8544 | 2969 | 74.21% | 1 / 103 / 643 |

Each known context/domain has 120 men / 135 women supported player-match targets,
across 89/103 charts and 38/36 exact source identities. Of these identities,
19/20 are frozen selected players; Hyeon Chung still has only one eligible chart
and no eligible earlier history. No known-context zero-target-attempt case occurs.
There are 86/95 cold-start slots per known view, four seed slots and six
completion-excluded slots. These dispositions account for all 446 slots per view.
FIRST/SECOND Return support totals 510 cells, representing 255 slots rather than
510 independent measurements or factors. UNKNOWN and UNSUPPORTED cells remain
in all inventories with explicit reasons; none gains a usable attempt.

The history ledger includes every target, prior chart/batch/usable-attempt depth,
original versus added prior contributions and nominal source-date gaps. Match
counts and retention are in opportunity-counts; exact selected/opponent player
profiles are in player-support. Source names are not newly reconciled external
athlete identities. Category-level missing/suffix/authority totals repeat across
views and must not be added across those views.

## Incremental observations versus repeated-player support

| Category | Supported slots, old → expanded | Supported identities, old → expanded | Cold starts, old → expanded | Old targets newly supported | Old targets with deeper history | Added supported slots |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 69 → 120 | 30 → 38 | 75 → 86 | 0 | 7 | 51 |
| WTA | 87 → 135 | 31 → 36 | 77 → 95 | 3 | 16 | 45 |

The same slot-support counts apply to recorded FIRST/SECOND Return, SECOND Serve,
Rally and +1; their attempt pools differ, and these views are not independent.
All original observed/usable counts and completion dispositions are identical.
Seven original men’s targets gain up to two prior usable charts; sixteen women’s
gain up to five. Three original women’s cold starts become supported; all other
new supported targets are added charts. The set of supported selected identities
remains 19/20. Support gains belong to previously inventoried opponents.

| Category | Prior usable charts min / median / max | One prior chart | Two–four | Five or more | Source-date gap min / median / max days |
| --- | --- | ---: | ---: | ---: | --- |
| ATP | 1 / 2.5 / 9 | 38 | 51 | 31 | 1 / 222.5 / 3286 |
| WTA | 1 / 3 / 13 | 36 | 56 | 43 | 1 / 238 / 6996 |

These integer depth bins describe supply; they are not adequacy gates. Old
maximum depths were four/seven. Larger union depths can exceed ten because a
selected player also appears as another selected player’s opponent. Gaps remain
source-label differences, not verified elapsed availability or inactivity.

## Serve +1 reconciliation

| Category | Observed prefixes | Usable attempts | Withheld prefixes | Known absences | Unknown opportunities |
| --- | ---: | ---: | ---: | ---: | ---: |
| ATP | 16890 | 14479 | 2411 | 8433 | 579 |
| WTA | 11513 | 8544 | 2969 | 5093 | 223 |

Those rows cover completion-eligible points. The all-inventory ledger retains
every point, validated attempts including attempted errors, known absences and
unknown/unvalidated observations. Incorrect challenges create no stroke; lets
create no physical-attempt credit. No rallyCount-based attempt substitution occurs.
Attempted errors remain existing provenance, not a new metric or fitted quantity.

## Additional failures and observed selection limits

No additional whole-chart completion failure occurs. Additional point-level
failures remain explicit; counts below refer only to the 64 added charts.

| Category | Added points | Unsupported/unresolved | Missing actions | Parsed explicit unknowns | Terminal conflicts |
| --- | ---: | ---: | ---: | ---: | ---: |
| ATP | 7312 | 490 | 74 | 9 | 0 |
| WTA | 4780 | 586 | 33 | 6 | 0 |

All additional failure reasons (a point may have several):

| Failure reason | Added men’s points | Added women’s points |
| --- | ---: | ---: |
| DROP_VOLLEY_MODIFIER_ON_OTHER_SHOT | 5 | 1 |
| ERROR_CODE_WITH_WINNER | 2 | 1 |
| ERROR_WITHOUT_TERMINAL_MARKER | 37 | 4 |
| INVALID_RALLY_DIGITS | 415 | 566 |
| INVALID_RETURN_DIGITS | 3 | 2 |
| MISSING_POINT_TERMINAL | 37 | 4 |
| SECOND_SERVE_WITHOUT_FIRST_FAULT_OR_FORFEIT | 1 | 12 |
| SERVE_NET_CORD_AUTHORITY_CONFLICT | 18 | 0 |
| TRAILING_SERVE_TERMINAL_OR_FAULT | 4 | 0 |
| UNFORCED_ERROR_WITHOUT_ERROR_TYPE | 17 | 4 |
| UNSUPPORTED_SERVE_START | 1 | 11 |
| UNSUPPORTED_SHOT_CODE | 36 | 4 |

All thirteen newly supported identities were **already-inventoried opponents**;
none of the twenty-nine newly inventoried opponents gains repeated support.
Inventory recurrence is 39/89 men and 36/97 women exact source identities;
completion-eligible recurrence is 38/88 and 36/97. These are repeated-date
identities; their number does not establish independence or statistical adequacy.

All-inventory transition retention is 86.59% men / 74.38% women; match ranges
remain 10.91%–100% / 6.46%–100%. First-serve
match retention remains 23.91%–100% / 18.80%–100%. Return UNKNOWN has zero observed
attempts; UNSUPPORTED has 12/26 completion-eligible observed attempts, all withheld.
Missing-action rows number 445/140; unsupported suffix rows 166/300. Authority
conflict flags affect 286/155 action rows, across 50/22 points; flags and parser
reasons retain provenance and receive no repair. Action, point and match counts
are different units. +1 all-inventory validated attempts are 14,737/8,556,
including 2,453/1,761 attempted errors under the frozen notation rules. These
existing terminal labels establish observable attempts, not causal shot quality.


## Release and verification

The six tracked files are the builder, focused tests, this report,
PROJECT_CONTEXT.md, docs/status.md and docs/data-source-contract.md. Nineteen
ignored CSVs are installed under the existing flat `data/pilot/` prefix
`mcp-expanded-recurring-v1-`, using staged writes, complete preflight comparison
and atomic per-file installation. A differing existing release is rejected before
any file changes; this is not a crash-atomic multi-file transaction.

Output suffixes: selection-dispositions, player-selection, sample, actions,
point-reconciliation, match-reconciliation, reason-summary, decoded-examples,
parser-summary, action-states, serve-plus1, state-coverage, field-provenance,
match-eligibility, opportunity-counts, history-support, player-support,
coverage-summary and incremental-support. All are CSVs. The ledgers include
4,460 opportunity and history rows, 1,860 player profiles and twenty
coverage/incremental view rows; no unobserved opportunity is manufactured.
The preserved field-provenance table uses frozen component output names:
its coverage-summary denotes state-coverage in this release, not the new
opportunity-support coverage-summary. Source strings are preserved.

19,106 focused checks passed: frozen input pins and identities, exact earliest-ten
selection/ties/all-available behavior, context-only selection, deduplication,
raw point/action/span preservation, original parser/state/completion equality,
independent ownership/attempt/+1 reconstruction, every strictly earlier eligible
history and source gap, cold starts/zero denominators/unknowns, permutations,
same/later-cutoff perturbations, earlier positive controls, installed bytes,
ignore coverage, overwrite refusal and 568 historical fingerprints.
Twenty additional independent-rerun checks passed: two full source-driven builds
produce byte-identical nineteen-file releases, matching every installed output.
No historical test suite was rerun. Current-document agreement, local links,
anchors, whitespace, exact scope and the three historical document tails are
All eighty documentation/accounting/link/pin/whitespace/exact-scope checks
passed, including the three historical document tails. Every generated summary
was inspected.

## Decision and one next executable step

**EXPANSION_IMPROVES_REPEATED_SUPPORT_REMAINS_EXPLORATORY.** The expansion materially
increases usable observations and prior depth and adds thirteen supported source
identities. It does not enlarge the selected-player set. Cold starts also rise
as one-off opponents enter, thirty-eight men’s and thirty-six women’s supported
targets still have only one prior chart, and twenty-nine selected players cannot
reach ten available charts. QA retention, long gaps, selective charting, source
category/identity limits and unverified official completion/availability remain.
All acquired years, including 2026, are exposed; UNCERTAINTY_NOT_ESTABLISHED remains.
No evaluation period is selected and no transfer, skill, factor-validity, population
or statistical-adequacy claim follows. Prior experiment conclusions are unchanged.

Recommend one unchanged unsmoothed first-serve-fault transfer experiment on this
frozen expanded release to test whether deeper history reduces the previously
observed player-deletion sensitivity. The supported transfer claim remains
conditional on chart-observed, QA-usable physical attempts. This is a concrete
exploratory experiment, not a factor-validation step or another support audit.

Exact separate approval required:

> Approve one expanded-sample first-serve-fault transfer experiment using MCP_EXPANDED_RECURRING_1.0.0, its unchanged completion exclusions, and ALL_DATE_EXPANDING. Reuse the frozen physical-attempt/fault definitions, unsmoothed pooled strictly earlier same-category counts, simultaneous batches, positive-denominator abstention, identical personal/reference masks, losses and match/both-slot-player deletions. Change no method or eligibility; add no smoothing, acquisition, factor, rating or match-winning claim.
