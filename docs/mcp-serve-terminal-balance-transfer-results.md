# Direct Serve terminal-balance transfer results

## Prospective specification — recorded before scoring

Baseline: `a0b3c5f3cbc76717fc7e8599e80e61054899755e`. This executes the
separately approved balance experiment proposed in the
[distribution report](mcp-direct-serve-transfer-results.md#limits-and-one-next-executable-question).
Reuse MCP_DIRECT_SERVE_TRANSFER_1.0.0 and unchanged MCP_EXPANDED_RECURRING_1.0.0:
frozen point classes, counts, identities, prior histories, probabilities,
completion exclusions, dispositions and exact 255 supported server-match IDs.
No reconstruction or modification of the estimators, mask or eligibility occurs.
The normalized text before the measured-results heading is fingerprinted in the
runner before scoring; historical authorities and every distribution output are
pinned independently. This proposal followed exposed distribution results and
is exploratory, not independent replication or an untouched test.

### Estimand and scoring unit

For each unique fully validated service point, define Z as ACE=+1,
DOUBLE_FAULT=−1 and OTHER=0. Unknown and withheld observations have no Z, never
zero credit. Frozen validated eligible point counts alone supply denominator N.
The observed server-match-slot average is `b=(ACE−DOUBLE_FAULT)/N`; N=0 leaves
b undefined. Personal/reference prediction is the unchanged earlier pooled
probability contrast `h=p(ACE)−p(DOUBLE_FAULT)`, without fitted weights.

The target is the **match-level average terminal balance conditional on observed,
QA-validated eligible service points**. Primary slot loss is `(h−b)^2`.
Average supported slot losses within each match, then average matches equally,
separately by historical men/women category. A match with one supported slot
remains one match with that slot's loss. Secondary opportunity-weighted loss
is `sum(N*(h−b)^2)/sum(N)` on the identical slot-ID mask. This weights squared
slot-average errors, not individual point errors. Neither score substitutes
`mean((h−Z)^2)`: the latter contains within-slot point variation and has a
different estimand. No point-level squared-error result is calculated here.

Report personal-minus-reference loss; negative descriptively favors personal.
Preserve the frozen ALL_DATE_EXPANDING earlier-same-category probabilities,
simultaneous-batch freezes, unsmoothed endpoints, positive-denominator cold-start
abstention, explicit unknowns, seed rows and completion exclusions. Both methods
use exactly the frozen 120 men's and 135 women's supported IDs; no new rows
become eligible. Endpoint contrasts remain permitted and finite where supported.
The earlier distribution's infinite log losses are neither repaired nor replaced
by this bounded score.

### Deletions, failures and claim limits

Use the inherited full evaluation inventory: every eligible nonseed match and
every player occurring in either neutral slot, including zero-impact deletions.
Delete an entire match, or every evaluation match containing the named player in
either slot. Keep probabilities, reference pools and training histories frozen;
never refit or drop only that player's slot. Report both scores, paired counts,
removed slots/matches and signed changes for every deletion.

No supported targets yields undefined losses and
`UNEVALUABLE_NO_SUPPORTED_TARGETS`. Nonfinite supported losses or invalid
supported denominators yield undefined comparisons with an explicit reason;
never drop such rows with `na.rm`, replace losses or call a missing result a tie.
Missing or conflicting frozen identities, masks, counts, predictions or source
pins stop before scoring. A deletion comparison requires finite base and retained
scores; otherwise its change/direction status is `UNEVALUABLE`. Ties stay ties.
All numerical safeguards verify arithmetic, not a new adequacy threshold.

Apply existing nonsummed requirements: favorable, stable descriptive balance
results permit only limited component research; reference-favored, mixed,
unevaluable or composition-sensitive findings cannot qualify a factor. No
composite selection rule, practical threshold, smoothing or automatic next run.
Direct balance measures a partial serve benefit/cost component, not comprehensive
Serve quality, causal skill or independence. It overlaps point outcomes
arithmetically; calculate no NPR association, factor weights, ratings or match-
winning forecast. Preserve selective-retention, sparse-history, category,
source-date chronology, unverified official-completion and exposed-year limits,
and UNCERTAINTY_NOT_ESTABLISHED. Serve +1 stays Rally-owned.

## Measured results and coverage

**DIRECT_SERVE_TERMINAL_BALANCE_REMAINS_DESCRIPTIVE.** The men's primary
personal-minus-reference difference is negative, but the women's is positive;
secondary opportunity weighting favors reference in both categories. Deletions
change directions in both categories. This does not strengthen the earlier
limited component-research recommendation. Retain direct terminal balance as
an exploratory descriptive summary, without an automatic further transfer run,
tuning chain or factor advancement.

The mask, predictions and counts are exactly those of the distribution release.
All 223 charts, 446 slots and 43,310 points remain in the linked inventory;
unchanged per-point unknowns/exclusions remain in its pinned point ledger.
The balance release carries all 446 target rows and all 223 coverage rows.

| Frozen support/coverage | Men (ATP file label) | Women (WTA file label) |
| --- | ---: | ---: |
| Inventoried / completion-eligible matches | 106 / 104 | 117 / 116 |
| Supported slots / scored matches / server identities | 120 / 89 / 38 | 135 / 103 / 36 |
| Validated eligible service points / paired point denominators | 22,910 / 12,973 | 13,637 / 8,074 |
| Cold-start / seed / completion-excluded slots | 86 / 2 / 4 | 95 / 2 / 2 |
| Eligible-chart withheld / completion-excluded points | 2,992 / 416 | 3,192 / 163 |
| All-inventory point retention | 87.05% | 80.26% |
| Eligible-match point-retention range | 23.91%–100% | 18.80%–100% |
| Supported prior N range / median | 39–1,195 / 276 | 26–985 / 154 |
| Usable prior-match depth range / median | 1–9 / 2.5 | 1–13 / 3 |
| Last source-date gap range / median days | 1–3,286 / 222.5 | 1–6,996 / 238 |

Completion exclusions, unknown observations, zero denominators and all
applicable abstention flags remain unchanged. There are no zero-target or
zero-reference priority abstentions in this particular frozen release, although
the inherited positive-denominator gates remain. The two first eligible batches
are seed matches, with no prediction. No opponent, player or failed chart is
replaced. Categories retain their historical labels, without certifying early
ATP/WTA membership or historical availability.

## Match-average balance losses

Negative personal-minus-reference difference favors personal descriptively.
These squared slot-average balance errors are neither multiclass Brier nor
point-level squared errors. Their scales and scientific targets differ from
the previous distribution experiment; do not rank experiments by these numbers.

| Score on identical supported IDs | Men personal | Men reference | Men difference | Women personal | Women reference | Women difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Primary whole-match squared balance error | 0.006108402 | 0.006432909 | −0.000324507 | 0.007489973 | 0.007316133 | +0.000173840 |
| Opportunity-weighted squared slot-balance error | 0.005321702 | 0.005157508 | +0.000164194 | 0.005562259 | 0.005445140 | +0.000117119 |

All balance comparisons are finite and evaluable. This is an expected property
of bounded contrasts with finite probabilities and positive denominators, not
endpoint stabilization, proof of player information or repair of the frozen
three-class probabilities. No new log loss is defined for this scalar target.

Preserve the [distribution findings](mcp-direct-serve-transfer-results.md#paired-distribution-losses-and-endpoint-failures)
exactly: its primary Brier favors personal in both categories, while its personal
log losses are Inf from 26 men's and 22 women's contradicted zero probabilities.
The distribution's Nick Kyrgios deletion reverses men's primary Brier to
+0.000297407. Those results and their artifacts are unchanged. Distribution
Brier improvement therefore cannot establish prediction of the signed balance.

## Every frozen-prediction deletion

All 401 inherited deletion IDs remain present, including zero-impact rows:
men have 103 match plus 87 both-slot-player deletions; women have 115 plus 96.
Each removes complete evaluation matches, never one player's observation alone.
No deletion changes training histories or personal/reference estimates.

| Sensitivity | Men | Women |
| --- | ---: | ---: |
| Primary direction reversals | 3 of 190 | 11 of 211 |
| Opportunity-weighted direction reversals | 7 of 190 | 13 of 211 |
| Primary retained-score difference range | −0.000578204 to +0.000305518 | −0.000521579 to +0.000661740 |
| Weighted retained-score difference range | −0.000319651 to +0.000668978 | −0.000440264 to +0.000528086 |

Men's largest primary influence is Nick Kyrgios: deleting his matches removes
14 paired slots and changes the difference to +0.000305518. Removing the
2015 Kyrgios/Jaziri Australian Open match, or Malek Jaziri, produces
+0.000076306. Women's largest primary examples are deletion of the 2021
Marino/Vondrousova Australian Open match, or Vondrousova, changing direction
to −0.000521579; Oksana Selekhmeteva deletion gives +0.000661740. Reported
influence identifies composition dependence; it is not uncertainty or a basis
for trimming the sample. No real deletion is unevaluable or tied; explicit
empty/nonfinite/invalid-denominator handling is verified with fixtures.
Full per-deletion scores, changes, directions and removed counts are exported.

## Implementation, checks and release preservation

One base-R runner consumes the frozen distribution outputs; it does not rerun
its numerical experiment, reclassify points or re-estimate predictions.
Keyed comparisons protect every original target field, the exact 255-ID mask,
class counts, denominators, dispositions and probability contrasts. Independent
point-ledger checks reconcile the denominator and Z-average before scoring.
Source/rights/provenance helpers and all seven distribution output fingerprints
are verified before use. The normalized prospective specification SHA-256 is
`a0fa2a556cd90ba32fffb56a679135e99901092d8cbcaf9987cc3df4e0e01e30`.
The frozen distribution report SHA-256 remains
`b9245ec406491462f5085f848a6c252abfa3e4f00f564233511187a8f476cacd`.

Five ignored files use the existing flat prefix
`data/pilot/mcp-serve-terminal-balance-v1-`: `target-estimates.csv` (446 rows),
`paired-scores.csv` (two), `stability.csv` (401), `coverage-summary.csv` (223)
and `summary.csv` (two). Original prediction/count fields are preserved;
new loss fields explicitly identify squared balance error. Each file labels
MCP_SERVE_TERMINAL_BALANCE_TRANSFER_1.0.0, the source release and specification
pin. The existing point inventory remains linked and pinned rather than copied
or dropped. Installation stages all files, preflights fingerprints, refuses
differing releases and uses per-file atomic renames with rollback of newly
created files on an installation failure.

All **6,714 focused checks passed**. The R snapshot preserved 627 historical
artifacts; the independent inventory includes two hidden files and verifies
**629 historical artifacts plus all three historical document tails**. All
**770 documentation, numeric, scope and preservation checks passed**. The five
output summaries and final diff were inspected; no authority conflict or release
correction occurred. Tests cover the scalar estimand,
its distinction from point loss, frozen masks/probabilities/counts, independent
point-value averages, slot/match versus opportunity weighting, every deletion,
explicit unevaluable cases, altered-input refusal, neutral-slot invariance,
permutations, deterministic byte-identical reruns and installation safeguards.
Documentation checks cover links, agreement, cited results, whitespace, exact
six-file tracked scope and historical preservation. Historical numerical suites
are not rerun or repinned. No acquisition, dependency, smoothing, eligibility,
threshold, sample, portfolio, rating, weight or match-winning forecast change.

## Research consequence and one next approval

The balance result narrows the recommendation: **keep the summary descriptive**.
This experiment does not supply stable cross-category transfer against the
reference, and neither weighting can be chosen afterward to avoid a contrary
finding. No automatic diagnostic, smoothing, expansion or retest is recommended.
The complete narrow terminal distribution and its signed average are distinct
scientific targets; both remain exploratory for different measured reasons.

Aces/double faults describe only direct service endings. They omit what a
returned serve creates and depend on opponent/context. Signed balance overlaps
point outcomes arithmetically; no NPR association is calculated or inferred.
No comprehensive Serve-quality, causal-responsibility, independence, low-
collinearity or factor-qualification claim follows. Selective QA retention,
convenience selection, sparse recurring histories, large era gaps, source-date
chronology and unverified official completion/availability remain. Evidence
is exposed and overlapping; the balance proposal followed distribution results,
so it is not independent replication or a new untouched test.
UNCERTAINTY_NOT_ESTABLISHED remains. Serve/Return/Rally remain proposed domains,
with Serve +1 exclusively Rally-owned and movement attribution unresolved.

Recommend one **documentation-only Serve Creation construct decision** before
any further experiment: determine whether an observable mechanism beyond
ace/double-fault terminal bookkeeping can represent the intended Serve domain.
Use saved parser/state definitions and these frozen results to specify the
mechanism, action versus point unit, ownership, denominator and opponent-response
ambiguity, or identify the specific missing evidence if none is defensible.
This resolves the construct gap rather than continuing an adaptive scoring chain;
it authorizes no new statistics, eligibility change or next automatic run.

Exact next approval: “Complete one documentation-only Serve Creation construct
decision using saved action/state definitions and frozen transfer findings.
Keep direct terminal balance descriptive. Specify one defensible observable
mechanism beyond ace/double-fault bookkeeping, including unit, ownership,
denominator, opponent-response limits and a falsifiable question; if existing
evidence is insufficient, name the missing evidence and request direction.
Do not calculate new statistics, run another transfer experiment, tune,
acquire data or change historical releases.”
