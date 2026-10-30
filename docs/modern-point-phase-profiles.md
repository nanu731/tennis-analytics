# Modern Where Players Win Points profiles

## Frozen scope before parsing

Frozen 2026-10-10 from clean baseline
`7dc6bc90cf95d74ccaa603e988e986b0ab8ad245`:
**calendar 2021–2025, all context-eligible charts**, not a recurring-player cap.
No backward widening. 2026 is outside selection. Use only already-saved MCP
revision `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`, its pinned rights/provenance
and unchanged major/main-draw identity/linkage rules. Retain all metadata
selection dispositions, then all selected charts regardless of completion or QA.
Exact source names identify profiles; no alias merging or guessed identities.
Historical men's/women's categories are not certified governing-tour populations.

This is descriptive accounting, not ranking, causal credit, forecasting, skill
or factor qualification. Reuse [MCP_POINT_PHASE_PROFILES_1.0.0 definitions](where-players-win-points-plan.md#adopted-contract-before-calculation):
exclusive Serve/Return/server +1/Later Rally/Administrative/Unresolved endings;
overlapping shared Return/+1/later reach; all completion-eligible whole-point-QA
points as ending/reach denominators; reached points as serving/receiving
conditional-win denominators. +1 remains error-inclusive and Rally-owned.
First faults/lets do not automatically end points. Unknowns are not absent or
losses; empty denominators remain undefined. Pool counts before division.

### Metadata inventory and council

| Period | Category | Context-eligible charts | Point rows | Identities | Recurring across dates | Multi-event | Multi-year |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 2021–2025 | Men's | 701 | 164,269 | 228 | 150 | 131 | 136 |
| 2021–2025 | Women's | 560 | 78,858 | 222 | 155 | 138 | 126 |
| 2016–2025 | Men's | 981 | 228,943 | 272 | 182 | 162 | 166 |
| 2016–2025 | Women's | 818 | 115,522 | 274 | 198 | 181 | 178 |

These counts use identities, dates, events and linkage only. Median chart count
per identity is three in both periods/categories; 2021–2025 maxima are 89/70.
The initial window includes 78 men's and 67 women's single-date identities.
They remain included. Recurrence is exposure, not a precision threshold.

Council question: “Does 2021–2025 support the proposed descriptive player-pattern
analysis, or does a specific recurring-player limitation justify widening
backward within 2016–2025?” Five independent read-only advisors (maximum 150
words each), five fresh anonymous reviewers who did not advise (maximum 120
words each), then chair synthesis were completed before parsing. Reviews saw
all five full responses under randomized labels, without their role mapping.

All advisors support the preferred window. Widening adds 32/43 recurring
identities but establishes no necessary repair of a specific descriptive gap.
Reviewers prefer the clear freeze plus all-chart selection. Their key objection:
one advisor's suggestion to revisit the period after QA conflicts with authority.
The chair rejects that suggestion: completion, parser retention and point results
cannot alter this release's period. Sparse/failed profiles stay inventoried.
Agreement is advice, not verification of usable points or profile stability.

Display one recurring identity per category, chosen by exact neutral name order
from metadata before outcomes: **Adrian Mannarino** and **Ajla Tomljanovic**.
Recurring means at least two distinct source-date batches, only a display rule.
Neither player is replaced for completion failure, low retention or unavailable
rates. Both plots use their pooled profiles over this period only.

### Enumerated output scope and processing

Exactly these 13 ignored files use the existing flat
`data/pilot/mcp-modern-point-phase-v1-` prefix:

1. `selection-dispositions.csv` — context and period decisions for every saved inventory row.
2. `period-inventory.csv` — the four metadata-only candidate-window/category summaries.
3. `player-exposure.csv` — metadata exposure in both candidate periods, no phase results.
4. `actions.csv` — unchanged parsed notation, ownership, tokens and raw provenance.
5. `action-states.csv` — unchanged observable boundaries and explicit unknowns.
6. `serve-plus1.csv` — unchanged attempt/error/absence/unknown ledger.
7. `match-completion.csv` — selected-chart metadata and all completion dispositions.
8. `point-dispositions.csv` — selected points, QA, terminal phase, winners and reaches.
9. `match-player-profiles.csv` — match and pooled player counts, rates and exposure.
10. `coverage.csv` — full match/category/year/event-year/surface accounting.
11. `parser-failures.csv` — grouped parser, annotation and score-reconciliation reasons.
12. `point-ending-prototype.svg`.
13. `opportunity-prototype.svg`.

No duplicate cohort or raw-point copy is exported. The selection ledger defines
the cohort; completion combines its metadata with chart reconciliation. The
original prototype and every historical release stay untouched.
Reuse the parser/state/completion/profile functions. Process each selected chart
individually and stream action/state/+1 outputs to staged flat files, retaining
only point dispositions for pooling. This bounds working memory without reducing
the cohort. The original profile checker hardcodes 223 charts; an isolated
adapter changes inventory-size and component-release assertions only, preserving
all identity, ownership, notation, completion and QA rules.

Stage the entire output set, verify pins and scope before installation, and
refuse differing pre-existing releases. Tests cover metadata independence,
identities, completion, terminal/winner/+1 accounting, denominators, unknowns,
pooled counts, neutral swaps, permutations and deterministic independent reruns.
No model, score, weighting framework, acquisition or dependency is authorized.

## Measured release

### Implementation disclosures

The first full processing attempt stopped before installing a release at
`20240705-M-Wimbledon-R32-Grigor_Dimitrov-Gael_Monfils|116`.
Both source serve fields contain `6f38b38*`. The unchanged parser marks the point
`UNSUPPORTED_OR_UNRESOLVED`, with `INVALID_RALLY_DIGITS` and
`SECOND_SERVE_WITHOUT_FIRST_FAULT_OR_FORFEIT`; neither sequence earns whole-point QA.
The historical state helper nevertheless aborts on two candidate +1 action IDs.
An isolated export adapter now retains both IDs and the original parser observation,
assigns no canonical +1 action, and records `UNKNOWN_OPPORTUNITY` plus
`DUPLICATE_UNVALIDATED_PLUS1_CANDIDATES`. The point remains withheld; no sequence
is chosen, deleted, repaired or interpreted. A duplicate in a validated point
still stops processing. Historical parser/state code and releases are untouched.
This handles already-failed observations, not a relaxed analytical gate.
A subsequent attempt exposed a column mismatch when adding this conflict to the
metadata-bearing failure summary. Selecting the five existing aggregate fields
before that join fixes export only; its complete affected-chart worker check passes.
Both stopped attempts installed no release.

Single-chart calls also exposed an empty failure-table export error; vectorized
metadata permits a zero-row table without inventing a failure. Prototype-only
inventory/release assertions are rebound to this cohort. The scientific formulas,
notation, ownership, completion and whole-point-QA rules remain unchanged.
After measuring serial processing at about 3.7 seconds/chart, bounded bundled-R
workers write results through the parent in frozen chart order. No dependency or
new directory is introduced; a full independent input-permuted rerun must match
all thirteen files byte-for-byte.

### Coverage and dispositions

**MODERN_DESCRIPTIVE_POINT_PHASE_PROFILES_BUILT — MCP_MODERN_POINT_PHASE_PROFILES_1.0.0.**
The selected 1,261 charts contain 243,127 unique points. All 11,830 saved inventory
rows retain selection dispositions: 1,261 selected, 3,766 context-excluded,
6,784 outside the period and 19 date-period-unknown. Context reasons overlap;
all linkage/identity failures remain excluded under the existing rules.

| Historical category | Charts | Completion eligible | Inventory points | Included | Completion excluded | QA withheld | Retention |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Men's | 701 | 674 | 164,269 | 122,102 | 5,359 | 36,808 | 74.33% |
| Women's | 560 | 553 | 78,858 | 52,358 | 901 | 25,599 | 66.40% |

All 40 expected major-event/year/category cells contain selected charts. These
are observed-source cells, not complete tournament coverage or official recall.
All 34 completion-excluded charts remain visible with zero included points.
Completion reasons overlap: 24 incomplete charts, 11 terminal-outcome conflicts,
five score-replay conflicts/unavailable formats and eight status-note cues.
No status cue is newly interpreted as a specific retirement or injury cause.
Existing eligible-chart retention ranges from 21.45% to 100% in men and
14.80% to 100% in women; the full inventory range includes zero.

| Year | Men's charts / included points / retention | Women's charts / included points / retention |
| --- | ---: | ---: |
| 2021 | 92 / 14,956 / 66.65% | 81 / 7,219 / 60.27% |
| 2022 | 124 / 19,455 / 63.64% | 92 / 6,784 / 49.30% |
| 2023 | 164 / 28,614 / 75.82% | 128 / 12,208 / 68.23% |
| 2024 | 166 / 29,832 / 76.76% | 148 / 13,874 / 68.86% |
| 2025 | 155 / 29,245 / 84.39% | 111 / 12,273 / 81.40% |

Surface counts (charts / included points / retention): men's Hard
387 / 68,699 / 75.91%, Clay 172 / 28,230 / 70.50%, Grass 142 / 25,173 / 74.63%;
women's Hard 336 / 35,024 / 75.27%, Clay 104 / 7,942 / 51.94%, Grass
120 / 9,392 / 55.13%. Carpet is explicitly empty, with undefined retention.
These compositional and annotation differences prohibit treating pooled category
percentages as standardized performance comparisons.

### Measured phase accounting and player displays

| Exclusive ending | Men's included points | Women's included points |
| --- | ---: | ---: |
| Serve | 21,697 | 7,339 |
| Return | 30,219 | 15,631 |
| Server Serve +1 | 20,661 | 9,989 |
| Later Rally | 49,496 | 19,386 |
| Administrative | 29 | 13 |
| Unresolved | 0 | 0 |

These partitions exhaust 122,102/52,358 included points. Later Rally is the
largest observed ending category in each pooled category, not evidence of its
importance or causal credit. Shared Return reach is 100,398/45,017 points,
+1 reach 70,176/29,377, and later-rally reach 49,509/19,388. Reaches overlap.
Nine included Return reaches remain unknown (seven men's, two women's);
unknowns are retained, and affected conditional rates remain unavailable.
The 99,553 included +1 attempts contain 21,857 attempted errors (14,028/7,829).
They are Rally actions, not additional factor-total credit.

The all-inventory +1 ledger separately records 102,730 validated attempts,
77,031 known absences, 61,472 unvalidated observed prefixes and 1,894 unknown
opportunities. Its validation count precedes completion/score exclusion and must
not be substituted for the included +1 denominator. The duplicate-candidate
conflict occurs once; both raw action IDs remain recorded and the point is withheld.

Match/player and pooled profiles cover all 450 category-qualified literal source
identities (228 men, 222 women); 449 have included points (227/222).
The one zero-coverage men's identity remains visible with undefined rates.
Counts are pooled before division, with years, surfaces, opponents, date batches
and match/point retention retained. Exact source names are not a verified global
person registry; no alias reconciliation is inferred.

| Frozen display | Charts / eligible | Opponents | Included / inventory | Retention | Most frequent observed ending |
| --- | ---: | ---: | ---: | ---: | --- |
| Adrian Mannarino | 17 / 16 | 17 | 2,827 / 4,010 | 70.50% | Later Rally: 1,121 (604 wins / 517 losses) |
| Ajla Tomljanovic | 4 / 4 | 4 | 349 / 670 | 52.09% | Return: 137 (79 wins / 58 losses) |

Mannarino spans five years and Grass/Hard; Tomljanovic spans 2021–2022 and
Grass/Hard. Neither is replaced. Their different exposure and selective retention
prevent a fair comparison. Wins at a Serve ending can belong to the receiver,
for example at a double fault; a phase label does not assign action credit.
Both final SVGs were rendered and visually inspected: readable identities,
counts, retention, role-specific denominators and limitations, with no clipped labels.

### Remaining parsing and evidence limits

Grouped failures retain every reason. `INVALID_RALLY_DIGITS` is the largest:
34,786 men's points in 295 charts and 24,988 women's points in 287 charts.
Other leading reasons include missing point terminals (1,702/755), unsupported
shot codes (1,685/747) and errors lacking terminal markers (1,588/688).
Reason counts overlap and include completion-excluded charts, so they are not
another partition of the 62,407 QA-withheld points. Frozen
[notation evidence](mcp-notation-resolution.md) does not define these later-stroke
numeric codes; outcome agreement cannot supply a meaning. No grammar is extended.
The literal parser label `INVALID_RALLY_DIGITS` is not proof of a source error.
Score reconciliation records 242,279 PASS, 769 unsupported-format and 79 conflict
point rows; score PASS alone does not imply whole-point QA or analytical inclusion.

Because the dominant QA failure concerns later-stroke notation, retention is
related to recorded action context. The surviving ending/reach mix cannot be
assumed to describe withheld points or a player's complete match distribution.

Selective charting, annotation conventions, unsupported suffixes, unequal
opponents/surfaces/years and repeated-player dependence limit descriptive claims.
Supported prefixes never validate a full point. There is no certified tour
population, verified official completion or historical availability, representative
sample, independent factor, causal skill, ranking, forecast, NPR association or
weight estimate here. All acquired years remain exposed; 2026 is outside this cohort.
UNCERTAINTY_NOT_ESTABLISHED persists.

Outreach correction: **the user reports sending a TDI access request.**
Delivery is not independently verified. The private correspondence draft stays
outside this code release.
No tracking access is secured; NO_QUALIFYING_FREE_PAIRED_STATE_SOURCE_VERIFIED
and SERVE_CREATION_ATTRIBUTION_UNSUPPORTED remain unchanged.

### Verification and preserved release

**51,841 focused and release-integrity checks passed.** The independent full
rerun permuted metadata and reversed raw point order; all thirteen CSV/SVG files
are byte-identical. Tests streamed 1,257,935 actions and the same number of states;
independently reconstructed every terminal winner, physical reach, +1 error,
completion reason, match/player denominator and pooled ending win/loss count.
They checked source/rights pins, metadata-only selection, exact joins, neutral
slot swaps, zero/unknown dispositions, duplicate-candidate failure handling,
all expected cells, historical overlap and refused incomplete/differing installs.
All thirteen output files remain ignored; temporary stages were removed.

Separate documentation checks preserve all 665 historical-file fingerprints and
three current-document historical tails (668 checks), including the prior prototype
and stored TDI draft. The nine current-document local links/anchors and whitespace
pass; all three current source-of-truth sections agree with the measured release.
The complete tracked scope is the two new R files, this new report, and current
sections of PROJECT_CONTEXT.md, docs/status.md and docs/data-source-contract.md.
Both rendered final plots were inspected. No unrelated historical suite reran.

The frozen prospective specification SHA-256 is
`4adf874d8643b12e1b60b044cc79147e34795dfa6b5e5fe01d80c233631b6732`.
The largest single-chart parser/state input object was 5,181,840 bytes; this is
an object-size measurement, not total process peak RAM. CSV checks stream bounded
chunks instead of holding both full action/state corpora. The 13-file release
contains 3,364,840,209 bytes. No source, period, eligibility, historical release,
dependency or portfolio change, acquisition, fitting, scoring, ranking or publication.

| Output suffix | Bytes | SHA-256 |
| --- | ---: | --- |
| `action-states.csv` | 1,704,501,099 | `1b57613d846a6071116113152f8dd2f3e6dc257bebe4f62dc4d27561df1dd530` |
| `actions.csv` | 1,128,056,618 | `f7848bc4f2fb84251d0088b7d6e1f1b71ee9eb0bf0ce478731863e3b55f024b5` |
| `coverage.csv` | 904,673 | `005df41adc7965f485192b8787ee87171695850b1477bf701f108bde00c1e53d` |
| `match-completion.csv` | 1,138,073 | `960723784f764a6ab0b753ac54af32d5080c5a256f41dfd93f7f3297baf9ebf4` |
| `match-player-profiles.csv` | 32,508,915 | `6a8a921d3c1d68d060ad3032b4192b56a730ab41a6bd5d3f40f566bd88076fae` |
| `opportunity-prototype.svg` | 26,913 | `ccb9e03c8fe25622894132b275669a136c4764c58db99affe948ee87e2c5c838` |
| `parser-failures.csv` | 21,784 | `cb69ce6cad28d805528319c08c823bebf052adf3328ddc16233bf73e9c52aa83` |
| `period-inventory.csv` | 2,325 | `15b2bf3dae9e2ef744c9846c4907335d206c75ec12824112470e9027b4e6bcf7` |
| `player-exposure.csv` | 520,129 | `49d0c96f6b3d0452abc6d1a442ab656532030a233ce165a7a6b1ef373608ed74` |
| `point-dispositions.csv` | 263,181,383 | `150cf5359a231e7ee4aaa0be70c1a9cd6962fded577f838d60d82a0907670f1f` |
| `point-ending-prototype.svg` | 18,296 | `b13ef64f5bd50611a005c2d79f44fb5033a72018745ab8c683fa78dfb7317290` |
| `selection-dispositions.csv` | 10,495,063 | `c50ff33f8fccdfa8583fd72f18ce52c1778e6f4f0de160f4d80141bc65233b19` |
| `serve-plus1.csv` | 223,464,938 | `ff5960536288c70d70f9dcfca7e34edffba27044f497851378d87392be579262` |

### One next executable step — proposed, not implemented

Build a local read-only viewer for all frozen modern profiles, searchable by exact
identity, using the existing two plot types. Always display cohort exposure,
retention and unavailable values; never rank players. This makes the completed
analysis inspectable without adding a metric, interpreting unsupported notation
or turning selective observations into skill claims. The source-level annotation
gap remains visible, not silently repaired.

Exact approval: **Approve one local, read-only viewer of MCP_MODERN_POINT_PHASE_PROFILES_1.0.0 using the existing profile/coverage fields and two frozen plot types; show exposure, retention and unavailable values; add no analysis, ranking, parsing change, acquisition, dependency, publication or portfolio work.**
