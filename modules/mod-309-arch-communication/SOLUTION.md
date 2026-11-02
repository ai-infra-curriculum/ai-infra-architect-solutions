# SOLUTION — Architectural Communication

> Read this *after* you have attempted the architectural-
> communication deliverables. This document explains the
> architect-tier communication frame and acts as a high-level
> index for the per-exercise solutions in this directory.

## Per-exercise solutions

The rationale below is factored into per-exercise `SOLUTION.md`
files. Start here for orientation, then go to the exercise file
that matches the deliverable you are reviewing.

| Exercise | Topic | File |
| --- | --- | --- |
| Exercise 1 | Executive Comms Application | [`exercise-1/SOLUTION.md`](exercise-1/SOLUTION.md) |
| Exercise 2 | Visual Communication Application | [`exercise-2/SOLUTION.md`](exercise-2/SOLUTION.md) |
| Exercise 3 | ADRs Application | [`exercise-3/SOLUTION.md`](exercise-3/SOLUTION.md) |
| Exercise 4 | Stakeholder Management Application (audience mapping) | [`exercise-4/SOLUTION.md`](exercise-4/SOLUTION.md) |
| Exercise 5 | Stakeholder Management Application (pre-read / ARB) | [`exercise-5/SOLUTION.md`](exercise-5/SOLUTION.md) |

The legacy `exercise-01/` … `exercise-05/` directories remain as
pointer READMEs into the learning repository; the depth lives in
the new `exercise-1/` … `exercise-5/` directories above.

## What this module is really teaching

Architecture decisions that aren't communicated well don't
land. The architect's communication skill includes:
- Picking the right artifact (memo, slide, diagram, ADR).
- Picking the right altitude per audience.
- Translating "engineering" into "business" without losing
  signal.

## What the deliverables should actually look like

### Audience map (stakeholder mapping — exercise 4)

For a given architecture proposal, who needs to be persuaded?
What's their altitude? What format do they consume?

### Strategy memo for executives (executive comms — exercise 1)

One page. State the decision, the alternatives, the
recommendation, the ask. Executives want decisions, not
expositions.

### Technical deep-dive for senior engineers

10-30 pages. Trade-offs, alternatives, implementation
considerations, risks. Engineers want detail. In this module
the deep-dive content lives inside the ADRs exercise (3) and
the pre-read packet (exercise 5); it is not a standalone
deliverable.

### Architecture diagram set (visual communication — exercise 2)

C4 model: context diagram, container diagram, component
diagram, code (optional). Different altitudes for different
conversations.

### Pre-read packet for ARB (stakeholder management — exercise 5)

Distributed 48 hours before the meeting. Includes context,
proposal, alternatives, recommendation, supporting analysis.
ARB members come prepared.

### Architecture Decision Records (ADRs — exercise 3)

The durable "why" artifact. Context, decision, alternatives,
consequences, status. ADRs are the artifact that answers "why
did we choose X?" two years after the decision.

## Trade-offs we deliberately accepted

- One-page memos require painful editing.
- Multiple-altitude documents mean producing the same content
  in different shapes.
- Diagrams age fast and need maintenance.

## Common mistakes graders see

1. **One document, all audiences**: serves none well.
2. **Diagrams too dense**: nobody reads them.
3. **Memos that bury the recommendation**.
4. **Pre-reads sent the morning of**: nobody prepares.

## When to go beyond this implementation

- Adopt **diagram-as-code** (Structurizr, Mermaid) for
  version-controlled diagrams.
- Move to **video walkthroughs** for async-first orgs.

## Related curriculum touchpoints

- ``principal-architect/mod-601-org-wide-architecture`` —
  presentation patterns at higher altitude.
- ``senior-engineer/mod-210-technical-leadership`` — peer-
  audience communication.
- Local supporting material: `../../guides/stakeholder-communication.md`
  (reusable kit, audience table, anti-patterns) and
  `../../architecture-templates/architecture-decision-records/adr-template.md`
  (ADR template used by Exercise 3).
