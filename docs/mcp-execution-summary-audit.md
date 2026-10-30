# Sample-only MCP descriptive execution summaries

## Prospective count and denominator dictionary

Specified before summary calculation at baseline
`e6c4d19b7a40f023395d3cfeee942b0c9a8c3cea`, using frozen
`MCP_ACTION_STATES_1.0.0` and `MCP_STAGE2_1.1.0`. No action-value or skill
attribution is estimated. These definitions follow the existing
[parser support](mcp-action-parser-audit.md) and
[observable-state audit](mcp-action-state-audit.md).

| Domain / statistic | Numerator | Denominator / rate meaning |
| --- | --- | --- |
| Serve observed attempts | Usable nonvoid SERVE or SERVE_FAULT actions | Count only; eligible denominator repeats usable attempts, rate undefined |
| First-serve faults | Usable SERVE_FAULT with recorded serve number 1 | Usable physical first-serve attempts; administrative forfeits and lets excluded |
| Double faults | Usable second-serve fault with DOUBLE_FAULT terminal | Fully validated points served by this player; point-level outcome, not fault-attempt rate |
| Aces | Usable serve with ACE terminal | Fully validated points served by this player |
| Chart-coded unreturnable serves | Usable serve with UNRETURNABLE terminal | Fully validated points served by this player; collapsed `#` notation, excludes aces and distinct return-error actions |
| Return / Rally observed attempts | Usable STROKE actions owned by the domain | Count only; eligible denominator repeats usable attempts, rate undefined |
| Return / Rally balls put in play | Usable strokes without forced/unforced error terminal | Usable attempts, including terminal winners and the physical stroke before an administrative challenge; a chart-derived execution category, not trajectory inference |
| Return / Rally winners | Usable strokes with WINNER terminal | Usable attempts; winners are a subset of balls put in play |
| Return / Rally forced / unforced errors | Usable strokes with respective terminal label | Usable attempts; labels are annotations, not causal blame |
| Serve +1 attempts | Validated opportunity-ledger attempts linked to usable server-owned Rally ordinal-three actions | Count only; not extra domain credit |
| Serve +1 attempted errors | Forced or unforced errors among validated +1 attempts | Validated +1 attempts; known absences never enter the denominator |

Zero denominators produce undefined rates. Count-only rows also have undefined
rates rather than tautological percentages. Pool compatible numerators and
denominators before division; never average match rates.

Each summary row retains observed candidate counts, usable counts, unknown counts
and usable proportions. For action-based rows, unknown counts are withheld
observed attempts in that domain (or first-serve subset). They do not estimate
unobserved suffix length. For point-level serve outcomes, unknown counts are
nonvalidated points served by that player. For +1, unknown counts combine
unvalidated observed prefixes and unknown opportunities; known absences stay
separate. Coverage retains unresolved/unassigned rows and all points, so missing
actions cannot silently become successes, failures or known absences.

Literal error-subtype breakdowns (`n`, `w`, `d`, `x`, `!`) use only usable errors
with a recorded supported subtype. `e` and omitted forced-error subtypes remain
unknown and outside that breakdown denominator. Shot-type and direction +1
breakdowns use validated attempts with the respective attribute recorded;
unknown attributes have explicit rows and undefined rates. No new interpretation
of notation is introduced.

One action receives Serve, Return or Rally credit exactly once. +1 is a Rally
subset, not a fourth total. Lets and administrative challenges/forfeits receive
no physical-attempt credit. Unreturned outcomes depend on both players; none
of these sample summaries establishes attributed skill, population differences
or player rankings. Every match/player and tour remains represented regardless
of usable opportunity count.

Versioned outputs use the existing flat ignored prefix
`data/pilot/mcp-execution-v1-`: `dictionary.csv`, `execution-summary.csv`,
`breakdowns.csv` and `coverage-summary.csv`. No directory is added.

## Measured release and coverage

**SAMPLE_ONLY_MCP_EXECUTION_SUMMARIES_AUDITED.** The
[summarizer](../R/summarize_mcp_execution.R) verifies saved rights, eleven raw
source pins, notation evidence, sample, both parser releases and all four
observable-state hashes before reading. It executes no historical runner or
reparse. Source revision remains `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`.
CC BY-NC-SA 4.0 noncommercial research use remains the saved basis; no acquisition
or new redistribution permission is introduced.

All **44 matches, 88 match/player perspectives and 7,333 points** remain in
coverage. There are 17 dictionary rows, 1,547 execution rows (ALL, two tours,
88 match/player groups), 3,185 complete categorical breakdown rows and 135
coverage rows (ALL, tour, match, match/player). Sparse and zero categories stay
present. Match/player context-point counts repeat the match inventory; do not
sum these overlapping context views. Owned attempts and service-point statistics
are disjoint across the two player perspectives and do pool.

| Coverage / observed denominator | ALL | ATP-file | WTA-file |
| --- | ---: | ---: | ---: |
| All / validated points | 7,333 / 6,237 | 4,092 / 3,560 | 3,241 / 2,677 |
| Usable / all transitions | 31,136 / 38,593 | 17,415 / 20,893 | 13,721 / 17,700 |
| Transition retention | 80.68% | 83.35% | 77.52% |
| Usable / observed Serve attempts | 8,558 / 9,908 | 4,885 / 5,543 | 3,673 / 4,365 |
| Serve attempt retention | 86.37% | 88.13% | 84.15% |
| Usable / observed Return attempts | 5,483 / 6,488 | 3,058 / 3,534 | 2,425 / 2,954 |
| Return attempt retention | 84.51% | 86.53% | 82.09% |
| Usable / observed Rally attempts | 16,845 / 21,720 | 9,330 / 11,547 | 7,515 / 10,173 |
| Rally attempt retention | 77.56% | 80.80% | 73.87% |

The 30,886 usable physical actions receive exactly one domain assignment.
The 7,230 withheld observed physical attempts remain unknown for execution
summaries: 1,350 Serve, 1,005 Return and 4,875 Rally. Another 189 unassigned
rows preserve missing observations or unsupported suffixes whose unobserved
action length/ownership cannot be inferred. All 279 void-let and nine
administrative rows remain in coverage without physical-attempt credit.
Supported prefixes of nonvalidated points never enter rate denominators.

Match-level transition retention remains **8.60%–100%**. The complete tables
include the three previously identified low-retention charts rather than dropping
them. Conditional rates cannot correct this heterogeneous chart/sequence
selection. ATP/WTA columns describe this sample only, not tour differences.

## Counts and compatible execution rates

Each cell below is numerator / its prespecified denominator, followed by the
pooled percentage. Counts are pooled before division; no match percentages are
averaged. Zero denominators remain undefined in the implementation.

| Statistic | ALL | ATP-file | WTA-file |
| --- | ---: | ---: | ---: |
| First-serve faults / physical first attempts | 2,321 / 6,233 (37.24%) | 1,325 / 3,560 (37.22%) | 996 / 2,673 (37.26%) |
| Double faults / validated service points | 287 / 6,237 (4.60%) | 144 / 3,560 (4.04%) | 143 / 2,677 (5.34%) |
| Aces / validated service points | 413 / 6,237 (6.62%) | 314 / 3,560 (8.82%) | 99 / 2,677 (3.70%) |
| Chart-coded unreturnable / validated service points | 54 / 6,237 (0.87%) | 44 / 3,560 (1.24%) | 10 / 2,677 (0.37%) |
| Return balls put in play / attempts | 4,124 / 5,483 (75.21%) | 2,245 / 3,058 (73.41%) | 1,879 / 2,425 (77.48%) |
| Return winners / attempts | 137 / 5,483 (2.50%) | 65 / 3,058 (2.13%) | 72 / 2,425 (2.97%) |
| Return forced errors / attempts | 1,044 / 5,483 (19.04%) | 637 / 3,058 (20.83%) | 407 / 2,425 (16.78%) |
| Return unforced errors / attempts | 315 / 5,483 (5.75%) | 176 / 3,058 (5.76%) | 139 / 2,425 (5.73%) |
| Rally balls put in play / attempts | 14,077 / 16,845 (83.57%) | 7,809 / 9,330 (83.70%) | 6,268 / 7,515 (83.41%) |
| Rally winners / attempts | 1,217 / 16,845 (7.22%) | 659 / 9,330 (7.06%) | 558 / 7,515 (7.43%) |
| Rally forced errors / attempts | 1,110 / 16,845 (6.59%) | 644 / 9,330 (6.90%) | 466 / 7,515 (6.20%) |
| Rally unforced errors / attempts | 1,658 / 16,845 (9.84%) | 877 / 9,330 (9.40%) | 781 / 7,515 (10.39%) |
| +1 attempted errors / validated attempts | 724 / 3,986 (18.16%) | 368 / 2,180 (16.88%) | 356 / 1,806 (19.71%) |

Four administrative first-serve forfeits explain 6,237 service points versus
6,233 physical first attempts. There are 2,325 usable physical second attempts,
including 287 second faults. First and second fault attempts total 2,608. Neither
first faults nor double faults are an additional Return or Rally action.

Unknown exposure remains alongside every row: 1,012 withheld observed first
attempts; 1,096 nonvalidated service points for each point-level serve statistic;
1,005 withheld Return and 4,875 withheld Rally attempts for their execution rows.
These are exposure units, not inferred counts of unobserved errors/winners.

## Serve +1 and supported categorical breakdowns

Independent action reconstruction agrees exactly with the frozen opportunity
ledger: **3,986 validated attempts**, **724 attempted errors**, **2,251 known
absences**, **983 unvalidated observed prefixes** and **113 unknown opportunities**.
The four mutually exclusive opportunity dispositions total 7,333 points; errors
are a subset of attempts. The +1 validated-attempt fraction among attempt-or-unknown
opportunities is 3,986 / 5,082 = 78.43%; this is not observed-action retention or
a +1 success rate. Known absences are reported separately and cannot improve it.

Shot type is known on **3,984 / 3,986** validated +1 attempts (two unknown).
Counts include 2,098 forehand and 1,302 backhand groundstrokes, 264 backhand
slices, and every other supported type including zero categories. Direction is
recorded on **3,955 / 3,986**: direction 1 = 1,284, 2 = 937, 3 = 1,734; 31 are
not recorded. Categorical rates use only recorded-attribute denominators, while
explicit unknown rows have undefined rates. ATP has two unknown shot types and
ten nonrecorded directions; WTA has zero and 21 respectively.

Return error subtypes: net 466, wide 266, long 446, wide-and-long 62, shank 28,
unknown/omitted 91. Rally: 1,113, 606, 798, 98, 26 and 127 respectively. Supported
subtype denominators are 1,268 Return and 2,641 Rally errors; the unknown/omitted
counts are excluded from subtype-rate denominators and retained explicitly.
The forced/unforced classification itself remains known on these usable actions.
Error-breakdown retention uses all observed attempts in the respective domain,
not the selectively known-error subset.

The breakdown `count` field is the categorical numerator. Its denominator,
unknown exposure, retention numerator/denominator and rate status are explicit;
unknown rows are counts of missing attributes, never inferred errors or successes.

## Candidate-metric recommendation and limitations

**Potential measurement candidates, not validated factors:** physical
first-serve fault frequency and point-level double-fault frequency are directly
supported error components; Return and Rally in-play/error frequencies are
simple chart-execution candidates. Their construct and predictive usefulness
have not been established. Source labels, opponent pressure, stroke opportunities
and selective chart retention prevent isolated skill attribution.

**Overlap:** winners are already included in balls put in play; in-play plus
forced and unforced errors partition attempts. They cannot all represent distinct
mechanisms. Error-location categories subdivide errors. First faults and double
faults describe related serve mechanics with different denominators. +1 attempts,
errors and shot/direction categories are Rally subsets and receive no fourth
factor-total credit. Disjoint ownership alone establishes no independence.

**Too incomplete for comparison:** full-sample Rally rates have 4,875 withheld
observed attempts, and the worst match retains only 8.60% of transitions. No
cross-player, population or ranking comparison is defensible from these outputs.
The 54 collapsed unreturnable annotations do not measure every failed return;
unknown error subtypes and missing +1 attributes also prohibit complete-category
claims. Sparse tactical categories are breakdowns, not qualified metrics.

No action values, point-win probabilities, NPR correlations, weights, ratings,
models or scores are calculated. Official completion/admission, actual temporal
availability and movement attribution remain unresolved.
`UNCERTAINTY_NOT_ESTABLISHED` remains binding. All
acquired years including 2026 are exposed; no evaluation period is selected.

## Validation and preservation

The [focused tests](../R/test_mcp_execution.R) passed **2,367 checks**. They
independently reconstruct all 1,547 statistic rows from pinned parser actions
and points, verify all match/player ownership and compatible pooling, retain
undefined zero-opportunity and unknown-attribute rates, partition subtype
breakdowns and reconcile all +1 cases. Duplicate/identity/ledger disagreement
fixtures fail closed. Input permutations and audit-only raw/Notes perturbations
leave summaries unchanged. Four independently generated outputs are byte-identical;
idempotent installation and refusal of differing releases pass.

All **494 pre-existing artifacts** outside the three current-document updates
remain byte-for-byte unchanged, including raw sources, sample, both parser
releases, observable states and historical code/reports. Historical document
tails are also checked separately. A test-file regular-expression escape was
corrected before the successful run; no data, rule or scientific result changed.
**62 documentation, agreement, local-link, whitespace, exact-scope and preservation
checks passed.** All four installed outputs were inspected; historical document
tails remain unchanged. Only affected checks ran; historical suites were not
rerun. Installation stages all outputs,
rejects existing differing bytes before installation, and uses atomic per-file
renames; this is not a multi-file transaction.

| Ignored output | SHA-256 |
| --- | --- |
| dictionary | `ff422c58cf3ccc393ac0d258c3ccfb2d59aed5e5acc4ee756594bd6035f8d664` |
| execution-summary | `74ddb27e2b7d9c460566d8825e325e20ffe3360e290ae72ce3764ebc1726514f` |
| breakdowns | `17cf5a0de712ec1ca06b8108842d21bcbf9593510317f449132fcb3274d1948e` |
| coverage-summary | `97c4ac9fb0c639775f17af1efd8d6a94ab6dce74504654c59f51610ffaf4200c` |

## One next executable step and exact approval

“Implement a sample-only opportunity-context audit of the frozen execution
summaries. Prespecify compatible Return/Rally error-rate denominators by recorded
serve number and preceding observable stroke context; retain all 44 matches,
unknown contexts and withheld observations. Report context composition and
retention before any player comparison. Estimate no action values, probabilities,
correlations, factors, weights, ratings or models; acquire no data and choose no
evaluation period.”

This addresses the observed unequal opportunity/retention problem without
pretending to repair it. A genuinely untouched evaluation design still requires
user input before estimation; this milestone requires no new split decision.
