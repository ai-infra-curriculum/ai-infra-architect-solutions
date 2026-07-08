# SOLUTION — Exercise 01: Cost-Attribution Architecture (FinOps Application)

Reference for the matching learning exercise
[`lessons/mod-304-cost-finops/exercises/exercise-1.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-1.md).
See also the module-level rationale in [`../SOLUTION.md`](../SOLUTION.md).

## 1. Solution overview

The learning exercise is a generic "apply FinOps to a real architecture
problem" prompt. At the architect tier, the concrete deliverable behind
that prompt is the one named in the module SOLUTION as exercise 01:
**a cost-attribution architecture** that lets the business see and
attribute spend to the team and workload that created it.

A complete submission produces three artifacts:

1. A **tagging policy** that names the required tags, who owns each
   one, and how the tag is enforced at provisioning time.
2. An **attribution pipeline** that moves cloud billing data into a
   warehouse and out to per-team dashboards.
3. A **stakeholder slide deck** that translates (1) and (2) into
   business value — what changes for finance, what changes for
   engineering leadership.

## 2. Worked answer

### 2a. Tagging policy (the core of the deliverable)

Per the module SOLUTION, every resource is tagged with:

| Tag           | Owner               | Enforcement point                        |
|---------------|---------------------|------------------------------------------|
| `environment` | Platform team       | IaC module / provisioning policy          |
| `team`        | Engineering manager | IaC module / provisioning policy          |
| `service`     | Service owner       | IaC module                                |
| `cost-center` | Finance             | IaC module — required field, no default   |
| `workload-type` | Service owner     | IaC module (`batch` / `online` / `dev`)   |
| `model-name`  | Model owner (ML)    | Training/inference job template           |

Enforcement is at provisioning, not after the fact. Resources without
the full tag set are rejected by the IaC pipeline or admission policy.

### 2b. Attribution pipeline

```
cloud billing export → object store → warehouse (daily ingest)
                                       │
                                       ├── per-team dashboard
                                       ├── per-workload dashboard
                                       └── anomaly-detection feed
```

The pipeline is intentionally one-way and idempotent: re-ingesting a
day's billing export produces the same dashboards. Tag-coverage % is a
first-class metric on the dashboard — leadership sees how much spend
is correctly attributed and how much is "unattributed."

### 2c. Stakeholder-facing framing

The slide deck (per the learning file's Task 4) should lead with what
changes for the audience, not the architecture diagram:

- Finance: every dollar lands in a cost-center.
- Engineering leadership: per-team cost is visible and comparable.
- Service owners: their workload's cost is a number they can move.

### 2d. Trade-offs the architect should call out

From the module SOLUTION: **tagging discipline requires enforcement
and we accept the friction.** A submission that hides this trade-off
behind "we'll just educate teams" misses the point.

## 3. Validation steps

A grader walks the submission through this checklist:

- [ ] Tagging policy names every tag in the table above, with owner
      and enforcement point.
- [ ] Enforcement is at *provisioning*, not a periodic sweep.
- [ ] Attribution pipeline shows source (billing export), sink
      (warehouse), and consumers (dashboards). Re-ingestion is
      idempotent.
- [ ] Tag-coverage % is itself a dashboard metric, not a one-time
      audit.
- [ ] Stakeholder deck has a slide each for finance, engineering
      leadership, and service owners — not a generic exec summary.
- [ ] Trade-off: the friction of mandatory tags is acknowledged.

## 4. Rubric

Weights match the learning file's evaluation criteria.

| Criterion (weight) | Excellent | Adequate | Insufficient |
|---|---|---|---|
| Architecture quality (40%) | All six tags + owner + enforcement point named; pipeline is idempotent; tag-coverage is a first-class metric. | Tags listed but ownership or enforcement is vague; pipeline shown end-to-end. | Tags as suggestions; no enforcement; pipeline missing source or sink. |
| Documentation (30%) | Tagging policy reads like something a service owner could follow on day one; dashboards drawn with intended consumer named. | Policy and pipeline diagrams present but require interpretation. | Diagrams without policy text, or policy without diagrams. |
| Strategic thinking (20%) | Trade-off (tagging friction) acknowledged; coverage % framed as a leadership KPI. | Trade-off mentioned in passing. | Trade-off omitted; tagging treated as a one-time setup task. |
| Communication (10%) | Stakeholder deck tailored to finance / leadership / service owners separately. | Single generic deck. | Architect-only artifacts; no stakeholder framing. |

## 5. Common mistakes

From the module SOLUTION (graders see these repeatedly):

1. **Tagging policy without enforcement.** The single most common
   failure mode. A policy doc nobody enforces is no policy.
2. **Cost dashboards no one looks at.** Build the dashboard for a
   named consumer (the team lead's weekly review) or don't build it.
3. Skipping ML-specific tags (`model-name`, `workload-type`) and
   then being unable to answer "which model is driving our spend?"
4. Treating tag-coverage % as a one-time clean-up project instead of
   a standing operational metric.

## 6. References

- Learning exercise: [`lessons/mod-304-cost-finops/exercises/exercise-1.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-1.md)
- Module-level architect-tier framing: [`../SOLUTION.md`](../SOLUTION.md) §"Cost-attribution architecture (exercise 01)"
- Related curriculum: `mlops/08-production-ops`, `architect/projects/project-301-enterprise-mlops` (per module SOLUTION §"Related curriculum touchpoints").

<!-- needs-research: cite the FinOps Foundation tagging-policy guidance and at least one cloud-provider cost-allocation-tag reference (AWS / GCP / Azure) once a vetted link is available. -->
