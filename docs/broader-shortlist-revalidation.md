# Phase 2J: broader-cohort shortlist revalidation

Version 1.0.0. Offline, descriptive implementation from `7368be949340186801f2108250580f5f18fb49be`. The Phase 2J prompt explicitly authorizes these fits; the prior Phase 2I prohibition on further modeling described its then-current authority, not this later approval. No historical document, admission rule or release was rewritten.

## Result and decision

**S02_PAUSED_FOR_PRESPECIFIED_FAILURE.** S02 (M01 + M05 + M11 + M12) fails the registered positive conditional winning-direction requirement for M01 in the warning-free ATP primary logistic diagnostic: standardized log-odds coefficient **−0.041131**, versus **+0.500106** in WTA. The ATP coefficient remains negative in **8/10 leave-one-cell-out** and **185/189 leave-one-player-out** fits. These repeated observations corroborate a direction failure; they are not independent replications or a new numerical stability cutoff. This is a provisional pause, not evidence of a statistically established adverse effect.

S08 (M03 + M05 + M11 + M12) remains provisional. Higher descriptive R-squared does not select it or establish stable future value. Neither alternative fails primary NPR directions, computability, rank or numerical collinearity gates. No shared-family revision is triggered by a primary failure in both sets. Isolated cell-level M05 reversals and logistic instability remain unresolved; the shared family has not received a final stability pass.

**Decision implementation disclosure:** the initial in-memory decision mapping covered primary NPR but omitted the separate registered winning-direction requirement. After inspecting the logistic results, this omission was corrected before release. No expected sign, numerical threshold or practical-effect margin was changed. The label refers to the previously registered direction requirement, not a claim that this entire software mapping was frozen before results inspection. A warning-bearing logistic fit cannot force a direction pause. No count defining “repeated stability failure” was registered, so all deletion failures are reported without inventing such a cutoff. This interpretation of the existing direction requirement is explicit and reviewable.

M05 remains second-serve security, M11 provisional return pressure and M12 break-point conversion/execution, not established recovery, resilience or clutch performance. M03 is outcome-coupled. Historical S02 definitions/results remain intact, as do the prior pauses, M07 sensitivity and M08/M15 benchmarks. No final factors, weights or practical-effect thresholds are selected.

## Frozen inputs, estimand and reconstruction

The versioned base-R runner verifies literal SHA-256 pins before reading and before output release. Pins cover the Phase 2H membership, effective-count disposition ledger and six outputs; Phase 2F code, tests and 14 outputs; Phase 2I code, tests and two outputs; source manifests, saved evidence and relevant protocols. Only allowlisted pure Phase 2F numerical functions are evaluated: the historical empirical runner and its old authority check are never invoked. `PROJECT_CONTEXT.md` is intentionally outside this new pin set because it is an authorized changed authority document; its historical version remains at the starting commit. The 669/105/82-check historical records are preserved, not rerun or repinned.

All **2,580 admitted matches in 30 event cells** are reconstructed from frozen effective counts, including existing bounded overrides. The 342 excluded panel records, including all 237 service-game conflicts, remain excluded. Raw values, identifiers, player spellings, recovery scope and membership do not change. The estimand is conditional on authorized source presence, Phase 2H eligibility and complete required denominators; it is not all matches played. Official recall remains UNKNOWN without a saved official denominator. Nothing here passes the official complete-event coverage gates.

For a player's counts: M01 = aces/service points; M03 = first-serve points won/first serves in; M05 = double faults/(service points − first serves in); M11 = opponent break points faced/opponent service games; M12 = (opponent break points faced − saved)/opponent break points faced. Every predictor is neutral slot A minus slot B. M12 is undefined when either side has zero opportunities; no zero substitution or imputation is used.

If `sA` and `sB` are service points played and `wA` and `wB` service points won, A's total points won is `wA+sB-wB`, B's is `wB+sA-wA`. NPR is 100 times their difference divided by `sA+sB`. Equal-phase NPR is `100*(wA/sA-wB/sB)`. Slot swapping negates all five differences and both outcomes, and complements winning. All 231 overlapping Phase 2F pilot rows reproduce their saved metric/outcome values and undefined masks within the preserved tolerance.

## Availability and denominator filtering

One row per admitted match is retained in `analysis-samples.csv`; both sets and all full/reduced comparisons use the **same common-complete sample**. M01/M03/M05/M11 and both NPR outcomes are defined for all 2,580. Only M12 removes rows from fitting: **73/846 ATP** and **79/1,734 WTA**, giving **773 ATP and 1,655 WTA** (2,428 total). WTA contributes 783/825 in 2021 and 872/909 in 2023. These are metric availability fractions within admitted source records, not official event coverage. Pairwise availability of the four non-M12 predictors exceeds model availability; no coefficient or increment is compared across those differing samples.

| Tour / season | Surface | Admitted | Common complete | M12 undefined |
| --- | --- | ---: | ---: | ---: |
| ATP 2023 | Clay | 305 | 284 | 21 |
| ATP 2023 | Grass | 56 | 53 | 3 |
| ATP 2023 | Hard | 485 | 436 | 49 |
| WTA 2021 | Clay | 228 | 221 | 7 |
| WTA 2021 | Grass | 100 | 94 | 6 |
| WTA 2021 | Hard | 497 | 468 | 29 |
| WTA 2023 | Clay | 302 | 294 | 8 |
| WTA 2023 | Grass | 92 | 89 | 3 |
| WTA 2023 | Hard | 515 | 489 | 26 |

Every authorized cell is present. Entries below are **common complete / admitted**, not tournament recall.

| Event | Surface | ATP 2023 | WTA 2021 | WTA 2023 |
| --- | --- | ---: | ---: | ---: |
| Australian Open | Hard | 119/126 | 117/126 | 118/127 |
| Canada | Hard | 49/54 | 49/49 | 51/53 |
| Cincinnati | Hard | 46/50 | 48/49 | 52/52 |
| Indian Wells | Hard | 79/91 | 85/91 | 87/91 |
| Madrid | Clay | 83/94 | 57/58 | 92/93 |
| Miami | Hard | 74/89 | 84/89 | 88/92 |
| Roland-Garros | Clay | 118/119 | 114/119 | 115/119 |
| Rome | Clay | 83/92 | 50/51 | 87/90 |
| US Open | Hard | 69/75 | 85/93 | 93/100 |
| Wimbledon | Grass | 53/56 | 94/100 | 89/92 |

M12 opportunity quartiles across admitted rows are 4/7/11 for both ATP slots and 5/8/11 for both WTA slots; minima are zero. Maxima are ATP A/B 26/28 and WTA 33/30. All five numerator/denominator pairs for both slots remain in the ignored sample file. Small positive denominators are retained; no new denominator threshold is introduced.

## Numerical gates and descriptive NPR fits

Predictors are centered and scaled to unit sample SD within each actual fitted context. The original numerical rank tolerance, near-constant detection and rounded-tie Spearman convention are reused. Absolute Pearson or Spearman correlation reaches review at .80, warning at .90, and near-redundancy failure at .95; VIF concern is 5 and unacceptable is 10; condition-index failure is 30. Rank/constant/near-constant failures take precedence. The intercept is excluded from standardized condition indices.

| Tour / set | n | Maximum VIF | Maximum condition index | Maximum absolute correlation |
| --- | ---: | ---: | ---: | ---: |
| ATP S02 | 773 | 1.188 | 1.578 | .341 |
| ATP S08 | 773 | 2.623 | 2.948 | .699 |
| WTA S02 | 1,655 | 1.184 | 1.577 | .338 |
| WTA S08 | 1,655 | 3.014 | 3.218 | .704 |

All primary and deletion designs pass. No design has a rank or numerical failure. Two distinct ATP S08 slices require correlation review: grass/Wimbledon (the same 53 rows, maximum .835) and US Open (69 rows, .857). Their VIFs are 3.689/4.425 and condition indices 3.746/4.179. They remain flagged; the shared-count interpretation and unresolved precision prevent a blanket slice-stability claim.

Coefficients below are NPR percentage points per one-SD difference, **not weights**. Each parenthesis is full minus reduced R-squared on identical rows; shared variance is not allocated. The coefficient order is serve term, M05, M11, M12.

| Tour / set | Full R² | Serve coefficient (increment) | M05 | M11 | M12 |
| --- | ---: | ---: | ---: | ---: | ---: |
| ATP S02 | .813816 | .849647 (.004427) | −.566678 (.002255) | 8.572576 (.454322) | 5.539466 (.212966) |
| ATP S08 | .873445 | 4.802600 (.064056) | −.978541 (.006606) | 5.414708 (.089385) | 3.989444 (.086590) |
| WTA S02 | .833139 | 1.266512 (.006504) | −1.019324 (.004837) | 10.689857 (.463273) | 7.337249 (.242408) |
| WTA S08 | .895899 | 6.595559 (.069265) | −1.448609 (.009638) | 6.294356 (.071449) | 4.653717 (.064309) |

The primary equal-phase R² values are ATP .818636/.881661 and WTA .833877/.899482 (S02/S08). Event-cell fixed effects are a sensitivity: K−1 treatment-coded indicators, lexical first cell as reference, same controls retained in every reduced model. Actual-design VIF/condition checks include standardized dummy columns; fitted dummy coefficients retain their 0/1 contrast interpretation. FE NPR R² is ATP .820017/.876382 and WTA .835288/.897141; FE equal-phase R² is ATP .824612/.884384 and WTA .835749/.900632. All primary sensitivity factor signs agree with expectations. The largest FE VIF/condition index is 3.045/4.923, both below concern. Full, adjusted and reduced R², partial R², intercepts and factor slopes are saved.

## Same-match winning diagnostics and stability

| Tour / set | Serve slope | M05 | M11 | M12 | Apparent log loss | Apparent Brier |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP S02 | −.041131 | −.184620 | 4.264955 | 2.939248 | .225667 | .068777 |
| ATP S08 | 1.189175 | −.312967 | 3.477483 | 2.654020 | .212469 | .065292 |
| WTA S02 | .500106 | −.374498 | 5.505971 | 4.058313 | .160908 | .047189 |
| WTA S08 | 2.487526 | −.600014 | 4.545510 | 3.671518 | .138021 | .040380 |

All four primary fits converge without warnings, boundary flags, extreme probabilities or a separation witness. Absence of a detected witness is not proof that separation is absent. These are same-match apparent losses, not forecast scores, held-out improvement or calibration validation.

**29 distinct context/set fits are unstable:** 25 event-cell, two season and two surface fits. Ten have a complete-separation witness and nonconvergence: both sets for ATP grass and ATP Wimbledon (duplicate context), ATP US Open, WTA 2021 US Open and WTA 2023 US Open. Remaining warning-bearing contexts include ATP Cincinnati (both); WTA 2023 season (both); WTA 2021 Indian Wells (S08), Roland-Garros/Wimbledon (both); WTA 2023 Australian Open/Indian Wells/Rome (both), Cincinnati/Madrid/Roland-Garros/Wimbledon (S08). All 29 record the numerical-zero-or-one probability warning; exact extreme counts and warning text are retained, including zero extreme counts under the stricter machine-epsilon flag. No penalized replacement is fitted. Unstable estimates are descriptive warnings, not reliable evidence for directional selection.

The common samples contain **189 ATP and 266 WTA players**. For each set/outcome, refits omit each of 10 ATP/20 WTA cells and each player, removing **every match in either player slot**. All 970 logistic deletion fits are warning-free; 1,940 NPR/equal-phase deletion fits have no direction reversal, numerical increment loss, rank or collinearity failure. Every refit recomputes scaling on retained rows. These overlapping deletions are influence checks, not independent samples or uncertainty intervals.

ATP S02's negative M01 win slope becomes positive under two cell and four player omissions; those are reversals relative to its negative primary estimate, while improving agreement with the expected positive sign. Other primary winning factors keep their expected signs in deletion fits. Individual-cell NPR/equal-phase reversals nevertheless occur: S02 M01 at ATP Cincinnati and WTA 2021 Canada; M05 at ATP Miami (both sets, NPR only), ATP Rome (S02), WTA 2021 Madrid (S02), WTA 2023 Canada (S02 both outcomes, S08 NPR), WTA 2023 Cincinnati (S02 NPR), and WTA 2023 US Open (S02). All other listed reversals affect both NPR outcomes unless specified. Individual-cell winning reversals are also retained in the stability output, including shared M05 reversals. These do not establish an across-cohort failure of the shared family and cannot be dismissed as proven noise.

## Uncertainty, limitations and next executable step

**UNCERTAINTY_NOT_ESTABLISHED** applies throughout. No defensible player-and-event-aware interval procedure was prespecified and validated within this bounded implementation. Base R is not intrinsically incapable of one; choosing and validating such a method is additional methodological work. No IID p-values, ordinary intervals, independent-match bootstrap or deletion ranges are substituted for valid uncertainty. Practical-effect thresholds remain pending. Small sign deviations cannot be called materially negative or statistically significant.

ATP season stability is unavailable (2023 only). WTA 2021/2023 slices are observed comparisons, with no 2022 cohort. Actual within-event chronology, cutoff-valid features, future-match value, independent out-of-time performance, Elo comparisons and final weights remain unavailable. Positive same-match NPR fits share underlying counts and do not prove distinct mechanisms. Source inclusion, conservative completion/count exclusions and structural M12 filtering can select matches systematically; the service-game exclusions disproportionately affect some events. No absent match is imputed and source retention is not official recall.

**One recommended next phase: Phase 2K, offline chronology and pre-match availability audit.** Using only the existing authorized saved sources and frozen 2,580 IDs, produce a reproducible temporal-evidence ledger that distinguishes actual match dates/times from event start dates, documents whether each match can be ordered safely without outcome information, and reports unresolved ordering/cutoff gaps by cell. Do not invent times, build histories, refit factors, forecast or fetch missing evidence. This addresses a concrete prerequisite for testing S08's future value; it does not resolve uncertainty or reinstate S02.

**Exact approval required:** “Approve Phase 2K: an offline chronology and pre-match availability audit of the frozen Phase 2H cohort using only already authorized saved evidence, with a versioned R audit, focused tests, an ignored temporal-evidence ledger and aggregate report. Preserve all memberships and historical releases; do not acquire evidence, infer missing times, build histories or fit forecasting models.” The next prompt must specify its exact file/output scope. New statistical interval methods, factor revisions, histories, ratings and forecasting still need their own approval.

## Validation and release

Focused validation covers frozen pins, independent formula fixtures, undefined denominators, all-row slot swaps, reproduction of the 231 pilot rows, common samples, actual-design gates, independent full/reduced OLS comparisons, both-slot player deletion, every event/player refit, decision precedence, warning-bearing logistic handling and independent byte-identical full reruns. Historical suites were not run. **612 focused checks passed**, including two independent full builds with identical SHA-256 hashes for all five serialized outputs. All **69 pinned inputs** verified. A separate pre-task baseline check confirmed **134 unchanged historical files** retained their SHA-256, size and modification time; only the two authorized source-of-truth edits were exempted. The status history after `CURRENT_SNAPSHOT_END` is byte-identical to the starting commit. All five output paths remain Git-ignored; the complete tracked diff is the five-file scope below. Whitespace checks pass.

Only the five requested tracked files form this phase: the runner, its focused tests, this report, `PROJECT_CONTEXT.md` and the current `docs/status.md` snapshot. The five ignored output tables contain 2,580 / 15,534 / 8,448 / 5,260 / 12,656 rows respectively (analysis samples, collinearity, NPR increments, same-match win, stability/decision). All were inspected through complete summary/group checks and flagged-context review. No extra match-level release or output file is created.


Release SHA-256 fingerprints:

| Output | SHA-256 |
| --- | --- |
| analysis-samples.csv | `51ea4947dc1a8eeb53507dff19a6e0c756da263a7ac36121c4a909717eba1209` |
| collinearity.csv | `855e17d0f42390292fba687a25e13471c087d267135453d508a9f61611633788` |
| npr-increments.csv | `cc7ce39361fbfb3464482278b6be6a59075229516379bb6169de849c7bcfbe20` |
| same-match-win.csv | `bc60bcd950ba2c271a579850155ee2b4ac69beed073be5f3da7d0fe13bb864f3` |
| stability-and-decision.csv | `8f36e5fc403eab6196c203702a748e72c7eb5a53a221db51f6553c2b1c5d4b4c` |

Development issues resolved before release: the pure-helper loader initially needed a symbol guard for non-symbol assignment targets; the independent OLS reference needed the same intercept convention; editing a running test script caused a parse interruption. The final saved scripts passed cleanly from start to finish. These were implementation/test defects, not changes to frozen evidence. The logistic warnings and decision-mapping limitation described above remain substantive and are not suppressed from the release.
