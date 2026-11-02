# SOLUTION — Exercise 3: Chaos Engineering Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-305-ha-dr/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **DR drill plan**
discipline — *DR drills run quarterly, with a documented caller,
test scope, success criteria, and rollback* — and extends it in
the direction the module names under "when to go beyond": *adopt
chaos engineering for HA verification*. The architect-tier
answer is a program plan that commits to a drill cadence, a
chaos-engineering frame for HA verification between drills, and
the measurement surface that proves the HA and DR designs
(exercises 1–2) actually behave as claimed.

The module rationale is explicit that DR drills are expensive
and politically hard to schedule, and that *backups that aren't
tested* and *DR plans on a shelf* are dominant failures. Chaos
engineering is how the architecture is verified continuously, so
the quarterly drill is a confirmation rather than a discovery.

## 2. Worked answer

A passing chaos engineering submission produces one program plan
with four named sections, mirroring the module rationale's drill
deliverables and the "go beyond" chaos extension:

1. **DR drill plan** — the quarterly drill with caller, scope,
   success criteria, and rollback.
2. **Chaos engineering frame** — the HA verification regime
   that runs between drills.
3. **Measurement surface** — the signals that confirm RPO/RTO
   targets (from exercise 2) and HA posture (from exercise 1)
   are met.
4. **Failure-mode coverage** — the top failure modes the
   program exercises and the lineage back to the runbook
   library (exercise 4).

### DR drill plan

The module rationale lists the four questions the drill plan
must answer:

- **Who calls the drill** — the named role (not a person) with
  the authority to invoke; the backup caller; the escalation
  path if the caller is unavailable.
- **Test scope** — the specific failure mode under test and
  the systems in scope. Scope creep during a drill masks
  learnings.
- **Success criteria** — the measurable outcomes that count as
  pass, drawn from the RPO/RTO matrix (exercise 2) and HA
  targets (exercise 1).
- **Rollback** — the procedure to return to steady state,
  including the reverse-replication path from exercise 2.

The cadence is quarterly; the plan names the next four dates
and the owner for each. The module rationale accepts that
*drills are expensive and politically hard to schedule* — the
plan surfaces that cost rather than hiding it.

### Chaos engineering frame

The module names *adopt chaos engineering for HA verification*
in the "when to go beyond" section. The frame covers:

- **Blast radius** — what the chaos run is allowed to perturb.
  Non-production first; production chaos only after a stated
  readiness gate.
- **Steady state** — the system behavior that must hold during
  the experiment; the signals used to detect deviation.
- **Hypothesis** — the specific HA behavior being verified
  (e.g., "AZ loss triggers quorum failover within N seconds
  with no write errors").
- **Abort criteria** — the signals that halt the experiment
  before user impact becomes material.
- **Learning capture** — the mechanism that turns findings
  into runbook updates (exercise 4) and architecture tickets.

The frame is HA-scoped: chaos verifies the exercise-1 design.
DR verification stays in the quarterly drill because the DR
mechanism (cross-region failover) is too expensive to run as
chaos.

### Measurement surface

The program is only credible if HA and DR behavior is
measurable. The surface names:

- **RPO measurement** — the replication-lag signal per data
  class; the alert threshold tied to the exercise-2 lag budget.
- **RTO measurement** — the elapsed time from fault injection
  to recovered steady state; the drill and chaos runs both
  emit this signal.
- **Failover signals** — the per-component signals that confirm
  the mechanism (DNS flip, LB health, quorum promotion) fired
  as designed.
- **False-positive rate** — chaos should not trigger
  user-visible pages that are not real; the surface tracks
  this so the program does not degrade on-call quality.

### Failure-mode coverage

The module rationale frames exercise 4's runbook library as
*the top 10 expected failure modes*. The chaos program's
coverage table lists each failure mode, the mechanism that
exercises it, and the frequency:

| Mode | Mechanism | Frequency |
| --- | --- | --- |
| Instance death | Pod/VM kill | Weekly chaos |
| AZ loss | Zone evacuation | Monthly chaos |
| Dependency timeout | Latency / fault injection | Weekly chaos |
| Region loss | Controlled failover | Quarterly drill |
| Data corruption | Restore-from-backup drill | Quarterly drill |
| Ransomware / tamper | Immutable backup restore | Semi-annual drill |

Each entry references the matching runbook so coverage and
runbook maintenance stay in sync.

### AI/ML specifics

The program verifies AI/ML components, not only transactional
services. The submission names which chaos experiments and
drills exercise:

- **Model serving** — replica loss, autoscaler failure, model
  rollback.
- **Model artifact store** — artifact fetch failure during
  serving pod boot.
- **Embedding / vector store** — shard loss and rebuild path.
- **Feature store** — online tier staleness and failover.
- **Observability** — ability to detect AI/ML-specific
  regressions when the measurement surface itself degrades.

The NIST AI RMF *Measure* function anchors this: measurement
without a verified measurement surface is unreliable, which is
exactly the gap chaos engineering closes.

### Decision rationale

A combined drill + chaos program is the right altitude because
the module rationale lists DR drills as a core deliverable and
calls out chaos engineering as the HA-verification extension.
Trade-offs the submission should explicitly accept, mirroring
the module rationale:

- Drills are expensive and politically hard; the plan budgets
  them and names the caller.
- Chaos cannot verify DR without full-scope failover, which is
  expensive; the division of labor between chaos (HA) and
  drills (DR) is intentional.
- A chaos program that pages the on-call rotation falsely will
  be turned off; the false-positive signal is tracked.

### What stays out of scope

The architect-tier answer **does not** reproduce exercise 1's
HA topology, exercise 2's DR plan, exercise 4's runbooks, or
exercise 5's self-healing automation. The goal here is the
verification program that proves the other exercises hold up.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` enumerates the "DR drill plan" as
`(exercise 04)` in its older module-level deliverables rationale,
while its per-exercise table maps Exercise 3 to **Chaos
Engineering Application**. This file is Exercise 3 and carries
the drill + chaos program jointly, because quarterly DR drills
and continuous HA-verification chaos share a measurement
surface, abort criteria, and readiness-gate posture — splitting
them creates duplicated infrastructure and a weaker signal.
Runbook library content sits in exercise-4; beyond-the-reference
automation in exercise-5. Failure-injection guardrails cite the
AWS, GCP, and Azure Well-Architected Reliability guidance in §6.

## Implementation

Implementation of the chaos / drill program lands as versioned
architecture assets, not as a running experiment:

1. **DR drill plan document** — Markdown in the architecture
   repository naming the caller role (plus backup and
   escalation), test scope, success criteria mapped to the
   RPO/RTO matrix and HA targets, and the rollback procedure.
   The next four quarterly dates and owners are listed.
2. **Chaos experiment catalog** — structured Markdown with one
   entry per experiment covering blast radius, steady-state
   signal, hypothesis, abort criteria, and the readiness gate
   that permits production execution. Aligned with the AWS,
   GCP, and Azure Well-Architected Reliability guidance on
   failure injection cited in §6.
3. **Measurement surface specification** — the signals the
   program depends on: RPO lag per data class, RTO elapsed
   time, per-component failover signals (DNS flip, LB health,
   quorum promotion), and false-positive rate.
4. **Failure-mode coverage table** — the matrix of modes →
   mechanism → frequency → runbook lineage, so coverage and
   runbook maintenance stay in sync with exercise 4.
5. **AI/ML coverage addendum** — chaos experiments for model
   serving, model artifact store, embedding / vector store,
   feature store, and the observability surface itself.
6. **Governance hook** — any new experiment that touches
   production requires an ADR via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the drill plan. Confirm it names the caller role,
   backup caller, test scope, success criteria, and rollback.
   Confirm the next four quarterly dates and owners are listed.
2. Confirm success criteria map back to the RPO/RTO matrix
   (exercise 2) and HA targets (exercise 1). Criteria without
   lineage are aspirational.
3. Open the chaos frame. Confirm each named experiment has
   blast radius, steady state, hypothesis, and abort criteria.
   An experiment without an abort criterion is a fail signal.
4. Confirm the measurement surface emits signals for RPO lag,
   RTO elapsed time, and failover mechanism firing. Confirm
   false-positive rate is tracked.
5. Confirm the failure-mode coverage table ties each mode to
   the matching runbook from exercise 4.
6. Confirm AI/ML-specific components (model serving, artifact
   store, embeddings, feature store) are covered — not only
   generic compute and database.
7. Confirm production chaos has a stated readiness gate; chaos
   that starts in production without one is the dominant real
   failure.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Drill caller | Named role + backup + escalation | "The team" |
| Drill criteria | Lineage to RPO/RTO + HA targets | Freeform narrative |
| Chaos experiments | Blast radius, steady state, hypothesis, abort each named | "We'll kill some pods" |
| Measurement surface | RPO lag, RTO elapsed, failover signals, false-positive rate | Drill timing only |
| Coverage table | Modes → mechanism → runbook mapping | Drill scope ad-hoc |
| AI/ML coverage | Serving, artifact store, embeddings, features | Transactional DB only |
| Production readiness | Explicit gate for prod chaos | Prod from day one |
| Form | Versioned Markdown + structured data | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see":

1. **Backups that aren't tested.** The dominant real failure.
   The drill plan must include a restore drill, not just a
   failover drill.
2. **DR plans on a shelf.** A plan nobody has rehearsed is a
   plan nobody can execute. The quarterly cadence exists to
   prevent this.
3. **Chaos without abort criteria.** Experiments that cannot be
   halted will produce production incidents and get the
   program cancelled.
4. **No lineage to targets.** Success criteria must map to
   RPO/RTO (exercise 2) and HA targets (exercise 1); otherwise
   drills validate nothing.
5. **AI/ML blind spots.** Chaos that only kills generic
   workloads misses model artifact fetch failure, embedding
   shard loss, and feature-store staleness — all of which are
   known AI/ML failure modes.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- NIST SP 800-34 Rev. 1, *Contingency Planning Guide for Federal
  Information Systems* —
  <https://csrc.nist.gov/pubs/sp/800/34/r1/upd1/final>
- AWS Well-Architected Framework — Reliability Pillar —
  <https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html>
- Google Cloud Architecture Framework — Reliability —
  <https://cloud.google.com/architecture/framework/reliability>
- Microsoft Azure Well-Architected Framework — Reliability —
  <https://learn.microsoft.com/en-us/azure/well-architected/reliability/>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
