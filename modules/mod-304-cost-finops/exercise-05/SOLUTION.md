# SOLUTION — Exercise 05: Workload-Level Optimization Playbook (Optimization Application)

Reference for the matching learning exercise
[`lessons/mod-304-cost-finops/exercises/exercise-5.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-5.md).
See also the module-level rationale in [`../SOLUTION.md`](../SOLUTION.md).

## 1. Solution overview

The learning prompt is a generic "apply optimization to a real
architecture problem." At the architect tier — per the module
SOLUTION — exercise 05's deliverable is a **per-workload optimization
playbook**: a collection of named patterns each platform team applies
to its own workloads, with the embedded FinOps champion (exercise 02)
as the owner.

A complete submission produces:

1. A **playbook table** of named patterns, when each applies, and
   what each costs to apply.
2. **Per-pattern worked notes** — at minimum: spot-instance
   handling, right-sizing, scheduled scaling, cache hit-rate
   improvement.
3. A **prioritization rubric** for picking which pattern to apply
   first on a given workload.
4. A **stakeholder deck** that frames the playbook as a champion's
   tool, not a central-team mandate.

## 2. Worked answer

### 2a. The reference patterns (from the module SOLUTION)

| Pattern | When it applies | Architect-tier concern |
|---|---|---|
| Spot-instance handling | Interruptible workloads — async batch, training jobs with checkpointing. | Checkpoint frequency, restart cost, fallback to on-demand. |
| Right-sizing | Workloads provisioned against peak instead of observed P95/P99. | Risk of right-sizing into a regression; need observability before the change. |
| Scheduled scaling | Workloads with a predictable daily / weekly cycle (e.g., business-hours-only dev). | Failure mode when the schedule and the actual traffic diverge. |
| Cache hit-rate improvement | Workloads where downstream cost (model inference, DB queries, embedding lookups) scales with cache misses. | Cache invalidation correctness — the optimization must not break behavior. |

### 2b. Prioritization rubric

For a given workload, the champion picks patterns in this order:

1. **Right-size first.** Cheapest to apply; reveals the real
   baseline that other patterns are tuning against.
2. **Schedule next** if the workload has a predictable cycle.
3. **Spot** for the interruptible portion of the right-sized
   baseline.
4. **Cache** when the downstream cost (per the per-service feed
   from exercise 01) shows a meaningful tail.

The architect-tier point is sequencing: applying spot before right-
sizing locks in waste on cheaper instances.

### 2c. Ownership model

The playbook is the **embedded champion's** tool (exercise 02). The
central FinOps team maintains the playbook; the champion decides
which pattern to apply on which workload, with the service owner.
Central FinOps does not optimize workloads directly — it would
not survive past a handful of services if it tried.

### 2d. Trade-off the architect must own

Optimization has carry cost — engineering time spent on cost work
is engineering time not spent on product. The playbook must say
*when to stop optimizing a workload* (typically when projected
savings fall below a configured threshold relative to engineer
time).

## 3. Validation steps

- [ ] At least the four module-SOLUTION patterns are named with
      conditions and concerns.
- [ ] Prioritization rubric is sequenced — not a flat list.
- [ ] Ownership: champion applies, central FinOps maintains.
- [ ] Stopping criterion for "this workload is optimized enough"
      is named.
- [ ] Each pattern names a failure mode (checkpoint cost, schedule
      drift, cache invalidation, right-sizing regression).

## 4. Rubric

| Criterion (weight) | Excellent | Adequate | Insufficient |
|---|---|---|---|
| Architecture quality (40%) | Four patterns with conditions, concerns, and failure modes; sequenced prioritization; named stopping criterion. | Patterns listed without sequencing or failure modes. | Pattern list without when-to-apply guidance. |
| Documentation (30%) | Per-pattern worked notes a champion can act on without further architect input. | Patterns described at the level of "right-size your instances." | Bullet list of pattern names. |
| Strategic thinking (20%) | Ownership model (champion applies, central maintains) is explicit. Carry-cost / stopping criterion is named. | Ownership stated but stopping criterion missing. | Optimization framed as a one-time project. |
| Communication (10%) | Deck frames the playbook as the champion's tool. | Deck pitches the playbook as a central mandate. | Architect notes only. |

## 5. Common mistakes

1. **Spot-first.** Applying spot before right-sizing locks in
   waste on cheaper instances.
2. **Right-sizing without observability.** Cutting capacity to
   match P50 instead of P95/P99 and getting paged the next week.
3. **Scheduled scaling that ignores drift.** A business-hours-
   only schedule survives until traffic patterns shift; without
   a feedback loop it quietly under-serves.
4. **Cache "improvements" that break correctness.** The fastest
   way to save inference cost is to serve stale outputs; the
   playbook must guard against that.
5. **No stopping criterion.** Engineering time chasing diminishing
   savings becomes its own cost. This is the architect-tier
   discipline the exercise is teaching.

## 6. References

- Learning exercise: [`lessons/mod-304-cost-finops/exercises/exercise-5.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-5.md)
- Module-level architect-tier framing: [`../SOLUTION.md`](../SOLUTION.md) §"Workload-level optimization playbook (exercise 05)"
- Coupled components in this module:
  - [`../exercise-01/SOLUTION.md`](../exercise-01/SOLUTION.md) — supplies the per-service spend feed that surfaces cache / right-sizing opportunities.
  - [`../exercise-02/SOLUTION.md`](../exercise-02/SOLUTION.md) — defines the embedded champion who owns playbook application.

<!-- needs-research: cite the cloud-provider spot/preemptible best-practice docs (AWS Spot, GCP Preemptible / Spot VMs, Azure Spot VMs) and a vetted right-sizing reference (FinOps Foundation or cloud provider) once verified links are available. -->
