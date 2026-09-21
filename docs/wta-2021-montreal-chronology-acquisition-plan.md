# WTA Montreal 2021 chronology-evidence acquisition plan

**Phase 1O. Plan version 0.1.0: PROPOSED_NOT_APPROVED. Acquisition authorization: FALSE.** No request, discovery search, download, scraping, hidden API use, browser automation or new raw-data file is authorized by this document. All A1–A10 decisions below are PENDING_USER_APPROVAL. This plan follows the separately [adopted chronology policy 1.0.0](wta-2021-montreal-chronology-policy.md); adoption of that policy does not approve this plan.

## Purpose and verified local basis

Find the smallest evidence collection that can test chronology semantics and dependency safety for WTA Montreal 2021 main-draw singles. Do not begin with a bulk collection of ambiguous startDate fields. The intended future Four Factors versus surface-adjusted Elo comparison still needs a prespecified cutoff, history scope and modeling protocol. This plan selects none of those methods.

Phase 1N preserves 55 results: 49 completed, five RET and one WO. Nine saved pages cover seven completed matches and two retirements; 46 results lack pages. The reconciled non-bye inventory has **54 supplied official codes**, of which nine have saved pages: **45 remaining coded results = 42 completed + three retirements**. The remaining record is an uncoded walkover. The HTML's 62 codes include eight byes; they are not 62 played matches or a request universe. These counts were checked locally with blank CSV values treated as missing.

All 49 completed matches have within-event player chains accounted for, with 54 corroborated feeder edges overall and 45 completed-to-completed. Event-week 20210809, overview August 9–15 and PDF August 7–15 remain distinct. No actual start/completion dates, timestamps, timezone, suspension/resumption or historical availability times are verified. LS007 and LS003 publish August 14; other saved quarterfinals publish August 13. Neither those dates nor the EventScheduled/finished-card conflict is resolved by approval.

Offline inspection found the exact href `https://www.wtatennis.com/tournaments/806/montreal/2021/order-of-play` in both saved overview and draw HTML. **Verified: the link occurs locally. Unverified: the target's existence now, accessibility, historical content, semantics and suitability.** No request was made. Previously documented sources are recorded in the [contract](data-source-contract.md#5-source-by-source-findings), [reference report](wta-2021-montreal-reference-feasibility.md) and [research report](../tennis-analytics-public-data-research.pdf). Their historical claims are not fresh provider verification.

## Common controls for every candidate group

The group-specific entries below inherit these controls; exceptions are stated explicitly. Proposed paths do not exist as new artifacts from this phase and require approval before creation.

- **Request accounting:** ceilings count every attempted outbound request, including failures, HEAD, retries, redirects, discovery queries and archive-index lookups. A file count is a maximum, not a promise of availability. No automatic redirects, retries, hidden endpoints, alternate slugs, login, paywall or bot-check bypass. Stop at the first disallowed destination or access restriction. Return the failure for review; do not spend a larger stage's budget implicitly.
- **Rights:** free access, research permission, local retention, raw redistribution and derivative publication are separate fields. Existing WTA restrictions and [DATA_LICENSE.md](../DATA_LICENSE.md) remain controlling. User approval authorizes a bounded action, not third-party rights. Ambiguous or prohibitive terms stop collection for the affected use; retain a blocker, not an invented permission. All publication, including aggregates, stays blocked pending review.
- **Storage proposal:** new original bytes, if separately authorized, go under ignored `data/raw/reference/montreal-2021-chronology/`, with provider and stage names in immutable filenames. Local manifests, extraction and comparisons go under ignored `data/pilot/development-2021/montreal-chronology-acquisition/`. Never overwrite Phase 1G references, the Phase 1I overlay or Phase 1N outputs. No directories or manifests are created now. Only minimal metadata and aggregate reports may later be proposed for Git; restricted official tables remain ignored.
- **Manifest proposal:** acquisition group/stage/approval ID; requested and resolved URL; provider/original creator/upstream chain; discovery-parent URL and exact locator; request time, HTTP outcome, retrieval method and redirects rejected; byte count, media type, SHA-256 and immutable revision/release/capture when available; local path; original event/match/player identifiers and spellings; terms URL/version/hash/access date, permitted research/retention scope, attribution, redistribution and derivative restrictions; parser/version/transformations; completeness and known limitations. Failed requests receive no fictitious file/hash. Retrieval and capture times remain provenance, not play dates.
- **Chronology observations:** retain literal field/text, locator, semantic role, precision, stated timezone/time basis, publication/revision time and its meaning, scheduled versus actual versus completion/resumption/availability status, verification evidence, missingness reason and disagreement. No imputation from duration, event week, adjacent matches, filenames or row order. Record bounds as bounds; never manufacture exact timestamps.
- **Validation/linkage:** exact WTA 2021 Montreal singles event, code when supplied, both identities, round and result must reconcile to the validated local inventory. Use existing player IDs and bounded aliases; no name-only/fuzzy/global alias inference. For schedule-only documents with no result, establish the unique scheduled pairing/event/round and keep it schedule-only. Separate cancellation, retirement, walkover, suspension and completion. Isolate historical content from current news/widgets. Reject duplicate or conflicting attribution; preserve every original observation.
- **Insufficiency:** repeated ambiguous fields, unchanged EventScheduled metadata, schedule without actual occurrence, result without relevant completion/availability evidence, unresolved identities, current-season content, unsupported timezone conversion or shared-feed agreement alone cannot clear the dependent gate. Missing evidence remains missing. Do not lower 90%/95% count thresholds, shrink the intended population or claim an event pass from the diagnostic sample.

## Candidate groups — assessment only

### G1. Remaining official WTA match pages

**Provider/URL:** WTA. Candidate pattern `https://www.wtatennis.com/tournaments/806/montreal/2021/scores/{official_code}`, following seven already saved Montreal-slug pages. The exact finite code set is locally derivable from `reconciliation-links.csv` in the existing Montreal inventory directory: nonempty unique official_code for non-bye linked results, minus the nine reference-manifest codes. Never generate a numeric LS range. Do not request LS013 or bye codes. The two existing Toronto-slug references are reused as pinned evidence; no alternate-slug probing is proposed.

**Count/target:** 45 potential new URLs/files, comprising 42 completed and three RET results. Recommend considering only the 42 completed pages in Stage C; the three RET pages are deferred unless a separately approved inventory question requires them. Nine existing pages need zero refetches. The complete raw allowlist is not republished here; local deterministic reconstruction, unique linkage and the 45/42/3 counts are tested.

**Possible timing value:** published dates and perhaps schedule/context; actual start, completion, availability, suspension/resumption and timezone are all unverified for unsaved pages. Date-only fields must retain their role until corroborated. More pages alone cannot resolve semantics.

**Dependence/access/rights:** same WTA provider and potentially the same feed as existing references; not independent corroboration. Nine historical responses were free HTTP 200, but unsaved pages' existence and current access are unverified. No open-data or redistribution grant is established. Use the common rights gate.

**Path/validation/stop:** proposed raw filenames `wta-score-{code}.html`; common manifest and exact code/pair/round/result linkage apply. Stop expansion if diagnostics yield only the same ambiguous metadata, an identity mismatch, changed content, access restriction or unresolved rights. Separate download approval and exact allowlist approval are required; no discovery request is needed merely to derive the local candidates.

### G2. Uncoded walkover

**Provider/locator:** the saved WTA draw's uncoded Gauff–Konta R16 walkover block; PDF and source corroborate the result. No verified match-page code or URL exists in current evidence. LS013 must not be synthesized from the code gap.

**Count/target/value:** zero proposed match-page requests/files. Preserve the existing inventory record and its unknown timing. It contributes no statistical history or Elo update. Existing bracket advancement is sufficient for the present inventory purpose; it does not date the walkover.

**Dependence/access/rights/path:** existing WTA evidence, same provider and existing rights restrictions; no new access or storage. Any later document that mentions it must follow the common manifest/linkage contract, stored separately by its real URL. Discovery of a code or new timing record would require a separate bounded proposal; absence of a guessed endpoint is not missing-match evidence.

### G3. Official daily order-of-play documents

**Provider/URL:** WTA's exact locally linked candidate: [2021 Montreal order of play](https://www.wtatennis.com/tournaments/806/montreal/2021/order-of-play). This is the only exact order-of-play target established locally. Tournament-organizer hosting and historical daily PDF paths are unverified; do not invent an OP.pdf path or reuse a current tournament domain as historical proof.

**Count/target:** Stage A proposes at most one index-page request/file after its rights gate. Stage B could select up to three exact, subsequently reviewed daily documents covering LS007, LS003 and LS004. Stage C could consider up to seven additional distinct daily documents if evidence establishes their dates/scope. Seven is a request ceiling, not a claim that one document per day exists. Superseded/revised versions may require a new plan rather than uncapped retrieval. Stages do not automatically authorize following links.

**Possible timing value:** planned dates, court order, scheduled/not-before times and possibly a stated time basis. Those do not prove actual start, completion or result availability. A revision/suspension note could help only if explicitly attributed. Timezone, publication time and historical revisions remain unverified.

**Dependence/access/rights/path:** official schedule is a different artifact but may share the WTA feed; not inherently independent. Current free access, historical availability and retention rights are unverified; apply the common WTA gate. Proposed index filename `wta-stage-a-oop-index.html`; later daily files `wta-oop-{document_id}-{revision}.{ext}`. Match each pairing/date/round and preserve document revision, court and not-before semantics. Stop if the selector loads current content, requires hidden APIs, supplies only planned dates, or does not resolve the targeted dependency. Separate approval is needed for index access and every later finite document allowlist.

### G4. Official results, completed schedules, reports or event pages

**Provider/URL:** WTA and potentially the official tournament organizer. Known WTA starting references are the already saved overview and `/draws` URLs in the manifest. A results/report article's exact URL and organizer host are UNVERIFIED; use only explicit links in approved evidence after user review, not guessed news IDs or an open-ended crawl.

**Count/target:** zero refetches of saved pages. At most three new exact documents in Stage B, **sharing the same three-request budget with G3 and G5**, to test LS007 → LS003 and ordinary comparator LS004. Later daily results share Stage C's seven-document budget with G3; they are not an additional seven.

**Possible timing value:** a dated account may establish actual play/completion day, postponement or resumption; an authenticated contemporaneous report may bound when a result was publicly available. Article publication, update time and described play date must stay distinct. A modern backdated article or a date-only recap does not automatically establish a usable historical availability bound. Exact clock time/timezone are unverified.

**Dependence/access/rights/path:** official pages may repeat the same feed; editorial wording is potentially different evidence, not automatic independence. Existence, current free access, semantics and rights for new documents are unverified. Proposed `official-result-{document_id}-{revision}.{ext}`, with common manifest plus publication/revision provenance. Stop for no match-specific actual-timing information, ambiguous identities, current-season substitution, source copying or unreviewed rights. Discovery and access of new URLs each require approval.

### G5. Historical WTA metadata semantics

**Provider/URL:** an authoritative WTA explanation of its historical startDate, endDate and EventScheduled fields would be preferred. No such specification or exact URL has been established locally. The saved schema.org status identifier names a generic vocabulary; it does not document WTA's historical implementation. Do not call it independent semantic verification.

**Count/target:** zero currently known semantic-document URLs and zero requests authorized. Stage A first inspects the approved index, if later permitted, for explicit definitions/links. If insufficient, return for a **separate discovery proposal**: at most two provider-restricted searches using the literal fields and WTA historical metadata, then at most three explicitly approved document requests. This optional five-attempt ceiling is not part of the two-request Stage A recommendation and does not authorize automatic link following. A diagnostic semantic document may instead occupy one of Stage B's shared three slots after exact approval.

**Possible value:** role of dates, timezone convention, update/status lifecycle and whether completion or availability can be bounded. Generic labels cannot establish historical actual timestamps. Version applicability to 2021 and the acquired representation must be evidenced.

**Dependence/access/rights/path:** provider semantics clarify its own fields; they are not an independent measurement of match timing. Existence, free access, accessibility, semantics and rights are UNVERIFIED. Proposed `wta-semantics-{document_id}-{revision}.{ext}`; common manifest plus version/effective-period and provider-authority evidence. Stop if only generic schema definitions, undocumented assumptions or current-only behavior are found. Provider contact is not authorized; any outreach requires a separate explicit user request.

### G6. Independent free match-date candidate

**Provider/URLs:** Open Tennis Data, ryantjx/tennis-match-data, previously discussed in the research report and contract S15–S18. Exact documentation candidates are [repository overview](https://github.com/ryantjx/tennis-match-data), [DATA_LICENSE.md](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA_LICENSE.md), [DATA.md](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA.md) and [schema](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/docs/SCHEMA.md). These mutable URLs were documented previously; they were not opened in Phase 1O. No release/payload URL is selected.

**Count/target:** Stage D proposes at most four documentation requests/files, then at most one separately approved, immutable **2021-only** payload containing the Montreal records. Do not fetch an all-season asset containing 2025 to filter it afterward. If no compliant asset exists, stop. Target the diagnostic records before assessing the 49 completed matches, retaining all status mismatches.

**Possible value:** documented match-day and provenance fields may corroborate dates. Exact start, completion, timezone, suspension and availability semantics are unverified. Contract claims are not audited Montreal coverage. Obtaining all dates would still not establish result availability.

**Independence/access/rights:** historical documentation describes free preview releases with source-specific obligations; current access and research/retention permission for a chosen payload remain unverified. Sackmann and other upstream contributions mean **independence is UNESTABLISHED**. Accept independent corroboration only if row/field provenance establishes a distinct primary timing source; a second package wrapping WTA/Sackmann is source-dependent. MIT code licensing does not cover its data. No raw or derivative-publication permission is inferred.

**Path/validation/stop:** proposed `otd-{document_id}-{revision}.{ext}` and `otd-2021-{release_id}.{ext}`, common manifest plus release pin, row/field upstream lineage, match identity crosswalk and date-role reconciliation. Stop if dependent/unknown lineage is the only corroboration, local use is not permitted, a dependency installation would be needed, or the only asset exceeds year/scope limits. Documentation access and payload download require separate approval. tennis-data.co.uk is a previously discussed alternative, but access/terms and date schema remain unresolved; do not add it silently. TennisData.app remains excluded without written permission.

### G7. Historical web archives

**Provider/pattern:** Internet Archive Wayback Machine is a separately reviewed candidate requested for assessment here. Candidate pattern `https://web.archive.org/web/{capture_utc}/{original_url}`; original URL must be an already approved exact official target. No capture identifier, index URL or archived resource is verified. Do not guess capture timestamps or invoke an index/API now.

**Count/target:** zero requests in the recommended next stage. A later separate proposal could cap one exact index lookup and three explicitly selected captures, four attempts total, focused on diagnostic dates/revisions. Archive access may entail more requests than one apparent URL; the cap does not waive request accounting or allow automatic resource loading.

**Possible value:** a complete authentic capture can show content was present by capture time, not when it first appeared or when play occurred. Later captures cannot demonstrate availability before an earlier forecast cutoff. Missing captures do not prove absence of publication; incomplete JavaScript captures may omit the evidence.

**Dependence/access/rights/path:** preserves the original source, so not independent match measurement. Existence, free accessibility, completeness, replay stability and permission to retain/reuse each capture are UNVERIFIED. Archive accessibility does not replace original-provider rights. Proposed `archive-{capture_utc}-{target_id}.{ext}`, common manifest plus original URL, capture/replay URL, capture timestamp, payload completeness and digest. Stop on missing capture, ambiguous original identity, rewritten/mixed resources, robots/access blocks, rights uncertainty or failure to bound the targeted availability. Exact discovery/index and capture access need separate approval; no archive fallback is automatic.

## Recommended stages and hard ceilings

### Stage A — rights and semantic triage

Recommend this as the **only next collection milestone offered for approval**: at most **two direct public-page GET attempts / two response files**, in order:

1. `https://www.wtatennis.com/terms-and-conditions`
2. `https://www.wtatennis.com/tournaments/806/montreal/2021/order-of-play`

The second request is conditional on the first review finding the specifically proposed access/retention mode permissible. An unresolved restriction stops the stage for user/provider clarification, without bypass or a more permissive assumption. Terms review is not new legal permission. Exact proposed Stage A paths are `data/raw/reference/montreal-2021-chronology/wta-stage-a-terms.html` and `data/raw/reference/montreal-2021-chronology/wta-stage-a-oop-index.html`; the local manifest would be `data/pilot/development-2021/montreal-chronology-acquisition/stage-a-manifest.csv`. Do not overwrite any existing file; a changed acquisition needs a separately reviewed version/path. No match pages, document links, search queries, scripts, APIs or archives are automatically followed. No automatic browser rendering/subresource loading is proposed.

Deliver a bounded access/semantics report, exact candidate daily-document links if present, and a request-level allowlist for subsequent review. If the page lacks historical content or cannot explain timing, report insufficiency and propose only the separately bounded discovery described in G5 if justified. This may legitimately conclude that the route is unusable. It does not require collecting more pages to demonstrate that conclusion.

### Stage B — diagnostic evidence, conditional and separately approved

Reuse the three saved pages for **LS007, LS003 and LS004** without refetching. LS007 → LS003 tests same-player published-date ambiguity; LS004 is an ordinary saved quarterfinal comparison. At most **three new exact document requests/files total across G3–G5**, selected after Stage A and approved before access. One document covering all questions is preferable to three. Preserve conflicting findings; do not preselect August 13 as LS007's correct date.

Proceed only if an identified, rights-compatible document can test a stated gap: scheduled versus actual day, completion, publication/availability bound, suspension or time basis. Return an evidence matrix for the three matches. If only ambiguous date fields recur, stop; do not expand to manufacture apparent completeness. An ordinary match is a diagnostic comparison, not proof for other records.

### Stage C — targeted event expansion, conditional and separately approved

Only after diagnostic evidence demonstrates a usable semantic rule and linkage method, propose an exact new allowlist of at most **42 completed-match pages plus seven additional daily timing documents: 49 attempts/files maximum**. These are ceilings, not quotas. Fetch no match page already saved, no bye page and no invented walkover URL; the three remaining RET pages stay out. If a smaller collection of actual-results documents addresses dependencies directly, reduce or omit score-page collection. Document missing matches explicitly.

Require rights clearance for the exact mode, conflict-resolution evidence, known time basis where needed, reproducible historical scope and user approval of the allowlist/paths. No expansion follows merely because Stage B returns HTTP 200 or more dates. No full official match table is committed.

### Stage D — corroboration and readiness review, separately approved

G6's maximum is **four documentation requests plus one separately approved scoped payload**. G7 remains outside these stages unless separately reviewed under its own four-attempt proposal. Compare provenance before calling agreement independent. An offline review then assesses every intended dependency under policy 1.0.0, including unresolved cross-event boundaries; it creates no model or operational sequence and grants no event admission. A Montreal-only success cannot clear panel chronology. No stage or unused budget carries forward automatically.

## Evidence required for each future use

| Future use | Minimum evidence question; no implementation selected |
| --- | --- |
| Player-relative ordinal Elo | Are all contributing completed results and both players' dependencies demonstrably available before the declared cutoff? Corroborated player-relative precedence may suffice within its scope; no arbitrary global ordering is needed for genuinely independent updates. Initialization and cross-event dependencies remain separate. |
| Same-day sequential Elo | Does each earlier same-day completed result precede the applicable cutoff with defensible availability? An edge does not prove availability before an earlier scheduled forecast time. Unknown dependency is blocked; no match_num tie-break. |
| Daily-batched Elo | Are play/completion dates, common time basis and availability before the prior-day boundary verified? Requires separate approval and validation; omits genuinely available same-day results. Not activated. |
| Last-K Four Factors | Are the K eligible completed histories, their relative order, inclusion scope and pre-cutoff availability established for both players? No retirement partial statistics; no full-event totals. K remains unselected. |
| Elapsed-time histories | Above requirements plus verified date/time boundaries at the precision needed for the chosen window; resolve suspensions and cross-zone comparisons. Window length remains unselected. |
| Inactivity adjustments | Reliable elapsed time from the appropriately defined previous activity/completion to the current cutoff, with documented time basis and excluded-match treatment. Bracket distance is not elapsed time; no inactivity method selected. |
| Cross-event/overlapping histories | Explicit history scope, stable identities, safe completion/availability dependencies across tournaments and timezone/calendar boundaries. Montreal feeder edges do not resolve outside-event order; off-panel/pre-2021 acquisition is not authorized. |

**Dates for all matches would not automatically establish historical result availability.** Completion and knowledge at the cutoff are separate claims; an authenticated bound may suffice for a particular use without an exact timestamp. Absence of suspension evidence is not evidence of uninterrupted play. Same-provider agreement is not independent corroboration. The 49 completed matches remain the intended event audit population; missing evidence cannot silently shrink it.

## New acquisition decisions for the user

These A-numbered decisions are separate from the already approved chronology decisions. No approval is inferred from adopting policy 1.0.0 or committing this plan.

### A1. Discovery and provider scope

Recommend WTA Stage A only as the next bounded access milestone: the two exact URLs above. No broad search, organizer crawl, hidden APIs, browser automation, contact or alternative providers. G5 discovery, G6 access and G7 archives need distinct later approval.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A2. Request ceiling and transport

Recommend two direct GET attempts maximum for Stage A, no redirects/retries/subresource loads. Count failures against the ceiling. Later B/C/D ceilings are 3/49/5 respectively, separately approved, with no pooled or carried-over budget. Optional semantics discovery and archives remain separate 5/4 ceilings, inactive.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A3. Local storage and provenance

Approve or revise the two proposed ignored directories, immutable stage/provider filenames and common manifest fields before creation. Preserve all existing raw, overlay and historical audit bytes; no raw or restricted table enters Git. Later manifests must record failures honestly.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A4. Rights constraints

Recommend rights-first conditional access and local retention only when the proposed mode is supported. Stop on prohibitions or unresolved scope; obtain separate clarification rather than treating educational intent as permission. No publication, raw redistribution or licensing assumption is approved.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A5. Diagnostic sample and evidence acceptance

Recommend LS007, LS003 and LS004, reusing existing pages and at most three separately allowlisted timing/semantic documents. Require evidence of the targeted role, historical applicability, identities and availability bounds where needed; HTTP success or another startDate field is insufficient.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A6. Expansion conditions and scope

Recommend expansion only after useful diagnostics, rights/linkage checks and a new exact allowlist approval. Ceiling: 42 unsaved completed pages plus seven daily documents, reduced whenever possible. No RET, bye or invented uncoded-match page. Preserve all excluded inventory records without statistical use.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A7. Independent corroboration

Recommend separately reviewing OTD documentation before any one pinned 2021-only payload; reject dependence as proof of independence and reject all-season payloads containing locked data. No tennis-data.co.uk or TennisData.app substitution, package installation or source adoption is implied.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A8. Archives

Recommend deferring all archive activity. Any later one-index/three-capture proposal requires exact targets, capture review, request accounting, rights and reproducibility controls. Archived WTA content remains WTA-dependent evidence; no automatic fallback.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A9. Stopping and failure reporting

Recommend stopping on request limits, access/rights restrictions, current-content contamination, identity conflicts, ambiguous semantics, inadequate availability evidence or changed saved artifacts. Return negative findings and residual gaps; never infer dates, expand scope or weaken coverage thresholds to get a pass.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

### A10. Review deliverables and next authorization

Recommend aggregate access/semantics findings, a local evidence/unknowns matrix and the next exact allowlist for user review. A successful stage does not approve another stage, operational chronology, history windows, batching, models, event admission or publication. Require a response-only ChatGPT Handoff of no more than 2,000 words.

Approval: PENDING_USER_APPROVAL; acquisition implemented: FALSE.

## Current completion and unchanged gates

This phase implements documentation and verification only. The acquisition plan is complete as a proposal; **acquisition performed: NONE**. No new URL was checked, no source rights were newly verified and no raw file was created. The policy is ADOPTED; operational chronology is NOT_IMPLEMENTED; chronology/model readiness is BLOCKED; event admission is NOT_EVALUATED; canonical analytical population is NOT_IMPLEMENTED; 95% tour-season gate is NOT_TESTED; modeling authorization is FALSE; publication is BLOCKED_PENDING_RIGHTS_REVIEW. Fixed panel, ATP/WTA separation, development/validation/locked-test splits, deferred Challenger work and portfolio boundaries remain unchanged.

The smallest next milestone is user review of this plan and, only after explicit approval of the applicable scope/ceiling/storage/rights/stopping decisions, the two-request Stage A triage. Approval of Stage A must identify which decisions it covers and must not activate B–D, semantic searches or archives. If access is not approved or rights remain unresolved, stop at the documented blocker.
