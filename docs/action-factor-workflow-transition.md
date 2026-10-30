# Transition to action-based tennis factor research

Adopted user direction: 2026-10-08. Implementation has not started.

## Read this first

Use this file for the new research workflow. It supersedes the old panel and
season rules only for the new prototype as specified below. Preserve the
original workflow, frozen releases, results and their historical rules.

The current task creates transition documentation. On a subsequent instruction
to start or continue this workflow, execute Stage 1 below. Read
`AGENTS.override.md`, the current status snapshot and this file; consult named
historical reports or relevant contract sections only when needed.

Keep all research in this repository. Website integration and the Challenger
project remain later work.

## Objective and reason for the transition

Research question: Can a small set of interpretable tennis factors describe
player strengths and produce better-calibrated forecasts than surface Elo?

The user requires factors derived from the mechanics of tennis, with distinct
event ownership and no duplicated credit. Derive the measurement framework
before selecting statistics. Four factors remains a hypothesis; the user accepts
three supported factors if a fourth cannot be measured and validated.

Test structural overlap, algebraic dependence, empirical collinearity,
incremental information and out-of-time usefulness as separate requirements.
Disjoint events do not guarantee uncorrelated player metrics. Do not force zero
correlation through residualization or rename correlated measures to imply
independence. Describe association and attribution assumptions without claiming
causality.

## Previous workflow and completed evidence

The original workflow used match-level counts from the pinned Sackmann archive,
main-draw singles and ten event families: Australian Open, Roland-Garros,
Wimbledon, US Open, Indian Wells, Miami, Madrid, Rome, Canada and Cincinnati.
Analyze ATP and WTA separately. Original periods were 2021–2023 development,
2024 validation and 2025 locked final test. Actual development admissions cover
ATP 2023 and WTA 2021/2023; they lack 2022 and ATP 2021.

The four original hypothesis families were Serve Creation, Second-Serve
Security, Return Pressure, and Conversion and Recovery. The provisional S08
specification contains:

| ID | Actual measurement |
| --- | --- |
| M03 | Own first-serve points won / own first serves in |
| M05 | Own double faults / own second-serve opportunities |
| M11 | Opponent break points faced / opponent service games |
| M12 | Opponent break points converted / opponent break points faced |

M05 measures one second-serve error component. M12 measures conversion or
execution; recovery, resilience and clutch ability remain unsupported meanings.
The reduced comparator contains M03/M11/M12. S02 remains paused and S08 remains
provisional.

The implemented pipeline audits provenance, identities, completion, counts,
exclusions, neutral player orientation and cumulative prior histories. It uses
simultaneous tour/source-date batches, prior-batch features, training-only
scaling and post-batch updates. Actual timing and historical availability remain
unverified. Preserve these labels on the historical analysis:

- `SOURCE_LABEL_EVENT_BATCHING_FOR_DEVELOPMENT_SENSITIVITY`
- `NO_FORECAST_CHRONOLOGY_SUPPORTED_BY_SAVED_EVIDENCE`
- `UNCERTAINTY_NOT_ESTABLISHED`

The historical factor forecast uses separate ATP/WTA logistic models, neutral
player differences, zero intercept and training-SD-only scaling. Frozen Elo
uses 1500 priors, scale 400, K=32, a 50:50 overall/surface rating blend and
synchronous summed updates. Overall-only Elo is the frozen sensitivity.

Verified completed results:

- Phase 2AL finished the locked 2025 comparison. Surface Elo has lower log loss
  and Brier than both factor candidates in both tours; all batch deletions retain
  that direction. Calibration comparisons remain unresolved. The common scoring
  cohort contains 951 ATP and 826 WTA matches. WTA Canada/Cincinnati remain
  excluded. See [locked results](2025-locked-final-evaluation-results.md).
- Phase 2AN estimated same-match NPR contributions. Development R² is 0.873 ATP
  and 0.896 WTA; applying development fits to 2024 gives 0.889 and 0.895.
  LMG/Shapley shares in M03/M11/M12/M05 order are 44.0/36.7/17.1/2.2% ATP and
  47.3/34.2/15.9/2.7% WTA. These are descriptive shares, with no established
  uncertainty or final weights. See [weighting results](factor-weights-results.md).

Phase 2AN's `FOUR_DISTINCT_STABLE_FACTORS_SUPPORTED_DESCRIPTIVELY_ON_NPR`
records passage of its stated numerical and stability rules. It does not certify
disjoint event ownership under the new requirement. Same-match components share
counts with NPR; high R² alone cannot qualify them. Preserve this historical
finding alongside that distinction. The failed M05 cross-tour forecast-direction
requirement remains binding for historical S08 qualification.

Development/validation/final evaluation and descriptive weighting already exist.
Do not restart Phase 2AL or treat it as pending. Pause expansion into S08 player
profiles while developing the new measurement framework.

## New candidate framework

Retain Net Point Rating as the primary descriptive outcome:

`NPR = 100 * (points_won - points_lost) / total_points`

Use match winning as the forecasting outcome. Define player/match aggregation
and opponent adjustment before estimating new relationships or weights.

| Candidate domain | Intended ownership | Data requirement |
| --- | --- | --- |
| Serve Action Value | Serve attempts, faults and the advantage created by the serve | Serve/point sequence; richer attribution needs tracking |
| Return Action Value | The receiver's first response to the serve | Return action, direction, depth and outcome where recorded |
| Rally Stroke Value | Subsequent strokes by either player, including volleys, overheads and the server's +1 | Parsed shot sequence and available context |
| Positioning and Movement Value | Positioning/recovery contribution distinguishable from stroke contribution | Valid player/ball coordinates, timing and attribution assumptions |

These are candidate domains, not validated metrics. Define a canonical
perspective for point-win probability and ownership before estimating value.
Audit forced errors, terminal winners, non-contact failures, first-serve faults,
double faults and serve-and-volley cases. Opponent failure and prior-shot credit
must not receive duplicate attribution.

An exploratory value framework is `P(win | after action) - P(win | before
action)`. Do not assume it identifies causal value. Specify state boundaries,
reference player/opponent, terminal treatment and estimable inputs. Estimate
probabilities from training data; use held-out point outcomes for assessment.
Exact transition totals can telescope to the point outcome by construction;
reconstruction accuracy and same-match R² then measure accounting or model fit,
not independent evidence that the chosen factors explain success.

Movement occurs around serve, return and rally actions. Separating it from stroke
quality needs a documented attribution rule and evidence of identifiability.
If separation fails, retain three domains and report the limitation. A Bayesian
model can handle sparse observed spatial data; it cannot supply missing
coordinates or turn shot-direction codes into verified movement measurements.

## Serve +1

Define +1 as the server's first stroke after the return, usually shot three.
Assign its contribution to Rally Stroke Value. Keep serve contribution in Serve
Action Value. Show Serve +1 as a tactical composite of those owned contributions;
do not add it as another term to the factor total.

Track two denominators: all service points for aggregate contribution, and
observed +1 opportunities for conditional execution. Mark aces, double faults,
unreturned serves and terminal returns as no +1 action. A known absent action
contributes zero to that action ledger; unknown or uncharted actions remain
missing. Keep conditional +1 rates undefined when no opportunity exists.

The first prototype reports serve direction, return characteristics, +1 shot
type/direction, +1 winners/errors and eventual point outcomes where available.
Label conditional point-win rates as descriptive; they combine opponent quality
and earlier actions. Added-value estimation must condition on supported prior
state information. Skip synergy/interaction models until simpler components
show a specific unresolved limitation.

## Data scope, rights and authorized direction

The user approves a Match Charting Project (MCP) prototype using available
charted matches rather than forcing the original ten-event panel, accepts three
supported factors, and authorizes pursuit of free research access from TDI or
other official providers subject to privacy and cost constraints.

For the new prototype, audit ATP/WTA main-draw singles across available years,
events and surfaces. Select an outcome-neutral sample from that inventory;
report imbalance and convenience selection. A balanced subset is optional and
does not establish population representativeness. Preserve the old panel and
admissions for their existing releases. Defer Challenger modeling.

Use [MCP](https://github.com/JeffSackmann/tennis_MatchChartingProject) as the
initial candidate shot source. It supplies crowdsourced shot sequences, not
verified tracking coordinates. Audit the exact revision, notation and field
availability. Its stated CC BY-NC-SA 4.0 terms require attribution and constrain
commercial use and sharing; verify the intended use before acquisition and any
public derivative release. Trace mirrors to their origin. Historical coverage
counts in `tennis-analytics-public-data-research.pdf` describe its audited
snapshot, not the current repository.

[TDI's platform](https://www.tennisdata.com/tennis-data-platform) describes a
tracking archive and sandbox. Free external research access, downloadable fields
and publication rights remain unconfirmed. ATP Tennis IQ access for players and
coaches does not establish researcher access. Consult the [tracking
research](https://arxiv.org/abs/2005.12853) for method feasibility, not access
permission or endorsement of this factor decomposition.

Research official application/contact routes and prepare a short access request.
Use only user-provided identity, affiliation and contact details. Obtain the
missing details and an explicit instruction to send before submitting outreach.
Request no biometric, health or private wearable data. Confirm zero fees,
coverage, coordinates, timestamps, retention and derivative-publication terms.
Accept no paid access or agreement on the user's behalf. Continue the MCP path
while access remains unresolved. OTD remains paused.

## Evaluation boundary for the new workflow

The team has inspected 2025 results and used them to motivate this redesign.
Treat 2021–2025 evidence as exposed historical material for the new method.
Keep the original locked-test designation only for the original frozen models.
Chronological holdouts within exposed years can measure retrospective transfer,
but they cannot supply a new untouched final test.

Before fitting the new model, document data exposure, development/validation
periods and a proposed untouched final sample. Do not choose a new final season
by assumption or inspect its outcomes before freezing the plan. A calendar year
alone does not prove that data is unexposed. Obtain the user's input on the new
evaluation split after the coverage audit makes the options concrete.

Apply all learned transformations, opponent adjustments, probability estimation,
imputation, shrinkage, selection and weights inside training folds. Keep matches
and their points together. Keep simultaneous batches together when using source
labels. Distinguish match dates from verified information availability.

Use identical eligible IDs and cutoffs for factor/Elo forecast comparisons, with
all-target coverage and cold starts reported. Preserve retirement/walkover and
invalid-record exclusions. Structural zero-opportunity rates remain undefined.
Add imputation only for a demonstrated eligible sporadic-missingness problem.

Design uncertainty around the estimand and shared-player/event dependence.
Retain `UNCERTAINTY_NOT_ESTABLISHED` until a supported method passes validation.
The old connected-component bootstrap failure applies to that method; it does
not prove that all dependence-aware methods are impossible.

## Execution stages and completion gates

1. **Framework and measured coverage audit, next executable stage.** Inspect
   existing source artifacts and reuse eligible evidence. Write the action
   ownership/state/denominator specification and a versioned MCP metadata
   inventory after rights/provenance verification. Report tour/year/event/surface
   coverage, players, point-file linkage, duplicates, completion information,
   available temporal fields and supported Serve +1 fields. Choose no sample
   based on player performance or model fit. Produce a measured audit and
   proposed sample/evaluation options in one milestone; no factor fitting yet.
2. **Action parser and three-domain prototype.** Build a small R parser with
   retained raw notation, unique action ownership and explicit unknowns. Verify
   it against notation examples and a documented outcome-neutral match sample.
   Independently reconcile point totals and audit Serve +1 opportunity cases.
   Report parser failures before implementing any repairs or exclusions.
3. **Candidate estimation and assessment.** Freeze a simple method and the
   approved retrospective split before fitting. Assess structural/algebraic
   redundancy, correlations, VIF/conditioning, incremental information, NPR
   relationships and stability across players, tours, seasons and surfaces.
   Evaluate held-out probability estimates and distinguish mechanical accounting
   from useful skill measurement. Report failed candidates and revise them
   within development only.
4. **Movement feasibility, alongside the prototype.** If access supplies valid
   tracking, test simple positioning attribution and its measurement error first.
   Use Bayesian spatial estimation only for a named limitation that requires it,
   with prior sensitivity and predictive checks. If coordinates or distinct
   attribution fail, document three supported domains and proceed.
5. **Freeze supported factors and weighting.** Select metrics from replicated
   measurement and incremental evidence. Estimate descriptive importance with
   appropriate shared-variance handling when the design supports it. Keep
   regression importance, additive accounting shares and forecast coefficients
   distinct. Obtain approval of the concrete specification and final-test plan.
6. **Forecast comparison.** Construct prior histories under the chosen chronology
   and compare with frozen Elo on common matches. Assess log loss, Brier,
   calibration, coverage and sensitivity. If studying current form, define that
   target and test a small prespecified time-sensitive extension; existing Elo
   losses alone do not validate current-form measurement. Give no prestige or
   round bonuses. Freeze before the new untouched final test.
7. **Research deliverables and publication.** Produce reproducible findings,
   player profiles and Serve +1 plots after qualification and rights checks.
   Report negative/partial findings. Website integration requires the user's
   separate request; keep personal interpretation markers for user input.

For Stage 1 use existing `R/`, `docs/` and `data/manifests/` locations: proposed
names are `R/audit_mcp_coverage.R`, `R/test_mcp_coverage.R`,
`docs/action-factor-definition-and-coverage.md` and
`data/manifests/mcp-source-files.csv`. Reuse an existing ignored local data
location, or obtain approval before adding a new directory structure. Finalize
the exact acquired inputs and output files after inspecting rights and source
layout. Test linkage, accounting, source pins and outcome-independent sampling;
avoid scaffolding a general ingestion framework before it is needed.

## Working rules and handoff

Use R with installed tidyverse/base-R tools and ggplot2. Ask before dependencies,
Python in the main analysis, directory restructuring, new split adoption,
publication or paid/provider agreements. The approved prototype panel change and
methodological direction above need no repeat approval. Preserve historical
code, manifests, outputs and reports; create new versioned research releases.

Keep context routing short. Reuse validated helpers only where their assumptions
match the new source. Run affected scientific/implementation checks; rerun
historical suites only for changes affecting their behavior. Commit each
completed milestone with a result-specific message; do not push by default.
Update the current status and affected sibling claims with measured results.
Combine specification and implementation within a stage when the method and
authority are settled. Avoid repeated readiness-only milestones.

End each task with a text `# ChatGPT Handoff`: target 400–650 words, maximum 800
unless the user requests more. Include the new result, commit, changed files,
material evidence, remaining limitations, next executable step and any specific
missing authority or input. Report only the delta; do not invoke a handoff tool
or repeat the project history. Include no model/effort recommendations.
