# WTA Montreal 2021 completed-match eligibility and count coverage

Phase 1M; audit version 1.0.0. Numerical event gate: **PASS**. Event admission: **NOT_EVALUATED**.

## Inventory and status eligibility

Fresh inventory state: COMPLETE. All 55 non-bye results are preserved: 49 normally completed, 5 retirements, 1 walkover, 0 unresolved.

All five retirement decisions must revalidate under the adopted Phase 1I and Phase 1L policies, including LS049/Ferro–Tomljanovic despite its missing source RET marker. The raw scores, five HTML omissions and scoped conflict history remain unchanged. Retirements and the walkover are excluded from the completed denominator, valid numerator and all Four Factors, Elo-update, rolling-history and evaluation status-eligibility flags in this event audit. These flags are not model authorization or a canonical panel selector.

Normal completion requires linked source/HTML/PDF winner and score agreement plus complete numeric result scores in all three representations. Generic F metadata and populated counts alone never establish completion. Unknown or conflicting status is preserved, excluded pending review and withholds a numerical PASS.

## Completed-match count coverage

| Measure | Verified result |
| --- | --- |
| Valid unchanged original-source bundles | 42/49 = 85.7143% |
| Separate approved overlay bundles | 7 |
| Source plus approved overlay | 49/49 = 100.0000% |
| Required at the unchanged 90% event threshold | ceiling(0.90 × 49) = 45 |
| Numerical threshold result | PASS |

The denominator depends on validated completion evidence, never count availability. Missing, malformed or invalid counts reduce the numerator without removing normally completed matches from the denominator. All 18 required fields must pass the existing nonnegative-integer, component-bound and game/score checks; original bundles require all 43 checks evaluable and passing. Recovery requires all 51 checks per bundle, exact field links, orientation, provenance and the adopted seven-bundle policy. Structural consistency is not independent proof that every recorded statistic is correct. No filled-in Sackmann table is produced.

## Historical apparent-play measures

Unchanged historical presence is 47/54 source-only and 54/54 with the separate overlay. These include retirements and are not completed-match analytical coverage.

## Evidence protections and reproduction

The workflow reconstructs current evidence twice, validates pinned manifests and source/reference fingerprints, reparses official observations, rebuilds both adopted policy layers and compares the existing recovery release with its fresh reconstruction. Saved generated tables alone cannot establish a current pass. Missing or changed evidence stops the run before any output write; a previously saved result is not a fresh validation. Only existing local 2021/2023 evidence is read; no 2025 data or network is used.

```sh
Rscript R/audit_montreal_completed_match_coverage.R
Rscript R/test_montreal_completed_match_coverage.R
```

Four ignored local tables are written under data/pilot/development-2021/montreal-completed-match-coverage/: dispositions.csv (all results, raw evidence, linkage, decisions and provenance); count-links.csv (separate origins and validation); structural-checks.csv; summary.csv. No recovered count values or full official draw are committed. Existing raw evidence, manifests, generated observations and the populated Phase 1I overlay are preserved.

## Admission and remaining blockers

| Gate | State |
| --- | --- |
| Event admission | NOT_EVALUATED |
| Canonical analytical population | NOT_IMPLEMENTED |
| Chronology and same-day ordering | UNRESOLVED |
| 95% tour-season gate | NOT_TESTED |
| Modeling authorization | FALSE |
| Publication | BLOCKED_PENDING_RIGHTS_REVIEW |

Numerical coverage passage does not admit Montreal, validate the full panel or resolve chronology. Actual-date evidence, same-day/suspended-match treatment, the LS007 date discrepancy and differing event windows remain unresolved. H64/H61 suffix meanings remain unknown even though scoped retirement occurrence is corroborated. Wider acquisition, canonical structures, dependencies, statistical choices and publication rights need their respective future review/authorization; local research permission is not a provider redistribution grant.

The smallest recommended next milestone is a bounded offline chronology-evidence inventory and policy proposal for this event, documenting which actual dates/completion order the existing references support and which remain unknown. It should not implement ordering, acquire data, admit events or start models. The flagship Four Factors versus surface-adjusted Elo project and deferred Challenger extension remain unchanged; portfolio was not modified.

See [current status](status.md), [data contract](data-source-contract.md), [inventory reconciliation](wta-2021-montreal-inventory-reconciliation.md), [recovery policy](wta-2021-montreal-recovery-policy.md) and [inventory status policy](wta-2021-montreal-inventory-status-policy.md).
