# Local modern point-phase viewer

## Current fan-language definitions

**FAN_LANGUAGE_DEFINITIONS_IMPLEMENTED.** The exact viewer question remains
**“When do tennis players win and lose their points?”** One bounded council used
five independent roles and five fresh reviewers. Reviewers received the same
verified meanings and shuffled Response A–E labels without advisor identities.
The chairman synthesized once, then the wording was implemented in this task;
no new approval or research phase was opened. Council agreement guided phrasing,
not factual verification.

The council agreed on short, standalone tennis-language explanations and distinct
zero, not-reached, unclear and unavailable states. Drafts disagreed on how much
inclusion procedure belonged in the definition. The synthesis removed “eligible
charts” and “inclusion checks” from definitions, keeping those procedures in
Methodology and explaining omitted/excluded points separately. Peer review caught
missing definitions for break points faced versus receiving opportunities,
percentage bases, ending types and final-action labels. It also warned that an
ending with no assigned physical action does not prove that no physical play occurred.

All nine existing popups and the glossary now share matching plain text. The
collapsed glossary has 37 short entries covering stages, recorded/included/omitted
points, match-record exclusions, percentages, dates/categories, break-point
exposure, zero/missing states, ending types and final-action players. Each has
one sentence, or two where accuracy needs it. Representative changes:

| Before | After |
| --- | --- |
| “Points retained after the frozen chart-completion and whole-point notation checks.” | “Recorded points with enough clear information about the full point to use in these charts.” |
| “The receiver’s response to the delivering serve, including a recorded return error.” | “The receiver’s attempt to hit the serve back, including errors.” |
| “The server’s first post-return stroke attempt, including attempted errors.” | “The server’s first attempt to hit the ball after the return, including errors.” |
| “Nonphysical” | “No final-shot player named” |
| “Other supported ending” | “Other recorded ending” |

Visible wording aliases also use “Server’s Serve +1,” “No recorded final shot,”
“Unknown stage,” “Other recorded winner” and “Unknown ending type.” Coverage uses
“Points omitted because details are unclear” and “Points from excluded match
records.” Saved scientific labels and identifiers remain unchanged. Individual
forced/unforced-error definitions describe what the record says; no cause or
responsibility is inferred. Administrative endings name no final shot but do not
deny earlier play. Unreturnable endings receive no inferred error subtype.

A wording correction follows the existing profile code: unknown reach stays
outside the reached-point denominator; an unknown winner among reached points
makes the conditional rate unavailable. The old sentence saying an unknown reach
could make the rate unavailable was misleading. Only its explanation changed;
no calculation, gate or saved value changed. Source authority:
[existing formulas](../R/build_mcp_point_phase_profiles.R) and
[frozen context definitions](modern-point-context-extension.md#frozen-specification).

The style/layout, explanation interaction implementation and selector handlers
are byte-identical to the preceding viewer. Existing hover/focus/tap behavior,
Escape and Tab navigation, glossary targeting and selection preservation remain.
The exact five-file tracked scope is builder/tests, this report and current
context/status; only the ignored HTML is regenerated. No portfolio or historical
release changes occur. **Final checks: 734,163 R and 2,398,028 Node assertions passed.** The full builder
ran twice with byte-identical results. Checks verify every frozen field, both
scientific JSON fingerprints, glossary/popup copy and labels, the 37 entries’
short sentence limits and absence of construction jargon, missing/zero/absence
semantics, error and actor distinctions, all selectable views and preserved
hover/focus/tap, keyboard/glossary and selector behavior in minimal-DOM fixtures.
CSS/layout, explanation interaction code and selector handlers retain their
starting fingerprints. The rebuilt HTML is 51,797,931 bytes, SHA-256
`a7d65eb32f5c0395316f851adf5deea1d8662a5b2411d1789328d779ca7ad7f7`.

Preservation checks passed for 668 historical file/tail fingerprints, all thirteen
modern outputs, the four context outputs and other tracked files. Sixteen current
links/anchors, whitespace, exact five-file scope and ignored-output checks passed.
No unrelated historical test suite ran. The interpretation of “Other recorded
ending” remains limited by the recorded unreturnable marker: no forced/unforced
subtype is inferred. No unresolved wording/evidence conflict requires a method
change; official completion and causal responsibility remain unverified.

**NOT_BROWSER_VERIFIED** remains. Source and minimal-DOM fixtures do not establish
actual browser layout, keyboard/touch or assistive-technology behavior. The
recorded restriction remains binding; no browser workaround is attempted.

## Prior presentation-only refinement

**PRESENTATION_REFINED_WITH_DEFINITION_HELP.** The local viewer asks exactly
**“When do tennis players win and lose their points?”** Its introduction explains
that “when” means the stage of a point and that the ending identifies the final
recorded action, not the shot that caused the result. This is a display change;
the [scientific context extension](modern-point-context-extension.md) retains its
original question, definitions and historical record.

Four sections state their questions and counting rules beside the results:

- **At what stage did points end?** Each included point appears once. Selected-player
  wins/losses divide by all included points in the current selection, or its
  included break points when that subset is selected.
- **How far did points go?** Reaches describe a shared point and overlap. Rows retain
  known absences and unknowns alongside the current-selection denominator.
- **How often did the player win after each stage was reached?** Frozen reached-point
  denominators remain separate for serving and receiving. Receiving views retain
  “Opponent’s Serve +1.”
- **How did points end?** Expandable stage rows retain the recorded type and final
  actor relative to the selected player, counts, phase denominators and point
  wins/losses. No causal credit is assigned.

“All recorded matches,” “Points omitted after notation checks,” “Points from
excluded charts” and player-name wording replace visible internal labels. The
all-points/break-points selection, faced-serving/receiving-opportunity counts,
unknowns, true zeros and unavailable rates remain. All 450 names and 2,972 views
remain embedded; only the exact prior Koepfer selector exclusion persists.

A labeled illustrative reading guide uses 100 hypothetical included points,
with 10 wins and 5 losses ending at Serve. These are teaching numbers, not findings.
No stage is described as a strength. Cream/sand/green/rust, Fraunces and fallback
stacks, common-scale bars and textual/hatched loss distinctions are preserved.
Below the charts, visible **Important limitations** precede initially collapsed
**Definitions** and **Methodology**. Methodology retains all scientific formulas,
qualifications, source/release identifiers and font-license disclosures.

Read-only portfolio references were its NBA project content and
`src/components/DefinitionHelp.astro`. The local adaptation uses native buttons,
one shared explanation panel and existing JavaScript. Underlined terms support
hover with pointer-transit grace, focus and tap pinning. Escape and Close return
focus to the term; “See definitions” opens and focuses its glossary entry, with
an explicit return-to-term control. Outside-pointer dismissal and scroll/resize
placement preserve selectors. CSS constrains the panel to narrow viewports;
synthetic bounds tests are not visual verification. No dependency or integration
was introduced, and the portfolio was not modified.

Both embedded scientific payloads are byte-identical to the starting viewer:
base SHA-256 `123263579bec1b88d2bfab604ea7977cb5ef323add6ca89f5db10b4dc913de34`;
context SHA-256 `f43021f0244b2f1145b48aca803abe6296bd68122a23dcd4ced0164e27c352dd`.
**Final verification: 734,163 R and 2,397,899 Node assertions passed.** Checks cover
input pins, every frozen base/context field, both subsets in every selectable
view, the four section questions, role/type denominators, reset behavior,
unknowns/zeros, safe serialization, fonts, glossary-copy agreement and unique IDs.
Minimal-DOM interaction fixtures exercise hover transit, focus/tap pinning,
Tab/Shift-Tab access, Escape/Close focus return, outside dismissal, glossary entry
and return navigation, synthetic narrow-screen placement and selector preservation.
The full builder ran twice and produced byte-identical HTML.

Integrity checks preserve 668 historical file/tail fingerprints, all thirteen
modern outputs, all four context outputs and every other tracked file against
HEAD. All nine pre-existing methodology paragraphs remain verbatim. Fourteen
current documentation links/anchors, whitespace, the exact five-file scope and
ignored HTML passed. The read-only portfolio status remains unchanged. No
historical analysis suite ran. Only the builder, its tests, this report and current
context/status change; the contract and extension report remain byte-identical.

Development checks exposed a null-focus fixture guard and a duplicate identifier
for the Return glossary entry and return control; both were corrected. One interim
run read a changing test file and ended with a parse error; it is not counted as
successful. The final confirmation ran from unchanged source files and exited
successfully.

**NOT_BROWSER_VERIFIED.** The recorded rejection of local file access also prohibits
server, alternate-browser and automation workarounds. None was attempted. Actual
layout, assistive-technology behavior, touch/keyboard interaction, overflow, fonts,
console/network and load performance remain unverified. Source/minimal-DOM
interaction fixtures do not establish browser behavior.

## Prior score-context and ending extension

**CONTEXT_EXTENSION_EXPOSED — MCP_MODERN_POINT_CONTEXT_1.0.0.** The exact question
remains **“Where do tennis players win and lose their points?”** The
[separately frozen extension](modern-point-context-extension.md) adds pre-point
break-point context and exclusive recorded terminal types. It preserves every
original inclusion, phase, reach and original embedded analytical value.

The Point subset control selects **All included points** or **Break points**.
Subset choice persists through category/player/match changes, while their prior
reset behavior remains. Break-point bars divide by included break points;
zero-opportunity rates remain unavailable. Serving break points faced and
receiving opportunities are separately counted. Coverage retains original
all-point retention, plus included/inventoried known break points, QA-withheld /
completion-excluded break points, unknown score context and ending classifications.
No subset is presented as representative of all points or proven clutch ability.

Each existing ending phase has expandable recorded-type/actor rows: count,
phase denominator, phase percentage and selected-player point wins/losses.
Ace, double fault, other winner, forced/unforced error, administration, other
supported ending and unknown are distinct. Collapsed unreturnable notation is
Other supported ending, not a forced error. Administrative actors are nonphysical;
Serve +1 stays Rally-owned. Only observed type cells are exported; positive
phase denominators make absent types known zeros. Empty subsets have no inferred
profiles. The display reads frozen values and performs no new analysis.

There are 9,953 / 5,619 included men's/women's break points; 848 inventory score
contexts remain unknown, none included. All 174,460 included ending types are
supported. The four new CSV pins are documented in the extension report and
verified before embedding; the original payload hash below remains unchanged.
The new context payload is separate. Current HTML bytes/hash are in the table.

Prior extension checks: **734,163 R + 2,374,014 Node assertions**, covering every base and
extension value, both subsets in every selectable view, reset behavior, zero
opportunities, actor labels, denominators, safe serialization and deterministic
independent generation. These are source/minimal-DOM checks, not actual browser
visual, keyboard or performance verification. No policy workaround was attempted.
The larger standalone file has no measured browser load performance.

## Prior display-only refinement

The sections below retain the preceding display refinement's design and checked
boundaries; the current extension above adds separately frozen results.

**LOCAL_FROZEN_POINT_PHASE_VIEWER_BUILT — PRESENTATION_CLARIFIED.** The exact
project question is **“Where do tennis players win and lose their points?”**
The introduction now reads: “Explore included points from charted matches,
2021–2025. Each ending identifies the final recorded action, not which shot
caused the result.”

Open the ignored [standalone viewer](../data/pilot/mcp-modern-point-phase-viewer-v1.html)
locally. It needs no server, account, installation or internet connection. The
[existing builder](../R/build_mcp_modern_point_phase_viewer.R) and
[focused tests](../R/test_mcp_modern_point_phase_viewer.R) were refined in place.
The builder's explicit `--replace` option permits the authorized atomic replacement
of this generated display; default execution still refuses differing output.
No website integration, publication or portfolio editing occurred.

Controls retain category defaults Adrian Mannarino/Ajla Tomljanovic, exact-name
search, pooled and individual-match views, and category/player reset behavior.
Labels now use “Category,” “Find a player” and “All charted matches.” Category
options say Men’s/Women’s; the underlying identifiers remain unchanged.
Only exact men's-category Dominik Koepfer is hidden from selection: 227 men and
222 women are selectable. All 450 identities and 2,972 profiles remain embedded,
including his 407 excluded points and unavailable rates. Selection counts state
that one name is hidden; no other identity, profile or coverage total is removed.

Flat sections and rules replace rounded panels. The sequence is controls,
compact coverage, point endings, stages reached, serving/receiving rates, then
expandable methodology. Rates sit beside each other on desktop and stack on
narrow screens; no chart stretches to the other chart's height. Years, surfaces
and events are displayed as readable lists without changing saved fields.

## Chart interpretation and numerical preservation

Ending bars are paired horizontal wins/losses on one common 0–100% scale,
labeled “Share of all included points.” Green wins and rust hatched losses also
have explicit text and solid/hatched symbols. Each bar uses its original frozen
share times 100 for display units only. No within-phase normalization, separate
row rescaling or new rate is introduced. Counts and percentages remain visible.
Zero-count Administrative/Unresolved rows move into labeled details, individually;
nonzero residuals remain visible. Neither category is merged or erased.

Beside the ending chart: “The phase names the final action by either player.
Wins and losses belong to the selected player.” Serve wins can include the
selected player's aces or an opponent's double faults. Beside reaches: “One
point can reach several stages; these percentages overlap.” Serve +1 is the
server's first shot attempt after the return, including attempted errors;
methodology preserves exclusive Rally ownership. Receiving rows display
“Opponent’s Serve +1”; the saved phase and role-specific denominators do not change.

Coverage remains beside every profile: included/inventoried charted points,
included percentage, “Points omitted after notation checks,” “Points from
excluded charts,” and match exposure. The visible warning reads **“Missing
notation may change the apparent phase distribution.”** The included percentage
does not measure career or complete tournament coverage. Conditional rows use
“Point win rate when serving/receiving” and “points reaching this stage.”
Unknown opportunity counts remain explicit. Positive percentages below 0.1%
display `<0.1%`; true zero is `0.0%`, and unavailable remains `Unavailable`.
Bar lengths still use the exact frozen share, not the formatted label.

## Portfolio reference and font boundary

Read-only references were the portfolio's `src/styles/global.css`, font
configuration in `astro.config.mjs`, and local font assets. Reused tokens:
cream `#f2e9ce`, sand `#d0be9e`, dark green `#14532d`, rust `#9c3d1e`.
Numbers use a tabular monospace stack. Typography follows Fraunces headings,
Source Serif 4 body and IBM Plex Mono numbers, with this explicit limitation:

- The saved Fraunces asset is embedded unchanged as a data URL. Its saved SIL
  Open Font License explicitly permits embedding; full copyright/license text
  accompanies it in technical methodology. Font SHA-256:
  `94bb7e04bb1a32237a67935c72526e42a3e52ee4aebd50299802b18a93114251`.
  Saved `OFL.txt` SHA-256:
  `bdf4c22802eaf804f998195871c6b8938aac2ac14b2d78a8bd66a6f1eced833b`.
- Source Serif 4 and IBM Plex Mono cached assets exist, but their licensing
  evidence was not verified in the saved files. They are not embedded. CSS
  requests these family names if installed, otherwise Georgia/system monospace.
  Their actual rendering is unverified; full typography parity is not claimed.

The builder verifies both Fraunces fingerprints before embedding. No font
acquisition or dependency was added. The palette reference SHA-256 is
`2b2ffff069f335340fab0f126e33491bf42cd3465fc04a1ab3f0d05ea213fc27`.
The portfolio's pre-existing unrelated changes were preserved.

## Frozen input and generated output fingerprints

Source revision: `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`.
Inputs remain pinned to the [frozen modern report](modern-point-phase-profiles.md#verification-and-preserved-release).

| File under `data/pilot/` | Bytes | SHA-256 |
| --- | ---: | --- |
| `mcp-modern-point-phase-v1-match-player-profiles.csv` | 32,508,915 | `6a8a921d3c1d68d060ad3032b4192b56a730ab41a6bd5d3f40f566bd88076fae` |
| `mcp-modern-point-phase-v1-coverage.csv` | 904,673 | `005df41adc7965f485192b8787ee87171695850b1477bf701f108bde00c1e53d` |
| `mcp-modern-point-phase-viewer-v1.html` | 51,797,931 | `a7d65eb32f5c0395316f851adf5deea1d8662a5b2411d1789328d779ca7ad7f7` |

The preceding presentation-only viewer was 51,788,517 bytes, SHA-256
`cf094588b1e216d9824c75cc47dbaf44647926b58dc5bbf4610d7d959c462995`.
Before that refinement the extension viewer was 51,773,662 bytes, SHA-256
`ad3696d029f936ced2fe82f2c0c0beb84779aaf5d2c5e954deff92a35c0a7462`.

The embedded analytical payload is byte-identical to the previous viewer:
SHA-256 `123263579bec1b88d2bfab604ea7977cb5ef323add6ca89f5db10b4dc913de34`.
All 44,580 profile rows and 1,263 MATCH/CATEGORY coverage records remain.
At the prior refinement, only display code, styling and the licensed font resource changed.
The current extension adds a separate payload without changing these original values.
Prior HTML fingerprint (15,768,447 bytes):
`12bcb90ff2e70b51cc512c1477a1c122a72c4dd00d88523680f92b147e9f70d5`.

## Prior checks and continuing visual boundary

**734,163 R and 749,873 Node (1,484,036 total) checks passed.** Affected R and Node fixture checks verify
pins, every frozen field, denominator/coverage accounting, payload identity,
category/player resets, exact selector exclusion, role labels, common-scale
bars, residual categories, null/zero/small-positive formatting, safe encoding,
embedded font identity/license, request-free code and deterministic generation.
One initial fixture check failed because its injection test left a temporary
name mutation; the fixture was restored in the correction batch. The confirmation
pass includes one byte-identical independent rebuild. No scientific code changed in that prior display refinement.

Historical fingerprint/tail checks, all thirteen frozen modern-output hashes,
links/anchors, whitespace, exact five-file scope and ignored HTML were checked.
The data-source contract was unchanged at that prior refinement; its current head
now records the context extension. Historical scientific releases remain unchanged.
No unrelated historical suite ran.

**NOT_BROWSER_VERIFIED remains.** The prior browser-tool rejection of local file
URLs explicitly prohibited a server, alternate browser or automation workaround.
That restriction was respected; it was not retried or bypassed. No new viewer
screenshots, actual browser-control/keyboard checks, desktop/375px overflow or
chart readability inspection, font-rendering check, or browser-console/network
check occurred. Source/DOM-fixture checks do not establish browser behavior.

## Limits and one next step

Expandable methodology retains formulas, source/release identifiers, historical
category qualifications and uncertainty limits, with plain-language explanations
of technical statuses. This is included-point descriptive accounting, not fair
rankings, causal responsibility, transferable skill, independent factors or
complete tournament coverage. Unknowns are not success/failure/absence.
UNCERTAINTY_NOT_ESTABLISHED and exposed-year/source-date limitations persist.

**Next step:** review revised user-provided desktop and 375px screenshots of this
same viewer, with both categories, All recorded matches / individual matches,
both point selections, ending-type details, term explanations and the rate sections.
Please provide those screenshots; keyboard behavior and console/network checks
require user observations or a policy-permitted browser surface. Limit any later
correction to display defects. No new analysis or website integration is proposed.
