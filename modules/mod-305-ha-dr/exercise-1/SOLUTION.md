# SOLUTION — Exercise 1: HA Patterns Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-305-ha-dr/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **high availability**
frame — *HA is surviving expected failures (instance death, AZ
outage) without user impact* — to a concrete architecture. The
architect-tier answer is not a tour of load-balancer features; it
is a documented HA topology that commits to failure domains,
replica placement, and the per-tier recovery targets that
distinguish HA from DR.

The module rationale is explicit that HA and DR are usually
conflated and rarely tested. The reference separates them: HA
absorbs expected failure modes transparently, while DR owns the
unexpected catastrophe path. This exercise is where the learner
shows they can design the HA half — multi-AZ topology with
explicit failure-domain boundaries — without smuggling in DR
scope that belongs to exercises 2–5.

## 2. Worked answer

A passing HA patterns submission produces one linked design
package with four named sections, mirroring the module
rationale's HA deliverable:

1. **Tier definition** — which services are tier-1 critical and
   what their HA target is (no user impact under expected
   failure).
2. **Multi-AZ topology** — tier-1 services running in 3+ AZs
   with replicas spread and failure-domain boundaries drawn.
3. **Stateful replication posture** — synchronous replication
   within region for stateful data.
4. **Lower-tier relaxation** — explicit statement of what tiers
   2 and below give up and why that's acceptable.

### Tier definition

The module rationale pins tier-1 critical apps at *RPO ≤ 5 min,
RTO ≤ 15 min*. Those are DR targets; HA targets are the stricter
"no user impact" bar for expected failures. The submission names
each application's tier and the HA target that applies:

- **Tier-1** — must survive instance death and AZ outage with no
  user-visible impact. Load balancers reroute, replicas take
  over, writes continue.
- **Tier-2 and below** — relaxed targets. A short user-visible
  interruption during AZ failover is acceptable; the submission
  states the window.

Tiering is per-application, not global. "Everything is tier-1" is
a fail signal because it collapses the HA/DR trade-off into
unaffordable architecture.

### Multi-AZ topology

The module rationale is specific: *tier-1 services run in 3+ AZs
with replicas spread*. The topology diagram shows:

- **Compute** — stateless workloads across 3+ AZs behind a
  regional load balancer, with health-check-driven removal.
- **Stateful data** — primary + synchronous replicas with
  quorum-based failover; AZ outage drops at most one replica
  and keeps quorum.
- **Failure-domain boundaries** — drawn explicitly on the
  diagram. Each boundary names which services share it and
  therefore co-fail.

The deliverable commits to one topology per tier-1 service
class and names what breaks under a two-AZ loss (the quorum
boundary) so the DR path can be scoped later.

### Stateful replication posture

The module rationale calls out *synchronous replication within
region* for stateful data. The submission states, per data
class:

- **Replication mode** — synchronous within region (the HA
  posture) vs. asynchronous cross-region (the DR posture,
  owned by exercise 2–3).
- **Write quorum** — majority of replicas acknowledge before
  commit. Named so AZ failure math is explicit.
- **Read serving** — primary-only vs. replica reads, with the
  staleness window stated when replicas can serve reads.
- **Failure behavior** — what happens on single-AZ loss (write
  path continues) and on majority-AZ loss (writes block; this
  is the DR trigger).

### AI/ML HA specifics

The module targets AI/ML infrastructure; the submission names
HA posture for the ML-specific stateful components, not just the
transactional database:

- **Model artifact store** — the authoritative registry; HA
  posture plus cache locality for the serving tier.
- **Embedding / vector store** — one of the hardest stateful
  components to re-shard; replica strategy is stated.
- **Feature store** — online vs. offline split; the online tier
  carries HA scope, the offline tier is typically batch.
- **Serving tier** — stateless by design, so multi-AZ spread
  with health-check removal is the pattern.

### Decision rationale

A multi-AZ, synchronously-replicated topology is the right
altitude because the module rationale frames HA as *expected
failures without user impact*. Trade-offs the submission should
explicitly accept, mirroring the module rationale:

- Synchronous replication costs latency; the submission names
  the budget and which services pay it.
- 3+ AZ spread raises baseline cost; the submission accepts it
  for tier-1 and relaxes for lower tiers.
- Failure-domain boundaries are honest about co-failure; shared
  dependencies (DNS, control plane) become named risks rather
  than implicit assumptions.

### What stays out of scope

The architect-tier answer **does not** cover cross-region
failover, backup/restore, or DR drill cadence — those belong to
exercises 2–5. The goal here is the HA frame tight enough that
the DR scope is well-bounded.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` uses two overlapping numbering
schemes: a per-exercise table (Exercise 1 = HA Patterns,
Exercise 2 = DR Planning) and, in its deliverables rationale, an
older module-level enumeration that labels the RPO/RTO matrix
"(exercise 01)" and the Multi-AZ architecture "(exercise 02)".
This file is **Exercise 1 / HA Patterns**, so it absorbs the
parent's "Multi-AZ architecture" deliverable (3+ AZ topology,
synchronous within-region replication) because that *is* the HA
realization. The RPO/RTO matrix sits in Exercise 2 / DR Planning
where the DR targets are set. No deliverable is dropped; the
split is HA (here) vs. DR (exercise-2).

The "3+ AZ + synchronous stateful replication" posture is
grounded in authoritative cloud-provider Well-Architected
Reliability guidance — AWS, GCP, and Azure — enumerated in
§6; each provider's framework endorses multi-AZ failure-domain
isolation and synchronous within-region replication for tier-1
stateful workloads.

## Implementation

Implementation of the HA patterns lands as versioned
architecture assets, not as a running system:

1. **Tier definition document** — Markdown in the architecture
   repository listing every application, its tier, and the HA
   target that applies. One row per application; "everything is
   tier-1" is rejected at review.
2. **Multi-AZ topology diagram** — one diagram per tier-1
   service class, drawn with 3+ AZ failure domains explicit and
   replica placement shown. Shared dependencies (DNS, control
   plane, secrets store) are drawn as their own failure domains.
3. **Replication posture table** — structured Markdown table
   keyed on data class with columns for replication mode, write
   quorum, read serving, and single-AZ / majority-AZ failure
   behavior. Synchronous within-region replication across a 3+
   AZ topology is the committed posture for tier-1 stateful
   data, aligned with the AWS Well-Architected Reliability
   Pillar, Google Cloud Architecture Framework (Reliability),
   and Microsoft Azure Well-Architected Framework (Reliability)
   guidance cited in §6 — each endorses multi-AZ failure-domain
   isolation with synchronous within-region replication as the
   tier-1 default.
4. **ML stateful posture record** — an addendum covering the
   model artifact store, embedding / vector store, feature
   store (online vs. offline), and serving tier so AI/ML
   components carry a stated HA posture.
5. **Lower-tier relaxation statement** — explicit record of what
   tiers 2+ give up (interruption window, replica count) so the
   cost trade-off is defensible.
6. **Governance hook** — any change to tiering or AZ topology
   requires an ADR via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the tier definition. Confirm each application has a
   named tier and HA target. "Everything is tier-1" is a fail
   signal.
2. Open the multi-AZ topology diagram. Confirm tier-1 services
   are placed in 3+ AZs and that failure-domain boundaries are
   drawn, not implied.
3. Open the replication posture table. Confirm each stateful
   data class names its replication mode, write quorum, read
   serving, and failure behavior.
4. Confirm the diagram names what breaks under two-AZ loss —
   the quorum boundary that triggers the DR path.
5. Confirm the ML-specific stateful components (model
   artifacts, embeddings, feature store) each carry an HA
   posture, not just the transactional database.
6. Confirm lower-tier relaxation is explicit (what tiers 2+
   give up) rather than implicit.
7. Confirm DR scope is deferred — cross-region, drills, and
   backups are named as separate scope, not inlined here.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Tiering | Per-application tier with HA target | "Everything is tier-1" |
| Multi-AZ spread | Tier-1 across 3+ AZs with replicas spread | Single-AZ or 2-AZ tier-1 |
| Failure domains | Boundaries drawn, co-failure named | Boundaries implicit |
| Replication posture | Mode / quorum / failure behavior per data class | Single "it replicates" bullet |
| ML stateful coverage | Model store, embeddings, feature store addressed | Transactional DB only |
| Lower-tier relaxation | Named windows and trade-offs | Tiering collapses |
| Scope discipline | DR scope deferred to exercises 2–5 | HA document includes drills / backups |
| Form | Versioned Markdown + diagrams | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the HA half of the module:

1. **HA and DR conflated.** The module rationale separates them
   deliberately. An HA document that includes cross-region
   failover, DR drills, or backup restore is out of scope.
2. **Everything is tier-1.** Collapses the trade-off and makes
   the architecture unaffordable; tiering must be defensible.
3. **Replicas not spread.** 3+ AZs on paper with replicas
   co-located on two is the subtlest failure mode; the diagram
   must show spread explicitly.
4. **Transactional DB only.** The module targets AI/ML; model
   artifact store, embedding store, and feature store each need
   an HA posture.
5. **Failure domains implicit.** Shared DNS, shared control
   plane, shared secrets store — any of these is a failure
   domain that must be drawn, not assumed.

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
