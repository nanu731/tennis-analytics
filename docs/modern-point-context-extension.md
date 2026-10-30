# Modern point-context extension

## Frozen specification

Question: **“Where do tennis players win and lose their points?”**
Release: `MCP_MODERN_POINT_CONTEXT_1.0.0`. This specification is recorded before
calculation. The existing 1,261-chart inventory, completion and whole-point QA
membership are immutable. Context annotation cannot rescue a withheld point.

A break point is an ordinary-game pre-point state in which the receiver would
win that game by winning the point. Supported source server-relative scores
`0-40`, `15-40`, `30-40` and `40-AD` qualify. Deuce and server advantage do not.
Every opportunity counts, whether subsequently converted or saved. Tiebreaks,
including match tiebreaks, never qualify. An isolated copy of the pinned score
replay captures its state before the current winner is read; source score,
server and replay must agree and the preceding replay prefix must be conflict
free. Unsupported formats, conflicts or invalid preceding winners leave context
unknown. Prior outcomes may advance the score; the current/future outcome,
ending, round and final score cannot determine current context.

Included-point endings partition into Ace, Double fault, Other annotated winner,
Forced error, Unforced error, Administrative ending, Other supported ending,
and Unknown or unsupported classification. Only the frozen terminal token and
uniquely linked terminal action authorize classification. `UNRETURNABLE` is
Other supported ending, not inferred forced error. Administrative outcome,
penalty and challenge codes create no physical winner/error attribution.
Terminal actor is the explicit action's neutral slot, separately from point
winner. Winner/error actor perspectives identify selected player or opponent;
nonphysical and unresolved actors remain explicit. Double faults are recorded
server errors, not reclassified unforced errors. +1 remains Rally-owned.

`ALL_INCLUDED` uses unchanged included points. `BREAK_POINTS` uses included
points with positively reconciled break-point context. Unknown context remains
in inventory and coverage, outside this subset. Facing while serving and
opportunities while receiving are separate exposures. Shares and ending-type
shares divide by the selected subset's included points; phase-specific type
shares divide by that phase's subset count. Reached-point conditional win rates
retain their role-specific denominators. Counts pool before division; zero
opportunities are undefined. No percentage measures clutch ability.

Minimum implementation: one new `R/build_mcp_modern_point_context.R`, one focused
`R/test_mcp_modern_point_context.R`; existing viewer builder/tests updated in
place. Four new ignored flat outputs under `data/pilot/mcp-modern-point-context-v1-`:
`point-dispositions.csv`, `match-player-profiles.csv`,
`phase-terminal-profiles.csv`, `coverage.csv`. The generated viewer is atomically
refreshed, preserving its original embedded scientific payload and all historical
CSV/SVG releases. No raw notation or parser grammar changes. Documentation:
this report, current context/status/contract and existing viewer report.

Verification will cover pre-point timing, deuce/advantage/repeated opportunities,
tiebreak exclusion, frozen independent replay equality, actor/type identities,
exclusive accounting, unknowns, slot swaps, pooled denominators and independent
byte-identical reruns. Source/DOM tests do not establish browser visual QA;
the recorded browser restriction remains binding.

## Measured extension

**MODERN_BREAK_POINT_AND_ENDING_EXTENSION_BUILT.** All 243,127 points and
1,261 charts remain inventoried; original inclusion remains 174,460 points,
6,260 completion-excluded and 62,407 QA-withheld. Both subsets retain all
2,972 match/player and pooled profiles (450 category-qualified identities).
The outputs contain 243,127 point dispositions, 89,160 profile rows,
78,208 observed phase/type/actor cells and 2,972 coverage rows.

| Score context and break-point coverage | Men's category | Women's category |
| --- | ---: | ---: |
| Inventory points | 164,269 | 78,858 |
| Known pre-point context | 163,567 | 78,712 |
| Unknown/conflicting prefix context | 702 | 146 |
| Included points | 122,102 | 52,358 |
| Included context unknown | 0 | 0 |
| Known inventoried break points | 13,385 | 8,635 |
| Included break points | 9,953 | 5,619 |
| Known break points QA-withheld | 3,086 | 2,935 |
| Known break points completion-excluded | 346 | 81 |
| Known tiebreak points (never break points) | 5,976 | 2,018 |
| Included tiebreak points | 4,212 | 1,111 |

The 22,020 known inventoried break points partition exactly into 15,572 included,
6,021 QA-withheld and 427 completion-excluded. These are source-chart counts,
not official tournament opportunities. All included contexts are known; 848
inventory contexts remain unknown and cannot enter the break-point subset.

| Recorded ending | Men's all / break points | Women's all / break points |
| --- | ---: | ---: |
| Ace | 12,756 / 813 | 3,224 / 294 |
| Double fault | 5,562 / 416 | 3,669 / 398 |
| Other annotated winner | 23,350 / 2,036 | 9,867 / 1,096 |
| Forced error | 39,725 / 3,124 | 18,935 / 1,950 |
| Unforced error | 37,301 / 3,291 | 16,204 / 1,830 |
| Administrative ending | 29 / 1 | 13 / 2 |
| Other supported ending | 3,379 / 272 | 446 / 49 |
| Unknown or unsupported classification | 0 / 0 | 0 / 0 |

All 174,460 included endings have supported types; physical terminal actors have
zero unresolved slots. The 42 administrative endings remain nonphysical. The
68,667 nonincluded points have `WITHHELD` ending status, not success/failure or
OTHER credit. All 3,825 Other supported endings preserve collapsed unreturnable
notation without assigning a forced error. Each selected-player profile separately
reports break points faced and receiving opportunities; these sum to its subset
count. Phase/type/actor wins and losses sum to their cell counts.

### Verification and fingerprints

Prospective specification SHA-256:
`9d6066b62effcf224219c7bb07cfe8fc83bad2660439c13d382df1fb36d62c7f`.
Input pins in the builder verify selection, point, action and completion files,
in addition to existing saved-source/rights/parser/state checks. Whole replay
return values equal the independently called frozen helper, and its point
statuses agree with every frozen point status. Current/later outcome perturbations,
deuce/advantage/repeated-opportunity and tiebreak fixtures pass. Terminal actor
checks independently reconcile recorded winners/errors with neutral point winners.
Focused context validation: **2,990,532 assertions passed**; includes exact
membership and terminal phases matched point-for-point to the frozen ledger,
original all-point counts/missingness, ratios within CSV precision,
independent per-player reconstruction, unknowns, actual neutral slot swaps and
point permutations. An independent rebuild produced byte-identical files for all four exports.
Viewer checks preserve the original embedded payload byte-for-byte and verify
new metadata, every break-point value and every terminal cell against the CSVs.
Final viewer assertion totals are recorded in the viewer report. All 668 historical
fingerprint/tail checks and all thirteen frozen modern-output hashes passed.
No historical scientific suite was rerun.

| New ignored file under `data/pilot/` | Bytes | SHA-256 |
| --- | ---: | --- |
| `mcp-modern-point-context-v1-point-dispositions.csv` | 161,180,105 | `8e23bdb34cb5c8820c5f7dc4c1d6fb0a96f835f755296e914231c41a9b2669c3` |
| `mcp-modern-point-context-v1-match-player-profiles.csv` | 42,866,258 | `7bb22451e035fa18cb493a44daaf26028662224105b74624d4d6ac3161d0535b` |
| `mcp-modern-point-context-v1-phase-terminal-profiles.csv` | 33,448,880 | `574aca1339fe88353e926f4c2bbf85e7bfe0d0d7aedbbd181f6d4182c7b3682c` |
| `mcp-modern-point-context-v1-coverage.csv` | 1,045,596 | `4d2bc9277c86005c0297c2ad88995caf4b60b20f5a906e5871999bab6e7c8468` |

All files are staged before individual atomic installation. Existing differing
release bytes are refused. Independent rerun compares all four complete files;
no scientific release is overwritten. Initial development checks caught CSV
rounding-sensitive equality checks and a fixture missing inherited reach columns;
checks were corrected without changing definitions, membership or recorded results.
An interrupted test-file read occurred during editing; final runs parse tests
completely before executing them. No acquisition or scientific rescue occurred.

### Authority and schema

The [frozen modern release](modern-point-phase-profiles.md#verification-and-preserved-release)
and [parser authority](mcp-action-parser-audit.md#implemented-parsing-and-ownership)
remain unchanged. Saved chart instructions distinguish serve `*`/`#` (ace/collapsed
unreturnable) from stroke `*`/`#`/`@` (winner/forced/unforced error); the
[notation resolution](mcp-notation-resolution.md#evidence-to-rule-mapping) establishes
administrative challenge handling. This extension interprets no new grammar.
`modern_verify()` reuses saved rights/provenance/revision verification and the
frozen parser/state pins; no new licensing assumption or redistribution is granted.

The point ledger preserves raw sequences and terminal IDs, source score/server,
replay score/server/tiebreak evidence, context status and independent source/replay
break-point indicators, membership, type and neutral actor slot. Replay snapshots
are captured before the current `PtWinner` is read; the isolated replay's entire
return value must equal the unchanged helper's return. Tiebreak flags/expected
scores are replay evidence, not independently verified facts when context is
unknown. Conflicts fail closed from the first conflicting prefix onward.

Both profile subsets retain every match/player and pooled identity, including
zero-opportunity views. New metadata uses `subset_points`,
`subset_inventory_fraction` and `subset_usable_matches` to avoid calling the
break-point subset count all-point QA retention. The original viewer payload is
preserved. Terminal profiles store observed phase/type/actor cells; absent cells
have known zero counts only where the subset denominator is positive. A zero
subset has no type rows and every rate stays undefined. Type `phase_share` uses
`phase_denominator`; `subset_share` uses `subset_denominator`. Wins/losses are
selected-player point results and are not terminal-actor credit. Pooled counts
are summed before division, never averaged match percentages.

### Limitations and next step

These are recorded ordinary-game opportunities and charted endings, not causal
credit, pressure, clutch skill, rankings or validated factors. QA selection can
change both break-point and ending distributions. Internal score reconciliation
is not official match completion or full-event coverage. Historical categories,
exposed years, source-date limitations and `UNCERTAINTY_NOT_ESTABLISHED` remain.
The existing parser's unsupported notation remains withheld; context annotates
coverage without granting analytical inclusion. Administrative actors remain
nonphysical; collapsed unreturnable endings are not reassigned to Return errors.

One next step: a display-only readability/accessibility review using user-supplied
desktop and narrow-screen screenshots and browser observations. Exact approval:
“Review the revised local viewer using the screenshots and observations I provide;
change display only, preserve the frozen context release, and use no browser
workaround.” No browser verification or website integration is authorized here.
