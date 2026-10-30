# Direct Serve terminal-outcome transfer results

## Prospective specification — recorded before scoring

Baseline: `f90a02a0823654d19f8a2e6d9caff32a228a1e5e`. This executes the
[approved measurement question](annotated-error-measurement-family-decision.md#one-proposed-next-question-direct-serve-terminal-balance)
on unchanged MCP_EXPANDED_RECURRING_1.0.0. No new eligibility, estimator,
threshold, smoothing or sample selection is introduced. The normalized text
above the measured-coverage heading is fingerprinted in the runner before any
comparative scoring; the approved decision and source/QA chain are pinned too.

### Unique point classes and denominator

Each inventory point retains its raw point, match and source-row identifiers,
raw sequences and recorded server. Neutral server-slot identity comes from the
frozen Serve actions and match identities, never from the point winner.
An eligible chart's service point enters N only when the frozen full sequence
is validated, score status is PASS, terminal agrees with the recorded winner,
and exactly one supported nonvoid terminal boundary reconciles to that winner.
Unusable prefixes cannot validate the point. Authority/accounting contradictions
stop the release; existing unvalidated points stay withheld with their reasons.
Completion-excluded charts retain point QA information but contribute zero N.

A unique usable Serve-owned ACE or second-serve DOUBLE_FAULT terminal supplies
that class. Each remaining fully validated point is OTHER. OTHER includes
UNRETURNABLE, Return/Rally endings and a supported administrative challenge,
with original terminal/domain retained. It is not a success label. Outcome-only,
missing, unsupported and conflict observations cannot become OTHER. Lets are
void actions, not extra points; first faults do not independently enter this
three-class partition. Optional explicit unknown attributes remain flagged when
the frozen full sequence and terminal are valid. Terminal penalties without
validated sequences stay withheld. Classes are mutually exclusive and sum to
N for each server-match slot. Zero N leaves rates undefined.

Direct terminal balance is `(ACE - DOUBLE_FAULT) / N`; expected personal/reference
balance is `p_ACE - p_DOUBLE_FAULT`. These are descriptive signed summaries,
not independently scored targets, learned weights or comprehensive Serve quality.
Three-class distribution transfer cannot establish transfer of the balance.

### Frozen estimation, masks and losses

ALL_DATE_EXPANDING uses historical men/women categories, displayed with their
frozen ATP/WTA file labels without certifying early tour membership. Pool class
counts over strictly earlier eligible same-category source-date batches.
Personal pools link the exact server identity; category reference pools include
all prior eligible server slots. Equal-date matches are simultaneous. Histories
and predictions freeze before the whole batch; no elapsed-time adjustment.
Report history depth, prior N, last source-date gaps and sparse support without
inventing adequacy thresholds. First eligible batch is the seed. Failure
precedence is completion exclusion, seed, target N=0, personal prior N=0,
reference prior N=0, supported. Also retain all applicable abstention flags.
Cold starts abstain; no clipping, smoothing, imputation or replacement.

Personal/reference class probabilities are pooled counts / pooled N. Evaluate
only identical supported server-match IDs with target N>0 and both prior N>0.
Preserve all 223 charts, 446 slots and all inventoried points outside this mask.

For each point, multiclass Brier is `sum_c (p_c - I[class=c])^2`, with **no
 division by three or two**; range 0–2. Pool target class counts to reconstruct
point loss sums, then average points within slot, supported slots within match,
and matches equally within category. Secondary natural-log loss is
`-log(p_observed_class)` with the same hierarchy. Secondary opportunity-weighted
losses divide pooled point loss sums by pooled N on the identical mask. Keep
endpoint probabilities: a positive target count at probability zero yields Inf;
a zero target count contributes zero even at p=0. Inf minus Inf is explicitly
indeterminate NA, never zero. No new binary or balance loss is substituted.

Enumerate each eligible nonseed evaluation match and each player appearing in
either slot, including zero-impact deletions. Delete the full match or every
match containing that player from frozen prediction scores; never remove just
that player's slot or rebuild histories. Report both losses, weightings and
direction changes. These influence diagnostics establish no uncertainty interval.

Reference-favored, mixed, nonfinite or composition-sensitive evidence cannot
qualify a factor. Favorable descriptive distribution transfer permits only further
component research. No composite score, practical threshold, causal skill claim,
NPR association, low-collinearity assertion or factor advancement follows.
UNCERTAINTY_NOT_ESTABLISHED remains; source-date availability, internally
consistent rather than official completion, selective QA retention, convenience
sampling, overlapping prior experiments and exposed years including 2026 apply.

## Measured coverage and denominators

**DIRECT_SERVE_DISTRIBUTION_TRANSFER_EXPLORATORY_ONLY.** Personal multiclass
Brier is descriptively lower in both categories and both weighting schemes,
but personal log loss is infinite in both categories and men's primary Brier
reverses under one player deletion. Existing decision rules therefore support
no factor advancement. This is a three-class distribution experiment; transfer
of its signed balance has not been scored or established.

| Accounting | Men (ATP file label) | Women (WTA file label) |
| --- | ---: | ---: |
| Inventoried matches / slots / points | 106 / 212 / 26,318 | 117 / 234 / 16,992 |
| Completion-eligible charts / eligible batches | 104 / 102 | 116 / 110 |
| All source-date batches | 104 | 111 |
| Validated eligible service-point N | 22,910 | 13,637 |
| Eligible-chart withheld points | 2,992 | 3,192 |
| Completion-excluded points | 416 | 163 |
| ACE / DOUBLE_FAULT / OTHER within N | 1,916 / 871 / 20,123 | 737 / 819 / 12,081 |
| All-inventory point retention | 87.05% | 80.26% |
| Paired server-match targets / scored matches | 120 / 89 | 135 / 103 |
| Distinct supported server identities | 38 | 36 |
| Cold-start slot abstentions | 86 | 95 |
| Seed slots / completion-excluded slots | 2 / 4 | 2 / 2 |
| Zero-target / zero-reference priority abstentions | 0 / 0 | 0 / 0 |
| Evaluation matches with both / one / neither slot supported | 31 / 58 / 14 | 32 / 71 / 12 |
| Paired validated service points | 12,973 | 8,074 |

All 223 charts, 446 slots and 43,310 points remain in their ledgers. Exactly
36,547 eligible validated points partition into the three classes; 6,184
eligible-chart points remain withheld and 579 points are completion excluded.
Exclusions are the frozen incomplete Chung/Federer and Gasparyan/Svitolina
charts and Michelsen/Harris terminal-conflict chart, without replacement.
Point QA and raw notation remain available even inside excluded charts; those
points enter neither training nor scoring. Apparent direct terminals in
unvalidated sequences receive no numerator credit.

OTHER retains 387/70 UNRETURNABLE, 5,255/3,463 Return-terminal,
14,478/8,541 Rally-terminal and 3/7 administrative-challenge points, men/women
respectively. Those groups sum to OTHER and do not turn collapsed unreturned
notation into ACE. Administrative challenges create no physical stroke.
Unsupported suffixes, missing observations and authority conflicts remain
explicit in the point issues/dispositions; an observed prefix is not a full
validated point. Explicit unknown shot attributes remain separately visible
when full-sequence terminal authority is validated. No unobserved attempts are
invented, and a first fault or let adds no second service-point denominator.
Eligible-chart point retention spans 23.91%–100% for men and 18.80%–100%
for women. Withheld men's points comprise 444 outcome-only, 2,546 unsupported/
unresolved and two administrative-point observations; women comprise 140
outcome-only and 3,052 unsupported/unresolved observations. All 61/27 included
points with explicit unknown optional attributes remain flagged, men/women.

Supported prior point N is 39–1,195 (median 276) for men and 26–985
(median 154) for women. Usable prior-match depths are 1–9 (median 2.5) and
1–13 (median 3). Last-source-date gaps are 1–3,286 days (median 222.5) and
1–6,996 days (median 238). These are labels and descriptive exposure, not
verified historical availability or time-decay inputs. Targets can have only
one prior usable match; no adequacy threshold is claimed. The mask's 120/135
counts coincide with the earlier first-fault experiment, but were reconstructed
from unique service points independently, never copied from that release.

## Paired distribution losses and endpoint failures

Negative personal-minus-reference differences favor personal descriptively.
Brier retains its three-class sum normalization; its numerical scale cannot
be compared directly with earlier binary-error experiments.

| Loss on identical supported IDs | Men personal | Men reference | Men difference | Women personal | Women reference | Women difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Whole-match multiclass Brier | 0.2307395 | 0.2319255 | −0.001185971 | 0.2353278 | 0.2375270 | −0.002199214 |
| Opportunity-weighted Brier | 0.2252335 | 0.2263415 | −0.001107982 | 0.2116801 | 0.2128131 | −0.001133000 |
| Whole-match natural-log loss | Inf | 0.4668485 | Inf | Inf | 0.4841119 | Inf |
| Opportunity-weighted natural-log loss | Inf | 0.4566359 | Inf | Inf | 0.4423006 | Inf |

Five men's and six women's supported slots have zero personal class probabilities
contradicted by later target points: 26 and 22 point-level failures respectively.
Failures are 14 ACE and 12 DOUBLE_FAULT points for men, 18 ACE and four DOUBLE_FAULT points for women; none involve OTHER. All reference losses are finite, with no endpoint contradiction. Unsmoothed
zero probabilities remain in the exported predictions; no rescue or replacement
is applied. Brier stays finite despite these failures. That finite behavior is
not evidence of comprehensive transferable player information. Inf minus Inf
handling is tested, although it does not arise in these aggregate comparisons.

Each slot exports its ACE/DOUBLE_FAULT components, denominator, observed balance
and earlier expected balances so cancellation remains inspectable. These values
are descriptive; no balance loss, correlation, NPR association, importance
weight or performance ranking is calculated. A better distribution Brier score
could reflect components other than the contrast represented by the balance.

## Frozen-prediction deletion influence

All 401 prespecified evaluation deletions were enumerated, including zero-impact
rows: 190 men and 211 women. Each match deletion drops that whole match; each
player deletion drops every evaluation match containing the identity in either
slot. Predictions and prior reference/personal pools remain frozen.

Men's primary Brier differences range from −0.001817916 to +0.000297407.
The sole sign reversal is deletion of **Nick Kyrgios**, removing 14 paired slots
and yielding +0.000297407. Removing the Cressy/Auger-Aliassime Wimbledon match
or Maxime Cressy yields −0.000512360, illustrating composition influence without
an uncertainty claim. Women's primary differences remain negative across all
211 deletions, ranging from −0.003070456 to −0.001448516. The strongest examples
are removal of the Marino/Vondrousova Australian Open match or Vondrousova
(−0.003070456), and Marino/Snigur US Open (−0.001448516).
The enumerations contain 103/115 match and 87/96 player deletions, men/women.
Both opportunity-weighted Brier directions remain negative under every deletion,
so the men's primary reversal is weighting-sensitive. All 401 log differences
remain Inf. No deletion is used to repair
or select a favorable cohort. Whole-match and opportunity losses are separate
estimands, not interchangeable selection options.

## Implementation, validation and preservation

One base-R runner reuses pinned source/rights and frozen parser/state verification
helpers, then independently builds point dispositions, slot counts, strictly
prior pools, scores and deletions. The normalized prospective specification
SHA-256 is `70117be68f7aa4fb44e2b2ce390f0dad95c8eca6d7d55d83b8d191af620255d8`;
the approved decision SHA-256 is
`79f67353697d70fd5a467428237732ccd9ae60bc2d8838d58d17eaf71a916bef`.
MCP revision remains `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`.
Saved noncommercial research rights, provenance and the unchanged expanded
release were checked through the existing source-verification chain; no request
or acquisition was made.

The seven ignored outputs use the existing flat prefix
`data/pilot/mcp-direct-serve-transfer-v1-`: `point-dispositions.csv`,
`observation-counts.csv`, `target-estimates.csv`, `paired-scores.csv`,
`stability.csv`, `coverage-summary.csv` and `summary.csv`. Counts, terminal
subtypes, abstentions, histories and unknowns remain auditable. Installation
stages all files, checks fingerprints before mutation, refuses differing
releases and renames individual completed files atomically; newly created files
are rolled back on installation errors. It is not a filesystem-wide transaction.

All **11,367 focused checks passed**, including prospective formula/endpoint
fixtures before empirical scoring, full point/class/denominator reconstruction,
recorded terminal and server ownership, strictly earlier pools, cutoffs and
positive controls, category separation, zero-target abstention, common masks,
point-indicator loss reconstruction, all 401 deletions, neutral-slot swaps, row/
event/within-batch permutations, independent byte-identical reruns, atomic
installation preflight, pin failures and ignored-output scope. The focused test
snapshot preserved 617 artifacts; the independent inventory includes two hidden
files and verifies 619 historical artifacts plus all three historical document
tails. All **693 documentation, count, scope and preservation checks passed**,
including local links/anchors, sibling agreement, numerical report checks,
source/specification pins, whitespace and exact six-file tracked scope. All
seven outputs were inspected: 43,310 point rows, 446 count rows, 446 target rows,
two paired-score rows, 401 deletion rows, 223 coverage rows and two summary rows.
No authority/accounting conflict or release correction occurred. No historical
numerical suite is rerun or repinned. Historical releases and document tails
remain under their original rules.

## Limits and one next executable question

Retain this direct Serve distribution only as an exploratory measurement. The
Brier advantage merits a narrow follow-up question, but infinite log losses
and men's player-composition reversal prohibit factor advancement. No supported
cross-category player-skill, comprehensive Serve-quality, causal-responsibility,
low-collinearity or Four Factors conclusion follows. Aces may depend on receiver
and context; direct balance reuses points in NPR's numerator, so a same-match
association would partly be arithmetic coupling. No such relationship is tested.
Return/Rally exposure is selected by earlier Serve endings despite distinct
ledger ownership. Serve +1 remains Rally-owned; movement attribution unresolved.

Source-date chronology, convenience chart selection, selective point retention,
sparse histories, unverified official completion and category membership,
overlapping samples and exposed years including 2026 remain.
UNCERTAINTY_NOT_ESTABLISHED is preserved; no intervals or p-values are created.

Recommend one bounded **direct terminal balance transfer experiment** on the
same frozen 255 supported slot IDs. Its falsifiable target would be the observed
server-match balance `(ACE−DOUBLE_FAULT)/N`, compared with frozen earlier
personal and category-reference `p_ACE−p_DOUBLE_FAULT`. Prespecify squared error
of that balance, average supported slots within match and matches equally,
retain opportunity weighting and frozen-prediction match/both-slot deletions
as sensitivities, and keep all inventory/abstentions. This answers the currently
untested contrast rather than inferring it from distribution Brier; it does not
rescue the three-class log losses. No smoothing search or expansion is proposed.
Approval is required before computing that new loss. Further explanatory,
nonalgebraic incremental and joint-domain evidence would still be needed later.

Exact next approval: “Implement and execute one prespecified direct Serve terminal
balance transfer experiment on unchanged MCP_DIRECT_SERVE_TRANSFER_1.0.0 counts,
histories and its 255 supported slot IDs. Freeze whole-match squared balance-error,
opportunity-weighted and match/both-slot-player deletion rules before scoring.
Preserve personal/reference estimates, eligibility, unknowns, cold starts and
historical releases. Add no smoothing, thresholds, sample expansion or acquisition;
calculate no NPR association, factor weights, ratings or match-winning forecasts.”
