# SOLUTION — Exercise 5: Self-Healing Application (Beyond-the-Reference Posture)

> Pairs with
> `ai-infra-architect-learning/lessons/mod-305-ha-dr/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **when to go beyond
this implementation** section — *active/active multi-region for
tier-0 services, immutable backups for ransomware defense,
chaos engineering for HA verification* — on top of the
self-healing library built in exercise 4. The architect-tier
answer is a decision document that commits to which beyond-the-
reference postures the organization adopts, for which workloads,
and the ops cost that falls out.

The module rationale is explicit that the baseline (multi-AZ HA
+ asynchronous multi-region DR + quarterly drills + runbook
library) is sufficient for most tier-1 services. Going beyond is
a specific decision for tier-0 services where the baseline RPO
or RTO is too loose, or where ransomware or data-tamper threat
models demand immutable storage. The exercise is where the
learner commits to the upgrade path and names what it costs.

## 2. Worked answer

A passing beyond-the-reference submission produces one linked
decision document with four named sections, mirroring the three
"when to go beyond" items the module rationale lists plus the
tier-0 scoping decision:

1. **Tier-0 scope** — which services (if any) are tier-0 and
   therefore need beyond-the-reference posture; which stay on
   the exercise 1–4 baseline.
2. **Active/active multi-region** — the posture for tier-0
   services, with the data model that makes it possible and
   the trade-offs the organization is accepting.
3. **Immutable backups** — the ransomware-defense posture,
   with the storage model, the restore drill, and the
   verification that mutable paths cannot touch immutable
   copies.
4. **Chaos engineering upgrade** — the posture that elevates
   exercise 3's chaos frame when tier-0 services are in scope.

### Tier-0 scope

The module rationale pins tier-1 critical at *RPO ≤ 5 min, RTO
≤ 15 min* with asynchronous cross-region + warm-standby.
Tier-0 is the step above: services where even that RPO/RTO is
too loose, usually because downtime is directly revenue- or
safety-impacting. The decision document names:

+ **Which services are tier-0** — the list, with the business
  reason each is elevated. "All of tier-1 should be tier-0" is
  a fail signal because it collapses the tiering.
+ **Which stay on the baseline** — explicit, so the ops cost
  is bounded. The module rationale accepts the cost of
  tier-1; tier-0 cost is additive.
+ **Promotion / demotion triggers** — the events that move a
  service between tiers (regulatory change, revenue growth,
  incident). Tiering drifts without them.

### Active/active multi-region

The module rationale calls out *move to active/active
multi-region for tier-0 services* in the "when to go beyond"
section. Active/active doubles replication challenge compared
to the asynchronous warm-standby baseline (exercise 2). The
submission commits to:

+ **Data model** — which data classes can accept multi-master
  writes with a stated conflict-resolution rule, and which
  stay single-master even in active/active topology.
+ **Convergence SLO** — the time within which the regions
  reconcile. Active/active without a convergence SLO is a
  silent correctness failure.
+ **Traffic steering** — how user traffic is split (geographic,
  latency-based, weighted) and how the system behaves on
  region loss (the surviving region absorbs full load).
+ **Capacity posture** — each region must carry enough
  capacity to absorb the other's load. The ops cost is
  explicit.
+ **Downgrade path** — when the beyond-reference posture is
  untenable (cost shock, incident, strategic change), how the
  service returns to the baseline.

The module rationale names the honest trade-off:
*multi-region doubles much infrastructure cost*. Active/active
doubles it further and adds coordination cost; the submission
accepts this openly rather than claiming active/active is free.

### Immutable backups

The module rationale calls out *add immutable backups for
ransomware defense* in the "when to go beyond" section. The
submission names:

+ **Storage model** — write-once, read-many storage with a
  tamper-evident control plane. Mutable paths cannot
  overwrite or delete the immutable copy before the retention
  window expires.
+ **Scope** — which data classes carry immutable copies. The
  module rationale targets ransomware; model artifacts,
  training data lineage, and prompt / response logs are
  high-value for AI/ML.
+ **Retention window** — long enough that a stealth
  compromise is detectable before the earliest immutable copy
  expires.
+ **Restore drill** — the module rationale's dominant failure
  is *backups that aren't tested*. The immutable restore drill
  is on the exercise-3 cadence; the drill proves the copy is
  usable, not merely stored.
+ **Access-control proof** — the control that prevents the
  admin credential that would otherwise be ransomware's
  target from mutating the immutable storage. Without this
  control, "immutable" is marketing.

### Chaos engineering upgrade

The baseline chaos frame (exercise 3) verifies the HA posture.
When tier-0 and active/active are in scope, chaos is upgraded:

+ **Region-pair chaos** — one region is withdrawn under load
  and the surviving region's capacity posture is verified. The
  blast radius is higher; the readiness gate is stricter.
+ **Steady-state chaos in production** — tier-0 depends on the
  active/active posture being continuously validated, so
  low-blast chaos runs continuously rather than on a schedule.
+ **Immutable-restore chaos** — the restore drill is run as
  chaos against staging data, in addition to the periodic
  production-scope drill.

### AI/ML specifics

Beyond-the-reference posture carries AI/ML-specific risk the
baseline doesn't address:

+ **Model artifacts in immutable storage** — the artifact
  registry is a high-value target for supply-chain-style
  attacks (OWASP ML Top 10, MITRE ATLAS adversarial reach).
  Immutable storage of signed artifacts is the architectural
  mitigation.
+ **Training data lineage** — the ability to prove what a
  model was trained on is a NIST AI RMF *Govern* and *Map*
  function; immutable lineage records are the storage layer.
+ **Prompt / response logs** — compliance and
  incident-forensic value; the module's DR scope already
  includes them, but immutable retention is where the
  ransomware trade-off is accepted.
+ **Active/active for serving** — model serving is often the
  easiest active/active workload because it is stateless; the
  harder question is the embedding and feature store, and the
  submission commits to one answer per store.

### Decision rationale

A beyond-the-reference decision document anchored to tier-0 is
the right altitude because the module rationale lists the three
"beyond" postures as specific adjacencies, not blanket
upgrades. Trade-offs the submission should explicitly accept,
mirroring the module rationale:

+ Active/active is strictly more expensive and more complex
  than the baseline; it is justified for tier-0 only.
+ Immutable backups are not free — storage cost, access-control
  cost, and restore-drill cost — but ransomware defense is the
  specific threat they answer.
+ The chaos upgrade raises false-positive risk; the signal
  tracking from exercise 3 is critical to prevent degradation.

### What stays out of scope

The architect-tier answer **does not** reproduce the baseline
HA (exercise 1), DR (exercise 2), chaos (exercise 3), or
runbook (exercise 4) design. The goal here is the layered
upgrade on top of them, tight enough that the organization can
decide whether each tier-0 service pays for it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` does not enumerate an "exercise 05"
in its older module-level deliverables rationale — the three
beyond-the-reference postures (active/active multi-region,
immutable backups, chaos engineering) live under *"When to go
beyond this implementation"*. The per-exercise table maps
Exercise 5 to **Self-Healing Application (Beyond-the-Reference
Posture)**, so this file carries those three postures as a
tier-0 layering on exercises 1–4. Active/active and
immutable-restore commitments are grounded in AWS, GCP, and
Azure Well-Architected Reliability guidance cited in §6.

## Implementation

Implementation of the beyond-the-reference posture lands as
versioned architecture assets layered on top of exercises 1–4:

1. **Tier-0 scope document** — Markdown in the architecture
   repository listing tier-0 services, the business reason each
   is elevated, and the promotion / demotion triggers. Services
   that stay on the exercise 1–4 baseline are listed explicitly
   so the ops cost is bounded.
2. **Active/active multi-region design** — one design document
   per tier-0 service covering data model (master posture per
   data class, conflict rule), convergence SLO, traffic steering,
   capacity posture, and the downgrade path back to the baseline.
   Aligned with the AWS, GCP, and Azure Well-Architected
   Reliability guidance on multi-region active/active cited in §6.
3. **Immutable-backup configuration record** — the storage
   model (write-once, read-many), scope (data classes with
   immutable copies), retention window, restore drill cadence,
   and the access-control proof that mutable paths cannot touch
   the immutable copy.
4. **Chaos engineering upgrade spec** — the extensions to
   exercise 3's chaos frame: region-pair chaos, continuous
   steady-state production chaos for tier-0, and
   immutable-restore chaos. Includes the stricter readiness
   gate for region-pair experiments.
5. **AI/ML immutable scope addendum** — model artifacts,
   training-data lineage records, and prompt / response logs in
   immutable storage; active/active posture per data class for
   model serving, embedding store, and feature store.
6. **Ops cost summary** — capacity doubling, immutable storage
   cost, and chaos operational attention, each stated so the
   trade-off is auditable.
7. **Governance hook** — any tier-0 promotion, active/active
   adoption, or immutable-backup scope change requires an ADR
   via the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the tier-0 scope. Confirm the list is explicit, with
   business reasons, and that promotion / demotion triggers
   are named. "All tier-1 is tier-0" is a fail signal.
2. Open the active/active section. Confirm each data class has
   a stated master model (single or multi) with a
   conflict-resolution rule, a convergence SLO, and a stated
   capacity posture that absorbs region loss.
3. Confirm the downgrade path from active/active to the
   exercise-2 baseline is named. A one-way adoption is
   incomplete.
4. Open the immutable backups section. Confirm the storage
   model, retention window, restore drill, and access-control
   proof. Immutable without a restore drill is the baseline
   failure under a new name.
5. Confirm the chaos upgrade reflects the tier-0 scope
   (region-pair chaos, steady-state production chaos,
   immutable-restore chaos).
6. Confirm AI/ML specifics are addressed (model artifacts,
   training-data lineage, prompt/response logs, serving vs.
   embedding/feature store posture).
7. Confirm the ops cost is explicit: active/active doubles
   capacity, immutable storage adds a retention cost, chaos
   upgrade adds operational attention.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Tier-0 scope | Explicit list with reasons + triggers | Blanket tier-0 claim |
| Active/active data | Master model per data class + conflict rule | "Multi-master, works out" |
| Convergence SLO | Stated per data class | Absent |
| Capacity posture | Each region absorbs full load | Half-capacity each |
| Downgrade path | Return-to-baseline procedure named | One-way adoption |
| Immutable storage | Write-once + access-control proof | "Backups to another bucket" |
| Immutable restore drill | On exercise-3 cadence | Stored but un-tested |
| Chaos upgrade | Region-pair + steady-state prod + immutable-restore chaos | Baseline chaos only |
| AI/ML coverage | Artifacts, lineage, logs, serving vs. embedding | Generic workloads only |
| Ops cost | Capacity, storage, operational attention named | "No material change" |
| Form | Versioned Markdown + diagrams | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
and the "when to go beyond" section:

1. **Tier-0 for everything.** Collapses the trade-off; the
   ops cost makes it unaffordable and the discipline becomes
   theater.
2. **Immutable backups without a restore drill.** The dominant
   failure the module rationale names reappears with an
   immutable wrapper.
3. **Active/active without a convergence SLO or a downgrade
   path.** The hardest part of active/active is correctness
   during conflict and the ability to exit if the posture is
   not paying off.
4. **Access-control proof missing on immutable storage.** If
   the admin credential that is ransomware's primary target
   can also mutate the immutable store, immutability is
   marketing.
5. **AI/ML treated as generic.** The module targets AI/ML;
   model artifacts, training-data lineage, and prompt /
   response logs are the specific assets ransomware and
   supply-chain attacks target. NIST AI RMF *Govern* and
   OWASP ML Top 10 anchor the trust model.

## 6. References

+ NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
+ NIST SP 800-34 Rev. 1, *Contingency Planning Guide for Federal
  Information Systems* —
  <https://csrc.nist.gov/pubs/sp/800/34/r1/upd1/final>
+ AWS Well-Architected Framework — Reliability Pillar —
  <https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html>
+ Google Cloud Architecture Framework — Reliability —
  <https://cloud.google.com/architecture/framework/reliability>
+ Microsoft Azure Well-Architected Framework — Reliability —
  <https://learn.microsoft.com/en-us/azure/well-architected/reliability/>
+ OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
+ MITRE ATLAS — <https://atlas.mitre.org/>
+ Module-level rationale: `../SOLUTION.md`
