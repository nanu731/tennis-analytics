# Broader MCP Return-transfer protocol — frozen ALL_DATE_EXPANDING

**BROADER_RETURN_TRANSFER_PROTOCOL_FROZEN.** Baseline
`9b49a926e0d0ce2eb9e5deed45181be00fab85ef`. The user selected ALL_DATE_EXPANDING
and authorized conservative completion eligibility before scoring. This protocol
freezes that experiment on the [broader sample](mcp-repeated-player-sample-audit.md),
reusing the [original definitions and assessment](mcp-return-transfer-protocol.md).
The [action workflow](action-factor-workflow-transition.md) remains authoritative.
Only eligibility and opportunity support have been calculated; no error-rate
performance, estimate, fit or comparative loss was inspected or calculated here.

## Inventory and completion gate

Preserve all 159 sampled matches, 318 neutral player slots and 31,218 points in
coverage. No reselection, replacement, name reconciliation or parser repair.
ATP/WTA source labels mean historical men's/women's analysis categories, with
source-supported major main-draw context; they do not certify governing-tour
membership for early charts. Exact saved names define identities within category.

**The same whole-match gate applies to targets, personal histories and the
category/context reference.** Require all of the following saved evidence:

- Contiguous point IDs, a chart beginning at zero, valid point ownership, and
  exact expected/observed point totals.
- Frozen score replay with zero conflicts and `chart_score_complete=TRUE`.
- Zero saved status-note cues and zero recorded terminal-outcome conflicts.

Exclude the entire match on an incomplete ending, unresolved terminal-outcome
conflict, status cue or failed internal reconciliation. Preserve all overlapping
reasons. The existing status cue inventory covers retired/retirement/ret,
walkover/w/o, abandoned/unfinished/incomplete. A cue triggers conservative
exclusion, even if it cannot be independently diagnosed; absence of a cue alone
never establishes completion. No dedicated official status column or complete
external official-status crosswalk exists in this saved release.

Unavailable chart completion, status-cue accounting, terminal-conflict accounting,
start/continuity or reconciliation evidence **fails closed**. A missing evidence
row, pin, schema or identity join stops the release rather than dropping an ID.
No manual repair or override is permitted. Known retirements/walkovers and their
partial observations cannot enter either targets or prior/reference pools.

**Internally consistent chart completion is sufficient only for this conditional
retrospective chart experiment. Official completion remains NOT_VERIFIED for
every match.** Missing official certification alone does not exclude a chart
passing every internal gate; it limits the claim. This does not establish primary
Four Factors admission or prove that undetected source status errors are absent.

The earlier Stage 1 terminal-pattern shortcut is retained as provenance, not
substituted for complete score replay: 22 charts have a complete replay despite
an unresolved shortcut label, and one of these has the independently excluded
terminal conflict. An unresolved notation suffix or outcome-only point is not
itself a contradictory terminal outcome; existing action QA still withholds it.
No supported prefix earns full-point validation and no withheld action becomes
an observed success, error or known absence.

Measured whole-match exclusions:

| Source match | Reason | Target/history/reference use |
| --- | --- | --- |
| 2018-01-26 Chung–Federer, Australian Open SF | Incomplete chart ending | Excluded |
| 2024-07-01 Michelsen–Harris, Wimbledon R128 | One unresolved terminal-outcome conflict | Excluded |
| 2019-07-03 Gasparyan–Svitolina, Wimbledon R64 | Incomplete chart ending | Excluded |

All 159 charts have zero saved status-note cues, contiguous IDs, a zero start and
no score-replay conflicts. These facts do not diagnose the two incomplete endings
as retirements or certify official completion. No additional completion decision
is pending for this narrowly stated experiment.

## Measurements, estimates and chronology

For receiver `p`, match `m`, context `c` (FIRST or SECOND), `N[p,m,c]` is the
number of frozen-QA-usable Return-owned STROKE attempts with recorded pre-action
serve context `c`. `E[p,m,c]` counts those attempts ending in FORCED_ERROR or
UNFORCED_ERROR; preserve both subcounts. Their sum divided by N measures
annotated error frequency, not causal responsibility or total return skill.
FIRST/SECOND are two contexts within one Return domain, not independent factors.
Aces, double faults and unreturnable serves create no synthetic Return action;
Rally/+1 contributes no Return credit. Unknown contexts, unsupported notation and
withheld actions enter neither E nor N. Zero-opportunity frequencies are undefined.

For each same-category source-date batch, freeze:

`q_personal[p,c,t] = sum(E[p,m,c]) / sum(N[p,m,c])`

using every eligible same-player/category match with `Date[m] < Date[t]`.
The reference is `q_reference[c,t] = sum(E[all receivers,m,c]) /
sum(N[all receivers,m,c])` over the same eligible earlier category/context pool.
Pool counts before division; use every surface and all eligible earlier dates.
The reference is a comparator, never a substitute for a missing personal history.

Seed **all eligible matches at the earliest eligible date per category**;
seed matches are not evaluated. Every later eligible batch is evaluation inventory.
The measured seeds remain 1960-07-04 and 1993-07-02. Freeze all predictions before
the complete simultaneous batch; only afterward add its eligible counts to later
pools. No points from a match are split across training and evaluation. Equal-date
matches cannot supply one another. No window, decay, smoothing, clipping,
imputation, adjustment, minimum-denominator threshold or model fitting.
Source dates are labels, not verified information-availability timestamps.

## Mask, precedence and failure handling

Retain all four context inventory rows (FIRST/SECOND/UNKNOWN/UNSUPPORTED) for
both players. Precedence: completion exclusion; unknown/unsupported context;
seed; zero usable target denominator; zero personal prior denominator; zero
reference denominator; otherwise paired support. Record every completion reason
and all raw availability counts even when an earlier disposition takes precedence.

Positive sparse denominators are sufficient to attempt the descriptive estimate;
they are not evidence of adequacy. Keep personal/reference comparison IDs identical
by category, match, neutral slot and context. Freeze the mask before losses.
No error numerator, target error rate or loss can select a row or change a gate.
Unknown/withheld exposure remains visible alongside retained denominators.

Stop on changed pins, duplicate/ambiguous IDs, invalid dates, inconsistent joins,
noninteger/negative counts, E>N, E unequal to its two error subcounts, a cutoff
violation or mismatch with frozen availability. Do not rescue, replace or repair.
An absent comparison is UNEVALUABLE; never substitute zero loss.

## Frozen assessment and dependence

Evaluate categories and FIRST/SECOND separately. For target-cell estimate q:

- Primary Brier: `[E*(1-q)^2 + (N-E)*q^2]/N`.
- Secondary natural-log loss: `-[E*log(q)+(N-E)*log(1-q)]/N`, with explicit
  `0*log(0)=0` cases. An unsmoothed boundary estimate contradicted by a target
  observation yields infinite loss. Report it; never clip or omit it.

Within each category/context, average supported receiver-cell losses within each
match, then average matches equally. The secondary opportunity-weighted estimand
pools loss sums and attempt counts. Report personal-minus-reference differences;
negative favors personal descriptively. Inf minus Inf is indeterminate, not a tie
or victory. There is no selection threshold or transfer/superiority qualification.

Reuse measurement-stability reporting: every supported E/N, signed and absolute
departure from the frozen personal estimate, with denominators. Report coverage,
seed/abstention reasons, retained/withheld exposure, prior match/attempt depth and
source-date gaps by category, match and player. No ranking or NPR association.

Keep the original leave-one-evaluation-match and both-slot leave-one-player
score-deletion diagnostics on frozen predictions, without refitting or deleting
training history. A player deletion removes every evaluation match containing
that player, including the opponent slot. Enumerate all eligible evaluation
matches/players, including deletions removing zero paired cells. Empty remainders
are UNEVALUABLE. Predictions stay batch-frozen even when deleting one match in a
same-date batch. Recurring-player and batch dependence preclude IID uncertainty;
retain `UNCERTAINTY_NOT_ESTABLISHED`. No intervals, p-values, calibration regression,
accuracy cutoff or statistical-superiority claim.

## Measured post-exclusion support

These are completion/availability counts, not estimates or loss results.

| Measure | Men's category (ATP label) | Women's category (WTA label) |
| --- | ---: | ---: |
| Inventory / eligible / excluded matches | 75 / 73 / 2 | 84 / 83 / 1 |
| Eligible source-date batches | 72 | 79 |
| Seed / later evaluation matches | 1 / 72 | 1 / 82 |
| Later evaluation batches | 71 | 78 |
| Supported FIRST / SECOND cells | 69 / 69 | 87 / 87 |
| Supported matches / receiver slots / identities | 58 / 69 / 30 | 70 / 87 / 31 |
| Supported selected recurring players | 19 of 20 | 20 of 20 |
| Cold-start FIRST/SECOND cells, excluding seed | 150 | 154 |
| Completion-excluded / seed FIRST/SECOND cells | 8 / 4 | 4 / 4 |
| Zero target / reference denominator failures | 0 / 0 | 0 / 0 |
| Eligible observed / usable / withheld Return attempts | 16,018 / 13,974 / 2,044 | 10,788 / 8,332 / 2,456 |
| Usable attempts removed by completion exclusion | 338 | 32 |
| Eligible Return retention | 87.24% | 77.23% |
| Prior-match depth among supported cells | 1–4 | 1–7 |
| Prior attempts among supported cells | 7–275 | 4–276 |
| Latest-prior source-date gaps | 1–3,789 days | 1–8,088 days |

Eligible FIRST: 8,515/9,826 attempts (86.66%) men; 5,208/6,765 (76.98%) women.
Eligible SECOND: 5,459/6,183 (88.29%) men; 3,124/4,009 (77.92%) women.
The additional 9/14 unsupported-context attempts are withheld and included in
the pooled observed/withheld totals. Supported target exposure is 6,370/4,508
attempts. The 636 FIRST/SECOND inventory cells partition exactly into 12 excluded,
8 seed, 304 cold starts and 312 supported cells. Removing excluded histories
reduces support from 144/178 to 138/174 cells; no replacements occur.

All sample dates remain exposed, including 2026. Changing eras, long gaps,
convenience selection, crowdsourced labels, unverified official completion,
source-date chronology and selective QA constrain every conclusion. Retention
cannot establish performance on unobserved actions, contemporary form, player
skill, population transfer, independent factors or an untouched final test.

## Reproducibility and executable next step

[Eligibility/support builder](../R/freeze_mcp_broader_return_protocol.R) and
[focused tests](../R/test_mcp_broader_return_protocol.R) use pinned saved evidence
and existing verification helpers. No parser/state/historical release changed.
Three ignored files use `data/pilot/mcp-broader-return-protocol-v1-` plus `.csv`:

| Stem | Rows | SHA-256 |
| --- | ---: | --- |
| match-eligibility | 159 | `c54ea1ad73b9d228979235b8090a705b2d01d29107433431d9b9eacf11c8eda3` |
| context-support | 1272 | `64567fe04d807a1219e780a457314d34cf2744e0a74c9863ab4042477e45dfd7` |
| summary | 6 | `af5faf044dbbe6150f40ffbec93f57cf90f505831086ebb4b46568216e701421` |

Input hashes are embedded in the builder; it verifies saved rights/source and
scientific helper pins before loading selected evidence. Installation stages and
preflights all destinations, refuses differing files and uses atomic per-file
renames; no crash-safe multi-file transaction is claimed. **5,136 focused checks
and 95 documentation, scope, accounting, pin and preservation checks passed.**
All three independently rebuilt outputs are byte-identical; 537 historical
artifacts and the three current-document historical tails remain unchanged.
Checks cover completion conflicts/missingness, exact identities, all-context
accounting, independent personal/reference denominators, abstention precedence,
same-date and later-exposure invariance, excluded-history perturbations, eligible
earlier-exposure positive controls, permutations, output pins and ignored scope.
Only affected checks ran; no historical suite or scoring routine was rerun.

**One next executable step:** implement this frozen broader Return-transfer
experiment, producing personal/reference pooled estimates and the specified
paired loss/deletion outputs, without changing completion, dates or masks.
Exact approval: “Execute docs/mcp-broader-return-transfer-protocol.md on the frozen
eligibility/support release using ALL_DATE_EXPANDING. Preserve all definitions,
completion exclusions, positive-denominator abstention, unsmoothed pools,
identical masks and loss/deletion rules; report infinite losses and every
inventory/abstention count. Acquire no data and make no eligibility or method
change.”
