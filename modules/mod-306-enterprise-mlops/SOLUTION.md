# SOLUTION — Enterprise MLOps

> Read this *after* you have designed the reference enterprise
> MLOps platform. This document explains the architect-tier
> view of enterprise-scale MLOps and acts as a high-level index
> for the per-exercise solutions in this directory.

## Per-exercise solutions

The rationale below is factored into per-exercise `SOLUTION.md`
files. Start here for orientation, then go to the exercise file
that matches the deliverable you are reviewing.

| Exercise | Topic | File |
| --- | --- | --- |
| Exercise 1 | MLOps Architecture Application | [`exercise-1/SOLUTION.md`](exercise-1/SOLUTION.md) |
| Exercise 2 | Model Governance Application | [`exercise-2/SOLUTION.md`](exercise-2/SOLUTION.md) |
| Exercise 3 | Feature Stores Application | [`exercise-3/SOLUTION.md`](exercise-3/SOLUTION.md) |
| Exercise 4 | Real-time Serving Application | [`exercise-4/SOLUTION.md`](exercise-4/SOLUTION.md) |
| Exercise 5 | Real-time Serving Application (Operating Model + Beyond-the-Reference) | [`exercise-5/SOLUTION.md`](exercise-5/SOLUTION.md) |

The legacy `exercise-01/` … `exercise-05/` directories remain as
pointer READMEs into the learning repository; the depth lives in
the new `exercise-1/` … `exercise-5/` directories above.

## What this module is really teaching

Engineer / senior-engineer MLOps tracks (mod-106, mod-206) cover
the technical capability. The architect tier adds:
- Org-wide platform governance.
- Cross-team ML platform standards.
- Compliance and risk classification for ML systems.
- Vendor / build decisions for the platform.

## What the deliverables should actually look like

### Platform architecture document (exercise 01)

Layered architecture: data layer, feature layer, training layer,
serving layer, observability layer, governance layer. Each layer
has owner team, technology choice, integration interface.

### Build-vs-buy decision (exercise 02)

For each capability, decide: build in-house, adopt OSS, buy
vendor. The deliverable has explicit cost / control trade-offs
per capability.

### MLOps maturity model (exercise 03)

The reference uses a 5-level maturity scale (manual / partial
automation / repeatable / measured / optimizing). The deliverable
assesses the current state per capability + 18-month target.

### Risk-tiering for ML systems (exercise 04)

ML systems classified by:
- Decision impact (financial / safety).
- Affected population.
- Reversibility.

Risk tier drives review depth, audit cadence, approval gate.

### Platform team operating model (exercise 05)

Centralized vs. embedded vs. federated platform team. The
reference recommends embedded-platform-engineers + central-
tooling-team for orgs with 50+ ML engineers.

## Trade-offs we deliberately accepted

- Enterprise patterns are slower than startup patterns.
- Heavy governance can frustrate data scientists.
- Build-vs-buy decisions need revisiting every 18 months.

## Common mistakes graders see

1. **MLOps platform built without product-management
   discipline**: features added because engineers wanted them,
   not because customers needed them.
2. **Maturity model never re-assessed**: aspirational, not
   actionable.
3. **Risk tiering applied unevenly**: some teams claim "low
   risk" for high-impact systems.
4. **Platform team disconnected from customers** (data
   scientists, ML engineers).

## When to go beyond this implementation

- Adopt **platform-as-product** discipline (DORA / Team
  Topologies).
- Move to **internal developer platform** (Backstage) as the
  unifying interface.
- Add **EU AI Act risk classification** for regulated workloads.

## Related curriculum touchpoints

- ``architect/projects/project-301-enterprise-mlops`` — the
  reference project.
- ``ml-platform`` track entirely — the platform-team-side
  view.
