# Draft WTA 2021 Montreal recovery and status-evidence policy

**WTA Montreal recovery and status-evidence policy 0.1.0**

| State field | Current value |
| --- | --- |
| policy_status | PROPOSED_NOT_APPROVED |
| recovery_implemented | FALSE |
| status_precedence_implemented | FALSE |
| event_admission | NOT_EVALUATED |
| modeling_authorized | FALSE |

Phase 1H delivers this proposal for user review. It does not approve recovery, implement status precedence or grant analytical use. Every rule below describing future use is conditional on explicit approval. Version 0.1.0 is not adopted, active or controlling. A later approval should identify version 1.0.0 or another explicit adopted version and the exact approved scope; this task does not promote the draft. Committing a draft is not approval.

## Purpose, evidence and limits

The proposed policy would supply seven wholly missing WTA Montreal 2021 count bundles through a separate derived overlay while preserving both Sackmann and official WTA observations. It also proposes narrowly scoped treatment of conflicting status evidence. This supports the Four Factors versus surface-adjusted Elo research infrastructure, not a model result. Challenger promotion readiness remains deferred.

**Verified offline in Phase 1H:** all twelve Montreal reference files match the existing [manifest](../data/manifests/montreal-reference-files.csv), including sizes and SHA-256. Four ATP/WTA annual files from 2021/2023 match their pinned manifests. The archive revision remains `83733587353df8a41f2fd4f516147d5aa83f5a8d`. Saved match cards, whole-match counts, targeted PDF branches and structural checks were read or recomputed in memory and compared with the unchanged Phase 1G outputs. No downloader was called.

| Verified observation | Result and evidentiary boundary |
| --- | --- |
| Seven source bundles | All 18 counts are missing in each source row; identity, round, result and numeric score remain present. |
| Seven official candidates | LS001–LS007 each provide 18 exact whole-match counts; 126 field comparisons are `source_missing_official_present`. |
| Required-count disagreement | Zero observed conflicts; the seven source bundles have no competing counts. |
| Status-review counts | LS042 and LS049 each have 18 exact agreements with populated source counts, 36 altogether; neither is a recovery candidate. |
| Structural checks | All nine bundles pass 51 applicable checks each: 459 evaluated, zero flagged and zero unevaluable. The seven missing-bundle candidates account for 357 of these checks. |
| Orientation and status | All nine statistics name-bars are empty; ordered a/b columns and verified match cards support mapping. All nine match-specific metadata blocks say `EventScheduled` despite finished/completed cards. |
| Retirement observations | Match cards, structured score text and PDF support Martincova's retirement in LS042 and Tomljanovic's in LS049; both HTML draw cards omit RET. |
| Source-only coverage | 47/54 = 87.0370%, using the unchanged source apparent-play denominator. |
| Separate candidate availability | Seven candidates imply hypothetical 54/54, not implemented recovered coverage. Strict exclusion of any metadata-conflicted candidate still gives 47/54. |

The [Phase 1G report](wta-2021-montreal-reference-feasibility.md), [Phase 1F source review](wta-2021-montreal-admission-review.md), [Phase 1E audit](2021-annual-source-audit.md) and [source contract](data-source-contract.md) document the evidence and earlier decisions. Exact count agreement is not proof of independent measurement or statistical accuracy. Nine targeted draw matches do not establish complete event inventory. The cause of the missing bundles and meanings of H64/H61 remain unknown.

## Proposed exact scope

The recovery allowlist would contain only these seven source/page mappings. This is a scope specification, not populated overlay records or an approval of any row. Full source audit IDs use the prefix `sackmann:WTA:` before the source IDs below.

| Source ID | Official code | Round | Source winner → loser |
| --- | --- | --- | --- |
| 2021-806:238 | LS001 | F | Camila Giorgi → Karolina Pliskova |
| 2021-806:300 | LS002 | SF | Karolina Pliskova → Aryna Sabalenka |
| 2021-806:299 | LS003 | SF | Camila Giorgi → Jessica Pegula |
| 2021-806:298 | LS004 | QF | Aryna Sabalenka → Victoria Azarenka |
| 2021-806:297 | LS005 | QF | Karolina Pliskova → Sara Sorribes Tormo |
| 2021-806:296 | LS006 | QF | Camila Giorgi → Coco Gauff |
| 2021-806:295 | LS007 | QF | Jessica Pegula → Ons Jabeur |

The proposed recovery rule must fail closed for any other match, tour, event, season or representation. Preserve source match number 238 literally; it does not establish chronological order. Source Coco Gauff and WTA Cori Gauff are the bounded linkage documented in Phase 1G, not authority for a general name-matching rule. Preserve all source spellings and WTA IDs.

Status-observation scope is separately limited to `sackmann:WTA:2021-806:260` / LS042 and `sackmann:WTA:2021-806:253` / LS049. Their populated counts must not be overwritten, even where they agree. The existing twelve-reference manifest fixes the evidence; this draft permits no new URL access or acquisition.

## Proposed four observation layers

### Layer 1: immutable source observation

Keep the original Sackmann row, all raw fields, source identifiers, spellings, scores, match numbers and missingness. Never rewrite the annual CSV or replace unavailable counts with zero. Preserve source-only coverage as 47/54 for the declared Phase 1G source apparent-play cohort. Subsequent eligibility analyses must name their own denominator instead of silently redefining that historical measure.

### Layer 2: immutable official reference observation

Keep saved WTA bytes and the Phase 1G extracted observations separate from Sackmann. Preserve displayed values, exact fractions, extraction locators, whole-match scope, page order, a/b classes, WTA player IDs, reference IDs, hashes and retrieval metadata. Retain `EventScheduled`, omitted HTML retirement markers and other conflicts. These are official observations, not Sackmann corrections.

Existing extracted tables are reproducible observations of pinned bytes; this proposal would not edit them to encode a policy decision. A later approved extraction revision would need separate provenance, never silent replacement of the recorded evidence.

### Layer 3: derived recovery overlay — future only

An approved implementation would link a candidate field to one source audit ID and one official match code. The overlay would retain the original missing source value, exact candidate value, provenance, orientation, validation, disposition, rights and adopted policy version. The field schema is specified below, but Phase 1H creates no populated records, empty overlay file or recovery function.

Recommend one all-or-nothing release of the seven eligible bundles. Each bundle must contain every required field once, with no duplicate source-field links or ambiguous mappings. If any bundle fails, withhold the seven-bundle release and report blockers; do not select only enough matches to pass a coverage threshold. All seven remain audit candidates until approval and implementation succeed.

### Layer 4: canonical analytical record — future only

A later analytical layer would explicitly choose which observation an analysis reads and retain that choice's provenance. It requires user approval of the policy, completed and verified recovery implementation, complete event-inventory review, status/retirement rules, chronology rules for ratings or rolling features, and rights review for published outputs. Phase 1H creates no canonical table or analytical selector.

Approval alone would not mean implementation is complete; an implemented overlay alone would not admit Montreal to any model.

## Proposed recovery eligibility and blocking rules

A future implementation may recover a bundle only if **all** of the following are true; unavailable or ambiguous evidence must fail closed:

1. Every one of the source bundle's 18 required counts is missing.
2. Source identity, round, winner/result and numeric score remain present.
3. The official page agrees on exact tour, event, season, round, unordered pair, winner and score.
4. Page orientation is resolved before counts are mapped to source sides.
5. All 18 official counts are available and exactly parseable.
6. Each count derives from a displayed integer or exact displayed fraction.
7. Extraction selects the unique whole-match Match panel.
8. Every required field retains a specific reference locator.
9. Every applicable structural check passes, with mandatory checks evaluable.
10. All required saved reference bytes match their manifested sizes and hashes.
11. No required official field conflicts with a nonmissing source field.
12. The mapping is inside the seven-match allowlist above.
13. An explicitly adopted policy permits the proposed local analytical use; 0.1.0 grants none.
14. No identity or orientation ambiguity remains, and the proposed completion rule below is satisfied under an adopted version.

For each player the fields are `ace`, `df`, `svpt`, `1stIn`, `1stWon`, `2ndWon`, `SvGms`, `bpFaced` and `bpSaved`, retaining source `w_`/`l_` field names for audit linkage only. These are not outcome-neutral predictive features.

Mandatory structural checks include nonnegative integers, valid count bounds, first/second-serve opportunities, break points saved no greater than faced, consistent displayed denominators, service games reconciled to completed scores with tie-break adjustment, and cross-player service/return games. Existing Phase 1G checks are the evidence baseline; failed or unavailable mandatory checks must not be reclassified as success.

Block recovery for a partial source or official bundle, percentage-only reconstruction, summing set panels, unknown orientation, structural failure, any populated-source count conflict, changed/missing fingerprints, out-of-scope matches, or a proposed operation that depends on interpreting an unexplained suffix. A populated source count cannot be replaced merely because it agrees. Do not impute from scores, neighboring matches, averages or forecasts. Whole-bundle recovery prevents convenient field selection and threshold-driven match selection.

## Proposed empty-name-bar orientation rule

An empty statistics name-bar rules out name-bar-only orientation; it does not erase the other saved evidence. Require the exact match-card player pair, winner and score; the stable ordered a/b statistic-column classes; and an explicit relationship between match-card order and statistic-column order. Preserve both orders before applying the source-side mapping.

Use a reference-specific fingerprint consisting of its manifested SHA-256 and expected structural selectors: the scoped 0806-2021 match card, team-a/team-b rows, unique Match tab and bar--a/bar--b order. Require synthetic reversal tests with known expected values: reverse both card identities and statistic columns, then verify the same correctly mapped source-side counts. A test must also detect incorrect one-sided reversal.

Stop if the representation, fingerprint, relevant classes, winner mapping or ordering changes, or if identity cannot be established. A newly populated name-bar does not excuse a changed fingerprint. Do not infer orientation from favorable count agreement or a score alone. No new parser or orientation rule is implemented in Phase 1H.

## Proposed completed-match evidence rule

For **LS001–LS007 only**, recommend that an adopted implementation may classify completion for scoped count recovery when all of these agree:

- The visible match card shows completed or finished play.
- Winner and numeric score agree with the source.
- HTML draw advancement agrees.
- The PDF result agrees.
- Whole-match statistics are present.
- Match-specific completion fields, such as `completed=true` and status `F`, agree.

The proposed resolution state is `completed_match_evidence_controls_for_scoped_recovery_scheduled_metadata_preserved`. Preserve the original `EventScheduled` observation, its locator, reference hash and conflict flag. A future separate resolution record should name the adopted rule and supporting evidence, rather than changing the metadata itself.

This would be event- and match-scoped operational precedence, not a claim that JSON-LD is generally unreliable. It would allow the specified completion evidence to address this known conflict for recovery purposes only. A different unresolved result, identity or status conflict must block use. Phase 1H does not apply this precedence, relabel Phase 1G conflict flags or change its conservative coverage scenario.

## Proposed retirement-evidence rule

For LS042 and LS049 only, recommend an operational retirement observation when the match-card identity and numeric score agree with the source, the card names the retiring player, structured match-specific score text contains retirement evidence, the PDF marks retirement and names the player, and the HTML draw agrees on pair, numeric score and advancement but omits the marker.

Under that future rule, the HTML omission would be missing status detail, not affirmative evidence of a completed non-retirement result. Keep the omission and `EventScheduled` conflict as original observations. A contradictory affirmative status or retiring-player identity would require review, not silent preference.

| Target | Proposed operational observation | Source text that must remain unchanged |
| --- | --- | --- |
| LS042 / 2021-806:260 | Tereza Martincova retired; `official_retirement_confirmed_suffix_meaning_unresolved` | `6-1 4-3 RET+H64` |
| LS049 / 2021-806:253 | Ajla Tomljanovic retired; `official_retirement_confirmed_source_marker_missing` | `2-6 6-2` |

Phase 1G already records these as evidence findings; adopting operational precedence would be a separate decision. Retirement can be corroborated without explaining `+H64`. Keep H64 and the local H61 analog unresolved. Do not insert RET, add a deciding set, infer suffix semantics or alter historical source-only cohorts.

Retirement occurrence is separate from eligibility of retirement statistics for Four Factors, Elo updates or forecasts. Defer that eligibility decision, including other retired matches. The seven count-recovery candidates are completed matches, so their proposed recovery need not decide retirement eligibility.

## Proposed field-level provenance schema

This table defines future fields; it contains no populated recovery records.

| Required field or field group | Required meaning |
| --- | --- |
| source_audit_id; source_field | One full source audit ID and exact original field name; unique within an adopted overlay release. |
| original_source_value; original_missingness_state | Preserve the original unavailable value and its observed missingness representation; never encode it as zero. |
| official_reference_id; official_match_code | One official candidate match code and its manifested reference; supporting draw/PDF references remain linked separately. |
| official_player_orientation; source_side; orientation_evidence | Page a/b identity, WTA player ID/spelling, source-side mapping, card/column locators and reversal-test result. |
| raw_displayed_value; raw_fraction; exact_parsed_value | Original display text and the exact integer candidate, without reconstructing percentages. |
| fraction_numerator; fraction_denominator | Original displayed components where supplied; absent components remain unavailable, not zero. |
| extraction_locator; extraction_method; extraction_scope; extractor_version | Specific whole-match location, integer/fraction method, Match-tab scope and reproducible extractor version. |
| retrieval_hash; retrieval_timestamp; retrieval_class | SHA-256, original retrieval UTC timestamp and original-response classification from the manifest. Do not substitute a later check time. |
| structural_validation_state; validation_details | Applicable checks, results and supporting return-game/denominator observations, including any failure or unavailable test. |
| recovery_disposition; policy_name; policy_version | Separate overlay decision tied to an explicitly adopted version, never draft 0.1.0. |
| rights_classification; permitted_uses; prohibited_uses | Local-use boundary and continuing restrictions, retained at field and release level. |

Recommend `recovered_in_derived_overlay_source_preserved` only after approval and successful implementation. Do not use `corrected`: a missing source count supplies no competing value. A conflict with a populated count would receive `recovery_blocked_cross_source_conflict`; preserve both observations and do not choose whichever improves coverage. Other failures should retain specific reason codes and remain blocked.

## Proposed coverage reporting

Future reports should show these measures separately, with numerator, denominator, cohort definition and policy/implementation state:

| Measure | Phase 1H state | Conditional future meaning |
| --- | --- | --- |
| Source-only presence | 47/54 = 87.0370%, unchanged | Original source availability for the declared cohort, even if an overlay exists. |
| Approved recovered-overlay presence | Unavailable; recovery not implemented | Could become 54/54 only after explicit approval and all seven bundles pass implementation checks. This would combine 47 original bundles with seven transparently supplemental bundles, not claim 54 original bundles. |
| Valid analytical coverage | Not evaluated or reported as passed | Requires overlay passage plus applicable structural, inventory and eligibility rules; the approved analytical denominator may differ and must be stated. |

The Phase 1G 54/54 candidate-availability arithmetic remains hypothetical. Its strict conflict-exclusion scenario remains 47/54 until a later approved rule is implemented and reported separately. Preserve both historical scenarios; do not rewrite them after adoption.

Do not replace the source-only rate with a recovered rate, choose only the minimum two matches needed for 90%, shrink the denominator to available records or claim numerical coverage proves admission. Keep the existing 90% event and 95% tour-season thresholds unchanged. Do not evaluate the 95% gate in this phase.

## Admission, rights and cross-policy boundaries

Even an approved recovery policy would address only the seven missing count bundles and the explicitly scoped status observations. It would not settle complete Montreal inventory, retirement eligibility, walkover treatment beyond existing descriptive rules, actual dates, same-day or rating-update order, pre-2021 history, event/tour-season admission, common Elo/Four Factors populations or publication rights. Published match dates and source match numbers are not authorized chronology substitutes.

The ten-family panel and development/validation/test periods remain unchanged. No new season, analytical table, model, package, directory reorganization or portfolio work is authorized.

The adopted [WTA Indian Wells quarantine policy](wta-anomaly-and-quarantine-policy.md) and [ATP Indian Wells precedence policy](atp-inventory-reference-precedence-policy.md) remain untouched. Montreal's proposed handling of scheduled metadata cannot clear Andreescu–Stearns' structural/count conflicts or extend either policy's scope. An existing adoption elsewhere does not approve this draft.

Carry forward [DATA_LICENSE.md](../DATA_LICENSE.md) without a new legal conclusion: Sackmann data retains its documented CC BY-NC-SA conditions; public WTA pages supply no open-data grant. User authorization records local noncommercial research/auditing intent, not provider permission. This draft grants no new analytical or redistribution right. An adopted version would need to state the permitted local overlay use explicitly.

Do not commit raw WTA pages, full extracted match tables or populated match-level overlays. Website publication of recovered match-level WTA values remains prohibited pending separate rights review and authorization. Aggregate metrics, charts and exports also require review; aggregation is not an automatic permission. Portfolio integration remains a later, separately requested step.

## Verification and approval-to-implementation boundary

Phase 1H checked saved reference fingerprints, annual manifests, all seven recovery mappings and both status mappings; recomputed whole-match extractions, applicable structural checks and targeted PDF evidence in memory; checked field comparisons, source scores, suffix observations and coverage arithmetic; and inspected the existing policy boundaries. Existing data, manifests and generated observations are preserved. The verifier's initial blank-versus-NA comparison mismatch was corrected in the temporary read-only check, not in saved evidence. Report-only CSV type inference also briefly changed the display of an unavailable duration; restoring the original character type kept all calculated report lines unchanged.

Only the draft and current documentation are changed. The generated Phase 1G report receives its follow-up link through its existing generator; calculated findings and CSVs are unchanged. No future recovery implementation test is claimed to have passed. Approval-table completeness, policy-state distinctions, local links/anchors, paths, placeholders, whitespace, preserved-file hashes/modification times and the complete diff are checked before commit.

Next action: the user should review each decision below and explicitly approve, reject or revise it. Record approval against the exact version and scope; silence, this drafting prompt and the draft commit do not constitute approval. Only after explicit approval should ChatGPT prepare a bounded implementation prompt that records an adopted version and verifies an overlay without automatically creating canonical data or authorizing modeling. Every later task must end with a response-only ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000.

## User approval checklist

All ten entries remain pending. “Approve” is the recommendation, not a recorded decision. Existing thresholds and restrictions remain in force while these proposed policy choices await review.

| Decision | Proposed choice and recommendation | Reason | Effect if explicitly approved | User approval required | Current approval state |
| --- | --- | --- | --- | --- | --- |
| D1 | Separate derived overlay; approve | Preserves both original observations and provenance. | Authorizes the specified architecture for a later implementation; never rewriting Sackmann. | Yes | PENDING_USER_APPROVAL |
| D2 | Recover all seven eligible bundles together; approve | Avoids choosing only matches needed to cross a threshold. | A consistent seven-bundle release, withheld if any bundle fails. | Yes | PENDING_USER_APPROVAL |
| D3 | Require all 18 fields and every applicable structural check; approve | Presence and agreement alone do not establish structural validity. | Whole-bundle acceptance only; partial, ambiguous or failed candidates remain blocked. | Yes | PENDING_USER_APPROVAL |
| D4 | Scoped completion evidence controls while EventScheduled is preserved; approve for LS001–LS007 only | Multiple match-specific result observations agree despite conflicting metadata. | Allows a later scoped recovery resolution; does not delete conflict flags or generalize source precedence. | Yes | PENDING_USER_APPROVAL |
| D5 | Confirm LS042/LS049 retirement from match-specific and PDF evidence; approve as a status observation | Named retirement evidence is consistent; HTML merely omits the marker. | Enables later operational retirement observations without rewriting scores or admitting retirement statistics. | Yes | PENDING_USER_APPROVAL |
| D6 | Keep H64 and H61 unresolved; approve | No verified suffix meaning exists. | Preserves raw suffixes and prevents interpretation-dependent recovery. | Yes | PENDING_USER_APPROVAL |
| D7 | Defer retirement eligibility; approve | Status occurrence does not decide model or factor use. | Leaves retirement statistics, rating updates and forecasting eligibility undecided. | Yes | PENDING_USER_APPROVAL |
| D8 | Retain 90% event and 95% tour-season thresholds; approve | Recovery must not change the coverage standard after observing missingness. | Carries forward existing thresholds; neither gate is newly evaluated or passed. | Yes | PENDING_USER_APPROVAL |
| D9 | Keep event admission, chronology and modeling blocked; approve until separate gates are completed | Count recovery cannot establish inventory, dates, ordering or analytical populations. | Limits later implementation to its authorized recovery/status scope. | Yes | PENDING_USER_APPROVAL |
| D10 | Keep recovered match-level publication blocked; approve pending rights review | Public access and local-use intent do not grant redistribution rights. | Blocks match-level publication and requires review before aggregate exports. | Yes | PENDING_USER_APPROVAL |
