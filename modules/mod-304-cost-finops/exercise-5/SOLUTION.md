# SOLUTION — Exercise 5: Optimization Application (Workload Playbook)

> Pairs with
> `ai-infra-architect-learning/lessons/mod-304-cost-finops/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **workload-level
optimization playbook** deliverable: *per-workload optimization
patterns — spot-instance handling, right-sizing, scheduled
scaling, cache hit-rate improvement.* The architect-tier
answer is a reusable catalogue of patterns, keyed to the
tagging schema from exercise 1 and the detection signals from
exercise 4, so the organization can act on waste as it is
seen rather than re-invent the response per team.

The module rationale frames workload-level optimization as the
last mile of FinOps: attribution (exercise 1) tells you what
spend exists, team structure (exercise 2) decides who owns it,
reservations (exercise 3) absorb steady-state, and anomaly
detection (exercise 4) catches drift. Exercise 5 is where
decisions turn into changes — spot adoption, right-sizing,
scheduled scale-down, and cache tuning — against a catalogue
that specifies when each pattern applies and what the exit
criteria are.

## 2. Worked answer

A passing optimization-playbook submission produces three
linked artefacts:

1. **Pattern catalogue** — the four module-named patterns
   (spot, right-sizing, scheduled scaling, cache hit-rate),
   each with scope, mechanism, and exit criteria.
2. **Applicability matrix** — which patterns apply to which
   workload class from the exercise-1 tag schema.
3. **Operating cadence** — how patterns move from the
   catalogue into production work, tied to the quarterly
   review (exercise 2) and the anomaly surface (exercise 4).

### Pattern catalogue

Each pattern is a self-contained entry. The catalogue entries
below pull from the module rationale; the deliverable is the
catalogue, not improvisation.

#### Spot-instance handling

- **Scope** — training workloads, batch inference, offline
  evaluation, non-latency-sensitive stages of ML pipelines.
- **Mechanism** — bid on spot / preemptible capacity with
  checkpoint-and-resume plumbing; fall back to on-demand on
  sustained preemption.
- **Pre-conditions** — the workload must be able to resume
  from checkpoint without consistency damage; blast radius of
  a mid-run preemption must be bounded.
- **Exit criteria** — move off spot when latency SLO cannot
  tolerate preemption, or when spot availability deteriorates
  below a stated threshold.
- **Risks** — long-running jobs amplify preemption cost
  without checkpointing; spot pricing can invert during
  demand peaks.

#### Right-sizing

- **Scope** — any workload with sustained utilisation below
  a stated utilisation floor (CPU, memory, GPU memory, GPU
  SMs).
- **Mechanism** — profile actual utilisation over a stable
  window, propose a right-sized instance class or
  configuration, roll out behind a controlled change.
- **Pre-conditions** — observability must expose
  utilisation at the right granularity; GPU workloads need
  GPU-specific metrics.
- **Exit criteria** — stop when further right-sizing crosses
  a performance guardrail (latency, throughput, batch
  completion).
- **Risks** — right-sizing against a short window picks up
  seasonality; right-sizing without a performance guardrail
  trades cost for incident risk.

#### Scheduled scaling

- **Scope** — development, staging, sandbox, and any
  production workload with a predictable demand curve.
- **Mechanism** — schedule scale-down (and spin-down for
  non-prod) outside business hours or outside the demand
  window; schedule warm-up ahead of expected demand.
- **Pre-conditions** — the workload's warm-up latency must
  be acceptable; dependencies must survive the scaled-down
  state.
- **Exit criteria** — stop when demand becomes 24/7 or when
  warm-up latency breaches SLO.
- **Risks** — unscheduled traffic lands against the scaled-
  down footprint; downstream dependencies that cannot be
  scaled block the pattern.

#### Cache hit-rate improvement

- **Scope** — inference workloads, retrieval surfaces,
  feature stores — anywhere a cache miss drives downstream
  cost.
- **Mechanism** — raise hit rate via key design, TTL tuning,
  pre-warming, and request-shape normalisation; measure the
  cost delta against the downstream service.
- **Pre-conditions** — cache telemetry must expose hit
  rate, size, and eviction cause.
- **Exit criteria** — stop when further hit-rate increase
  requires cache size growth whose cost offsets the saving,
  or when cache-staleness tolerance is breached.
- **Risks** — aggressive caching leaks stale state;
  warming at request time inverts the saving.

### Applicability matrix

The matrix maps the four patterns onto the workload classes
from exercise 1 (via `workload-type` and `environment`
tags):

| Workload class | Spot | Right-sizing | Scheduled scaling | Cache hit-rate |
| --- | --- | --- | --- | --- |
| Steady-state inference (prod) | No | Yes | Partial (regional) | Yes |
| Steady-state platform services (prod) | No | Yes | Partial | Yes |
| Scheduled training (prod) | Yes | Yes | Yes | n/a |
| Burst training | Yes | Yes | Yes | n/a |
| Dev / staging / sandbox | Yes | Yes | Yes | Yes |

The matrix is advisory; the champion from exercise 2 picks
the pattern on evidence from the attribution pipeline and
anomaly surface.

### Operating cadence

Patterns move from the catalogue into production work via
stated rhythms:

- **Anomaly-driven** — a cost-anomaly alert (exercise 4)
  routes the champion to the applicable pattern via the
  runbook pointer.
- **Quarterly review** — the exercise-2 leadership review
  reviews pattern adoption and sets the next quarter's
  optimization priorities per workload class.
- **Pattern authoring** — new patterns are added to the
  catalogue only when evidence from attribution or anomaly
  surfaces justifies them; the catalogue is kept small on
  purpose.
- **Rollback stance** — every pattern application has a
  rollback plan; the exercise-4 anomaly surface is the signal
  that a pattern application is making things worse.

### AI/ML risk anchoring

Workload-level optimization intersects model behaviour. The
NIST AI RMF *Measure* function tracks the performance
guardrails each pattern names; right-sizing against stale
metrics or caching against drifting inputs can breach quality
without a cost dashboard noticing. The OWASP ML Top 10 and
MITRE ATLAS adversary catalogues highlight that
inference-cost reductions can expose a model to more
exhaustive querying (model theft) or inversion; the pattern
catalogue flags where optimization widens an attack surface so
the security partner from exercise 2 is in the loop.

### Decision rationale

A fixed catalogue of four patterns with an applicability
matrix is the right altitude because the module rationale
names those four patterns directly and because the discipline
is to *apply the catalogue*, not to re-invent. Trade-offs the
learner should accept:

- **Small catalogue, strict discipline.** New patterns are
  not added casually.
- **Patterns are not stacked without evidence.** Combining
  all four at once risks hiding failures from each.
- **Rollback is a design input.** Every pattern application
  can be reversed.

### What stays out of scope

The architect-tier answer **does not** operate the
attribution pipeline (exercise 1), structure the FinOps team
(exercise 2), set reservation posture (exercise 3), or build
anomaly detection (exercise 4). The goal here is the
pattern catalogue and its operating cadence.

## Implementation

Implementation of the optimization-playbook artefacts lands as
versioned architecture assets:

1. **Pattern catalogue document** — Markdown in the
   architecture repository, one entry per pattern with
   scope, mechanism, pre-conditions, exit criteria, and
   risks.
2. **Applicability matrix** — structured file (Markdown
   table or CSV) tying patterns to workload classes.
3. **Runbook pointers** — every anomaly-detection alert
   (exercise 4) links to the applicable pattern entry.
4. **Rollback template** — a per-pattern rollback checklist
   referenced from each application.
5. **Quarterly review input** — the pattern-adoption summary
   that feeds the exercise-2 leadership review.
6. **Governance hook** — new patterns, or materially
   changed existing ones, require an ADR via the governance
   system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the pattern catalogue. Confirm all four module-named
   patterns are present (spot, right-sizing, scheduled
   scaling, cache hit-rate) with scope, mechanism, exit
   criteria, and risks.
2. Open the applicability matrix. Confirm it ties patterns
   to workload classes from exercise 1 and that
   latency-sensitive production workloads are not marked
   spot-eligible.
3. Confirm each anomaly-detection alert from exercise 4
   links to the applicable pattern via a runbook pointer.
4. Confirm every pattern application has a rollback plan;
   the exercise-4 surface is the signal to invoke it.
5. Confirm the quarterly-review input exists so pattern
   adoption is visible to leadership (exercise 2).
6. Confirm the catalogue is small; new entries required
   evidence and an ADR.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Pattern catalogue | All four module patterns, each with scope / mechanism / exit / risks | Narrative without exit criteria |
| Applicability matrix | Workload-class × pattern grid tied to exercise-1 tags | Patterns applied globally |
| Runbook pointers | Alerts link to pattern entries | Alerts without actions |
| Rollback | Named per pattern | "Revert the change" |
| Review cadence | Pattern-adoption summary feeds exercise-2 review | Patterns applied without visibility |
| Catalogue discipline | Small, evidence-driven | Patterns proliferate |
| AI/ML risk framing | Performance guardrails + adversary surface named | Optimization treated as pure cost |
| Form | Versioned Markdown + structured matrix | Slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
section:

1. **Patterns without exit criteria.** Right-sizing without
   a performance guardrail trades cost for incident risk;
   spot without a preemption-SLO exit converts a
   latency-sensitive workload into an unstable one.
2. **Spot on latency-sensitive production.** The scope of
   the spot pattern is bounded on purpose; the matrix is
   the enforcement.
3. **Patterns applied without rollback.** The exercise-4
   anomaly surface is the signal to roll back; without a
   plan, the signal is lost.
4. **Stacked patterns.** Combining all four at once hides
   whether any single pattern delivered.
5. **Optimization decoupled from governance.** The pattern
   catalogue is a governed artefact; changes without ADRs
   convert the catalogue into opinion.

## 6. References

- FinOps Foundation — FinOps Framework overview —
  <https://www.finops.org/framework/>
- FinOps Foundation — *Workload Optimization* capability
  (right-sizing, scheduling, usage reduction) —
  <https://www.finops.org/framework/capabilities/workload-optimization/>
- FinOps Foundation — *Cloud Policy & Governance*
  capability (pattern catalogues as governed artefacts) —
  <https://www.finops.org/framework/capabilities/policy-governance/>
- AWS — Spot Instances best practices and interruption
  handling —
  <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html>
- AWS Compute Optimizer — right-sizing recommendations —
  <https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is-compute-optimizer.html>
- Google Cloud — Spot VM best practices —
  <https://cloud.google.com/compute/docs/instances/spot>
- Microsoft Azure — Scheduled autoscaling and start/stop
  patterns for cost savings —
  <https://learn.microsoft.com/azure/cost-management-billing/manage/vm-usage-based-savings>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
