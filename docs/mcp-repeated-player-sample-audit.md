# Broader repeated-player MCP sample and coverage

**BROADER_REPEATED_PLAYER_SAMPLE_BUILT_EVALUATION_UNSELECTED.**
Baseline `c607f9686bda19d115a4ccef0a0c49bcfd62b893`; user approved the saved
[broader-sample proposal](mcp-return-transfer-results.md#conclusion-and-one-next-executable-step).
Release `MCP_REPEATED_PLAYER_1.0.0`. This is an outcome-neutral convenience
sample and measurement inventory, not a representative or statistically adequate
cohort. No transfer estimate, score, factor, weight, action value or rating was calculated.

## Selection rules fixed before sequences were loaded

The [builder](../R/build_mcp_repeated_player_sample.R) accepts only an explicit
identity/context/date/linkage field allowlist. It cannot select on winners,
scores, completion, notes, errors, execution rates or parser/state success.

Context support requires an exact normalized Australian Open, Roland Garros,
Wimbledon or US Open label; a main-draw singles round R128/R64/R32/R16/QF/SF/F;
compatible source identifier date, M/W marker, event and round; best-of-five
men's or best-of-three women's format; distinct non-doubles player identities;
valid source date and surface; unique metadata ID; and one nonempty matching
point shard with unique point keys. Existing normalization trims spaces and
replaces event underscores; raw fields remain unchanged. Qualifying, juniors,
team/exhibition and other unverifiable event contexts are not silently admitted.

These are **source-supported major singles contexts**, not independent governing-
tour certification. ATP/WTA are men's/women's analysis categories corroborated
by the event, round, identifier and format, not file gender alone. Historical
men's major charts include pre-ATP-era matches. No claim of historical ATP
membership, full-tour scope or official completion follows from this labeling.
Saved metadata does not uniformly certify other events' tour levels, so those
contexts remain excluded rather than inferred. The sample does not restore the
historical ten-event panel.

Recurring means at least two distinct eligible linked matches in **different
source-date batches** within the same category. Same-date appearances alone do
not qualify. Exact saved player strings are identities; no alias inference.
For each eligible identity, hash the UTF-8 bytes of
`MCP_REPEATED_PLAYER_V1|ATP|<exact player name>` or the WTA equivalent, without
a trailing newline. Order recurring players by SHA-256 ascending, then exact
name in radix order for a hash tie; choose at most 20 per category.

For each selected player, order linked matches by source date then match ID;
retain the first five, or all when fewer exist. Include every match on the fifth
match's date, including boundary ties beyond five. Deduplicate the union by
unchanged match ID and retain both players. A selected player can therefore
appear additionally as another selected player's opponent. No player is replaced
because of failure or poor retention. Caps bound work, not statistical adequacy.

## Selection and source accounting

All source rights, sizes, SHA-256/Git blobs, revision and notation evidence verify
through existing helpers. Revision is
`1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`; saved CC BY-NC-SA 4.0 research-use
terms apply. No acquisition or new redistribution permission occurred. Historical
parser/state implementations are pinned and unchanged.

| Category | Metadata rows | Context/link eligible | Excluded | Eligible recurring players | Selected players | Deduplicated matches | Source-date batches | Distinct players / added opponents |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 7,566 | 2,023 | 5,543 | 325 | 20 | 75 | 74 | 78 / 58 |
| WTA | 4,264 | 1,354 | 2,910 | 268 | 20 | 84 | 80 | 79 / 59 |

Player-selection output retains every eligible identity, recurrence evidence,
hash input/hash, rank, selected status, cutoff and chosen-match count. Nonrecurring
identity counts are 211 ATP / 117 WTA. The cap leaves 305 / 248 recurring players
unselected. Some selected players have only two charts; no replacement occurs.
No actual fifth-match boundary tie expanded a selected player's five-match cap;
fixtures verify that such a tie would be included. The final inventory has five
two-match same-date batches (one ATP, four WTA) and 149 single-match batches.

Every metadata row has an explicit selection disposition, including simultaneous
reasons. Combined reason occurrences, **overlapping and not additive**:

| Reason | Rows |
| --- | ---: |
| Tour/event context unverified | 8,313 |
| Major/category format context unsupported | 5,260 |
| Main-draw context unsupported | 794 |
| Duplicate point keys | 51 |
| Point file context conflict | 37 |
| Point linkage missing/ambiguous | 37 |
| Source ID context conflict | 23 |
| Invalid/conflicting date | 19 |
| Duplicate metadata ID | 16 |
| Surface context unsupported | 11 |
| Singles identity ambiguous | 9 |

Dates span 1960-07-04–2025-08-28 ATP and 1993-07-02–2026-07-02 WTA.
No evaluation period was selected. All acquired years, including 2026, are exposed.

## Unchanged parser and state rules

Reuse `action_build`, `state_point`, `state_plus1`, observable-state construction,
and pre-action context classification without changing interpretations or QA
gates. An isolated adapter replaces the historical fixed-44 row-count/order
check with new inventory accounting and preserves the historical CSV loader's
numeric point-index type; historical functions/files remain unchanged.
Added audit fields expose existing score withholding and provenance;
they do not repair notation or grant admission.

| Category | Points | Parsed / parsed with explicit unknowns | Unsupported/unresolved | Outcome-only | Administrative | Terminal conflicts | Usable transitions / rows |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP | 19,006 | 16,522 / 52 | 2,059 | 371 | 1 | 1 | 81,962 / 96,782 |
| WTA | 12,212 | 9,496 / 21 | 2,588 | 107 | 0 | 0 | 45,235 / 63,380 |

All 31,218 points and 160,162 action/event/suffix rows remain. Source point totals,
server ownership and score replay reconcile; score-conflict points number zero.
One recorded terminal-outcome conflict remains withheld. Chart-score completion
is supported for 74/75 ATP and 83/84 WTA charts; this is not official completion.
Chung–Federer (2018-01-26) and Gasparyan–Svitolina (2019-07-03) have incomplete
chart endings. Neither contains a saved retirement-note cue in the selected
point records; do not infer a cause or repair them. Their observed prefixes remain
in this **sample inventory**, not a primary forecasting admission. A later
evaluation must freeze the completion/exclusion policy before using these charts
or their partial histories; the options below are opportunity support, not an
admission pass.

All parser reasons appear by category and match in the frozen point ledger and
reason summary. Failure occurrences:

| Failure reason | ATP points | WTA points |
| --- | ---: | ---: |
| INVALID_RALLY_DIGITS | 1,680 | 2,367 |
| INVALID_RETURN_DIGITS | 194 | 4 |
| MISSING_POINT_TERMINAL | 110 | 141 |
| UNSUPPORTED_SHOT_CODE | 108 | 137 |
| ERROR_WITHOUT_TERMINAL_MARKER | 99 | 56 |
| DROP_VOLLEY_MODIFIER_ON_OTHER_SHOT | 58 | 4 |
| SERVE_NET_CORD_AUTHORITY_CONFLICT | 32 | 22 |
| UNSUPPORTED_SERVE_START | 13 | 17 |
| SECOND_SERVE_WITHOUT_FIRST_FAULT_OR_FORFEIT | 12 | 14 |
| UNFORCED_ERROR_WITHOUT_ERROR_TYPE | 9 | 109 |
| TRAILING_SERVE_TERMINAL_OR_FAULT | 4 | 2 |
| TRAILING_POINT_TERMINAL | 0 | 128 |
| ERROR_CODE_WITH_WINNER | 0 | 1 |
| TERMINAL_OUTCOME_CONFLICT | 1 | 0 |

Reasons overlap; arithmetic agreement cannot establish undocumented meanings.
Explicit unknown error/fault/direction/shot codes remain separate. The 54
authority-conflict points, missing observations, raw notation, token spans and
source locations are preserved. No speculative interpretation was added.
Validated +1 attempts reconcile to 10,590 ATP / 5,932 WTA; observed prefixes are
12,548 / 8,438. Validation is parser evidence, not analytical match admission.

## Observable Return exposure and candidate history support

| Category/context | Observed attempts | Usable attempts | Retention | History-supported player/context cells | Supported players | Prior usable attempts range |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| ATP FIRST | 10,036 | 8,722 | 86.91% | 72 | 31 | 15–275 |
| ATP SECOND | 6,314 | 5,590 | 88.53% | 72 | 31 | 7–203 |
| WTA FIRST | 6,874 | 5,232 | 76.11% | 89 | 32 | 8–276 |
| WTA SECOND | 4,054 | 3,132 | 77.26% | 89 | 32 | 4–184 |

All 318 neutral slots and 636 recorded-context cells remain; 1,272 Return
context inventory rows also retain UNKNOWN and UNSUPPORTED. Zero target usable
FIRST/SECOND contexts number zero. Unsupported observed attempts are 9 ATP / 14
WTA and all withheld; usable unknown contexts number zero. Total Return
withholding is 2,047 ATP / 2,578 WTA, including those unsupported attempts.
Withheld observations are not successes, failures or absences.

Candidate prior pools use every sample match involving the same player/category
in strictly earlier source-date batches, including opponents added by union.
This measures opportunity support only; no error numerator, frequency estimate
or score is aggregated. Cold-start context cells number 156 ATP / 158 WTA,
including earliest appearances. Supported cells number 144 / 178, belonging to
72 / 89 receiver-match slots and 31 / 32 identities. All 20 selected players per
category have observable prior support; added opponents supply another 11 / 12.
Selected players contribute 55 / 72 supported slots; opponents contribute 17 / 17.

Prior-match depth reaches four ATP and seven WTA: opponent additions can exceed
the five-match selection cap. Whole-inventory match support is both/one/neither
players: ATP 12/48/15, WTA 18/53/13. Gaps since latest usable prior source-date
range 1–3,789 ATP and 1–8,088 WTA days. They are labels, not verified elapsed
availability or inactivity. Tour/player/match and every cell's denominator,
prior depth, gaps and withholding are exported.

Return retention pooled across compatible counts is 87.49% ATP / 76.44% WTA.
Player Return retention ranges 17.32%–100% / 14.63%–100%. Match transition
retention ranges 10.91%–100% / 6.46%–100%, distinct from Return retention.
Strong QA selection remains; rates on unobserved/withheld actions are unknown.

## Concrete chronological options — not selected

| Option/category | Seed matches / seed cutoff | Evaluation matches / batches | Supported context cells / players / selected players | No-prior context cells |
| --- | --- | ---: | ---: | ---: |
| All-date expanding / ATP | 1 / 1960-07-04 | 74 / 73 | 144 / 31 / 20 | 152 |
| All-date expanding / WTA | 1 / 1993-07-02 | 83 / 79 | 178 / 32 / 20 | 154 |
| After half the batches expanding / ATP | 37 / 2014-01-16 | 38 / 37 | 78 / 20 / 11 | 74 |
| After half the batches expanding / WTA | 42 / 2019-05-28 | 42 / 40 | 90 / 18 / 12 | 78 |

Both options keep whole matches/batches together and would use strictly earlier
data only; prior evaluated matches may train later batches. The half-batch option
uses the first floor(number of distinct source dates / 2) batches as seed,
including every match at the boundary date. It asks a narrower, later-calendar
question and loses support across selected players. No outcome or execution rate
was used to construct or recommend the dates.

Recommend **ALL_DATE_EXPANDING** for a conditional retrospective Return-transfer
experiment because it retains all observed recurrences and all 40 selected
players' supported encounters. It is not a new untouched test or contemporary-
form experiment. Long gaps, changing eras, repeated opponents, incomplete charts
and selective QA must accompany any claim. No period or adequacy threshold is
adopted by this recommendation; UNCERTAINTY_NOT_ESTABLISHED remains.

## Release, verification and next decision

One new builder, [focused tests](../R/test_mcp_repeated_player_sample.R), this report,
and current context/status/contract updates. Seventeen ignored flat
`data/pilot/mcp-repeated-player-v1-*.csv` outputs retain selection dispositions,
player selection, deduplicated sample; six parser outputs; four state/provenance
outputs; Return contexts, history support, coverage and evaluation options.

Output SHA-256 pins (same prefix and `.csv` suffix):

| File stem | Rows | SHA-256 |
| --- | ---: | --- |
| selection-dispositions | 11830 | `95aa84af5659363973958e5461edfb264c94f96883b7b6ed3859cdbcd8c2afad` |
| player-selection | 921 | `7f50f7519f11852a31fa1bc22d479151f19f2b2af30d56c5d22e8985ec7eed3a` |
| sample | 159 | `06bd5741f63fc47b8f9c683bad0ba5db543e45faea236e3290d10843ab574cdd` |
| actions | 160162 | `4d1dd07d783bbd689031731fe160996e8978a6f8dfd896ed56eb345a783c487a` |
| point-reconciliation | 31218 | `375b797eb056b9027dfa12f030d94d5de30bda6508730209d263af5f922d8337` |
| match-reconciliation | 159 | `94ebcd4e2aa53a3214416b7c0b81aac695c8615f4b950d4e9f2d51378300f3e2` |
| reason-summary | 35 | `85f4e82809870cd290b28a98b67bee39b943a0547bfccf2edfe0e742349930a0` |
| decoded-examples | 14 | `58940f278455e03c82d484302db1904ad1dd49d625322ed90b146034677b5188` |
| parser-summary | 3 | `cb4b2743f03ae718016836b5231b1c411d7513030381620dd9cb0c8b0af69ebc` |
| action-states | 160162 | `c9ff96dd67716c42064ea6fd7e27b7804b119dafeb444e5d39735b4ea6b25ce2` |
| serve-plus1 | 31218 | `a1be15b9b1a4eb34749e130d9a6a12d7e8710a7fbf7a67d5a6a24bcdbef1e798` |
| state-coverage | 299 | `360d8ca1518c7083a9298363a168f98727f1ed5f075914d27509caa51a8d30b3` |
| field-provenance | 129 | `458a1dc1678561f10b57ba2ba61175b894f964184d48922ab251499b3a2eff78` |
| return-contexts | 1272 | `aa344121d581221b0aed12f3455b240cd1894c6a97b1219808f005ade2d1ec22` |
| history-support | 636 | `556938e345dd1d71baad23129af5a8302a9ee06a0055637f4fea32cb313ecb29` |
| coverage | 318 | `c57353c380c86c7c622884bcf62f9f39fcc8b20f272b874bf1c6d4654044b8ee` |
| evaluation-options | 4 | `d55bd21bdbfbaec0857e59dc8ba9d880bfe664f0e5b7d51430f7ebba1f44dc50` |

Historical releases and scientific helpers remain byte-for-byte unchanged.
Installation stages/preflights every destination and uses atomic per-file renames;
the flat layout is not a crash-safe multi-file transaction.

Validation: **4,960 focused checks and 143 documentation, scope, pin, accounting
and preservation checks passed**. All seventeen independently rebuilt outputs
are byte-identical; 517 baseline historical artifacts and the three historical
document tails are unchanged. Selection invariance, boundary ties, exact ownership,
point linkage, Return denominators, earlier-batch history pools, withholding,
information boundaries, +1 reconciliation and ignored installation were checked.
No full historical suite was rerun.

Construction corrected an empty selection-label handling bug before
point parsing. An ordering check identified character point indices in the new
in-memory adapter; integer typing restores the historical CSV-loader behavior,
and a fail-closed check forbids changing any source label. No source value,
selection rule, notation interpretation or scientific QA gate changed.

**Exact next user decision:** choose ALL_DATE_EXPANDING (recommended) or
AFTER_HALF_BATCHES_EXPANDING for the broader sample; decide whether positive
prior-attempt support without a new minimum is sufficient for a descriptive
experiment, or specify prospective adequacy requirements. The next protocol
must also freeze completion exclusions for targets and prior contributions,
including the two incomplete charts, without outcome-based selection. No
estimation or scoring is authorized yet.

Suggested approval: “Freeze a broader-sample Return-transfer protocol using
ALL_DATE_EXPANDING, with whole-batch earlier-source-date histories, positive-
denominator cold-start abstention and no smoothing or new adequacy threshold.
Specify and freeze conservative completion exclusions for targets and prior
contributions, preserve all inventory coverage and exposed-year limitations,
and report the resulting support before execution. Fit or score nothing in
that protocol phase.”
