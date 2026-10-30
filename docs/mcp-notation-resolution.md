# MCP sample notation resolution

Completed 2026-10-08 from `91bbd10749b486f0388dd261a12422abf7eaef54`.
Terminal result: **MCP_SAMPLE_NOTATION_PARTIALLY_RESOLVED_WITH_AUTHORITY_CONFLICTS**.
This is parser verification on the frozen 44-match sample, not factor validation,
analytical admission or population parsing. No new match or point data was acquired.

## Evidence and applicability

The [evidence manifest](../data/manifests/mcp-notation-evidence.csv) records URLs,
retrieval UTC time, publisher/version, byte size and SHA-256 for four documentation
snapshots in existing ignored `data/raw/reference/mcp-notation-` locations. The
parser verifies the manifest fingerprint and every evidence file before processing.
The original MCP revision remains `1813a1309b7ed7ebf1c7e884b32bf675d00e4edf`;
all eleven original source pins and the sample fingerprint remain unchanged.

| Evidence | Upstream authority / version | SHA-256 |
| --- | --- | --- |
| E01 | [Jeff Sackmann quick-start guide](https://www.tennisabstract.com/blog/2015/09/23/the-match-charting-project-quick-start-guide/), published 2015-09-23; retrieved HTML snapshot | `d3de3dd414f2ce231bb2fc7f2a48d72ad005bc4fb5e5c707d8be06963c6e5d68` |
| E02 | [Sackmann rally-depth explanation](https://www.tennisabstract.com/blog/2025/04/11/lessons-from-a-48-shot-rally/), published 2025-04-11; retrieved HTML snapshot | `14fc56ba85737ad41705b4688031865a2ee7ebd53231a74330c98dd116179562` |
| E03 | [Official MatchChart workbook](https://www.tennisabstract.com/charting/template/MatchChart%200.3.2.xlsm), 0.3.2; changelog 2019-01-15 | `46e2349eee512296a86170449f6e463a6be91be9261a0c7b6b5d5a25c006729f` |
| E04 | [Maintainer comment 265687286](https://github.com/JeffSackmann/tennis_MatchChartingProject/issues/5#issuecomment-265687286), JeffSackmann, created/updated 2016-12-08; saved GitHub comments response | `c39c7423ec81a2e2a86ef566766310a48577d839a4a4c18cfc789e79763c7cfb` |

E03 is byte-identical to the already pinned workbook, so its instructions and
formulas apply directly to this snapshot. E01 is an older return-depth guide;
E02 is later evidence of rally-depth collection, not a numeric-code specification.
Neither establishes the introduction date, contributor convention or exact digit
syntax for the observed later-stroke annotations. Match dates do not establish
when charts were entered. No later convention was retroactively assigned.
The saved README's CC BY-NC-SA 4.0 research basis was rechecked for original
inputs. The new documentation is retained locally with attribution, not published
or treated as new rights to redistribute data. No outreach was submitted.

## Evidence-to-rule mapping

| Observed notation | Evidence and implementation | Disposition |
| --- | --- | --- |
| Terminal `C` after a supported in-play prefix | Pinned Instructions A213–A216 describe stopping play for an incorrect challenge. Sheet1 AN18 explicitly awards the point using last-stroke parity; K18/L18 identify server/receiver, AM18 counts post-serve strokes. The last hitter wins and the opponent is the administrative challenger. | Supported. Preserve `C` as ADMIN, never a physical stroke, return error or +1 attempt. A trailing suffix or unsupported preceding notation still fails. |
| Later-stroke digits such as `b19`, `s38` | E01 and Instructions A170–A180 define numeric depth only for returns. E02 confirms later-rally depth observations exist, but supplies no numeric grammar. Workbook AL18 strips 7/8/9 anywhere for counting; stripping is not semantic authority. | All 946 affected points remain unresolved. Do not silently ignore digits or label them rally depth. |
| `+` after direction/depth, `!` before direction, `h^` or serve `^` | Instructions A187/A193 require approach/position modifiers immediately after shot type; error instructions put shank at the final error; A198 documents stop volleys. No located upstream explanation establishes the observed variant placements or half-volley/serve extension. | Preserve as unsupported; no aliases or normalization. |
| Semicolon on a serve fault | Instructions A196 broadly permits a net-cord annotation on any shot, but E04 explicitly restricts semicolons to rallies and describes net-cord/out serves using `n`. The evidence conflicts. | New `SERVE_NET_CORD_AUTHORITY_CONFLICT` on all 15 observed points. Retain literal tokens and net-cord annotation, but withhold validation; never repair faults to `n`. |

The challenge rule comes from upstream instructions plus normative workbook
calculation, independently of the sample's recorded winners. Recorded winner
agreement is a subsequent check, not evidence used to invent a rule. E04 predates
the workbook; no explicit later repeal was found. The broader phrase alone cannot
resolve that contradiction. The conflict flag records this uncertainty.

## Measured disposition delta

The same 20 ATP-file / 24 WTA-file matches and 7,333 points were rerun.
“Validated” below includes explicit-unknown fields and supported administrative
challenge endings after observed tennis actions; it does not imply normal
completion of an official match.

| Measure | Stage 2 original | Version 1.1.0 | Delta |
| --- | ---: | ---: | ---: |
| Validated sequences | 6,244 | 6,237 | −7 |
| ATP validated | 3,565 | 3,560 | −5 |
| WTA validated | 2,679 | 2,677 | −2 |
| Parsed without explicit unknown fields | 6,234 | 6,227 | −7 |
| Parsed with explicit unknown fields | 10 | 10 | 0 |
| Outcome-only missing-action points | 81 | 81 | 0 |
| Unsupported/unresolved sequences | 1,008 | 1,015 | +7 |
| Decoded terminal agreements, including unresolved prefixes | 7,225 | 7,228 | +3 |
| Unresolved terminal winner | 108 | 105 | −3 |
| Terminal-outcome conflicts | 0 | 0 | 0 |
| Charts with every point validated | 12 | 13 | +1 |

Two WTA points gain validation: Cornet/Azarenka point 15 (`5b29C`) and
Kostyuk/Keys point 107 (`4b28f3f3b3b3b3b2C`). Cornet/Azarenka point 20
still contains unsupported later-stroke digits despite its decoded challenge
ending. Nine points lose validation solely through the serve-semicolon authority
conflict (five ATP / four WTA); six other such points already had failures.
No other point changes validation membership.

Independent score/server replay remains unchanged: all 7,333 points pass;
44 charts reconcile to completed score states, 1,164 games and ten tiebreaks.
Raw notation, Notes, source rows/IDs, token spans, neutral player names and
sample selection remain unchanged. All 38,593 ledger rows retain unique action
IDs and one domain; ADMIN challenge ownership is now explicit.

## Serve +1 reconciliation

| Measure | Original | Version 1.1.0 | ATP / WTA now |
| --- | ---: | ---: | ---: |
| Observed +1 prefixes | 4,969 | 4,969 | 2,650 / 2,319 |
| Validated attempts | 3,988 | 3,986 | 2,180 / 1,806 |
| Validated attempted errors | 725 | 724 | 368 / 356 |
| Known absent | 2,256 | 2,251 | 1,380 / 871 |
| Unknown opportunity/observation | 108 | 113 | 62 / 51 |
| Observed but unvalidated prefixes | 981 | 983 | 470 / 513 |

Observed + known absent + unknown = 7,333. Validated attempts + known absent
= 6,237. Three formerly validated +1 prefixes lose validation through the
semicolon conflict, and one challenge case gains a validated +1. One attempted
error loses validation. Six previously known absences become unknown because
of the conflict; the supported terminal return/challenge adds one known absence.
A challenge does not create a nonexistent error attempt. Explicit shot letters,
including attempted errors, determine +1, never rallyCount.

## Remaining failures and limits

Overlapping failures are fully reported in the versioned reason summary. ATP/WTA
counts: later-stroke digits 452/494; unsupported shot code 51/51; missing terminal
51/52; error without terminal 10/22; serve-semicolon conflict 9/6; stop-volley
extension 7/2; invalid return digits 2/5; trailing serve notation 2/2; missing
unforced-error subtype 4/1. Other unchanged failures are one ATP duplicate
modifier and WTA first-serve-forfeit misuse (one), missing second serve (one),
second serve without first fault/forfeit (two), special code in second field (one)
and unsupported serve start (two). No challenge-authority failure remains;
its digit-conflicted point stays excluded. Sole later-digit failures now total
871, because two such points also carry the new semicolon conflict.

No inconsistent field is repaired. Chart consistency cannot establish official
completion or admission. Movement, temporal availability, statistical uncertainty
and factor validity remain unresolved. Every acquired year, including 2026, is
exposed; no untouched test period or estimation cohort is designated.

## Release and validation

Six new ignored files use existing flat `data/pilot/mcp-stage2-v2-` prefixes:
actions, point-reconciliation, match-reconciliation, reason-summary,
decoded-examples and summary. They carry `MCP_STAGE2_1.1.0`, exposed-year,
parser-only and uncertainty labels. The original Stage 2 six CSVs are hash-pinned
and unchanged. Installation remains staged per-file atomic rename with summary
last; it is not a multi-file transaction and refuses differing installed bytes.

The final run passed **283 focused parser checks** and **47 documentation,
consistency and preservation checks**. Six independent outputs were byte-identical;
473 original files and the four new evidence snapshots were preserved. An early
test invocation was interrupted by a concurrent test-file edit; the completed
unmodified test source passed syntax validation and the full focused rerun.
No raw or historical release correction resulted.

Focused checks cover documentation pins, normative challenge parity, every
original supported family, unresolved variants, conflict preservation, raw spans,
neutral ownership, attempted errors, independent score/server replay, exact
before/after point deltas, sample accounting, order invariance, ignored file scope
and independent byte-identical reruns. Validation totals are recorded in current
status after completion. Historical suites were not rerun. Original reports,
inputs, manifests, samples and releases remain byte-identical; no dependency,
directory structure, rating, estimation or scoring was introduced.

## One next executable step

Build a sample-only deterministic **pre/post-action state and opportunity ledger**
from this versioned release, retaining all 7,333 points and an explicit
unusable/unknown state for every unresolved sequence. Specify server-relative
state boundaries and unique terminal/admin treatment; reconcile ownership and
+1 denominators without estimating probabilities or assigning action values.
This prepares the accounting required by the transition without pretending the
remaining notation or factor definitions are validated.

Exact proposed approval: “Build and audit pre/post-action states and Serve +1
opportunity ledgers only for the frozen 44-match version 1.1.0 parser release.
Preserve all unresolved and authority-conflicted cases, raw inputs, sample and
historical outputs. Estimate no probabilities, factors, weights, ratings or
models; acquire no data and select no evaluation period.”

No user input is needed to complete this audit. Before any later estimation,
the user must choose the evaluation approach and untouched evidence boundary;
2021–2026 must not be relabeled unseen. Remaining numeric/modifier semantics
require attributable documentation or separately authorized maintainer outreach,
not inference from point outcomes.
