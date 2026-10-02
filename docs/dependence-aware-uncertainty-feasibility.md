# Phase 2S: dependence-aware uncertainty feasibility

Read-only assessment from clean `main` at `dc959bcccc827edbace1a8c75b39b2eb67ec5b82`. Only saved Phase 2R artifacts were used. No models were refitted, resampling performed, confidence intervals calculated or generated files created.

## Estimands fixed before dependence calculations

For each tour t, frozen comparator c (primary surface Elo or overall-only Elo), and loss l (natural-log loss or Brier), define `d_i(c,l) = loss_i(S08,l) - loss_i(c,l)` and `Delta_t(c,l) = sum(d_i)/N_t` over exactly the Phase 2R paired scored IDs. There are eight contrasts: two tours × two comparators × two losses. Negative differences favor S08 descriptively. Matches retain equal weight; this is not an equally weighted mean of event means or player means.

Condition on the frozen scored development cohort, eligibility/readiness selection, fitted predictions, model specification and **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY**. ATP N=211; WTA N=1,067. The other 1,302 targets remain in Phase 2R coverage but cannot enter this paired-loss estimand. No reweighting of the point estimate, new scored subset or pooling across tours is authorized.

The realized finite-cohort means are fully observed descriptive quantities. An inferential interval would additionally need a justified joint repetition/sampling law for losses under that conditioning; fixed predictions do not imply independent losses. No such law is established by the saved artifacts. This is not a claim that generalization uncertainty is zero. Future populations, training uncertainty, verified historical availability, 2024 performance and final factor importance are outside these estimands. **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE** remains unchanged.

## Evidence and read-only verification

All five SHA-256 hashes were checked against the [Phase 2R report](s08-paired-evaluation-results.md) before reading its tables:

| Frozen file in data/pilot/s08-paired-evaluation/ | SHA-256 |
| --- | --- |
| fold-readiness.csv | b419e1883269201a70fa78bd0aa398d56b0a18456147f587780edf719f280ed9 |
| target-predictions.csv | d7d7b774c1ce7c4f303820208fbed196f38fe058b0d1ad763c02e0f6880ea433 |
| model-fits.csv | 46300fa049333fb36d0eec96ec6d51669f9f6e8742e36be0fe231cd94cfc9726 |
| paired-scores.csv | c2d419f8cfadd1a91da5bc4380b7d29d55af1fae1ea1b04f8da2846431790b4e |
| stability.csv | 08176292218802df34225159fabe984ac0abbbacf7909aa5b928a882570519ad |

Base-R calculations were run transiently and printed to the session; no script or output was saved. Counts were computed from target-predictions.csv with its unchanged paired flag. Batch/player deletions were checked against every one of the 1,336 saved stability rows; all eight mean contrasts agreed with paired-scores.csv to 1e-12. Historical runners, fitting functions and suites were not invoked.

## Measured dependence and concentration

A participation is one appearance of a player in a scored match, in either neutral slot. Each match contributes two participations. A player–batch incidence edge exists if that player appears at least once in that scored batch; repeated matches within the batch do not add edges.

| Quantity | ATP | WTA |
| --- | ---: | ---: |
| Scored matches / batches | 211 / 4 | 1,067 / 14 |
| Unique players | 120 | 196 |
| Player-match participations | 422 | 2,134 |
| Matches per player: min / Q1 / median / Q3 / max | 1 / 1 / 3 / 5 / 14 | 1 / 2 / 7 / 17 / 52 |
| Players in multiple scored batches | 73 (60.83%) | 161 (82.14%) |
| Batches per player: min / median / max | 1 / 2 / 4 | 1 / 5 / 14 |
| Player–batch incidence edges | 255 | 1,163 |
| Matches touching a multi-batch player | 202 / 211 | 1,066 / 1,067 |
| Batch size: min / median / max | 48 / 49 / 65 | 47 / 83.5 / 107 |
| Largest batch share of matches | 30.81% | 10.03% |
| Largest two batches' combined share | 54.50% | 18.65% |
| Batch HHI / inverse HHI | 0.254554 / 3.9284 | 0.075434 / 13.2566 |
| Player participation HHI / inverse HHI | 0.013791 / 72.5098 | 0.009776 / 102.2947 |
| Largest player's match count / share | 14 / 6.64% | 52 / 4.87% |
| Top-five players' participation share | 61 / 422 = 14.45% | 223 / 2,134 = 10.45% |
| Unique matches touching those five players | 55 / 211 | 211 / 1,067 |

Batch HHI is `sum((n_batch/N)^2)`; player HHI is `sum((n_player/(2*N))^2)`. Their inverses describe concentration only, **not effective independent sample or cluster counts**. Top-player lists use descending participation count, breaking ties by source ID. The top five ATP IDs/counts are 207989/14, 206173/13, 200282/12, 100644/11 and 126205/11; WTA: 214544/52, 202468/48, 216347/42, 221103/41 and 214981/40. No single player accounts for a majority of match volume. Shared-player dependence remains extensive despite this.

The ATP batch labels/counts are 20230703/48, 20230807/48, 20230814/50 and 20230828/65. WTA: 20210809/47, 20210816/48, 20210830/80, 20211006/82, 20230116/88, 20230306/84, 20230320/85, 20230424/84, 20230508/84, 20230529/107, 20230703/83, 20230807/51, 20230814/52 and 20230828/92. These remain source labels, not inferred timing.

ATP players appear in exactly 1/2/3/4 batches with frequencies 47/28/28/17. WTA frequencies for 1 through 14 batches are 35/28/12/14/15/10/11/11/14/4/17/9/5/11. The long-slot tabulation independently reproduces all participation and incidence totals.

## Connectivity

Construct a bipartite graph whose vertices are scored batches and player IDs within tour. Connect both participants to their match's batch. ATP has **124 vertices, 255 edges, one connected component**; WTA **210 vertices, 1,163 edges, one connected component**. Every scored match belongs to its tour's sole component.

All six of six ATP batch pairs share players (30–39 shared players per pair). All 91 of 91 WTA batch pairs share players (26–83). Both the batch projection and a separate direct traversal of the bipartite graph produce the same component counts. WTA's saved seasons do not split it into independent components.

Connectivity is an incidence fact, not proof of perfect correlation or proof that every possible model-based uncertainty method is impossible. It does show that a partition preserving arbitrary whole-batch and recurring-player dependence cannot split either tour into multiple disjoint blocks. Lack of a graph edge would not, by itself, establish independence either: frozen walk-forward fits share earlier training information. No covariance strength or independence assumption was estimated or validated here.

## Does a few-unit contribution dominate each difference?

For each contrast, let `B_b=sum(d_i in batch b)` and `A_p=sum(d_i in matches involving p in either slot)`. Report concentration of **absolute net contributions**, not variance explained. The top-two batch share is the two largest absolute B values divided by `sum(abs(B))`; the top-five player share uses absolute A similarly. Player contributions overlap: each match enters two A values, and `sum(A)=2*sum(d)`. They must not be added as disjoint match shares. Cancellation inside or between units means these measures alone cannot determine robustness.

| Tour / comparator / loss | Mean difference | Top-two batch absolute-net share | Top-five player absolute-net share | Sign reversals: batch / player deletions |
| --- | ---: | ---: | ---: | ---: |
| ATP / primary / log loss | -0.0054933 | 73.47% | 19.01% | 0 / 1 |
| ATP / primary / Brier | -0.0034229 | 74.09% | 16.35% | 0 / 0 |
| ATP / overall / log loss | -0.0005342 | 76.05% | 19.97% | 1 / 46 |
| ATP / overall / Brier | -0.0016932 | 71.14% | 17.13% | 1 / 1 |
| WTA / primary / log loss | +0.0039396 | 31.82% | 12.57% | 0 / 0 |
| WTA / primary / Brier | +0.0009517 | 31.57% | 11.36% | 2 / 3 |
| WTA / overall / log loss | +0.0156199 | 34.94% | 15.25% | 0 / 0 |
| WTA / overall / Brier | +0.0060530 | 32.26% | 13.74% | 0 / 0 |

ATP's two largest batch net contributions account for over 71% in every contrast, from only four batches. Its tiny overall-Elo log-loss difference is especially cancellation-sensitive: the largest absolute batch sum is 19.71 times the absolute total net difference, and the largest player's sum is 14.31 times it. Those ratios are not percentages of independent evidence. Deleting Canada changes that mean to +0.0129345; deleting player 200282 changes it to +0.0075409. ATP primary log loss reverses when player 200282 is removed, but primary Brier does not reverse under any single deletion.

WTA net contributions are less concentrated by these measures; neither log-loss contrast changes sign under any single saved deletion. Nonetheless primary Brier reverses under two batches and three players. The largest absolute WTA primary log-loss deletion change comes from the 2021 US Open batch (80 matches): +0.0039396 becomes +0.0084350. WTA overall log loss remains positive after every deletion; player 214544 removes 52 matches and changes it to +0.0117095. These facts do not establish a stable population effect or validate intervals. A few units can control a small net contrast even without dominating match volume; conversely, absence of single-deletion reversal is not independence or uncertainty calibration.

## One candidate assessed, not adopted

**Candidate: joint batch–player connected-component block bootstrap of frozen paired scores.** This is the sole candidate assessed. Build components using both incidence dimensions above, retain each original paired match row and all model scores together, and hypothetically resample/reweight whole components using one shared component weight for every contrast. Preserve the original source-label fold assignments and frozen predictions; never refit, shuffle chronology, split simultaneous batches or assign a match to one arbitrary player. The hypothetical mean would use the weighted match numerator divided by the weighted match count, preserving the match-weighted estimand rather than averaging component means.

Keeping linked units together avoids pretending a shared player is two slot-specific clusters. Its necessary extra assumptions would include an appropriate joint repetition law, independent/exchangeable component contributions under that law, and enough non-dominating components for calibrated inference. The graph cannot verify those assumptions. This is an assessed conservative construction, not a claim of a validated off-the-shelf estimator.

**Small-cluster handling and failure rules:** with fewer than two components, stop immediately; do not emit an interval, degrees-of-freedom correction or zero-variance assurance. Two components would merely escape this algebraic failure, not establish adequate support. Any later claimed sufficiency threshold must be justified prospectively for the actual design and target, with synthetic validation, rather than inferred from the number of matches or players. Degenerate resamples, unidentified variance, excessive concentration, invalid weights or failed coverage/false-positive calibration would also block use; no silent clipping, cluster reassignment or IID fallback.

Here there is **one component per tour**. Repeating or positively reweighting the only component makes the weighted numerator and denominator change by the same factor, leaving every mean unchanged. This algebraic degeneracy was identified without drawing resamples or calculating an interval. Pooling ATP and WTA to manufacture two blocks would change the tour-specific estimands and is prohibited. Four ATP batches and fourteen WTA batches cannot be treated as independent replacement blocks when the candidate preserves all recurring-player links.

Before any future use, a separately approved validation must prespecify the joint simulation law, nominal coverage/error levels, replication budget, Monte Carlo tolerances, seeds and rejection criteria. It must examine coverage and false-positive behavior under null paired differences, alternative differences, heterogeneous and dominant batches, skewed player participation, cross-slot recurrence, shared-player covariance, and one/few-component degeneracy. Simulations must preserve paired rows and frozen chronological predictions. They must fail rather than output a reassuring interval when independent replication is absent. No simulation was performed, and favorable simulation under invented assumptions would not establish those assumptions for this cohort.

Ordinary IID or match bootstraps, event-only resampling, one-slot clustering and standard two-way formulas are not substituted or assumed to solve the registered dependence. No second candidate is evaluated.

## Terminal decision and next executable phase

**UNCERTAINTY_NOT_ESTABLISHED_RETAINED.** Failed requirements are non-degenerate joint dependence blocks (one per tour), a justified conditional repetition/independence law, and validated small-cluster coverage/false-positive behavior. The candidate preserves pairs and both dependence dimensions structurally but fails support. This does not claim that every possible future uncertainty method is impossible; none is defensible from this bounded saved-evidence assessment. No interval method is authorized. Existing point estimates and score-deletion descriptions remain conditional descriptive evidence only; no superiority or factor-selection claim follows.

Recommend **Phase 2T: bounded M05 direction diagnostic using frozen Phase 2R evidence**. Since the current uncertainty route fails, address the already observed ATP-negative/WTA-positive M05 coefficient contrast without forcing intervals or changing factors. Examine saved fold coefficients, training predictor relationships and available opportunity/history-depth records; distinguish measured associations from unsupported causal explanations. This diagnostic would not repair the uncertainty limitation or authorize factor selection.

Exact approval language: **“Approve Phase 2T: diagnose the ATP/WTA M05 coefficient-direction difference using frozen Phase 2R coefficients and authorized saved feature/history evidence only. Report descriptive fold, predictor and opportunity patterns without refitting, tuning, changing factors or eligibility, or calculating intervals. Retain UNCERTAINTY_NOT_ESTABLISHED and source-label limitations. Do not acquire data, add dependencies, access 2024/2025, resume OTD or modify the portfolio.”** The next prompt must specify its exact file/output scope before execution.

## Validation and preservation

Five source hashes, all 2,580 unique target IDs and the 211/1,067 paired counts were verified. Two independent tabulations agreed on player participation and incidence totals; batch-projection and direct bipartite traversals agreed on connectivity. All eight saved mean differences and 1,336 saved deletion rows were checked. One transient display initially omitted top-player IDs because its count vector lacked names; an independent named table corrected the display without changing any count or saved artifact.

Documentation agreement, 16 local links/anchors, whitespace and the exact four-file scope passed. All 297 other pre-existing tracked files and pilot artifacts retain their SHA-256 hashes. Historical status/contract content is unchanged apart from the contract current/completed label; no pilot file was added or changed. The complete diff was inspected. No new code, dependency, generated output, confidence interval, refit, tuning, factor/eligibility change, source acquisition, inferred timestamp, 2024/2025 access, OTD, portfolio modification or publication occurred. S02 remains paused and S08 provisional. The Phase 2R runner, tests, protocol, results report and all five ignored outputs are preserved byte-for-byte. Only the three authorized current-governance documents are updated alongside this new assessment; no historical suite was rerun or repinned.
