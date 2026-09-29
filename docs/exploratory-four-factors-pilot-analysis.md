# Exploratory Four Factors pilot analysis

**PILOT_DIAGNOSTICS_SUPPORT_CANDIDATE_REFINEMENT**. All 231 current-context match rows reproduce the frozen Phase 2A metrics. This is an exploratory same-match result from three hard-court convenience samples, not final factor selection or evidence of future forecasting value.

Primary alternatives meeting the registered two-tour numerical refinement rule: S01;S02;S03;S07;S08;S09 .
The rule checks full-rank fits, unacceptable collinearity, prespecified directions and numerical nonzero NPR increments. It does not rank sets by fit, establish four independent mechanisms, supply practical-effect margins or resolve instability. All twelve sets remain reported below.

The main concerns are conditional direction and sample sensitivity. S04–S06 fail the two-tour direction requirement because M02 is negative in WTA. ATP S07 reverses M11 and M12 signs after denominator filtering; WTA M01 changes sign between event-season cells in S02/S03. These findings prevent a final stability claim. Some cell-level logistic fits have separation or extreme-probability warnings despite strong apparent fit.

## Scope and reconstruction

The release uses only ATP Indian Wells 2023, WTA Indian Wells 2023 and WTA Montreal 2021. Phase 2E verified 245 inventory matches: 91/92/49 completed, with the single completed WTA Indian Wells statistical quarantine excluded. All retirements and walkovers remain excluded. The resulting 231 bundles comprise 91 ATP, 91 WTA Indian Wells and 49 Montreal matches; Montreal retains 42 original bundles plus seven separately reconstructed recovery bundles. No raw file or historical release was changed.

Reconstruction agrees across 183 fields, including exact memberships, identifiers, result-neutral source-ID orientation, eligibility, all denominators and undefined reasons. Maximum floating representation difference: 4.9496e-11 .
Only floating metric/outcome values use 5e-12 * max(1, abs(frozen)) tolerance for historical 12-significant-digit serialization. NA patterns and all other fields compare exactly. Reproduction completes before any extended fit. Match-level CSVs contain source IDs for reproducibility, no player names, and remain ignored/local.

## Availability and denominator sensitivity

| slice | eligible_matches | common_complete_n | m12_undefined_matches | common_model_tail_n |
| --- | --- | --- | --- | --- |
| cell:ATP / 2023 / Indian Wells | 91 | 79 | 12 | 28 |
| cell:WTA / 2023 / Indian Wells | 91 | 87 | 4 | 42 |
| cell:WTA / 2021 / Canada | 49 | 49 | 0 | 19 |
| tour:ATP | 91 | 79 | 12 | 28 |
| tour:WTA | 140 | 136 | 4 | 62 |

Only M12/M13 have structural match-difference gaps among these valid bundles. No missing input or invalid bundle enters this analysis. Side-specific zero opportunities and minimum, quartile, median and maximum positive denominators for all fifteen metrics appear in availability-summary.csv. A defined zero remains distinct from an unavailable value. No imputation or missingness-indicator model was fitted.

Full models use a common-complete cohort across all nine registered predictors. The denominator sensitivity retains only rows above each metric’s within-slice positive paired-minimum denominator lower quartile (type 1), intersecting all nine masks. This keeps identical samples across candidate sets and may remove many rows; it is not a coverage/admission threshold. Univariate sensitivity retains the inherited metric-specific mask. Predictors are restandardized within the retained sample, so coefficient changes also reflect changed variation and selection.

## Registered alternatives and algebraic facts

| set_id | role | serve_creation | second_serve_security | return_pressure | conversion_recovery |
| --- | --- | --- | --- | --- | --- |
| S01 | PRIMARY_ALTERNATIVE | M01 | M04 | M11 | M12 |
| S02 | PRIMARY_ALTERNATIVE | M01 | M05 | M11 | M12 |
| S03 | PRIMARY_ALTERNATIVE | M01 | M06 | M11 | M12 |
| S04 | PRIMARY_ALTERNATIVE | M02 | M04 | M11 | M12 |
| S05 | PRIMARY_ALTERNATIVE | M02 | M05 | M11 | M12 |
| S06 | PRIMARY_ALTERNATIVE | M02 | M06 | M11 | M12 |
| S07 | PRIMARY_ALTERNATIVE | M03 | M04 | M11 | M12 |
| S08 | PRIMARY_ALTERNATIVE | M03 | M05 | M11 | M12 |
| S09 | PRIMARY_ALTERNATIVE | M03 | M06 | M11 | M12 |
| T01 | SENSITIVITY_ONLY | M01 | M07 | M11 | M12 |
| T02 | SENSITIVITY_ONLY | M02 | M07 | M11 | M12 |
| T03 | SENSITIVITY_ONLY | M03 | M07 | M11 | M12 |

M08/M15 are broad benchmarks and never enter a registered model. M07 is sensitivity-only. Exact A-minus-B identities remain dM03=dM09, dM04=dM10, dM08=dM15, dM11=-dM14 and dM12=dM13. No duplicate or signed complement coexists in a set. M05 and M06 are related alternatives, not exact duplicate differences. M06=M05*(1-M02), M04=M07*(1-M05), and M15=M02*M03+(1-M02)*M04 are within-side nonlinear identities.

Equal-phase NPR is exactly 100*dM08=100*dM15. NPR shares point counts with these rates and the other point-outcome ingredients. High correlation with these outcomes is not independent construct validity. M11/M12 share break-opportunity structure; raw conversion is not conversion above expectation or established clutch skill. M02’s positive direction is a hypothesis with a first-serve quality tradeoff.

## Same-match associations

| tour | metric | pair_count.NPR | correlation.NPR | direction_agreement.NPR | pair_count.equal_phase_NPR | correlation.equal_phase_NPR | direction_agreement.equal_phase_NPR | pair_count.same_match_win | correlation.same_match_win | direction_agreement.same_match_win |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | M01 | 91 | 0.4518 | AGREES | 91 | 0.463 | AGREES | 91 | 0.2882 | AGREES |
| ATP | M02 | 91 | 0.2303 | AGREES | 91 | 0.1967 | AGREES | 91 | 0.1725 | AGREES |
| ATP | M03 | 91 | 0.808 | AGREES | 91 | 0.8263 | AGREES | 91 | 0.5932 | AGREES |
| ATP | M04 | 91 | 0.7356 | AGREES | 91 | 0.759 | AGREES | 91 | 0.6971 | AGREES |
| ATP | M05 | 91 | -0.3311 | AGREES | 91 | -0.343 | AGREES | 91 | -0.3071 | AGREES |
| ATP | M06 | 91 | -0.3261 | AGREES | 91 | -0.3286 | AGREES | 91 | -0.296 | AGREES |
| ATP | M07 | 91 | 0.6871 | AGREES | 91 | 0.7048 | AGREES | 91 | 0.6478 | AGREES |
| ATP | M08 | 91 | 0.9822 | AGREES | 91 | 1 | AGREES | 91 | 0.8099 | AGREES |
| ATP | M09 | 91 | 0.808 | AGREES | 91 | 0.8263 | AGREES | 91 | 0.5932 | AGREES |
| ATP | M10 | 91 | 0.7356 | AGREES | 91 | 0.759 | AGREES | 91 | 0.6971 | AGREES |
| ATP | M11 | 91 | 0.8059 | AGREES | 91 | 0.8508 | AGREES | 91 | 0.6929 | AGREES |
| ATP | M12 | 79 | 0.4179 | AGREES | 79 | 0.3184 | AGREES | 79 | 0.362 | AGREES |
| ATP | M13 | 79 | 0.4179 | AGREES | 79 | 0.3184 | AGREES | 79 | 0.362 | AGREES |
| ATP | M14 | 91 | -0.8059 | AGREES | 91 | -0.8508 | AGREES | 91 | -0.6929 | AGREES |
| ATP | M15 | 91 | 0.9822 | AGREES | 91 | 1 | AGREES | 91 | 0.8099 | AGREES |
| WTA | M01 | 140 | 0.3314 | AGREES | 140 | 0.3428 | AGREES | 140 | 0.3274 | AGREES |
| WTA | M02 | 140 | 0.1778 | AGREES | 140 | 0.1733 | AGREES | 140 | 0.06196 | AGREES |
| WTA | M03 | 140 | 0.8495 | AGREES | 140 | 0.8589 | AGREES | 140 | 0.6591 | AGREES |
| WTA | M04 | 140 | 0.6971 | AGREES | 140 | 0.6903 | AGREES | 140 | 0.5824 | AGREES |
| WTA | M05 | 140 | -0.1772 | AGREES | 140 | -0.1683 | AGREES | 140 | -0.126 | AGREES |
| WTA | M06 | 140 | -0.2438 | AGREES | 140 | -0.2315 | AGREES | 140 | -0.1544 | AGREES |
| WTA | M07 | 140 | 0.658 | AGREES | 140 | 0.656 | AGREES | 140 | 0.5605 | AGREES |
| WTA | M08 | 140 | 0.9946 | AGREES | 140 | 1 | AGREES | 140 | 0.7727 | AGREES |
| WTA | M09 | 140 | 0.8495 | AGREES | 140 | 0.8589 | AGREES | 140 | 0.6591 | AGREES |
| WTA | M10 | 140 | 0.6971 | AGREES | 140 | 0.6903 | AGREES | 140 | 0.5824 | AGREES |
| WTA | M11 | 140 | 0.709 | AGREES | 140 | 0.7371 | AGREES | 140 | 0.5869 | AGREES |
| WTA | M12 | 136 | 0.5046 | AGREES | 136 | 0.4724 | AGREES | 136 | 0.3755 | AGREES |
| WTA | M13 | 136 | 0.5046 | AGREES | 136 | 0.4724 | AGREES | 136 | 0.3755 | AGREES |
| WTA | M14 | 140 | -0.709 | AGREES | 140 | -0.7371 | AGREES | 140 | -0.5869 | AGREES |
| WTA | M15 | 140 | 0.9946 | AGREES | 140 | 1 | AGREES | 140 | 0.7727 | AGREES |

The complete local association table contains Pearson and Spearman, NPR/equal-phase NPR/same-match win, exact pair counts and common-complete counts, expected/observed signs, roles and coupling, across all three cells and both tour aggregates. Spearman preserves the inherited 12-decimal tie convention. Pairwise and common-complete samples are compared explicitly. The ATP aggregate duplicates its only cell; it is not a replication.

## Collinearity and conditional NPR results

Coefficients are NPR units per one sample SD of the named A-minus-B predictor, conditional on the other three. Each full and leave-one-factor-out fit keeps identical rows, orientation and scaling. An intercept is included. Ordinary R-squared describes same-match fit; adjusted R-squared is only a separate diagnostic. Neither is forecast performance or causal importance.

| tour | set_id | n | r_squared | adjusted_r_squared | max_vif | max_condition | collinearity_gate |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | S01 | 79 | 0.8216 | 0.812 | 2.066 | 2.519 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S02 | 79 | 0.7959 | 0.7849 | 1.348 | 1.752 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S03 | 79 | 0.8021 | 0.7914 | 1.31 | 1.702 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S04 | 79 | 0.8149 | 0.8049 | 1.73 | 2.184 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S05 | 79 | 0.7907 | 0.7794 | 1.262 | 1.643 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S06 | 79 | 0.7906 | 0.7793 | 1.462 | 1.903 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S07 | 79 | 0.9176 | 0.9131 | 4.131 | 4.051 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S08 | 79 | 0.825 | 0.8156 | 2.034 | 2.567 | NO_NUMERICAL_GATE_FAILURE |
| ATP | S09 | 79 | 0.8317 | 0.8226 | 2.04 | 2.543 | NO_NUMERICAL_GATE_FAILURE |
| ATP | T01 | 79 | 0.7996 | 0.7888 | 1.839 | 2.336 | NO_NUMERICAL_GATE_FAILURE |
| ATP | T02 | 79 | 0.8075 | 0.7971 | 1.61 | 2.068 | NO_NUMERICAL_GATE_FAILURE |
| ATP | T03 | 79 | 0.875 | 0.8683 | 3.654 | 3.808 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S01 | 136 | 0.865 | 0.8609 | 1.472 | 2.103 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S02 | 136 | 0.8205 | 0.815 | 1.158 | 1.527 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S03 | 136 | 0.82 | 0.8145 | 1.219 | 1.632 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S04 | 136 | 0.8648 | 0.8607 | 1.471 | 1.976 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S05 | 136 | 0.8203 | 0.8148 | 1.126 | 1.419 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S06 | 136 | 0.8204 | 0.8149 | 1.247 | 1.634 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S07 | 136 | 0.9653 | 0.9642 | 3.749 | 4.044 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S08 | 136 | 0.8646 | 0.8605 | 2.796 | 3.068 | NO_NUMERICAL_GATE_FAILURE |
| WTA | S09 | 136 | 0.8675 | 0.8635 | 2.905 | 3.18 | NO_NUMERICAL_GATE_FAILURE |
| WTA | T01 | 136 | 0.856 | 0.8516 | 1.359 | 1.968 | NO_NUMERICAL_GATE_FAILURE |
| WTA | T02 | 136 | 0.8561 | 0.8517 | 1.359 | 1.833 | NO_NUMERICAL_GATE_FAILURE |
| WTA | T03 | 136 | 0.9345 | 0.9325 | 3.442 | 3.768 | NO_NUMERICAL_GATE_FAILURE |

Conditional coefficients and semi-partial R-squared (full minus reduced):

| tour | set_id | metric_1 | beta_1 | unique_R2_1 | metric_2 | beta_2 | unique_R2_2 | metric_3 | beta_3 | unique_R2_3 | metric_4 | beta_4 | unique_R2_4 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | S01 | M01 | 2.094 | 0.02439 | M04 | 3.486 | 0.04739 | M11 | 6.134 | 0.1275 | M12 | 4.558 | 0.1354 |
| ATP | S02 | M01 | 1.738 | 0.01727 | M05 | -1.861 | 0.02164 | M11 | 7.885 | 0.3229 | M12 | 5.313 | 0.1971 |
| ATP | S03 | M01 | 1.809 | 0.01862 | M06 | -2.081 | 0.02785 | M11 | 7.902 | 0.3335 | M12 | 5.214 | 0.19 |
| ATP | S04 | M02 | 1.608 | 0.0177 | M04 | 2.775 | 0.03115 | M11 | 7.323 | 0.2258 | M12 | 4.567 | 0.1358 |
| ATP | S05 | M02 | 1.418 | 0.01211 | M05 | -1.118 | 0.006931 | M11 | 8.723 | 0.483 | M12 | 5.172 | 0.1843 |
| ATP | S06 | M02 | 1.193 | 0.007151 | M06 | -1.194 | 0.006822 | M11 | 8.781 | 0.5038 | M12 | 5.136 | 0.1824 |
| ATP | S07 | M03 | 6.889 | 0.1203 | M04 | 6.329 | 0.118 | M11 | 0.8061 | 0.001101 | M12 | 1.855 | 0.01568 |
| ATP | S08 | M03 | 3.672 | 0.04639 | M05 | -2.021 | 0.02546 | M11 | 6.193 | 0.1327 | M12 | 4.186 | 0.1023 |
| ATP | S09 | M03 | 3.747 | 0.04819 | M06 | -2.235 | 0.0321 | M11 | 6.201 | 0.136 | M12 | 4.057 | 0.09556 |
| ATP | T01 | M01 | 1.76 | 0.01771 | M07 | 2.429 | 0.02534 | M11 | 7.035 | 0.1883 | M12 | 4.708 | 0.143 |
| ATP | T02 | M02 | 1.933 | 0.02565 | M07 | 2.337 | 0.02373 | M11 | 7.675 | 0.266 | M12 | 4.56 | 0.1327 |
| ATP | T03 | M03 | 5.921 | 0.09316 | M07 | 4.776 | 0.07548 | M11 | 2.601 | 0.01296 | M12 | 2.341 | 0.02501 |
| WTA | S01 | M01 | 0.259 | 0.0004139 | M04 | 3.177 | 0.04793 | M11 | 7.702 | 0.3006 | M12 | 5.952 | 0.1765 |
| WTA | S02 | M01 | 0.239 | 0.0003505 | M05 | -0.719 | 0.003384 | M11 | 8.994 | 0.503 | M12 | 7.241 | 0.3165 |
| WTA | S03 | M01 | 0.2853 | 0.0004902 | M06 | -0.6793 | 0.002854 | M11 | 8.956 | 0.4938 | M12 | 7.194 | 0.2968 |
| WTA | S04 | M02 | -0.1654 | 0.0001837 | M04 | 3.17 | 0.04776 | M11 | 7.793 | 0.3316 | M12 | 6.047 | 0.1862 |
| WTA | S05 | M02 | -0.1406 | 0.0001326 | M05 | -0.7004 | 0.003234 | M11 | 9.075 | 0.5573 | M12 | 7.328 | 0.3332 |
| WTA | S06 | M02 | -0.3923 | 0.0009124 | M06 | -0.7725 | 0.003344 | M11 | 9.064 | 0.5553 | M12 | 7.308 | 0.3278 |
| WTA | S07 | M03 | 6.878 | 0.1007 | M04 | 5.219 | 0.108 | M11 | 1.81 | 0.006108 | M12 | 2.165 | 0.01386 |
| WTA | S08 | M03 | 4.219 | 0.04449 | M05 | -1.067 | 0.007353 | M11 | 5.909 | 0.09422 | M12 | 5.427 | 0.1257 |
| WTA | S09 | M03 | 4.468 | 0.04803 | M06 | -1.307 | 0.01023 | M11 | 5.667 | 0.08352 | M12 | 5.177 | 0.1059 |
| WTA | T01 | M01 | 0.1303 | 0.0001049 | M07 | 2.751 | 0.03892 | M11 | 7.883 | 0.3197 | M12 | 6.432 | 0.2289 |
| WTA | T02 | M02 | -0.1456 | 0.0001423 | M07 | 2.754 | 0.03903 | M11 | 7.931 | 0.3448 | M12 | 6.489 | 0.2361 |
| WTA | T03 | M03 | 5.869 | 0.07856 | M07 | 4.096 | 0.07721 | M11 | 2.976 | 0.01799 | M12 | 3.487 | 0.0426 |

Partial R-squared divides the ordinary increment by one minus reduced R-squared; it is undefined when that denominator is numerically zero. These are conditional unique contributions, not normalized allocations of explained variance or published weights. No LMG/Shapley allocation was calculated. Ranges across every registered alternative, including sensitivity sets, follow:

| tour | removed_metric | semi_partial_r_squared | partial_r_squared |
| --- | --- | --- | --- |
| ATP | M01 | 0.01727 to 0.02439 | 0.0780 to 0.1203 |
| WTA | M01 | 0.0001049 to 0.0004902 | 0.000728 to 0.003057 |
| ATP | M02 | 0.007151 to 0.025650 | 0.03302 to 0.11760 |
| WTA | M02 | 0.0001326 to 0.0009124 | 0.0007374 to 0.0050540 |
| ATP | M03 | 0.04639 to 0.12030 | 0.2096 to 0.5935 |
| WTA | M03 | 0.04449 to 0.10070 | 0.2474 to 0.7435 |
| ATP | M04 | 0.03115 to 0.11800 | 0.1441 to 0.5888 |
| WTA | M04 | 0.04776 to 0.10800 | 0.2611 to 0.7567 |
| ATP | M05 | 0.006931 to 0.025460 | 0.03206 to 0.12700 |
| WTA | M05 | 0.003234 to 0.007353 | 0.01768 to 0.05152 |
| ATP | M06 | 0.006822 to 0.032100 | 0.03156 to 0.16020 |
| WTA | M06 | 0.002854 to 0.010230 | 0.01560 to 0.07167 |
| ATP | M07 | 0.02373 to 0.07548 | 0.1098 to 0.3766 |
| WTA | M07 | 0.03892 to 0.07721 | 0.2128 to 0.5410 |
| ATP | M11 | 0.001101 to 0.503800 | 0.01318 to 0.70640 |
| WTA | M11 | 0.006108 to 0.557300 | 0.1496 to 0.7562 |
| ATP | M12 | 0.01568 to 0.19710 | 0.1598 to 0.4913 |
| WTA | M12 | 0.01386 to 0.33320 | 0.2852 to 0.6496 |

The unchanged .80/.90/.95 correlation, VIF 5/10 and condition-index 30 rules apply. Rank deficiency is an automatic failure; no predictor dropping or generalized inverse is used. Centered/unit-SD condition indices omit the intercept. Pairwise Pearson/Spearman, each VIF, each condition index, near-constant columns and shared-count warnings are retained in collinearity-diagnostics.csv. Sets with fatal numerical gates in any requested slice/sensitivity are listed here:

No registered set reached a correlation, VIF, rank or condition-index concern boundary in the requested slices. Maximum VIF was below 5 and maximum condition index below 30. This does not resolve shared-count interpretation or stability.

Across all NPR fits, 65 residual flags and 603 leverage flags were recorded, counting the same match again when it appears in another model. These are model-by-row diagnostics, not distinct-match counts.
Flags use absolute internally studentized residual >3 and leverage >2p/n; residual maxima and counts remain in the local model table. No p-values, standard errors or confidence intervals are reported.

## Confounded WTA event adjustment

| set_id | n | coefficient | r_squared | max_vif | max_condition | collinearity_gate |
| --- | --- | --- | --- | --- | --- | --- |
| S01 | 136 | -0.4134 | 0.8653 | 1.473 | 2.108 | NO_NUMERICAL_GATE_FAILURE |
| S02 | 136 | -0.4954 | 0.8209 | 1.161 | 1.578 | NO_NUMERICAL_GATE_FAILURE |
| S03 | 136 | -0.4 | 0.8202 | 1.223 | 1.671 | NO_NUMERICAL_GATE_FAILURE |
| S04 | 136 | -0.4638 | 0.8651 | 1.472 | 1.982 | NO_NUMERICAL_GATE_FAILURE |
| S05 | 136 | -0.5361 | 0.8207 | 1.132 | 1.448 | NO_NUMERICAL_GATE_FAILURE |
| S06 | 136 | -0.5251 | 0.8208 | 1.277 | 1.688 | NO_NUMERICAL_GATE_FAILURE |
| S07 | 136 | -0.3963 | 0.9655 | 3.75 | 4.048 | NO_NUMERICAL_GATE_FAILURE |
| S08 | 136 | -0.5384 | 0.8651 | 2.796 | 3.07 | NO_NUMERICAL_GATE_FAILURE |
| S09 | 136 | -0.4649 | 0.8679 | 2.905 | 3.183 | NO_NUMERICAL_GATE_FAILURE |
| T01 | 136 | -0.03677 | 0.856 | 1.362 | 1.978 | NO_NUMERICAL_GATE_FAILURE |
| T02 | 136 | -0.07297 | 0.8561 | 1.361 | 1.845 | NO_NUMERICAL_GATE_FAILURE |
| T03 | 136 | 0.1803 | 0.9345 | 3.447 | 3.776 | NO_NUMERICAL_GATE_FAILURE |

The indicator equals one for Montreal 2021 and zero for Indian Wells 2023; its coefficient is an NPR-unit conditional contrast. It remains in every reduced comparison. Event and season cannot be disentangled, and an indicator does not adjust opponents, player dependence or the selection of these events. The local tables also retain this adjustment under the denominator sensitivity.

## Same-match win diagnostics

| tour | set_id | n | converged | unstable | separation | apparent_log_loss | apparent_brier |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | S01 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1347 | 0.04402 |
| ATP | S02 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.247 | 0.07826 |
| ATP | S03 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2448 | 0.07779 |
| ATP | S04 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1329 | 0.04101 |
| ATP | S05 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2468 | 0.07799 |
| ATP | S06 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2468 | 0.07816 |
| ATP | S07 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1259 | 0.04096 |
| ATP | S08 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2477 | 0.07862 |
| ATP | S09 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2465 | 0.07855 |
| ATP | T01 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2076 | 0.06361 |
| ATP | T02 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1791 | 0.06106 |
| ATP | T03 | 79 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.199 | 0.06479 |
| WTA | S01 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1909 | 0.06197 |
| WTA | S02 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2094 | 0.06797 |
| WTA | S03 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.2086 | 0.06719 |
| WTA | S04 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1726 | 0.05554 |
| WTA | S05 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1911 | 0.06196 |
| WTA | S06 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.191 | 0.06182 |
| WTA | S07 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1341 | 0.04485 |
| WTA | S08 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1908 | 0.06229 |
| WTA | S09 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1928 | 0.06295 |
| WTA | T01 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1877 | 0.05886 |
| WTA | T02 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1744 | 0.05416 |
| WTA | T03 | 136 | TRUE | FALSE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0.1568 | 0.04957 |

These are apparent in-sample binomial fits to the same matches whose statistics form the predictors. They are not pre-match probabilities, calibration estimates or forecasts. Log loss uses stable softplus arithmetic without clipping; Brier score is squared error. Full and reduced comparisons keep identical rows. Removing a predictor need not worsen apparent Brier score because logistic fitting optimizes likelihood, not Brier score.

All coefficient directions, full/reduced loss changes, convergence, boundary status, iteration counts, numerical warnings and separation witnesses remain in same-match-win-summary.csv. A signed fitted linear predictor that separates outcomes is sufficient evidence of separation; failure to find that witness does not prove its absence. Extreme probabilities or nonconvergence flag instability. No penalized or tuned replacement fit is used. Coefficients from unstable fits must not be treated as reliable effects.

Unstable full logistic fits by requested slice (including the duplicate ATP cell/aggregate):

| slice | sensitivity | set_id | converged | separation | extreme_probability_count | warning |
| --- | --- | --- | --- | --- | --- | --- |
| cell:ATP / 2023 / Indian Wells | lower_denominator_quartile | S04 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S01 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S02 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S03 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 1 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S04 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 2 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S05 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S06 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S07 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 4 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S08 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | S09 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | T01 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 1 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | T02 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 1 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2023 / Indian Wells | full | T03 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 3 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | full | S07 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 11 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | full | T02 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | full | T03 | FALSE | COMPLETE_SEPARATION_WITNESS | 44 | glm.fit: algorithm did not converge;glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | lower_denominator_quartile | S01 | FALSE | COMPLETE_SEPARATION_WITNESS | 13 | glm.fit: algorithm did not converge;glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | lower_denominator_quartile | S04 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 2 | glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | lower_denominator_quartile | T01 | FALSE | COMPLETE_SEPARATION_WITNESS | 13 | glm.fit: algorithm did not converge;glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | lower_denominator_quartile | T02 | FALSE | COMPLETE_SEPARATION_WITNESS | 14 | glm.fit: algorithm did not converge;glm.fit: fitted probabilities numerically 0 or 1 occurred |
| cell:WTA / 2021 / Canada | lower_denominator_quartile | T03 | FALSE | COMPLETE_SEPARATION_WITNESS | 13 | glm.fit: algorithm did not converge;glm.fit: fitted probabilities numerically 0 or 1 occurred |
| tour:ATP | lower_denominator_quartile | S04 | TRUE | NO_WITNESS_NOT_PROOF_OF_ABSENCE | 0 | glm.fit: fitted probabilities numerically 0 or 1 occurred |

## Stability and sensitivity

| kind | context | sign_reversal | changed_collinearity | numeric_increment_lost |
| --- | --- | --- | --- | --- |
| npr_coefficient | CONFOUNDED_EVENT_ADJUSTMENT | 0 | 0 | 0 |
| npr_increment | CONFOUNDED_EVENT_ADJUSTMENT | 0 | 0 | 0 |
| association | CONFOUNDED_EVENT_SEASON | 24 | 0 | 0 |
| npr_coefficient | CONFOUNDED_EVENT_SEASON | 4 | 0 | 0 |
| npr_increment | CONFOUNDED_EVENT_SEASON | 0 | 0 | 0 |
| win_coefficient | CONFOUNDED_EVENT_SEASON | 5 | 0 | 0 |
| win_log_loss_increment | CONFOUNDED_EVENT_SEASON | 0 | 0 | 0 |
| association | cross_tour_convenience_samples | 0 | 0 | 0 |
| npr_coefficient | cross_tour_convenience_samples | 4 | 0 | 0 |
| npr_increment | cross_tour_convenience_samples | 0 | 0 | 0 |
| win_coefficient | cross_tour_convenience_samples | 6 | 0 | 0 |
| win_log_loss_increment | cross_tour_convenience_samples | 0 | 0 | 0 |
| association | cross_tour_same_event_season | 0 | 0 | 0 |
| npr_coefficient | cross_tour_same_event_season | 4 | 0 | 0 |
| npr_increment | cross_tour_same_event_season | 0 | 0 | 0 |
| win_coefficient | cross_tour_same_event_season | 9 | 0 | 0 |
| win_log_loss_increment | cross_tour_same_event_season | 0 | 0 | 0 |
| association | denominator_sensitivity | 40 | 0 | 0 |
| npr_coefficient | denominator_sensitivity | 12 | 0 | 0 |
| npr_increment | denominator_sensitivity | 0 | 0 | 0 |
| win_coefficient | denominator_sensitivity | 21 | 0 | 0 |
| win_log_loss_increment | denominator_sensitivity | 0 | 0 | 0 |
| association | pairwise_vs_common_complete | 0 | 0 | 0 |

Counts above describe comparisons, not independent replications. NPR coefficient sign reversals are shown below; numeric changes for every comparison remain in stability-summary.csv. A scientifically large-change threshold remains PENDING_SPECIFICATION; no threshold was chosen after seeing results.

| context | slice_a | slice_b | set_id | metric | value_a | value_b |
| --- | --- | --- | --- | --- | --- | --- |
| cross_tour_same_event_season | cell:ATP / 2023 / Indian Wells | cell:WTA / 2023 / Indian Wells | S04 | M02 | 1.608 | -0.3488 |
| cross_tour_same_event_season | cell:ATP / 2023 / Indian Wells | cell:WTA / 2023 / Indian Wells | S05 | M02 | 1.418 | -0.1687 |
| cross_tour_same_event_season | cell:ATP / 2023 / Indian Wells | cell:WTA / 2023 / Indian Wells | S06 | M02 | 1.193 | -0.5946 |
| cross_tour_same_event_season | cell:ATP / 2023 / Indian Wells | cell:WTA / 2023 / Indian Wells | T02 | M02 | 1.933 | -0.3589 |
| CONFOUNDED_EVENT_SEASON | cell:WTA / 2023 / Indian Wells | cell:WTA / 2021 / Canada | S02 | M01 | 0.4899 | -0.2574 |
| CONFOUNDED_EVENT_SEASON | cell:WTA / 2023 / Indian Wells | cell:WTA / 2021 / Canada | S03 | M01 | 0.6033 | -0.2197 |
| CONFOUNDED_EVENT_SEASON | cell:WTA / 2023 / Indian Wells | cell:WTA / 2021 / Canada | S04 | M02 | -0.3488 | 0.2105 |
| CONFOUNDED_EVENT_SEASON | cell:WTA / 2023 / Indian Wells | cell:WTA / 2021 / Canada | T02 | M02 | -0.3589 | 0.463 |
| cross_tour_convenience_samples | tour:ATP | tour:WTA | S04 | M02 | 1.608 | -0.1654 |
| cross_tour_convenience_samples | tour:ATP | tour:WTA | S05 | M02 | 1.418 | -0.1406 |
| cross_tour_convenience_samples | tour:ATP | tour:WTA | S06 | M02 | 1.193 | -0.3923 |
| cross_tour_convenience_samples | tour:ATP | tour:WTA | T02 | M02 | 1.933 | -0.1456 |
| denominator_sensitivity | cell:ATP / 2023 / Indian Wells | cell:ATP / 2023 / Indian Wells | S05 | M05 | -1.118 | 0.1635 |
| denominator_sensitivity | cell:ATP / 2023 / Indian Wells | cell:ATP / 2023 / Indian Wells | S06 | M06 | -1.194 | 0.3739 |
| denominator_sensitivity | cell:ATP / 2023 / Indian Wells | cell:ATP / 2023 / Indian Wells | S07 | M11 | 0.8061 | -0.5839 |
| denominator_sensitivity | cell:ATP / 2023 / Indian Wells | cell:ATP / 2023 / Indian Wells | S07 | M12 | 1.855 | -0.05499 |
| denominator_sensitivity | cell:WTA / 2021 / Canada | cell:WTA / 2021 / Canada | S02 | M01 | -0.2574 | 0.864 |
| denominator_sensitivity | cell:WTA / 2021 / Canada | cell:WTA / 2021 / Canada | S03 | M01 | -0.2197 | 0.9654 |
| denominator_sensitivity | cell:WTA / 2021 / Canada | cell:WTA / 2021 / Canada | S04 | M02 | 0.2105 | -1.007 |
| denominator_sensitivity | cell:WTA / 2021 / Canada | cell:WTA / 2021 / Canada | T02 | M02 | 0.463 | -0.9538 |
| denominator_sensitivity | tour:ATP | tour:ATP | S05 | M05 | -1.118 | 0.1635 |
| denominator_sensitivity | tour:ATP | tour:ATP | S06 | M06 | -1.194 | 0.3739 |
| denominator_sensitivity | tour:ATP | tour:ATP | S07 | M11 | 0.8061 | -0.5839 |
| denominator_sensitivity | tour:ATP | tour:ATP | S07 | M12 | 1.855 | -0.05499 |
Same-match logistic coefficient sign reversals: 41 ; examine convergence/separation flags before interpreting them.

Comparisons cover ATP versus WTA Indian Wells, the two WTA event-season cells, tour aggregates, full versus denominator-filtered samples and pairwise versus common-complete associations. WTA cell differences are confounded by event and season. ATP has only one event-season. All three cells are hard-court convenience samples. Surface stability and independent-season stability are NOT_ASSESSABLE. Uncertainty is NOT_ASSESSABLE_UNDER_PILOT_DESIGN: no approved event/player-aware uncertainty implementation exists and these pilots have too few event clusters. No resampling or uncertainty intervals were calculated.

## Exploratory scorecard

| criterion | status | rows |
| --- | --- | --- |
| Interpretation and algebraic role | BENCHMARK_ONLY | 4 |
| Measurement validity | BENCHMARK_ONLY | 4 |
| Nonredundancy | BENCHMARK_ONLY | 4 |
| NPR association | BENCHMARK_ONLY | 4 |
| Same-match win association | BENCHMARK_ONLY | 4 |
| Interpretation and algebraic role | CONCERN | 104 |
| Measurement validity | CONCERN | 26 |
| Same-match conditional win contribution | CONCERN | 6 |
| Collinearity | CONTINUE_AS_PRIMARY_ALTERNATIVE | 90 |
| Measurement validity | CONTINUE_AS_PRIMARY_ALTERNATIVE | 72 |
| Nonredundancy | CONTINUE_AS_PRIMARY_ALTERNATIVE | 90 |
| NPR association | CONTINUE_AS_PRIMARY_ALTERNATIVE | 98 |
| Same-match win association | CONTINUE_AS_PRIMARY_ALTERNATIVE | 98 |
| Collinearity | CONTINUE_AS_SENSITIVITY | 6 |
| Measurement validity | CONTINUE_AS_SENSITIVITY | 6 |
| Nonredundancy | CONTINUE_AS_SENSITIVITY | 6 |
| NPR association | CONTINUE_AS_SENSITIVITY | 6 |
| Same-match win association | CONTINUE_AS_SENSITIVITY | 6 |
| Nonredundancy | FAIL | 8 |
| ATP/WTA consistency | INCONCLUSIVE | 96 |
| Denominator sensitivity | INCONCLUSIVE | 86 |
| Event sensitivity | INCONCLUSIVE | 45 |
| Collinearity | NOT_ASSESSABLE | 12 |
| Event sensitivity | NOT_ASSESSABLE | 54 |
| Incremental NPR contribution | NOT_ASSESSABLE | 12 |
| Missing evidence required for final qualification | NOT_ASSESSABLE | 108 |
| Same-match conditional win contribution | NOT_ASSESSABLE | 12 |
| Incremental NPR contribution | PENDING_SPECIFICATION | 96 |
| Same-match conditional win contribution | PENDING_SPECIFICATION | 90 |
| ATP/WTA consistency | UNSTABLE | 12 |
| Denominator sensitivity | UNSTABLE | 22 |
| Event sensitivity | UNSTABLE | 9 |

The local scorecard records metric, candidate set, tour and all twelve criteria in the approved precedence, with reasons and no total. CONTINUE statuses preserve alternatives for review, not final success. Exact duplicate alternatives fail coexistence; benchmarks remain BENCHMARK_ONLY. Structural conversion gaps, shared-count interpretation, reversed conditional signs, separation and sensitivity concerns cannot be compensated by high R-squared. Practical incremental-effect margins remain PENDING_SPECIFICATION; missing future, surface, season and uncertainty evidence remains NOT_ASSESSABLE.

## Decision and next approval

**PILOT_DIAGNOSTICS_SUPPORT_CANDIDATE_REFINEMENT**.
The terminal rule was registered before fitting. Support means at least one primary set meets the specified numerical and directional checks in both full tour samples; it does not endorse the numerically best fit, suppress failed alternatives, establish stability or select final factors. A family-revision result calls for a proposal, not an unapproved replacement. Inconclusive means the pilots cannot defensibly distinguish those outcomes.

**Exact recommended next approval:** Approve one offline documentation-only candidate-refinement protocol using this frozen Phase 2F release to address sign instability, same-match coupling, conversion/recovery interpretation, practical-effect margins and missing uncertainty evidence; select no final factors, change no formulas, fit no new models, acquire no data, admit no new cells, build no histories or forecasts, and keep Package B stopped, OTD paused and publication blocked.

Final factors, practical-effect margins, new fields/formulas/composites, dependency or structural changes, broader data admission, uncertainty methods, opponent/history adjustments and any forecasting implementation require separate applicable approvals. Package B remains STOPPED; OTD remains PAUSED_BY_USER_AFTER_PHASE_1S; Q6/Q8/Q9/Q10 remain PENDING_USER_APPROVAL. Publication is BLOCKED_PENDING_RIGHTS_REVIEW. No source or licensing permission was upgraded. Challenger work and portfolio integration remain deferred.

## Reproducibility and verification

| output | rows |
| --- | --- |
| input-provenance.csv | 108 |
| match-metrics.csv | 231 |
| reproduction-comparison.csv | 183 |
| candidate-set-registry.csv | 12 |
| availability-summary.csv | 225 |
| association-summary.csv | 1800 |
| collinearity-diagnostics.csv | 2160 |
| npr-model-summary.csv | 744 |
| npr-incremental-contributions.csv | 576 |
| same-match-win-summary.csv | 1080 |
| stability-summary.csv | 4068 |
| candidate-scorecard.csv | 1296 |
| decisions.csv | 15 |
| summary.csv | 17 |

The new release pins current context/contract, unchanged Phase 2B rules, saved three-pilot inputs and frozen comparisons. Source code and tests are inert when sourced. The production entry point reconstructs and compares a complete release before atomic directory installation. Existing identical releases preserve bytes and mtimes; changed inputs, disagreements, partial releases and conflicting bytes fail closed. Only staging files newly created by the current invocation are cleaned up after interruption.

Run `Rscript R/analyze_exploratory_four_factors_pilots.R` and `Rscript R/test_exploratory_four_factors_pilots.R`. Base R only; no dependency was added. The test suite blocks network/browser transports and checks formulas, memberships, registration, known-answer model arithmetic, scope, historical pins, failed publication and deterministic output. Actual final verification counts are recorded in [status](status.md).

The unchanged Phase 2E suite passed on the clean Phase 2E baseline before current-document edits. Its seven frozen tables and original historical authority remain separately checked after implementation; its former current-document assertions are not weakened. The old Phase 2A empirical entry point is never invoked; its actual context-hash refusal remains required.

No network, search, download, contact, OTD resumption, other event content, 2022/2024/2025 data, history, Elo, forecast, final weight, portfolio edit, publication or push is part of this release. Saved whole annual files are hashed, but only the three literal event prefixes are parsed as data; unrelated rows remain opaque. Historical file preservation includes hashes, byte sizes and modification times.

See [source authority](data-source-contract.md#phase-2f-exploratory-authority-and-prespecified-implementation), [standing context](../PROJECT_CONTEXT.md), [Phase 2B protocol](four-factors-definition-protocol.md), [Phase 2E bridge](current-context-pilot-revalidation.md), [implementation](../R/analyze_exploratory_four_factors_pilots.R) and [tests](../R/test_exploratory_four_factors_pilots.R). Future ChatGPT handoffs remain response-only and no more than 2,000 words.
