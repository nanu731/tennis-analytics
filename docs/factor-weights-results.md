# Phase 2AN: descriptive Four Factors weights on Net Point Rating

## Result

Within a match, the four S08 differences together account for most of the variation in Net Point Rating (NPR). In the 2021–2023 development fits, R² is 0.873 for ATP and 0.896 for WTA. Shapley/LMG allocation splits that explained variation in the same order in both tours and every tested context: **M03 > M11 > M12 > M05**.

| Tour (development n) | M03 first-serve win share | M11 break chances created | M12 break-point conversion | M05 double-fault rate | Full R² |
| --- | ---: | ---: | ---: | ---: | ---: |
| ATP (773) | 44.0% | 36.7% | 17.1% | 2.2% | 0.873 |
| WTA (1,655) | 47.3% | 34.2% | 15.9% | 2.7% | 0.896 |

Shares are percentages of the full-model R², averaged over all 24 predictor orderings. Source: `weights.csv`, primary development full-set NPR rows.

Under the prespecified strict rule, all four components hold their expected direction, keep a positive unique R² increment and pass the collinearity gates in all 425 ATP and 490 WTA assessed contexts. Label: **FOUR_DISTINCT_STABLE_FACTORS_SUPPORTED_DESCRIPTIVELY_ON_NPR**.

**What this does not show.** These are same-match explanatory shares, not forecast importance and not causal effects. The S08 differences are built from the same points that make up NPR, so a high same-match R² is partly mechanical. The protocol states that same-match association alone cannot qualify a factor ([Phase 2B](four-factors-definition-protocol.md#association-and-incremental-value-rules)). As forecasters, models built on these components had higher loss than surface Elo on the locked 2025 test ([results](2025-locked-final-evaluation-results.md#result)). **UNCERTAINTY_NOT_ESTABLISHED:** there are no intervals. No practical-effect margin is registered, so this report cannot call M05's 2–3% share negligible or meaningful. No final factors or weights are selected. S08 remains provisional, and **M05_CROSS_TOUR_DIRECTION_REQUIREMENT_NOT_SATISFIED** stays binding.

## Data and method

- **Rows.** Admitted development matches (2,580: ATP 2023, WTA 2021/2023) and 2024 matches (1,901: ATP 944, WTA 957). No 2025 data or outcome was read; the runner names no 2025 input and the tests check this.
- **Metrics.** Same-match S08 differences come from the frozen effective counts through the pinned [Phase 2J](broader-shortlist-revalidation.md#frozen-inputs-estimand-and-reconstruction) helpers (`bj_samples`, `bj_pair`, `bj_side`). The 2024 rows use the same pair function. Applied to the development inputs, the 2024 row builder reproduces the Phase 2J development sample exactly. The headline ATP and WTA S08 coefficients, R² and increments reproduce the committed Phase 2J values.
- **Missing values (decision 2).** Complete cases only, as in Phase 2J: an M12 with zero break-point opportunities stays undefined and drops that row. Nothing is imputed. M12 is the only cause of dropped rows (`dropped-rows.csv`):

| Tour / split | Admitted | Complete | M12 undefined |
| --- | ---: | ---: | ---: |
| ATP development | 846 | 773 | 73 |
| ATP 2024 | 944 | 866 | 78 |
| WTA development | 1,734 | 1,655 | 79 |
| WTA 2024 | 957 | 912 | 45 |

- **Model.** Ordinary least squares of NPR on centered, unit-SD predictors, standardized within each fitted sample as in Phase 2J, separately by tour. Coefficients are NPR points per one-SD difference. LMG/Shapley is implemented directly in base R: each term's average R² gain over all k! orderings (24 for the full set, 6 for reduced). The shares do not depend on predictor scaling.
- **Splits (decision 1).** The headline is the development fit. 2024 is a separate out-of-time check in two forms: a refit on 2024 alone, and the development coefficients and scaling applied unchanged to 2024. 2024 is never pooled into the headline.
- **Sensitivity (decision 4).** Equal-phase NPR, `100*(service points won % − opponent's service points won %)`, using the Phase 2J formula.
- **M05 (decision 5).** Reported with its estimated sign and share, without constraints or reinterpretation.

## Out-of-time check

| Tour | Set | Development R² | Development fit applied to 2024 | 2024 refit R² |
| --- | --- | ---: | ---: | ---: |
| ATP | Full | 0.8734 | 0.8892 | 0.8899 |
| ATP | Reduced | 0.8668 | 0.8812 | 0.8816 |
| WTA | Full | 0.8959 | 0.8954 | 0.8960 |
| WTA | Reduced | 0.8863 | 0.8897 | 0.8898 |

The 2024 refits keep the same share order. M03 / M11 / M12 / M05 shares: ATP 45.5 / 36.8 / 15.6 / 2.1%, WTA 46.1 / 33.0 / 18.0 / 2.8%. The M05 coefficient is negative in all four primary fits (development −0.979 ATP and −1.449 WTA; 2024 −1.056 and −1.164 NPR points per SD). Sources: `stability.csv` (OUT_OF_TIME, TERM_STABILITY) and `weights.csv`.

Dropping M05 lowers R² by 0.007 ATP and 0.010 WTA in development; the reduced set's shares are M03 44.3 / M11 38.1 / M12 17.6% ATP and 47.9 / 35.5 / 16.6% WTA.

## Stability (development and 2024, full set, NPR)

Every context refits and restandardizes on its retained rows. Player deletion removes every match involving that player, in either slot.

| Context | ATP M05 share range | WTA M05 share range | Direction failures / lost increments / rank changes |
| --- | --- | --- | --- |
| Season slices | 2.2% (2023 only) | 1.8–3.5% | 0 / 0 / 0 |
| Surface slices, development | 2.0–4.5% | 2.3–3.5% | 0 / 0 / 0 |
| Surface slices, 2024 | 1.0–3.1% | 0.9–3.3% | 0 / 0 / 0 |
| Leave one event out (10 per tour-split) | 1.7–2.8% dev; 1.7–2.4% 2024 | 2.5–3.0% dev; 2.5–3.2% 2024 | 0 / 0 / 0 |
| Leave one player out (189/206 ATP, 266/193 WTA) | 2.0–3.1% dev; 1.9–2.5% 2024 | 2.3–2.8% dev; 2.3–3.6% 2024 | 0 / 0 / 0 |

The other shares stay in narrow bands. Across leave-one-player-out deletions, M03 ranges 43.6–44.4% ATP and 47.1–47.6% WTA. Surface slices vary more: ATP development M03 ranges 37.0% (grass, 53 matches) to 48.3% (clay). The equal-phase sensitivity shows the same pattern with no direction failure or lost increment. It has one rank change: the M03/M11 order swaps in one ATP development surface slice.

Collinearity (`diagnostics.csv`): the largest primary-fit correlation is M03 with M11 (Pearson 0.67–0.70). Maximum primary VIF is 3.01 and maximum condition index 3.22. Across all 1,830 fitted contexts, no gate fails. One context gets a PRACTICAL_REVIEW flag: ATP development grass, both sets, 53 matches, maximum correlation 0.835.

**Four or three?** The rule, fixed before results, is the strictest reading of the [Phase 2B stability plan](four-factors-definition-protocol.md#stability-and-uncertainty-plan): any expected-direction failure, lost numerical increment (at most 1e-10) or failed gate in any context makes a factor unstable, with no materiality margin. All four pass in both tours, so on this same-match NPR evidence **four distinct components are supported descriptively; the evidence does not reduce to three.**

Two boundaries apply. The assessed contexts are the ones requested (tour, season, surface, leave-one-event-out, leave-one-player-out); single-event fits were not part of this set. Phase 2J reported M05 NPR reversals in some single-event cells, for S08 at ATP Miami and WTA 2023 Canada ([Phase 2J](broader-shortlist-revalidation.md#same-match-winning-diagnostics-and-stability)). ATP season stability is also not assessable, because development has ATP 2023 only.

## Uncertainty (decision 3)

Following the [Phase 2S reasoning](dependence-aware-uncertainty-feasibility.md#one-candidate-assessed-not-adopted), only blocks that keep events and recurring players together could support a dependence-aware resampling interval. The event–player graph has **one connected component** in each of the four tour/split samples: all 10 events and all 189–266 players are linked. Resampling a single block cannot change any estimate, so a joint block interval is degenerate. No IID, event-only or one-slot interval is substituted. **UNCERTAINTY_NOT_ESTABLISHED.** Deletion ranges are influence checks, not intervals.

## Interpretation boundaries

- These are explanatory weights for same-match point dominance. They are not forecast weights, and they do not change the locked 2025 forecast result.
- M05's negative coefficient means that, holding the other three fixed, a higher double-fault rate goes with lower same-match NPR. It does not resolve the mixed 2024 forecast-coefficient signs, so the M05 direction requirement remains unmet.
- Coefficients and shares are associations, not causal effects.
- No final factors or weights are selected, and SELECTION_UNRESOLVED, S02 paused and S08 provisional are unchanged.

TODO_USER_COPY: your interpretation of what these weights mean for how you describe player strengths.

## Outputs and verification

Four ignored outputs are under `data/pilot/2an-factor-weights/`:

| Output | Rows | SHA-256 |
| --- | ---: | --- |
| weights.csv | 12,810 | `525b8590e385f8355cbd016b583fff5dbd4b4ca708fc7a69c789f1211829f37d` |
| stability.csv | 37 | `6f2b66aa4a6c15b8cb3e5ceb297c1125c62783bb8475c34804e8b0cda31537f8` |
| diagnostics.csv | 116 | `b7246b5caa1367131010582fa3b34884b26650aee3dc0416967b84e6516950f8` |
| dropped-rows.csv | 13 | `d6cb94e3bf722c2b7a819de11c06d32adf982b5791f3470346ddfefb19ac1323` |

The [runner](../R/run_2an_factor_weights.R) pins nine inputs and authorities, and Phase 2J's own 69 pins verify on load. The [tests](../R/test_2an_factor_weights.R) pass **3,750 checks**. They cover:

- the ordering average against an independent subset-weight Shapley formula fitted with `lm()`;
- R² additivity, term-order, affine and slot-swap invariance, and orthogonal-predictor truth cases;
- rank-failure handling with no fabricated shares;
- exact reuse of the Phase 2J reconstruction and Phase 2J value reproduction;
- development-only headline fits, with a 2024-outcome permutation positive control, and independent held-out R²;
- the rows retained in every deletion and slice, and restandardization on retained rows;
- stability recomputation and verdict truth cases;
- event–player component counting;
- atomic install guards and a byte-identical independent rerun.

No historical suite was rerun or repinned.
