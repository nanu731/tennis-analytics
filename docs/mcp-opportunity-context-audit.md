# MCP opportunity context and measurement feasibility

## Prospective context dictionary

Specified before aggregation at baseline
`b4d66f7351afd729af1c47a46f65b3f91633cbf1`. Use frozen
`MCP_ACTION_STATES_1.0.0` and `MCP_EXECUTION_SUMMARIES_1.0.0` with the
[transition](action-factor-workflow-transition.md) and
[execution definitions](mcp-execution-summary-audit.md). No sample restriction,
new factor or evaluation period is adopted.

Five marginal views are prescribed; each partitions its own domain's observed
attempts. Their totals must not be added across views.

| View | Pre-action inputs | Fixed contexts |
| --- | --- | --- |
| Return serve number | Pending boundary/domain and recorded pending serve number | FIRST, SECOND, UNKNOWN, UNSUPPORTED |
| Rally role/phase | Pending boundary/domain, expected actor role and prior in-play stroke count | SERVER_PLUS1, SERVER_LATER, RECEIVER_LATER, UNKNOWN, UNSUPPORTED |
| Rally preceding stroke type | Role/phase plus incoming prior stroke type | Each documented literal type; UNKNOWN, UNSUPPORTED |
| Rally preceding direction | Role/phase plus incoming direction and its support status | Recorded 1/2/3; NOT_RECORDED, UNKNOWN, UNSUPPORTED |
| Rally preceding return depth | Role/phase plus incoming prior domain/depth/status | For +1 after Return: recorded 7/8/9, NOT_RECORDED, UNKNOWN, UNSUPPORTED; NOT_APPLICABLE for later strokes following Rally |

Rally attribute views are crossed only with role/phase, not with each other.
They are compact context diagnostics, not comprehensive difficulty strata.
Unknown documented shot type and unknown/ambiguous source annotations remain
explicit. An earlier unsupported/terminal boundary gives UNSUPPORTED context.
Current stroke type, direction, error, winner, terminal status and eventual point
outcome cannot define context. Ownership identifies the audited action universe;
expected actor/phase and incoming attributes use the pre-action allowlist only.
Movement, aggression, quality, causal responsibility and elapsed time are absent.

Observed Return/Rally STROKE rows are the attempt inventory. A usable execution
denominator requires the unchanged frozen whole-point/boundary gate. Numerators
are current forced/unforced errors, measured only after context assignment;
their sum is the total annotated error count. In-play strokes and winners retain
the existing definitions. Unknown contexts can have known execution outcomes,
but are never presented as comparable known-context strata. Unsupported boundaries
are withheld. Unknown execution exposure is withheld observed attempts, not an
inferred error or success count. Missing suffix action length is not estimable.
Service points without an observed return create no synthetic return attempt.

Pool compatible counts before division. Retention = usable / observed attempts;
composition = a context's observed or usable attempts / its domain/view total.
Execution rates = annotated errors / usable attempts. All zero denominators are
undefined. Composition and execution percentages describe this chart sample,
not point-win probabilities, isolated skill or population comparisons.

All 44 matches, 88 match/player perspectives and 7,333 points remain in coverage.
Output scope uses existing flat ignored `data/pilot/mcp-opportunity-context-v1-`
filenames: `dictionary.csv`, `context-summary.csv`, `coverage-summary.csv` and
`measurement-checks.csv`. No new directory or dependency is needed.

## Measured opportunity composition and retention

Release **MCP_OPPORTUNITY_CONTEXT_1.0.0** uses the
[focused audit](../R/audit_mcp_opportunity_context.R) and frozen verification
helpers. Saved CC BY-NC-SA 4.0 research-use rights, raw/source/evidence/sample
pins, both parser releases, all four state outputs and all four execution outputs
are checked before use. No acquisition, reparsing or historical runner is executed.
Source revision remains `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`.

Five dictionary rows produce 15,379 complete context rows, 135 coverage rows
and 84 measurement-check rows. All 44 matches and 88 match/player perspectives
remain present, including empty context cells. The 7,333-point inventory and
31,136/38,593 usable transitions remain unchanged. Match-level transition
retention is **8.60%–100%**. Missing/unassigned suffixes, void/admin events,
1,005 withheld observed Return attempts and 4,875 withheld observed Rally
attempts remain in coverage, without synthetic action or error credit.

| Context | Observed / usable attempts | Annotated errors / usable | Retention |
| --- | ---: | ---: | ---: |
| Return, first serve | 4,136 / 3,462 | 932 / 3,462 (26.92%) | 83.70% |
| Return, second serve | 2,349 / 2,021 | 427 / 2,021 (21.13%) | 86.04% |
| Return, unsupported prior boundary | 3 / 0 | 0 / 0 (undefined) | 0% |
| Rally, server +1 | 4,967 / 3,986 | 724 / 3,986 (18.16%) | 80.25% |
| Rally, server later | 7,301 / 5,585 | 813 / 5,585 (14.56%) | 76.50% |
| Rally, receiver later | 9,447 / 7,274 | 1,231 / 7,274 (16.92%) | 77.00% |
| Rally, unsupported prior boundary | 5 / 0 | 0 / 0 (undefined) | 0% |

Explicit UNKNOWN serve/phase cells have zero observed opportunities and
undefined rates. Unknown preceding attributes have nonzero counts below.
No zero cell is interpreted as error-free execution. +1 fully usable totals and
errors agree with the frozen ledger. Its 983 unvalidated prefixes include two
whose pre boundary cannot support +1 classification: the role/phase table counts
981 classifiable withheld +1 attempts and retains those two among unsupported
Rally contexts. Frozen opportunity dispositions are unchanged.

| Tour-file/context | Usable / observed | Error rate | Retention |
| --- | ---: | ---: | ---: |
| ATP Return first | 1,890 / 2,189 | 568 / 1,890 (30.05%) | 86.34% |
| ATP Return second | 1,168 / 1,343 | 245 / 1,168 (20.98%) | 86.97% |
| WTA Return first | 1,572 / 1,947 | 364 / 1,572 (23.16%) | 80.74% |
| WTA Return second | 853 / 1,006 | 182 / 853 (21.34%) | 84.79% |
| ATP server +1 | 2,180 / 2,649 | 368 / 2,180 (16.88%) | 82.30% |
| ATP server later | 3,101 / 3,858 | 444 / 3,101 (14.32%) | 80.38% |
| ATP receiver later | 4,049 / 5,038 | 709 / 4,049 (17.51%) | 80.37% |
| WTA server +1 | 1,806 / 2,318 | 356 / 1,806 (19.71%) | 77.91% |
| WTA server later | 2,484 / 3,443 | 369 / 2,484 (14.86%) | 72.15% |
| WTA receiver later | 3,225 / 4,409 | 522 / 3,225 (16.19%) | 73.15% |

These are conditional chart-sample execution percentages, not tour effects,
point-win estimates or causal responses to a serve/stroke. Context composition
changes the pooled rate. Both Return serve classes and server +1 have nonzero
usable opportunities in all 40 ATP and 48 WTA match/player perspectives.
Later server and receiver contexts each occur in only 32/40 ATP and 39/48 WTA
perspectives. Within-player first-serve shares of usable returns range from
**40.00%–77.61% ATP** and **41.03%–88.89% WTA**. These are composition ranges,
not rankings or performance thresholds.

Nonzero support is not precision: per-player usable first/second-return
denominators range from 11–106 / 7–63 in ATP and 6–81 / 1–35 in WTA.
Some later-Rally cells have no opportunities at all. No minimum-size threshold,
rescue, smoothing or sample exclusion is manufactured from these counts.

## Preceding-attribute support and missingness

Usable Rally contexts have **five unknown incoming stroke types** (four ATP,
one WTA), **16 nonrecorded/unknown incoming directions** (five ATP, eleven WTA)
and **107 nonrecorded preceding return depths at +1** (90 ATP, seventeen WTA).
Return depth is recorded for 3,879/3,986 usable +1 contexts: depth 7 = 816,
8 = 2,045, 9 = 1,018. Later-Rally incoming depth is explicitly NOT_APPLICABLE,
not missing or zero. Current +1 attributes from the previous audit must not be
confused with these preceding-return attributes.

Only server +1 following a forehand-groundstroke return has usable observations
in every match/player perspective, in both tours. No individual preceding-return
depth cell has support in every perspective. For +1 directions, all ATP
perspectives have direction 2, but no direction cell occurs in every WTA
perspective. Rare literal types are fully reported rather than collapsed according
to outcomes or selected after seeing error rates.

The apparently complete incoming-direction field among usable actions hides
strong QA selection. **3,670 observed Rally attempts** have unknown/nonrecorded
incoming direction, but only **16** are usable (**0.44% retention**). The
recorded-direction cells retain **16,829/18,045 (93.26%)**; five unsupported
boundary rows remain separate. This is a descriptive association of context
recording and the existing whole-point gate, not proof of its cause. NOT_RECORDED
in a withheld prefix does not validate the meaning of unresolved notation. The
whole-point gate remains binding and no prefix is promoted.

## Comparability and structural dependencies

The audit establishes compatible count denominators within each literal context
and player perspective. It does **not** establish exchangeability of opportunities
across players. Recorded serve number is not a complete measure of serve
difficulty; stroke type/direction/depth do not measure ball speed, spin, quality,
positions or opponent pressure. QA selection is severe and context-dependent;
sample-wide rates cannot be repaired by a rich contextual table. Official normal
completion and analytical admission remain unverified.

Exact identities hold in every reported cell: attempts = in-play + forced errors
+ unforced errors; total errors = forced + unforced; winners are included in
in-play. Each view partitions the same domain, so view totals duplicate exposure.
Role/phase partitions Rally, while +1 is nested in Rally rather than a fourth
domain. Error subtype breakdowns likewise partition existing errors. First-serve
faults and double faults remain related Serve components with different
denominators. All algebraic and frozen +1 residuals are zero. None of this proves
uncorrelated or incrementally useful player metrics; no correlations are computed.

Opportunity selection also links domains: a recorded ace, double fault or terminal
return leaves no +1 attempt, and later strokes require the preceding sequence
to continue. Thus error rates condition on different surviving opportunities;
they cannot be added into a point-performance total or interpreted as independent
mechanisms merely because action credit is exclusive.

## Validation and preservation

The [focused tests](../R/test_mcp_opportunity_context.R) passed **1,408 checks**.
Independent chronological reconstruction from frozen parser actions matches all
pre-context keys and all observed/usable/error counts across the five views and
88 player perspectives. Current terminal/stroke/Notes and later unsupported-suffix
perturbations cannot change contexts; changed earlier incoming attributes provide
a positive control. Zero opportunities, unknown support, pooling, ownership,
context partitions, full point coverage and +1 reconciliation pass.

All four output reruns are byte-identical; per-file atomic installation refuses
differing releases before changing installed files. It is not a multi-file
transaction. **501 pre-existing artifacts** outside the current-document updates
remain unchanged, including raw inputs, sample, parser/state/execution releases
and historical code/reports. **73 documentation, agreement, links, whitespace,
exact-scope and historical-preservation checks passed.** All four installed
summaries were inspected; historical document tails remain unchanged.
Only affected checks ran. All acquired years,
including 2026, remain exposed. `UNCERTAINTY_NOT_ESTABLISHED` remains binding.
No action values, probabilities, NPR correlations, factors, weights, ratings,
models, data acquisition, new dependencies, directory structure or portfolio
changes occurred; no evaluation period was selected.

| Ignored output | SHA-256 |
| --- | --- |
| dictionary | `ed2fce2ac242bc1cf7b9ebaaf02e4a5cded149ca1f8288f8ae2276a4de61cd05` |
| context-summary | `6630898e21ed059320730821a6a04bc451f007732c545b0c48c522f75c793b94` |
| coverage-summary | `1777e842998d6abc5d50e273704803e90d567d220573b36a1cd2250ec528444b` |
| measurement-checks | `c0ee60ac388288725a9c49c634e63d5179527b4a04ef09e6baad9ffa64937276` |

## Smallest useful next experiment and terminal decision

The smallest useful falsification experiment is **whole-match retrospective
transfer of Return error frequency separately for first- and second-serve
opportunities**. Those two coarse contexts are observed in all 88 perspectives;
this tests whether apparent execution differences persist outside their original
matches without pretending richer context measures difficulty. Specify repeated
players, opponent confounding, zero opportunities, QA-conditioned estimands and
failure disclosure before estimation. Keep three proposed action domains, but
do not estimate independent contributions or treat +1 as another factor.

Exact next approval: “Draft a bounded candidate-metric specification and
retrospective evaluation protocol, with first-/second-serve Return error
frequency as the first whole-match transfer experiment. Freeze definitions,
denominators, exposure, repeated-player handling, QA/unknown reporting and
failure rules. Present concrete retrospective split options for my choice;
do not select a period, restrict the sample, fit, acquire data or claim an
untouched final test.”

The concrete user choice needed before estimation is the retrospective split
and intended transfer claim, followed by approval of the frozen protocol.

**Terminal decision — 1. Proceed to a bounded candidate-metric specification
and retrospective evaluation design.** Both coarse Return contexts have usable
observations in all 88 match/player perspectives and reconstruct exactly. That
supports a small falsifiable specification, not qualified player comparisons or
permission to fit. Sparse richer Rally contexts and QA-dependent retention must
remain limitations. No restricted sample is adopted or proposed as a repair.
