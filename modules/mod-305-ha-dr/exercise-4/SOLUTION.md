# SOLUTION — Exercise 4: Self-Healing Application (Runbook Library)

> Pairs with
> `ai-infra-architect-learning/lessons/mod-305-ha-dr/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **runbook library**
deliverable — *runbooks for the top 10 expected failure modes;
each runbook is exercised in DR drills and updated based on
findings* — to the self-healing frame. The architect-tier answer
is a cataloged library of runbooks whose steps are precise
enough to automate, together with the decision record for which
runbooks are automated now, which stay human-executed, and why.

The module rationale is explicit that *DR plans on a shelf*
(nobody knows the steps when needed) and *no backup of the DR
runbook itself* (locked into the primary's wiki) are dominant
failures. Self-healing is the architectural answer: the runbook
is the specification, and automation turns high-signal, low-risk
runbooks into first-responder actions.

## 2. Worked answer

A passing self-healing submission produces one linked library
with four named sections, mirroring the module rationale's
runbook deliverable and the "when to go beyond" posture:

1. **Runbook library** — the top 10 expected failure modes with
   a per-mode runbook that meets a structured template.
2. **Automation posture** — per runbook, whether it is
   automated (self-healing), semi-automated (one-click), or
   human-executed; the rationale is explicit.
3. **Backup-of-runbook** — the hosting that survives the
   primary going down. The module rationale calls this out as
   a dominant failure.
4. **Drill lineage** — the pointer from each runbook into the
   exercise-3 drill or chaos experiment that keeps it current.

### Runbook library

The module rationale pins the library at the *top 10 expected
failure modes*. The submission names them, inheriting from the
HA (exercise 1) and DR (exercise 2) scope and the chaos coverage
table (exercise 3). A representative set covering the module's
named failure modes:

| # | Failure mode | Scope |
| --- | --- | --- |
| 1 | Instance / pod death | HA |
| 2 | AZ loss | HA |
| 3 | Dependency timeout / fault | HA |
| 4 | Autoscaler failure | HA |
| 5 | Model artifact fetch failure | HA (AI/ML) |
| 6 | Embedding shard loss | HA (AI/ML) |
| 7 | Region loss / failover | DR |
| 8 | Data corruption / restore from backup | DR |
| 9 | Ransomware / tamper restore | DR |
| 10 | Failback / reverse-replication | DR |

Each runbook meets a structured template:

- **Trigger** — the signal that invokes this runbook; must map
  to a measurement from the exercise-3 surface so false
  invocation is detectable.
- **Preconditions** — the system state the runbook assumes.
- **Steps** — ordered, idempotent actions. Each step names its
  success signal.
- **Rollback** — what to do if a step fails mid-run.
- **Verification** — the signals that confirm steady state is
  restored.
- **Owner** — the role that owns runbook correctness, not a
  person.
- **Last exercised** — the date and the exercise-3 event that
  last ran this runbook.

### Automation posture

The module names *adopt self-healing* implicitly in the runbook
library (runbooks that automate expected recovery) and
explicitly in the "when to go beyond" section with *chaos
engineering* and *active/active multi-region* as adjacent
practices. The automation decision per runbook is captured in a
table:

| Runbook | Posture | Rationale |
| --- | --- | --- |
| 1 Instance death | Automated | Idempotent, low blast radius, high frequency |
| 2 AZ loss | Automated | Health-check driven; identical to steady-state operation |
| 3 Dependency timeout | Automated with limits | Circuit breaker + retry budget; must not amplify |
| 4 Autoscaler failure | Semi-automated | Human confirms scaling decision |
| 5 Model artifact fetch | Automated with rollback | Serve previous version on fetch failure |
| 6 Embedding shard loss | Human | Rebuild cost / correctness risk is high |
| 7 Region loss | Human | High blast radius; drill-rehearsed |
| 8 Data corruption | Human | Point-in-time choice requires judgment |
| 9 Ransomware restore | Human | Immutable-backup validation step; forensic preservation |
| 10 Failback | Human | Reverse-replication state must be inspected |

The decision rule mirrors the module rationale: automate when
the action is idempotent, high-frequency, and has bounded blast
radius; keep humans in the loop when correctness or forensics
depends on judgment. Automating runbook 7 (region failover) is
flagged as a fail signal because the mechanism is too costly
and too rare to let an automated loop invoke it.

### Backup-of-runbook

The module rationale calls out *no backup of the DR runbook
itself; locked into the primary's wiki* as a dominant failure.
The library is hosted in a way that survives the primary going
down:

- **Primary host** — the engineering docs system, versioned
  and searchable in steady state.
- **DR host** — a copy that is reachable without the primary
  identity or network. The module rationale accepts the cost
  of this duplication explicitly.
- **Offline copy** — a cold copy printable or usable without
  any infrastructure dependency, for ransomware or
  identity-provider outage scenarios.
- **Freshness signal** — the DR and offline copies emit a
  staleness signal; a wiki that was last synced before the
  incident is worse than no copy.

### Drill lineage

Each runbook names the exercise-3 event — chaos experiment or
quarterly drill — that last exercised it. Runbooks not
exercised within their stated cadence are flagged as stale.
This closes the loop the module rationale demands:
*each runbook is exercised in DR drills and updated based on
findings*.

### AI/ML specifics

The library is not generic SRE boilerplate. The ML-specific
runbooks (5, 6, and parts of 8) address:

- **Model artifact fetch failure** — serve previous model
  version with a clear operator warning; do not fail-closed on
  the request path.
- **Embedding shard loss** — the rebuild path from source,
  with the service-degradation posture during rebuild and the
  staleness window named.
- **Prompt / response log restore** — compliance and incident
  forensics may require point-in-time restore of logs, not
  just transactional data.

The NIST AI RMF *Manage* function anchors runbook ownership:
response to AI/ML incidents is an architected function, not an
ad-hoc rediscovery each time.

### Decision rationale

A runbook library with explicit automation posture and a
backup-of-runbook plan is the right altitude because the module
rationale pins both. Trade-offs the submission should explicitly
accept, mirroring the module rationale:

- Automation reduces mean time to repair but can amplify
  incorrect actions; the automation decision is per-runbook,
  not blanket.
- Runbook maintenance is work; the drill lineage keeps it
  honest.
- Hosting the DR copy of the runbooks costs money and attention
  but is the lesson the module rationale explicitly surfaces.

### What stays out of scope

The architect-tier answer **does not** cover the drill program
itself (exercise 3) or the "beyond" posture of active/active
multi-region and immutable backups (exercise 5). The goal here
is the self-healing library — specification plus automation
decisions — tight enough that exercise 5 can commit to the
beyond-posture.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` labels the "Runbook library" as
`(exercise 05)` in its older module-level deliverables rationale,
while its per-exercise table maps Exercise 4 to **Self-Healing
Application (Runbook Library)**. This file is Exercise 4 and
carries the top-10-failure-modes runbook library plus per-runbook
automation posture; exercise-5 extends it with beyond-the-
reference posture (active/active, immutable backups,
chaos-in-production). Runbook content, failure-mode selection,
and automation gates are grounded in AWS, GCP, and Azure
Well-Architected Reliability guidance cited in §6.

## Implementation

Implementation of the self-healing library lands as versioned
architecture assets, not as a running responder:

1. **Runbook library** — one Markdown file per runbook under
   the architecture repository, each conforming to the
   structured template (trigger, preconditions, idempotent
   steps with success signals, rollback, verification, owner,
   last-exercised date). Top 10 failure modes covered, aligned
   with the AWS, GCP, and Azure Well-Architected Reliability
   operational-excellence guidance cited in §6.
2. **Automation posture table** — structured Markdown with one
   row per runbook stating posture (automated / semi /
   human) and rationale; automated region failover is rejected
   at review.
3. **Backup-of-runbook hosting** — the DR copy and the offline
   copy, each with a stated freshness signal. Hosting records
   the mechanism that keeps the DR copy reachable without the
   primary identity provider.
4. **Drill lineage record** — the mapping from each runbook to
   the exercise-3 chaos experiment or drill event that last
   exercised it; runbooks past cadence are flagged stale.
5. **AI/ML runbook specializations** — explicit runbooks for
   model artifact fetch failure, embedding shard loss, and
   prompt / response log restore, each with the degraded-service
   posture and staleness window named.
6. **Governance hook** — any new runbook, posture change, or
   trigger change requires an ADR via the governance system
   from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the library. Confirm ten failure modes are covered and
   that the set reflects the HA/DR scope from exercises 1–2
   and the chaos coverage table from exercise 3.
2. Open any runbook. Confirm it includes trigger, preconditions,
   steps (idempotent, each with a success signal), rollback,
   verification, owner, and last-exercised date.
3. Open the automation posture table. Confirm every runbook has
   a posture (automated / semi / human) with rationale.
   Automated region failover (runbook 7) is a fail signal.
4. Open the backup-of-runbook record. Confirm there is a DR
   host and an offline copy, and that both emit a freshness
   signal.
5. Confirm each runbook names the exercise-3 event that last
   exercised it; runbooks past their cadence are flagged as
   stale.
6. Confirm AI/ML runbooks (model artifact, embeddings,
   prompt/response logs) are specialized rather than copies of
   the generic templates.
7. Confirm each runbook's trigger maps to a measurement from
   the exercise-3 surface; triggers without measurement are
   un-invocable.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Library coverage | Top 10 failure modes aligned with HA/DR scope | Random set of runbooks |
| Runbook template | Trigger / preconditions / steps / rollback / verification / owner / last-exercised | Freeform narrative |
| Step quality | Idempotent, with success signal each | Prose instructions |
| Automation posture | Per-runbook decision + rationale | Blanket automation claim |
| High-risk automation | Region failover kept human | Automated DR failover |
| Backup-of-runbook | DR host + offline copy + freshness | Primary wiki only |
| Drill lineage | Last-exercised date per runbook | Un-dated |
| AI/ML specialization | Model, embeddings, logs runbooks specialized | Generic templates |
| Form | Versioned Markdown with structured front-matter | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see":

1. **DR plans on a shelf.** The module rationale's second
   dominant failure. Runbooks must be exercised and dated.
2. **No backup of the DR runbook itself.** The module
   rationale's fourth dominant failure. The DR host and offline
   copy are not optional.
3. **Automated region failover.** The failure mode the chaos
   literature and the module rationale both treat as high
   blast radius; this runbook stays human.
4. **Prose steps.** Runbook steps that are not idempotent or
   that lack success signals cannot be automated and cannot be
   drilled reliably.
5. **Generic AI/ML coverage.** Model artifact fetch failure and
   embedding shard loss have specific recovery paths that
   generic templates do not capture.

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
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
