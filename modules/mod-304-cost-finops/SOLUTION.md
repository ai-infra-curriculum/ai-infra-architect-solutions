# SOLUTION — Cost and FinOps

> Read this *after* you have built the reference FinOps
> infrastructure. This document explains the architect-tier
> cost-management frame and acts as a high-level index for the
> per-exercise solutions in this directory.

## Per-exercise solutions

The rationale below is factored into per-exercise `SOLUTION.md`
files. Start here for orientation, then go to the exercise file
that matches the deliverable you are reviewing.

| Exercise | Topic | File |
| --- | --- | --- |
| Exercise 1 | FinOps Application | [`exercise-1/SOLUTION.md`](exercise-1/SOLUTION.md) |
| Exercise 2 | TCO Analysis Application | [`exercise-2/SOLUTION.md`](exercise-2/SOLUTION.md) |
| Exercise 3 | Cost Allocation Application | [`exercise-3/SOLUTION.md`](exercise-3/SOLUTION.md) |
| Exercise 4 | Optimization Application (Cost Anomaly Detection) | [`exercise-4/SOLUTION.md`](exercise-4/SOLUTION.md) |
| Exercise 5 | Optimization Application (Workload Playbook) | [`exercise-5/SOLUTION.md`](exercise-5/SOLUTION.md) |

The legacy `exercise-01/` … `exercise-05/` directories remain as
pointer READMEs into the learning repository; the depth lives in
the new `exercise-1/` … `exercise-5/` directories above.

## What this module is really teaching

ML workloads are unusually expensive. The architect's job is to
design a cost-management capability that lets the business see,
attribute, forecast, and optimize spend.

## What the deliverables should actually look like

Each bullet below is the spine of the matching per-exercise
file. The exercise file carries the worked example, validation
steps, rubric, and references.

### Cost-attribution architecture → exercise 1 (FinOps Application)

Every resource is tagged with: environment, team, service, cost-
center, workload-type, model-name (for ML). Tagging is enforced
at provisioning. The deliverable is the tagging policy + the
attribution pipeline (cloud billing -> warehouse -> per-team
dashboards).

### FinOps team structure → exercise 2 (TCO Analysis Application)

The reference defines:
- Central FinOps team for tooling, dashboards, anomaly
  detection.
- Embedded FinOps champions per platform team.
- Quarterly review cadence with engineering leadership.

### Reserved-capacity strategy → exercise 3 (Cost Allocation Application)

Reserved instances / savings plans / committed-use discounts:
which to choose, what coverage % to target, how to handle
forecast uncertainty.

### Cost-anomaly detection → exercise 4 (Optimization Application — Cost Anomaly Detection)

Daily anomaly detection on per-service spend with PagerDuty
escalation for runaway costs. The reference uses cloud-native
anomaly detection (AWS Cost Anomaly Detection / GCP equivalent)
augmented with custom rules for ML workloads.

### Workload-level optimization playbook → exercise 5 (Optimization Application — Workload Playbook)

Per-workload optimization patterns: spot-instance handling,
right-sizing, scheduled scaling, cache hit-rate improvement.

## Trade-offs we deliberately accepted

- Tagging discipline requires enforcement (we accept the
  friction).
- Reserved capacity is a forecast bet.
- Cost anomaly detection has false-positives.

## Common mistakes graders see

1. **Cost dashboards no one looks at**.
2. **Tagging policy without enforcement**.
3. **Over-commitment to reservations**: pay for unused
   capacity.
4. **No on-call for cost anomalies**: a $50k/day runaway runs
   for a week.

## When to go beyond this implementation

- Adopt **showback / chargeback** beyond pure attribution.
- Integrate **carbon-footprint accounting** alongside cost.

## Related curriculum touchpoints

- ``mlops/08-production-ops`` — ML-specific cost concerns.
- ``architect/projects/project-301-enterprise-mlops`` —
  enterprise FinOps in context.
