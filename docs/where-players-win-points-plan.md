# Where Players Win Points: descriptive prototype

## Adopted contract before calculation

Adopted 2026-10-10 from clean baseline
`c3aa9be2c3766507771718fc3488b20a7286ec92`. This is descriptive accounting on
frozen `MCP_EXPANDED_RECURRING_1.0.0`, not factors, skill, causal attribution,
forecasting or point value. All 223 charts remain inventoried. Reuse the
[expanded completion/QA release](mcp-expanded-recurring-player-audit.md),
[observable-state boundaries](mcp-action-state-audit.md) and pinned helpers.
No parser interpretation or eligibility changes. No source acquisition.

Use a unique source match/point ID, retaining raw source provenance. Resolve
server, receiver, actor and winner with the frozen reconciled identity mappings
and neutral A/B slots. No new name ordering or winner-based orientation.
Completion-eligible and fully point-QA-valid means frozen completion eligible,
`tennis_sequence_validated` and score reconciliation `PASS`. Excluded and
QA-withheld points never become measured losses or known absent attempts.

Each included point receives one exclusive ending:

| Presentation phase | Required supported terminal event |
| --- | --- |
| Serve | Physical server-owned Serve / second-fault event; includes collapsed UNRETURNABLE notation without inventing a Return stroke. |
| Return | Physical receiver's first response. |
| Server Serve +1 | Physical server's first post-return stroke, including attempted errors; remains exclusively Rally-owned. |
| Later Rally | Other supported terminal Rally stroke, after +1. |
| Administrative | Supported nonphysical terminal event, such as incorrect challenge or point penalty. |
| Unresolved | Insufficient/conflicting terminal boundary or identity evidence; preserve residual in the QA-valid denominator and mark rates unavailable where winner evidence is insufficient. |

First faults, void lets and first-serve forfeits do not automatically end points.
Identify attempts from action boundaries and the frozen +1 ledger, never
`rallyCount`. Administrative endings do not create strokes and do not erase
supported earlier attempts. Return reach denotes a separately recorded supported
physical Return attempt; it is not every possible receiver response. Collapsed
UNRETURNABLE has no separately charted Return and preserves the parser's absence
disposition, without asserting that the receiver never moved or touched a ball.

For each player, keep three distinct measures:

1. **Point endings:** terminal-phase wins and losses / all included points
   involving that player. Six categories exhaust that denominator, including
   explicit Unresolved residuals. Unavailable winners remain separately counted.
2. **Reach:** at most one Return, server +1 and later-Rally reach per point.
   These point-level exposures overlap and apply to both player perspectives;
   they do not mean that both players executed each action. Record known reached,
   known absent and unknown. Divide by the same all-included-player-point
   denominator. Role-specific breakdowns retain this denominator and expose the
   role's included-point count separately.
3. **Conditional win:** known player wins / points known to reach that phase,
   separately for SERVER and RECEIVER perspectives. Unknown reach stays outside
   the reached denominator but remains visible. Unknown winner makes the
   conditional rate unavailable rather than silently reducing its denominator.

Whole-point QA withholds unresolved prefixes from reach success/absence.
For included points, use frozen Return/+1 dispositions and supported physical
boundaries; absence requires complete supported evidence, otherwise unknown.
A later-Rally attempt is a supported Rally stroke other than server +1, including
errors. Empty denominators remain undefined, never zero-rate substitutes.
Preserve raw terminal labels, event ownership and exclusion reasons in the ledger.

Pool compatible counts before division for match/player and category/player
profiles; never average match percentages. Keep historical men's/women's
categories separate, without claiming certified ATP/WTA populations. Include all
players/opponents and excluded/zero-usable matches. No rankings or fair-comparison
claim: matches, periods, opponents and QA retention are unequal.

Select plot demonstrations from eligibility and neutral match-ID order only:
first completion-eligible chart in each historical category. Freeze those IDs
before reading point outcomes or retention, use both charts in both plots and
never replace poor coverage. Display all categories, unknowns, zero denominators
and inventory/QA coverage. Show terminal wins/losses separately and distinguish
shared reach from role-specific conditional wins.

## Bounded council decision

Question: “Which supported phase definitions and denominators provide an honest
descriptive point-phase prototype from these frozen ledgers?”

Five independent role analyses (Contrarian, First Principles, Expansionist,
Outsider, Executor; at most 150 words each) and five label-anonymized reviews
(at most 120 words each) were completed using read-only agents. Three agents
were reused within the concurrency limit; they may recognize earlier wording,
so strict identity anonymity is not claimed. No advisor received another
advisor's initial response. Reviews used anonymous condensed responses.

**Agreement:** exclusive terminal categories; +1 is an error-inclusive Rally
subtype; common all-QA point denominator for endings/reach; overlapping reaches;
conditional reached denominator by role; explicit unknowns and coverage.
**Emphasis differences:** table traceability versus presentation clarity, not
competing definitions. **Review blind spots:** distinguish attempted strokes
from possible opportunities; collapsed Serve terminals do not manufacture a
Return; nonphysical endings require independent prior-reach evidence; a player
can win a phase-ending point without owning its terminal action.
**Chair synthesis:** adopt the contract above, with full-inventory coverage and
source-linked evidence first. Agreement is advice, not factual verification.
The council cannot change frozen rules or establish validated factors.

## Roadmap and release boundary

Implement one source-pinned R builder and focused tests. Write only five ignored
flat outputs under `data/pilot/mcp-point-phase-v1-`: point-dispositions.csv,
match-player-profiles.csv, coverage.csv, point-ending-prototype.svg and
opportunity-prototype.svg. The profile CSV contains both MATCH_PLAYER and
POOLED_PLAYER aggregation levels; coverage contains match and category totals.
Retain source IDs and phase authority; no new sample, dependency or directories.
Validate unique assignments, winners, ownership, counts/denominators, unknowns,
slot swaps, permutations, deterministic reruns and preserved historical bytes.
Inspect both rendered plots and report measured findings below. Stop after this
release and commit; further analysis needs separate approval.

## Measured prototype

**DESCRIPTIVE_POINT_PHASE_PROTOTYPE_BUILT — MCP_POINT_PHASE_PROFILES_1.0.0.**
The implemented contract supports point-ending and opportunity descriptions;
it establishes no factor validity, skill, transfer or causal value.

### Inventory and coverage

| Historical category | Charts (eligible / excluded) | Inventory points | Included points | Completion-excluded points | QA-withheld points | Included / inventory |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Men's | 106 (104 / 2) | 26,318 | 22,910 | 416 | 2,992 | 87.05% |
| Women's | 117 (116 / 1) | 16,992 | 13,637 | 163 | 3,192 | 80.26% |
| Total inventory | 223 (220 / 3) | 43,310 | 36,547 | 579 | 6,184 | 84.38% |

Every inventory point has one disposition and two neutral player perspectives.
Included winners reconcile exactly; no included terminal category is unresolved.
This does **not** validate the excluded/withheld points. All 220 eligible charts
have some included points. Eligible-chart retention ranges from **23.91–100%**
in the men's category and **18.80–100%** in the women's category. Whole-point QA
is stricter than retaining individual transitions, so these are not the prior
transition-coverage percentages.

### Exclusive endings and overlapping reach

Counts below are unique included points, not doubled player-perspective totals.
Each category's six endings sum exactly to its included-point denominator.

| Terminal phase | Men's points | Women's points |
| --- | ---: | ---: |
| Serve | 3,174 | 1,626 |
| Return | 5,255 | 3,463 |
| Server Serve +1 (Rally-owned) | 3,831 | 2,375 |
| Later Rally | 10,647 | 6,166 |
| Administrative | 3 | 7 |
| Unresolved | 0 | 0 |

Later Rally accounts for 46.47% and 45.22% of included men's/women's points.
That is an ending distribution, not value or credit assigned to a stroke/player.
A player may win an ending through the opponent's error.

| Shared point reach | Men's reached / absent / unknown | Women's reached / absent / unknown |
| --- | ---: | ---: |
| Return | 19,736 / 3,174 / 0 | 12,010 / 1,626 / 1 |
| Server Serve +1 | 14,479 / 8,431 / 0 | 8,544 / 5,093 / 0 |
| Later Rally | 10,648 / 12,262 / 0 | 6,168 / 7,469 / 0 |

Reaches overlap; they must not be summed as an exclusive partition. +1 attempts
include **2,402 men's and 1,749 women's attempted errors**. Independent frozen
ledger/event reconstruction reconciles these counts after completion/point QA.
Later-Rally reach exceeds Later-Rally endings by one men's and two women's
points: supported strokes can precede a nonphysical ending.
The single unknown Return reach is point 34 of
`20130117-W-Australian_Open-R32-Jelena_Jankovic-Ana_Ivanovic`, with a supported
incorrect-challenge terminal. It remains unknown rather than invented absence.
Eighty-eight included points retain explicit annotation unknowns (61 men's,
27 women's); valid phase boundaries do not certify every recorded attribute.

The profile file contains **9,480 rows**: 446 match/player groups and 186 pooled
category/player groups (89 men's, 97 women's), each with 15 measure rows.
Counts are pooled before division. Inventory exposure varies from 1–10 matches
and 1–9 opponents per men's identity, and 1–14 matches and 1–12 opponents per
women's identity. Included matches may be zero for an excluded-only identity.
Source-date inventories span 1960-07-04–2026-01-23 and
1993-07-02–2026-07-02 respectively. These unequal eras, opponents, exposures
and QA proportions prohibit rankings or claims of fair comparisons.

### Plot inspection

Both SVGs use these identity-selected, completion-eligible demonstrations:

- `19600704-M-Wimbledon-F-Rod_Laver-Neale_Fraser`: 241/288 included points
  (83.7%), 47 QA-withheld, zero completion-excluded.
- `19930702-W-Wimbledon-SF-Conchita_Martinez-Steffi_Graf`: 125/127 included
  points (98.4%), two QA-withheld, zero completion-excluded.

[Point-ending prototype](../data/pilot/mcp-point-phase-v1-point-ending-prototype.svg)
shows six exclusive phases, win/loss counts and all-QA denominator shares.
[Opportunity prototype](../data/pilot/mcp-point-phase-v1-opportunity-prototype.svg)
separates overlapping shared reach from serving/receiving conditional win rates,
with reached denominators, absences and unknowns. These are the same charts,
not high-retention replacements. Zero-denominator output/plot handling is
explicitly tested, though the selected charts have positive reach denominators.
Both final SVGs were rendered and visually inspected in full; labels, coverage,
counts, axes and all four player perspectives are visible.

### Provenance, validation and implementation disclosures

No source or historical pipeline was regenerated. The builder reuses the saved
rights/provenance and revision verification and literal expanded-release pins
from `plus_protocol_verify()`, then reads frozen tables only. MCP revision:
`1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`. All three CSVs carry a fingerprint
of the prospective contract above, frozen release identity and claim boundaries.

Focused validation: **7,049** checks, including source pins,
unique point/terminal and player ownership, independent event/winner and +1
reconstruction, every match/player and pooled denominator, unknown/zero cases,
neutral swaps, row permutations, independently byte-identical five-file reruns,
ignored scope and refusing a differing installed release without mutation.
Additional **727** checks verify local links, six-file scope, current-document agreement,
whitespace and baseline preservation of **657 historical files and three
historical document tails**. Historical test suites were not rerun or repinned.

One test found an order-dependent audit label on a withheld multi-terminal
point. Sorting candidate terminal IDs makes that label deterministic without
changing inclusion, measured endings, parser rules or historical evidence.
The initial Cairo SVG attempt failed because system libraries were unavailable;
already-installed `svglite` provides the final deterministic SVGs. Existing
bundled `sharp` rendered them for inspection. No dependency was added. A failed
renderer's disposable `Rplots.pdf` was removed; no historical work was deleted.

| Ignored output | SHA-256 |
| --- | --- |
| point-dispositions.csv | `3379b2233470cd3ac3875b56e991eaaf22f5c993d98c0d5d26dd247a2100f650` |
| match-player-profiles.csv | `a9e5cee02a3cbd0008eac64b01d9d493e50a0880afa310ecf9dadaabbfadbe1e` |
| coverage.csv | `b78a1d59ba607b7d679dcc7c0ede1eb5dd451d200ed0f492ae5fae77c7d7c015` |
| point-ending-prototype.svg | `7c075d010fac70b7ced8650028218b0f724fdfc3b9dffb1d339701893afce038` |
| opportunity-prototype.svg | `fd1e6596546bc70f9555bc7339230a9fb096a47adeb3933e9c68b909bf280b64` |

### Limits and one proposed next step

The prototype describes QA-selected chart observations, not official completion
or certified ATP/WTA populations. All acquired years, including 2026, are
exposed; source dates do not verify historical availability.
UNCERTAINTY_NOT_ESTABLISHED remains. Exclusive terminal partitions and action
ownership cannot establish independent mechanisms, attribution, NPR explanatory
value, stable transfer or factor qualification. Prior negative/mixed findings
and tracking-access limitations remain intact. The unsent TDI draft stays unsent.
No acquisition, model, rating, weight, publication or portfolio change occurred.

**Recommendation, not implemented:** build one local, read-only profile viewer
from these frozen CSVs so a user can select a player/match and inspect the
ending/reach/conditional measures together with periods, opponents and retention.
It introduces no measurement or scientific claim and does not launch another
research diagnostic. Exact next approval:

> Build one local, read-only Where Players Win Points viewer from
> MCP_POINT_PHASE_PROFILES_1.0.0, preserving the definitions, eligibility and
> historical categories. Show match and pooled profiles, role-specific
> conditional rates, unknowns and full coverage context. Add no ranking, new
> statistic, model, dependency, acquisition, publication or portfolio change.
