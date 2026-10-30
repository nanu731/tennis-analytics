# MCP first-serve-fault frequency transfer experiment

## Prospective definition and assessment

Recorded before scoring, from clean baseline
`8abb5e2938df05357b0ef723b9734f7a3df37cc2`. This user-authorized experiment uses
all 159 inventoried matches, unchanged completion exclusions and ALL_DATE_EXPANDING.
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
Serve support is measured independently; the 312 Return IDs are not reused.

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

## Measured coverage and denominators

**FIRST_SERVE_FAULT_TRANSFER_MIXED_PLAYER_SENSITIVE_EXPLORATORY_ONLY.**
This is a completed measurement-transfer experiment, not a validated Serve factor.
The pinned MCP revision remains `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf` under
the saved CC BY-NC-SA 4.0 research-use basis. Existing verification checks the
source/provenance, parser/state, execution-definition and completion-release
pins before loading counts. No source was acquired or license assumption added.
The prospective definition section is separately SHA-256 pinned:
`89633738adef6154286f81fd80c55604bcb5f649c560d3be524855c0c0a691dd`.

All 159 matches, 318 neutral player slots and 31,218 points remain inventoried.
Historical men/women categories do not certify ATP/WTA membership for early
charts. The same two incomplete charts and one terminal-conflict chart stay
excluded from targets and both histories. Internal chart completion remains the
conditional basis; official completion and information availability are unverified.

| Accounting | Men | Women |
|---|---:|---:|
| Inventory / eligible matches | 75 / 73 | 84 / 83 |
| Seed / eligible evaluation matches | 1 / 72 | 1 / 82 |
| Inventoried observed / usable first attempts | 18,626 / 16,574 | 12,090 / 9,517 |
| Eligible observed / usable first attempts | 18,211 / 16,163 | 11,927 / 9,476 |
| Eligible withheld first attempts | 2,048 | 2,451 |
| Eligible usable first faults | 6,136 | 3,754 |
| Eligible first-attempt retention | 88.75% | 79.45% |
| Inventoried second observed / usable attempts, not scored | 7,022 / 6,279 | 4,707 / 3,765 |
| Inventoried void lets, not attempts | 793 | 516 |
| Administrative first-serve forfeits | 0 | 0 |
| Eligible missing / unsupported observation rows | 370 / 123 | 107 / 246 |
| Eligible known-first usable attempts with explicit unknown attributes | 18 | 19 |

Across both categories, the 30,716 observed first attempts differ from the
31,218 service points; no point count substitutes for physical attempts.
Missing/suffix observation rows do not reveal the number of absent physical
attempts. That count is explicitly `NOT_IDENTIFIABLE`. All missing/unsupported
rows and unresolved ownership remain reported, without hypothetical attribution.
The four-context observation inventory keeps FIRST, SECOND, UNKNOWN and
UNSUPPORTED rows for both slots. No observed physical attempt has an unknown or
unsupported serve number in this release; those zero-count rows remain explicit.
First-attempt retention across eligible matches ranges 23.91%–100% men and
18.80%–100% women. Selective retention is substantial despite aggregate coverage.

## Support and unsmoothed losses

The Serve-specific mask contains **156 supported player-match FIRST targets**:
69 men / 87 women, across 58/70 matches and 30/31 serving identities. It was
reconstructed from physical Serve counts, not copied from Return. The 318 FIRST
slot rows partition into 156 supported, 152 cold starts (75/77), four seed (two
each) and six completion-excluded (four/two). No actual zero-target or zero-reference
denominator failure occurs; those abstention branches remain implemented.

Supported prior attempts span 39–557 men / 26–481 women and usable prior matches
1–4 / 1–7. Latest-prior source-date gaps span 1–3,789 / 1–8,088 days. Supported
target denominators span 25–224 / 16–108; pooled target faults/attempts are
2,817/7,454 and 1,952/4,957. Sparse recurrence and long gaps remain relevant even
when serve-attempt denominators exceed the corresponding Return denominators.

| Category | Personal whole-match Brier | Reference Brier | Personal − reference | Personal log loss | Reference log loss | Difference |
|---|---:|---:|---:|---:|---:|---:|
| Men | 0.231716482 | 0.232764077 | −0.001047596 | 0.656221113 | 0.658396550 | −0.002175437 |
| Women | 0.240595585 | 0.239396171 | +0.001199414 | 0.675383593 | 0.671830651 | +0.003552941 |

| Category | Personal opportunity-weighted Brier | Reference Brier | Difference | Personal opportunity-weighted log | Reference log | Difference |
|---|---:|---:|---:|---:|---:|---:|
| Men | 0.235070016 | 0.235484763 | −0.000414747 | 0.663193335 | 0.663912823 | −0.000719488 |
| Women | 0.240150547 | 0.238885622 | +0.001264925 | 0.673927908 | 0.670782567 | +0.003145341 |

All scored probabilities and losses are finite without smoothing or clipping.
Personal probability ranges are 0.179487–0.509972 men and 0.133333–0.571429 women;
reference ranges are 0.278008–0.421708 and 0.316832–0.395289. There are no scored
q=0 or q=1 estimates and no personal/reference infinite-loss cases. Endpoint
contradictions and Inf-minus-Inf handling are nevertheless explicitly tested.
Finite numerical behavior is separate from evidence of transferable information.

## Frozen-prediction deletion influence

All 308 deletions are present, including zero-impact deletions: men 72 match /
76 both-slot-player; women 82/78. Zero-impact counts are 14/10 and 12/8.
No deletion refits or removes prior history; none is unevaluable.

| Category / deletion | Brier difference range | Log difference range | Brier / log direction reversals |
|---|---:|---:|---:|
| Men / match | −0.001520–−0.000482 | −0.003129–−0.000882 | 0 / 0 |
| Men / player | −0.001655–+0.000524 | −0.003463–+0.001392 | 1 / 1 |
| Women / match | +0.000187–+0.001554 | +0.000434–+0.004297 | 0 / 0 |
| Women / player | +0.000187–+0.002030 | +0.000434–+0.005347 | 0 / 0 |

Deleting all five evaluation matches involving Marco Cecchinato removes five
paired cells and reverses the men's advantages: Brier +0.000524, log +0.001392.
Deleting his 2018 Roland-Garros semifinal alone leaves Brier −0.000482.
The strongest women's lowering deletion is the Stearns–Ciric Bagaric 2024
Roland-Garros match (also the single evaluation match for Ciric Bagaric):
Brier remains +0.000187 and log +0.000434. The women's reference-favored direction
survives every deletion, while the men's direction depends on recurring-player
composition. No practical-effect threshold or uncertainty interval exists.

## Validation and versioned release

One new base-R runner reuses verified source helpers and frozen loss/deletion
functions. A small Serve-specific estimator avoids importing Return error labels
or its mask. Technical `errors` fields mean first faults on FIRST rows and serve
faults on SECOND coverage rows; they do not assert forced/unforced attribution.
The first-fault field is undefined outside FIRST. No historical helper is modified.

Six ignored files use the existing flat `data/pilot/mcp-first-serve-fault-transfer-v1-`
prefix. Every file carries measurement, revision, ALL_DATE_EXPANDING, conditional
chart-completion, source-label chronology, exposed-year and uncertainty labels.
Coverage rows retain each match, void/admin events and unobservable-attempt flags.
Installation stages all outputs, verifies pins and preflights destinations before
per-file atomic renames, refusing differing releases. It is not a crash-safe
multi-file transaction.

| Output stem | Rows | SHA-256 |
|---|---:|---|
| observation-counts | 1,272 | `a59622e2bbbc87206e29db74d8d3833b8d2dd0b9ec6a0e40431e1fe39c999a45` |
| target-estimates | 318 | `87e31fa13bfa248a28657f50b2efd12f494f6bc1a662c4d8a67b1cbbfbb0c6cf` |
| paired-scores | 2 | `79678e136b046fbaf07c441b99acfbf636ade48f3b8e3195ee445c5c08edb886` |
| stability | 308 | `0991a3e734aab0ffe82047903b32d6d58779a93f55d4ca41b5eee739747553d7` |
| coverage-summary | 159 | `ffd825d536fff14a05a7cff2e8cc58aab2b9ec5f1dfab8d593a7be62b71b85bc` |
| summary | 2 | `02315119e2d488cb9cbb0d57864522b4e68e0a571572b2abfd43303cd6652af7` |

9,298 focused checks passed. Independent parser-action reconstruction verified
every numerator/denominator, lets/admin/missing handling and neutral ownership.
Tests cover earlier-only pools, positive-denominator abstention, first-fault
notation with explicit unknowns, whole-match/opportunity losses, endpoint fixtures,
all deletions, current/later numerator and opportunity perturbations, an earlier
fault positive control, category separation, input-conflict failures, permutations,
six byte-identical independent reruns and immutable atomic-install preflight.
All 559 historical artifacts remain unchanged. All 92 documentation/accounting/
pin/scope checks passed: reported losses/counts, local links/anchors, current
document agreement, whitespace, six-file tracked/ignored scope and preservation
of three historical document tails. Only affected checks ran.
The additional coverage-order normalization changed no output bytes or method.

## Decision, limitations and one next executable step

**Retain first-serve-fault frequency as an exploratory measurement only.**
Men show a small descriptive personal advantage on both weighting schemes,
but it reverses under one player deletion; women consistently favor the
reference. This is mixed, composition-sensitive transfer evidence, not a stable
cross-category player signal. The absence of endpoint failures does not qualify
a factor. Do not tune or run another smoothing experiment. These findings do
not establish that serve skill is absent or that the Serve domain is invalid.

Claims are conditional on QA-usable, chart-observed attempts and internally
consistent endings. Convenience selection, selective retention, exact-name
identity linkage, sparse prior matches and era gaps constrain interpretation.
No official completion, verified historical availability, untouched test,
population representativeness, causal skill, independent factor, weight or
match-winning claim follows. All acquired years including 2026 remain exposed;
`UNCERTAINTY_NOT_ESTABLISHED` remains. The Return releases and conclusions are
unchanged; no combined domain score or factor assessment was performed.

Recommend one bounded outcome-neutral recurrence expansion before further
qualification: keep the same frozen selected recurring players, extend each
from its earliest five to earliest ten linked source-date matches including ties
(or all available if fewer),
and deduplicate into a separate sample. Ten is a fixed inventory cap, not an
adequacy threshold or optimized history window. Use only already pinned sources,
unchanged context and completion/QA rules, retain excluded/unknown observations
and replace no player. This addresses the measured 1–4/1–7 usable-history depth
and permits measuring whether more repeated exposure is attainable; it does not
promise that coverage resolves selective charting or transfer instability.
The Serve and Return measurements remain exploratory, and old samples stay frozen.

Exact next approval: “Build and audit a separate expanded recurring-player MCP
sample from already pinned sources, using the same frozen selected players and
their earliest ten linked source-date matches including boundary ties, or all
available if fewer. Preserve
selection identities, context eligibility, completion exclusions, parser/state
rules and unknowns; deduplicate matches and retain both players. Measure prior
Serve/Return attempt support, recurrence, retention and source-date gaps without
scoring or replacing players. Acquire nothing, change no method, preserve existing
releases, and make no factor or skill qualification.”
