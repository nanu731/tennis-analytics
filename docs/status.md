# Tennis analytics status

Date: **2026-09-14**. **Phase 1H is complete: WTA Montreal recovery and status-evidence policy 0.1.0 has been drafted for review. policy_status = PROPOSED_NOT_APPROVED. All ten decisions remain PENDING_USER_APPROVAL. Recovery and status precedence are not implemented; event_admission = NOT_EVALUATED; modeling_authorized = FALSE.**

## Draft awaiting user decisions

The [Phase 1H draft](draft-wta-2021-montreal-recovery-policy.md) defines four separate layers: immutable Sackmann observations, immutable official observations, a future derived recovery overlay, and a future canonical analytical record. Only the proposal exists. No overlay records, canonical table, policy application or new data file was created. Version 0.1.0 is not adopted or controlling.

Its recommendations are: D1 preserve sources through a separate overlay; D2 recover all seven eligible bundles together; D3 require all 18 fields and structural checks; D4 apply scoped completion evidence while preserving EventScheduled; D5 confirm the two retirements as status observations; D6 leave H64/H61 unexplained; D7 defer retirement eligibility; D8 retain 90%/95% thresholds; D9 keep admission, chronology and modeling blocked; D10 keep publication blocked pending rights review. Every item requires explicit user approval. Existing restrictions stay in force while decisions are pending.

Phase 1H used only saved local evidence. Twelve Montreal reference fingerprints and four annual manifests passed; the nine match mappings, 180 official observations, 126 missing-source comparisons, 36 exact comparisons and 459 structural checks were rechecked without calling a downloader or rewriting observations. All 112 protected pre-existing files retain hashes, sizes and modification times; the four other pre-existing changes are this status, the contract, the Phase 1G generator and its follow-up report.

## Completed and verified

The flagship asks whether interpretable Four Factors improve match-forecast calibration over surface-adjusted Elo, separately for ATP and WTA. Challenger promotion readiness remains deferred until shared infrastructure is validated. This repository owns the research; portfolio publication needs completed, reviewed outputs and a separate request.

The user selected Phase 1F Option A investigation and allowed exactly twelve WTA URLs: overview, HTML draw, main-draw PDF, LS001–LS007 Montreal pages and LS042/LS049 Toronto-slug pages. All twelve returned HTTP 200 on the first direct attempt. Original bytes, sizes, SHA-256 and retrieval times are recorded in the [reference manifest](../data/manifests/montreal-reference-files.csv). No browsing-service fallback, search, hidden endpoint or computer control was used. Raw references and extracted match tables remain ignored; no WTA redistribution permission is inferred.

The [Phase 1G report](wta-2021-montreal-reference-feasibility.md) verifies these source/page mappings: 238→LS001, 300→LS002, 299→LS003, 298→LS004, 297→LS005, 296→LS006, 295→LS007, 260→LS042 and 253→LS049. All match pages show event 806, 2021 and Montreal; Toronto URL slugs do not override displayed identity. Round, player pair, advancing player and numeric score agree across the nine targeted match pages, HTML draw and PDF branches. This is not complete official inventory reconciliation.

LS001–LS007 each have 18/18 exact whole-match counts. All nine targets pass 51 applicable structural checks each: 459 passed, none flagged or unevaluable. Tests cover count bounds, displayed denominators, score/service games, tie-breaks and cross-player service/return games. Retirement checks allow an unfinished service game. The 162 required-field comparisons comprise 126 source-missing/official-present and 36 exact source/official agreements; no count conflict was observed. A separate table preserves 180 official observations, including 18 supporting return-game counts.

## Conflicts and status evidence

LS042 and the PDF confirm Tereza Martincova retired; LS049 and the PDF confirm Ajla Tomljanovic retired. Both HTML draw cards omit RET despite agreeing on score and advancement. Source scores remain `6-1 4-3 RET+H64` and `2-6 6-2`. States are `official_retirement_confirmed_suffix_meaning_unresolved` and `official_retirement_confirmed_source_marker_missing`. H64/H61 are not interpreted. These findings do not settle retirement eligibility.

All nine match-specific metadata blocks say EventScheduled despite finished/completed cards. These conflicts remain explicit. Official match dates are published metadata, not verified actual-play chronology; LS007 is dated August 14 while other quarterfinal metadata is August 13. Overview dates August 9–15 differ from the PDF's August 7–15 window. Eight source durations agree at integer-minute precision; the final's source duration is missing while WTA records 01:40:31.

Saved statistics name-bars are empty. Orientation uses the checked match cards and ordered a/b statistics columns/bar classes. The bounded Coco Gauff / Cori Gauff linkage is documented without changing source spelling or creating a global identity crosswalk.

## Coverage and review state

The [historical Phase 1F source review](wta-2021-montreal-admission-review.md) remains reproducible. It observes 55 source rows, 54 apparent-play rows, one walkover, four literal retirement markers and seven whole-bundle gaps. The additional officially corroborated retirement does not rewrite historical source cohorts. The zero-count walkover remains outside the apparent-play denominator.

| Scenario | Source bundles | Included official candidates | Coverage | Adopted policy |
| --- | --- | --- | --- | --- |
| Source only | 47 | 0 | 47/54 = 87.0370% | No |
| Separate candidate availability | 47 | 7 | Potential 54/54 = 100% | No |
| Hypothetical passing-bundle recovery | 47 | 7 | Hypothetical 54/54 = 100% | No |
| Strict exclusion of any conflicted candidate | 47 | 0 | 47/54 = 87.0370% | No |

Two later acceptable recoveries could reach the arithmetic 49/54 required for 90%. All seven count bundles are structurally acceptable, supporting **SUPPORTED_PENDING_RECOVERY_POLICY**. The strict conservative scenario excludes all seven because EventScheduled conflicts are unresolved. Source cells remain missing in every scenario; no recovered/canonical record is emitted. Denominators are source apparent-play observations, not approved inventory or eligibility rules. No 95% tour-season gate was tested.

**WTA Montreal reference-feasibility review 1.0.0** is an implemented review specification, not a recovery, precedence or admission policy. Its nine dispositions permit local auditing and feasibility review only; they prohibit source substitution, canonical recovery, Four Factors, Elo, forecasting, admission and publication.

## Existing evidence preserved

All four ATP/WTA 2021/2023 annual files were revalidated against pinned manifests. The archive revision remains 83733587353df8a41f2fd4f516147d5aa83f5a8d. Phase 1E still has twenty found source candidate cells, not official inventory confirmations. All 73 pre-acquisition snapshot files retain sizes, SHA-256 and modification times: prior raw evidence, manifests, policy specifications, applicable check code and generated outputs. Only authorized historical report follow-up notes changed through their generators.

Indian Wells 2023 ATP/WTA inventory gates remain PASS. ATP reference-precedence policy 1.0.0 retains four resolved PDF conflicts under its two approved branches and three conflicting match links. WTA quarantine policy 1.0.0 still quarantines Andreescu–Stearns' whole count bundle with all four reasons while retaining inventory/played-denominator membership. Existing valid-count coverage stays 93/94 WTA and 95/95 ATP. These policies do not admit Montreal.

## Reproduction and verification

The following reproduction commands describe the completed Phase 1G workflow, not authority to download in Phase 1H: `Rscript R/download_montreal_references.R` and `Rscript R/audit_montreal_reference_feasibility.R --self-test`. Phase 1H instead used read-only manifest validators and extraction/check functions, then regenerated only the Phase 1G Markdown report from unchanged saved outputs. Its report-only rerun is byte- and modification-time stable. No dependency or network access was used.

The existing Phase 1G test suite covers exact URL rejection; event/year/code/pair/round verification; reversed player orientation; Match-tab isolation; repeated set panels; integer/fraction extraction; missing/hidden values and percentage-only rejection; field locators and comparison states; invalid bundles; tie-break/retirement rules; raw score preservation; draw conflicts; 47/54 baseline; and nonadoption. Phase 1E/1F reproducibility, manifest validation, ignore rules, documentation links/anchors, machine paths, placeholders, whitespace and the complete diff are checked before commit.

Historical Phase 1G execution notes: Local development checks caught decorative hidden bars being mistaken for hidden values, an empty statistics name-bar, differing section/date labels and an overly broad footer locator. These were corrected without changing raw evidence. One synthetic round-mutation test initially failed to alter whitespace-containing HTML; the test was fixed to exercise actual rejection. A reference-only validation adapter initially lacked required event context; that interface was corrected without copying or filling source match rows. The report switched to REVIEW_REQUIRED during failure and was regenerated after correction. No retrieval failed and no unresolved execution failure remains.

Phase 1H verification covers all ten pending decisions, the five nonadopted state fields, unchanged evidence and manifests, draft/recovery/admission distinctions, coverage labels, local links/anchors, paths, placeholders, whitespace and the complete diff. A temporary comparison initially treated blank PDF non-retirement names differently from CSV NA; the read-only comparison was corrected, with no change to saved evidence. Report-only CSV type inference also briefly changed the display of an unavailable duration; restoring the original character type kept all calculated report lines unchanged.

## Smallest recommended next task

**User review is the next action:** approve, reject or revise each of the ten decisions in the [draft approval checklist](draft-wta-2021-montreal-recovery-policy.md#user-approval-checklist). The drafting prompt and commit do not constitute approval. Only after explicit approval should ChatGPT prepare a bounded implementation prompt identifying an adopted version and exact recovery/status scope. Do not populate an overlay, apply precedence or admit Montreal automatically.

Any new URL access, recovery/reconstruction method, eligibility change, dependency, substantial structural change or publication-rights assumption requires appropriate authorization. The ten-family panel, 90%/95% thresholds, 2021–2023 development, 2024 validation and locked 2025 test periods remain unchanged. 2022/2024/2025 acquisition stays closed.

No source repair, imputation, canonical recovery, admission, model, factor, forecast, predictive evaluation or portfolio change occurred. Nothing was pushed, published or deployed. DATA_LICENSE.md is unchanged.

## Git and handoff

Phase 1H began clean on main at 97f655bcac881a190a83396b45b1860358926df1, `Audit Montreal reference recovery feasibility`, ten ahead and zero behind the existing local origin/main. No later Phase 1H commit existed. Completion commit message: `Draft Montreal recovery policy for review`. The final response records the completed commit and final Git state; no remote refresh occurred.

Every next task must finish with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000, in the response only. Do not invoke a handoff tool or create another task without a separate request.
