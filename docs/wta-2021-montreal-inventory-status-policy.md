# WTA Montreal inventory status-detail policy 1.0.0

**ADOPTED and IMPLEMENTED in Phase 1L, 2026-09-21.** The user explicitly approved D1-D8 of proposal 0.1.0 exactly as proposed. Approval is separate from the successful evidence checks and implementation. This is an inventory-only policy, not a Phase 1I extension.

## Current state

| Field | Current value |
| --- | --- |
| policy_status | ADOPTED |
| policy_version | 1.0.0 |
| policy_implemented | TRUE |
| inventory_reconciliation | COMPLETE |
| event_admission | NOT_EVALUATED |
| analytical_coverage | NOT_EVALUATED |
| modeling_authorized | FALSE |
| chronology | UNRESOLVED |
| primary_population_design | COMPLETED_MATCHES_ONLY_APPROVED_NOT_IMPLEMENTED |
| publication | BLOCKED_PENDING_RIGHTS_REVIEW |

## Approval and history

Phase 1K proposal 0.1.0 was PROPOSED_NOT_APPROVED with eight pending decisions. Its drafting commit 492714e8da898e03d3de4d69efb40a9d033a76b9 did not grant approval. The Phase 1L prompt explicitly approves D1-D8, authorizes the rename and adopts version 1.0.0. Git preserves the original draft. Phase 1J/1K inventory remained REVIEW_REQUIRED with three status-detail conflicts and 12/14 criteria passing. The implemented Phase 1L audit now applies all three resolutions and requires 14/14 criteria.

The separately approved [PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md) settles primary retirement/walkover exclusion and no round/prestige bonus in primary Elo. Neither this inventory policy nor context adoption creates the analytical population or changes raw records.

## Verified evidence and exact scope

Scope is WTA, season 2021, Montreal, source event 2021-806, main-draw singles. The following allowlist binds each code to its full source audit identifier, pair, round, advancing player, score and retiring player. No other event, season, draw or match is eligible for the adopted rule.

| Code | Source audit ID | Round | Advancing player / opponent | Source score; normalized PDF score | HTML numeric score | PDF legend identifies retiring player |
| --- | --- | --- | --- | --- | --- | --- |
| LS036 | sackmann:WTA:2021-806:266 | R64 | Maria Sakkari / Marie Bouzkova | 6-4 3-1 RET | 6-4 3-1 | Marie Bouzkova |
| LS054 | sackmann:WTA:2021-806:248 | R64 | Johanna Konta / Shuai Zhang | 4-6 5-2 RET | 4-6 5-2 | Shuai Zhang |
| LS026 | sackmann:WTA:2021-806:276 | R32 | Cori Gauff (official); Coco Gauff (source) / Anastasia Potapova | 5-0 RET | 5-0 | Anastasia Potapova |

The original PDF scores are respectively `64 31 RET`, `46 52 RET` and `50 RET`. Normalization inserts game separators without changing score direction or retirement evidence. Source strings remain unchanged. The already verified event-scoped Gauff identity decision is retained; this policy introduces no alias or identity rule.

The saved PDF's combined **RETIREMENTS/WALKOVERS** legend names each listed player. The legend alone does not distinguish retirement from walkover: the corresponding bracket result's explicit RET marker, the source RET marker, and the exact pair/advancement linkage supply that distinction. Medical reasons are not needed for this inventory decision and are not republished here.

Direct inspection of each saved HTML match block found `data-status="F"`, a matching winner ID/class, numeric score cells and no retirement marker or retirement title. The markup includes generic Upcoming, Suspended and Finished label elements; their mere text presence is not three affirmative match-status observations. No explicit normal-completion, non-retirement, walkover or contrary retiring-player statement was found in these three draw blocks. The generic F/Finished state is preserved and is not treated as an explicit assertion that a full normal match was completed. This is a bounded interpretation of the inspected draw evidence, not a claim about unsaved match pages or a general WTA status specification.

## Provenance and locators

All evidence remains in its original local file. The [Montreal reference manifest](../data/manifests/montreal-reference-files.csv), [development source manifest](../data/manifests/development-source-files.csv), and [pilot source manifest](../data/manifests/pilot-source-files.csv) retain URLs, retrieval metadata and existing pins; no URL was accessed in Phase 1K or Phase 1L. Archive revision remains `83733587353df8a41f2fd4f516147d5aa83f5a8d`.

| Observation file | Bytes | SHA-256 |
| --- | --- | --- |
| data/raw/reference/montreal-2021-feasibility/draw_html.html | 1388142 | 58e2a0f4c8ccce9440452e3fcdb449291e04bbc5ff5cd68e14e22b62ca4ff74d |
| data/raw/reference/montreal-2021-feasibility/draw_pdf.pdf | 176067 | 3b09b6de5390c717af4215d82efe3d332969a9674fc3c3b4db4bde86b5357d1c |
| data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta_matches_2021.csv | 531828 | 3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f |

The WTA annual source Git blob is `ca104914fcb353366e43f49face349960c15ec87`. Locate source rows by tour/event and the audit identifier's match number, never by row order or chronology. HTML locators are within `data-event-type=LS`; the official code must agree with the stated block. PDF coordinates below are page-one word-segment x/y minima from the existing pdftotext extraction, not image pixels.

| Code | HTML locator | PDF advancement; score locator | PDF legend name locator |
| --- | --- | --- | --- |
| LS036 | R64 block 5; data-match-counter=28; draw_html:R64:5 | draw_pdf:R64:5; (250.7688,169.91412); (250.76856,178.4178) | RETIREMENTS/WALKOVERS; (494.3688,650.1954) |
| LS054 | R64 block 23; data-match-counter=10; draw_html:R64:23 | draw_pdf:R64:23; (250.7688,466.0578); (250.76856,474.4578) | RETIREMENTS/WALKOVERS; (494.3688,671.0754) |
| LS026 | R32 block 11; data-match-counter=6; draw_html:R32:11 | draw_pdf:R32:11; (318.5688,441.71412); (318.5688,449.7378) | RETIREMENTS/WALKOVERS; (494.3688,678.4194) |

The existing ignored Phase 1J extraction, identity, source-inventory, linkage and reference-comparison tables retain full original observations and provenance. Phase 1L adds inventory-status-resolutions.csv in the existing ignored directory as a derived decision layer; raw extraction and source tables remain unchanged.

## Implemented rule and mandatory conditions

Implemented machine-readable resolution name: **`pdf_retirement_corroborated_html_omission_preserved`**. This name describes controlling PDF evidence and a preserved HTML omission; it does not imply HTML contains retirement evidence.

For exactly LS036, LS054 and LS026, the explicit retirement marker and retiring-player identification in the saved official PDF control **inventory status detail only**, if every condition below passes:

1. The exact tour, season, event, draw, official code and source audit ID are allowlisted. Existing event-scoped player IDs and spellings resolve unambiguously.
2. Required source, HTML, PDF and manifest fingerprints and locators are present and match the pinned evidence. Revalidate the existing Phase 1I overlay separately; its observations cannot substitute for these matches' evidence.
3. The source score explicitly contains RET. The PDF result independently contains RET, and its legend explicitly identifies the expected retiring player in the allowlist.
4. Source, HTML and PDF agree on the unordered player pair, round and advancing player; normalized winner-oriented numeric scores agree exactly. Preserve every original score and orientation.
5. The PDF legend's named retiring player maps uniquely to the non-advancing player in the same bracket result. Do not infer that identity merely from losing or from an incomplete score.
6. The HTML retirement marker is absent, and inspection finds no affirmative contrary status. Preserve the absence, raw F/Finished metadata and reference-conflict flag. A missing marker is not affirmative non-retirement evidence.
7. Record each approved derived resolution separately from raw observations, with policy version, exact evidence locators and validation results. Do not overwrite a source or reference value or erase the original discrepancy.

**Fail closed:** missing or changed fingerprints; missing evidence or locators; ambiguous identity; different pair, round, winner or score; absent RET; missing or different retiring player; affirmative non-retirement, walkover or other contradictory status; duplicate linkage; or scope mismatch must prevent this resolution. Unrecognized status semantics require review, not assumed compatibility. Preserve the conflict and keep reconciliation non-COMPLETE. Do not pick a preferred source merely to make counts agree.

## Atomic scope and failure behavior

The existing reconciliation workflow re-reads all pinned evidence and independently parses HTML/PDF before applying this policy. Supplied evidence must equal the freshly validated representation, including source provenance, original records, named legend text and locators. Per-match recorded fields must also agree with that representation. This binds provenance labels to actual content. Missing/changed input evidence stops or withholds resolution. A mismatch in any one target withholds all three new decisions, leaving non-COMPLETE inventory; no subset is applied. Other adopted Phase 1I resolutions remain distinct.

The separate ignored inventory-status-resolutions.csv records the exact three audit IDs/codes, adopted name/version, derived retirement observation, named retiring player, source/HTML/PDF scores, PDF RET/legend, original HTML omission/F metadata, original conflict flag/history, locators, hashes, sizes and source Git blob. Raw official extraction and source rows are unchanged. Links/reference comparisons reference the derived resolution without replacing raw statuses. Consumers must rerun validation before trusting saved outputs; an old file alone is not a current pass.

COMPLETE is permitted only when all three approved resolutions validate and every existing inventory criterion passes. Approval alone never establishes completion. No general PDF precedence or source correction is implemented.

## Existing policies and continuing boundaries

LS042 and LS049 stay under [Phase 1I recovery and status-evidence policy 1.0.0](wta-2021-montreal-recovery-policy.md); LS001-LS007 remain under its completed-match recovery rule. H64/H61 remain unresolved. The seven-bundle / 126-field overlay is reconstructed separately and retains its bytes and timestamp. Its SHA-256 remains 2b2d146bc22b947fc3dd5ee6e67cc6116c56245810569c6cce580af0c7a512b5 and size 760695 bytes.

Retirement occurrence is distinct from analytical eligibility. The approved primary design excludes retirements (including partial history inputs) and walkovers from Four Factors, Elo updates and primary evaluation while preserving audit records. No canonical selection, eligible denominator, count-coverage calculation, admission or model is implemented here. Historical apparent-play presence stays 47/54 source-only and 54/54 with the separate overlay. The 90% event and 95% tour-season thresholds remain unchanged.

Actual match dates/same-day order remain unresolved. No new acquisition, dependency, season or model is authorized. Publication remains blocked pending rights review, including aggregates; user approval is not provider permission. Portfolio is untouched. The standing chronological 2021-2023 / 2024 / locked 2025 design and pre-modeling tuning/evaluation requirement are unchanged; no 2025 data was accessed.

## Reproduction and verification

Run from the repository root with existing local evidence and installed utilities:

```sh
Rscript R/reconcile_montreal_inventory.R
Rscript R/test_montreal_inventory.R
Rscript R/test_montreal_recovery.R
```

[The inventory report](wta-2021-montreal-inventory-reconciliation.md) is generated from the workflow; [status](status.md) records final regression and preservation results. Tests retain historical no-new-policy controls and exercise every new success and failure gate, including missing or changed evidence, marker, legend, identity, round, result, score, fingerprint, locator, status and duplicate/scope cases; no partial application is permitted. Raw outputs stay ignored and untracked.

The first development run rejected a PDF roster attribute during record comparison. Comparing all record fields rather than unrelated data-frame attributes fixed this while preserving full-bracket and pinned-evidence validation; the failed run applied no new resolution.

## Approved decisions

All D1-D8 were explicitly approved in the Phase 1L prompt. No reapproval is required within this exact scope.

| Decision | Approved choice | Implemented result or continuing boundary |
| --- | --- | --- |
| D1 | Exact LS036/266, LS054/248, LS026/276 allowlist | Three derived inventory decisions only |
| D2 | Corroborated PDF RET and retiring-player name control inventory detail | All mandatory evidence conditions enforced |
| D3 | Preserve HTML omissions and original observations | Raw files/tables preserved; separate conflict history |
| D4 | Fail closed for every evidence or linkage conflict | Any failed target withholds all three decisions |
| D5 | No extension beyond these matches or inventory | Phase 1I scope and H64/H61 unchanged |
| D6 | Separate retirement occurrence from analytical eligibility | Completed-match-only design separately approved; canonical selector not implemented |
| D7 | Preserve remaining gates and thresholds | Admission/coverage/chronology/modeling/publication remain blocked or unevaluated |
| D8 | Require approval, implementation and passing tests before COMPLETE | All fourteen criteria required; three validated resolutions implemented |

## Next boundary

The smallest recommended next task is an offline completed-match eligibility and count-coverage audit under the approved context, preserving excluded audit records and separate overlay provenance. It should identify residual blockers without admitting Montreal or implementing chronology, canonical inputs or models. Any broader scope requires a separate request. Every next task must end with a response-only ChatGPT Handoff of approximately 2,000 words and no more than 2,000 words.
