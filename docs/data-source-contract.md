# Phase 1 tennis data-source contract

Verification date: **2026-09-14**. Status: **source contract with a completed 2023 Indian Wells acquisition pilot; broader panel admission and modeling remain unvalidated**.

## 1. Research question

Can an interpretable Four Factors model capture tennis player strengths and produce better-calibrated match forecasts than surface-adjusted Elo?

The flagship covers ATP and WTA separately. A later project asks which Challenger performance factors predict future ATP Tour success. That extension must reuse validated flagship infrastructure and is not part of this implementation milestone. The governing project instructions are [AGENTS.md](../AGENTS.md).

## 2. Purpose and scope

This contract records source suitability, published reuse conditions, the fixed initial sample, input requirements, proposed tables, validation gates, and decisions needed before acquisition. A candidate classification does not establish rights, actual row coverage, or readiness for modeling.

The primary research workspace is this `tennis-analytics` repository. The separate `portfolio` repository is reserved for later, explicitly requested publication of completed and reviewed research. No portfolio work belongs in this milestone.

The original documentation milestone created only this document and [status.md](status.md). The subsequent user-approved acquisition pilot retained two pinned 2023 annual files locally and audited Indian Wells on both tours. See [pilot-acquisition-audit.md](pilot-acquisition-audit.md) and the [manifest](../data/manifests/pilot-source-files.csv). No canonical tables or models were created.

## 3. Evidence and verification method

### Evidence labels

- **VERIFIED DURING THIS TASK** in the original source review means a local reference or underlying source page was read. When a page reports coverage or provenance, verification establishes that the publisher makes that statement, not that its data independently passes the claim.
- **DIRECTLY VERIFIED FROM DOWNLOADED BYTES** identifies the later 2023 pilot evidence, scoped to its annual headers and two selected events. This does not validate the complete panel.
- **REPORTED BY THE RESEARCH PDF** means a prior finding in [Tennis Analytics: Public Data, Prior Art, and Project Roadmap](../tennis-analytics-public-data-research.pdf), abbreviated **[R]** with page numbers. It has not been reproduced here.
- **PROPOSED DESIGN** means a recommendation for future implementation. It is not a current table, test, model, or approved statistical choice.
- **UNRESOLVED** identifies missing evidence, access limitations, conflicting statements, or a user decision.

### Local foundation

**VERIFIED DURING THE ORIGINAL SOURCE REVIEW:** All 20 pages of [R], including its references and verification notes, were read using in-memory text extraction with the existing bundled PDF reader. No extraction file or analysis script was created in that documentation milestone. PDF metadata reports 129,496 bytes and the title above. SHA-256: `1c18296ff08f22a0284100788104640267275f8ff33fa7840014fb29c96224ad`.

The original source-review milestone started clean on `main` at `f4d5ecad8f1e96ab3076fbef2b1d9eda673e1e92`. Five recent commits were requested; only three existed. The configured origin was `https://github.com/nanu731/tennis-analytics.git`. The branch was ahead of its existing `origin/main` reference by two commits; no live-remote comparison occurred. Existing tracked files were `.gitignore`, `AGENTS.md`, `LICENSE`, `README.md`, and [R]. The applicable ancestor `AGENTS.md` was also read. No nested instruction files or existing `docs` directory were found at that original starting point.

The local license is MIT. It does not establish rights over externally sourced tennis data. `.gitignore` still ignores `docs/`; new authorized documents require explicit staging. The pilot adds exclusions for local raw and pilot data. See [DATA_LICENSE.md](../DATA_LICENSE.md).

### Research-report findings and limitations

**REPORTED BY THE RESEARCH PDF:** [R, pp. 1–7] reports 9,828 matches in the shared panel, with 9,755 complete for its serve-point criterion (99.26%). This is not a newly verified count and is not proof of completeness for every required field in section 8. Its lower-tier audits suggest discontinuous ITF statistics around 2025; Challenger results and tour qualifying are mixed in some files. [R, pp. 7–9] distinguishes aggregate, point, shot, and tracking data and reports no complete free public optical-tracking feed. This task did not establish that no such feed exists.

[R, pp. 10–12] proposes Net Point Rating, four candidate families, opponent adjustment, importance decomposition, uncertainty, and chronological forecast comparisons. [R, pp. 15–18] recommends R, provenance manifests, canonical identities, coverage audits before Elo, and factor selection before final testing. These guide requirements, not implemented methods.

[R, p. 17] proposes 95% flagship tour-year coverage; its 90% rule on p. 6 concerns tier expansion. They are distinct recommendations. Reference [12] on p. 19 is an incomplete ATP URL ending `what-is-`; it is not usable evidence for Challenger categories.

### External verification boundaries

During the original source review, underlying documentation and license pages were opened; search snippets were not used as verification. Source links appear beside claims and in section 17. No dataset was downloaded in that earlier milestone. The later pilot acquired only `atp/atp_matches_2023.csv` and `wta/wta_matches_2023.csv`; their byte sizes, row counts, SHA-256 hashes and Git blob matches are recorded in the pilot evidence. No other season or point dataset was acquired.

**DIRECTLY VERIFIED FROM DOWNLOADED BYTES:** ATP Indian Wells is `2023-0404`, `Indian Wells Masters`; WTA is `2023-609`, `Indian Wells`. Each has 95 rows and 96 player IDs. Both use date label `20230306`, hard surface, and 49-column annual schemas with all 18 required count columns. Non-walkover completeness is 95/95 ATP and 94/94 WTA; after removing one WTA count-review row from the valid numerator, WTA is 93/94 (98.9362%). These are observed-file denominators, not independently reconciled official inventories. The ATP source draw size is 128; WTA is 96. WTA match 268 needs service-game/score review. No actual match-date or dedicated status column exists in either annual header.

Availability findings describe retrieval during this task, not guaranteed availability for other clients. Some pages came through the browsing service's retrieved representation; this is not an independent uptime test. No account was created, permission requested from a provider, or licensing agreement accepted.

## 4. Source decision matrix

All classifications below are **provisional project decisions**, checked 2026-09-14. `PRIMARY_CANDIDATE` means plausible principal input; `SUPPLEMENTARY_CANDIDATE` means limited complementary use; `BENCHMARK_ONLY` limits an otherwise usable source to comparisons; `REQUIRES_PERMISSION` means an explicit grant or clarification is needed; `REJECTED_FOR_CURRENT_SCOPE` excludes a source from this milestone's intended dataset; `UNRESOLVED` means evidence is insufficient. Not every label needs a selected source.

| Candidate / intended role | Provisional status | Evidence and outstanding condition |
| --- | --- | --- |
| Aneeshers archive: Sackmann ATP/WTA aggregate matches | `PRIMARY_CANDIDATE` | User approved the pinned noncommercial pilot. Indian Wells bytes support schema/availability, with one WTA count anomaly; full coverage, provenance limits and precise chronology remain gates. [S1–S5; pilot audit] |
| Same archive: Slam point-by-point | `SUPPLEMENTARY_CANDIDATE` | Point/shot detail is uneven and historical; not necessary for first aggregate acquisition. [S1, S6] |
| hi-im-elson Match Charting Project fork | `SUPPLEMENTARY_CANDIDATE` | Preserves a separate crowdsourced shot-data corpus and license. Selection bias and snapshot coverage require audit. [S7] |
| IBM Datapalooza Wimbledon datasets | `SUPPLEMENTARY_CANDIDATE` | Public historical release with Apache-2.0 repository license; file-level notices and suitability still need review. Does not supply the 2021–2025 panel. [S8–S9; R, p. 8] |
| Live Tennis API academic program | `REQUIRES_PERMISSION` | Institutional application and approval required; raw redistribution prohibited by program conditions. Later lower-tier role only. [S10] |
| tennis-data.co.uk | `UNRESOLVED` | Direct pages were not retrievable. The PDF's proposed local benchmark role is unconfirmed, not a grant of research or derivative-publication rights. [S11–S12; R, p. 3] |
| TennisData.app | `REQUIRES_PERMISSION` | Download-page invitation conflicts with formal copying, derivatives, and automation restrictions. Obtain written clarification before use. [S13–S14] |
| Open Tennis Data v3 | `SUPPLEMENTARY_CANDIDATE` | Documentation supports identity/date/provenance cross-checks, not aggregate factor inputs. Preview status and source-dependent rights prevent unconditional adoption. [S15–S18] |
| Official ATP calendar/category material | `UNRESOLVED` | ATP pages/PDFs returned 403; ATP Media resource page was readable but does not complete the season-specific registry. [S19–S21] |
| Official WTA calendar/category material | `SUPPLEMENTARY_CANDIDATE` | Useful reference evidence; calendar list did not populate. Selected edition pages and announcements were readable. No bulk-data or republication permission inferred. [S22–S25, P1–P13] |
| Official ITF category material | `SUPPLEMENTARY_CANDIDATE` | Readable category-change guidance supports later season-aware mapping; ITF datasets remain outside the panel. [S26–S29] |

## 5. Source-by-source findings

### 5.1 Sackmann ATP/WTA archival match data

**VERIFIED DURING THIS TASK:** [S1] describes an Aneeshers preservation repository containing `atp`, `wta`, and `slam_pointbypoint`, with original readmes retained. It attributes compilation to Jeff Sackmann and claims June 2026 ATP/WTA snapshots. The source documentation was successfully read at the full revision `83733587353df8a41f2fd4f516147d5aa83f5a8d`. This establishes that those documentation paths resolve at the proposed pin, not that all upstream history or dataset bytes have been authenticated.

[S2–S4] describe match rows, player tables, and dated rankings. ATP tour main draws, Challenger/main-tour qualifying, and Futures are separated by file family; WTA qualifying/ITF results have a separate family. Counts include both players' serve totals, aces, double faults, first serves, first/second points won, service games, and break points. Dictionary mappings are in section 8. ATP statistical history is described as generally starting in 1991 for tour matches, 2008 for Challengers, and 2011 for tour qualifying. WTA points to the ATP dictionary; completeness is not promised.

**REPORTED BY THE RESEARCH PDF:** ATP result years 1968–2026 and WTA 1977–2026 [R, p. 3]. These lower bounds and annual file completeness were not audited here. Current documentation says through 2026, which is a partial current year, not full-season coverage.

**Rights:** Preserved ATP/WTA readmes and archive license identify CC BY-NC-SA 4.0 [S2, S4–S5]. Noncommercial research appears permitted subject to its conditions. Sharing/adaptation rights are conditional, not MIT: credit Jeff Sackmann/Tennis Abstract and original repositories, identify changes, link the license, and apply required share-alike conditions [S30]. The user has declared noncommercial educational intent for the pilot; compatibility of a specific portfolio release and the treatment of its derived outputs remain review questions. Mirror claims cannot cure missing third-party rights.

**UNRESOLVED:** original ATP, WTA, and Slam GitHub URLs returned 404 in the original source review [S31–S33]. The reason for unavailability remains unknown. Exact upstream June commit IDs and complete original provenance remain unresolved. The pilot verified two annual-file hashes and their Git blob identities against pinned directory metadata; other file bytes were not checked. `tourney_date` is usually an event-week date; `match_num` can be arbitrary. Neither supplies reliable match order [S3], confirmed as an unresolved limitation by the pilot headers. Archived data are plausible aggregate inputs, not yet a defensible chronological forecast dataset.

### 5.2 Slam point-by-point archive

**VERIFIED DURING THIS TASK:** This is another Sackmann corpus in [S1], not Match Charting Project data. [S6] describes points and match metadata scraped from Slam websites, including some doubles separately. It describes varying serve-speed, rally, serve-number, and distance fields; missing or placeholder values vary by event and source system. It says AO/FO extraction was not attempted from 2023 onward. The archive advertises 2011–2024 coverage; that is not complete four-Slam coverage in every year.

**Rights/status:** same stated CC BY-NC-SA conditions and attribution as above; supplementary only. **REPORTED BY THE RESEARCH PDF:** 49 singles event-years and 1,922,136 points, with snapshot-specific holes [R, p. 7]. The readme and PDF differ in detail about AO/FO 2022 availability; an eventual file inventory must resolve this. Do not silently treat the readme's historical scope as the actual archived inventory. No points or optical coordinates were acquired.

### 5.3 Match Charting Project

**VERIFIED DURING THIS TASK:** [S7] is a separate hi-im-elson fork of Jeff Sackmann's Match Charting Project. Its readme describes contributor-entered shot encodings, point rows, aggregate match statistics, men's/women's files, and metadata including tournament/date/surface. It credits Tennis Abstract's crowdsourced project under CC BY-NC-SA 4.0. Conditional noncommercial research and redistribution follow that license; retain contributor/project attribution and change notices.

**REPORTED BY THE RESEARCH PDF:** pin `fbc316f5d830d2ea2641564953f4eb8499a4189e`, 8,855 matches, and roughly 1.42 million points through 2024-10-18 [R, pp. 3, 7, 19]. That pin and those counts were not independently checked. Earliest years and exact tournament-level coverage are **UNRESOLVED**. Nonrandom contributor selection makes this a tactical validation candidate, not a substitute for panel-wide statistics. The Aneeshers repository listing does not include MCP despite the broader wording in [R]'s reference [1].

### 5.4 IBM Datapalooza Wimbledon

**VERIFIED DURING THIS TASK:** [S8] is an IBM Datapalooza release, not a Sackmann mirror. Its listing includes a Slam set-statistics file, weather files, and Wimbledon `w14`/`w15` point files for rounds 1–3. Its point dictionary documents server/winner, serve type and direction, speed, rally information, shot outcomes, and timestamps. The README labels both point files as 2014 despite the `w15` filename: actual edition years require file inspection.

**REPORTED BY THE RESEARCH PDF:** 86,934 player-set rows, largely 2005–2015 plus AO 2016; 83,307 Wimbledon point rows across 2014–2015; both tours [R, p. 8]. Exact set-file fields and years remain unverified here.

**Rights:** Repository `LICENSE` was read through GitHub's content connector after browser retrieval failed [S9]. Apache 2.0 permits covered-work reproduction and derivatives subject to license, notice, and change-marking requirements. Noncommercial research, raw redistribution, and derived publication appear possible **for material actually covered by that grant**. Repository location alone does not prove rights over every externally collected file. Review per-file notices before adoption. Current historical scope makes it supplementary; no modern IBM tracking feed was verified.

### 5.5 Live Tennis API academic data

**VERIFIED DURING THIS TASK / PROVIDER CLAIM:** [S10] describes a 2023-01-01–2026-08-13 match index across ATP, WTA, Challenger, and ITF, with index fields for event, tier, surface, round, format, scheduled UTC time, and player IDs. Metadata includes a Sackmann crosswalk. It distinguishes live-observed points from reconstructed third-party sequences; live observation starts 2025-10-12. Partial tapes and missing serve-speed/direction/shot data are explicit limitations. Scheduled time is not proof of actual play time.

The program offers free noncommercial academic research/teaching access on application, with annual renewal, an embargo, citation, and publication notification. It prohibits raw redistribution and permits published aggregates/findings. Reconstructed layers require case-specific access. These are program claims, not an access grant to this project. Independent portfolio eligibility is unknown. No application or dataset was obtained. The linked Zenodo page initially resolved but later failed; its license and payload were not verified. Classification remains `REQUIRES_PERMISSION`.

### 5.6 tennis-data.co.uk

**UNRESOLVED:** [S11–S12] failed through browsing (timeouts). A direct HTTPS attempt first hit sandbox DNS failure; the approved network retry failed TLS negotiation. The failure does not prove the site is unavailable elsewhere. No underlying content or current terms were read successfully.

**REPORTED BY THE RESEARCH PDF:** season-level ATP 2000–2026 and WTA 2007–2026 results/odds downloads, useful for bookmaker benchmarks; no clear open-data license found [R, p. 3]. Creator identity beyond the site, exact levels, schema, dates, attribution requirements, noncommercial research rights, raw redistribution, and derived-output rights are all unverified in this milestone. Open Tennis Data's notice is a secondary claim, not permission from this source [S16]. Do not treat `BENCHMARK_ONLY` as an established permission. Reverify before any local use or publication.

### 5.7 TennisData.app

**VERIFIED DURING THIS TASK / PROVIDER CLAIM:** [S13] advertises 2021–2026 ATP/WTA seasonal CSVs covering main tours and Challenger events, stable player IDs, home/away orientation, winner code, percentage fields, and odds. Actual raw counts needed for factors, exact competition coverage, upstream creators, and download access remain unverified; the page shows a bot-check notice. No check was bypassed and no data was acquired.

The broad download-page invitation conflicts with [S14, sections 18 and 20], which limits use and requires prior written permission for copying, redistribution, public display, and derivatives, while prohibiting automated extraction. Therefore noncommercial research permission for this project, raw sharing, derived publication, and required attribution need written clarification. `REQUIRES_PERMISSION`; do not resolve the conflict by selecting the more permissive sentence.

### 5.8 Open Tennis Data v3

**VERIFIED DURING THIS TASK / MAINTAINER CLAIM:** ryantjx's project [S15–S18] describes ATP/WTA top-level main-draw singles from 2020 onward and preview releases. Match schema v3.3 contains identity, date, round, format, result, status, and source fields, but none of the nine required aggregate service-count fields. Separate assets describe players, tournaments, provenance, coverage, and source policies. Terminal rows require match-day evidence; preview history can have missing retrieval timestamps. These are documented contracts, not locally tested releases.

The software's MIT license explicitly does not cover the tennis data [S16]. Source-specific Sackmann, Wikimedia, tennis-data.co.uk, and correction obligations remain. Research use and publication are conditional on the contributing sources and exact release manifest; no blanket raw/derived redistribution grant or commercial permission was established. Attribution must follow every contributing source. Use only as a supplementary identity/date candidate after permissions and overlap audit. Its use of Sackmann means agreement is not fully independent validation [S17–S18].

### 5.9 Official calendars and categories

**ATP — UNRESOLVED:** [S19–S20] and linked calendar PDFs returned 403. [S21], ATP Media's resource page, directly lists ATP 250/500/Masters 1000 categories and links to an ATP calendar, but does not verify all 2021–2025 editions. Historical Challenger categories reported by [R] must be checked against valid season-specific official documents. ATP website terms were also not retrieved; research extraction, raw republication, and derived-database rights remain unestablished. These are official metadata references, not verified bulk match-stat sources.

**WTA — VERIFIED DOCUMENTATION:** [S22] explains tour categories; [S23] exposes year/surface/category filters but its returned calendar list remained unloaded. Selected 2025 event pages and dated announcements support the metadata and exceptions in section 7. [S25] restricts automated/mass collection and redistribution, while describing limited personal use. Reference reading does not grant a calendar-scraping or publication license. Do not copy entire official calendars or assume public facts waive terms. Attribute specific WTA pages; publication/extraction scope needs review.

**ITF — VERIFIED DOCUMENTATION:** [S26–S27] describe the men's/women's professional pathways. [S28, p. 1] documents the 2024 women's transition: W25/W40/W60 renamed W35/W50/W75, W80 removed. Historical category labels and prize money must remain season-specific. Men's category mapping beyond the reviewed documents remains incomplete. [S29] permits limited private noncommercial page use and restricts republication. No open bulk-data grant was established. Attribute ITF documents; later collection and publication require separate rights review. ITF events remain outside this panel.

## 6. Licensing and redistribution implications

**PROPOSED DESIGN:** Store a separate rights decision for local research, raw redistribution, and each type of derived output. An accessible endpoint, a provider's coverage claim, or a code license is not a data license. This is a report of published provisions and uncertainty, not legal advice.

1. The user approved noncommercial educational research for this pinned pilot. Eventual portfolio use and specific derivative-publication obligations still require review [S5, S30]. Do not automatically mark charts, ratings, or JSON as exempt derivatives.
2. Keep third-party notices separate from the repository MIT license. Do not relabel restricted datasets as MIT. No license file is changed by this milestone.
3. Record URL, retrieval time, immutable source revision, file name/size/SHA-256, original creator, mirror chain, terms URL/version, permitted uses, required attribution, and unresolved restrictions. The pilot's [tracked manifest](../data/manifests/pilot-source-files.csv) now supplies these records for two 2023 files only.
4. Keep raw files outside Git. The user approved `data/raw/sackmann/83733587353df8a41f2fd4f516147d5aa83f5a8d/` and `data/pilot/`, with ignore rules, for this pilot. Further structural changes require authorization.
5. IBM's covered files may offer broader reuse than CC BY-NC-SA, but file-specific rights must still be established [S9]. Live Tennis raw redistribution is prohibited by its academic conditions [S10]. TennisData.app and tennis-data.co.uk remain blocked as described above.
6. Official metadata references support verification; they do not authorize automated acquisition or copied calendar publication [S25, S29]. Resolve the intended use before producing a public registry derived from restricted material.

## 7. Standardized tournament panel

**FIXED USER SCOPE:** Ten event families, each on ATP and WTA, for required seasons **2021, 2022, 2023, 2024, 2025**. This creates **100 expected tour-season-family cells**, an arithmetic design target, not 100 verified acquired editions. Development = 2021–2023; validation = 2024; locked final test = 2025. No panel or split change is authorized.

**PROPOSED DESIGN, APPROVED FOR THE PILOT:** Main-draw singles on both tours at 2023 Indian Wells. Keep qualifying rounds, doubles, juniors, wheelchair, team events, and Challenger/ITF out of that cohort. Preserve walkovers and incomplete outcomes in the audit universe even when not eligible for factor calculations. The pilot retains retirement rows and excludes walkovers from its non-walkover denominator; final retirement policy is unsettled. A player's qualifying entry into a main draw does not make that main-draw match a qualifying-round match.

Both tours are required in every row below. Surfaces/cities are expected metadata, supported by selected official references where available; they are not an exhaustive audit of all 100 editions. Alias entries are **candidate match labels to recognize**, not claims that every spelling occurs in the raw files.

| Canonical family | Tours / seasons | Expected surface; host location | Candidate aliases | Edition exceptions and post-acquisition questions |
| --- | --- | --- | --- | --- |
| Australian Open | ATP + WTA; 2021–2025 | Hard; Melbourne [P1] | Australian Open; AO | Official 2021 announcement specifies February 8–21 and offshore qualifying [P10]. Verify actual dates and exclude qualifying locations from main-draw city mapping. |
| Roland-Garros | ATP + WTA; 2021–2025 | Clay; Paris — expected, pending successful edition-page verification | Roland Garros; Roland-Garros; French Open | Main draw delayed to May 30 in 2021 [P11]. Verify surface, venue, official edition dates and aliases; attempted 2025 overview failed. |
| Wimbledon | ATP + WTA; 2021–2025 | Grass; Wimbledon/London [P2] | Wimbledon; The Championships | WTA's 2022 guide describes no ranking points and scoring/scheduling changes [P12]. Verify tour-specific rules and eligibility, not a canceled event. |
| US Open | ATP + WTA; 2021–2025 | Hard; New York/Queens [P3] | US Open; U.S. Open | 2025 main draw began on Sunday under an extended schedule [P13]. Verify edition-specific dates; do not assume a Monday opening. |
| Indian Wells | ATP + WTA; 2021–2025 | Hard; Indian Wells [P4] | Indian Wells; BNP Paribas Open | WTA's revised 2021 calendar places the event in October [P14]. Confirm each tour's actual dates; do not carry the 2020 cancellation into 2021. |
| Miami | ATP + WTA; 2021–2025 | Hard; source city Miami; Hard Rock Stadium venue [P5] | Miami; Miami Open; Miami Open presented by Itau/Itaú | Verify municipality and venue versus source city, dates, draw/status counts, and year-specific labels. No relocation within this period independently established here. |
| Madrid | ATP + WTA; 2021–2025 | Clay; Madrid [P6; S21] | Madrid; Mutua Madrid Open | Verify actual draw expansion timing per tour/year rather than backfilling the 2025 draw to earlier years. |
| Rome | ATP + WTA; 2021–2025 | Clay; Rome [P7] | Rome; Roma; Italian Open; Internazionali BNL d'Italia | Verify draw changes, dates, sponsor names and source IDs per tour/year. |
| Canada | ATP + WTA; 2021–2025 | Hard; Montreal and Toronto as separate edition cities [P8, P13] | Canada; Canadian Open; Rogers Cup; National Bank Open; Omnium Banque Nationale; Montreal; Toronto | 2025 WTA Montreal/ATP Toronto documented [P13]; independently verify all other tour-year city assignments. Preserve original city and name. Extended 2025 event needs revised expected counts. |
| Cincinnati | ATP + WTA; 2021–2025 | Hard; source city Cincinnati, venue Mason, Ohio [P9] | Cincinnati; Cincinnati Open; Western & Southern Open | Official 2025 page prose says 96 singles but its summary field says 94 [P9]; planned expansion is documented separately [P13]. Resolve actual draw/count conventions from final draws. Do not infer relocation from aliases. |

**UNRESOLVED:** No exhaustive cancellation/relocation audit for all 100 cells has been performed. [R, p. 5] reports presence on both tours throughout; this remains a prior audit claim. The above list records verified examples, not a declaration that no other exceptional editions exist. ATP classifications should be resolved with official season evidence; do not convert the archive's `A` code into 250/500 from draw size. WTA's current pages can mix an old edition header with newer stories; use dated edition evidence, not the surrounding news feed.

For every acquired edition, verify source ID, tour, draw type, city/country, actual start/end dates, level, surface, aliases, status, draw size, byes, walkovers, completed matches, and tournament lineage. Calendar schedules alone do not prove actual match occurrence. Unmatched or canceled cells require investigation and a user decision, never silent panel substitution.

## 8. Required raw fields

**PROPOSED DESIGN:** A source must either provide a field or permit a documented, rights-cleared reconstruction. Keep raw values unchanged. Requirements are scoped: identity/context for all records; counts for factor-eligible records; optional biography/ranking values remain nullable. Retain a reason for missingness. The dictionary mappings [S3–S4] were subsequently confirmed against both acquired 2023 annual headers, including absence of an actual match-date or explicit completion-status field. Field population was audited for Indian Wells only.

| Required identity/context | Sackmann documentation mapping | Acceptance requirement / gap |
| --- | --- | --- |
| Source match identifier | `match_num` within event | Preserve as text; composite source/tour/draw/season/tournament/match namespace, not global uniqueness. |
| Source tournament identifier | `tourney_id` | Preserve exact value and link through aliases; no inference from suffix. |
| Tournament name | `tourney_name` | Preserve original alongside canonical family. |
| Tour / season / draw type | File context; tournament identifier and date evidence | Record filename-derived context and verify; do not infer sex/tour from names. |
| Match date | **Not established** by `tourney_date` | Require independently evidenced played-on date, its role, precision and source; event-week date is a separate field. |
| Surface / level | `surface`, `tourney_level` | Canonical mapping with official season evidence; preserve raw code. |
| Round / best-of | `round`, `best_of` | Validate format and round ordering by draw type; numeric label 3/5 describes sets, not actual sets played. |
| Score | `score` | Preserve string exactly; do not derive point totals from game/set score. |
| Completion status / retirement / walkover | Dedicated fields absent from both acquired 2023 annual headers | Pilot records explicit score markers and completion-consistent syntax separately from official status; unknown must not become completed/false automatically. |
| Source player ID and name, both sides | `winner_id/name`, `loser_id/name` | Link identity before orientation; every admitted match has two distinct canonical players. |
| Hand / country, when available | `winner_hand/ioc`, `loser_hand/ioc` | Preserve unknowns and original country codes; avoid invented nationality corrections. |
| Pre-match rank / points, when available | `winner_rank/rank_points`, `loser_rank/rank_points` | Dictionary dates rankings to event date or prior ranking date; record as-of evidence and missingness. No final-season rank backfill. |

**Both-player count contract:** for each prefix `w_` and `l_`, require the following nine integer counts when admitting a row for the proposed complete-count factor cohort. Remap the entire side consistently after establishing neutral A/B slots.

| Meaning | Source suffix | Proposed symbol |
| --- | --- | --- |
| Aces | `ace` | A |
| Double faults | `df` | D |
| Service points | `svpt` | S |
| First serves in | `1stIn` | I |
| First-serve points won | `1stWon` | F |
| Second-serve points won | `2ndWon` | Q |
| Service games | `SvGms` | G |
| Break points faced | `bpFaced` | B |
| Break points saved | `bpSaved` | V |

Also retain winner identity as the outcome, source row locator, file/revision, and original side mapping. These are not predictive features. Exact start/end UTC times, venue timezones, within-day order, source retrieval times, and data-availability times are additional chronology/provenance requirements wherever obtainable, not fields claimed to exist in Sackmann files.

## 9. Derived-measure requirements

**PROPOSED DESIGN, not selected Four Factors formulas.** Let subscript `i` denote a player and `j` the opponent. All rates below are fractions; multiply by 100 only for percentage display. For an undefined/zero denominator or missing required input, return missing with a reason, never zero. Window rates should use sums of compatible counts rather than an unweighted mean of match percentages.

These are algebraic requirements using the count meanings in [S3], not evidence of actual source completeness. Before implementation, verify that `S-I` counts second-serve opportunities including double faults and that both players' totals cover the same point universe, including tie-break points. No independent total-point field was established in the reviewed dictionary.

| Measure | Numerator | Denominator / calculation | Required inputs and limitation |
| --- | --- | --- | --- |
| Service points won, count | `F_i + Q_i` | Count, no denominator | Both first/second wins. |
| Service points-won rate | `F_i + Q_i` | `S_i` | Requires positive service points. |
| Return points won, count | `S_j - F_j - Q_j` | Count, no denominator | Opponent's complete service counts, same point universe. |
| Return points-won rate | `S_j - F_j - Q_j` | `S_j` | Opponent service points are this player's return points. |
| Total points won, count | `F_i + Q_i + S_j - F_j - Q_j` | Count, no denominator | Needs both players; total points lost are opponent's total won. |
| Total point-win rate | Total points won by `i` | `T = S_i + S_j` | Same included points on each side. |
| First-serve percentage | `I_i` | `S_i` | First serves in per service point. |
| Ace rate | `A_i` | `S_i` | Proposed service-point denominator; not first serves only. |
| Double-fault rate | `D_i` | `S_i - I_i` | Proposed per second-serve opportunity; also retain `D_i/S_i` as a separately named descriptive rate. Final factor choice deferred. |
| First-serve points-won percentage | `F_i` | `I_i` | Undefined if no first serves in. |
| Second-serve points-won percentage | `Q_i` | `S_i - I_i` | Includes double faults in opportunities; do not subtract them a second time from the denominator. |
| First-serve return points-won rate | `I_j - F_j` | `I_j` | Complements opponent's first-serve success. |
| Second-serve return points-won rate | `S_j - I_j - Q_j` | `S_j - I_j` | Includes opponent double faults. |
| Break-point conversion | `B_j - V_j` | `B_j` | Complement of opponent saves, not service games broken divided by all return games. No opportunities means missing rate. |
| Break-point save percentage | `V_i` | `B_i` | No faced opportunities means missing rate. |
| Break chances per return game | `B_j` | `G_j` | A rate, not a probability; can exceed one. Verify service-game/tie-break convention. |
| Net Point Rating | `100 * (total_won_i - total_won_j)` | `T` | Equivalently `200 * total_won_i/T - 100`; range -100 to 100. [R, p. 10] |
| Equal-phase Net Point Rating | Service win fraction plus return win fraction minus 1 | `100 * ((F_i+Q_i)/S_i + (S_j-F_j-Q_j)/S_j - 1)` | Requires both positive phase denominators; not generally identical to NPR. [R, p. 10] |

**Not directly identifiable from these aggregate fields:** unreturned-serve rate, rally tolerance, serve placement/speed, winners/errors, point leverage, actual break-point sequence, expected conversion/saving residuals, and tracking measures. They need supplementary fields or an explicit model. A game score cannot recover exact points played. Opponent adjustments, rolling windows, minimum point counts, shrinkage, and factor-family aggregation are later choices. Mechanical overlap between these components and NPR must be acknowledged before interpreting regression importance as an independent causal contribution.

## 10. Proposed canonical tables

**PROPOSED DESIGN ONLY:** No table is created. Keys are stable internal strings unless a composite key is stated. Every accepted foreign key must resolve; unknown mappings remain quarantined, not fabricated. Version rules and decisions so that a changed mapping does not erase the original evidence.

| Table / grain and purpose | Primary key | Foreign keys | Minimum fields |
| --- | --- | --- | --- |
| `sources`: a source namespace/program | `source_id` | None | Creator, source URL/type, original upstream URLs, tour/grain/coverage claims, classification, license/terms URL, terms revision/check date, local/raw/derived-use decisions, attribution, permission evidence, uncertainty. |
| `source_files`: one immutable acquired file version | `source_file_id` | `source_id -> sources` | Source revision and filename/path, URL, retrieval timestamp, bytes, SHA-256, content type, declared tour/season/draw, upstream lineage, applicable terms reference, parser/transform version when later used. A changed checksum creates a new record. |
| `events`: one canonical tour-season-family edition/draw | `event_id` | Evidence references to `source_files` when acquired | Family, tour, season, draw type, edition city, venue if known, country, actual start/end, date precision, surface, indoor flag if known, official level, draw/bye counts, edition status, panel version/member flag, evidence and transformation version. Unique approved edition tuple; dates/city are attributes with history, not mutable IDs. |
| `event_aliases`: source event observation/mapping | `event_alias_id` | `event_id -> events`, `source_file_id -> source_files` | Source tournament ID/name/city/level/date exactly as supplied, source tour/season/draw namespace, mapping method, confidence/review status, evidence locator. Unique source-file/event namespace; ambiguous mappings cannot join automatically. |
| `players`: canonical individual | `player_id` | Evidence references to `source_files` | Canonical display name, nullable hand/country/date of birth when permitted, metadata as-of time, review state. Country/name alone never determines identity. |
| `player_aliases`: source identity observation | `player_alias_id` | `player_id -> players`, `source_file_id -> source_files` | Source namespace/player ID, original names and metadata, effective/as-of date when known, match method and review evidence. A source ID maps to one canonical person unless a documented reuse/split requires disambiguation. |
| `matches`: one deduplicated match in the audit universe | `match_id` | `event_id -> events`; `player_a_id`, `player_b_id`, nullable winner ID -> `players`; provenance entries -> `source_files` | Neutral A/B slots; winner/result separate; raw and canonical round/score/status; best-of; played-on/date role/precision; start/end/timezone when known; season/split; chronology quality; retirement/walkover flags with unknown state; eligibility reason; all source match observations and transformation version. |
| `match_stats`: one player-side statistical observation from one source/version | (`match_id`, `player_id`, `source_file_id`, `source_row_locator`, `stat_scope`) | Match, player, source-file keys | Nine raw counts, original side/column values, count-unit conventions, source evidence, validity/missingness flags, accepted-observation flag, transform version. Exactly one accepted whole-match observation per player, chosen by a documented reconciliation policy; retain rejected/conflicting observations. |
| `dataset_coverage`: one audit cell for a dataset/contract version | `coverage_id` | `source_id`; nullable `source_file_id`, `event_id` where applicable | Dataset/contract version, tour, season, event family, draw, field or complete-input bundle, official expected inventory, observed/eligible/valid counts, missing/invalid/duplicate/status counts, numerator/denominator and rate, gate result, failure reason, audit time/version. Explicitly represent absent expected cells. |

**Provenance without an extra table:** Within the nine-table scope, `matches` carries a structured list of source observations, each with `source_file_id`, row locator, source match/tournament/player identifiers, original values, and field-level selection/conflict decisions. Events and players likewise retain evidence references; aliases preserve source observations. Validate references inside these structures as foreign keys. A future normalized provenance table would require a separate scope decision, not silent loss of evidence.

**Neutral orientation proposal:** assign A/B using a stable ordering of established canonical player IDs, unrelated to winner, ranking, or match statistics. Store original winner/loser mappings for audit and test complete side swaps. Do not identify a match by its winner; cross-source matching should begin with event/draw, the unordered player pair, round and date evidence, then review conflicts. Dates or names alone are insufficient.

**Chronology contract:** Store tournament date separately from match date. An exact day does not establish order between two same-day matches or prove a suspended match had finished. Before forecasts, select an evidence-backed ordering policy or a conservative batching policy that uses only previously completed matches. Never sort arbitrary `match_num` and call it actual chronology. If time precision is inadequate, mark the match ineligible for the planned forecasting mode until an approved resolution exists. Historical retrieval time is not historical feature availability.

## 11. Proposed data-quality gates

These remain specifications for the full dataset. The [pilot audit](pilot-acquisition-audit.md) reports the subset of checks actually executed on Indian Wells, including one WTA service-game/score flag. Official inventory and chronology gates were not satisfied. **Block** means stop the affected admission/build stage; **quarantine** means preserve evidence but exclude an invalid observation; **review** means report and resolve before admitting the affected cohort. Never repair invalid values by silently converting them to zero.

| Gate | Proposed test and response |
| --- | --- |
| Required columns | Compare each file's actual schema with its documented tour/file-family contract. Missing mandatory context/count fields block that file's relevant use; optional fields are reported, not invented. |
| Column types | Strict parsing; preserve ID strings and original values, record failed dates/counts, reject fractional or negative count values. Unknown flags are nullable, not false. |
| Source-match uniqueness | Within a pinned dataset version, validate source namespace + tour + draw + season + tournament ID + match number; duplicate source observations across overlapping files are investigated rather than counted twice. |
| Within-source duplicates | Compare exact row fingerprints and canonical event/player-pair/round/date candidates. Keep raw duplicates and resolve the selected observation; a repeat encounter is not automatically a duplicate. |
| Cross-source duplicates | Reconcile the same match before pooling counts; preserve disagreements and every provenance contributor. Shared upstream sources do not provide independent corroboration. |
| Event editions | Unique approved tour-season-family-draw edition; detect multiple source IDs, conflicting cities/dates, and missing expected cells. Do not collapse Canada into a cityless record. |
| Player ambiguity | Two distinct players per singles match; all accepted aliases resolve. Name-only collisions, reused IDs, incompatible biographical evidence, or ambiguous crosswalks block affected matches. |
| Valid dates | Actual played-on dates inside verified edition windows, accounting for suspensions; impossible dates fail. Tournament-week dates must never satisfy a match-day requirement. |
| Chronological ordering | Demonstrate a permissible before/after relation for every update. Same-day uncertainty and completion times must follow the approved policy. Future features cause hard failure. |
| Surfaces and rounds | Validate controlled values against event/draw evidence; unknown or contradictory values quarantine relevant surface/round analyses. Never assume one round order across singles, qualifying, and doubles. |
| Nonnegative counts / numerator bounds | Require `0 <= I <= S`, `0 <= F <= I`, `0 <= Q <= S-I`, `0 <= D <= S-I`, `Q+D <= S-I`, `0 <= V <= B <= S`, and `A <= F+Q`, subject to verified source definitions. Aces need not all be first-serve aces. Invalid records fail the complete-count gate. |
| Service/return reconciliation | Derive return wins from opponent service losses; both players' total wins must sum to `S_a+S_b`. Swapping players reverses NPR. These identities catch implementation errors but are partly tautological; validate against independent totals when available and do not claim independent source accuracy from algebra alone. |
| Games and break points | Verify `B-V` versus service games lost where independent counts exist, and investigate incompatibilities with score/tie-break conventions. Do not force service-point counts from final game scores. |
| Unexpected zeros | Zero aces/double faults/break chances may be valid; all-zero service totals for a played complete match are suspect. Detect clusters by field/source/tour/event/year before interpreting zeros. Undefined ratios remain missing. |
| Missingness | Report every required field and the joint complete-input bundle by source/tour/event/season, including invalid counts separately. Missing optional ranks create a separately reported ranking-baseline cohort. |
| Walkovers | Retain and label in audit records; no played points or routine Elo update assumed. Exclude from proposed factor-eligible denominator with explicit counts. |
| Retirements | Retain partial statistics and outcome flags; proposed main factor cohort excludes them pending user approval. Preserve counts for future sensitivity analysis; no Elo treatment selected here. |
| Incomplete/unknown status | Keep abandoned, defaulted, canceled, suspended, unknown and retired distinct where evidence permits. Unknowns cannot silently shrink completeness denominators or become completed matches. |
| Panel coverage | Reconcile 100 expected cells and each edition's official final draw/results inventory with observed matches. Separate byes, walkovers, retirements and played matches. Source row totals alone cannot establish recall. |
| ATP/WTA separation | Tour labels preserved through joins, denominators and reports; no pooled threshold can hide a deficient tour. Cross-tour identity links do not merge analytical cohorts. |
| Season assignment | Derive season from reviewed edition/played-date evidence; flag conflicts, particularly delayed events. Do not trust filename alone. |
| Split isolation | Immutable 2021–2023 development, 2024 validation, 2025 test assignments; no fit/tuning statistics learned from 2025. Coverage inspection is allowed, performance inspection is not. |
| Source-regime change | Compare schema/terms/parser/provenance and field missingness across adjacent seasons and events. Abrupt availability jumps trigger investigation, especially later ITF expansion [R, p. 6]. No automatic pooling across regimes. |

## 12. Recommended provisional coverage threshold

**USER-APPROVED PROVISIONAL THRESHOLD:** At least **95% of eligible matches in each ATP-season and WTA-season** must have all nine counts for both players present, valid, and reconcilable before admitting that tour-season to factor modeling. This follows the flagship criterion in [R, p. 17], but defines a stricter joint bundle than its reported service-point-only audit. Final eligibility policy is not settled; one-event pilot percentages do not test tour-season admission.

Define an independently reconciled official final-draw match universe, excluding byes. Keep every expected match and status in the coverage report. Proposed eligible denominator `N` = completed main-draw singles matches after explicitly approved status rules; use official records to account for missing source rows. Missing/unknown status cannot be excluded without reconciliation. Numerator `C` = matches in `N` satisfying the whole two-player count contract. Admission requires `C/N >= 0.95`, `N > 0`, and no unresolved inventory or identity discrepancies. A file containing only its easiest matches cannot pass by shrinking `N`.

Report the same joint coverage for every event-tour-season and field. **Additional safeguard, approved provisionally for the pilot:** every event cell must reach at least 90% joint completeness, and a wholly absent cell is a hard stop. A tour-season mean must not mask a lost grass tournament. This event safeguard was a new contract recommendation, not a PDF prescription. Both pilot tours clear the numerical floor even after count-review rows leave the numerator; the unresolved WTA anomaly and official inventory prevent claiming full contract admission.

For forecasting, require valid identity, result/status and an approved chronology policy for every admitted match, separately from count coverage. Ranking availability is a distinct baseline gate. Break-point denominators may legitimately be zero even in otherwise complete rows; resulting missing rates do not mean a missing raw count.

If a gate fails, stop the affected modeling cohort and report counts/reasons. Do not lower the threshold, alter the panel, impute zeros, select factors to suit 2025 availability/performance, or drop an event without user review. Neither threshold establishes representativeness; assess missingness by round/player/context later.

## 13. Known risks

- Rights over a mirror, original data, and future derived products may differ. Public access and local MIT licensing are insufficient [S5, S9, S16, S25, S29–S30].
- Exact match chronology is not supplied by the archive's tournament-week date; the proposed date supplement inherits its own source-rights and preview limitations [S3, S16–S18].
- Source documentation is not actual coverage: the PDF's 99.26% cannot substitute for the broader field gate; its point-data and mirror descriptions contain qualifications noted above [R, pp. 2–7, 19].
- Official pages can fail, present unloaded lists, combine historical headers with current content, or disagree internally about draw size [S19–S24, P9]. Calendar versions and actual final draws both matter.
- The fixed elite-event panel may leave sparse grass/player histories and selection bias; broadening rating history or adding a warm-up period is a separate decision [R, pp. 5, 18].
- Explanatory components mechanically share counts with NPR; apparent explanatory power does not prove predictive value. Conversion residuals cannot be read from raw break percentages [R, pp. 10–12].
- Missing source rows, ambiguous statuses and biased statistic availability can invalidate a seemingly high completeness rate. Reconciliation must precede the coverage calculation.

## 14. Unresolved user decisions

| Decision | Recommended disposition; no approval inferred |
| --- | --- |
| U1. Intended noncommercial use and source rights | User approved the pilot as noncommercial educational portfolio research. Source-specific conditions and future derived-publication review remain; user intent cannot override third-party rights. |
| U2. Initial source and pin | User approved and pilot acquired ATP/WTA 2023 annual files at archive revision `83733587353df8a41f2fd4f516147d5aa83f5a8d`. Broader acquisition and MCP/IBM/Live Tennis/OTD remain outside that approval. |
| U3. Analytic population and statuses | Main-draw singles approved for the pilot; retirements retained and walkovers excluded from non-walkover denominators. Final retirement/default/unknown-status and anomaly-quarantine rules remain unsettled. |
| U4. Coverage gates | 95% per tour-season and 90% event-cell floor approved provisionally. Pilot numerical event floors passed; tour-season admission was not tested. Do not silently lower gates. |
| U5. Date evidence and within-day policy | Choose a permissible exact-date source and treatment of same-day/suspended matches before implementing forecasts. Do not approve arbitrary match-number ordering. |
| U6. Historical rating context | Decide whether ratings may use pre-2021 or off-panel history while evaluation remains fixed. No warm-up period or full-tour acquisition is authorized here. |
| U7. Future acquisition structure/dependencies | Pilot paths and base R approved and implemented; R/Rscript 4.6.0 available and used, no packages installed. Further structures/dependencies need authorization. |
| U8. Later statistical decisions | Rolling windows, minimum points, missing-rate handling, factor formulas, opponent adjustment, Elo parameters, retirement updates and resampling remain later review items; no final formulas or methodological replacements here. |

The ten-family panel and split are fixed by existing instructions. Any change still requires explicit user approval. No scheduled acquisition, provider application, website integration, deletion, publishing, deployment or push is authorized.

## 15. Explicit exclusions

The original contract milestone excluded acquisition and code. The later pilot explicitly authorized two 2023 annual downloads, two base-R scripts, local subsets, provenance and audit summaries. All other acquisition remains excluded. No canonical tables, packages, project-environment initialization, Elo, factors, regressions, ratings, forecasts or performance scoring; no 2025 dataset access; no portfolio changes; no publication/deployment; no Git fetch/pull/push/merge/rebase, branch switching or configuration change.

## 16. Recommended next implementation step

The 2023 Indian Wells pilot is complete as an acquisition/audit milestone, with an unresolved WTA count flag and no chronological match dates. Review match 268 and authorize a resolution or quarantine policy while preserving raw bytes. Define independent final-draw reconciliation and retain unknown chronology.

The pilot supports bounded expansion in principle, not automatic approval. A next prompt may explicitly authorize acquisition/auditing of the fixed ten-event 2021–2023 ATP/WTA development sample with named source files, paths and tools. Keep 2024/2025 closed. Settle actual-date and ordering policy before any rating or rolling-statistic implementation; no chronology solution is selected here.

Keep [status.md](status.md) current and require the next Codex task to finish with a written ChatGPT Handoff of approximately 2,000 words, strictly no more than 2,000. Do not send it, invoke a handoff tool, or create another task unless the user separately requests that action.

## 17. Linked sources and retrieval record

All checks below occurred **2026-09-14**. Readable means underlying documentation content was obtained, not data rows or provider claims independently validated. These labels are the source references used above.

- **S1:** [Aneeshers archive overview](https://github.com/Aneeshers/tennis-sackmann-archive) — readable listing/readme.
- **S2:** [Preserved ATP README at proposed revision](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp/UPSTREAM_README.md) — readable.
- **S3:** [Preserved match dictionary at proposed revision](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/atp/matches_data_dictionary.txt) — readable.
- **S4:** [Preserved WTA README at proposed revision](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/wta/UPSTREAM_README.md) — readable.
- **S5:** [Archive license at proposed revision](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/LICENSE) — readable; links full CC legal code.
- **S6:** [Preserved Slam README at proposed revision](https://raw.githubusercontent.com/Aneeshers/tennis-sackmann-archive/83733587353df8a41f2fd4f516147d5aa83f5a8d/slam_pointbypoint/UPSTREAM_README.md) — readable.
- **S7:** [Separate MCP fork and preserved license](https://github.com/hi-im-elson/jeff-sackmann-tennis-match-charting) — readable listing/readme; PDF pin not checked.
- **S8:** [IBM Datapalooza Wimbledon listing and dictionary](https://github.com/ibm-datapalooza/wimbledon-datasets) — readable.
- **S9:** [IBM repository LICENSE via GitHub](https://api.github.com/repos/ibm-datapalooza/wimbledon-datasets/contents/LICENSE) — full text read through connector; [browser file URL](https://github.com/ibm-datapalooza/wimbledon-datasets/blob/master/LICENSE) and raw URL failed in browser retrieval.
- **S10:** [Live Tennis API academic program and conditions](https://livetennisapi.com/data/academic) — readable; [linked Zenodo record](https://zenodo.org/records/22048731) inconsistently retrievable, payload/license not verified.
- **S11:** [tennis-data.co.uk season downloads](https://www.tennis-data.co.uk/alldata.php) — failed; coverage/permissions unresolved.
- **S12:** [tennis-data.co.uk field notes](https://www.tennis-data.co.uk/notes.txt) — failed; not accepted as verified schema.
- **S13:** [TennisData.app downloads and field descriptions](https://tennisdata.app/downloads/) — readable; no download/bot-check interaction.
- **S14:** [TennisData.app terms, updated April 16, 2026](https://tennisdata.app/terms/) — readable; sections 18/20 conflict with broad download invitation.
- **S15:** [Open Tennis Data v3 overview](https://github.com/ryantjx/tennis-match-data) — readable; preview status.
- **S16:** [Open Tennis Data data-specific terms](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA_LICENSE.md) — readable; distinct from MIT code license.
- **S17:** [Open Tennis Data distribution/date contract](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/DATA.md) — readable.
- **S18:** [Open Tennis Data schema](https://raw.githubusercontent.com/ryantjx/tennis-match-data/main/docs/SCHEMA.md) — readable; version 3.3; no aggregate service counts.
- **S19:** [ATP 2025 calendar overview](https://www.atptour.com/en/news/what-is-the-2025-atp-tour-calendar) — 403, not verified from search excerpt.
- **S20:** [ATP 2025 calendar announcement](https://www.atptour.com/en/news/2025-atp-tour-calendar-announced) and [official calendar PDF attempted](https://www.atptour.com/-/media/files/calendar-pdfs/2025/2025-atp-challenger-calendar-as-of-22-december-2024-updated.pdf) — 403.
- **S21:** [ATP Media resources](https://www.atpmedia.tv/resources/) — readable category/reference material; linked ATP calendar failed.
- **S22:** [WTA tour/category explanation](https://www.wtatennis.com/news/3052772/tennis-explained-breaking-down-the-tennis-tour-schedule) — readable; use season-specific evidence for historical mappings.
- **S23:** [WTA 2025 calendar selector](https://www.wtatennis.com/tournaments?year=2025&status=all) — selector readable; list not populated.
- **S24:** [WTA 2025 calendar announcement](https://www.wtatennis.com/news/4009675/wta-announces-2025-hologic-wta-tour-calendar) — readable.
- **S25:** [WTA website terms](https://www.wtatennis.com/terms-and-conditions) — readable; conduct/content restrictions reviewed.
- **S26:** [ITF women's tour](https://www.itftennis.com/en/tours/womens-world-tennis-tour/) — readable current category descriptions, not a historical calendar.
- **S27:** [ITF men's tour](https://www.itftennis.com/en/tours/mens-world-tennis-tour/) — readable pathway/current prize-tier description; incomplete historical category mapping.
- **S28:** [ITF 2024 rule-change summary](https://www.itftennis.com/media/11482/2024-wtt-summary-of-rule-changes.pdf) — category section on page 1 reviewed; summary, not full regulations.
- **S29:** [ITF website terms](https://www.itftennis.com/en/about-us/terms-conditions/) — readable use-of-content provisions.
- **S30:** [Creative Commons BY-NC-SA 4.0 deed](https://creativecommons.org/licenses/by-nc-sa/4.0/) — readable conditions and limits; deed is a summary, not the legal code. The full legal code was not independently reviewed in this milestone.
- **S31:** [Original Sackmann ATP repository](https://github.com/JeffSackmann/tennis_atp) — 404 during retrieval.
- **S32:** [Original Sackmann WTA repository](https://github.com/JeffSackmann/tennis_wta) — 404 during retrieval.
- **S33:** [Original Sackmann Slam repository](https://github.com/JeffSackmann/tennis_slam_pointbypoint) — 404 during retrieval.
- **P1:** [WTA Australian Open 2025 metadata](https://www.wtatennis.com/tournaments/901/australian-open/2025) — readable.
- **P2:** [WTA Wimbledon 2025 metadata](https://www.wtatennis.com/tournaments/904/wimbledon/2025) — readable.
- **P3:** [WTA US Open 2025 metadata](https://www.wtatennis.com/tournaments/905/us-open/2025) — readable.
- **P4:** [WTA Indian Wells 2025 metadata](https://www.wtatennis.com/tournaments/609/indian-wells/2025) — readable.
- **P5:** [WTA Miami 2025 metadata](https://www.wtatennis.com/tournaments/902/miami/2025) — readable.
- **P6:** [WTA Madrid 2025 metadata](https://www.wtatennis.com/tournaments/1038/madrid/2025) — readable.
- **P7:** [WTA Rome 2025 metadata](https://www.wtatennis.com/tournaments/709/rome/2025) — readable.
- **P8:** [WTA Montreal 2025 metadata](https://www.wtatennis.com/tournaments/806/montreal/2025) — readable.
- **P9:** [WTA Cincinnati 2025 metadata](https://www.wtatennis.com/tournaments/1017/cincinnati/2025) — readable; prose/summary draw-size discrepancy retained.
- **P10:** [Tennis Australia 2021 timing announcement](https://ausopen.com/articles/news/australian-open-set-historic-8-february-start) — readable.
- **P11:** [WTA Roland-Garros 2021 postponement](https://www.wtatennis.com/news/2097014/2021-french-open-pushed-back-by-one-week) — readable; [2025 edition overview attempted](https://www.wtatennis.com/tournaments/903/roland-garros/2025) failed.
- **P12:** [WTA Wimbledon 2022 guide](https://www.wtatennis.com/news/2652150/wimbledon-2022-draws-dates-prize-money-and-everything-you-need-to-know) — readable; tour-specific guide, not universal match-format authority.
- **P13:** [WTA 2025 Canada/Cincinnati expansion and US Open schedule](https://www.wtatennis.com/news/4212745/canadian-open-cincinnati-expand-to-96-player-fields-extended-format) — readable.
- **P14:** [WTA revised 2021 fall calendar](https://www.wtatennis.com/news/2198798/wta-announces-2021-fall-calendar) — readable.

## 18. Verification date and maintenance

Verified documentation and retrieval outcomes as of **2026-09-14** only. Recheck terms and mutable documentation before acquisition and publication. A new source version requires a new provenance record; a changed classification requires evidence and review. Nothing in this contract certifies a dataset, licenses third-party content, approves a model, or unlocks 2025 performance evaluation.
