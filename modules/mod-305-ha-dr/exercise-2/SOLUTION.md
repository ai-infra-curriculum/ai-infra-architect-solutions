# SOLUTION — Exercise 2: DR Planning Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-305-ha-dr/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **disaster recovery**
frame — *DR is surviving unexpected catastrophes (region outage,
data corruption, ransomware) with bounded RPO/RTO* — to a
concrete plan. The architect-tier answer is a per-application
RPO/RTO matrix plus a multi-region DR design that commits to how
data replicates, how compute fails over, and how DNS or load
balancers redirect traffic.

The module rationale is explicit that HA (exercise 1) and DR are
usually conflated and rarely tested. DR is where the
organization commits to the targets it will meet during
catastrophe and the architecture that physically makes those
targets achievable. This exercise is where the learner shows
they can match targets to topology and name the trade-offs the
multi-region posture forces.

## 2. Worked answer

A passing DR planning submission produces one linked plan with
three named sections, mirroring the module rationale's DR
deliverables:

1. **RPO / RTO matrix** — per-application targets for data loss
   tolerance (RPO) and downtime tolerance (RTO).
2. **Multi-region DR design** — how data replicates
   cross-region, how compute fails over, how DNS or load
   balancers redirect.
3. **Scope boundary vs. HA** — explicit statement of what DR
   owns and what HA (exercise 1) owns, so the two documents
   compose rather than overlap.

### RPO / RTO matrix

The module rationale pins the tier-1 critical targets at
*RPO ≤ 5 min, RTO ≤ 15 min* and relaxes lower tiers. The matrix
has one row per application with:

- **Tier** — carried over from the HA tiering (exercise 1).
- **RPO target** — the data-loss window the business accepts.
  Tier-1 ≤ 5 min; lower tiers state their own window.
- **RTO target** — the downtime window the business accepts.
  Tier-1 ≤ 15 min; lower tiers state their own window.
- **Realizing architecture** — the replication posture and
  failover mechanism that physically meets the targets. This
  column is the test that targets are not aspirational.
- **Signed owner** — the business owner who agreed to the
  target. Targets without owners drift silently.

The failure mode the module rationale flags is *RPO/RTO
unrealistic vs. architecture*: targets that physically can't be
met. A passing matrix shows the realizing architecture per row
so the target is auditable, not aspirational.

### Multi-region DR design

The module rationale is specific: *the reference uses
asynchronous cross-region replication + warm-standby compute for
tier-1*. The design document covers:

- **Data replication** — asynchronous cross-region per data
  class, with the lag budget and the resulting RPO stated.
  Async replication means non-zero RPO; the budget is where
  that cost is accepted explicitly.
- **Compute failover** — warm-standby in the DR region for
  tier-1, with the mechanism (orchestration, image parity,
  config parity) named. Lower tiers may use cold-standby or
  re-provision from infrastructure-as-code.
- **DNS and load-balancer redirect** — the traffic-steering
  layer that promotes the DR region. The mechanism is named
  (health checks, control-plane flip, manual DNS) along with
  the propagation window that lands in the RTO budget.
- **Reverse-replication plan** — once the primary returns,
  the plan to re-synchronize is named. "Primary down, DR
  takes over, never return" is a hidden failure.

### Per-data-class DR posture

The module targets AI/ML infrastructure; the design names a DR
posture per ML-specific data class, not just the transactional
database:

- **Model artifacts** — immutable artifact registry replicated
  cross-region; version pins must survive region loss.
- **Training data** — large volumes with longer async budgets
  are often acceptable, but the RPO is stated.
- **Embedding / vector store** — rebuild cost from source vs.
  cross-region replication cost is a real trade-off; the
  design names which it chose and why.
- **Prompt / response logs** — compliance and incident-forensic
  value makes these in-scope for DR; retention and the DR
  posture are named.
- **Feature store** — online (serving) vs. offline (training)
  tiers; online carries RPO scope, offline typically rebuilt
  from source.

### DR scope vs. HA scope

The module rationale separates HA (expected failures, no user
impact) from DR (unexpected catastrophes, bounded RPO/RTO). The
submission names the boundary explicitly:

- **HA path (exercise 1)** — instance death, AZ outage;
  transparent to users; owned by replicas and health checks.
- **DR path (this exercise)** — region outage, data
  corruption, ransomware; bounded RPO/RTO; owned by
  cross-region replication and controlled failover.

The two paths compose: HA absorbs the common case so DR is only
invoked for genuine catastrophe.

### Decision rationale

A per-application RPO/RTO matrix tied to a multi-region design
is the right altitude because the module rationale lists both as
the DR deliverables. Trade-offs the submission should explicitly
accept, mirroring the module rationale:

- *Multi-region doubles much infrastructure cost* — the design
  names which workloads carry warm-standby and which do not.
- *Async replication means non-zero RPO* — the lag budget is
  stated and defended per data class.
- Reverse-replication and failback are harder than failover;
  the plan is explicit, not implicit.

### What stays out of scope

The architect-tier answer **does not** cover the HA posture
(exercise 1), the DR drill cadence (exercise 3), the chaos
engineering frame (exercise 3), or the self-healing automation
(exercises 4–5). The goal here is the plan — targets plus the
realizing architecture — tight enough that the drill scope and
automation are well-bounded in later exercises.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` labels the "RPO/RTO matrix" as
`(exercise 01)` and the "Multi-region DR design" as
`(exercise 03)` in its older module-level enumeration, while the
per-exercise table maps Exercise 2 to **DR Planning
Application**. This file is Exercise 2 and carries the RPO/RTO
matrix + multi-region DR design jointly, because the matrix is
only defensible when paired with the realizing architecture.
The Multi-AZ HA posture sits in exercise-1; chaos / drills in
exercise-3; self-healing in exercises 4–5. DR replication,
failover, and failback choices here are grounded in AWS, GCP,
and Azure Well-Architected Reliability guidance cited in §6.

## Implementation

Implementation of the DR plan lands as versioned architecture
assets, not as a running failover:

1. **RPO/RTO matrix** — structured Markdown table (or
   spreadsheet exported to the architecture repository) with one
   row per application and columns for tier, RPO, RTO,
   realizing architecture, and signed business owner. Rows
   without a realizing architecture fail review.
2. **Multi-region design document** — one Markdown document
   covering data replication (asynchronous cross-region with
   lag budget per data class), compute failover (warm-standby
   mechanism), and traffic redirect (DNS or LB mechanism plus
   propagation window). Aligned with the AWS, GCP, and Azure
   Well-Architected Reliability guidance cited in §6.
3. **Per-data-class DR posture record** — addendum covering
   model artifacts, training data, embedding / vector store,
   prompt / response logs, and feature store (online vs.
   offline), so AI/ML components carry a stated DR posture.
4. **Reverse-replication / failback plan** — the procedure to
   return to the primary once it recovers; a one-way DR plan is
   rejected at review.
5. **Scope-boundary statement** — explicit record of what the
   HA path (exercise 1) absorbs versus what triggers the DR
   path, so the two documents compose rather than overlap.
6. **Governance hook** — any change to RPO/RTO targets or
   realizing architecture requires an ADR via the governance
   system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the RPO/RTO matrix. Confirm each application has a
   tier, an RPO, an RTO, a realizing architecture column, and a
   signed business owner. Targets without a realizing
   architecture are the module rationale's "unrealistic vs.
   architecture" failure.
2. Confirm tier-1 rows are at or stricter than *RPO ≤ 5 min,
   RTO ≤ 15 min*; lower tiers state their own windows.
3. Open the multi-region design. Confirm data replication is
   asynchronous cross-region with a stated lag budget, and that
   compute uses warm-standby for tier-1.
4. Confirm DNS / load-balancer redirect names the mechanism and
   the propagation window; the window must fit inside RTO.
5. Confirm per-data-class posture addresses model artifacts,
   training data, embedding store, prompt / response logs, and
   feature store — not just the transactional database.
6. Confirm reverse-replication / failback is in the plan; a
   one-way DR plan is incomplete.
7. Confirm DR scope is bounded against HA scope — HA failures
   do not invoke DR, and DR mechanisms are not triggered by
   routine AZ loss.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| RPO/RTO matrix | Per-app rows with target + realizing architecture + owner | Target without realizing architecture |
| Tier-1 targets | ≤ 5 min RPO / ≤ 15 min RTO | Looser without stated justification |
| Replication | Async cross-region per data class with lag budget | "Replicated" without budget |
| Compute failover | Warm-standby for tier-1 with mechanism named | Cold-standby for tier-1 |
| Traffic redirect | DNS / LB mechanism + propagation window | Flip "handled by DNS" |
| ML data coverage | Model, training, embedding, logs, features | Transactional DB only |
| Failback | Reverse-replication plan named | One-way failover |
| Scope boundary | HA vs. DR cleanly separated | HA concerns inlined |
| Form | Versioned Markdown + diagrams | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the DR half of the module:

1. **RPO/RTO unrealistic vs. architecture.** Targets that
   physically can't be met with the stated replication posture.
   The matrix must include a realizing architecture column.
2. **HA and DR conflated.** The module rationale separates
   them; a DR plan that re-litigates AZ-level failures loses
   the frame.
3. **One-way failover.** DR plans that promote the standby but
   do not describe failback leave the organization stuck in the
   DR region.
4. **"Replicated" without a lag budget.** Async replication
   means non-zero RPO; the module rationale accepts that
   explicitly and the plan must state it.
5. **Transactional DB only.** The module targets AI/ML; the DR
   posture must address model artifacts, embeddings, and
   prompt/response logs where the compliance and incident value
   is high.

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
