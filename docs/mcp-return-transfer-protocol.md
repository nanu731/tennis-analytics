# MCP Return-frequency transfer protocol — pending split choice

**BOUNDED_RETURN_TRANSFER_PROTOCOL_DRAFTED_PENDING_USER_SPLIT_CHOICE.**
Baseline: `6e41b52ca9dc66e596e08b083f03dda460b05a35`. Authority:
[action workflow](action-factor-workflow-transition.md) and
[opportunity-context audit](mcp-opportunity-context-audit.md).
This document specifies one sample-only experiment; no estimates or scores have
been calculated and no period, eligibility change or final test is adopted.

## Measurement and target

Two context-specific measurements belong to **one Return domain**, not two
independent factors. For receiver/player `p`, match `m`, recorded serve context
`c ∈ {FIRST, SECOND}`:

- `N[p,m,c]`: frozen usable Return-owned STROKE attempts with pre-action serve
  context `c`; not service points, hypothetical noncontact actions or Rally/+1.
- `E[p,m,c]`: those attempts with current terminal FORCED_ERROR or UNFORCED_ERROR.
  Preserve both subcounts; total annotated error frequency is `E/N` when `N>0`.
- Player perspective is the acting receiver, linked to the frozen neutral A/B
  player identity. Use exact saved names within tour; no alias inference.

Lower frequency means fewer annotated errors among these observed attempts,
not better causal skill, total return effectiveness or easier opportunities.
Aces, double faults and collapsed unreturnable serves create no synthetic Return
attempt. Winners and other in-play returns are nonerrors, not independent factors.
UNKNOWN/UNSUPPORTED serve contexts and withheld actions never enter either
numerator or denominator. Retain their counts and reasons alongside every match.
Empty/zero-opportunity cells are undefined, not zero-error performances.

**Transfer target:** future *observed and frozen-QA-usable Return errors* in a
later source-date match, conditional on FIRST or SECOND serve context. This is
retrospective source-label transfer on the available charts, not point-winning,
NPR, match-winning, movement, action value or population performance.

All 44 matches / 88 player perspectives / 7,333 points remain in inventory.
The frozen sample has positive first/second Return denominators in all 88
perspectives; this establishes availability, not precision. Normal match
completion/admission and actual historical data availability remain unverified.
This experiment creates no primary Four Factors analytical admission. Disclose
any input/standing-rule conflict and stop rather than quietly changing eligibility.

## Simplest prior-match estimator

For each target match, freeze two receiver estimates before its source-date batch:

`q[p,c,t] = sum(E[p,m,c]) / sum(N[p,m,c])`, over same-tour matches with
source `Date[m] < Date[t]` permitted by the chosen split.

Pool counts before division; never average prior-match frequencies. Include all
eligible earlier chart matches, all surfaces, and both error labels. Use no
window, decay, opponent adjustment, smoothing, imputation, minimum-size cutoff,
sign constraint or model fit. A long gap remains visible rather than being
converted to an inactivity adjustment. These are historical receiver/context
frequencies, not forecast coefficients or importance weights.

Same-tour equal-date matches are simultaneous: freeze estimates for the entire
batch and append its counts only after every match is evaluated. No point,
player, outcome or count from the target match, same-date batch or later date can
enter its estimates. Source Date is a chart label, not verified start/completion
time or proof that a historical observer possessed the chart.

Use one simple **reference** on the identical supported target cells: the
same-context, same-tour pooled error frequency from all strictly earlier matches.
It tests whether personal recurrence adds anything beyond the training tour's
context average; it is another unadjusted count pool, not a rescue for cold starts.
No parameter search or alternative estimator is introduced.

## Cold starts, processing and abstention

`NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS` withholds an estimate when the personal pooled
denominator is zero. Sparse positive denominators remain allowed and reported
exactly with prior match count, attempts and date span; no invented adequacy gate
or smoothing. `NO_USABLE_TARGET_CONTEXT_ATTEMPTS` withholds assessment when a
target denominator is zero. `UNKNOWN_OR_UNSUPPORTED_CONTEXT` and
`WITHHELD_ACTION` retain unscored exposure, never successful/failed attempts.
Seed matches are `SEED_NOT_EVALUATED` while remaining in the inventory.

Fail closed on pin changes, duplicate/ambiguous identities, missing/invalid date
labels, conflicting joins, noninteger/negative counts, `E>N`, a same/later-date
contribution, or a mismatch with frozen context totals. Stop the affected release
and disclose the defect; do not repair data or silently drop a match. Missing
reference counts withhold the paired comparison, not substitute a player estimate.

All parsing, identities and QA rules are already frozen. Future preprocessing or
method changes require separate approval and must use training data only. Target
outcomes cannot set contexts, cutoffs, thresholds, pooling rules or exclusions.

## Feasible chronological options measured without error outcomes

Counts below use pinned sample `Date`, tour and exact player names, plus the
existing positive attempt availability. No error numerator or model result was
used. All source dates are valid labels; no same-tour equal-date matches occur
in this sample, but simultaneity remains required. Source revision:
`1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`.

| Option / tour | Initial training seed | Evaluation matches | Returning / no-history player-match slots | Supported context targets / distinct returning players |
| --- | ---: | ---: | ---: | ---: |
| A: all-date expanding / ATP | 1 | 19 | 6 / 32 | 12 / 4 |
| A: all-date expanding / WTA | 1 | 23 | 6 / 40 | 12 / 5 |
| B: from-2020 expanding / ATP | 12 | 8 | 3 / 13 | 6 / 2 |
| B: from-2020 expanding / WTA | 12 | 12 | 3 / 21 | 6 / 3 |

**A:** Seed the earliest date batch in each tour. ATP seed is 1987-09-12;
evaluation labels span 1988-06-29–2026-01-25. WTA seed is 1989-01-28;
evaluation spans 1993-06-05–2026-07-01. Earlier training inventories expand
from 1 to 19 ATP matches and 1 to 23 WTA matches. The union of matches available
as earlier training is 19/23; these overlap later evaluation membership and must
not be added as a disjoint train/test total.

**B:** Seed source dates before 2020-01-01, then expand using strictly earlier
evaluated matches. ATP seed ends 2019-08-27, evaluation spans
2020-09-07–2026-01-25; WTA seed ends 2019-07-01, evaluation spans
2020-09-30–2026-07-01. Training inventories expand from 12 to 19/23. This asks
about transfer into the recent exposed charts, with less personal recurrence.

In A, exactly six evaluation matches per tour contain one supported receiver;
none contains two. Thirteen ATP / seventeen WTA evaluation matches contain none.
In B, three per tour contain one; five ATP / nine WTA contain none. Unsupported
player-context targets number 64/80 in A and 26/42 in B. Seeds account for the
remaining inventory; neither option excludes cold starts from coverage.
Maximum personal prior depth is three ATP / two WTA matches in A, and three / one
in B. Across the entire sample, only four ATP and five WTA players recur.

**Recommend A**, because it uses every chronological return encounter and doubles
supported target cells versus B without selecting on error outcomes. Its claim
is limited to transfer within these few recurring charted players across source
dates, sometimes across long eras. It cannot establish contemporary form,
population generalization, reliable uncertainty or an untouched final test.
The period remains **UNSELECTED_PENDING_USER_CHOICE**; B remains a valid narrower
temporal question, not a performance-selected alternative.

## Frozen assessment and dependence rules

Report tours and FIRST/SECOND contexts separately. Preserve seed/evaluation
inventory, prediction/abstention status, prior match/attempt depth, target usable
and withheld attempts, unknown contexts, and retention by match/player. Report
pooled observed counts alongside rates; supported-score coverage cannot replace
the 44-match inventory. Freeze prediction IDs before computing losses and use
identical IDs for personal and tour-reference comparisons.

Measurement stability: report each supported target frequency `E_target/N_target`,
its signed departure and absolute departure from the frozen personal estimate,
and every match/player/context result. Do not create a stability threshold,
rank players, correlate with NPR or declare a factor from these differences.

Prediction assessment: primary squared error/Brier for future error indicators.
For a target cell with estimate `q`, compute exactly
`[E*(1-q)^2 + (N-E)*q^2]/N`. Within each tour/context, average supported player-cell
losses within match, then average whole-match losses equally. This evaluates a
typical supported chart match, not an IID action population. Report opportunity-
weighted loss as a secondary estimand, pooling loss sums and attempt counts,
not averaging match percentages. Personal-minus-reference differences use the
same masks; negative favors personal descriptively, with no selection rule.

Secondary natural-log error loss is
`-[E*log(q) + (N-E)*log(1-q)]/N`, with `0*log(0)=0` by explicit cases. Unsmoothed
`q=0/1` estimates are valid: a contradictory target error/nonerror yields infinite
log loss, which must be reported rather than clipped, rescued or silently omitted.
Brier remains finite. No accuracy cutoff, calibration regression, confidence
interval, p-value or significance/superiority claim is authorized.

Whole matches stay intact; no point-level train/test split. Both opponents and
recurring receivers induce dependence, and only four/five returning players
support A. Report leave-one-evaluation-match and both-slot leave-one-player
score-deletion influence on frozen predictions, without refitting; remove every
evaluation match containing that player. An empty remainder is UNEVALUABLE.
These diagnostics are not confidence intervals or independent replications.
Retain `UNCERTAINTY_NOT_ESTABLISHED`.

Selective whole-point QA is retrospective. Return retention is 3,462/4,136 first
serve and 2,021/2,349 second serve, with three unsupported prior-boundary attempts
and 1,005 total withheld Return attempts. Match transition retention ranges from
8.60% to 100%. Conditioning on usable charts can select sequence styles and
opponents. This experiment cannot predict or validate performance on unobserved
actions, eliminate that selection bias or isolate causal receiver ability.

## Verification and exact decision needed

Saved rights/source/parser/state/execution/context hashes were checked. Split
accounting was calculated using context-only metadata and checked independently;
no predictions, histories containing error counts, fits or scores were built.
**84 context-only split, documentation, agreement, link, whitespace, exact-scope
and preservation checks passed; all 509 pre-existing artifacts outside the two
current-document updates and their historical tails remain unchanged.**
No generated repository output, code, dependency or historical release changes.
All acquired years, including 2026, remain exposed.

**User decision required:** Choose **A (recommended)** for all-date expanding
source-label transfer, or **B** for expanding transfer into 2020–2026 charts, and
approve the corresponding conditional claim and this frozen estimator/assessment.
Exact execution approval: “Implement Option [A or B] of
docs/mcp-return-transfer-protocol.md using the frozen 44-match inventory,
strictly earlier source-date pooled counts and all prespecified abstention,
coverage, scoring and dependence rules. Make no eligibility, smoothing,
adjustment or split changes; acquire no data and claim no untouched final test.”
