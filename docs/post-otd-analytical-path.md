# Phase 1T: analytical path after pausing Open Tennis Data

Date: **2026-09-28**. Decision: **REVISE_PHASE_2A**. Implemented here: documentation and offline contract tests only. Phase 2A implementation authorization: **PENDING_USER_APPROVAL**.

What useful analysis can begin with approved saved data while chronology-dependent forecasting remains blocked? A bounded pilot descriptive audit is plausible; a normally-completed-only analysis across all 40 saved source cells is not yet justified. Recommend the revised pilot-first scope below, without acquisition or a change to the ten-family research panel.

## Verified baseline and evidence

Started on clean main at `54075fe56d940a7d87356acfa37f4b8f2d07d0ed`, `Review Open Tennis Data documentation feasibility`, 26 ahead / zero behind the existing local origin/main. No remote refresh. Read [AGENTS.md](../AGENTS.md), [PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md), [status](status.md), [data contract](data-source-contract.md), and the historical [Phase 1Q](tennis-chronology-path-decision-brief.md), [Phase 1R](event-boundary-feasibility.md) and [Phase 1S](otd-documentation-preflight.md) reports before changes. Historical reports retain their original recommendations and approval states; this document and current status/contract supersede their next-step recommendations.

Saved evidence, revalidated through the relevant offline regressions:

- Four pinned annual files: ATP/WTA 2021 and 2023, archive `83733587353df8a41f2fd4f516147d5aa83f5a8d`. Annual row counts respectively 2,733 / 2,597 / 2,986 / 2,810. Nine counts per player appear in the shared 49-column schema; presence is not validity or independent accuracy.
- Phase 1R identifies **40 candidate cells / 3,832 source rows**, not 40 admitted events. Only **three** cells have reconciled inventory evidence; **37** remain UNVETTED_NONPILOT. Numeric score syntax alone cannot establish completion.
- ATP Indian Wells 2023: 95 results, 91 completed and four retired. WTA Indian Wells 2023: 95 results, 92 completed, two retired and one walkover. The completed Andreescu–Stearns bundle, source `2023-609:268`, remains quarantined; its match stays in the inventory and completed denominator.
- WTA Montreal 2021: 55 results, 49 normally completed, five retired, one walkover. Its completed-count audit validates 42 original bundles plus seven separate adopted recovery bundles: 49/49. Recovery is not merged into canonical input. These three pilots have no implemented common analytical selector.
- Phase 1R: **2,377 conditional dependencies, zero verified release support**. All 40 cells lack verified pre-play cutoffs, completion upper bounds and historical availability upper bounds. Phase 1S changes none of that.
- Phase 1S retained one license response: HTTP 200, 1,528 bytes, body SHA-256 `51e17ec16942ccd9f2512da9bb0ee32389579632094859a7efc6322f2f80cc0f`. Its two access/retention assessments remain AMBIGUOUS_STOP_REQUIRED. The other three targets were NOT_ATTEMPTED_STOPPED. This task makes no new external verification.

## OTD pause and acquisition boundary

**OTD status: PAUSED_BY_USER_AFTER_PHASE_1S.** This is the user's implemented workflow decision, not a finding that OTD is prohibited or permanently unusable.

No OTD clarification draft. No recipient discovery or verification. No maintainer or upstream contact. No access to the three unattempted documents, any other repository file, payload, release, archive, API or dataset. No reuse of the three unused Phase 1S request slots. No substitute provider or URL. No acquisition loop. No network request, browser, search, download, dependency installation or remote refresh in Phase 1T.

Preserve existing retained Phase 1S evidence unchanged; do not delete it. Its retention duration or disposition remains a separate unresolved decision, not a newly granted right. Resuming OTD requires **new explicit user authorization and exact scope**, with a sufficient rights basis. Reading saved audit evidence for required offline regressions does not authorize new access.

**Judgment, not verified provider capability:** further OTD investigation has low expected value for the present descriptive objective. It adds rights, provenance and historical-availability questions but supplies no newly verified count data or chronology. The already saved counts can support limited measurement checks without within-event forecast order. This opportunity-cost judgment is not a claim that OTD could never help forecasting. Do not replace OTD with another open-ended search.

## Two analytical lanes

### Lane A: measurement and descriptive development

Proposed future work: audit candidate metrics describing the same completed match, with Net Point Rating (NPR) as the primary explanatory outcome, equal-phase NPR as sensitivity, and optional match win as an external same-match check. These quantities are all post-match. Their relationship does not require within-event forecast ordering, but it still requires verified identities, statuses, point definitions, valid counts and scoped rights.

This is **explanatory and exploratory, not a pre-match forecast**. It cannot establish future-match predictive value, that Four Factors outperform Elo, causal mechanisms, or that overfitting has been avoided. Strong associations can arise from mathematical coupling with NPR. Final factors and weights still require out-of-time validation. No empirical relationship, factor, coefficient, weight or diagnostic result is calculated in Phase 1T.

### Lane B: forecasting and Elo comparison

**Match-sequential forecasting remains the intended primary target.** Operational chronology, event-entry batching, canonical analytical population, Elo, rolling histories and forecasts remain **NOT_IMPLEMENTED**. Event admission remains **NOT_EVALUATED**; modeling authorization **FALSE**; publication **BLOCKED_PENDING_RIGHTS_REVIEW**.

Current blockers: safe player-relative order across events; supported information cutoffs; completion and historical availability of each included result/statistic version; warm-up and off-panel history scope; usable history volume; unresolved roles/windows/inactivity rules; canonical eligibility, validated coverage and relevant rights. Bracket edges and event labels do not establish historical release. No assumed delay cures these gaps. No release schedule or tournament-entry batching is implemented. Descriptive progress cannot clear a forecasting gate.

## Q decisions and exact recommendations

The following table is the current authority record. An approved specification is not an approved implementation.

| ID | Status | Scope |
| --- | --- | --- |
| Q1 | PENDING_USER_APPROVAL | WTA clarification route; no new contact work |
| Q2 | PENDING_USER_APPROVAL | Provider contact; no recipient verification or sending |
| Q3 | APPROVED_DOCUMENTATION_PREFLIGHT_ONLY | Completed Phase 1S only; OTD now paused |
| Q4 | APPROVED_DOCUMENTATION_PREFLIGHT_ONLY | Completed Phase 1S ceiling only; unused slots unavailable |
| Q5 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY | Completed Phase 1R; no batching implementation |
| Q6 | PENDING_USER_APPROVAL | Recommendation below, not adopted |
| Q7 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY | Completed Phase 1R boundary specification only |
| Q8 | PENDING_USER_APPROVAL | Recommendation below, no lag selected |
| Q9 | PENDING_USER_APPROVAL | Recommendation below, no K selected |
| Q10 | PENDING_USER_APPROVAL | Recommendation below, no inactivity rule implemented |
| Q11 | PENDING_USER_APPROVAL | Return-to-sequential evidence/implementation decision |
| Q12 | APPROVED_SPECIFICATION_FEASIBILITY_ONLY | Completed Phase 1R only; does not authorize Phase 2A |

### Q6: event-entry role — PENDING_USER_APPROVAL

**Recommended choice:** retain sequential primary; event-entry is a development fallback candidate and, if sequential becomes feasible, a sensitivity analysis. **Reason and scientific benefit:** preserve the intended pre-match-information question while making the effect of stale pre-event information testable. **Limitation:** the estimands differ; an event-entry win against frozen Elo is not superiority to standard sequential Elo. **Missing evidence:** supported cutoffs/releases, shared-player order, useful histories and matched information across models.

**Would authorize:** recording this research role only. **Would not authorize:** event-entry forecasts, a primary-estimand replacement, a release lag, model code or data acquisition. **Exact approval question:** “Do you approve Q6: retain match-sequential forecasting as primary, treat event-entry freezing only as a development fallback candidate and later sensitivity analysis, and require a separate protocol amendment before making it primary?”

### Q8: release lag — PENDING_USER_APPROVAL

**Recommended choice:** prefer evidence-triggered release; select no arbitrary one-event, one-week or longer lag as verified chronology. **Reason and scientific benefit:** preserve the distinction between known historical availability and a robustness assumption. **Limitation:** no current dependency has verified release support; this principle does not unblock one. **Missing evidence:** reliable completion/availability upper bounds, pre-play cutoffs, precision/timezone and correction/version history.

**Would authorize:** recording that principle; a later prespecified conservative lag could be proposed only as labeled sensitivity. **Would not authorize:** selecting a delay, treating delay as proof, releasing data or constructing histories. **Exact approval question:** “Do you approve Q8: use evidence-triggered release as the preferred principle, select no numerical lag now, and permit any later conservative lag only through a separately approved, explicitly assumed sensitivity protocol?”

### Q9: history window — PENDING_USER_APPROVAL

**Recommended choice:** consider last-K eligible completed matches before elapsed-calendar windows, once safe player order, availability, warm-up coverage and cross-event histories exist. **Reason and scientific benefit:** an ordinal window asks less of calendar precision and preserves an interpretable sample-size unit. **Limitation:** it still needs order and availability; sparse histories and the elite panel create selection and cold-start problems. **Missing evidence:** validated cross-event player links/order, eligible history volume, warm-up scope and defensible minimum samples.

**Would authorize:** a future design preference, not a K choice. Future K comparisons must occur within development and 2024 validation, then freeze before 2025. **Would not authorize:** histories, calendar proxies, new warm-up data or implementation. **Exact approval question:** “Do you approve Q9: consider last-K eligible completed matches first once order, availability, warm-up and cross-event histories are safe, with K and implementation deferred to a separately approved development/2024 comparison frozen before 2025?”

### Q10: inactivity — PENDING_USER_APPROVAL

**Recommended choice:** defer inactivity adjustment until reliable activity dates and a prespecified activity definition exist. **Reason and scientific benefit:** prevent fabricated elapsed time from changing ratings. **Limitation:** deferred decay cannot represent real inactivity; its predictive cost is unknown. **Missing evidence:** actual activity timing, definition of last activity, treatment of excluded RET/WO, off-panel activity and validated decay alternatives.

**Would authorize:** a documented deferral only. **Would not authorize:** tournament-label/event-start proxies, arbitrary decay, data acquisition or a fitted rule. **Exact approval question:** “Do you approve Q10: defer inactivity adjustment until reliable activity dates and an explicit activity definition are available, without substituting tournament labels, event-start dates or arbitrary decay?”

These four questions are independent recommendations, not approvals inferred from the Phase 1T prompt. They do not have to be resolved to authorize the purely descriptive revised audit. Q1/Q2/Q11 remain pending; Q3/Q4 are completed approvals with OTD paused; Q5/Q7/Q12 remain limited to Phase 1R.

## Proposed Phase 2A contract

**Title: Phase 2A: development-only Four Factors candidate-metric feasibility audit.** Full scope is not ready; the revised first implementation below requires explicit approval. Nothing here changes the established ten-family panel or permanent development/validation/test split.

### Population, evidence and stop rules

- ATP and WTA analyzed separately. Established families only: Australian Open, Roland-Garros, Wimbledon, US Open, Indian Wells, Miami, Madrid, Rome, Canada (Montreal/Toronto edition cities retained), Cincinnati.
- Saved **2021 and 2023 development data only**; no 2022 acquisition, **no 2024 model selection**, **no access to 2025 data or results**. Saved annuals and already approved local references/overlays only; no source acquisition.
- Main-draw singles only. Normally completed matches only. Preserve but exclude retirements, partial retirement statistics and walkovers from every candidate/outcome calculation. Unknown/conflicting status fails closed; counts and numeric score syntax do not prove completion. Never drop an unknown record to improve a gate.
- Preserve Indian Wells quarantine and all source conflicts, including ATP PDF identity dissent and Montreal raw status/metadata differences. The quarantined WTA match remains in its completed denominator but contributes no statistical bundle. No source repair or policy extrapolation.
- Scope analytical calculations to the three reconciled pilot cells after an audit-only eligibility/count adapter is approved and validated. Reconstruct each existing event's evidence and policy before selecting rows; withhold a failing cell. Do not silently reduce this scope to the remaining successful cells. Report a blocked result if a prerequisite fails.
- Keep all 40 cells in a metadata/availability inventory with the 37 unvetted cells visibly not eligible for metrics. For those 37, source-field missingness may be reported over source rows only, never as eligible-completed coverage. No completed-only estimates or invented official denominators there.
- A later extension to the full saved ten-family panel requires independently reconciled inventories/statuses and explicit scope approval. This pilot audit is not tour-season factor-model admission: preserve 90% event / 95% tour-season gates, NOT_TESTED tour-season admission and NOT_EVALUATED event admission. Do not redefine denominators or waive gates. No public claim of a representative panel.
- Preserve raw files, source IDs/spellings and whole-bundle provenance. Read the Montreal recovery as a separate approved layer; do not overwrite source NA or broaden its seven-match authority. Report source-only versus recovery-supported diagnostics separately where meaningful.
- Use deterministic outcome-neutral A/B orientation from stable source IDs within tour for this bounded audit, preserving original sides and a match key; it is not a global canonical identity table. Swap tests must exchange every paired field and negate NPR. Two player rows from one match are dependent, not two independent matches.
- No publication, portfolio integration, website exports or new licensing inference. Existing local audit authority is not public derivative permission.

### Count notation and common rules

For player i, opponent j: A=ace, D=df, S=svpt, I=1stIn, F=1stWon, Q=2ndWon, G=SvGms, B=bpFaced, V=bpSaved. Each suffix exists with original w_ and l_ prefixes; remap the entire side together. Every formula below is a fraction except NPR, and is a **proposed diagnostic**, not a selected final factor.

**U1 (required for every candidate):** if the denominator is zero, return NA with zero_opportunities; if any required input is missing, return NA with missing_input; if inputs or denominators violate the count contract, return NA with invalid_bundle. Keep structural, sporadic and eligibility-related missingness distinct. Missing required inputs must not be labeled legitimate zero opportunities. Never replace NA with zero, epsilon, a mean or a fabricated count. Negative denominators are invalid, not small samples. Report positive but small denominators separately without choosing a minimum threshold now.

Require nonnegative integer counts and 0 <= I <= S, 0 <= F <= I, 0 <= Q <= S-I, 0 <= D <= S-I, Q+D <= S-I, 0 <= V <= B <= S, A <= F+Q. Require paired point-universe consistency and applicable score/service-game/tie-break checks. S-I includes double faults: do not subtract D again for ordinary second-serve success. Only the explicitly named non-double-fault sensitivity conditions them out. Aces may occur on second serves. Verify definitions against the saved dictionary and scoped checks; do not infer unreturned serves from aces.

### Candidate catalogue

The formula is Numerator / Denominator in every row. U1 applies separately to **every** listed denominator. “Higher/lower” means a hypothesized association with same-match advantage, not a verified effect. The supplied fields are suffixes on the indicated player's source side. Coupling includes shared point outcomes even without an exact algebraic identity.

| ID / metric | Numerator | Denominator | Required source fields | Interpretation / expected direction | Valid range | Undefined rule | NPR coupling | Overlap | Hypothesis family | Failure or replacement reason |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| M01 ace rate | A_i | S_i | ace_i, svpt_i | Aces per service point; higher | [0,1] | U1 | Aces are a subset of service points won | M03, M15 | Serve Creation | Omits other unreturned serves; not pure serve quality |
| M02 first-serve-in rate | I_i | S_i | 1stIn_i, svpt_i | First-serve frequency; higher hypothesized, speed/security tradeoff | [0,1] | U1 | Mixture weight in service success | M03, M04, M15 | Serve Creation | Direction may reverse after serve-quality adjustment |
| M03 first-serve success | F_i | I_i | 1stWon_i, 1stIn_i | Wins conditional on first serve in; higher | [0,1] | U1 | Direct NPR component | M01, M02, M15; complement of opponent M09 | Serve Creation | Includes rally/opponent effects; sparse denominator |
| M04 second-serve success | Q_i | S_i-I_i | 2ndWon_i, svpt_i, 1stIn_i | Wins after missing first serve, including DF; higher | [0,1] | U1 | Direct NPR component | M05, M07, M15; complement of opponent M10 | Second-Serve Security | Includes return/rally effects; rare second serves |
| M05 double faults per second serve | D_i | S_i-I_i | df_i, svpt_i, 1stIn_i | Failure after missing first serve; lower | [0,1] | U1 | DF is a subset of lost service points | M04, M06, M07 | Second-Serve Security | Small denominator; may repeat M04 rather than add a mechanism |
| M06 double faults per service point | D_i | S_i | df_i, svpt_i | Total-service-point DF burden; lower | [0,1] | U1 | Same lost-point subset | M05 times (1-M02) | Second-Serve Security | Blends first-in frequency with second-serve risk |
| M07 non-DF second-serve success sensitivity | Q_i | S_i-I_i-D_i | 2ndWon_i, svpt_i, 1stIn_i, df_i | Success conditional on avoiding DF; higher | [0,1] | U1 | Subset ratio of NPR counts | M04 = M07 times (1-M05), where defined | Second-Serve Security | Conditions away errors; cannot replace M04 without a new decision |
| M08 return-point success | S_j-F_j-Q_j | S_j | svpt_j, 1stWon_j, 2ndWon_j | Wins on opponent serve; higher | [0,1] | U1 | Direct NPR component | M09, M10; complement of opponent M15 | Return Pressure | Broad outcome-like benchmark, not a distinct mechanism |
| M09 first-serve return success | I_j-F_j | I_j | 1stIn_j, 1stWon_j | Wins against first serves in; higher | [0,1] | U1 | Direct NPR component | M08; complement of opponent M03 | Return Pressure | Opponent serve quality confounds interpretation |
| M10 second-serve return success | S_j-I_j-Q_j | S_j-I_j | svpt_j, 1stIn_j, 2ndWon_j | Wins after opponent first miss, including DF; higher | [0,1] | U1 | Direct NPR component | M08; complement of opponent M04 | Return Pressure | May credit opponent DF as return skill |
| M11 break chances per return game | B_j | G_j | bpFaced_j, SvGms_j | Opportunities generated per opponent service game; higher | [0,Inf) | U1 | Same-match pressure/points, not an exact NPR identity | M08, M12 | Return Pressure | Can exceed one; repeated deuce chances and game conventions |
| M12 break-point conversion | B_j-V_j | B_j | bpFaced_j, bpSaved_j | Opponent break chances converted; higher | [0,1] | U1 | Subset of return points won, conditional on pressure | M11; complement of opponent M13 | Conversion and Recovery | No-opportunity NA, noisy selection; not clutch |
| M13 break-point saving | V_i | B_i | bpSaved_i, bpFaced_i | Saves conditional on facing break point; higher | [0,1] | U1 | Subset of service points won, conditional on pressure | M15; complement of opponent M12 | Conversion and Recovery | No-opportunity NA, noisy selection; not clutch |
| M14 break points faced per service game | B_i | G_i | bpFaced_i, SvGms_i | Pressure faced per service game; lower | [0,Inf) | U1 | Same-match losses/pressure, not an exact NPR identity | Opponent M11, M13, M15 | Conversion and Recovery | Exposure measure, not recovery skill; repeated opportunities |
| M15 service-point success benchmark | F_i+Q_i | S_i | 1stWon_i, 2ndWon_i, svpt_i | Broad service success; higher | [0,1] | U1 | Direct NPR component | M02*M03 + (1-M02)*M04, where defined | Serve Creation | Diagnostic comparator, almost outcome decomposition; not automatically a factor |

M07 is only a proposed sensitivity definition; including it in an approved audit would not replace the documented ordinary second-serve rate. Unreturned serves, placement, rally tolerance, leverage sequences and expected conversion/saving residuals are not recoverable from these nine counts alone. No invented proxies or fitted clutch residuals. If Conversion and Recovery offers no stable distinct information, report that four mechanisms are unsupported in this sample.

### Outcomes and coupling checks

Let W_i = F_i+Q_i+S_j-F_j-Q_j, W_j = F_j+Q_j+S_i-F_i-Q_i, T = S_i+S_j.

| Outcome | Exact formula | Numerator / denominator | Fields | Range / undefined behavior |
| --- | --- | --- | --- | --- |
| Primary NPR | 100*(W_i-W_j)/T = 200*W_i/T-100 | 100*(W_i-W_j) / (S_i+S_j) | Both players' svpt, 1stWon, 2ndWon | [-100,100]; U1 on T; suspect zero phase totals also flag bundle |
| Equal-phase NPR sensitivity | 100*((F_i+Q_i)/S_i+(S_j-F_j-Q_j)/S_j-1) | Service wins / S_i and return wins / S_j, then sum minus one times 100 | Both players' svpt, 1stWon, 2ndWon | [-100,100]; U1 on each phase denominator; requires both positive |
| Optional same-match win | 1 if verified winner is i, otherwise 0 | Indicator; no statistical denominator | Verified winner, neutral player ID and completed status | {0,1}; unknown/conflicting winner/status withheld, not imputed |

NPR is service/return success weighted by service-point opportunities; equal-phase NPR gives both phases equal weight. Verify point-win reconciliation and player-swap sign symmetry, recognizing these identities are partly tautological. A high correlation or R-squared from its own components measures decomposition, not independent validation. Same-match win is not an algebraic re-expression of NPR, but it remains a post-match outcome of the same play and cannot validate a future forecast.

### Diagnostics and boundaries

Proposed outputs: a formula/data dictionary; exact input/provenance list; all-40-cell scope/coverage matrix; three-pilot eligibility and exclusion audit; local candidate/outcome tables; denominator/missingness/distribution summaries; exploratory pairwise correlations and algebraic redundancy map; a limitations report with a go/revise/stop recommendation. Restricted row-level outputs stay ignored under existing data/pilot/ structure; base R can implement the first pass without a dependency. The next approved prompt must name its exact output paths before writing. No new top-level structure, moved file or canonical table is proposed.

For each available tour/season/event/surface and field, report expected inventory, source rows, completed denominator, valid bundles and defined metric counts separately. Distinguish missing raw inputs, invalid/quarantined values, true zero opportunities, and eligibility exclusions. Do not let pairwise complete-case correlations conceal different samples: show pair counts and a common-bundle sensitivity. A single overall missing percentage is insufficient.

Examine ranges, impossible counts, distribution tails and small denominators. Show redundancy/correlations and exact identities before considering multicollinearity diagnostics such as rank/condition checks on a standardized candidate matrix; constant columns and insufficient samples must be explicit failures, not zero correlations. Do not fit coefficients or publish weights as part of these diagnostics. Avoid treating complements from opposite sides as independent findings.

Evaluate ATP/WTA differences descriptively with separate denominators; retain match pairing and repeated-player dependence. Compare sensitivity to influential matches, denominator tails and omission of individual pilot events without selecting a favorable final specification. No unapproved minimum-volume cutoff or numerical significance claim. Any later uncertainty method needs a prespecified player/match-aware design; naive independent-row p-values are inappropriate.

**Known limitations of the revised first step:** all three pilots are hard-court events; ATP contributes 2023 Indian Wells only. WTA contributes Montreal 2021 and Indian Wells 2023, so event and season effects are confounded. Surface stability is NOT_ASSESSABLE; independent season stability is NOT_ASSESSABLE. Report these unavailable comparisons explicitly. The broad full-panel audit would eventually assess hard/clay/grass and season stability, but these pilots cannot do it. No general four-factor verdict follows from three convenience pilots.

**Not authorized in Phase 2A:** imputation, choosing mean or PMM, final four-factor selection, published weights, forecast fitting, rolling histories, Elo, opponent-strength model fitting, 2024 tuning, 2025 inspection, out-of-sample performance claims, or claims that documented safeguards prove absence of overfitting. No portfolio/publication. Phase 1T implements none of these and implements no candidate calculations.

Missingness findings should inform the later formal comparison of appropriate complete cases/no imputation, mean, mean plus justified missingness indicators, and PMM multiple imputation. Every procedure must eventually be fitted inside chronological training samples/resamples only, never using future matches, validation/test outcomes or the full dataset. Never impute outcomes or unavailable-to-zero. No imputation may bypass eligibility, quarantine, undefined denominators or coverage. Later authorized comparisons use calibration, Brier score, log loss and stability; no method is preselected. Freeze factors, transforms, weights, Elo and imputation choices before 2025. [Standing guidance remains unchanged](../PROJECT_CONTEXT.md#overfitting-and-missing-data-comparisons).

## Prerequisite and authority matrix

| Prerequisite | Verified or adopted state | Effect on revised Lane A | Remaining authority / Lane B |
| --- | --- | --- | --- |
| Saved counts/provenance | Four pinned 2021/2023 annuals; schema present | Recheck pins and conventions; no new source | No authority for other seasons/files |
| Panel inventory/status | Three reconciled pilots; 37 unvetted cells | Restrict metrics to pilots; preserve all 40 in scope inventory | Full-panel normally-completed analysis blocked |
| Completed-only eligibility | Approved design; Montreal audit implemented only | New audit-only three-pilot adapter needs explicit approval and tests | Canonical selector remains NOT_IMPLEMENTED |
| Structural count validity | Montreal 42+7; IW quarantine/scoped checks | Revalidate both sides and defined denominators before metrics | Presence/structural algebra is not independent truth |
| Recovery/precedence | Narrow adopted event/match policies | Reuse only their scope, preserve raw conflicts | No global status default or count correction |
| Coverage | 90% event / 95% tour-season gates preserved | Pilot diagnostics are not factor-model admission | Tour-season NOT_TESTED; admission NOT_EVALUATED |
| Chronology | Zero verified release support for 2,377 dependencies | Not needed for same-match descriptive audit | Forecasting remains BLOCKED |
| Source and publication rights | Saved local research scope; unresolved derivative/retention issues | Private bounded diagnostics only after user scope approval | No new licensing inference or publication |
| Software/structure | Base R and existing directories sufficient | No dependency required for proposed first pass | Any later dependency/structural change needs approval |
| Q authority | Table above; Q6/Q8–Q10 pending | Independent of descriptive approval | No chronology role/lag/K/decay chosen |
| Final selection/validation | Standing future-model requirements adopted, unimplemented | Diagnostic exploration only | Protocol, method choices, histories and model approval still needed |

## Final decision and exact next approval

**REVISE_PHASE_2A**, not STOP_ANALYTICAL_PATH: useful formula/denominator diagnostics appear possible with saved pilots. Do not issue GO_TO_PHASE_2A for an all-40-cell completed-only audit: 37 inventories/statuses are unvetted, no common analytical eligibility/count adapter exists, and full coverage/admission is not demonstrated. The smallest non-acquisition revision is the pilot-first audit above. This narrows the diagnostic implementation sample, not the permanent research panel, and must be explicitly approved rather than silently treated as a gate waiver.

**Exact next user approval required:** “Do you approve the revised Phase 2A: an offline, development-only candidate-metric feasibility audit that first validates an audit-only completed-match/count adapter for ATP and WTA Indian Wells 2023 and WTA Montreal 2021, then calculates descriptive candidate metrics only for those three reconciled pilot cells; keeps all 40 saved 2021/2023 cells in a coverage/availability inventory with the other 37 unvetted and excluded from metrics; preserves all eligibility, quarantine, source conflicts and 90%/95% gates without admitting a model cohort; and performs no acquisition, imputation, forecasting, final factor selection, 2024 tuning, 2025 access or publication?”

If approved, the next complete implementation prompt should specify local outputs inside existing directories, existing R helpers to reuse, immutable input pins, scoped eligibility tests, synthetic formula/denominator/swap fixtures, missingness and coupling diagnostics, unavailable-comparison labels, deterministic reruns, preservation and restricted-file checks, documentation updates and a clear commit. Stop with a blocked report if a pilot prerequisite cannot be reproduced; do not fetch evidence or infer missing eligibility. Require a response-only ChatGPT Handoff of no more than 2,000 words.

Unverified assumptions to test then: candidate measures offer distinct information; observed variation is sufficiently broad; sample sizes/denominators are useful; recovery does not drive apparent patterns. No statistical result or guaranteed feasibility is asserted now. No genuine contradiction with PROJECT_CONTEXT.md was found, so it remains unchanged. Further dependencies, structure, data expansion, method replacement and publication rights remain separate user decisions. Challenger promotion readiness stays deferred until validated flagship infrastructure; the portfolio repository remains untouched.

## Verification scope

[R/test_post_otd_analytical_path.R](../R/test_post_otd_analytical_path.R) checks the document contract, negative mutations, baseline, authority, catalogue completeness, offline-only code, historical preservation and links. Relevant Phase 1Q/1R/1S, chronology-policy and acquisition-plan regressions and preservation/restricted-file checks are recorded in [status](status.md). These checks verify documentation and saved-evidence/software contracts, not metric performance, statistical generalization or fresh external rights.
