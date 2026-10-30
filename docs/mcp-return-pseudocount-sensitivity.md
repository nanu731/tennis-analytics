# Broader Return-transfer fixed pseudocount sensitivity

## Prospective convention

Recorded before computing sensitivity results, from clean baseline
`14383ea47a951ce2fa98de30ab1d1421738090a1`:

`q_personal = (E_prior + 0.5) / (N_prior + 1)` for `N_prior > 0`.

This is one user-authorized fixed convention, not an optimized parameter.
`N_prior = 0` remains undefined and abstains. Neither eligibility nor the
312 supported context IDs changes. The category/context reference stays
unsmoothed and unchanged. The [primary results](mcp-broader-return-transfer-results.md)
and [frozen protocol](mcp-broader-return-transfer-protocol.md) remain authoritative
and byte-for-byte preserved. This release is a sensitivity, not a replacement.

Compare sensitivity minus unchanged reference and sensitivity minus primary
personal estimates on identical masks, using existing whole-match Brier,
opportunity-weighted Brier, natural-log loss and frozen-prediction match and
both-slot-player deletions. No tuning, rescue, smoothing search or new model.

## Frozen coverage and comparisons

All 159 matches, 318 neutral slots and 31,218 points remain in the inventory.
Men/women are historical source categories, not verified ATP/WTA membership.
The same three charts remain completion-excluded from targets and both pools;
73/83 matches are eligible, with one seed each and 72/82 evaluation matches.
There are 69 FIRST and 69 SECOND supported men targets, and 87/87 women targets,
covering 58/70 matches and 30/31 receiver identities. The 636 recorded-context
rows still partition into 312 supported, 304 cold starts, 8 seed and 12 excluded
rows. All 636 UNKNOWN/UNSUPPORTED rows remain inventoried. No withheld action
becomes a success, error or known absence.

No support, reference prediction, count, date, disposition or comparison ID
changes. Eligible Return retention remains 87.24% men / 77.23% women. Paired
prior attempts span 7–275 / 4–276, prior matches 1–4 / 1–7, and latest-prior
source-date gaps 1–3,789 / 1–8,088 days. These limitations survive smoothing.

Each supported receiver/context cell uses its target error/attempt counts.
Primary loss averages those cells within a whole match, then matches equally.
Secondary loss weights observed usable attempts. Categories and FIRST/SECOND
contexts stay separate. Negative differences favor the sensitivity. No match's
points are split across training and evaluation; only earlier same-category,
same-context eligible matches enter pools. The second comparison replaces the
scoring comparator with the frozen primary personal prediction; it does not
alter the saved reference or invent a new benchmark.

## Measured loss changes

Whole-match losses, with unchanged reference values from the primary release:

| Category/context | Sensitivity Brier | Reference Brier | Sensitivity − reference | Sensitivity − primary personal |
|---|---:|---:|---:|---:|
| Men FIRST | 0.238313257 | 0.210300377 | +0.028012880 | −0.001207668 |
| Men SECOND | 0.175790972 | 0.158782097 | +0.017008874 | −0.000970172 |
| Women FIRST | 0.233414476 | 0.226527123 | +0.006887352 | −0.001454001 |
| Women SECOND | 0.202230198 | 0.204584293 | −0.002354095 | −0.002838307 |

| Category/context | Sensitivity natural-log loss | Reference | Sensitivity − reference | Sensitivity − primary personal |
|---|---:|---:|---:|---:|
| Men FIRST | 0.677313455 | 0.612290072 | +0.065023383 | −0.003961084 |
| Men SECOND | 0.537270595 | 0.500021304 | +0.037249291 | −0.003976384 |
| Women FIRST | 0.663223918 | 0.647884054 | +0.015339863 | −0.004686521 |
| Women SECOND | 0.601807544 | 0.604369529 | −0.002561985 | −Inf |

The last −Inf is finite sensitivity loss minus preserved infinite primary loss;
it is not an estimated finite effect size. Endpoint failures disappear, but
only women SECOND changes its whole-match personal-minus-reference direction.
There is no practical-effect threshold or uncertainty interval.

Secondary opportunity-weighted differences:

| Category/context | Brier: sensitivity − reference | Brier: sensitivity − primary | Log: sensitivity − reference | Log: sensitivity − primary |
|---|---:|---:|---:|---:|
| Men FIRST | +0.019486930 | −0.000634938 | +0.045384256 | −0.002242685 |
| Men SECOND | +0.019656397 | −0.000472641 | +0.046094352 | −0.002326230 |
| Women FIRST | +0.011077972 | −0.001017664 | +0.024480514 | −0.003707609 |
| Women SECOND | +0.008286278 | −0.001476480 | +0.022249956 | −Inf |

Thus all four opportunity-weighted comparisons still favor the reference.
The women SECOND reversal between weighting schemes is reported, not resolved
by changing the primary metric or selecting one presentation.

## Endpoint cases and deletion instability

The three primary zero estimates all concern women SECOND with zero prior
errors. Venus Williams (2000-07-08, N=10) becomes q=0.045455; Rebecca Marino
(2021-02-10, N=4), q=0.100000; Mirra Andreeva (2026-05-24, N=12), q=0.038462.
Their target errors/attempts remain 4/26, 2/4 and 3/18. Sensitivity log losses
are 0.514908, 1.203973 and 0.575700; all three primary infinite losses remain
in the immutable primary release and copied primary-value columns.
All 312 sensitivity personal probabilities are strictly interior: ranges
0.040541–0.852273 men / 0.038462–0.833333 women. No cold start receives q=0.5.
Reference endpoint failures remain zero.

All 616 original match/both-slot-player deletion IDs recur for each comparison
(1,232 rows). These are frozen-prediction score deletions, not refits or removal
of a player's prior contributions. Every eligible nonseed match and either-slot
identity is enumerated, including zero-impact deletions. No deletion is
unevaluable. Whole-match sensitivity-minus-reference ranges:

| Category/context | Match Brier range | Player Brier range | Brier reversals, match/player | Log reversals, match/player |
|---|---:|---:|---:|---:|
| Men FIRST | +0.019198–+0.029841 | +0.019198–+0.033747 | 0/0 | 0/0 |
| Men SECOND | +0.008795–+0.019251 | +0.008795–+0.020366 | 0/0 | 0/0 |
| Women FIRST | +0.001509–+0.012273 | +0.000805–+0.012273 | 0/0 | 0/0 |
| Women SECOND | −0.006119–+0.001595 | −0.006645–+0.002771 | 3/5 | 10/13 |

Women SECOND log differences range −0.010527 to +0.006677 under match deletion
and −0.011624 to +0.011135 under player deletion. Deleting the
Stearns–Alexandrova 2022 US Open match changes its Brier difference to +0.001595;
deleting all five evaluation matches containing Jil Teichmann changes it to
+0.002771, with log difference +0.011135. Women FIRST stays reference-favored
but deleting Jule Niemeier's four evaluation matches leaves just +0.000805
Brier and +0.001152 log differences.

Against the primary personal estimates, sensitivity Brier and log loss remain
lower in all four groups under every deletion. Women SECOND finite-minus-Inf
remains −Inf throughout. This demonstrates a numerical improvement over this
unsmoothed estimator, not a reliable advantage over the category/context pool.

## Reproducibility and preservation

The runner loads pinned primary count/prediction files, verifies their source
and eligibility chain with existing helpers, changes only the authorized
personal estimate, and reuses frozen loss/deletion functions. No parser,
completion, sampling or primary runner changes. No acquisition or dependency.
Existing per-file atomic staging checks every destination before installation
and refuses differing files; it is not a crash-safe multi-file transaction.

Five ignored outputs use the existing flat `data/pilot/mcp-return-pseudocount-v1-`
prefix. Each carries the sensitivity convention, source revision, exposed-year,
source-label chronology and uncertainty labels. Primary personal probabilities
and losses remain separate columns; both comparison labels are explicit.

| Output stem | Rows | SHA-256 |
|---|---:|---|
| observation-counts | 1,272 | `69b5275cd7abfdffc9db831c6294f5c62061d180a9ee83cda694a24345f59698` |
| target-estimates | 636 | `504b6b4ba58ee69a861329193b22cb5413c55980a889802cc9f6a2709a466791` |
| paired-scores | 8 | `8661a2c74a9dee1de6cdc89a5c96382ae7091a780ea95c3f8540e8e6201ef4d8` |
| stability | 1,232 | `1e085ad4cd30156fbb0711d4416bfccbe2dd91bae42d2e6e64af4474fd555c42` |
| summary | 2 | `87238ff492b6af29ff8773f07fd9fe3cc475363dcc48032b240031e288f48882` |

24,629 focused checks passed: independent pooled-count/formula and Bernoulli
loss reconstruction, cold starts, frozen reference/masks, simultaneous and
later-count perturbations, earlier-count positive controls, all deletions,
byte-identical independent reruns, ignored scope and immutable installation.
All 551 pre-task historical artifacts and source pins remain unchanged.
All 88 documentation/accounting/pin/scope checks passed, including loss-table
reconstruction, local links, current-document agreement, whitespace, exact
six-file tracked/five-file ignored scope and three unchanged historical tails.
During validation, two test-only assertions were corrected: absolute rather
than relative floating-point tolerance for tiny deletion changes, and comparing
permutations before release metadata is attached. No estimate or scientific
rule changed. Only affected checks ran; historical suites were not rerun.

## Conclusion and one next executable step

**RETAIN_EXPLORATORY_MEASUREMENT_ONLY.** The fixed convention fixes the
observed endpoint loss failures and modestly improves this personal estimator.
It does not supply stable incremental player information over the reference:
three groups remain reference-favored, the fourth reverses under deletions,
and every opportunity-weighted comparison favors the reference. Keep
FIRST/SECOND as context-specific observed Return measurements; do not advance
this pooled-frequency candidate as an independent or validated factor.
Do not search additional pseudocounts. This finding does not invalidate Return
as a domain or establish that players have no persistent Return skill.

Claims remain conditional on chart-observed, QA-usable actions and internally
consistent chart completion. Selective retention, sparse histories, long era
gaps, convenience selection and unverified historical availability/official
completion limit transfer interpretation. All acquired years including 2026
are exposed; `UNCERTAINTY_NOT_ESTABLISHED` remains. No population, causal skill,
untouched-test, factor-weight or match-winning claim follows.

Recommend one next experiment in the Serve domain, where a recorded first-serve
fault is an observed serve-attempt outcome: test first-serve-fault frequency
transfer from the same frozen ledgers. This is a proposed measurement, not a
validated factor; its attempt/error dictionary must be frozen and checked
against parser support before scoring. It changes the measurement hypothesis
rather than tuning this Return estimate. The purpose is to test another
owned error component for the eventual framework while leaving Return
exploratory. No new sample or evaluation period is proposed.

Exact next approval: “Execute one prespecified first-serve-fault frequency
transfer experiment on the frozen 159-match inventory. Freeze and verify
attempt/error denominators before scoring; retain current completion exclusions,
ALL_DATE_EXPANDING and strictly earlier same-category batches. Compare personal
pools with an identical-mask category reference and report coverage, endpoint
failures and match/both-slot-player deletion sensitivity. Acquire nothing,
tune nothing, and estimate no factor weights or match-winning forecasts.”
