# SOLUTION — Exercise 2: Visual Communication Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-309-arch-communication/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **architecture
diagram set** deliverable — *"C4 model: context diagram,
container diagram, component diagram, code (optional). Different
altitudes for different conversations."* — to a concrete
AI-platform diagram set. The architect-tier answer is not a
single all-you-can-eat diagram; it is a *set* of diagrams, each
at a specific altitude, each paired to a specific audience from
the stakeholder map.

The module rationale pins visual communication to altitude per
audience and names "diagrams too dense" as a top grader-visible
failure. This exercise is where the learner produces the C4 set
that lets Exercises 1, 3, and 5 refer to a shared visual
reference without redrawing it each time.

## 2. Worked answer

A passing visual-communication submission produces one versioned
diagram set with four named levels, mirroring the module
rationale's C4 fields:

1. **System context diagram** — the system and the external
   actors / systems it interacts with. The altitude for
   executive and non-technical audiences.
2. **Container diagram** — the deployable units inside the
   system boundary and the technology choices per container.
   The altitude for engineering leadership and ARB review.
3. **Component diagram** — the significant components inside a
   container and their responsibilities. The altitude for
   engineering peers inside the owning team.
4. **Code diagram (optional)** — class / module-level detail,
   only when a specific component warrants it. Usually
   generated, not hand-drawn.

The C4 set is the shared visual spine; the memo from
[`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md),
the ADR from [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md),
and the pre-read packet from
[`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md)
each link to the level that matches their audience.

### Altitude per audience

The module rationale is explicit: *"different altitudes for
different conversations."* The audience table in
`../../../guides/stakeholder-communication.md` names the
altitudes per audience; a passing diagram set maps them:

- **Executive sponsor** → system context diagram, maybe one
  annotated container diagram if the proposal has material
  topology implications. Never the component level.
- **Finance / CFO partner** → system context diagram with the
  cost-attribution boundaries highlighted (the diagram cross-
  references the cost model, not the component layer).
- **Engineering peer / ARB** → container diagram as the primary
  artifact; component diagrams for the parts of the system that
  are the subject of the decision.
- **Security review board** → container diagram with trust
  boundaries annotated; the detail belongs in a threat model,
  not in a denser C4 diagram.

A diagram set that does not map levels to audiences repeats the
module's "one document, all audiences" failure in visual form.

### Diagram-as-code

The module rationale names *"adopt diagram-as-code (Structurizr,
Mermaid) for version-controlled diagrams"* in its "when to go
beyond this implementation" field, but at the architect tier
versioning is table stakes. The submission commits:

- **Source-controlled diagrams** — the diagram files are the
  source of truth, in Mermaid, Structurizr DSL, or equivalent.
  PNG / PDF exports are build artifacts, not primary sources.
- **Build-step rendering** — diagrams rebuild from source as
  part of the documentation build so stale images do not
  mislead.
- **Review via diff** — diagram changes land in pull requests
  and are reviewed as code; a diagram change that bypasses
  review is a fail signal.

### Diagrams age fast

The module rationale accepts the trade-off that *"diagrams age
fast and need maintenance."* The submission commits an explicit
ownership and refresh policy per diagram: the owner's role, the
refresh trigger (quarterly, or on container/component change),
and the deprecation path when a diagram no longer matches
reality. An out-of-date diagram is worse than no diagram
because stakeholders act on it; the governance hook here is
non-optional.

### Legend, scope, and date

Every diagram carries a legend (shape → kind), a scope note
(what the diagram includes and excludes), and a last-reviewed
date. These three fields are what let a diagram survive
rotation; without them the viewer has to guess, and the
guesses diverge across audiences — the asymmetric-disclosure
anti-pattern surfacing as a visual artifact.

### AI/ML-specific considerations

When the architecture being drawn is an AI/ML platform, the
diagram set surfaces the governance surfaces the audience will
look for:

- **NIST AI Risk Management Framework** — the container diagram
  shows the data-flow boundaries the *Map* and *Measure*
  functions need to attach to (training data in, inference
  requests in, telemetry out). The audit path is drawn, not
  implied.
- **OWASP Machine Learning Security Top 10** — the component
  diagram for the model-serving path annotates the ingress
  (prompt / input filter) and egress (output filter) controls
  so the ML supply chain is visible, not buried.
- **MITRE ATLAS** — the component diagram for the LLM /
  retrieval path annotates the reconnaissance / detection
  surface so a security reviewer can match techniques to
  components.

The diagrams do not teach the frameworks; they surface the
surfaces the frameworks name so the viewer can trace a control
to a shape.

### Decision rationale

The C4 four-level diagram set is the right structure because
the module rationale names it directly for this deliverable and
because its altitude-per-level framing matches the altitude-per-
audience discipline the module teaches. Trade-offs the
submission should explicitly accept, mirroring the module
rationale:

- *Multiple-altitude documents mean producing the same content
  in different shapes.* The C4 set is deliberately redundant
  across levels; collapsing to one diagram defeats the model.
- *Diagrams age fast.* The governance hook is the mitigation,
  not a nice-to-have.
- *Diagrams too dense.* The architect's edit is to remove, not
  to add; a dense diagram fails the module's criterion even if
  it is technically accurate.

### What stays out of scope

The architect-tier answer **does not** write the executive memo
(deferred to Exercise 1), produce the ADR (deferred to Exercise
3), build the stakeholder map (deferred to Exercise 4), or
assemble the ARB pre-read packet (deferred to Exercise 5). The
goal here is the versioned C4 set other exercises point to.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names the visual-communication
deliverable as *"Architecture diagram set ... C4 model: context,
container, component, code (optional). Different altitudes for
different conversations."* The learner-visible title for this
exercise is "Visual Communication Application"; this file
carries the C4 set and the governance that keeps it current,
and defers the referenced artifacts (memo, ADR, map, pre-read)
to exercises 1, 3, 4, and 5.

## Implementation

Implementation of the diagram set lands as versioned diagram
sources, not as a running system:

1. **System context diagram** — Mermaid, Structurizr DSL, or
   equivalent; the system boundary, external actors, external
   systems.
2. **Container diagram** — the deployable units, technology
   choices, and inter-container protocols; one per deployable
   boundary.
3. **Component diagram** — one per container that is the
   subject of a decision; otherwise deferred until it is.
4. **Legend and scope block** — every diagram includes a legend
   (shape → kind), a scope note, and a last-reviewed date.
5. **AI/ML annotation layer** — on the container and component
   diagrams, the AI/ML control points (NIST AI RMF data-flow
   boundaries, OWASP ML Top 10 ingress / egress, MITRE ATLAS
   reconnaissance / detection surface) are annotated by shape or
   note.
6. **Refresh policy** — the owner, refresh trigger, and
   deprecation path for each diagram is declared in the
   documentation front-matter.
7. **Governance hook** — diagram changes land in pull requests
   reviewed by the owner; changes that cross the module-301
   ADR trigger (significant topology / technology choice) also
   require an ADR via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the C4 set. Confirm the context, container, and
   component levels are each present as separate diagrams.
   Component may be scoped per-container; "all four in one
   drawing" is a fail signal.
2. Confirm the system context diagram is the artifact linked
   from the executive memo (Exercise 1) and that the container
   diagram is the artifact linked from the ADR (Exercise 3) and
   the ARB pre-read (Exercise 5).
3. Confirm each diagram has a legend, a scope note, and a
   last-reviewed date.
4. Confirm the diagram sources are committed as code, not as
   PNG uploads; rendered PNG / SVG artifacts are build outputs.
5. Confirm refresh ownership and trigger are declared.
6. For an AI/ML platform, confirm the container diagram shows
   data-flow boundaries and the component diagram for the model
   serving path annotates ingress / egress controls.
7. Confirm diagrams are not denser than their altitude requires:
   the context diagram is scannable in seconds, the container
   diagram in a minute, the component diagram in a review.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Level completeness | Context, container, component each present | Any missing |
| Altitude mapping | Each level mapped to its audience | One diagram serving all audiences |
| Diagram-as-code | Source files in the repo; PNG/SVG are build outputs | PNG uploaded as primary artifact |
| Legend / scope / date | All three present on every diagram | Any absent |
| Density discipline | Context scannable in seconds; container in a minute | Dense diagrams at the top levels |
| Refresh policy | Owner, trigger, deprecation path declared | Policy absent |
| AI/ML annotations | Data-flow boundaries and control points annotated when applicable | ML risks invisible on the diagram |
| Cross-reference fit | Memo, ADR, pre-read point to the right levels | Audience viewing wrong altitude |
| Governance hook | Diagram changes reviewed; significant topology triggers ADR | Diagram-only changes bypass review |
| Form | Versioned source + rebuilt renders | PDF-only or screenshots |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the visual communication deliverable:

1. **Diagrams too dense.** The module rationale calls this out
   as a top failure. A single diagram with every component on
   it fails every audience; the C4 split is the fix.
2. **One diagram, all audiences.** The visual form of "one
   document, all audiences." Executive sponsors shown the
   component diagram tune out; engineering peers shown the
   context diagram feel talked down to.
3. **Diagrams out of date.** A diagram that no longer matches
   reality is worse than no diagram because stakeholders act on
   it. The refresh policy is the fix; without it the diagram
   set ages into a liability.
4. **PNG uploads as the source of truth.** Non-reviewable, non-
   diffable, and inevitably stale. Diagram-as-code is the
   module-named "when to go beyond" that at architect tier is
   table stakes.
5. **Missing legend or scope.** A diagram without a legend
   forces every viewer to guess; a diagram without a scope note
   invites the viewer to assume the diagram covers everything.
   Both produce silent misreads.
6. **AI/ML risks invisible.** On an AI/ML platform diagram, the
   ingress / egress safety controls, the training-data boundary,
   and the audit path should be visible on the diagram, not
   hidden in prose.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
- Local stakeholder-communication kit:
  `../../../guides/stakeholder-communication.md`
