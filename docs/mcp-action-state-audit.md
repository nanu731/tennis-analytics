# Observable MCP action states and Serve +1 audit

## Prospective schema and information boundary

Defined before builder implementation, from baseline
`142e7758714b6b301b313c37925c3fa005ffa16c`, for frozen parser
`MCP_STAGE2_1.1.0`. This is an observable accounting schema, not an action-value
model, factor definition or analytical admission. No outcome is used to select
the 44-match sample.

One transition row preserves every parser action/event/unsupported suffix.
Match ID, point ID, action ID/index, owner domain, raw spans and source rows are
provenance/audit fields. They are not approved predictor features. The canonical
perspective is the point's source-reported server; actor ownership is expressed
as SERVER or RECEIVER, independently of the winner and neutral name ordering.
An administrative actor is not a tennis-stroke owner.

The explicit `pre_` predictor allowlist contains pending boundary, expected next
tennis actor, expected serve number, prior in-play stroke count, and incoming
previous stroke type/direction/return depth with their recorded missingness
statuses. A first fault permits a second serve, a let repeats the same serve,
and an in-play serve permits a return. The previous action ID records exact
provenance; no current token, terminal outcome, Notes, later action or whole-point
quality flag enters these predictors. These are chart-sequence boundaries, not
verified physical timestamps or historical data availability.

`post_` observations record the current kind/actor, recorded serve number, stroke
type, direction, return depth, error and terminal status; the resulting boundary
and server-relative terminal winner are recorded only after that action. A
terminal state is absorbing. Lets are void, first-serve forfeits are administrative,
and incorrect challenges terminate play without creating a stroke. A terminal
return/challenge can establish known absence of +1, never an attempted error.

Point-level parser validation is a retrospective QA gate, outside the predictor
allowlist. Usable transitions require a fully validated point, passing score
reconciliation and supported local boundaries. All transitions from unresolved,
authority-conflicted or outcome-only points are withheld, even if a prefix was
decoded. Unknown optional fields remain explicitly unknown/missing; they do not
become zero or fabricated depth/direction. Withheld decoded prefixes are audit
observations only. Changing a later failure may change retrospective usability,
but must never change an earlier pre-action predictor.

Outputs use four existing flat ignored locations under
`data/pilot/mcp-action-states-v1-`: `action-states.csv`, `serve-plus1.csv`,
`coverage-summary.csv`, `field-provenance.csv`. The field-provenance ledger
classifies every column as pre-action, post-action, identity/provenance or
retrospective QA/coverage. No new directory structure is introduced.

## Measured release

Terminal result: **OBSERVABLE_MCP_STATES_AUDITED_SIMPLER_METRICS_RECOMMENDED**.
The [builder](../R/build_mcp_action_states.R) rechecks the original rights/source
verification helpers, the eleven raw input pins, documentation pins, frozen
sample and all six parser-release fingerprints before reading the ledgers. It
executes no historical runner or parser rebuild. Only the 44 frozen matches are
used; source IDs, raw notation, Notes and spans remain literal.

| Coverage | ALL | ATP-file | WTA-file |
| --- | ---: | ---: | ---: |
| Points retained in inventory | 7,333 | 4,092 | 3,241 |
| Points with usable transitions | 6,237 | 3,560 | 2,677 |
| Point retention | 85.05% | 87.00% | 82.60% |
| Transition rows, including void/admin/unsupported | 38,593 | 20,893 | 17,700 |
| Usable observable transitions | 31,136 | 17,415 | 13,721 |
| Transition retention | 80.68% | 83.35% | 77.52% |
| Usable nonvoid tennis actions | 30,886 | 17,273 | 13,613 |

Every validated point has supported boundaries throughout. All 7,457 withheld
rows belong to the 1,096 nonvalidated points: 1,015 unresolved/authority-conflicted
and 81 outcome-only points. A usable transition may have unknown optional
attributes; usability certifies an observable boundary, not a complete feature
vector or future model eligibility. Local consistency alone never overrides the
whole-point gate. One existing inconsistent sequence has a row after a terminal;
it is explicitly absorbing and unusable. Missing/unsupported rows and subsequent
uncertain boundaries remain present.

Usable transitions comprise 8,802 Serve-owned rows, 5,483 Return-owned rows,
16,845 Rally-owned rows and six administrative rows. Serve includes 244 void lets;
therefore nonvoid Serve actions number 8,558 (5,950 in-play serves and 2,608 faults).
The administrative rows are four first-serve forfeits and two incorrect challenges;
none receive tennis-action credit. All 38,593 original action IDs remain unique.
A first fault changes only the next serve opportunity; a let changes no tennis
state; no match-winning or player-performance predictor is added.

Direction is recorded on 8,550/8,558 usable Serve actions, 5,370/5,483 Return
actions and 16,685/16,845 Rally actions. Return depth is recorded on 4,091/5,483
usable Return actions. Nonrecorded depth on a terminal error is not automatically
an unobserved successful return or a zero-depth ball. Seven usable current strokes
have explicit unknown type; five usable pre states have unknown incoming type.
Twenty usable pre states have nonrecorded/unknown incoming direction. The state
schema omits spatial/quality variables entirely rather than fabricating them.

## Serve +1 independent reconciliation

The opportunity ledger derives attempts from action kind, Rally ownership,
server identity and in-play ordinal three, not from rallyCount or a point-level
+1 flag. Terminal/error handling then reconciles against the frozen point ledger.

| Mutually exclusive disposition | ALL | ATP | WTA |
| --- | ---: | ---: | ---: |
| Validated attempt | 3,986 | 2,180 | 1,806 |
| Known absent | 2,251 | 1,380 | 871 |
| Unvalidated observed prefix | 983 | 470 | 513 |
| Unknown opportunity without observed prefix | 113 | 62 | 51 |
| Total | 7,333 | 4,092 | 3,241 |

Validated attempted errors total **724** (368 ATP / 356 WTA). An error indicator
is undefined outside validated attempts, including known absences; conditional
execution rates are not calculated. Known absence preserves the frozen terminal
reason. Unvalidated prefixes retain their action ID but receive no usable
transition or full-point validation. Administrative challenges create no new
stroke; the validated +1 in one challenge-ending point was already a preceding
physical stroke. No missing observation is substituted with zero.

## Coverage and selection limitations

The 165-row coverage summary reports ALL, tour, all 44 matches, surface,
point disposition, owner, pending serve number and incoming observable context.
Context combines tour, next domain, previous type and direction/depth support
status. Context point counts can overlap because one point occupies several
states; the disjoint tour/match inventories reconcile to exactly 7,333 points.
Context counts describe chart-derived states, not inferred movement or attack.

| Tour/surface | Usable / all transitions | Retention |
| --- | ---: | ---: |
| ATP Clay | 6,482 / 7,159 | 90.54% |
| ATP Grass | 4,583 / 5,226 | 87.70% |
| ATP Hard | 6,350 / 8,508 | 74.64% |
| WTA Clay | 4,828 / 7,415 | 65.11% |
| WTA Grass | 4,486 / 5,153 | 87.06% |
| WTA Hard | 4,407 / 5,132 | 85.87% |

Match-level transition retention ranges from **8.60% to 100%**; thirteen charts
have every point validated. Bertens/Errani 2020 Roland-Garros retains only
157/1,825 rows, Sinner/Spizzirri 2026 Australian Open 183/1,494, and
Bertens/Siniakova 2020 Roland-Garros 61/494. These are reported examples of the
complete match table, not selected analysis subsets. Unsupported detailed numeric
annotations are concentrated in particular charts and long sequences, so action
retention is lower than point retention. Retention can reflect coding style and
sequence complexity; it does not establish which player or surface is better.

Recorded outcome counts are reported solely as selection diagnostics: ATP
validated points contain 2,300 server wins / 1,260 receiver wins, versus 316/216
among withheld points; WTA has 1,517/1,160 versus 299/265. No win probability,
association test, repair or outcome-based reselection is calculated. Complete
annotation is not random missingness. The original match sample is metadata-hash
selected and convenience-charted, not representative of the tour population.

The retrospective whole-point QA gate becomes known after the point. It cannot
serve as a prospective predictor, and its use conditions any eventual estimand
on fully interpretable chart sequences. Recorded times, positions, speeds, spin,
ball quality, attack/defence and actual historical availability remain absent or
unverified. No official completion/admission claim follows from chart consistency.

## What the states can and cannot support

These rows support deterministic action ownership, observable response context,
terminal accounting and simple execution summaries. They might support a later
coarse predictive state experiment, but this audit neither estimates its
probabilities nor demonstrates useful action values. The incoming one-stroke
snapshot is not established as a sufficient Markov state. The same recorded
shot/direction can follow very different unmeasured balls and player positions;
a post-minus-pre win-probability difference could absorb opponent quality and
unobserved context rather than measure the acting player's distinct skill.
Telescoping terminal totals would be accounting, not evidence of factor validity.

**Recommendation:** start with simpler, named observable execution metrics in
Serve/Return/Rally domains before attempting action-value estimation. Movement
attribution and a fourth factor remain unresolved. This does not prove all
predictive action-value models impossible; they need separate specification,
approved evaluation and empirical evidence of incremental usefulness. Three
measurement domains are proposed, not three validated performance factors.
All acquired years, including 2026, remain exposed; no evaluation period is chosen.
`UNCERTAINTY_NOT_ESTABLISHED` remains binding.

## Validation and preservation

Focused fixtures cover fault/second-serve transitions, lets, forfeits, double
faults, error-inclusive +1, terminal returns and administrative challenges;
terminal absorption and explicit unknowns; player relabeling; current/later
terminal and stroke perturbations; and prior-return positive controls.
All-point checks verify order, past-only provenance, unique ownership, immutable
sample/joins, no unresolved-prefix promotion, four-way +1 accounting, coverage
summaries and field classifications. Recorded outcome/Notes perturbations change
only the disclosed outcome-count diagnostics, never pre predictors or frozen
usability. Match/point/action permutations and independent reruns are byte-identical.

All 124 field-provenance entries classify the three data/coverage outputs;
only the eleven listed pre fields are an allowable predictor schema. Raw full-point
notation and QA labels are explicitly excluded. During inspection, the provenance
description of post-boundary calculation was clarified to include the preceding
state; that documentation-only output correction changed no state or coverage
value and was followed by focused validation.

Validation passed: **14,745 focused suite checks**, an additional independent
all-6,237 terminal/winner reconciliation, and **49 documentation, consistency
and preservation checks**. Four independently generated outputs were byte-identical.
The ending commit and clean Git state are recorded in the handoff.
All 487 pre-existing artifacts outside current-document updates remain byte-identical,
including parser code/tests, both parser releases, raw inputs, manifests, evidence
and the sample. Historical document tails are preserved. No acquisition, dependency,
directory structure, population parse, probability estimate, factor, weight,
rating, model, score or portfolio change occurred. Historical suites were not rerun.
Installation stages four files, rejects differing installed bytes and renames per
file; it is not a multi-file transaction.

Final output SHA-256 fingerprints:

| Output | SHA-256 |
| --- | --- |
| action-states | `bdb2c4030d570aff6d96112ff71471450c7d1a1101368653a764ff2f431b4197` |
| serve-plus1 | `6cc4bb3a513ad5e6344f28d8beb9f19ee8d4612d12299f64a5ef511e3f8e7281` |
| coverage-summary | `08768bef445c4b558940b6ad1cb88c470088663802c947074ba2ad46a7bc4e60` |
| field-provenance | `145a7ee0c37b0bf7fab33c81992e3c5c6396e97b02bf5f1f14f6f0695506e5d0` |

## One next executable step and exact approval

“Implement sample-only descriptive Serve/Return/Rally execution summaries from
the frozen observable-state release. Prespecify named counts and execution-rate
denominators, retain full-sample coverage and all unknown/unusable cases, and
report Serve +1 as a tactical breakdown without duplicated action credit.
Estimate no action values, point-win probabilities, weights, ratings or models;
acquire no data and choose no evaluation period.”

Before probabilistic estimation, user input must settle the retrospective
assessment and genuinely untouched evidence boundary. No new final season is
selected here. Unsupported notation and serve-semicolon authority conflicts
remain unresolved; this milestone authorizes no repairs or outreach.
