# Phase 1S: Open Tennis Data documentation preflight

Date: **2026-09-28**. Result: **STOP — documentation access and local-retention basis unresolved**. This is an operational assessment under the user's rights-first rule, not legal advice or a finding that documentation access is prohibited.

The flagship asks whether interpretable Four Factors improve calibrated tennis forecasts over surface-adjusted Elo. Phase 1R found zero verified release support for 2,377 conditional dependencies and recommended REVISE_AND_TARGET_EVIDENCE. Phase 1S tests only whether a narrowly bounded documentation review can establish a suitable alternative evidence route. It does not implement chronology or acquire match data.

## Authority and unchanged gates

Q3/Q4: APPROVED_DOCUMENTATION_PREFLIGHT_ONLY, maximum four direct public HTTPS GET attempts in the order below. The user accepted incidental current-documentation references to 2025, not access to 2025 match records or performance data. Every other provider and every payload has a ceiling of zero. The review stopped after request one; the three unused slots confer no further authority.

Q1/Q2/Q6/Q8/Q9/Q10/Q11: PENDING_USER_APPROVAL. Q5/Q7/Q12: APPROVED_SPECIFICATION_FEASIBILITY_ONLY for the completed Phase 1R scope. The [Phase 1Q brief](tennis-chronology-path-decision-brief.md) and [Phase 1R report](event-boundary-feasibility.md) remain unchanged historical records.

Operational chronology, event-entry batching and canonical analytical population: NOT_IMPLEMENTED. Event admission: NOT_EVALUATED. Chronology/model readiness: BLOCKED. Modeling authorization: FALSE. Publication: BLOCKED_PENDING_RIGHTS_REVIEW. Montreal count coverage and inventory, prior adopted policies, retirement/walkover exclusions, Indian Wells quarantine, panel and chronological splits are unchanged. No release strategy, Elo, factor, imputation, model, provider contact, portfolio work, publication or push was authorized or performed.

## Exact request record

| Order | Exact approved target | Outcome |
| --- | --- | --- |
| 1 | [DATA_LICENSE.md](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA_LICENSE.md) | GET attempted once; HTTP 200; readable; reviewed and stopped for unresolved access/retention basis |
| 2 | [DATA.md](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA.md) | NOT_ATTEMPTED_STOPPED |
| 3 | [docs/SCHEMA.md](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/docs/SCHEMA.md) | NOT_ATTEMPTED_STOPPED |
| 4 | [Repository overview](https://github.com/ryantjx/tennis-match-data) | NOT_ATTEMPTED_STOPPED |

Totals: **one attempt, one HTTP success, zero transport failures, three skipped after the rights stop**. No redirects, retries, searches, browser automation, authentication, APIs, cloning, linked requests, subresources, archives, packages or payloads were requested. Only request one has HTTP evidence; no outcome is invented for the others.

Request one provenance:

- GET started and finished: **2026-09-28T05:35:13Z**. Manual review recorded: **2026-09-28T05:35:33Z**.
- HTTP **200**, curl exit **0**, redirect **FALSE**, no Location, no transport error.
- Media type: `text/plain; charset=utf-8`.
- Original body: **1,528 bytes**, SHA-256 `51e17ec16942ccd9f2512da9bb0ee32389579632094859a7efc6322f2f80cc0f`.
- Original headers: **898 bytes**, SHA-256 `3851615d6390eefe24d80018601602619175a7010fa6627b2b038fcf4fe33e63`.
- ETag: `"ff81921cd135b4060b0f16be6749ee1fbd7fee937ac3133e2245558199d18384"`; no Last-Modified field. ETag is an HTTP validator, not a verified Git revision or data-release pin.
- Source endpoint: mutable `main` document. Immutable upstream commit/release: **NOT_ESTABLISHED**. Local bytes are fingerprinted; no remote revision discovery was attempted.
- Attempt-record SHA-256: `ac1f2208f5efbed8d0b62bc6801d8db9842c25554ceb19728aec6b0e26f0930d`.
- Response-record SHA-256: `bc15b4f2494d31f347ae29df012c38fb2bf6a27396ec799f82a1a3d6e125026d`.
- Review-record SHA-256: `c741444b2cffca17c5d60446ba8d747e33ea1e252df5fa9df61d2b0bca80bef3`.

Manifest SHA-256: `156973b5af3abc7864e28eab1e88318c369b988d3ab4f6c602ab796658354aee`.

## Rights and upstream findings

The retained document's lines 3–10 distinguish the software's MIT license from source-dependent tennis data and describe a release source registry. Lines 14–24 identify Sackmann/Tennis Abstract, Wikimedia, tennis-data.co.uk and community corrections. They describe noncommercial/share-alike obligations for Sackmann, attribution/share-alike obligations for Wikimedia, no claimed commercial redistribution grant for tennis-data.co.uk, and CC0 factual corrections. WTA/Tennis TV automation and publication require separate permission under the stated policy.

Lines 26–34 require suitable upstream rights and direct consumers to source records and terms. Those linked resources were not followed. This document does not establish a blanket OTD data license, raw redistribution grant, derived-output permission, commercial-use permission or retention duration. Exact field lineage and source-specific conditions remain unverified.

**Operational interpretation:** the document does not affirmatively cover this programmatic documentation-access method or private documentation retention. The software-only license statement does not establish that these documentation files are covered. No express documentation prohibition was found, but silence cannot clear the task's gate. Both access and retention are **AMBIGUOUS_STOP_REQUIRED**; request two was withheld.

The original response and headers remain privately stored for this requested provenance audit, outside Git. Their preservation does not assert that an ongoing retention right has been resolved. No deletion was authorized or performed. Future retention duration/disposition requires clarification; no additional copy, redistribution or continued acquisition is justified by the stored snapshot.

OTD's declared Sackmann cross-checking overlaps an existing project source; agreement would not automatically be independent validation. The degree of independence is field-specific and remains unverified. Neither the upstream sites nor OTD's registry was accessed.

## Chronology and historical availability

These are **not established by the retrieved license document**. The documentation that might define them was not requested after the stop:

| Question | Phase 1S finding |
| --- | --- |
| Actual match day versus tournament label or scheduled day | NOT_ASSESSED_AFTER_RIGHTS_STOP |
| Actual completion time | NOT_ASSESSED_AFTER_RIGHTS_STOP |
| Result publication/availability time | NOT_ASSESSED_AFTER_RIGHTS_STOP |
| Retrieval timestamp meaning/completeness | NOT_ASSESSED_AFTER_RIGHTS_STOP; this task's HTTP timestamp is only documentation acquisition provenance |
| Update/correction time and revision history | NOT_ASSESSED_AFTER_RIGHTS_STOP; mentioning community corrections does not establish a historical version history |
| Timezone and precision | NOT_ASSESSED_AFTER_RIGHTS_STOP |
| Suspensions and resumptions | NOT_ASSESSED_AFTER_RIGHTS_STOP |
| Terminal match status | NOT_ASSESSED_AFTER_RIGHTS_STOP |
| Historical point-in-time availability | NOT_ESTABLISHED |

A match-date field alone would not prove when a result became available. A current corrected record or present retrieval time cannot establish what was knowable at a historical prediction cutoff. No Phase 1R dependency or availability gate is cleared.

## Development-only artifact and analytical suitability

The following remain **NOT_ESTABLISHED**, rather than declared impossible: a future immutable/version-pinned 2021-only artifact acquired without later seasons; verified ATP/WTA main-draw singles scope; exact field-level source lineage; a rights-supported hashable retained payload; and reliable avoidance of 2025 records. The license's description of a source registry is a maintainer claim, not a verified artifact inventory. No payload URL or hash was discovered or tested.

Chronology corroboration, identity reconciliation and terminal-status suitability remain **NOT_ASSESSED_AFTER_RIGHTS_STOP**. No schema was retrieved. Whether the current schema supplies any of the nine per-player counts—aces, double faults, service points, first serves in, first-serve points won, second-serve points won, service games, break points faced and break points saved—was **not reverified**. The historical source contract says those counts were absent from schema 3.3; that older finding is not a current Phase 1S schema inspection. OTD is not adopted as a primary factor source.

No incidental 2025 text occurred in the one retrieved document. No 2025 match records or performance data were requested, extracted, inspected, summarized or used. Required local project/research documents contain historical season references and coverage summaries; reading them did not access a new match dataset or evaluate test performance.

## Implementation and reproduction

The [bounded R implementation](../R/review_otd_documentation.R) is inert when sourced. Ordinary execution validates saved evidence only. Live mode requires the exact repository root and approved starting HEAD, the exact URL/order, an unconsumed persistent reservation and a cleared preceding manual review. It uses existing base R, curl and SHA tools; no dependency was installed.

A reservation persists before transport, consumes a slot even on failure/interruption, and is never silently removed. No repeated request or response overwrite is permitted. Original response/header bytes are retained even for failed, redirected or partial synthetic responses. Unknown artifacts, changed hashes, orphan seals, missing reviewed caches and redirected storage paths fail closed. A finalized manifest closes live access; its fingerprint is pinned above. Four manifest rows account for every approved target, including skipped ones.

Ten ignored files were created: two raw response/header files under `data/raw/reference/otd-documentation/`; three RDS records and three hash seals, plus `manifest.csv` and its seal, under `data/pilot/otd-documentation/`. The persistent `reserved-1/` directory is an attempt marker, not a further file or response. No raw evidence or ignored manifest is committed.

Offline reproduction from repository root:

```sh
Rscript R/review_otd_documentation.R
Rscript R/test_otd_documentation.R
```

The new tests use synthetic temporary responses with live transport blocked. They cover the allowlist, order/ceiling, failure accounting, rights stops, redirects/retries, unapproved paths/providers/payloads, interruption preservation, cache reuse, hashes, deterministic bytes/timestamps, ignored evidence, current authority and durable modeling guidance. Relevant earlier suites and preservation/document checks are recorded in [status.md](status.md). These are software/provenance checks, not statistical validation or proof of legal permission.

## Durable guidance and next decision

[PROJECT_CONTEXT.md](../PROJECT_CONTEXT.md#overfitting-and-missing-data-comparisons) now records the user's chronological out-of-sample overfitting requirement and later comparison of complete-case/no imputation, mean, mean plus justified indicators, and PMM multiple imputation. All fitting stays inside the chronological training sample/resample; no outcome imputation, future information, zero substitution or preselection. Evaluate calibration, Brier/log loss and stability across tours/surfaces/seasons/events; freeze before 2025. Elo normally needs eligible results rather than statistical imputation. This guidance is adopted but not implemented and changes no data-admission gate.

**STOP means:** finish this bounded preflight with the preserved negative/unknown result; do not use the three remaining slots, substitute a URL, inspect the schema, or propose an already-cleared payload. It does not mean OTD is proved unusable or prohibited.

**Exact next user decision:** pursue a separately scoped clarification of OTD documentation access and local retention, or leave OTD paused. If clarification is chosen, the smallest recommended next task is an offline draft stating the exact method, documents, retention and source-rights questions; finding/verifying a recipient and sending anything require separate explicit authorization. No contact route was verified here. Further documentation or payload acquisition would need a sufficient rights basis and a new exact user-approved scope. No such next task has begun.

Starting clean main: `6a07728030422f7040b0f75d5ea8497ff6f16439`, 25 ahead / zero behind existing local origin/main. Completion message: `Review Open Tennis Data documentation feasibility`. The final response records the resulting commit and Git state. Handoffs remain response-only and at most 2,000 words.
