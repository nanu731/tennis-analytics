# Serve Creation construct decision

## Decision and checked evidence

**SERVE_CREATION_RESPONSE_HYPOTHESIS_ONLY.** Propose one mechanism: a serve's
recorded delivery direction may alter the depth of the receiver's first in-play
response, potentially changing the server's next-stroke opportunity. The
observable measurement is a **serve-conditioned return-depth profile**, not a
server-attributed advantage score or a qualified Serve Creation factor. Saved
notation supports the proposed fields; paired support and the mechanism have
not been tested. If the intended construct requires attribution of created
advantage to the server, current evidence is insufficient.

This documentation-only decision uses baseline
`985b9e4aacf1c0192fda821cfbcf828783410f8e`. It changes no sample, parser,
completion gate, ownership, metric, prediction or historical result. First-serve
fault frequency, direct terminal distribution and terminal balance remain
descriptive/exploratory; none advances as a validated factor.

| Frozen evidence | Checked finding | Construct consequence |
| --- | --- | --- |
| [Expanded first-serve faults](mcp-expanded-first-serve-fault-transfer-results.md) | Whole-match personal-minus-reference Brier: −0.001016432 men, +0.000882046 women; log differences also oppose across categories. Cecchinato deletion substantially attenuates the men's result; the original overlapping experiment reversed under that deletion. | Physical first-attempt error frequency is measurable, but finite losses and expansion do not establish general serving information or advantage creation. |
| [Direct terminal distribution](mcp-direct-serve-transfer-results.md) | Multiclass Brier differences −0.001185971/−0.002199214, but personal log loss is Inf in both categories, with 26/22 endpoint contradictions. Kyrgios deletion reverses men's Brier. | A valid ACE/DOUBLE_FAULT/OTHER partition is partial terminal bookkeeping; favorable Brier is insufficient transfer or construct evidence. |
| [Terminal balance](mcp-serve-terminal-balance-transfer-results.md) | Primary squared slot-average balance differences −0.000324507/+0.000173840; opportunity-weighted differences +0.000164194/+0.000117119. Primary directions reverse in 3/11 deletions; Kyrgios and Vondrousova illustrate composition sensitivity. | Scalar balance remains descriptive. Finite balance error does not repair distribution log failures or qualify Serve. |

Values above were checked against frozen paired-score files; named deletion and
endpoint findings were checked against the frozen reports and saved ledgers.
No losses, rates, correlations or other research statistics were recalculated.
Historical ATP/WTA file labels are reported here as men's/women's categories,
without newly asserting verified tour membership for early charts.

## Mechanism and observable unit

The tennis hypothesis concerns **how delivery direction shapes a returned ball**,
beyond whether the point ends immediately. A return landing in the service boxes
could leave a different next-stroke opportunity from one landing nearer the
baseline. Whether that opportunity is advantageous depends on unmeasured ball
and player conditions. Short depth is not synonymous with a weak return: a
short angle, low slice or drop return can be difficult. No favorable-depth
orientation, difficulty label or created-point-value scale is adopted.

Pinned MCP revision is `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`.
The saved MatchChart 0.3.2 Instructions A46–48 define serve direction
4/5/6 as wide/body/T and 0 as unknown. A170–180 define optional in-play return
depth: 7 in the service boxes; 8 behind the service line and nearer that line
than the baseline; 9 nearer the baseline than the service line. Omission or
0 does not establish depth. These definitions were read directly from the
saved workbook, whose SHA-256 is
`46e2349eee512296a86170449f6e463a6be91be9261a0c7b6b5d5a25c006729f`.
The [notation evidence manifest](../data/manifests/mcp-notation-evidence.csv)
records E03 and E01, the saved 2015 Quick Start corroboration. The workbook
matches the [pinned source manifest](../data/manifests/mcp-source-files.csv).
Later rally digits remain unsupported under the
[notation-resolution release](mcp-notation-resolution.md).

One observation is a unique service-point pair: the supported delivering Serve
and its first supported in-play Return, linked by match/point/action IDs,
server/receiver identity and recorded FIRST/SECOND serve number. The receiver's
first response must itself be an in-play Return; never skip an error or unknown
response to find a later stroke. It is not a physical-first-attempt fault denominator. First faults can precede the delivering
second serve; void lets and administrative events create no extra response pair.
Retain raw notation, spans, field provenance, serve-and-volley annotations and
all original flags. No position or exact landing coordinates are reconstructed.

For each server–receiver–match–serve-number–serve-direction stratum:

- Denominator: unique pairs meeting existing full-point QA and completion rules,
  with recorded direction 4/5/6, a supported in-play Return and depth 7/8/9.
- Numerator for each depth code: that stratum's pairs carrying the code. The
  three numerators partition this denominator; pool compatible counts before
  division. All three categories remain visible, without selecting a favorable
  depth after looking at results.
- Zero denominator: profile undefined. It is neither an all-deep profile nor
  a cold-start initialization. No smoothing, weighting by inferred quality,
  imputation, threshold or eligibility rescue is proposed.

Preserve the entire unchanged `MCP_EXPANDED_RECURRING_1.0.0` inventory of
223 charts and the three completion exclusions. A future linkage release must
report all service-point branches and retention, not only its profile rows.
Ace/double fault and a terminal-before-in-play-return branch have no qualifying
in-play depth observation; they are not code 7 or a failed profile prediction.
A recorded Return error remains Return-owned, outside this in-play denominator.
A supported Return winner may carry valid depth, but has known absence of +1;
it is not removed to manufacture a next-stroke opportunity. Collapsed unreturnable notation establishes no separately observed Return stroke.
Unknown serve number/direction, optional omitted depth, explicit unknown depth,
unsupported notation, authority conflicts, withheld points and completion
exclusions require separate dispositions. Structural nonapplicability is distinct
from missing observation. Unresolved suffixes continue to withhold the entire
point under frozen QA; supported prefixes cannot silently expand eligibility.

## Ownership, timing and attribution

Serve owns the delivery and its recorded direction. Return owns its stroke,
landing-depth annotation, winner and error. The linked profile is a cross-domain
response measurement, not transferred Return credit in a Serve factor total.
An error following a serve is never assigned wholly to Serve. Rally owns every
later stroke, including the server's first post-return stroke (+1), even an
attempted error. +1 is a Rally breakdown, with no duplicate Serve credit.
Administrative challenges create no stroke; known absence and unknown +1
opportunities remain distinct.

Serve direction is observed after delivery and can become pre-Return context.
Return depth is observed after Return and can become pre-+1 context; it cannot
enter a pre-Serve predictor. Current Return errors, later strokes and terminal
outcomes cannot be used to define the profile's prior context. Retrospective
full-point QA remains an explicit selection gate, not a real-time availability
claim. See the [observable-state boundaries](mcp-action-state-audit.md) and
[opportunity-context audit](mcp-opportunity-context-audit.md).

Receiver response can reveal the recorded depth distribution under observed
serve contexts. It cannot isolate the server's contribution from receiver
ability, intent, stroke choice or unobserved conditions. Disjoint action ownership
does not establish statistically independent player metrics. A return-depth
profile would overlap Return context and select which Rally/+1 opportunities
exist; it cannot simply be added to their rates as independent net-point credit.

## Falsifiable assessment and evidence gates

One bounded question for separate approval is: **within the same recorded
receiver, match and FIRST/SECOND context, do distinct recorded serve directions
have different observed in-play return-depth profiles?** Display every supported
direction/depth cell and all unknown/withheld exposure. Within-match/receiver
comparison reduces obvious composition differences but does not identify
causation. A stratum with only one observed direction cannot assess the question;
retain it with an explicit unavailable-comparison disposition. Invent no minimum
sample threshold or significance rule.

The hypothesis predicts observable profile variation with direction within
those contexts. Identical profiles offer no measured support there; sparse,
missing or one-direction strata make it unassessable rather than disproved.
Variation alone cannot establish advantageous depth or server attribution.
No such assessment has been executed, and no direction's expanded-sample depth
coverage is claimed from the earlier 44-match state audit.

Before a comparative assessment, require independently reconciled unique
Serve–Return pairs, supported direction/depth authority, unchanged full-point
QA/completion dispositions, and measured within-receiver/context exposure for
multiple directions. A first implementation must measure these prerequisites
without scoring transfer, testing NPR or selecting contexts by error/outcome
frequencies. If support is unavailable, stop this hypothesis; do not expand the
sample or replace missing depth with terminal outcomes.

To qualify actual *created advantage*, the missing evidence is a defensible
relation between these responses and the next player's playable state: measured
ball arrival/trajectory and both players' locations/timing, or another explicitly
justified opportunity assessment that separates receiver contribution. Current
coarse depth and stroke labels do not supply that relation. No particular new
source, acquisition or attribution method is approved.

## Documentation validation

All 758 affected checks passed: eleven pinned MCP files' SHA-256, byte sizes,
Git blobs and revision; four saved notation-evidence hashes/sizes; cited stored
losses and deletion signs; current-document agreement, local links, whitespace
and scientific boundaries. All 637 historical tracked/raw/pilot artifacts and
three historical document tails remain byte-for-byte unchanged; no raw/pilot
file was added. The final staged diff is limited to this decision and the three
current source-of-truth documents. No numerical runner or historical suite was
executed, and no new research statistics were computed.

## Factor-framework consequence and next approval

This question moves from terminal bookkeeping toward an observable intermediate
Serve–Return mechanism. It does not fill the Serve factor slot. In a coherent
Serve/Return/Rally framework, action ledgers remain exclusive while coupled
response measurements expose cross-domain dependence. A later contemporaneous
net-point association, separately designed chronological transfer assessment,
and distinct/stable incremental factor qualification are separate requirements.
No NPR relationship or low-collinearity result has been tested here. ACE/DF and
terminal outcomes directly overlap point totals arithmetically; using later
point outcomes to value depth would also introduce outcome coupling and
attribution assumptions, not independent explanatory evidence.

Keep source-date chronology, selective QA retention, convenience selection,
opponent/context confounding, annotation coarseness, exposed years including
2026, unverified official completion and `UNCERTAINTY_NOT_ESTABLISHED` visible.
No new evaluation period, ratings, weights, action values or factor approval
follows. There is no automatic smoothing, sample expansion or transfer chain.

**One next executable step, requiring this exact approval:**

“Build and audit one frozen-sample Serve–Return depth linkage release using
MCP_EXPANDED_RECURRING_1.0.0 and unchanged completion/parser/QA rules. Reconcile
unique delivering-Serve/in-play-Return pairs, literal serve direction and return
depth, all missing/structural/withheld dispositions, and within-receiver,
match and FIRST/SECOND exposure to multiple directions. Report support for the
prespecified response-profile question without calculating comparative losses,
NPR associations or server-attributed advantage. Keep all inventory rows and
historical releases; acquire nothing, change no eligibility, add no dependency,
expand no sample, and fit or score no model. If paired support fails, report
that evidence gap rather than substitute a proxy.”

This is a mechanism-specific measurement implementation, not permission to
execute another transfer run. Choosing an attributable Serve Creation construct
instead requires user direction on obtaining the missing state evidence.
