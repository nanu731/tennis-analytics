# Phase 2I service-game convention diagnostic

**COMPLETE — diagnostic version 1.0.0, 2026-09-29.** Implemented under explicit Phase 2I approval from commit `8486f5858e8b7e462226d3264b8d4b7f75885617`. All **237** frozen service-game/score conflicts are accounted for using **2,818 source-reported normal records** as denominators. This diagnostic changes no admission decision or source value.

## Arithmetic and population

For each frozen normal record, let **G** be total games in the recorded set score, **T** the number of ordinary 7–6/6–7 tie-break sets, and **S** the recorded two-player service-game total. The unchanged Phase 2H expectation is **E = G − T**; signed discrepancy is **D = S − E**. Positive D means excess service games under the current rule; negative D means a deficit. Parenthesized tie-break point scores are not games. The pinned Phase 2H score parser is reused as a pure function, without running its audit or extending its supported formats.

The primary arithmetic hypothesis is **D = T with T > 0**, equivalent to **S = G**: one extra service-game unit per tie-break. An exploratory second pattern is **D = 2T with T > 0**, equivalent to **S = G + T**. These statements concern match totals only; neither allocates expected games to players or assumes a first server. Zero-tie-break equality is uninformative about tie-break treatment and is never counted as hypothesis support.

The frozen ledger contains 2,922 panel records, but 104 records without affirmative source-reported normal completion are outside this diagnostic denominator. These include the nine unsupported extended scores, which remain unsupported. All 2,818 normal records are included regardless of membership or another count failure. The seven existing Montreal overlay bundles retain their separately attributed effective totals; all other totals equal the unchanged raw fields. The 2,581 zero-discrepancy records include one record excluded for other count bounds: game equality does not imply admission.

## Mixed findings and evidence labels

| Pattern | Records | Evidence status | Interpretation |
| --- | ---: | --- | --- |
| One extra per tie-break | 217 | ARITHMETICALLY_CONSISTENT_UNVERIFIED | 91.56% of conflicts; fits S = G, without documented provider semantics |
| Two extras per tie-break | 2 | ARITHMETICALLY_CONSISTENT_UNVERIFIED | Both US Open 2023 R128, one ATP and one WTA; each T = 1 and D = +2 |
| Previously documented no-tie-break error | 1 | DEMONSTRATED_SOURCE_ERROR | Indian Wells 2023: 29 corroborated score games versus recorded total 22; D = −7 |
| Other positive discrepancies | 3 | UNRESOLVED | Two +1 and one +2, all without tie-breaks |
| Other negative discrepancies | 14 | UNRESOLVED | Deficits from −1 to −13; cause and correct values not established |
| Zero discrepancy, no tie-break | 1995 | ARITHMETICALLY_CONSISTENT_UNVERIFIED | Descriptive equality; cannot distinguish conventions |
| Zero discrepancy, with tie-breaks | 586 | ARITHMETICALLY_CONSISTENT_UNVERIFIED | Fits the current aggregate rule; not blanket independent source verification |

**No proposed counting convention earns SUPPORTED_BY_SAVED_EVIDENCE.** The hypothesis output explicitly records zero documented convention cases with UNRESOLVED evidence status. Among conflicts, 219 arithmetic fits, one demonstrated existing error and 17 unresolved records partition all 237. There are 811 positive-tie-break normal records; 586 fit the current rule, 219 fit one of the additions and six have other negative discrepancies. A single convention cannot describe all observed records.

| Signed discrepancy D | −13 | −9 | −7 | −5 | −4 | −3 | −2 | −1 | +1 | +2 | +3 | +4 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Conflict records | 1 | 1 | 2 | 2 | 1 | 1 | 1 | 6 | 175 | 36 | 10 | 1 |

All ten +3 discrepancies occur with three tie-breaks; the single +4 occurs with four. Of the +1 records, 173 have one tie-break; of the +2 records, 33 have two tie-breaks and two have one. Twelve conflicts have no tie-break and cannot be explained by counting a tie-break as a service game. Repeated magnitudes are measured patterns, not assigned causes.

## Concentrations with normal-record denominators

Overall conflict rate is **237/2,818 (8.41%)**. The following rates use all source-reported normal records in the named group, including conflicts; they are not official coverage or rates among admitted records. Single_extra and Double_extra count the two arithmetic fits.

| tour | year | Normal | Conflicts | Single_extra | Double_extra | Conflict_rate |
| --- | --- | --- | --- | --- | --- | --- |
| WTA | 2021 | 880 |  55 |  49 | 0 | 6.25% |
| ATP | 2023 | 967 | 121 | 112 | 1 | 12.51% |
| WTA | 2023 | 971 |  61 |  56 | 1 | 6.28% |

All **217 single-extra fits** occur at Wimbledon (117) or the US Open (100). Together those events contain **226/237 conflicts**. ATP Wimbledon 2023 has 70/126 conflicts, all fitting D = T. WTA Wimbledon 2021 has 20/120 conflicts but only 16 fits: the other four have no tie-break and discrepancies −4, −5, −13 and +1. Event concentration therefore does not establish a uniform event rule.

| tour | year | event | Normal | Conflicts | Single_extra | Double_extra | Conflict_rate |
| --- | --- | --- | --- | --- | --- | --- | --- |
| WTA | 2021 | Australian Open | 126 |  0 |  0 | 0 | 0.00% |
| ATP | 2023 | Australian Open | 126 |  0 |  0 | 0 | 0.00% |
| WTA | 2023 | Australian Open | 127 |  0 |  0 | 0 | 0.00% |
| WTA | 2021 | Canada |  49 |  0 |  0 | 0 | 0.00% |
| ATP | 2023 | Canada |  54 |  0 |  0 | 0 | 0.00% |
| WTA | 2023 | Canada |  53 |  0 |  0 | 0 | 0.00% |
| WTA | 2021 | Cincinnati |  49 |  0 |  0 | 0 | 0.00% |
| ATP | 2023 | Cincinnati |  50 |  0 |  0 | 0 | 0.00% |
| WTA | 2023 | Cincinnati |  52 |  0 |  0 | 0 | 0.00% |
| WTA | 2021 | Indian Wells |  91 |  0 |  0 | 0 | 0.00% |
| ATP | 2023 | Indian Wells |  91 |  0 |  0 | 0 | 0.00% |
| WTA | 2023 | Indian Wells |  92 |  1 |  0 | 0 | 1.09% |
| WTA | 2021 | Madrid |  59 |  1 |  0 | 0 | 1.69% |
| ATP | 2023 | Madrid |  94 |  0 |  0 | 0 | 0.00% |
| WTA | 2023 | Madrid |  94 |  1 |  0 | 0 | 1.06% |
| WTA | 2021 | Miami |  90 |  1 |  0 | 0 | 1.11% |
| ATP | 2023 | Miami |  89 |  0 |  0 | 0 | 0.00% |
| WTA | 2023 | Miami |  92 |  0 |  0 | 0 | 0.00% |
| WTA | 2021 | Roland-Garros | 119 |  0 |  0 | 0 | 0.00% |
| ATP | 2023 | Roland-Garros | 124 |  5 |  0 | 0 | 4.03% |
| WTA | 2023 | Roland-Garros | 122 |  2 |  0 | 0 | 1.64% |
| WTA | 2021 | Rome |  51 |  0 |  0 | 0 | 0.00% |
| ATP | 2023 | Rome |  92 |  0 |  0 | 0 | 0.00% |
| WTA | 2023 | Rome |  90 |  0 |  0 | 0 | 0.00% |
| WTA | 2021 | US Open | 126 | 33 | 33 | 0 | 26.19% |
| ATP | 2023 | US Open | 121 | 46 | 42 | 1 | 38.02% |
| WTA | 2023 | US Open | 126 | 26 | 25 | 1 | 20.63% |
| WTA | 2021 | Wimbledon | 120 | 20 | 16 | 0 | 16.67% |
| ATP | 2023 | Wimbledon | 126 | 70 | 70 | 0 | 55.56% |
| WTA | 2023 | Wimbledon | 123 | 31 | 31 | 0 | 25.20% |

### Surface, format, round and tie-break distributions

| surface | Normal | Conflicts | Single_extra | Double_extra | Conflict_rate |
| --- | --- | --- | --- | --- | --- |
| Clay |  845 |   9 |   0 | 0 | 1.07% |
| Grass |  369 | 121 | 117 | 0 | 32.79% |
| Hard | 1604 | 107 | 100 | 2 | 6.67% |

| best_of | Normal | Conflicts | Single_extra | Double_extra | Conflict_rate |
| --- | --- | --- | --- | --- | --- |
| 3 | 2321 | 116 | 105 | 1 | 5.00% |
| 5 |  497 | 121 | 112 | 1 | 24.35% |

| round | Normal | Conflicts | Single_extra | Double_extra | Conflict_rate |
| --- | --- | --- | --- | --- | --- |
| F |   28 |   3 |   3 | 0 | 10.71% |
| QF |  111 |   6 |   6 | 0 | 5.41% |
| R128 | 1063 | 113 | 104 | 2 | 10.63% |
| R16 |  226 |  16 |  16 | 0 | 7.08% |
| R32 |  460 |  27 |  27 | 0 | 5.87% |
| R64 |  871 |  64 |  54 | 0 | 7.35% |
| SF |   59 |   8 |   7 | 0 | 13.56% |

| tiebreaks | Normal | Conflicts | Single_extra | Double_extra | Conflict_rate |
| --- | --- | --- | --- | --- | --- |
| 0 | 2007 |  12 |   0 | 0 | 0.60% |
| 1 |  663 | 178 | 173 | 2 | 26.85% |
| 2 |  127 |  35 |  33 | 0 | 27.56% |
| 3 |   20 |  11 |  10 | 0 | 55.00% |
| 4 |    1 |   1 |   1 | 0 | 100.00% |

The aggregate files additionally cross-classify cell × round, cell × tie-break count and all seven requested dimensions jointly. Different grouping views overlap: sum within a grouping, never across groupings. Counts of one in a fine-grained aggregate do not constitute a released match identifier. Small strata, especially four tie-breaks, do not establish stable rates or causal explanations.

## Saved evidence comparison

Only authorized saved evidence was used. Sixty-four independent literal SHA-256 pins cover Phase 2H code/test/report and all six outputs, Phase 2F code/test and fourteen outputs, the saved anomaly comparison, and the Phase 2H source/authority/reference pins. They are checked before processing and before output publication. These checks authenticate saved bytes against the project pins, not a complete upstream provider chain.

- **Recorded field definitions and current contract:** the saved project documentation names service games and explicitly leaves the service-game/tie-break convention for verification. No local saved dictionary/readme/license filename was found under `data/raw` in the targeted inventory search. The absence of such a saved definition does not establish that no external definition exists. No definition was fetched.
- **Indian Wells anomaly:** the pinned prior `anomaly-source-comparison.csv` is linked to the exact source key, two service-game fields and four saved score observations. WTA match and draw HTML and supplementary charted heading give `4-6 6-4 6-3`; the saved PDF extraction gives `46 64 63`. The prior adopted [quarantine evidence](wta-anomaly-and-quarantine-policy.md#structural-validation-and-source-dependence) establishes 29 games without a tie-break; source and official whole-match statistics both display 11 + 11. This is a demonstrated inconsistency in the published bundle, with correct individual counts and cause unknown. Their agreement may reflect shared upstream data; it is not independent confirmation of accuracy or a provider convention.
- **Other flagged events:** the authorized evidence used here supplies no independent count-definition or exact-match service-game corroboration that establishes a Wimbledon/US Open tie-break convention. The separate Montreal recovery and earlier pilot policies stay unchanged. Their bounded evidence cannot be transferred to unrelated records. Saved excerpts and prior verified extraction were reused; no fresh full official reconciliation or new extraction of point logs was performed.

## Deliverables and validation

Created [diagnostic code](../R/diagnose_service_game_conflicts.R), [focused tests](../R/test_service_game_conflicts.R) and this report; updated only [current status](status.md) and [source contract](data-source-contract.md). The ignored `data/pilot/service-game-convention-diagnostic/` release contains only:

- `discrepancy-summary.csv`: 1,282 aggregate distribution rows, including zero discrepancies, full group denominators/rates, evidence labels and summed G/T/S/E/D arithmetic.
- `hypothesis-summary.csv`: 6,184 aggregate pattern rows, including zero fits and an explicit zero documented-convention row for each group. Evidence basis, denominator and terminal recommendation are explicit.

No new match-level file is written. Transient arithmetic contains no player/source identifiers and is aggregated before export. Both files preserve the normal-record denominator and are ignored by Git.

**82 focused checks passed**: input pin failures; score/game identities and frozen-parser rejection; positive/negative discrepancies; noninformative T = 0 handling; single/double-extra hypotheses; saved anomaly linkage; all-237 and pattern accounting; all group denominators independently checked against normal records; aggregate arithmetic; zero-conflict cells; evidence labels; absence of player-side expectations/identifiers; row-order invariance; byte-identical independent runs; and refusal to overwrite changed or unexpected releases. All aggregate patterns, event totals and marginal summaries were inspected.

Final checks verify the exact five-file tracked scope, two ignored aggregate files, documentation consistency, local links, historical status/gate preservation and unchanged pre-existing fingerprints. Phase 2H’s six and Phase 2F’s fourteen output hashes, sizes and modification times remain unchanged; their code, reports, pins and historical 105/669-check records are preserved. Neither historical suite was rerun or repinned. No acquisition, dependency, parser extension, raw repair, admission change, expanded recovery, metric/model/history/Elo/forecast, OTD, portfolio modification, publication or push occurred.

## Limitations and approval boundary

The dominant arithmetic fit is evidence of a pattern, not evidence of its mechanism. A copied source error, inconsistent feed convention or another process could produce these totals; the diagnostic does not choose among them. The 17 unresolved conflicts retain unknown causes. The one demonstrated error does not authorize repairs or a broader error classification. The unsupported-score population was not reinterpreted, source errors can remain outside these flags, official recall remains unknown outside the saved pilots, and actual chronology remains unresolved.

No additional approval is needed to finish Phase 2I or leave existing exclusions intact. This phase authorizes no successor implementation. Any future analysis, acquisition or rule change needs its own explicit user scope; a rule-change proposal would additionally need saved evidence supporting the exact convention and affected tour/event/year boundaries. Arithmetic fit alone supplies no such approval basis.

## Terminal recommendation

**Preserve the current exclusion rule.** All 237 flagged records remain excluded, the full Phase 2H membership remains frozen at 2,580 admitted / 342 excluded, and no convention correction or rule change is implemented in Phase 2I.
