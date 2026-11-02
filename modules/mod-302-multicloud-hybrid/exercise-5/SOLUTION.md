# SOLUTION — Exercise 5: Migration Application (Execution)

> Pairs with
> `ai-infra-architect-learning/lessons/mod-302-multicloud-hybrid/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **migration
strategy** deliverable at the *execution* altitude — the
"how", given the "why / when" from exercise 4. The
architect-tier answer is a sequenced wave plan with cutover
runbooks, dependency gates, and the operability guarantees the
module rationale asks of any migration path.

The module rationale accepts a migration plan only if the
intermediate states are operable; *big-bang cutover* is a fail
signal. This exercise is where the learner shows that the
classified move / stay / defer workloads from exercise 4 are
sequenced into waves that respect dependencies and leave the
platform working at every step.

## 2. Worked answer

A passing migration-execution submission produces three linked
artefacts:

1. **Wave plan** — sequenced waves of workloads with
   dependencies, exit criteria, and intermediate operability
   guarantees.
2. **Cutover runbooks** — per-workload or per-pattern runbook
   covering pre-cutover, cutover, verification, and rollback.
3. **Metrics and go/no-go gates** — the quantitative gates
   between waves, so the plan advances on signal rather than
   schedule.

### Wave plan

The wave plan is a sequenced register with one row per wave.
Each row names:

- **Workloads in the wave** — drawn from the exercise-4
  classification register, with the *move first* class
  typically dominating wave 1.
- **Dependencies cleared** — the identity, networking,
  observability, and data couplings that must be in place
  before the wave begins.
- **Entry criteria** — the state the platform must be in to
  start the wave.
- **Exit criteria** — the measurable state that signals the
  wave is complete.
- **Intermediate operability guarantee** — the explicit
  statement of what still works, and how, while the wave is
  in flight.
- **Estimated duration and effort** — bounded; waves that
  cannot be bounded indicate missing dependency analysis.

A canonical wave sequence for a multi-cloud / hybrid AI/ML
platform:

| Wave | Content | Operability guarantee |
| --- | --- | --- |
| Wave 0 | Foundations — identity federation (per exercise 2), observability federation, connectivity, policy baselines | No workloads move; foundations are pre-conditions |
| Wave 1 | Low-coupling *move first* workloads — batch inference, offline eval | Prior serving path remains live until Wave 1 passes exit criteria |
| Wave 2 | *Move with care* — online inference under traffic shadowing / canary | Rollback to prior serving within the exercise-4 window |
| Wave 3 | *Move last* — platform services and system-of-record integrations | Dual-run with reconciliation; no data loss acceptable |
| Steady state | *Never move* workloads remain; integration patterns from exercise 2 carry the hybrid boundary | Platform operates as the target steady state |

The *defer* class from exercise 4 is not in the wave plan; it
is handled by a sibling program (rewrite / retire).

### Cutover runbooks

Each runbook covers:

1. **Pre-cutover** — data prepared, mirror running,
   dependencies verified, stakeholders notified. Explicit
   checklist, not prose.
2. **Cutover sequence** — ordered steps with the single
   decision point at the end of each step (continue / pause /
   roll back).
3. **Verification** — the signals that confirm the cutover
   succeeded (latency, error rate, correctness checks, user
   journeys), with the time window.
4. **Rollback** — invokes the exercise-4 reversibility design;
   explicit about the rollback trigger, path, and window.
5. **Communications** — who is told what, when, with the
   escalation path.

A failure mode the module rationale implies: runbooks written
only for the happy path. Each step names what pauses the
cutover and what rolls it back.

### Metrics and go/no-go gates

Between waves, the plan advances on signal. Minimum signals:

- **Operational**: SLOs for the migrated workloads meeting or
  exceeding the pre-migration baseline for a stated
  observation window.
- **Cost**: the realized spend on the new cloud matches the
  exercise-3 TCO within an agreed tolerance; variance beyond
  the tolerance pauses the next wave.
- **Compliance**: control mappings re-verified at the new
  trust boundary; evidence captured.
- **AI/ML quality**: evaluation metrics (accuracy, latency,
  cost per inference, drift signals) within or above
  pre-migration bounds, aligned with NIST AI RMF *Measure*.

### AI/ML risk anchoring

Migration execution surfaces specific ML risks:

- **Model-serving skew** — the destination's model artefacts
  must match the origin's; verification compares output
  distributions on a held-out set before promoting traffic.
- **Training-data lineage** — lineage must survive the move;
  waves that move training infrastructure must prove the
  lineage graph is intact before advancing.
- **Adversary-technique revalidation** — OWASP ML Top 10 and
  MITRE ATLAS techniques mitigated at origin must be
  re-mitigated at destination; the wave's exit criteria list
  which techniques were re-validated.
- **Prompt / response log continuity** — serving-side logs
  must flow to the unified evaluation surface regardless of
  which cloud is serving mid-wave; otherwise *Measure* and
  *Manage* lose coverage.

### Decision rationale

A wave plan with explicit exit criteria plus per-pattern
runbooks is the right altitude because the module rationale
demands operability at every intermediate state. Trade-offs
the learner should accept:

- Waves add duration; big-bang would be faster but fail the
  module's operability test.
- Dual-run periods (Wave 3) are expensive; the cost is
  budgeted and reflected in the exercise-3 TCO.
- Metric-gated advancement surfaces real risk; schedules
  slip when metrics do not clear, and the plan must survive
  that honestly.

### What stays out of scope

The architect-tier answer **does not** author per-step
Terraform, pick cutover timestamps, or deliver change-advisory
tickets; those are downstream of the plan. The goal is the
executable *shape* of the migration — waves, gates, runbooks,
operability — with enough detail to produce the detailed
schedule.

## Implementation

Implementation of the migration-execution artefacts lands as
versioned architecture assets:

1. **Wave plan register** — structured file with one row per
   wave; linked to the exercise-4 classification register.
2. **Cutover runbook template** — the structure every runbook
   follows, with the five sections above.
3. **Per-workload / per-pattern runbooks** — one per migrating
   workload class or integration pattern (exercise 2).
4. **Metrics and gates document** — the operational, cost,
   compliance, and AI/ML quality signals that gate each wave,
   with the observation windows.
5. **Communications plan** — who gets told, when; references
   the stakeholder-management discipline from
   `mod-301/exercise-5`.
6. **AI/ML risk mapping** — references NIST AI RMF functions
   and OWASP ML Top 10 / MITRE ATLAS techniques per wave, so
   the trust-boundary revalidation is explicit.
7. **Governance hooks** — wave transitions are gated by ARB
   review (per `mod-301/exercise-5`) and recorded as ADRs
   (per `mod-301/exercise-4`).

## 3. Validation steps

1. Open the wave plan. Confirm Wave 0 covers foundations
   (identity federation, observability federation,
   connectivity) before any workloads move.
2. Confirm each wave has entry criteria, exit criteria, and an
   intermediate operability guarantee; a wave without an
   operability guarantee is a fail by the module rationale.
3. Open any runbook. Confirm it covers pre-cutover, cutover,
   verification, **rollback**, and communications. Rollback
   missing is the single most common fail.
4. Confirm every wave has go/no-go gates with observation
   windows; schedule-only advancement is a fail.
5. Confirm the AI/ML risk mapping lists OWASP ML Top 10 /
   MITRE ATLAS techniques re-validated at each wave boundary,
   and that NIST AI RMF *Measure* signals gate advancement.
6. Confirm wave transitions reference the governance system
   (ADR + ARB) from `mod-301`.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Wave 0 foundations | Identity / observability / connectivity before any workload moves | Workloads moved onto unfederated platform |
| Entry / exit criteria | Both present per wave, measurable | Prose "wave is done" |
| Intermediate operability | Explicit statement per wave | Big-bang cutover |
| Runbook completeness | Pre / cutover / verification / **rollback** / comms | Rollback section missing |
| Go/no-go gates | Operational, cost, compliance, AI/ML quality signals with windows | Schedule-only advancement |
| AI/ML risk | OWASP ML / ATLAS techniques revalidated per wave, NIST AI RMF *Measure* gating | AI treated as generic |
| Governance hooks | Wave transitions via ADR + ARB | Un-reviewed advancement |
| Form | Versioned Markdown + structured data | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders
see":

1. **Big-bang cutover.** The module rationale is explicit that
   intermediate states must be operable; no wave plan without
   operability guarantees passes.
2. **Rollback missing.** Mirrors the exercise-4 failure mode;
   the runbook has to invoke a *reversibility design*, not
   invent one on the day.
3. **Schedule-only advancement.** The gates must be
   measurable, not calendar-driven; otherwise a slipping
   migration pulls the next wave off a cliff.
4. **No foundations wave.** Moving workloads before identity
   and observability federation are in place guarantees the
   failure modes the module rationale calls out.
5. **AI treated as generic.** Model artefact portability,
   training-data lineage, adversary-technique revalidation,
   and prompt-log continuity are the ML-specific gates the
   execution plan must enforce; without them the migration
   can succeed on infrastructure signals while silently
   degrading the ML surface.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
