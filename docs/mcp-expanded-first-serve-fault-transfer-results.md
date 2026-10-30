# Expanded MCP first-serve-fault frequency transfer experiment

## Prospective definition and assessment

Recorded before scoring, from clean baseline
`e1d6b2e9344646de9c7ace747c4f513a984f8781`. This user-authorized experiment uses
all 223 MCP_EXPANDED_RECURRING_1.0.0 inventoried matches, unchanged completion exclusions and ALL_DATE_EXPANDING.
The [workflow](action-factor-workflow-transition.md), [execution dictionary](mcp-execution-summary-audit.md#prospective-count-and-denominator-dictionary)
and [inherited transfer assessment](mcp-broader-return-transfer-protocol.md#frozen-assessment-and-dependence)
are the authority. This report freezes the Serve-specific adaptation before losses.

For each neutral server slot, N is frozen-QA-usable Serve-owned, nonvoid physical
`SERVE` or `SERVE_FAULT` actions with recorded serve number 1; E is the subset
with kind `SERVE_FAULT`. Count physical attempts, not service points. Recorded
lets are void and receive neither numerator nor denominator credit, even when
followed by another first serve. `FIRST_SERVE_FORFEIT` is administrative and
receives no physical-attempt/fault credit. Second-serve attempts/faults are
inventoried but are outside this experiment's numerator and denominator.

Known first attempts partition into usable and withheld observations. Withheld
attempts enter neither E nor N and never become successes or faults. Unknown or
unsupported serve number enters explicit separate context rows. Unknown direction
or fault subtype remains explicit but does not erase a usable known first attempt
or its fault label. Missing sequences, outcome-only points and unsupported suffixes
remain missing/unsupported observation rows; their unobserved physical-attempt
counts cannot be inferred. A supported prefix never promotes an unresolved point.

Use existing `tennis_action_usable` unchanged, including full-point parser,
score-authority and local-boundary gates. Require unique action/player ownership
and exact frozen parser/state joins before scoring. Stop on pin, definition,
identity, count or evidence conflicts. No parser changes or speculative repairs.

For each player/category/source-date target batch:

`q_personal = sum(E_prior_player) / sum(N_prior_player)`

`q_reference = sum(E_prior_all_servers) / sum(N_prior_all_servers)`

Only eligible same-category FIRST counts with strictly earlier source dates
enter either pool. Pool counts before division, across all prior surfaces. Freeze
predictions for the complete simultaneous batch. No smoothing, clipping, window,
decay, adjustment or minimum-exposure threshold. Positive denominators permit
an estimate, not a claim of adequacy. Zero prior N abstains; a category reference
never initializes a missing personal history. Preserve all seed matches at the
first eligible date, both slots, completion exclusions and unknown observations.
Serve support is reconstructed independently from physical attempts. Before
scoring, compare every denominator and eligibility disposition with the
[expanded support audit](mcp-expanded-recurring-player-audit.md#compatible-attempt-support-and-retention)
and its pinned opportunity/history ledgers. The expected prior-supported 120/135
slots require a positive usable target denominator separately; stop on any
accounting mismatch. The Return comparison mask is never reused.

Mask precedence: completion exclusion; seed; zero usable target FIRST denominator;
zero personal prior denominator; zero reference denominator; otherwise paired
support. Coverage records all availability and exclusion reasons even when an
earlier disposition controls scoring. Neither E, target rate nor loss selects IDs.
The common personal/reference mask requires valid positive target/prior/reference
N. Outcome-neutral slot identities and cutoffs must match exactly.

Inherited cell Brier is `[E*(1-q)^2+(N-E)*q^2]/N`. Average supported slot losses
within each whole match, then matches equally within category. Secondary
natural-log loss is `-[E*log(q)+(N-E)*log(1-q)]/N`, with explicit zero-times-log-zero
handling. Contradictory q=0 or q=1 yields Inf and stays reported. Secondary
opportunity-weighted losses pool loss sums over attempt totals. Report personal
minus reference: negative favors personal descriptively. Inf minus Inf is
indeterminate; absent comparisons are UNEVALUABLE. No threshold or qualification
rule is created.

Enumerate every eligible nonseed evaluation match and both-slot player identity,
including zero-impact deletions. Delete whole matches containing the player in
either slot and rescore frozen predictions without refitting or deleting history.
Keep every match intact, same-date batches simultaneous and categories separate.
No IID interval, p-value, smoothing sensitivity or match-win forecast. Retain
`UNCERTAINTY_NOT_ESTABLISHED`. Claims concern observed QA-usable physical serve
attempts and internally consistent charts, not official completion or serve skill.

The estimator, eligibility, mask precedence, losses and deletion rules are
unchanged from the [frozen first-serve experiment](mcp-first-serve-fault-transfer-results.md#prospective-definition-and-assessment).
This expanded sample overlaps that release: compare descriptive directions and
composition sensitivity, never pool releases as independent evidence. No
parameter, adequacy threshold, smoothing or interpretation gate is added.

## Measured coverage and denominators

Before scoring, frozen parser/state physical counts independently matched every
expanded Serve opportunity row. FIRST supports 120 men / 135 women slots, each
with positive usable target N. No usable target-denominator or reference failure
was assumed away. Eligible observed/usable/withheld FIRST counts are
25,447/22,910/2,537 men and 16,663/13,637/3,026 women. All three unchanged
completion exclusions and explicit unknown contexts are retained.

A pre-score assertion initially used a different label for supported exposure;
it stopped before scoring or installation. The assertion was corrected to the
frozen label PRIOR_SUPPORT_AVAILABLE. No count, eligibility or estimator changed.

**EXPANDED_FIRST_SERVE_FAULT_TRANSFER_CATEGORY_SPECIFIC_DESCRIPTIVE_ONLY.**
The larger overlapping inventory preserves the category loss directions but
does not qualify this frequency as a transferable Serve factor.

All 223 matches / 446 neutral server slots / 43,310 points remain inventoried.
The same forty selected recurring players and all original 159 charts remain
in MCP_EXPANDED_RECURRING_1.0.0. Men/women refer to historical source categories;
the ATP/WTA output labels do not independently verify early governing-tour
membership. Only internally consistent chart endings establish eligibility;
o official completion claim is added.

| Coverage | Men | Women |
| --- | ---: | ---: |
| Inventory / eligible matches | 106 / 104 | 117 / 116 |
| Inventory / eligible source-date batches | 104 / 102 | 111 / 110 |
| Seed / eligible evaluation matches | 1 / 103 | 1 / 115 |
| Paired server targets / scored matches / serving identities | 120 / 89 / 38 | 135 / 103 / 36 |
| Cold-start / seed / excluded slots | 86 / 2 / 4 | 95 / 2 / 2 |
| Evaluation matches with both / one / neither supported slot | 31 / 58 / 14 | 32 / 71 / 12 |
| Inventoried observed / usable first attempts | 25,862 / 23,321 | 16,826 / 13,678 |
| Eligible observed / usable / withheld first attempts | 25,447 / 22,910 / 2,537 | 16,663 / 13,637 / 3,026 |
| Eligible usable first faults | 8,683 | 5,366 |
| Eligible pooled attempt retention | 90.03% | 81.84% |
| Eligible match-level first-attempt retention range | 23.91%–100% | 18.80%–100% |
| Paired target faults / attempts | 4,881 / 12,973 | 3,145 / 8,074 |
| Inventoried void lets (no attempt credit) | 1,143 | 703 |
| Eligible missing / unsupported observation rows | 444 / 164 | 140 / 261 |
| Eligible usable FIRST attempts with explicit unknown attributes | 24 | 24 |

The 42,688 inventoried observed first attempts differ from 43,310 points. No
service-point substitution occurs. All 1,784 observation rows retain FIRST,
SECOND, UNKNOWN and UNSUPPORTED by slot. Second attempts are inventoried only.
There are zero observed physical Serve attempts with unknown/unsupported serve
number and zero administrative first-serve forfeits; explicit zero context rows
remain. Missing sequences, unresolved suffixes and withheld actions cannot
establish the multiplicity of unseen attempts: NOT_IDENTIFIABLE remains.

The three exclusions remain Chung–Federer 2018 Australian Open (incomplete),
Michelsen–Harris 2024 Wimbledon (terminal conflict), and Gasparyan–Svitolina
2019 Wimbledon (incomplete). Excluded counts contribute neither predictions
nor histories. Zero usable target and zero reference failures happen zero times;
implemented abstention branches remain, rather than assuming such support.

## Exposure and paired losses

| Supported exposure: minimum / median / maximum | Men | Women |
| --- | --- | --- |
| Prior usable FIRST attempts | 39 / 276 / 1,195 | 26 / 154 / 985 |
| Prior usable charts | 1 / 2.5 / 9 | 1 / 3 / 13 |
| Target usable FIRST attempts | 25 / 102.5 / 224 | 16 / 56 / 113 |
| Latest-prior nominal source-date gap, days | 1 / 222.5 / 3,286 | 1 / 238 / 6,996 |

Thirty-eight men’s and thirty-six women’s supported targets still have only one
prior usable chart. No history window or elapsed-time adjustment is applied.
Gaps are source-date labels, not verified information availability or inactivity.

Whole-match losses average supported server-slot losses within each match, then
weight matches equally. Personal minus reference is negative when personal
estimates have lower descriptive loss. Categories and comparison IDs remain
separate; no composite or practical-effect threshold exists.

| Category | Personal Brier | Reference Brier | Difference | Personal log | Reference log | Difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 0.231685306 | 0.232701738 | -0.001016432 | 0.656205018 | 0.658238426 | -0.002033408 |
| WTA | 0.239075104 | 0.238193058 | +0.000882046 | 0.671922918 | 0.669373127 | +0.002549791 |

| Category | Personal opportunity Brier | Reference opportunity Brier | Difference | Personal opportunity log | Reference opportunity log | Difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 0.234479106 | 0.235071426 | -0.000592320 | 0.661930958 | 0.663040394 | -0.001109437 |
| WTA | 0.238695197 | 0.237922890 | +0.000772307 | 0.670748547 | 0.668815638 | +0.001932909 |

There are no scored q=0/q=1 estimates, endpoint failures, personal/reference
infinite losses or indeterminate comparisons in either category. No clipping or
smoothing was needed. Personal probabilities range 0.179487–0.509972 men and
0.133333–0.571429 women; reference ranges 0.278008–0.418423 and
0.316832–0.394083. Inf contradictions and Inf-minus-Inf remain explicit, tested
behaviors. Finite loss is numerical stability, not transferable information.

## Complete frozen-prediction deletion assessment

All 401 deletions retain the category direction for both whole-match losses,
without refitting or deleting historical contributions. Every eligible nonseed
match and both-slot identity is included, even when its removal has zero impact.

| Category / deletion | Rows / zero impact | Brier difference range | Log difference range | Direction reversals, Brier / log |
| --- | --- | --- | --- | --- |
| ATP / MATCH | 103 / 14 | -0.001323937 to -0.000638506 | -0.002653041 to -0.001156779 | 0 / 0 |
| ATP / PLAYER | 87 / 10 | -0.001379071 to -0.000170700 | -0.002757724 to -0.000151462 | 0 / 0 |
| WTA / MATCH | 115 / 12 | +0.000194348 to +0.001131983 | +0.000431316 to +0.003070594 | 0 / 0 |
| WTA / PLAYER | 96 / 8 | +0.000194348 to +0.001345038 | +0.000431316 to +0.003581383 | 0 / 0 |

The largest absolute Brier deletion changes are fully disclosed. Removing
Marco Cecchinato’s six men’s evaluation matches (seven paired slots) changes
Brier from −0.001016432 to −0.000170700 and log from −0.002033408 to
−0.000151462. The Brier advantage attenuates about 83%; the original experiment’s
Cecchinato deletion reversed its direction. Removing Fabrice Santoro’s six
matches/seven slots instead gives Brier −0.001379071. For women, removing
Lucija Ciric Bagaric’s sole match/slot gives +0.000194348 Brier and +0.000431316
log, while removing Qinwen Zheng’s eleven matches/twelve slots gives
+0.001345038 / +0.003581383. No deletion is unevaluable, tied or nonfinite.
Complete rows, including zero-impact cases, are retained in stability.csv.

## Comparison with the preserved original experiment

| Category | Original → expanded whole-match Brier difference | Original → expanded log difference |
| --- | --- | --- |
| ATP | −0.001047596 → −0.001016432 | −0.002175437 → −0.002033408 |
| WTA | +0.001199414 → +0.000882046 | +0.003552941 → +0.002549791 |

The category difference persists in both weighting schemes. Men’s prior
player-deletion reversal does not recur, but strong composition sensitivity
remains. Women continue to favor the category reference under every deletion.
The new release contains all original charts, deeper histories for some original
targets, new targets and changed category-reference pools. It is an overlapping
exploratory experiment, not independent replication. Do not combine its losses
with the original as separate evidence or attribute the change uniquely to
greater history depth. No selected player was replaced.

## Verification and release record

The runner reuses frozen physical counting, pooled estimators, loss and deletion
helpers; only the inventory validator is adapted to 223 charts. Parser/state
rules are not rerun or altered. Existing verification rechecks source rights,
provenance and MCP revision 1813a1309b7ed7ebf1c7e884b32bf675d00e4edf, all nineteen
expanded outputs and the six original Serve outputs before use/installation.
The prospective specification SHA-256 is
1061aaa69a291619e5ccbf2df7c2cf8591415d7c760fedc77aecdcc7894b695b.
Saved CC BY-NC-SA 4.0 research-use authority is unchanged; no acquisition or
redistribution permission is added.

Six ignored flat outputs use mcp-expanded-first-serve-fault-transfer-v1-:

| Output | Rows | SHA-256 |
| --- | ---: | --- |
| observation-counts.csv | 1784 | `851731a26f355f9b64423f14ffbbb7f32f545f17403dbf4065a7aa953c5f37cc` |
| target-estimates.csv | 446 | `5a33dfcbe71705328a38ea1df919ad7d8f5e14b46356b77c5d3b38a975f412b7` |
| paired-scores.csv | 2 | `74e52553edc225b2d48d3587200de2b0e41b78e93ee9359772153f270bdd5fe5` |
| stability.csv | 401 | `56e1a868b913be9cac617c9401e4431753ad019a738056826c6d8f28e763e0e3` |
| coverage-summary.csv | 223 | `39f79c6bd735627e5fb8431562d6cb2513d80c7f5cdc7d4e8ba87800fb7deeb8` |
| summary.csv | 2 | `723534bf8cee63d02842d81c73c093fb7b7f9fbf1df0a781ff9c35ffa123abc3` |

All **12,631 focused checks** passed: independent action-kind denominators and
faults, exact personal/reference prior pools, cutoff/count perturbations,
simultaneous batches, category separation, failure precedence, unknown/let/admin
fixtures, direct losses and explicit Inf handling, every deletion, neutral slot
swaps, authority/pin failures, independent byte-identical reruns, exact output
scope and atomic mismatch refusal. The tests preserved 590 historical artifacts;
an independent baseline comparison additionally verifies all **592** saved
historical files, including hidden files, and the three historical document tails.
All **82 documentation/accounting checks** passed, covering cited losses,
counts, dispositions, endpoint/deletion findings, local links/anchors, source and
output pins, cross-document agreement, whitespace and exact six-file scope.
Every generated summary was inspected. No historical suite was rerun.

## Decision and one next executable step

Keep first-serve-fault frequency **descriptive/exploratory only**. The men’s
category supports a small retrospective transfer difference robust to individual
deletions; women’s category does not favor personal transfer. Strong influence,
selective chart/QA retention, exact-name identities, sparse histories and era
gaps prevent general player-skill or factor qualification. No automatic sample
expansion, parameter search or smoothing experiment is recommended. These
findings neither invalidate Serve as a domain nor validate independent factors.
Official completion, actual historical availability and population coverage
remain unverified. All acquired years including 2026 are exposed, and
UNCERTAINTY_NOT_ESTABLISHED remains; no untouched test, interval or superiority
claim follows. Historical releases and the portfolio remain unchanged.

Recommend one bounded **Serve +1 annotated-error transfer specification** using
the frozen expanded action/state and opportunity ledgers. Define attempts,
supported error labels, known absences, unknowns and pre-action FIRST/SECOND
serve context; +1 remains a Rally subset with no extra domain credit. Preserve
completion/QA rules and measure exact context-specific support before selecting
a retrospective evaluation design. This tests a distinct observable Rally
component rather than prolonging the first-fault candidate; annotation still
cannot establish causal responsibility or stroke quality. No specification or
new metric is implemented here.

Exact next approval: “Draft one bounded Serve +1 annotated-error frequency
transfer protocol on MCP_EXPANDED_RECURRING_1.0.0, defining physical attempts,
supported error categories, pre-action first/second-serve contexts, known
absences and unknowns; preserve Rally ownership and frozen completion/QA rules.
Measure context-specific support and propose one whole-match retrospective
evaluation design for approval. Acquire, fit and score nothing; add no
threshold, adjustment, smoothing, factor claim or sample expansion.”
