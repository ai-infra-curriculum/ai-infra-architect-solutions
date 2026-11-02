# SOLUTION — Exercise 4: Stakeholder Management Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-309-arch-communication/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **audience map**
deliverable — *"for a given architecture proposal, who needs to
be persuaded? What's their altitude? What format do they
consume?"* — to a concrete AI-platform proposal. The architect-
tier answer is a stakeholder map that commits, per audience, the
decision role, the altitude, and the artifact; the output of
this exercise is what Exercise 5 (the ARB pre-read) and
Exercises 1–3 (memo, diagrams, ADR) each use to pick a target.

The module rationale frames audience mapping as the discipline
of picking the *right altitude per audience* and names "one
document, all audiences" as a top grader-visible failure. This
exercise is where the learner commits the map that keeps every
other artifact in the module honest; the follow-on
Stakeholder Management work (ARB pre-read, ongoing engagement)
is in [`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md).

## 2. Worked answer

A passing stakeholder-map submission produces one versioned
stakeholder map with four named sections, mirroring the audience
table in `../../../guides/stakeholder-communication.md`:

1. **Audience table** — row per audience, with role, decision
   authority, altitude, format preference, and format produced.
2. **Decision-role classification** — who approves, who is
   consulted, who is informed per decision in the proposal.
3. **Format-to-artifact binding** — the specific artifact (memo,
   diagram, ADR, pre-read) each audience consumes.
4. **Pre-wire plan** — the sequence of 1:1 conversations that
   precede any formal review, per the module rationale's
   "ARB members come prepared" discipline.

### Audience table

The core artifact. Columns from the local stakeholder-
communication kit, selected for the architect tier:

| Audience | What they care about | How they read | Format produced |
| --- | --- | --- | --- |
| Executive sponsor (SVP+) | Outcome, risk, narrative arc | One page; then questions | Exec memo (Exercise 1) |
| Finance / CFO partner | $ in, $ out, when, certainty range | Numbers; sensitivities; assumptions explicit | Decision memo + cost model |
| Legal / privacy counsel | Liability exposure, regulatory fit, data handling | Specific clauses; attestations | Compliance mapping |
| Security review board | Threat model, controls, residual risk | Threat → control → evidence chain | Threat model + ADR (Exercise 3) |
| Product partner | Impact on roadmap, time-to-market, dependencies | Timeline, gates | Decision memo + timeline |
| Engineering peer | Trade-offs, alternatives, hidden complexity | Diagrams, ADRs | C4 set (Exercise 2) + ADR |
| Customer-facing team | What changes for customers, when, what to say | Comms plan, FAQ | Comms plan |
| Regulator | Compliance with a specific rule, documented evidence | Mapping table | Compliance mapping |

The columns are the module rationale's "altitude" discipline in
tabular form; the right-hand column binds the audience to one of
the artifacts produced elsewhere in the module.

### Decision-role classification

For each decision in the proposal the submission names:

- **Approve** — the single role that ratifies the decision; the
  executive memo (Exercise 1) is addressed here.
- **Consult** — the roles whose input is required before
  approval; the ADR (Exercise 3) is where their concerns are
  recorded and answered.
- **Inform** — the roles who learn after the decision; the
  comms plan reaches them.

A map without a named approver is a map that will produce an
unapproved decision; the architect-tier value is in forcing the
single-approver assignment.

### Format-to-artifact binding

Each row in the audience table binds to a specific artifact
elsewhere in the module. The binding is non-arbitrary:

- Executive sponsor → one-page memo from
  [`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md).
- Engineering peer / ARB → C4 set from
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md) and
  ADR from
  [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md).
- ARB-as-a-body → pre-read packet from
  [`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md).

The binding is the test of whether the map is operational: if an
audience in the map has no artifact bound to them, either the
audience is a stretch or an artifact is missing.

### Pre-wire plan

The module rationale pins "pre-reads sent the morning of" as a
top failure and names the ARB pre-read as the "48 hours before"
artifact. The pre-wire plan here is the sequence of 1:1s that
precedes the ARB meeting itself — one row per voting member,
with the pre-wire owner, the ask of that conversation, and the
expected objection or concern to surface. The local
stakeholder-communication guide names this pattern explicitly:
*"the meeting itself should ratify a decision the members
already understand."* The *execution* of the ARB meeting using
the pre-read is Exercise 5; the *mapping* that identifies who
to pre-wire is here.

### AI/ML-specific considerations

When the proposal is an AI/ML platform, the stakeholder map
carries additional required audiences and framework-aligned
asks:

- **Model risk / AI governance owner** — a dedicated audience
  on AI/ML platforms. Their altitude is the NIST AI Risk
  Management Framework *Govern* and *Manage* functions; their
  artifact is the ADR's Risks table plus the governance hook.
- **Security review board** — on AI/ML platforms the threat
  model layer carries OWASP ML Top 10 and MITRE ATLAS content;
  the stakeholder row names those frameworks in the "what they
  care about" column so the review arrives with the right
  expectation.
- **Data governance / privacy counsel** — AI/ML platforms touch
  training-data provenance and inference-data retention; the
  stakeholder row names the specific data classes in scope.

These audiences do not replace the standard set; they extend it.

### Decision rationale

The stakeholder map (audience table + decision-role
classification + format binding + pre-wire) is the right
artifact because the module rationale names audience mapping as
the first move in architect-tier communication and because the
local stakeholder-communication guide names the audience table
and the pre-wire pattern as reusable kit. Trade-offs the
submission should explicitly accept, mirroring the module
rationale:

- *Multiple-altitude documents mean producing the same content
  in different shapes.* The stakeholder map is what commits the
  shapes; without it the shapes drift.
- *One document, all audiences.* The map's existence is the
  structural check against this failure.

### What stays out of scope

The architect-tier answer **does not** write the executive memo
(deferred to Exercise 1), produce the C4 diagram set (deferred
to Exercise 2), produce the ADR (deferred to Exercise 3), or
assemble the ARB pre-read packet or the ongoing engagement plan
(deferred to Exercise 5). The map identifies the targets; the
other exercises hit them.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names the audience-map deliverable
as *"for a given architecture proposal, who needs to be
persuaded? What's their altitude? What format do they consume?"*
and the pre-read deliverable as the ARB packet "distributed 48
hours before the meeting." The learner-visible title for this
exercise is "Stakeholder Management Application"; because the
task briefing names the next exercise with the same title, this
file carries the *mapping* half — the audience table, decision
roles, and format binding — and defers the *execution* half
(ARB pre-read packet and ongoing engagement) to Exercise 5.

## Implementation

Implementation of the stakeholder map lands as versioned
documentation, not as a running system:

1. **Audience table** — Markdown table in the architecture
   repository with the columns above; one row per in-scope
   audience, no empty cells.
2. **Decision-role classification** — a RACI-style table (or
   lightweight equivalent) binding each decision in the
   proposal to a single approver, named consults, and named
   informs.
3. **Format-to-artifact binding** — one column of the audience
   table (or a sibling table) resolves each audience to the
   specific artifact produced in Exercises 1, 2, 3, or 5.
4. **Pre-wire plan** — one row per voting ARB member or
   equivalent approver / consult, with pre-wire owner, pre-wire
   ask, and expected objection; the plan is executed before the
   formal review in Exercise 5.
5. **AI/ML-specific audiences** — on AI/ML platforms, model
   risk / AI governance owner, security review board, and data
   governance / privacy counsel are additional required rows
   with the frameworks (NIST AI RMF, OWASP ML Top 10, MITRE
   ATLAS) named in their "what they care about" cells.
6. **Research-pending markers** — where an audience's role or
   decision authority is unknown at write time, a
   `<!-- research-pending: ... -->` comment is used, so
   auto-merge blocks until the gap is filled.
7. **Governance hook** — the map is reviewed by the proposal
   owner's lead; changes to the approver column of a RACI are
   material and trigger an ADR via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the stakeholder map. Confirm the audience table has
   one row per in-scope audience, with role, altitude, and
   format produced populated.
2. Confirm the decision-role classification names a single
   approver per decision. Multiple approvers or an unnamed
   approver is a fail signal.
3. Confirm every audience in the table is bound to a specific
   artifact from Exercises 1, 2, 3, or 5. An audience without
   an artifact is a map that will not produce a decision.
4. Confirm the pre-wire plan names an owner, an ask, and an
   expected objection per voting member. Blank cells are a
   fail signal.
5. For an AI/ML platform, confirm model risk / AI governance
   owner, security review board, and data governance / privacy
   counsel are rows in the table with the applicable
   frameworks named.
6. Confirm any audience whose authority is uncertain carries a
   `<!-- research-pending: ... -->` marker rather than a guess.
7. Confirm the map is the artifact the Exercise 5 ARB pre-read
   packet uses to decide distribution and the Exercise 1
   executive memo uses to pick its target reader.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Audience coverage | Row per in-scope audience with role, altitude, format produced | Any audience missing or any cell blank |
| Approver clarity | Single approver per decision | Multiple approvers or none |
| Consult / inform split | Consults and informs separately named | Collapsed into one list |
| Artifact binding | Every audience bound to a specific module artifact | Audience without artifact |
| Pre-wire plan | Owner, ask, expected objection per voting member | Any cell blank |
| AI/ML audiences | Model risk, security review, data governance rows present when applicable | Missing on an AI/ML proposal |
| Framework alignment | NIST AI RMF / OWASP ML Top 10 / MITRE ATLAS surfaced per audience when applicable | Framework names absent |
| Research markers | `research-pending` for unknown authority | Guessed authority presented as fact |
| Governance hook | Approver changes trigger ADR | Approver changes applied silently |
| Form | Versioned Markdown | Chat message or wiki page only |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the stakeholder-map deliverable:

1. **One document, all audiences.** The map's existence is the
   structural fix for the module's top failure; a map that
   binds every audience to a single generic document reproduces
   the failure in table form.
2. **Approver not named, or multiple approvers.** Decisions
   with no single approver or more than one do not get taken;
   the architect-tier call is to name one.
3. **Audience without an artifact.** An audience in the table
   with no column binding to a module artifact is a map that
   has identified a stakeholder with no plan to communicate to
   them. Either delete the row or add the artifact.
4. **Pre-wire absent.** Taking a proposal to a review body
   cold produces reactive decisions; the module rationale and
   the stakeholder-communication guide both name pre-wire as
   the pattern. A map without a pre-wire plan predicts a
   failed review.
5. **Asymmetric disclosure.** Telling each audience a different
   story. The map is where the stories are rationalized against
   a single underlying position; the audience-specific shaping
   is in format, not in substance.
6. **AI/ML audiences omitted.** On an AI/ML platform proposal,
   missing the model risk / AI governance owner or the data
   governance counsel is a structural omission; the frameworks
   name these audiences and the real-world review will not
   proceed without them.
7. **Guessed authority.** If the proposal owner does not know
   the actual approver for a decision, saying so with a
   `research-pending` marker is pass; inventing an approver is
   fail.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
- Local stakeholder-communication kit:
  `../../../guides/stakeholder-communication.md`
