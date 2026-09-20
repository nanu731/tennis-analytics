# Phase 1I Montreal recovery verification

Date: 2026-09-20. **PASS: adopted policy 1.0.0 implemented as seven atomic recovery bundles / 126 field decisions and nine separate status resolutions.** This is local recovery verification, not event admission or analytical validation. No match-level recovered count values are included in this report.

## Starting state and approval

The task began on clean `main` at `a22cb2179daa27541ddd94ae5de8bef88dba0d1b`, `Draft Montreal recovery policy for review`, eleven commits ahead and zero behind the existing local origin/main. No fetch occurred. Before any repository modification, all twelve Montreal references and four ATP/WTA 2021/2023 annual files matched pinned manifests. The user explicitly approved D1–D10 from proposal 0.1.0 and authorized its one rename to the [permanent adopted policy](wta-2021-montreal-recovery-policy.md). No other reorganization occurred.

## Implemented result

| Match code | Full source audit ID | Recovery fields | Applicable checks | Disposition |
| --- | --- | --- | --- | --- |
| LS001 | sackmann:WTA:2021-806:238 | 18 | 51 passed | recovered_in_derived_overlay_source_preserved |
| LS002 | sackmann:WTA:2021-806:300 | 18 | 51 passed | recovered_in_derived_overlay_source_preserved |
| LS003 | sackmann:WTA:2021-806:299 | 18 | 51 passed | recovered_in_derived_overlay_source_preserved |
| LS004 | sackmann:WTA:2021-806:298 | 18 | 51 passed | recovered_in_derived_overlay_source_preserved |
| LS005 | sackmann:WTA:2021-806:297 | 18 | 51 passed | recovered_in_derived_overlay_source_preserved |
| LS006 | sackmann:WTA:2021-806:296 | 18 | 51 passed | recovered_in_derived_overlay_source_preserved |
| LS007 | sackmann:WTA:2021-806:295 | 18 | 51 passed | recovered_in_derived_overlay_source_preserved |

Every original source field remains missing. All 126 links are unique. Field-level provenance includes original empty-cell representation and parsed NA, source and official identities/orientations, exact displays/fractions, methods/locators, source/reference fingerprints and retrieval metadata, full validation details, disposition, adopted version and rights restrictions. The ignored RDS also retains structural checks, official supporting observations and full manifests as separate tables.

All seven completed-match resolutions use `completed_match_evidence_controls_for_scoped_recovery_scheduled_metadata_preserved`. The named rule does not remove EventScheduled, its conflict flag, locator or fingerprint. Separate LS042/LS049 operational retirement observations preserve `6-1 4-3 RET+H64` and `2-6 6-2`, respectively, plus both HTML RET omissions. Their 36 populated source counts agree and are not recovered or overwritten. H64/H61 remain unresolved and retirement model eligibility remains NOT_EVALUATED.

Source-only presence stays **47/54 = 87.0370%**. Implemented source-plus-overlay presence is **54/54 = 100%**, explicitly 47 original source bundles plus seven supplemental official-reference bundles. Valid analytical coverage and event admission are **NOT_EVALUATED**; the 95% tour-season gate is **NOT_TESTED**. Modeling and public export remain unauthorized. Neither the 90% nor 95% threshold changed.

## New automated tests

`Rscript R/test_montreal_recovery.R` passes **38 named checks**. The checked-in [test script](../R/test_montreal_recovery.R) exercises the actual publisher, requiring a rejected release to create no output or temporary residue.

- Seven bundles, 18 fields each, 126 unique links, missing source preservation, separate nine status records and blocked analytical states.
- Required provenance, live source/reference fingerprints, immutable manifest pins, rights fields and Git ignore/tracking boundary.
- Out-of-scope source and official IDs; partial source; populated-source conflict; partial or missing official field; duplicate source-field link.
- Percentage-only reconstruction; set-panel summation; missing locator; ambiguous orientation; incorrect source-side mapping.
- Changed/missing reference fingerprint and changed source fingerprint.
- Failed, unevaluable or missing mandatory structural check; unexplained suffix dependency.
- Missing completion fields; missing visible finished evidence; unresolved draw/status conflict; removal of the recorded scheduled conflict; conflicting retirement identity.
- Fewer than seven bundles; each of the seven bundles failing individually withholds the entire new release.
- Correct two-sided synthetic reversal preserves mapped counts; both incorrect one-sided reversals differ and are detected. Synthetic pages are never release evidence.
- Repeat execution preserves release bytes and modification time. Independent serializations are byte-identical. A failed rerun preserves an earlier release but returns an error rather than current success.
- Raw, extracted and populated recovery data remain untracked and ignored.

No original test was weakened. The workflow re-extracts the pinned raw evidence, compares every historical Phase 1G CSV, checks exact per-match structural-check membership and binds the candidate audit to another fresh read before writing. Validation precedes any staging file. One same-directory rename publishes the complete RDS. An existing differing release is never overwritten.

## Earlier checks rerun

- **Phase 1E:** `annual_2021_self_test()` passed allowlist/pin, metadata, SHA-256 mismatch rejection, malformed CSV, required/schema fields, tournament aliases and ambiguous/missing/year candidates, status evidence and annual-row namespaces. Cached downloader and audit reruns preserve bytes/timestamps with requests blocked.
- **Phase 1F:** `montreal_self_test(review_wta_2021_montreal())` passed source bundle, malformed/partial/negative count, structural bounds, literal retirement/suffix, incomplete-score, event-selection, source-preservation and deterministic rerun tests.
- **Phase 1G:** `mrf_self_test(audit_montreal_reference_feasibility(write_outputs=FALSE))` passed URL/event/year/code/player/round guards, orientation reversal, whole-match/duplicate-tab/set isolation, exact integer/fraction extraction, hidden/missing/percentage-only rejection, comparisons, invalid count bundles, tie-break/retirement game rules, source/status preservation, draw conflicts, coverage arithmetic and historical nonadoption. Cached reuse made no requests; report/CSV reruns preserved bytes/timestamps. A request guard would stop any attempted acquisition.
- **Relevant Phase 1H checks:** revalidated twelve reference and four annual fingerprints; nine identity mappings; 180 observations; 162 comparisons split into 126 missing-source and 36 exact agreements; 459 passing/evaluable structural checks; source missingness, literal H64/H61 observations and historical coverage states. Report-only reruns are stable. The former pending-approval expectation is superseded by explicit Phase 1I approval, not transferred to historical Phase 1G outputs.

## Preservation, documentation and execution notes

The pre-edit snapshot contains 117 existing files. The five authorized existing paths are the policy rename, status, contract, Phase 1G generator and its report. **All other 112 files retain identical SHA-256, size and modification time**, including all 90 existing data files. The only new data artifact is the ignored `data/pilot/development-2021/montreal-recovery-overlay-1.0.0.rds`. Original annual files, reference bytes, manifests and earlier extracted tables were not rewritten.

All 94 local documentation links/anchors across 14 Markdown files pass. Affected rename references, adoption/implementation/admission distinctions, placeholders, machine-specific paths, whitespace, restricted-data tracking/staging and the complete diff were checked before commit. Historical claims remain labeled by phase. No portfolio files were read for implementation or modified. No network, package installation, model work, push, publication or deployment occurred. DATA_LICENSE.md and both Indian Wells policy implementations remain unchanged.

The initial release attempt correctly failed closed: the implementation expected a literal “Finished,” while saved cards contain “Finished: duration.” The condition was corrected to the exact recorded format, retaining all corroboration requirements. No partial output was written. Two nonessential inspection lookups also found no old temporary Phase 1H files and no skill at an obsolete optional path; neither changed the repository or evidence, and current repository functions supplied the verification. No unresolved execution failure remains.

Runtime: **R 4.6.0 (2026-04-24)**, base/recommended packages already installed; existing SHA-256 utility and `pdftotext`. No new dependency or statistical method was introduced. PDF research-report context was read locally; its broad coverage claims were not independently re-audited here.

## Reproduction and next step

```sh
Rscript R/implement_montreal_recovery.R
Rscript R/test_montreal_recovery.R
```

Run from the repository root with the original manifested local evidence. No download is performed. Missing or changed inputs stop execution. RDS fields can be inspected locally with `readRDS`, but reading an old file alone does not revalidate it or authorize analytical use. The next task should separately authorize complete offline Montreal inventory reconciliation, report gaps and preserve the overlay's distinct provenance. Chronology, retirement eligibility, canonical populations, admission, wider acquisition and publication rights require later decisions.

Completion commit message: `Implement Montreal recovery overlay policy`. The response records the exact resulting hash and final clean Git state; this file cannot contain its own commit hash. Future tasks require a response-only ChatGPT Handoff of approximately 2,000 words and no more than 2,000 words.
