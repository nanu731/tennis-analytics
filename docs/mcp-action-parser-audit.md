# MCP action parser audit — Stage 2

**Result: `MCP_SAMPLE_ACTION_PARSER_AUDITED_WITH_UNSUPPORTED_NOTATION`.**
Release `MCP_STAGE2_1.0.0`, 2026-10-08. Baseline:
`ceaff79409e0904dad542870bce85de8679d1b7e`.
The [parser](../R/parse_mcp_actions.R) implements the
[Stage 1 ownership proposal](action-factor-definition-and-coverage.md) on its
unchanged 44-match sample. It parses and reconciles recorded events; it estimates
no action value and validates no factor's construct, independence or usefulness.

## Inputs and authority

Only MCP revision `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf` and the frozen
Stage 1 sample are used. The existing source-verification helpers recheck the
manifest, saved tree, rights basis, eleven file sizes, Git blobs and SHA-256
hashes. All five Stage 1 outputs are independently pinned in the new parser;
sample SHA-256 remains
`dffb33696c7b758be526fb180ed2f79ed527ea2b4ac4f962e89e139d6d08aa88`.
No acquisition or substitution occurred. Loading the six CSV shards to extract
the sample does not parse the remaining population.

Notation authority is the pinned `MatchChart 0.3.2.xlsm` **Instructions** sheet:
A32–36 first/second fields; A46–87 serves/faults/lets/terminal serves;
A91–168 stroke/error codes; A170–200 return depth and optional modifiers;
A202–222 missing points, penalties and challenges. Match-format rules are in
A9–16. The dictionary supplies source player/score conventions. Local research
remains under the saved CC BY-NC-SA 4.0 basis; neither public release nor
redistribution follows. Raw/contributor metadata and all previous releases stay
unchanged.

## Implemented parsing and ownership

A left-to-right scanner consumes each raw field. Token spans recover its exact
bytes, including unsupported suffixes; no trimming, spelling repair or notation
substitution occurs. Each ledger row retains match/point/source-row identifiers,
first/second field, raw token, actor, neutral player slot, raw fields and Notes.
Action IDs are unique. Partial prefixes are retained but flagged; they do not
become validated full sequences.

- **Serve:** recorded first and second attempts/faults belong to the server.
  Fault codes are `n/w/d/x/g/e/!`; `e` retains unknown fault type. A first fault
  requires a second field; two faults terminate as double fault. A terminal
  serve `*` is an ace and `#` is a collapsed unreturnable. No return stroke is
  invented for that collapse.
- **Return:** the first recorded post-serve shot belongs to the receiver,
  including its attempted error. Return winners and forced/unforced errors
  terminate before +1.
- **Rally:** later recorded strokes alternate players. The server's first
  post-return attempt has in-play ordinal three and is +1, including an error.
  Faults and void lets do not advance that ordinal.
- **Void/admin/missing:** leading `c` letters are recorded lets, retained as void
  Serve events. They do not create another point or +1 action. `V` means loss of
  the first serve, represented administratively rather than as a physical serve.
  `P/Q` are administrative point penalties; `R/S` retain known point outcome
  with unobserved action sequences. Incorrect challenge `C` is recognized and
  retained, but the instructions do not establish its actor from the last shot
  alone: actor/outcome attribution stays unresolved.

All eighteen documented shot codes are supported: groundstrokes, slices,
volleys, overheads, drops, lobs, half-volleys, swinging volleys, trick shots and
unknown type `q`. The scanner retains approach `+`, position `-/=`, net cord `;`
and volley modifier `^`. Serve-and-volley remains a Serve annotation; the later
volley is Rally/+1. A semicolon may annotate any shot, including a fault/error;
other placement extensions are not silently accepted.

Optional directions/depth can be unrecorded. Source `0`, `q` and `e` remain
explicit unknowns; a lone return zero cannot establish whether direction or
optional depth was unknown, so both remain ambiguous. Depth 7/8/9 is interpreted
only on returns under this pinned specification. Direction codes are never
coordinates or movement measurements. `^` on a half-volley, extra rally digits,
late approach modifiers and inconsistent fields are flagged rather than assigned
an unsupported meaning. A forced error can omit its error subtype; an unforced
error cannot under the pinned instructions.

Each point has one disposition. A normal tennis sequence is validated here only
when syntax, first/second-field composition and its independently decoded terminal
winner agree with the recorded winner. Explicitly unknown optional fields may
remain in a structurally reconciled sequence. This establishes recorded action
accounting, not complete information for future value estimation.

## Measured results

| Point disposition | ATP-file sample | WTA-file sample | Total |
| --- | ---: | ---: | ---: |
| Sample matches / points | 20 / 4,092 | 24 / 3,241 | 44 / 7,333 |
| Parsed normal tennis sequence | 3,558 | 2,676 | 6,234 |
| Parsed with explicit unknown fields | 7 | 3 | 10 |
| Outcome-only, actions unobserved | 53 | 28 | 81 |
| Unsupported or unresolved sequence | 474 | 534 | 1,008 |
| Separate administrative point | 0 | 0 | 0 |
| Decoded/recorded terminal conflict | 0 | 0 | 0 |

Thus **6,244 normal tennis sequences** reconcile fully under the supported
notation. Only 12 charts (five ATP, seven WTA) have every point in that category;
all 44 remain in the inventory and sample. No chart or point was excluded to
improve these counts. Across every disposition, 7,225 decoded outcome labels
agree with the source, including 81 outcome-only labels and 900 partially parsed
sequences. The other 108 terminal outcomes remain unresolved. Agreement on a
partial sequence does not turn it into a successful parse.

The ledger contains **38,593 rows**, including 279 recorded void lets, 81 missing
observation placeholders, nine administrative rows and 108 unsupported suffix
rows. It records 9,908 candidate serve attempts, 6,488 return actions and 21,720
rally actions across valid and flagged prefixes. These are not analytical rates;
31,158 ledger rows belong to validated normal tennis points. Optional unrecorded
lets cannot be recovered from these counts.

First-fault candidates total 2,658; double-fault candidates 293. Of these, 2,330
first faults and 291 double faults occur on validated points. Six `V` occurrences
include one invalid second-field placement; four are on validated points.
Unsupported records retain their independently applicable failures.

## Serve +1 reconciliation

| +1 disposition | ATP | WTA | Total |
| --- | ---: | ---: | ---: |
| Observed attempt prefix, all dispositions | 2,650 | 2,319 | 4,969 |
| Validated attempt | 2,182 | 1,806 | 3,988 |
| Validated attempted error | 369 | 356 | 725 |
| Known absence before +1 | 1,383 | 873 | 2,256 |
| Unknown observation/opportunity | 59 | 49 | 108 |

Observed prefixes + known absence + unknown = all **7,333 service points**.
Validated attempts + known absence = the **6,244 validated tennis sequences**.
The remaining 981 observed prefixes are unvalidated because their point carries
unsupported notation. Two validated +1 actions have unknown shot type `q`;
the attempt/owner is known, its type is not.

Known absence comprises 413 aces, 54 unreturnables, 291 double faults, 137 return
winners, 1,044 forced return errors and 317 unforced return errors. Among validated
+1 attempts, 218 end in forced error, 507 in unforced error, 297 in a winner and
2,966 continue to later strokes. No eventual point-win rate or isolated +1 value
was calculated. Attempt counts come from the explicit error-inclusive sequence,
never `rallyCount`. Known absence is distinct from missing observation; there is
no imputation or opportunity-rate calculation.

## Independent reconciliation

Sample point totals independently match all 44 Stage 1 inventory totals. Every
first/second raw field is recoverable from the ordered token spans. Source
server/receiver membership, actor alternation and neutral slots reconcile on
owned actions; unknown/admin placeholders are kept separate.

A second implementation replays recorded `PtWinner` values from an initial zero
score, without using decoded terminal tokens. It reconstructs traditional point
scores, games, sets, normal/tiebreak service rotation and game numbers under the
source's documented match-format labels. **All 7,333 pre-point score/server
states pass; all 44 chart terminal states reconcile**, totaling 1,164 completed
games and ten tiebreaks. Observed format labels are 0, 1, A, S and T. The S chart
ends in straight sets and does not exercise a deciding super-tiebreak. Unsupported
formats fail explicitly; score assumptions do not establish real match timing.

A completed reconstructed chart is not independent official match completion,
proof of normal status or analytical admission. Crowdsourced sequences can omit
information while maintaining a correct scoreboard, as the 81 unobserved points
show. Historical availability and movement attribution remain unverified.

## Representative decoding and failures

The example CSV preserves sample IDs, actual notation and parse status. Normative
examples below are grounded in the pinned instructions and tested separately:

| Raw first / second field | Decoded ownership and result |
| --- | --- |
| `6n` / `4f27b1*` | First Serve fault; second Serve; Return forehand; Rally/server +1 backhand winner |
| `4n` / `5d` | Two Serve faults; double fault; no Return or +1 |
| `cc4e` / `4f1*` | Two void lets; unknown-type first fault; second Serve; Return winner |
| `6*` or `6#` | Serve ace or collapsed unreturnable; no +1 |
| `6f#` or `6f2d@` | Recorded attempted Return error; no +1 |
| `4+b27v1*` | Serve-and-volley annotation; Return; Rally/server +1 volley winner |
| `4b28o2n@` | Return; attempted Rally/server +1 overhead error is counted |
| `S` | Point outcome known; Serve/Return/Rally observations unknown |
| `6b29C` | Serve and Return prefix; incorrect-challenge actor/outcome unresolved |

Failure counts below overlap: a point can carry several reasons. They do not sum
to the 1,008 unique unsupported/unresolved points.

| Failure reason | ATP points | WTA points |
| --- | ---: | ---: |
| CHALLENGE_ACTOR_AND_OUTCOME_UNRESOLVED | 0 | 3 |
| DROP_VOLLEY_MODIFIER_ON_OTHER_SHOT | 7 | 2 |
| DUPLICATE_SHOT_MODIFIER | 1 | 0 |
| ERROR_WITHOUT_TERMINAL_MARKER | 10 | 22 |
| FORFEIT_NOT_FIRST_SERVE | 0 | 1 |
| INVALID_RALLY_DIGITS | 452 | 494 |
| INVALID_RETURN_DIGITS | 2 | 5 |
| MISSING_POINT_TERMINAL | 51 | 52 |
| MISSING_SECOND_SERVE | 0 | 1 |
| SECOND_SERVE_WITHOUT_FIRST_FAULT_OR_FORFEIT | 0 | 2 |
| SPECIAL_CODE_IN_SECOND_FIELD | 0 | 1 |
| TRAILING_SERVE_TERMINAL_OR_FAULT | 2 | 2 |
| UNFORCED_ERROR_WITHOUT_ERROR_TYPE | 4 | 1 |
| UNSUPPORTED_SERVE_START | 0 | 2 |
| UNSUPPORTED_SHOT_CODE | 51 | 51 |

The dominant issue is extra numeric annotation on later strokes: **946 points**
across eleven matches, with 873 having that as their sole failure. For example,
`4b38b19*` includes a second digit on server +1. Treating that digit as rally depth
would extend the pinned return-only definition. Other examples include `h^`,
`f19+`, `s!2n#`, an error without a documented serve direction, malformed return
numbers and two trailing-space first-fault strings. These are observed notation
incompatibilities or ambiguities, not demonstrated causes or verified source
errors. No raw normalization or admission repair was applied.

## Outputs and validation

Exactly six ignored CSVs use existing `data/pilot/mcp-stage2-` locations:
`actions`, `point-reconciliation`, `match-reconciliation`, `reason-summary`,
`decoded-examples`, `summary`. Release/exposure/claim labels identify them as a
sample parser audit, not validated factors or analytical admissions. Installation
stages all files, refuses differing existing outputs and renames per file, with
summary last; it is not a multi-file transaction.

[Focused tests](../R/test_mcp_actions.R) passed **242 checks**: pinned notation
examples, all shot/fault families, lets, error-inclusive +1 counts, void/admin and
unknown cases, unsupported suffix preservation, player relabeling, independent
score fixtures, all-sample accounting, exact byte-span retention, row permutation,
ignored scope and an independent full rerun. All six outputs were byte-identical;
rejected installation left them intact. **466 historical files** were unchanged,
including Stage 1 code, manifest, raw inputs, frozen sample and all outputs.
Historical suites were not rerun. No dependency or directory was added.

During local implementation, score-result columns needed explicit initialization
before assignment by match; that defect was corrected before release. Net-cord
handling was completed against the pinned instruction permitting annotation on
any shot. These fixes changed no source bytes, sample or scientific interpretation.

## One next executable step and concrete approval

Before using these ledgers for candidate estimation, resolve notation authority
for the observed extensions. Recommend a **bounded sample-only notation
compatibility audit and parser extension**, not a population parse or fit. The
current task's pinned-input boundary prevented consulting newer documentation;
unsupported meanings remain unassigned.

Requested approval language: “Consult upstream charting documentation to verify the additional
rally digits and modifier variants observed in the frozen 44-match sample.
Extend the sample parser only where meanings are independently documented;
preserve raw inputs, sample selection and unresolved cases. Acquire no match
or point data and perform no factor estimation, weighting, ratings or scoring.”

This is the concrete source-authority decision needed next. Evaluation-plan and
untouched-sample decisions still precede fitting; all acquired years, including
2026, are exposed. No final-test period was selected. Movement and
`UNCERTAINTY_NOT_ESTABLISHED` remain unresolved.
