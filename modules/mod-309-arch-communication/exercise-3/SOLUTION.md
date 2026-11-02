# SOLUTION — Exercise 3: ADRs Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-309-arch-communication/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's framing that the
architect's communication skill includes *"picking the right
artifact (memo, slide, diagram, ADR)"* to the specific ADR
artifact for a concrete architecture decision. The architect-
tier answer is not a free-form design document; it is a durable
decision record using the repository's committed ADR template,
written so a reader two years later can reconstruct the
reasoning without finding the original author.

The module rationale names ADRs as one of the four core
artifacts an architect chooses between and places the "technical
deep-dive for senior engineers" (10–30 pages, trade-offs,
alternatives, implementation considerations, risks) as the
engineering-audience companion. In this module's exercise set,
the ADR is the structured, durable version of the deep-dive —
the artifact the stakeholder-communication guide calls *"read
once, archived, and becomes the institutional memory of 'why did
we choose X?'"*.

## 2. Worked answer

A passing ADR submission produces one ADR using the local
template at
`../../../architecture-templates/architecture-decision-records/adr-template.md`,
with every section populated. Mirroring that template:

1. **Header** — ADR number, short title, status (Proposed /
   Accepted / Deprecated / Superseded), date, decision makers,
   stakeholders.
2. **Context** — problem statement, background, forces (technical,
   business, team, timeline, compliance, strategic).
3. **Decision** — the "we will" statement and the specific
   details that follow from it.
4. **Alternatives considered** — each alternative with
   description, pros, cons, and the reason it was not chosen.
5. **Consequences** — positive, negative, and the risk table
   (likelihood × impact × mitigation).
6. **Validation** — proof-of-concept notes, expert review,
   success metrics.
7. **Implementation notes** — phased plan, dependencies, timeline.
8. **Related decisions** — links to other ADRs this one depends
   on, supersedes, or informs.
9. **Review and update** — next review trigger, revision
   trigger, owner.
10. **References** — supporting documents, research, vendor
    material.

### Context section discipline

The *Context* section carries the "why now" load; without it the
ADR is unreadable in a year. The module rationale frames
engineering audiences as wanting *"trade-offs, alternatives,
implementation considerations, risks"* — the Context section is
where the forces that create the trade-off live, so the Decision
section's claim ("we will do X") is anchored. A context that
reads like a product pitch is a fail signal; a context that
names the business and technical constraints is a pass.

### Decision statement

The Decision section leads with *"we will"* and a single
sentence. Details follow as a bulleted list. The module
rationale's warning against "memos that bury the recommendation"
applies here even though the audience is engineering: an ADR
whose decision is in prose halfway through a sub-section is an
ADR nobody can cite.

### Alternatives

The module rationale requires alternatives. The ADR carries
them in depth that the executive memo from
[`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md)
cannot. Each alternative gets pros, cons, and the reason it was
not chosen; "we chose X because it was best" is not an
alternatives analysis.

### Consequences

The *Positive consequences* bullets state the outcome; the
*Negative consequences* bullets state the trade-off and the
mitigation plan; the *Risks* table scores likelihood and impact
and names the mitigation per risk. This structure is what makes
the ADR auditable: a reviewer in a year can check whether the
mitigations were performed.

### Validation

Proof-of-concept notes, named expert reviewers, and success
metrics live here. The success metrics tie back to the outcome
language the module teaches ("reduce incidents by N%", not
"refactor the subsystem"). An ADR without success metrics is an
ADR that cannot be checked later.

### Related decisions and governance

The *Related decisions* section links to other ADRs; the
governance system from `mod-301/exercise-4` is the registry.
When this ADR supersedes an earlier one, both are updated —
status set to *Superseded by ADR-YYY* on the older ADR, with
the link.

### AI/ML-specific considerations

When the ADR records a decision about an AI/ML platform, the
*Forces*, *Alternatives*, and *Risks* sections carry framework-
aligned content:

- **NIST AI Risk Management Framework** — the *Forces* bullets
  include the AI RMF function the decision is in service of
  (*Govern* / *Map* / *Measure* / *Manage*). The *Risks* table
  carries at least one row for an AI RMF *Measure* or *Manage*
  risk the decision creates or mitigates.
- **OWASP Machine Learning Security Top 10** — ML-specific
  risks (supply chain, data poisoning, model theft, prompt
  injection) appear in the *Risks* table as named categories
  with mitigation.
- **MITRE ATLAS** — if the decision changes the adversarial-
  threat surface, the ADR links the relevant ATLAS techniques
  under *References* so the security reviewer can audit the
  reasoning.

Where a framework claim cannot be verified at write time, use
`<!-- research-pending: ... -->` so auto-merge blocks until
resolved.

### Decision rationale

The template-driven ADR is the right artifact because the
module rationale names ADRs as one of the four committed
architect artifacts, and the local ADR template at
`../../../architecture-templates/architecture-decision-records/adr-template.md`
is the specific schema the organization has standardized on.
Trade-offs the submission should explicitly accept, mirroring
the module rationale:

- *Multiple-altitude documents mean producing the same content
  in different shapes.* The ADR is the durable, engineering-
  altitude copy of the decision; the executive memo is the
  one-page copy. Both exist.
- *ADRs are read once, archived.* The writing bar is set for
  the archived read, not the live meeting; precision matters
  more than warmth.

### What stays out of scope

The architect-tier answer **does not** write the executive memo
(deferred to Exercise 1), produce the C4 diagram set (deferred
to Exercise 2), build the stakeholder map (deferred to Exercise
4), or assemble the ARB pre-read packet (deferred to Exercise
5). The ADR links to those artifacts; it does not inline them.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names ADRs as one of the artifact
choices the architect commits to and separately names the
"technical deep-dive for senior engineers" (10–30 pages, trade-
offs, alternatives, implementation considerations, risks). This
exercise consolidates the structured version of that engineering-
audience content into the ADR template committed in
`../../../architecture-templates/architecture-decision-records/adr-template.md`.
The learner-visible title for this exercise is "ADRs
Application"; this file carries the ADR depth and defers the
other artifacts to Exercises 1, 2, 4, and 5.

## Implementation

Implementation of the ADR lands as a versioned Markdown file in
the architecture repository:

1. **ADR file** — Markdown using the local ADR template at
   `../../../architecture-templates/architecture-decision-records/adr-template.md`,
   with every section populated.
2. **ADR number** — assigned from the project's ADR index,
   sequential; the governance system from `mod-301/exercise-4`
   is the registry.
3. **Status lifecycle** — the ADR enters as *Proposed*, moves
   to *Accepted* on decision ratification, and is updated to
   *Deprecated* or *Superseded* only via a new ADR, never by
   silent edit.
4. **Cross-links** — links to the executive memo (Exercise 1),
   the diagram set (Exercise 2), and the pre-read packet
   (Exercise 5) when they exist; links to related ADRs under
   *Related decisions*.
5. **Risks table** — populated with likelihood, impact, and
   mitigation per risk. For AI/ML platforms, at least one row
   per applicable NIST AI RMF function and the relevant OWASP
   ML Top 10 and MITRE ATLAS categories.
6. **Validation block** — proof-of-concept notes, named expert
   reviewers, and success metrics; metrics phrased as outcomes
   (per the module rationale), not activities.
7. **Governance hook** — the ADR is reviewed via pull request
   by the owner's lead and any affected stakeholders; the
   status transition from *Proposed* to *Accepted* follows the
   governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the ADR. Confirm every section from the template is
   present and populated. A missing or empty section is a fail
   signal.
2. Confirm the Decision section leads with *"we will"* and a
   single sentence; details follow as a list.
3. Confirm at least two alternatives are analyzed with pros,
   cons, and the reason each was not chosen.
4. Confirm the Consequences section separates positive and
   negative, and includes a risks table with likelihood,
   impact, and mitigation per row.
5. Confirm the Validation block names success metrics phrased
   as outcomes, not activities.
6. Confirm *Status*, *Date*, *Decision Makers*, and
   *Stakeholders* are all populated in the header.
7. Confirm *Related decisions* links to any superseded ADRs or
   companion ADRs; isolated ADRs with no cross-link usually
   indicate missing context.
8. For an AI/ML platform decision, confirm the Risks table
   carries at least one framework-mapped row (NIST AI RMF /
   OWASP ML Top 10 / MITRE ATLAS as applicable).
9. Confirm `<!-- research-pending: ... -->` markers are present
   for any factual claim that could not be verified at write
   time.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Template coverage | Every template section populated | Any section missing or empty |
| Decision clarity | "We will" sentence leads; details follow | Decision buried in prose |
| Alternatives | 2+ alternatives with pros / cons / reason not chosen | "We chose X because it was best" |
| Consequences | Positive, negative, and risks table present | Only one of the three |
| Risk scoring | Likelihood, impact, mitigation per row | Risks listed without scoring |
| Validation | Success metrics phrased as outcomes | Activity-phrased or absent |
| Header completeness | Status / Date / Decision Makers / Stakeholders populated | Any missing |
| Cross-links | Memo / diagrams / pre-read linked; related ADRs linked | Isolated ADR |
| AI/ML risks | Framework-mapped risk rows when platform is AI/ML | AI/ML risks absent when applicable |
| Research markers | `research-pending` for unverified claims | Unverified claims presented as fact |
| Form | Versioned Markdown via PR | Google Doc or wiki page only |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the ADR deliverable:

1. **Decision buried in prose.** The module's "memos that bury
   the recommendation" failure applies to ADRs too; a reader
   who cannot find the Decision statement in one scan has an
   ADR that cannot be cited.
2. **Alternatives named but not analyzed.** Listing three
   alternatives with no pros / cons is not an alternatives
   analysis; the Decision section's justification depends on
   the alternatives having been actually evaluated.
3. **Consequences without a risks table.** Positive and
   negative consequences without a scored risks table do not
   let a reviewer tell which risks are real; the ADR is
   non-auditable.
4. **Validation without metrics.** "We will measure success"
   is not a success metric. The outcome / activity split from
   the module rationale applies here: name the outcome, with
   a target.
5. **Status drift.** An ADR left in *Proposed* long after the
   decision was taken, or a *Superseded* ADR that still shows
   *Accepted*, is institutional memory that lies. The governance
   hook is the fix.
6. **AI/ML risks absent.** On an AI/ML platform decision, the
   NIST AI RMF function the decision serves and at least one
   OWASP ML Top 10 or MITRE ATLAS category should appear in the
   Risks table or References; silence is a fail signal.
7. **One document, all audiences.** The ADR is for the
   engineering audience; the one-page summary for executives is
   the memo from Exercise 1. An ADR that tries to also be a
   board brief loses the audience that reads ADRs.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
- Local ADR template:
  `../../../architecture-templates/architecture-decision-records/adr-template.md`
- Local stakeholder-communication kit:
  `../../../guides/stakeholder-communication.md`
