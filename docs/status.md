# Tennis analytics status

Date: **2026-09-14**. Milestone: **2023 Indian Wells ATP/WTA acquisition pilot complete; one WTA count anomaly remains unresolved. No model readiness claimed.**

## Completed and directly verified

- Began clean on `main` at `af761158bc37a1964be46dccfb41d86ed3db7d2a`, three ahead of the existing local `origin/main` reference. No remote synchronization occurred. Root/ancestor instructions, both existing documents, and all 20 PDF pages were read. R and Rscript 4.6.0 were available.
- Verified archive revision `83733587353df8a41f2fd4f516147d5aa83f5a8d`, preserved source attribution/terms, directory metadata, exact URLs, and file identities. Downloaded only `atp/atp_matches_2023.csv` (625,341 bytes; 2,986 rows) and `wta/wta_matches_2023.csv` (569,610 bytes; 2,810 rows). SHA-256 and acquisition metadata are in the [manifest](../data/manifests/pilot-source-files.csv); local Git blob hashes also match pinned directory metadata.
- Implemented base-R download and audit scripts, local raw/pilot ignore rules, and [DATA_LICENSE.md](../DATA_LICENSE.md). Generated the [pilot audit](pilot-acquisition-audit.md). Updated the [contract](data-source-contract.md) to distinguish pilot bytes, earlier documentation, report claims, and proposals.
- Indian Wells: ATP `2023-0404` / `Indian Wells Masters`; WTA `2023-609` / `Indian Wells`. Each has 95 source rows, 96 unique player IDs, hard surface, and date label `20230306`. ATP source draw size is 128; WTA is 96. No official final-draw reconciliation is complete.
- All 18 count columns exist in both 49-column annual schemas. ATP joint completeness: 95/95; WTA: 94/95 across all source rows, or 94/94 excluding its walkover. All six retirement rows retain all required counts. Status labels are score evidence, not a dedicated source completion field.
- Both tours numerically exceed the provisional 90% event floor. After excluding one flagged WTA row from the valid numerator, WTA is 93/94 (98.9362%). The 95% tour-season admission gate was not tested by this one-event pilot.
- No duplicate event-match keys/full rows, missing player-ID slots, same-ID opponents, or ID/name mapping conflicts were found within the pilot. Repeated player appearances are expected.

## Verification and warnings

The scripts were rerun; source bytes and modification times, manifest bytes, and every generated audit/subset output remained unchanged. In-memory guard tests exercised checksum mismatch rejection before network/write activity, missingness, score/status parsing, impossible counts, service-game disagreement, duplicates, and same-player identities. No synthetic test records were written into source data or audit outputs.

The initial sandboxed download failed DNS resolution. The authorized network-enabled retry succeeded with base R; no shell downloader or dependency fallback was used. Browser directory views failed; pinned GitHub metadata succeeded. PDF extraction emitted a standard-font warning initially; text remained readable and the later extraction supplied the bundled font path.

## Unresolved issues and approval boundaries

- WTA match `268`, score `4-6 6-4 6-3`, has `w_SvGms=11` and `l_SvGms=11`: 22 recorded service games versus 29 scored games without tie-breaks. Preserve the row and raw bytes; investigate or approve quarantine before admitting it to a complete-count cohort. The cause and correct values are unknown.
- No actual match date/time or explicit completion-status column exists. Tournament dates, rounds, row order, and match numbers cannot establish exact chronology. No chronology solution was implemented.
- Noncommercial pilot use, source pin, base R, main-draw singles and provisional 95%/90% thresholds are approved. Final retirement/default/unknown-status rules, independent draw inventory, anomaly handling, historical rating scope, chronology policy, and future derived publication remain unresolved.

## Recommended next milestone

Review the WTA discrepancy and authorize a resolution/quarantine rule plus independent event-inventory evidence. The source/schema supports bounded expansion in principle, subject to that review and explicit authorization for the complete fixed 2021-2023 development panel. Do not broaden acquisition automatically. Keep 2024/2025 closed; settle date and ordering policy before ratings or rolling features.

No packages, canonical tables, Elo, Four Factors, player ratings, forecasts, or performance evaluations were created. No 2025 dataset was accessed. Raw annual files and generated pilot CSVs remain outside Git. The portfolio repository was not modified. Nothing was pushed, published, or deployed.

## Commit and handoff

The completed milestone uses commit message `Audit 2023 Indian Wells source data`; the final response records its exact hash and final Git status. Future new documents still require explicit staging because the existing `docs/` ignore rule is preserved.

Every next task must end with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000. Do not send it, invoke a handoff tool, or create another task without a separate request.
