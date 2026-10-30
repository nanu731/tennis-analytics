# MCP Return-frequency transfer — Option A results

**RETURN_TRANSFER_MIXED_SPARSE_RECURRENCE_NO_GENERALIZATION_ESTABLISHED.**
User-authorized Option A of the frozen [protocol](mcp-return-transfer-protocol.md),
implemented from `a6ef8fd86a1a27fc67195069aa037e97207f808d`.
Release `MCP_RETURN_TRANSFER_1.0.0` measures later annotated Return errors
conditional on chart-observed, whole-point-QA-usable actions. It does not validate
player skill, independent factors, causal responsibility or match-winning forecasts.
The protocol remains byte-for-byte unchanged; its pending-choice statements record
the pre-experiment state. The user selected A in this task. B was not evaluated.

## Frozen method and inputs

Separate ATP/WTA and recorded FIRST/SECOND serve contexts. Error counts are
FORCED_ERROR plus UNFORCED_ERROR on usable Return-owned STROKE attempts, with
both subcounts retained. Aces, double faults and collapsed unreturnable serves
create no synthetic Return attempt. Both measurements belong to one Return domain.

For each player/context, pool errors and attempts from every strictly earlier
same-tour source-date match before division. Reference estimates pool all prior
same-tour/context attempts. Freeze estimates for the complete source-date batch;
same-date events cannot contribute to one another. There are no equal-date groups
in this inventory, so simultaneous multi-match behavior is tested with fixtures.
No smoothing, clipping, imputation, window, adjustment, model fitting or minimum
denominator gate was added. Source dates are labels, not verified information
availability or match timestamps. Gap calculations describe labels, not inactivity.

Verified source revision `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`, saved
CC BY-NC-SA 4.0 research-use evidence, source and notation manifests, frozen sample,
parser 1.0.0/1.1.0, state, execution and context hashes through existing helpers.
The four context pins are explicit in [runner](../R/run_mcp_return_transfer.R).
Frozen protocol SHA-256:
`fc012076f70e970493db5c6ff710add54e3efb87e2d116811b572c8110e68d36`.
No source or rights evidence was acquired or changed.

## Coverage, abstentions and histories

| Tour | Inventory matches / points / slots | Seed matches | Evaluation matches | Supported matches / slots / context targets | Distinct supported players | No-history context targets |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 20 / 4,092 / 40 | 1 | 19 | 6 / 6 / 12 | 4 | 64 |
| WTA | 24 / 3,241 / 48 | 1 | 23 | 6 / 6 / 12 | 5 | 80 |

All 44 matches, 88 perspectives, 176 FIRST/SECOND target cells and 7,333 points
remain inventoried. Eight context targets (four per tour) are
SEED_NOT_EVALUATED; 144 are NO_PRIOR_PLAYER_CONTEXT_ATTEMPTS; 24 are
PAIRED_SUPPORTED. NO_USABLE_TARGET_CONTEXT_ATTEMPTS and
NO_PRIOR_REFERENCE_CONTEXT_ATTEMPTS both occur zero times. The reference does
not rescue cold starts. All 88 perspectives have positive target attempts in both
recorded contexts; availability does not establish precision.

No evaluation match supports both players. Six per tour support one; 13 ATP / 17
WTA support neither. Scored coverage is 6/19 ATP and 6/23 WTA evaluation matches,
but only 6/38 and 6/46 evaluation player slots. Supported ATP players are Federer,
Djokovic, Nadal and Jarry; WTA players are Graf, Sharapova, Bertens, Gauff and Swiatek.
Djokovic supplies three of six ATP scored matches; Graf supplies two of six WTA.

| Tour/context | Target usable attempts / errors | Prior matches per supported receiver | Prior attempts range | Gap since latest prior source date, days |
| --- | ---: | ---: | ---: | ---: |
| ATP FIRST | 377 / 98 | 1–3 | 29–220 | 100–4,411 |
| ATP SECOND | 196 / 32 | 1–3 | 9–118 | 100–4,411 |
| WTA FIRST | 201 / 56 | 1–2 | 6–92 | 2–2,220 |
| WTA SECOND | 97 / 19 | 1–2 | 4–63 | 2–2,220 |

Elapsed gaps and first/last prior dates are recorded for every supported cell;
empty histories remain undefined. Most histories consist of one prior chart.
Supported-target absolute departures from personal frequencies range
0.0190–0.3759 ATP FIRST, 0.0104–0.4830 ATP SECOND,
0.0152–0.4576 WTA FIRST and 0.0071–0.5000 WTA SECOND.
These are descriptive measurement departures, not stability thresholds.

Frozen Return exposure remains 3,534 observed / 3,058 usable ATP and
2,954 / 2,425 WTA. WITHHELD_ACTION exposure is 476 / 529 attempts respectively:
1,005 total. FIRST retention is 3,462/4,136; SECOND is 2,021/2,349.
UNKNOWN_OR_UNSUPPORTED_CONTEXT exposure contains three observed attempts
(two ATP, one WTA), all unsupported and withheld; usable unknown contexts number
zero. Unsupported exposure overlaps withholding and must not be added to it.
Unobserved suffix action counts cannot be inferred. Match transition retention
remains 8.60%–100%; this is not the scored Return denominator or official coverage.

## Paired results

Losses use identical personal/reference cells, with six complete whole matches
in each tour/context. Primary Brier averages supported player-cell losses within
match, then gives each scored match equal weight. Personal minus reference:
negative favors personal descriptively. No direction selects or qualifies a factor.

| Tour/context | Personal Brier | Reference Brier | Brier difference | Personal log loss | Reference log loss | Log-loss difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP FIRST | 0.233684 | 0.211843 | +0.021842 | 0.663952 | 0.614892 | +0.049060 |
| ATP SECOND | 0.196276 | 0.148134 | +0.048142 | 0.595784 | 0.472445 | +0.123339 |
| WTA FIRST | 0.258041 | 0.292168 | −0.034127 | 0.716614 | 0.804044 | −0.087430 |
| WTA SECOND | 0.180060 | 0.224320 | −0.044260 | 0.527902 | 0.647728 | −0.119826 |

Opportunity-weighted secondary Brier differences are +0.026042 / +0.061264 ATP
FIRST/SECOND and −0.010895 / −0.005593 WTA. Secondary opportunity-weighted
log-loss differences are +0.057769 / +0.135822 ATP and −0.032920 / −0.013118 WTA.
All four directions agree with their respective primary match-weighted directions.
Every target cell's estimate, observed frequency, departure and loss is retained.

**Infinite log losses: zero for either estimator on all 24 scored cells.**
This is measured, not guaranteed. Tests retain contradictory unsmoothed 0/1
estimates as infinite loss and treat Inf-minus-Inf as indeterminate. No clipping,
replacement, silent omission or boundary rescue occurs.

## Frozen-score deletion diagnostics

All 42 evaluation-match deletions and 73 distinct evaluation-player deletions
are reported separately in each context: 230 rows. Player deletion removes every
evaluation match containing that identity in either slot, including when that
player is the unsupported opponent. Predictions and training pools are not refit.
No deletion leaves an empty scored remainder in this release; UNEVALUABLE remains
an explicit tested failure case. Deletions with zero scored-cell effect remain.

| Tour/context | Whole-match-deletion Brier difference range | Both-slot-player-deletion range |
| --- | ---: | ---: |
| ATP FIRST | −0.000521 to +0.028182 | −0.000521 to +0.047710 |
| ATP SECOND | +0.011173 to +0.059315 | +0.011173 to +0.094645 |
| WTA FIRST | −0.045892 to +0.000877 | −0.050017 to +0.000877 |
| WTA SECOND | −0.054739 to −0.015180 | −0.070002 to −0.015180 |

Removing Jarry–Rune (2025-06-30) reverses ATP FIRST Brier and log-loss directions.
Removing Linette–Swiatek (2026-05-29) reverses WTA FIRST Brier; log loss stays
negative. Deleting either player of those matches has the corresponding effect.
SECOND directions survive every measured match/player deletion. This does not
supply independent replication, intervals or a superiority conclusion.

## Release and verification

New [runner](../R/run_mcp_return_transfer.R) and
[focused tests](../R/test_mcp_return_transfer.R). Five ignored, flat files in
the existing `data/pilot/` location:

- `mcp-return-transfer-v1-observation-counts.csv`: 352 match/player/context rows,
  including zero, unknown, unsupported and withheld exposure.
- `mcp-return-transfer-v1-target-estimates.csv`: all 176 recorded-context targets,
  frozen prior pools, dates/gaps, abstentions, paired masks and cell losses.
- `mcp-return-transfer-v1-paired-scores.csv`: four tour/context comparisons.
- `mcp-return-transfer-v1-stability.csv`: all 230 deletion comparisons.
- `mcp-return-transfer-v1-summary.csv`: two tour coverage/history summaries.

Output SHA-256 pins (same prefix and `.csv` suffix):

| File stem | SHA-256 |
| --- | --- |
| observation-counts | `1080ac986481826ae4ffb17b526e617d9a1e2d79cb1f25c069662d426a7c54b8` |
| target-estimates | `a5262da89b26a2129f514d23f49d5e8e28a9564e6ba6294e367080fc7756053d` |
| paired-scores | `7a8a4f727c194e1f446c3cffb0a8957935c55fdbd00eb46edaf0123baee3fb1a` |
| stability | `5afd452a4da2638254886cdb747643b245ae5185bfb623cb4cd4c813ae2083d8` |
| summary | `2e60ce0226ce27f44b8da993b7c9aaad935acb8c8877aa9ac1edd98e0a167df2` |

Every output carries the retrospective source-label claim, exposed-year label and
UNCERTAINTY_NOT_ESTABLISHED. Installation stages all bytes, verifies sources and
preflights all destinations; atomic per-file renames reject differing releases.
It rolls back only newly created destinations on an installation failure; this
flat layout is not a crash-safe multi-file transaction.

**2,124 focused checks passed**, including source/protocol pins, independent
action-level count ownership, every pooled count and loss, all cutoffs and
deletions, same-date fixtures, positive controls, cold starts/zero denominators,
endpoint infinities, slot relabeling, permutations, identical masks, deterministic
independent byte reruns, installation and ignore coverage. A further 98
documentation/scope checks passed, including every output pin and exact six-file scope;
509 pre-existing artifacts and all three historical document tails are unchanged.
No historical scientific suite was rerun.

## Conclusion and one next executable step

There is no stable cross-tour transfer finding. ATP personal pools have higher
loss; WTA personal pools have lower loss on six matches per context, with
first-serve directions sensitive to one match. Sparse recurrence, long gaps,
uncertain chart availability/completion and selective QA prevent a generalizable
transfer or player-skill claim. This sample can demonstrate the estimator and
report these conditional comparisons, but cannot establish reliable repeat-player
transfer. No confidence interval, p-value, adequacy threshold or factor is created.
All acquired years including 2026 remain exposed.

Next, build a **new repeated-player sample from existing pinned MCP sources**:
up to 20 recurring players per tour, ordered by SHA-256 of exact tour/player
identity; retain each selected player's earliest five point-linked source-date
matches, include equal-date boundary ties, and deduplicate match IDs. Caps bound
prototype work; they are not adequacy or exclusion thresholds. Select on metadata
and linkage only, never errors, results or QA success. Retain failures in coverage.
Parse and construct observable states using frozen rules in a separate release;
report actual recurrence, completion evidence and QA retention before any new
transfer evaluation. Do not repeat diagnostics on the same 44 matches.

**Exact approval required:** “Build the proposed outcome-neutral repeated-player
MCP sample from the already pinned sources: up to 20 SHA-256-ordered recurring
players per tour and their earliest five linked source-date matches, including
boundary ties and deduplicating matches. Parse and construct observable states
with the existing rules, retain failures and preserve all releases. Acquire no
data; fit or score nothing. Return the measured repeated-player coverage for a
separate evaluation approval.”
