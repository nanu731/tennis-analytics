# Phase 2P: fixed event-batched surface Elo audit

Version 1.0.0. Implemented offline in base R from clean `main` at `0ccea947232283cf43edcdd2b507c17aa16b332b`, under the explicit Phase 2P prompt approving [Phase 2O's fixed specification](surface-elo-common-evaluation-decision.md). This is a probability, state-update and coverage audit, **not a performance evaluation**. No prediction is scored and no parameter is tuned.

Every output carries **SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY** and **NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE**. S02 remains paused; S08 remains provisional. Neither deployment readiness nor verified historical information availability follows.

## Implementation and authority boundary

Sixteen literal SHA-256 pins cover current instructions/context, the Phase 2O and 2L decisions, Phase 2H/M/N reports, the Phase 2M builder and three outputs, Phase 2N's three outputs, and Phase 2H membership/dispositions. These are checked before input processing and output installation. Saved Phase 2H results, Phase 2M targets/memberships and Phase 2N completeness are the only record inputs. No annual source file, 2024/2025 file or network source is opened.

The builder imports only seven allowlisted pure definitions/constants from the pinned Phase 2M code. It does not run old authority checks, historical runners or suites; the historical PROJECT_CONTEXT.md pin remains unchanged. It verifies exact frozen metadata and the full membership/empty ledger, allowed labels/surfaces and S08 completeness/reason agreement. Missing, duplicated, excluded or conflicting records fail closed. Frozen winner/loser identities identify neutral A's binary result solely for post-batch updates. Scores, count magnitudes, rankings, best-of and prestige do not enter Elo arithmetic or selection.

Overall and surface states start at 1500 independently for each tour/player and tour/player/surface. Probabilities use `1/(1+10^((R_B-R_A)/400))`. The primary rating is `R=0.5*G+0.5*S`; the sole sensitivity uses G. Overall deltas are `32*(y-p_G)` and surface deltas `32*(y-p_S)`, using their own component expectations. The primary probability is not an average of probabilities and is not substituted into update expectations.

All targets in one same-tour/source-date batch read frozen states before any result is used. Match deltas are summed in canonical match-ID order and applied after the complete batch; this ordering stabilizes floating-point serialization, not chronology. No averaging, clipping, within-event update, experience-dependent K, season reset, inactivity, decay, margin or format adjustment is applied. Untouched surfaces retain their states. Unseen surfaces begin at 1500 rather than copying current overall strength. WTA state carries from saved 2021 to 2023 without filling missing 2022.

All 2,580 admitted matches update both players' overall and played-surface states, including the 554 outside the common S08 feature cohort. The S08 subset does not restrict Elo training history. Target probabilities contain no outcome column. The ignored update ledger is outcome-derived and auditable; it is not represented as outcome-free or publication-approved.

## Measured probability and cold-start coverage

All **2,580 targets** receive finite primary and overall-only probabilities. The S08 strata remain **2,026 BOTH_COMPLETE**, **284 ONE_COMPLETE**, **270 NEITHER_COMPLETE**. No failed target, nonfinite probability or exact 0/1 probability occurred. These are coverage/implementation findings, not calibration or accuracy findings.

| Tour | Targets | Both / one / neither S08 complete | Overall cold slots | Target-surface cold slots | Both / one / neither overall cold targets | Both / one / neither surface cold targets |
| --- | ---: | --- | ---: | ---: | --- | --- |
| ATP | 846 | 612 / 103 / 131 | 356 | 679 | 129 / 98 / 619 | 282 / 115 / 449 |
| WTA | 1,734 | 1,414 / 181 / 139 | 449 | 1,005 | 135 / 179 / 1,420 | 342 / 321 / 1,071 |
| Total | 2,580 | 2,026 / 284 / 270 | 805 | 1,684 | 264 / 277 / 2,039 | 624 / 436 / 1,520 |

Cold counts refer to target-player slots, not distinct people or career debuts. There are 879 slots with overall experience but no target-surface history. Both overall-cold players yield probability 0.5; one cold player is compared against the opponent's existing state. Two surface-cold players can still have unequal blended ratings through overall history. Fixed Elo priors do not impute any missing S08 rate.

| Tour | Primary A-probability range | Overall-only A-probability range |
| --- | --- | --- |
| ATP | 0.1786925–0.8036696 | 0.1343175–0.8462352 |
| WTA | 0.1250763–0.8591868 | 0.0941618–0.9008275 |

These ranges use the frozen neutral A orientation; B probabilities are complements. No loss, discrimination, calibration, win-rate association or outcome-conditioned performance statistic was calculated. Detailed coverage includes zero-size S08 strata by tour, season, batch, event and surface rather than dropping absent subgroups.

## Rating and update diagnostics

There are **5,532 update rows**: 2,766 player-batch overall rows and 2,766 player-batch-surface rows. ATP contributes 907 rows per component; WTA 1,859. Each component accounts for 5,160 player-match contributions, exactly twice the 2,580 admitted matches. Contribution IDs are unique within a player/component/batch row. The real panel has one event per tour/date batch; tied multi-event/multi-surface behavior is tested with fixtures.

| Tour | Component | Surface | Update rows | Largest absolute batch delta | Post-update rating range |
| --- | --- | --- | ---: | ---: | --- |
| ATP | OVERALL | ALL | 907 | 112.000000 | 1408.761902–1786.885523 |
| ATP | SURFACE | Clay | 313 | 96.000000 | 1452.736307–1631.263696 |
| ATP | SURFACE | Grass | 81 | 64.000000 | 1484.000000–1564.000000 |
| ATP | SURFACE | Hard | 513 | 112.000000 | 1426.806646–1710.501507 |
| WTA | OVERALL | ALL | 1859 | 117.890426 | 1383.060974–1838.492250 |
| WTA | SURFACE | Clay | 561 | 97.152936 | 1429.907169–1729.499671 |
| WTA | SURFACE | Grass | 223 | 112.723911 | 1468.000000–1631.606017 |
| WTA | SURFACE | Hard | 1075 | 113.565189 | 1399.084972–1733.677574 |

The largest absolute accumulated delta is **117.890426** (WTA overall; rounded). There are **425 update rows with absolute accumulated delta greater than 32**. These sum several permitted match deltas and are not clipped or reinterpreted as per-match K violations. Match-level deltas sum to zero across opponents by construction; the largest observed batch/component/surface net residual is **1.527667e-13 rating points**, numerical floating-point summation residue, within the test tolerance of 1e-10. No balancing correction is applied. All before/after states are finite.

## Every batch

Source labels below are not verified dates. Each real batch currently corresponds to one event cell.

| Tour | Source label | Targets | Complete S08 | Overall cold slots | Surface cold slots | Primary A-probability range |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| ATP | 20230116 | 126 | 0 | 252 | 252 | 0.500000–0.500000 |
| ATP | 20230306 | 91 | 69 | 19 | 19 | 0.365257–0.568641 |
| ATP | 20230320 | 89 | 85 | 4 | 4 | 0.351865–0.649101 |
| ATP | 20230424 | 94 | 75 | 19 | 188 | 0.382845–0.599611 |
| ATP | 20230508 | 92 | 78 | 14 | 32 | 0.280716–0.626701 |
| ATP | 20230529 | 119 | 94 | 24 | 43 | 0.301285–0.713622 |
| ATP | 20230703 | 56 | 48 | 8 | 112 | 0.330783–0.627194 |
| ATP | 20230807 | 54 | 48 | 6 | 8 | 0.250436–0.739904 |
| ATP | 20230814 | 50 | 50 | 0 | 2 | 0.250365–0.716908 |
| ATP | 20230828 | 75 | 65 | 10 | 19 | 0.178693–0.803670 |
| WTA | 20210208 | 126 | 0 | 252 | 252 | 0.500000–0.500000 |
| WTA | 20210322 | 89 | 62 | 30 | 30 | 0.323698–0.591076 |
| WTA | 20210429 | 58 | 53 | 3 | 116 | 0.407706–0.605623 |
| WTA | 20210510 | 51 | 51 | 0 | 18 | 0.308602–0.679794 |
| WTA | 20210531 | 119 | 96 | 23 | 81 | 0.316908–0.689255 |
| WTA | 20210628 | 100 | 85 | 15 | 200 | 0.363763–0.658770 |
| WTA | 20210809 | 49 | 47 | 2 | 5 | 0.343791–0.640274 |
| WTA | 20210816 | 49 | 48 | 1 | 1 | 0.249745–0.771763 |
| WTA | 20210830 | 93 | 80 | 13 | 32 | 0.316574–0.774476 |
| WTA | 20211006 | 91 | 82 | 9 | 12 | 0.269300–0.682526 |
| WTA | 20230116 | 127 | 88 | 41 | 42 | 0.241054–0.726185 |
| WTA | 20230306 | 91 | 84 | 6 | 7 | 0.193154–0.735055 |
| WTA | 20230320 | 92 | 85 | 7 | 8 | 0.125076–0.726142 |
| WTA | 20230424 | 93 | 84 | 9 | 66 | 0.227599–0.774603 |
| WTA | 20230508 | 90 | 84 | 7 | 16 | 0.209016–0.720046 |
| WTA | 20230529 | 119 | 107 | 12 | 32 | 0.207260–0.787265 |
| WTA | 20230703 | 92 | 83 | 9 | 66 | 0.256333–0.770047 |
| WTA | 20230807 | 53 | 51 | 2 | 3 | 0.160466–0.829403 |
| WTA | 20230814 | 52 | 52 | 0 | 1 | 0.241939–0.843205 |
| WTA | 20230828 | 100 | 92 | 8 | 17 | 0.137336–0.859187 |

## Outputs and verification boundary

Only three files are installed in the already ignored `data/pilot/surface-elo-baseline/` directory:

- `target-elo-probabilities.csv`: 2,580 neutral targets with batch/event/surface metadata, frozen A/B overall/surface/blended ratings, primary/overall-only A/B probabilities, prior-match counts and cold flags, and complete-S08 slot flags/strata. No target outcome is exported.
- `rating-update-ledger.csv`: 5,532 player-batch/component rows with surface scope, before/accumulated delta/after, before/batch/after match counts and canonical contributing match IDs. Only touched surface states need update rows; untouched states persist.
- `summary.csv`: 356 rows: 288 coverage rows (72 grouping cells, each including ALL and the three S08 strata) and 68 update-diagnostic rows. Coverage and update rows share a schema; nonapplicable fields are NA. Probabilities are not performance scores.

All files are staged together, checked for exact scope and unchanged bytes, then installed by one directory rename after input pins are rechecked. An interrupted or corrupted stage cannot expose a partial final release. An identical release is preserved; different existing bytes or extra files fail closed without overwrite.

All **94 focused checks passed**. These include an independent dense-matrix replay of every pre-batch state, full contribution sums and history counts, fixture arithmetic, synchronous multi-event/multi-surface updates, cold starts, real WTA continuity, permutations, slot swaps, target/later-result perturbations, positive earlier-result controls, exclusions, exact scope, atomic failure injection and deterministic reruns. Historical suites and pins were not rerun or rewritten. No test failure or runtime warning occurred. The installed runner output matched the independently tested build byte for byte; reinstallation preserved those bytes. All three outputs, every batch summary and the diff were inspected. Documentation agreement, links, whitespace, exact five-file tracked scope and unchanged historical status/contract checks passed. All **283 other pre-existing tracked files and pilot artifacts retain their SHA-256 hashes**. The summary explicitly includes 54 zero-size coverage strata.

| Installed output | SHA-256 |
| --- | --- |
| target-elo-probabilities.csv | `93505d79faf5e17eb3646c101ea6b21e8035e2acddbfe55c27f3236bb6c2392c` |
| rating-update-ledger.csv | `a275fff322f81e2fde2194eb80c598ed5be7ff76bd901d7a378d1e475de9158c` |
| summary.csv | `9cf5eb133ef8a213881250c855ddb98a96bf16209f82d21e6d7c6bc35e927469` |

## Limits and one bounded next step

This implements the explicitly approved benchmark conventions, not evidence-supported optimal parameters. The Phase 2K failure remains: earlier source labels may overlap later events or predate actual availability. ATP includes 2023 only; WTA includes 2021 and 2023, no 2022. Unobserved matches remain absent; history depth and surface exposure differ. Retrospective normal-completion/count admission and S08 availability condition the sample. Fixed priors supply Elo probabilities for cold starts without establishing their reliability.

No prediction scoring, tuning, S08 fit, imputation, new data/source/year, inferred timestamps, dependency, 2024/2025 access, OTD, portfolio work or publication occurred. All 554 noncommon targets remain in coverage and update later states; future paired scoring must retain identical match IDs and cutoffs, and report additional training-readiness losses. S02 remains paused; S08 provisional. No final factor weights or validated uncertainty are established.

The current status and contract record implementation completion. Phase 2O's decision and PROJECT_CONTEXT.md retain their historical specification/approval boundary; their pending-implementation descriptions are superseded by this explicitly approved Phase 2P release. They and all earlier files remain unchanged within this exact scope.

Recommend **Phase 2Q: one bounded S08 forecasting and paired evaluation specification**, to resolve the still-unapproved model, chronological folds, training sufficiency/failure handling and uncertainty protocol before any fit or score. This is a specific unresolved design boundary, not authority to tune the Elo benchmark or select favorable complete cases.

Exact approval language: **“Approve Phase 2Q: specify one parsimonious S08 probability model and a chronological paired-evaluation protocol using saved development artifacts only. Define whole-batch training folds, training sufficiency and failure handling, common-match coverage, scoring and player/event-aware uncertainty requirements. Preserve the fixed Phase 2P Elo benchmark, all targets, exclusions and SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY. Do not fit, tune, score predictions, impute, acquire data, infer timestamps, access 2024/2025 or modify the portfolio.”** The next prompt must define exact documentation scope before work begins.
