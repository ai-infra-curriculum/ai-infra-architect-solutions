# SOLUTION — Multi-Cloud and Hybrid

> Read this *after* you have designed the reference multi-cloud
> architecture. This document explains the architect-tier lens on
> multi-cloud / hybrid topologies and acts as a high-level index
> for the per-exercise solutions in this directory.

## Per-exercise solutions

The rationale below is factored into per-exercise `SOLUTION.md`
files. Start here for orientation, then go to the exercise file
that matches the deliverable you are reviewing.

| Exercise | Topic | File |
| --- | --- | --- |
| Exercise 1 | Multi-cloud Strategy Application | [`exercise-1/SOLUTION.md`](exercise-1/SOLUTION.md) |
| Exercise 2 | Hybrid Cloud Application | [`exercise-2/SOLUTION.md`](exercise-2/SOLUTION.md) |
| Exercise 3 | Vendor Selection Application | [`exercise-3/SOLUTION.md`](exercise-3/SOLUTION.md) |
| Exercise 4 | Migration Application (Strategy) | [`exercise-4/SOLUTION.md`](exercise-4/SOLUTION.md) |
| Exercise 5 | Migration Application (Execution) | [`exercise-5/SOLUTION.md`](exercise-5/SOLUTION.md) |


## What this module is really teaching

The senior-engineer track (mod-205) teaches the technical
implementation of multi-cloud. The architect tier focuses on
**when to choose** multi-cloud at all:
- Sovereign-cloud / data-residency mandates.
- Vendor concentration risk.
- M&A leaving the org on multiple clouds.
- Workload-specific cost differentials.

## What the deliverables should actually look like

Each bullet below is the spine of the matching per-exercise
file. The exercise file carries the worked example, validation
steps, rubric, and references.

### Multi-cloud decision document → exercise 1

The deliverable answers:
- Why multi-cloud, specifically?
- Active/active, active/passive, or federated?
- What's the data master?
- What's the ops cost?

If the document can't answer "why specifically multi-cloud," the
decision is wrong.

### Reference topology / hybrid integration → exercise 2

On-prem + cloud requires explicit connectivity (Direct Connect,
ExpressRoute, Interconnect) and identity bridging. The
deliverable enumerates patterns for synchronous vs. async
integration and the per-workload residency pin.

### Vendor selection and cost comparison → exercise 3

Per-workload TCO across clouds, including hidden costs (data
egress, support tiers, professional services). The deliverable
is a weighted scorecard plus a spreadsheet-style TCO model
with documented assumptions.

### Migration strategy → exercise 4

Existing single-cloud to multi-cloud: which workloads move
first, which never move, what the rollback plan is. The
deliverable is a classification register plus a one-page
strategy.

### Migration execution → exercise 5

The execution altitude for the strategy from exercise 4:
sequenced waves with dependency gates, cutover runbooks, and
metric-gated advancement that keeps every intermediate state
operable.

## Trade-offs we deliberately accepted

- Multi-cloud has a real ops tax.
- LCD (lowest common denominator) services lose features.
- Architecture team has to maintain N-cloud expertise.

## Common mistakes graders see

1. **Multi-cloud chosen for resilience without a triggering
   event**: doubles cost without value.
2. **Data master ambiguous**: split-brain incidents.
3. **No exit strategy if multi-cloud doesn't pay off**.
4. **Federated identity not designed; manual sync forever**.

## When to go beyond this implementation

- Consider **sovereign-cloud** specifics (China cloud, Govcloud).
- Move to **multi-region single-cloud** if the requirement is
  geographic, not vendor.

## Related curriculum touchpoints

- ``senior-engineer/mod-205-multi-cloud`` — the engineering
  view.
- ``architect/projects/project-302-multicloud-infra`` — the
  user-facing project.
