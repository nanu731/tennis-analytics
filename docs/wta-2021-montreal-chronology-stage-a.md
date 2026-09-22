# WTA Montreal 2021 chronology Stage A triage

**Phase 1P, 2026-09-22: COMPLETE; STAGE_A_STOPPED_RIGHTS.** One exact terms request succeeded. The proposed programmatic research access is assessed **PROHIBITED** under the returned conduct provisions; retention for that method remains **AMBIGUOUS_STOP_REQUIRED**. The conditional second request was not permitted or attempted. This is a bounded operational assessment, not a legal conclusion.

## Authorization and actual access

The user approved acquisition-plan A1–A4, A9 and A10 **for Stage A only**: WTA scope, two-attempt ceiling, ignored storage/provenance, rights-first gating, stopping and review. A5–A8 remain PENDING_USER_APPROVAL. Stages B/C/D, searches, semantic discovery, match/daily pages, OTD, archives, organizer sites, provider contact, APIs, browser rendering/subresources, redirects and retries remain unauthorized. User authorization does not supply provider permission.

| Request | Directly verified outcome |
| --- | --- |
| 1: https://www.wtatennis.com/terms-and-conditions | GET attempted 2026-09-22T14:41:17Z; HTTP 200; curl exit 0; no redirect or Location target; readable server-delivered terms; no login/bot check encountered |
| Response | Retained 2026-09-22T14:41:18Z; text/html;charset=utf-8; 199865 bytes; original body bytes, unchanged |
| 2: https://www.wtatennis.com/tournaments/806/montreal/2021/order-of-play | NOT_ATTEMPTED_RIGHTS_GATE; no response, file, hash or retrieval time |
| Ceiling | One of two attempts consumed. One numerical slot unused; another request authorized: FALSE. It cannot be repurposed or carried forward. |

Raw response: `data/raw/reference/montreal-2021-chronology/wta-stage-a-terms.html`.

Response SHA-256: `f0185c0ec14067732a3797e3604ef686edf739241371ca91d41fb741cf558918`.

Manifest: `data/pilot/development-2021/montreal-chronology-acquisition/stage-a-manifest.csv`.

Manifest SHA-256: `2265cb488c4e165a4b2ad288defd75adfe559d1972659f6a0e0f03a92165efd9`.

The same ignored audit directory contains `attempt-1.rds`, `response-1.rds`, `review-1.rds` and each record's `.sha256` seal. The manifest binds all three record fingerprints, request timestamp/method/URL, approval IDs, HTTP/redirect outcome, response type/size/path/hash, retrieval timestamp, rights/retention reasons and remaining conditional authorization. No response version or effective date is inferred from retrieval time. No new match table or detailed chronology extraction was generated.

## Terms: observed provisions, interpretation and unknowns

Locators refer to the unchanged saved HTML, not a future page revision. The summaries below paraphrase the returned text; no substantial terms excerpt is reproduced.

| Topic | Directly observed provision and locator | Operational interpretation / unresolved scope |
| --- | --- | --- |
| Automation and extraction | Rules of Conduct, first two bullets, lines 2622–2623: restrict software-based collection and automated access; the collection provision mentions separate written permission; the access provision exempts search-engine indexing. | This single programmatic research GET is not search-engine indexing. A low request count does not clear the automated-access restriction. No separate written permission is present in project evidence. PROHIBITED for the proposed access mode. |
| Personal/noncommercial use and copying | Ownership of Site Content and Submissions, line 2644: personal use and occasional individual-page download/print copies are described, preserving proprietary notices. | A limited personal-copy allowance exists; it is not an educational-research or automation exception. Retention combined with the proposed programmatic method is not cleared: AMBIGUOUS_STOP_REQUIRED. The authorized terms-review snapshot remains ignored as evidence of the blocker; no general research-copy permission is inferred. |
| Redistribution and derivatives | Same ownership paragraph restricts copying, republication, distribution and derivative uses unless specifically authorized. | No raw redistribution or derived-publication permission established. The report documents access/rights findings, not a tennis dataset or legal exemption for public outputs. Publication remains BLOCKED_PENDING_RIGHTS_REVIEW. |
| Request behavior | Conduct bullets, lines 2625–2629, restrict unintended access, overloading, circumvention and disguised origin. | No login, bypass, redirect, retry, browser resources or alternative endpoint was used. A small budget does not supersede the automation prohibition. |
| Attribution / notices | Ownership paragraph requires keeping copyright and proprietary notices for its limited copies. | Original bytes retain those notices. No broader attribution-based research license was found in the relevant provisions. |
| Contact / clarification | Collection provision mentions separate written permission. Copyright-infringement section, lines 2655–2667, limits that contact channel to infringement notices. | No general research permission workflow was established. No contact was made; a DMCA address is not assumed to be a research-permission route. |

The current terms body supplies no verified historical match-day, actual-time, completion, timezone, suspension/resumption or result-availability evidence. It is a current rights document, not a 2021 timing source.

## Semantic outcome and unrequested links

Order-of-play assessment is **NOT_EVALUATED_NO_RESPONSE**. Historical scope, server-delivered daily schedules, literal daily-document links, court order, planned dates/times, timezone, revisions, actual results, completion, availability and current-widget contamination at that target are all unverified. No negative claim about the page's existence or usefulness is justified.

The exact order-of-play URL was already verified as a literal link in two Phase 1G saved pages; those observations were rechecked offline. No new chronology candidate link was discovered. The terms introduction contains a literal `https://www.wtatennis.com/privacy-policy` link; it was not requested and supplies no independently reviewed conditions here. No other link, script, image or subresource was followed. Scheduled information cannot become actual-play/completion evidence merely by being present; synthetic tests preserve that distinction.

## Implementation, reproduction and validation

`R/acquire_montreal_chronology_stage_a.R` uses base R (Rscript 4.6.0) and installed curl 8.7.1/SHA tooling. Running it performs **offline cache validation only**. Network access requires an explicit `msa_attempt()` call with the exact next URL and live opt-in. An immutable reservation precedes the request, so failures/interruption cannot reset the budget. Request two needs a readable first response plus separate, fingerprint-bound affirmative access and retention review. Curl disables its configuration file, redirects and retries; no HEAD or fallback is used. Final manifest validation also checks its fingerprint against this report before reporting success. Raw response changes, record/seal changes, unexpected artifacts and incomplete attempts fail closed.

`R/test_montreal_chronology_stage_a.R` uses only synthetic temporary responses with the live transport blocked. It tests allowlist/order/budget, negative rights/retention, unreadable/login/bot/redirect/failure paths, interrupted reservations, no fictitious failure provenance, cache immutability, altered bytes/fingerprints/manifests, literal links and schedule/current-content limits. Current repository checks verify Stage A-only approval, pending A5–A8 and ignored/untracked outputs. The historical plan test retains all eight invalid-document mutations against the exact Phase 1O Git text, replacing the superseded absence-of-directories assertion with validation of the now-authorized Stage A evidence.

All 57 Stage A checks, 38 chronology-audit, 45 completed-match coverage, 38 recovery and 41 inventory checks pass, alongside policy/plan mutation tests and Phase 1E/F/G/H/K regressions. All 157 protected pre-existing files, including 118 data files, retain hash/size/mtime; exactly eight new ignored files exist. All 145 local links/anchors across 21 Markdown files pass. Detailed completion is recorded in [status.md](status.md). Historical downloader entry points are used only for validated saved-cache regression checks with their request functions blocked, as explicitly allowed by this prompt.

Execution notes: the successful live call emitted an R output-redirection warning because stderr capture forced stdout capture. HTTP/body provenance was unaffected; the wrapper now requests capture explicitly. No live retry was made. Two temporary documentation/check helpers had syntax errors (an invalid escape and a malformed file vector); both were corrected and passed offline. Code review added guards against finalizing a still-open positive gate or reconstructing a missing reviewed cache before the tests were rerun successfully. None of these corrections changed historical evidence or granted access. Git also warned about ignored docs/ during staging; explicit report staging and the staged-file review resolved that warning without including raw/pilot data.

## Unchanged gates and next decision

Chronology policy ADOPTED; operational chronology NOT_IMPLEMENTED; chronology/model readiness BLOCKED; event admission NOT_EVALUATED; canonical analytical population NOT_IMPLEMENTED; modeling authorization FALSE; publication BLOCKED_PENDING_RIGHTS_REVIEW. Count coverage remains 42/49 source-only and 49/49 with the seven approved separate bundles; no tour-season admission is inferred. Cutoff semantics, window choice, date/availability evidence and cross-event history remain unresolved. No dependency, model, 2025 dataset, portfolio change or push occurred.

**Recommendation, not implemented:** next prepare an offline rights-resolution decision brief from this saved evidence, specifying the proposed method and questions for possible provider clarification. The user must decide whether to pursue that route or separately approve an alternative-source documentation review. No outreach, new URL, acquisition stage, statistical choice or publication follows automatically. Require a written ChatGPT Handoff of no more than 2,000 words at the next milestone's completion.
