# SOLUTION — Enterprise Architecture

> Read this *after* you have attempted the strategic deliverables.
> This document explains the *enterprise architect* lens and acts
> as a high-level index for the per-exercise solutions in this
> directory.

## Per-exercise solutions

The rationale below is factored into per-exercise `SOLUTION.md`
files. Start here for orientation, then go to the exercise file
that matches the deliverable you are reviewing.

| Exercise | Topic | File |
| --- | --- | --- |
| Exercise 1 | TOGAF Application | [`exercise-1/SOLUTION.md`](exercise-1/SOLUTION.md) |
| Exercise 2 | ADM Application | [`exercise-2/SOLUTION.md`](exercise-2/SOLUTION.md) |
| Exercise 3 | Zachman Application | [`exercise-3/SOLUTION.md`](exercise-3/SOLUTION.md) |
| Exercise 4 | Governance Application | [`exercise-4/SOLUTION.md`](exercise-4/SOLUTION.md) |
| Exercise 5 | Stakeholder Management Application | [`exercise-5/SOLUTION.md`](exercise-5/SOLUTION.md) |

The legacy `exercise-01/` … `exercise-05/` directories remain as
pointer READMEs into the learning repository; the depth lives in
the new `exercise-1/` … `exercise-5/` directories above.

## What this module is really teaching

Enterprise architecture is system design at the *organization*
level: which capabilities the business should have, how they
should compose, and which standards make that composition
possible. The exercises target deliverable shapes — capability
maps, architecture documents, reference architectures — rather
than implementation code.

## What the deliverables should actually look like

Each bullet below is the spine of the matching per-exercise
file. The exercise file carries the worked example, validation
steps, rubric, and references.

### Capability map and reference architecture → exercises 1 & 2 (TOGAF, ADM)

A capability map is a 2-3 layer hierarchy of *what* the org
does, not *how*. Each capability has an owner team. The
discipline: map the business, not the org chart.

A reference architecture document at the enterprise tier
includes:
- Capability mapping.
- System inventory with capability assignments.
- Integration patterns (event-driven, API, batch).
- Cross-cutting concerns (identity, observability, data
  governance).
- Future state vs. current state, with a migration path.

TOGAF (exercise 1) organizes the deliverables under the
Business / Data / Application / Technology content framework.
ADM (exercise 2) is the method that sequences the work and
produces the migration path.

### Cross-cutting concerns review → exercise 3 (Zachman)

Identity / observability / security / cost / data-governance
need consistent treatment across all systems. The reference's
cross-cutting review template enforces this. Zachman's grid is
the classification tool that forces the architect to think
about every concern from every perspective exactly once.

### Architecture decision records → exercise 4 (Governance)

Every significant architectural decision gets an ADR with
context / decision / consequences / alternatives-considered.
ADRs are version-controlled. The reference uses Markdown +
GitHub conventions, not a separate tool. Exercise 4 wraps the
ADR template in the broader governance system (triage rubric,
cross-cutting review template, supersession mechanism).

### Architecture review board prep → exercise 5 (Stakeholder Management)

ARB packages document the change, its alternatives, the
recommendation, and the implementation plan. The deliverable is
one PDF a busy executive can read in 15 minutes. Exercise 5
wraps that package in the stakeholder map and communication plan
that make it operable.

## Trade-offs we deliberately accepted

- ADRs over heavy enterprise-architecture tools (TOGAF, Archi).
- Markdown-based documents over PDF — version-control is the
  audit trail.
- Capability maps stay simple (≤30 top-level capabilities).

## Common mistakes graders see

1. **Capability maps that are org charts**.
2. **Reference architectures that don't show *current* state**
   — only the aspirational future.
3. **ADRs missing the alternatives-rejected section**.
4. **Cross-cutting concerns treated per-system, inconsistently**.

## When to go beyond this implementation

- Adopt **C4 model** diagrams for clarity at scale.
- Move to **arc42** template if the team prefers heavier
  structure.

## Related curriculum touchpoints

- ``principal-architect/mod-601-org-wide-architecture`` — the
  next altitude.
- ``architect/projects/project-301-enterprise-mlops`` — the
  enterprise architecture in practice.
