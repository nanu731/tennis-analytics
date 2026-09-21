# WTA 2021 Montreal recovery and status-evidence policy

**WTA Montreal recovery and status-evidence policy 1.0.0**

| State field | Current value |
| --- | --- |
| policy_status | ADOPTED |
| policy_version | 1.0.0 |
| recovery_implemented | TRUE |
| status_precedence_implemented | TRUE |
| event_admission | NOT_EVALUATED |
| analytical_coverage | NOT_EVALUATED |
| modeling_authorized | FALSE |
| publication | BLOCKED_PENDING_RIGHTS_REVIEW |

## Approval and historical record

The Phase 1I user prompt, “Implement the approved WTA 2021 Montreal recovery policy,” explicitly approves D1–D10 from proposal 0.1.0 exactly as proposed. This records approval for bounded local noncommercial recovery and status observations. Successful verification of the seven-bundle atomic release establishes implementation, separately from approval. Neither establishes event admission, analytical eligibility, model authorization or provider permission to redistribute data.

Phase 1H version 0.1.0 was **PROPOSED_NOT_APPROVED**, with ten pending decisions and no implementation. Its commit `a22cb2179daa27541ddd94ae5de8bef88dba0d1b`, `Draft Montreal recovery policy for review`, did not constitute approval. Git retains that historical proposal. The specifically authorized rename removes `draft-`; this permanent document records the adopted rules. Earlier feasibility outputs retain their historical nonadopted state.

## Purpose and evidence

The policy supplies seven wholly missing WTA Montreal 2021 count bundles through a separate derived overlay, preserving Sackmann and WTA observations. It implements narrowly scoped treatment of conflicting status evidence for the Four Factors versus surface-adjusted Elo research infrastructure. It supplies no model results; Challenger promotion readiness remains deferred.

The [Phase 1G report](wta-2021-montreal-reference-feasibility.md), [Phase 1F source review](wta-2021-montreal-admission-review.md), [Phase 1E audit](2021-annual-source-audit.md), [source contract](data-source-contract.md) and [Phase 1I verification](wta-2021-montreal-recovery-verification.md) distinguish source observations, implementation and unresolved questions. Twelve saved official references match their [pinned manifest](../data/manifests/montreal-reference-files.csv). Four ATP/WTA 2021/2023 annual files match their manifests; archive revision is `83733587353df8a41f2fd4f516147d5aa83f5a8d`.

All nine targeted matches have matching identities, rounds, advancing players and numeric scores across source, match card, HTML draw and targeted PDF branches. Seven source bundles lack all 18 fields, yielding 126 source-missing/official-present comparisons. Two status-review bundles have 36 exact source/official agreements. All nine official bundles pass 51 applicable structural checks each: 459 checks, including 357 for recovery. Agreement is not proof of independent measurement or statistical accuracy. Nine targeted draw matches do not establish complete event inventory.

## Exact scope

Full source audit IDs use prefix `sackmann:WTA:`.

| Source ID | Official code | Round | Source winner → loser |
| --- | --- | --- | --- |
| 2021-806:238 | LS001 | F | Camila Giorgi → Karolina Pliskova |
| 2021-806:300 | LS002 | SF | Karolina Pliskova → Aryna Sabalenka |
| 2021-806:299 | LS003 | SF | Camila Giorgi → Jessica Pegula |
| 2021-806:298 | LS004 | QF | Aryna Sabalenka → Victoria Azarenka |
| 2021-806:297 | LS005 | QF | Karolina Pliskova → Sara Sorribes Tormo |
| 2021-806:296 | LS006 | QF | Camila Giorgi → Coco Gauff |
| 2021-806:295 | LS007 | QF | Jessica Pegula → Ons Jabeur |

Recovery fails closed for every other match, tour, event, season or representation. Preserve match number 238 literally; it does not establish chronology. Source Coco Gauff / WTA Cori Gauff is the bounded Phase 1G linkage, not a global identity rule. Preserve spellings and IDs.

Separate retirement-observation scope: `sackmann:WTA:2021-806:260` / LS042 and `sackmann:WTA:2021-806:253` / LS049. Neither receives recovered counts. The twelve-reference manifest fixes the evidence; Phase 1I authorizes no acquisition or new URLs.

## Four observation layers

1. **Immutable source:** retain original annual CSVs, fields, IDs, scores, match numbers, spellings and missingness. No unavailable statistic becomes zero. Historical source presence remains 47/54 for the declared apparent-play cohort.
2. **Immutable official reference:** retain saved WTA bytes and Phase 1G extracted observations, including exact displays/fractions, whole-match locators, page order, a/b classes, WTA IDs, hashes, retrieval metadata, EventScheduled and omitted HTML retirement markers. No policy resolution is written into those files.
3. **Implemented derived overlay:** link each field to one source audit ID and one official code. Retain missing source value and raw empty-cell representation alongside the supplemental value, orientation, provenance, validation, disposition and rights. Nine separate status-resolution records preserve supporting and conflicting observations.
4. **Future canonical analytical record:** not implemented or authorized. A later selector must retain provenance and follow separately approved inventory, eligibility, chronology and publication rules. No mixed filled-in Sackmann table is created.

The ignored local release is `data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds`. One RDS object holds distinct tables and release metadata; using a single file permits one atomic rename after complete validation. The successful release contains exactly seven bundles and 126 field decisions, all `recovered_in_derived_overlay_source_preserved`. An invalid bundle withholds the whole new release. An existing identical release is reused without changing bytes or timestamps. A different existing release is preserved and requires review; failure never returns it as a current successful result. Consumers must rerun validation before considering saved output current. No consumer is authorized for analytical use in this phase.

## Mandatory recovery gates

All fourteen requirements must pass; unavailable or ambiguous evidence fails closed:

1. All 18 source counts are missing, with their original empty-cell representation preserved.
2. Source identity, round, winner/result and numeric score remain present.
3. Official tour, event, season, round, pair, winner and score agree.
4. Player orientation is resolved before mapping counts to source sides.
5. All 18 official counts are available and exactly parseable.
6. Each derives from a displayed integer or exact displayed fraction.
7. Extraction uses the unique whole-match Match panel.
8. Every field has a specific reference locator.
9. Every applicable structural check passes and mandatory checks are evaluable.
10. All twelve references and relevant annual sources match pinned sizes/hashes; the three manifest files themselves match policy pins.
11. No populated-source count conflicts or replacements are permitted.
12. The source/page mapping is in the exact seven-match allowlist.
13. Adopted policy 1.0.0 authorizes only the specified local overlay verification use.
14. Identity/orientation is unambiguous and the scoped completion rule passes.

Each player contributes `ace`, `df`, `svpt`, `1stIn`, `1stWon`, `2ndWon`, `SvGms`, `bpFaced`, `bpSaved`. Source `w_`/`l_` labels are audit linkage, not outcome-neutral predictive features. Require every field exactly once per bundle and all seven bundles together.

Checks cover nonnegative integers, count bounds, first/second-serve opportunities, saved versus faced break points, exact displayed denominators, service games versus completed scores with tie-break adjustment, and cross-player service/return games. The implementation requires the exact 51-check set for every target and independently binds supplied audit records to a fresh raw-evidence audit.

Reject partial source/official bundles, percentage-only reconstruction, set-panel summation, unavailable locators, ambiguous orientation, changed/missing fingerprints, failed/unevaluable/missing checks, populated-source counts, duplicate links, missing fields, unexplained suffix dependencies, insufficient completion evidence and subsets. Never infer values from scores, neighboring matches, averages, rankings or forecasts.

## Empty-name-bar orientation rule

All nine saved statistics name-bars are empty. Require the scoped `0806-2021` match card, exact player pair/winner/score, team-a/team-b identities, unique Match tab, and ordered bar--a/bar--b statistic columns. Retain both page identities, winner side, source-side mapping and locators. A manifest SHA-256 pins the exact representation; a changed page requires review even if a new name-bar appears.

Synthetic tests reverse both identities and statistic values and verify unchanged correctly mapped source-side counts. Incorrect one-sided reversals must be detected. The tests establish parser behavior; they do not license releasing modified synthetic pages. Count agreement or favorable scores cannot substitute for orientation evidence.

## Scoped completed-match evidence rule

For **LS001–LS007 only**, operational state is:

`completed_match_evidence_controls_for_scoped_recovery_scheduled_metadata_preserved`

Require the visible finished card (including its displayed duration), source winner and numeric score, HTML draw advancement, PDF result, whole-match statistics, `completed=true` and status `F` to agree. Preserve the original match-specific `EventScheduled`, its locator, SHA-256, conflict flag and the rule/version. Separate resolution records implement recovery eligibility without relabeling source metadata or historical Phase 1G conservative scenarios. Other unresolved identity, result or status conflicts block recovery. This does not establish general precedence for WTA metadata or another match/event/season/tour/source.

## Scoped retirement observations

Require matching identity/numeric score, a named retiring player on the match card, retirement in structured score text, PDF retirement and named player, plus HTML pair/score/advancement agreement with the marker omitted. Preserve the omission and EventScheduled conflict. Contradictory affirmative evidence blocks the observation.

| Target | Implemented operational observation | Unchanged source score |
| --- | --- | --- |
| LS042 / 2021-806:260 | Tereza Martincova retired; `official_retirement_confirmed_suffix_meaning_unresolved` | `6-1 4-3 RET+H64` |
| LS049 / 2021-806:253 | Ajla Tomljanovic retired; `official_retirement_confirmed_source_marker_missing` | `2-6 6-2` |

Keep H64 and H61 unresolved. No RET insertion/removal, extra set, inferred suffix semantics, overwritten populated count or historical cohort change is permitted. Retirement occurrence does not decide eligibility for Four Factors, Elo, ratings or forecasts; those eligibility decisions were deferred in Phase 1I. Phase 1L separately approves primary retirement/walkover exclusion in PROJECT_CONTEXT.md, without implementing a canonical selector or altering this recovery policy.

## Provenance and local release schema

The [implementation](../R/implement_montreal_recovery.R) is the executable schema. `field_decisions` retains:

- `source_audit_id`, `source_field`, original parsed value, raw empty value, missingness state, source player IDs/spellings, score and physical data row.
- `reference_id`, `match_code`, page side/name/slug/WTA ID, source side, both card identities, advancing side, card locator and orientation basis/validation.
- `raw_display`, `raw_fraction`, `value`, `numerator`, `denominator`, parse state, scope, locator, extraction method and extractor version. Absent fraction components remain NA for directly displayed integers.
- Source/reference paths, URLs, sizes, SHA-256, original retrieval timestamps, source Git blob/archive commit/license URL and original-response retrieval class. Supporting HTML/PDF hashes and locators are linked; full reference retrieval metadata is in `reference_manifest`.
- The 51-check validation state/names, status resolution, preserved EventScheduled/conflict/locator, recovery disposition, policy name/version and permitted/prohibited-use fields.

Separate `status_resolutions`, `structural_checks`, `official_supporting_observations`, source/reference manifests and manifest pins retain audit details. Release metadata distinguishes source/supplemental bundles, denominator, approval, implementation, admission and publication states. Supporting official observations remain restricted; the entire populated release stays ignored. No populated values appear in committed code, tests, schemas or verification summaries.

## Coverage and boundaries

| Measure | Current state |
| --- | --- |
| Source-only presence | 47/54 = 87.0370%, unchanged source apparent-play cohort |
| Implemented source-plus-overlay presence | 54/54 = 100%; 47 original plus seven supplemental official-reference bundles |
| Valid analytical coverage | NOT_EVALUATED |
| Event admission | NOT_EVALUATED |
| 95% tour-season gate | NOT_TESTED |
| Modeling | Unauthorized |

Historical Phase 1G candidate/hypothetical 54/54 and strict-exclusion 47/54 remain historical scenarios. Do not replace source-only coverage, shrink denominators or select only enough matches to cross 90%. The 90% event and 95% tour-season thresholds remain unchanged. Overlay presence alone passes no admission gate.

Historical Phase 1I left inventory and eligibility unresolved. Phase 1L completes inventory and separately approves primary retirement/walkover exclusion; canonical populations, actual dates/same-day order, pre-2021 history and publication rights remain unresolved or unimplemented. Published dates and source match numbers are not chronology substitutes. No canonical data, features, models, new seasons, dependencies or portfolio work are authorized.

The [WTA Indian Wells quarantine](wta-anomaly-and-quarantine-policy.md) and [ATP precedence policy](atp-inventory-reference-precedence-policy.md) remain unchanged. Montreal's scoped rule cannot clear Andreescu–Stearns' count conflicts or expand either policy.

[DATA_LICENSE.md](../DATA_LICENSE.md) remains controlling: Sackmann's documented CC BY-NC-SA conditions remain; public WTA access grants no open-data permission. User approval expresses local research intent, not provider permission. Do not commit raw WTA pages, full official match tables or populated overlays. Match-level publication remains blocked pending rights review. Aggregate charts/exports also need review; aggregation grants no automatic permission. Portfolio integration requires a separate future request.

## Approved decisions

All ten decisions were approved explicitly in the Phase 1I prompt; none awaits reapproval within this scope.

| Decision | Approved choice | Implementation or continuing boundary |
| --- | --- | --- |
| D1 | Separate overlay, preserve sources | Implemented separate layers; no source rewrite |
| D2 | All seven bundles atomically | Seven released together; any failure withholds all |
| D3 | All 18 fields and applicable checks | 126 decisions; 357 recovery structural checks |
| D4 | Scoped completed evidence controls, preserve EventScheduled | Implemented for LS001–LS007 only |
| D5 | Corroborated LS042/LS049 retirement observations | Implemented separately; counts/scores preserved |
| D6 | Keep H64/H61 unresolved | No inferred meaning or suffix-dependent recovery |
| D7 | Phase 1I deferred retirement model eligibility | Historical decision; Phase 1L separately approves primary exclusion, canonical selector not implemented |
| D8 | Keep 90%/95% thresholds | Unchanged; no new admission gate evaluation |
| D9 | Keep admission, chronology, analytical/model use blocked | Continuing restriction |
| D10 | Block publication pending rights review | Continuing restriction, including review of aggregate exports |

## Reproduction and next boundary

Run from the repository root with existing R, SHA-256 utility and existing `pdftotext`:

```sh
Rscript R/implement_montreal_recovery.R
Rscript R/test_montreal_recovery.R
```

No network or package installation occurs. Missing/changed evidence stops execution. See [verification](wta-2021-montreal-recovery-verification.md) for recovery checks. Historical Phase 1J linked all 55 rows but left three retirement-detail differences outside this policy. Phase 1L now resolves those under a [separate inventory policy](wta-2021-montreal-inventory-status-policy.md), with [all inventory criteria passing](wta-2021-montreal-inventory-reconciliation.md). This changes neither this policy scope nor the recovery release and does not admit the event.

Every later task must end with a response-only ChatGPT Handoff of approximately 2,000 words and no more than 2,000 words.
