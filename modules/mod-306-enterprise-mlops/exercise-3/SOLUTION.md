# SOLUTION — Exercise 3: Feature Stores Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-306-enterprise-mlops/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **feature-layer**
component of the platform architecture (exercise 1) together
with the **MLOps maturity model** deliverable — *a 5-level
maturity scale (manual / partial automation / repeatable /
measured / optimizing) assessed per capability + 18-month
target* — to the feature-store capability specifically. The
architect-tier answer is a feature-store architecture plus a
maturity assessment that commits to the current state and the
18-month target for the enterprise feature platform.

The module rationale frames MLOps maturity as the aspirational-
versus-actionable test. A maturity assessment that is never
re-assessed is a grader-visible failure; the submission here
pairs the feature-store architecture with a maturity assessment
that is auditable and tied to specific capability upgrades.

## 2. Worked answer

A passing feature-stores submission produces one linked design
package with four named sections:

1. **Feature-store architecture** — online + offline split,
   point-in-time correctness guarantees, write/read paths,
   tenancy, and lineage integration.
2. **Current-state maturity assessment** — the 5-level scale
   applied to each feature-store capability.
3. **18-month target** — the capability-level targets and the
   investments required to reach them.
4. **Re-assessment plan** — the cadence and trigger events
   that keep the maturity assessment actionable.

### Feature-store architecture

The feature store is the training/serving skew boundary; the
submission commits to:

- **Online / offline split** — the online store serves
  low-latency reads at request time; the offline store serves
  training workloads with historical point-in-time
  correctness. The split is explicit because the two have
  different consistency, latency, and cost postures.
- **Point-in-time correctness** — the offline store returns
  feature values as they existed at a stated past time. The
  rationale is reproducible training; without PIT correctness
  the lineage invariant from exercise 1 breaks.
- **Write path** — streaming vs. batch ingest, the schema
  registry, and the backfill mechanism are named. The write
  path must be governable (schema change gated, backfill
  auditable).
- **Read path** — online read SLO, offline read latency, and
  the fallback when the online store is unavailable.
- **Tenancy** — team / cost-center / workload-type metadata
  attached at write time and preserved on read, so the
  attribution pipeline from `mod-304/exercise-1` resolves.
- **Lineage integration** — feature definition version, the
  dataset version it derives from, and the model versions that
  consume it. The governance layer (exercise 2) queries this.

### Current-state maturity assessment

The module rationale pins the 5-level scale:

| Level | Name | Meaning |
| --- | --- | --- |
| 1 | Manual | Features computed per-model in notebooks, no reuse |
| 2 | Partial automation | Some features productionized, no central registry |
| 3 | Repeatable | Central registry, consistent naming, documented features |
| 4 | Measured | Feature-level SLOs, drift alerts, usage metrics |
| 5 | Optimizing | Automated feature retirement, cost-aware recomputation, self-healing |

The submission applies the scale to the feature-store
capabilities drawn from the architecture: online read,
offline read, PIT correctness, write pipelines, schema
registry, lineage, tenancy, observability, and governance
integration. "All level 5" and "all level 1" are both fail
signals because the assessment is a diagnosis, not a target.

### 18-month target

Each capability names its 18-month target level and the
investment required to move it:

- **Target band per capability** — not every capability needs
  to be level 5. The module trade-offs rationale accepts that
  enterprise patterns are slower than startup patterns; the
  target is defensible, not maximal.
- **Investment required** — platform-team headcount,
  tooling spend, or data-scientist enablement. A target
  without an investment line is aspirational.
- **Dependencies** — which capability must advance first.
  Observability (level 4) cannot land before the registry
  (level 3); the dependency graph is drawn.
- **Measurable milestones** — the artifact that proves the
  capability advanced (schema registry deployed, feature-level
  SLO dashboards live). Milestones without artifacts are drift.

### Re-assessment plan

The module rationale names *maturity model never re-assessed*
as the dominant failure. The submission commits:

- **Cadence** — the fixed interval for re-assessment (quarterly
  or semi-annual) with the review owner.
- **Trigger events** — adoption rate hitting a threshold, a
  skew incident, a vendor change, or an org change. Any of
  these triggers an out-of-cadence re-assessment.
- **Metric feed** — the quantitative signals (feature-store
  adoption rate, skew-incident count, time-to-feature) that
  inform the next assessment.
- **Decision outputs** — what the re-assessment is empowered to
  change: target band, investment allocation, deprecation of
  a capability.

### AI/ML feature-store specifics

The feature store is the layer where several AI/ML-specific
risks concentrate; the submission names:

- **Training / serving skew** — the single most common
  production ML outage. PIT correctness and shared
  transformation code between training and serving are the
  controls.
- **Feature poisoning** — OWASP ML Top 10 *ML02: Data
  Poisoning* applies at the feature-store write path. The
  governance layer requires provenance on ingested features.
- **Vector / embedding stores** — if the architecture includes
  embeddings as features, they are harder to re-shard and
  harder to version; the submission names the strategy or
  defers the capability explicitly.
- **PII handling** — feature-level sensitivity classification
  and the data-governance interface (consent, deletion,
  access control). NIST AI RMF *Govern* and *Map* anchor the
  policy.
- **Observability** — feature-level drift, distribution shift,
  and null-rate alarms. NIST AI RMF *Measure* function is the
  anchor; the observability layer from exercise 1 ingests
  these signals.

### Decision rationale

A feature-store architecture paired with a per-capability
maturity assessment is the right altitude because the module
rationale lists the feature layer as one of six layers and the
maturity model as the architect-tier assessment deliverable.
Trade-offs the submission should explicitly accept, mirroring
the module rationale:

- *Enterprise patterns are slower than startup patterns* —
  target levels are chosen for defensibility, not maximalism.
- *Heavy governance can frustrate data scientists* — the
  write path must offer self-service feature contribution with
  governance checks that scale.
- Build-vs-buy for the feature store itself (Feast, vendor
  product, in-house) is referenced from exercise 1's
  build-vs-buy work and does not re-litigate here.

### What stays out of scope

The architect-tier answer **does not** author the full layered
architecture (exercise 1), define the governance policy
(exercise 2), commit the serving posture (exercise 4), or
define the platform operating model (exercise 5). The goal
here is the feature-store architecture + the maturity
assessment that scopes the feature-platform investment.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` lists *"MLOps maturity model
(exercise 03)"* in its older module-level enumeration with the
5-level scale applied per capability + 18-month target. The
per-exercise table maps Exercise 3 to **Feature Stores
Application**, so this file applies the maturity-model
instrument to the feature-store capability and inherits the
feature-layer specification from the layered architecture in
exercise 1. Point-in-time correctness, skew defense, and
feature-level governance are grounded in NIST AI RMF, OWASP ML
Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the feature-stores artefacts lands as
versioned architecture assets:

1. **Feature-store architecture document** — Markdown in the
   architecture repository covering online / offline split,
   PIT correctness, write / read paths, tenancy, and lineage
   integration. One diagram showing the data flow and the
   skew-boundary annotation.
2. **Maturity assessment table** — structured Markdown keyed on
   capability with columns for current level (1–5), 18-month
   target, investment required, dependencies, and milestone
   artifact.
3. **Re-assessment plan** — one page naming cadence, trigger
   events, metric feed, and decision outputs. The owner is
   named by role, not team.
4. **AI/ML feature-store addendum** — skew defense, feature
   poisoning posture, embedding-feature strategy, PII handling,
   and feature-level observability. NIST AI RMF, OWASP ML Top
   10, and MITRE ATLAS cited inline.
5. **Governance hook** — any schema change, write-path change,
   or target-band shift requires an ADR via the governance
   system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the feature-store architecture document. Confirm the
   online / offline split is named with the consistency,
   latency, and cost posture of each.
2. Confirm point-in-time correctness is specified for the
   offline path and that shared transformation code or a
   dual-path contract prevents training/serving skew.
3. Confirm the write path is governable (schema change gated,
   backfill auditable) and that tenancy metadata is attached
   at write time.
4. Open the maturity assessment. Confirm every capability has
   a current level (1–5) and an 18-month target with the
   required investment and milestone artifact named.
5. Confirm dependencies between capabilities are drawn
   (observability cannot precede the registry).
6. Open the re-assessment plan. Confirm cadence, trigger
   events, metric feed, and decision outputs are stated.
7. Confirm the AI/ML addendum covers skew defense, feature
   poisoning, embedding features (or defers them explicitly),
   PII handling, and feature-level observability.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Online / offline split | Each named with consistency / latency / cost posture | Single store assumption |
| PIT correctness | Offline path guarantees stated | PIT absent or implicit |
| Skew defense | Shared transformation or dual-path contract | No skew control |
| Governable write path | Schema gating + auditable backfill | Open ingest |
| Tenancy carry | Team / cost-center / workload-type preserved | Metadata dropped |
| Lineage integration | Feature → dataset → model version tracked | Lineage absent |
| Maturity assessment | Current + target + investment + milestone per capability | Target without investment |
| Dependencies drawn | Capability-order graph explicit | Flat list of targets |
| Re-assessment plan | Cadence + trigger events + metric feed + decisions | Assessment is a one-off |
| ML coverage | Skew, poisoning, embeddings, PII, drift | Transactional view only |
| Form | Versioned Markdown + diagram + table | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the feature-store and maturity-model deliverables:

1. **Maturity model never re-assessed.** The module rationale
   names this as the dominant failure. Without a re-assessment
   plan, the targets are aspirational, not actionable.
2. **PIT correctness implicit.** A feature store without a
   stated PIT contract cannot guarantee reproducible training;
   the lineage invariant from exercise 1 breaks silently.
3. **Training / serving skew ignored.** The feature store is
   the skew boundary; no control (shared transformation code,
   dual-path contract) is a production outage waiting to
   happen.
4. **Target levels maximal.** "All capabilities to level 5"
   collapses the trade-off the module rationale accepts
   (enterprise patterns are slower than startup patterns).
5. **AI/ML feature risks collapsed to generic data risk.**
   Feature poisoning, embedding-store immutability, and
   feature-level drift are the ML-specific concerns that
   generic data governance does not catch. OWASP ML Top 10 and
   NIST AI RMF anchor the trust model.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
