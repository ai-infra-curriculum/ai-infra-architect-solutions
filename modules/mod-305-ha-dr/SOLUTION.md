# SOLUTION — HA and DR

> Read this *after* you have designed the reference HA/DR
> architecture. This document explains the architect-tier
> resilience frame and acts as a high-level index for the
> per-exercise solutions in this directory.

## Per-exercise solutions

The rationale below is factored into per-exercise `SOLUTION.md`
files. Start here for orientation, then go to the exercise file
that matches the deliverable you are reviewing.

| Exercise | Topic | File |
| --- | --- | --- |
| Exercise 1 | HA Patterns Application | [`exercise-1/SOLUTION.md`](exercise-1/SOLUTION.md) |
| Exercise 2 | DR Planning Application | [`exercise-2/SOLUTION.md`](exercise-2/SOLUTION.md) |
| Exercise 3 | Chaos Engineering Application | [`exercise-3/SOLUTION.md`](exercise-3/SOLUTION.md) |
| Exercise 4 | Self-Healing Application (Runbook Library) | [`exercise-4/SOLUTION.md`](exercise-4/SOLUTION.md) |
| Exercise 5 | Self-Healing Application (Beyond-the-Reference Posture) | [`exercise-5/SOLUTION.md`](exercise-5/SOLUTION.md) |

The legacy `exercise-01/` … `exercise-05/` directories remain as
pointer READMEs into the learning repository; the depth lives in
the new `exercise-1/` … `exercise-5/` directories above.

## What this module is really teaching

High availability and disaster recovery are usually conflated
and rarely tested. The reference solutions separate the two:
- **HA**: surviving expected failures (instance death, AZ
  outage) without user impact.
- **DR**: surviving unexpected catastrophes (region outage,
  data corruption, ransomware) with bounded RPO/RTO.

## What the deliverables should actually look like

### RPO / RTO matrix (exercise 01)

Per-application: target Recovery Point Objective (data loss
tolerance) and Recovery Time Objective (downtime tolerance).
Tier-1 critical apps: RPO ≤ 5 min, RTO ≤ 15 min. Lower tiers
relax these.

### Multi-AZ architecture (exercise 02)

Tier-1 services run in 3+ AZs with replicas spread. Stateful
data uses synchronous replication within region. The reference
diagrams the topology with explicit failure-domain boundaries.

### Multi-region DR design (exercise 03)

For DR scope: how data replicates, how compute fails over, how
DNS / load balancers redirect. The reference uses asynchronous
cross-region replication + warm-standby compute for tier-1.

### DR drill plan (exercise 04)

DR drills run quarterly. The plan documents: who calls the
drill, what the test scope is, what success criteria are, what
the rollback is.

### Runbook library (exercise 05)

Runbooks for the top 10 expected failure modes. Each runbook is
exercised in DR drills and updated based on findings.

## Trade-offs we deliberately accepted

- Multi-region doubles much infrastructure cost.
- Async replication means non-zero RPO.
- DR drills are expensive and politically hard to schedule.

## Common mistakes graders see

1. **Backups that aren't tested**: don't actually restore.
2. **DR plans on a shelf**: nobody knows the steps when needed.
3. **RPO/RTO unrealistic vs. architecture**: targets that
   physically can't be met.
4. **No backup of the DR runbook itself**: locked into the
   primary's wiki.

## When to go beyond this implementation

- Adopt **chaos engineering** for HA verification.
- Move to **active/active multi-region** for tier-0 services.
- Add **immutable backups** for ransomware defense.

## Related curriculum touchpoints

- ``senior-engineer/mod-207-observability-sre`` — incident
  management.
- ``architect/projects/project-301-enterprise-mlops`` —
  enterprise resilience.
