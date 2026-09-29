# Phase 2H source-defined cohort admission audit

**COMPLETE — audit version 1.0.0, 2026-09-29.** Implemented from `6d3bef480f0f233b1c95e551a09aa7ca2bb67aa7` under the explicit Phase 2H user approval of the [decision](occam-candidate-and-data-decision.md#one-executable-next-phase-phase-2h-source-record-admission-audit). This is measured source-record admission for a bounded local audit. It does not authorize metrics, modeling, histories, Elo or forecasting, or establish complete-event admission. S02/S08 remain provisional; no candidate definition or historical result changes.

## Inputs and saved-use verification

Only ATP 2023, WTA 2023 and WTA 2021 annual files at archive revision `83733587353df8a41f2fd4f516147d5aa83f5a8d` were processed. All three passed saved-use/provenance checks before parsing. The 38 literal SHA-256 pins cover these files, their relevant manifests/metadata, adopted pilot policies, saved references, frozen pilot eligibility, the separate recovery overlay, DATA_LICENSE.md and the unchanged Phase 2G context/decision/instructions. Source byte size, Git blob, row count, required schema, source URL, archive revision, creator, CC-BY-NC-SA-4.0 identification and recorded noncommercial intent were checked against the pinned manifests.

The saved basis is the recorded archive attribution and conditional research-use terms plus the user’s bounded Phase 2H approval. It is not a fresh provider grant, legal review or authenticated complete upstream history. Official evidence remains restricted to the existing local pilot exceptions. No source documentation was refreshed. Attribution remains Jeff Sackmann / Tennis Abstract via the Aneeshers archive; [DATA_LICENSE.md](../DATA_LICENSE.md) governs handling. Unknown or changed required evidence blocks its dependent annual file before reading rows; unaffected files can still run.

| File | SHA-256 | Bytes | Annual rows | Panel rows | Admitted | Excluded | Source-record retention |
| --- | --- | --- | --- | --- | --- | --- | --- |
| atp_matches_2023.csv | `9b9671aa7c8156e74c2e4466675b7ed4e762bb8a58b7237a30daefd84ffceff5` | 625341 | 2986 | 998 | 846 | 152 | 84.77% |
| wta_matches_2023.csv | `b73bf74928155b858cdb7045f6334246336cef604286cb361e695df26911ad18` | 569610 | 2810 | 998 | 909 | 89 | 91.08% |
| wta_matches_2021.csv | `3f4b865fe9f68aedb3d51597740cf658cf805f676bae652f2bc93cbab4f6e99f` | 531828 | 2597 | 926 | 825 | 101 | 89.09% |

## Admission rules implemented

- **Panel/context:** exact file/tour/year/source-event-ID/label mappings identify the ten fixed families. Require matching surface, level and best-of, valid event-week date and season, one source edition/date per cell, numeric source match number and main-draw round R128/R64/R32/R16/QF/SF/F. These are source-context checks, not independently verified official edition dates. A recognized label with an unknown ID remains a flagged candidate, not silently off-panel. Conflicting editions exclude affected candidates. Off-panel rows are retained with OUTSIDE_PANEL and NOT_ASSESSED_OUTSIDE_PANEL dispositions; no tennis/count analysis is performed on them.
- **Completion parser 1.0.0:** accept only best-of-three or best-of-five numeric set sequences, ending exactly when the recorded winner first reaches two or three sets; the loser cannot already have won. Each ordinary completed set must be 6–0 through 6–4, 7–5 or 7–6 in either direction. Parenthesized tie-break scores are accepted only with 7–6/6–7. Explicit RET, WO, DEF, abandonment/cancellation and unfinished/suspended markers exclude, as do missing, conflicting or unknown syntax, impossible set sequences, extended sets and match tie-break notation. Extended 2021 formats are conservatively unsupported, not asserted to be invalid tennis. Absence of RET does not pass the completion gate. No official completion guarantee is inferred from a plausible score.
- **Identity/duplicates:** require two distinct numeric source IDs and nonempty source names. Conflicting exact names or L/R hand evidence for an ID, or a shared exact name across IDs within a tour, are excluded pending resolution. No new alias or cross-tour identity merge is invented. All copies of duplicate source keys or event/player-pair/round/event-date encounters are excluded. Player A/B is the radix lexical ordering of source IDs, independent of winner; original winner/loser IDs, names, fields and side mapping remain.
- **Counts:** require all 18 nonnegative integer counts; positive service points; component bounds from the contract including second-serve wins plus double faults within second-serve opportunities. Zero aces, double faults or break opportunities are not automatically invalid. Apply the inherited game reconciliation: total service games must equal scored games minus completed tie-break games. An unsupported score makes this check unevaluable and cannot pass. Evaluate available bounds even when another field is missing; retain every applicable reason. This structural test detects incompatibility with the adopted convention, not necessarily the cause of a source discrepancy. No source values are repaired.
- **Pilot preservation:** reuse the pinned, previously validated 245-row eligibility ledger only after exact source path/pair/names/round/score linkage. Carry status policies, official identifiers, dissent and the one WTA Indian Wells bundle quarantine. Apply the separately pinned 126-field Montreal overlay only to its exact seven wholly missing bundles, with identity/score/field/policy checks. Raw fields remain empty; effective counts have separate columns and origin labels. The unmarked Montreal retirement remains excluded. Pilot agreement does not validate the other cells.

## Measured dispositions and breadth

All **8,393 annual source rows** have a ledger entry: **5,471 outside the panel**, **2,922 panel records**, **2,580 included** and **342 excluded**. Included records comprise **2,573 original-source bundles plus seven separately attributed Montreal recovery bundles**. There are **zero blocked files, zero absent cells, zero wholly blocked cells, zero identity conflicts, zero duplicate candidates and zero context failures** in these pinned inputs. These are measured results within this scope, not guarantees about other files.

Panel completion dispositions are **2,818 source-reported normal, 73 retirements, 21 walkovers, nine ambiguous extended scores and one unfinished score** (WTA Madrid 2023, `4-6 6-4`). Among the 2,818 completion-supported records, **237 fail service-game/score reconciliation** and one further WTA Roland-Garros 2023 record fails both sides’ second-serve-wins-plus-double-faults bounds. These 238 count exclusions plus 104 status exclusions account for all 342 rejected records. Reasons overlap: the preserved Indian Wells quarantine is among the 237 game conflicts; four WTA 2021 records also have zero service-point totals. Missing effective counts are recorded separately, never zero-filled.

Raw two-player count availability is **2,898/2,922 (99.18%)**; each of the 18 required fields has the same observed availability. The 24 missing raw bundles comprise seven approved recovery records and 17 other excluded records. Nonmissing integers alone are insufficient for admission. Overall source-record retention is **2,580/2,922 (88.30%)**.

All **30 authorized tour-season-family cells** contain observed and eligible records. The other 70 cells in the unchanged 100-cell research design are outside this task, not labeled missing or inspected. Surface breadth includes hard, clay and grass for each of the three authorized tour-years. The release contains 30 cell totals plus 202 observed round groups and 4,176 field/group availability records. Absent-cell and blocked-file fixtures demonstrate zero-versus-unknown reporting; no invented round denominators or official counts are added.

| Tour | Season | Event | Surface | Observed | Admitted | Excluded | Retention |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ATP | 2023 | Australian Open | Hard | 127 | 126 |  1 | 99.21% |
| ATP | 2023 | Roland-Garros | Clay | 127 | 119 |  8 | 93.70% |
| ATP | 2023 | Wimbledon | Grass | 127 |  56 | 71 | 44.09% |
| ATP | 2023 | US Open | Hard | 127 |  75 | 52 | 59.06% |
| ATP | 2023 | Indian Wells | Hard |  95 |  91 |  4 | 95.79% |
| ATP | 2023 | Miami | Hard |  95 |  89 |  6 | 93.68% |
| ATP | 2023 | Madrid | Clay |  95 |  94 |  1 | 98.95% |
| ATP | 2023 | Rome | Clay |  95 |  92 |  3 | 96.84% |
| ATP | 2023 | Canada | Hard |  55 |  54 |  1 | 98.18% |
| ATP | 2023 | Cincinnati | Hard |  55 |  50 |  5 | 90.91% |
| WTA | 2023 | Australian Open | Hard | 127 | 127 |  0 | 100.00% |
| WTA | 2023 | Roland-Garros | Clay | 127 | 119 |  8 | 93.70% |
| WTA | 2023 | Wimbledon | Grass | 127 |  92 | 35 | 72.44% |
| WTA | 2023 | US Open | Hard | 127 | 100 | 27 | 78.74% |
| WTA | 2023 | Indian Wells | Hard |  95 |  91 |  4 | 95.79% |
| WTA | 2023 | Miami | Hard |  95 |  92 |  3 | 96.84% |
| WTA | 2023 | Madrid | Clay |  95 |  93 |  2 | 97.89% |
| WTA | 2023 | Rome | Clay |  95 |  90 |  5 | 94.74% |
| WTA | 2023 | Canada | Hard |  55 |  53 |  2 | 96.36% |
| WTA | 2023 | Cincinnati | Hard |  55 |  52 |  3 | 94.55% |
| WTA | 2021 | Australian Open | Hard | 127 | 126 |  1 | 99.21% |
| WTA | 2021 | Roland-Garros | Clay | 127 | 119 |  8 | 93.70% |
| WTA | 2021 | Wimbledon | Grass | 127 | 100 | 27 | 78.74% |
| WTA | 2021 | US Open | Hard | 127 |  93 | 34 | 73.23% |
| WTA | 2021 | Indian Wells | Hard |  95 |  91 |  4 | 95.79% |
| WTA | 2021 | Miami | Hard |  95 |  89 |  6 | 93.68% |
| WTA | 2021 | Madrid | Clay |  63 |  58 |  5 | 92.06% |
| WTA | 2021 | Rome | Clay |  55 |  51 |  4 | 92.73% |
| WTA | 2021 | Canada | Hard |  55 |  49 |  6 | 89.09% |
| WTA | 2021 | Cincinnati | Hard |  55 |  49 |  6 | 89.09% |

Every retention percentage above uses observed source records including excluded statuses. It is **not official event coverage**. Saved official match-inventory denominators exist only for ATP Indian Wells 2023 (95), WTA Indian Wells 2023 (95) and WTA Montreal 2021 (55); their preserved inventory recall is 100%, excluding byes but including retirements/walkovers. This is distinct from complete-count coverage or source retention. Official recall is **UNKNOWN for all 27 other cells and all round groups**. The unchanged 90% event and 95% tour-season official gates are not evaluated or passed by these fractions.

## Outputs and verification

Created [audit code](../R/audit_source_defined_cohort.R), [focused checks](../R/test_source_defined_cohort.R) and this report; updated only [current status](status.md) and [source contract](data-source-contract.md). The exact six ignored files in `data/pilot/source-defined-cohort-admission/` are `input-provenance.csv`, `row-dispositions.csv`, `cohort-membership.csv`, `cell-coverage.csv`, `field-availability.csv` and `summary.csv`. Provenance records file-level saved-use state and dependencies; the ledger retains raw columns, effective overlay columns, every disposition/reason and source row ordinal; membership records neutral keys and original outcome linkage. Cell/field totals explicitly distinguish source-record retention, raw count availability and official recall.

**105 focused checks passed** via `Rscript R/test_source_defined_cohort.R`: pins and per-file fail-closed behavior (including no read of a blocked annual and all-files-blocked summaries), exact panel/context mappings, completion/unsupported formats, identity/duplicate failures, integer/bound/game tests, simultaneous reasons, pilot linkage/overlay restrictions and exact 245-row agreement, absent cells, neutral orientation, unchanged raw values and row order, and six byte-identical files from independent runs. Publication uses a staged atomic directory; changed or incomplete existing releases are preserved and rejected. All generated summaries were inspected, including provenance, exclusions, field availability, cell totals and round totals.

Implementation checks initially exposed empty-reason handling, blocked-file round reporting and an isolated test-environment lookup; each was corrected before publication. The final focused run passed. No external access or dependency was required. Targeted scope/documentation and start/end fingerprint checks preserve all fourteen Phase 2F CSV hashes, sizes and modification times and all untouched tracked inputs. The historical 669-check suite was neither rerun nor repinned. No portfolio files were read or modified; no publication or push occurred.

## Limits and one next executable step

The largest unresolved issue is the concentration of game-reconciliation failures: **121 ATP 2023, 61 WTA 2023 and 55 WTA 2021**. Wimbledon alone retains 56/127 ATP 2023, 92/127 WTA 2023 and 100/127 WTA 2021 source records. A source/stat-provider counting convention could explain some differences, but that is **unverified**; no correction, exception or gate relaxation is implemented. Selection bias can therefore be substantial despite all cells being present. Nine extended 2021 scores remain unsupported, and errors in otherwise plausible source rows may remain undetected without independent references. Match dates, completion order and pre-match availability are unresolved; the annual event-week dates are not actual match dates. No statistical adequacy or forecasting readiness is claimed.

**Recommended Phase 2I: offline service-game convention diagnostic.** Using only the frozen Phase 2H ledger and its already authorized saved evidence, measure the 237 game-conflict differences by tour/year/event/round and ordinary tie-break count; compare any applicable saved reference/definition evidence and distinguish demonstrated errors from unresolved convention differences. Deliver a versioned base-R diagnostic, focused checks, local ignored aggregate results and a concise evidence report. Preserve Phase 2H membership, all raw values, pilot exceptions and historical outputs. Do not extend the score parser or relax any rule in this diagnostic.

**Exact approval required:** Approve Phase 2I only as the bounded offline diagnostic above, including its code, focused checks, local aggregate outputs, report and current status/contract updates; authorize no acquisition, new source/year, raw repair, changed admission/count rules, expanded recovery, metrics, models, histories, ratings, forecasting, OTD, portfolio work or publication. Any later proposed rule change or empirical extension requires a separate user decision. This recommendation is not implemented or authorized by completing Phase 2H.
