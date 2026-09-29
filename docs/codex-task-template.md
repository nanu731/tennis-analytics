# Compact Codex task template

Use this template for future phases. Omit a section when it adds no new
information. Standing rules already live in `AGENTS.override.md`,
`PROJECT_CONTEXT.md`, the current status snapshot and the data-source contract.

```text
Work in /Users/narayanlekhi/Documents/GitHub/tennis-analytics.

Complete Phase [ID]: [short outcome]. Start from commit [SHA].

Objective
[One paragraph naming the decision or result this phase must produce.]

Authority
- [Actions newly authorized for this phase.]
- [Named existing artifacts or outputs to reuse.]

Deliverables
- [Files to create or change.]
- [Terminal decision, output or model state required.]

Acceptance checks
- [Checks specific to the scientific or implementation risk.]
- [Expected terminal state.]

Task-specific exclusions
- [Only boundaries not already stated in repository instructions.]

Commit with: `[result-specific message]`
Do not push.

End with `# ChatGPT Handoff`. Make it delta-only, target 400–650 words and
never exceed 800 words. Include the result, ending commit, changed files,
material evidence, unresolved limitations, next executable step and exact
approval needed. Return the handoff as response text; do not invoke a handoff
tool.
```

## Prompt-writing rules

- Cite stable repository instructions instead of copying them.
- State the outcome before procedural detail.
- Name exact files only when scope control needs them.
- Reuse a verified commit and outputs instead of restating their full findings.
- Specify proportionate checks. Do not request the full historical suite by
  default.
- Give one next executable step. Do not generate another planning phase unless a
  specific blocker requires it.
