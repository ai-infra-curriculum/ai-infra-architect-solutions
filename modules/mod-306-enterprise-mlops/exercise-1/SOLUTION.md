# SOLUTION — Exercise 1: MLOps Architecture Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-306-enterprise-mlops/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **platform architecture
document** deliverable — *a layered architecture (data, feature,
training, serving, observability, governance) where each layer has
an owner team, a technology choice, and an integration interface* —
to a concrete enterprise-scale design. The architect-tier answer is
not an inventory of ML tooling; it is a layered reference
architecture that commits to owners, interfaces, and the
cross-layer invariants that make the platform governable.

The module rationale frames the architect tier as the layer above
the engineer / senior-engineer MLOps capability. The engineer tiers
build the layers; the architect tier makes them compose at
org-scale by naming owners, interfaces, and the governance seams
that let teams integrate without re-litigating the shape of the
platform. This exercise is where the learner shows the layered
architecture *and* the operating contract between layers.

## 2. Worked answer

A passing MLOps architecture submission produces one linked design
package with six named layers plus the cross-layer contracts the
module rationale calls out:

1. **Data layer** — authoritative storage for raw and curated
   datasets with lineage back to source systems.
2. **Feature layer** — online + offline feature serving with
   point-in-time correctness.
3. **Training layer** — pipeline orchestration, experiment
   tracking, and reproducible training runs.
4. **Serving layer** — model deployment, routing, and request-
   time inference.
5. **Observability layer** — metrics, logs, traces, and
   model-specific signals (drift, performance decay).
6. **Governance layer** — model registry, approval gates, risk
   tiering, and the audit trail that spans the stack.

### Layer definitions

Each layer in the submission names **owner team**, **technology
choice**, and **integration interface** — the three fields the
module rationale calls out:

- **Owner team** — the organizational unit accountable for the
  layer's SLOs and roadmap. "Platform team" without decomposition
  is a fail signal because the architect tier is what makes org
  scaling explicit.
- **Technology choice** — the committed primary and the explicit
  alternatives considered. The build-vs-buy decision (exercise 2)
  justifies each choice; this layer references it.
- **Integration interface** — the contract the layer exposes to
  the next (API, event, library, declarative resource). Layers
  that leak implementation details are the "platform disconnected
  from customers" failure mode the module rationale names.

### Cross-layer invariants

The architect-tier value is in the invariants that cross layers,
not in any single layer:

- **Lineage end-to-end** — every production prediction traces to
  a feature snapshot, a trained model artifact, and a training
  dataset version. Any layer that breaks the chain is rejected at
  review.
- **Tenancy carries across layers** — team / cost-center /
  workload-type metadata attached in the data layer survives
  through serving so the attribution pipeline from
  `mod-304/exercise-1` can resolve it.
- **Governance is a cross-cutting concern** — the governance
  layer is drawn as spanning the other five, not sitting beside
  them, because it holds the registry, risk tier, and audit
  trail that each layer writes into.
- **Observability per layer, correlated by run / model id** —
  each layer emits metrics on the same correlation keys so a
  degraded prediction can be traced from serving back through
  features and data.

### Platform-as-product discipline

The module rationale calls out *platform-as-product* in its "when
to go beyond" section and names *platform built without product-
management discipline* as the dominant failure mode. The
submission commits, per layer:

- **Primary customers** — the data scientist persona, the ML
  engineer persona, the platform operator persona. Features
  added for engineer convenience without a customer are the
  rationale's "features added because engineers wanted them"
  anti-pattern.
- **Capability roadmap** — what the layer will offer this
  quarter and what it refuses to offer. "The platform does
  everything" is a fail signal; refusal is a product decision.
- **Deprecation contract** — how the layer sunsets an interface
  so customers (data scientists / ML engineers) are not stranded
  by platform-team-driven churn.

### AI/ML-specific considerations

Enterprise MLOps carries risks the generic microservice platform
does not; the layered architecture names them explicitly:

- **Model registry provenance** — the governance layer's model
  registry is the integrity anchor targeted by supply-chain-style
  attacks (OWASP ML Security Top 10 — *ML05: Model Theft*,
  *ML06: AI Supply Chain*; MITRE ATLAS reconnaissance /
  model-staging techniques).
- **Feature store authority** — the online feature store is the
  training/serving skew boundary; point-in-time correctness is
  non-negotiable because skew becomes an operational outage.
- **Observability coverage of ML signals** — drift, calibration
  error, and feature distribution shift are first-class signals
  alongside latency and error rate. NIST AI RMF *Measure* and
  *Manage* functions require continuous measurement, not
  snapshot evaluation.
- **Audit trail content** — the governance layer records who
  trained what on which data, who approved deployment, and the
  risk tier that was applied; NIST AI RMF *Govern* function is
  the anchor.

### Decision rationale

A six-layer architecture with owners, interfaces, and
cross-layer invariants is the right altitude because the module
rationale lists the layered-architecture deliverable as the
primary architect-tier artifact. Trade-offs the submission should
explicitly accept, mirroring the module rationale:

- *Enterprise patterns are slower than startup patterns.* The
  interface contract between layers is friction; it is worth it
  for org-scale governance.
- *Heavy governance can frustrate data scientists.* The
  governance layer must offer self-service entry points (the
  module targets ~100 data scientists; a human gate per request
  cannot scale).
- Build-vs-buy per layer (exercise 2) is explicit, not
  implicit. The architecture document references the decision;
  it does not re-litigate it.

### What stays out of scope

The architect-tier answer **does not** make the final
build-vs-buy call per layer (exercise 2), assess current maturity
(exercise 3 — feature layer specifically), decide the risk-tier
policy for serving (exercise 4), or commit to the platform team
operating model (exercise 5). The goal here is the layered
architecture tight enough that the later exercises can commit
decisions against it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names this deliverable *"Platform
architecture document (exercise 01)"* with the layered-
architecture spec. The per-exercise table maps Exercise 1 to
**MLOps Architecture Application**, so this file carries the
layered architecture + owner / interface / technology contract
and defers build-vs-buy per layer to exercise-2, maturity
assessment to exercise-3, serving risk tier to exercise-4, and
operating-model commitments to exercise-5. Layer definitions
and cross-layer invariants are grounded in NIST AI RMF (Govern,
Map, Measure, Manage functions), OWASP ML Top 10, and MITRE
ATLAS cited in §6.

## Implementation

Implementation of the MLOps architecture lands as versioned
architecture assets, not as a running platform:

1. **Reference architecture document** — Markdown in the
   architecture repository with one section per layer (data,
   feature, training, serving, observability, governance) and
   fields for owner team, primary technology choice, and
   integration interface.
2. **Layered architecture diagram** — one diagram showing the
   six layers with the governance layer drawn as spanning the
   other five; cross-layer invariants (lineage, tenancy,
   observability correlation) are annotated as flows, not
   implied.
3. **Interface contracts** — one Markdown subsection per layer
   with its exposed API / event / library contract, the version
   policy, and the deprecation window.
4. **Platform-as-product record** — the primary customers per
   layer, the quarterly roadmap commitment, and the "refuses to
   offer" list that bounds scope.
5. **AI/ML invariants addendum** — model registry, feature
   store, ML observability, and audit-trail requirements that
   each layer must honor. NIST AI RMF, OWASP ML Top 10, and
   MITRE ATLAS cited inline.
6. **Governance hook** — any layer boundary, owner, or
   interface change requires an ADR via the governance system
   from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the reference architecture document. Confirm each of the
   six layers has a named owner team, a primary technology
   choice, and an integration interface. "Platform team" without
   decomposition is a fail signal.
2. Open the architecture diagram. Confirm the governance layer
   is drawn as spanning the other five (not sitting beside
   them) and that cross-layer invariants are annotated.
3. Confirm the lineage invariant is testable: a production
   prediction can be traced back to a feature snapshot, trained
   artifact, and dataset version by following the diagram.
4. Confirm tenancy metadata (team, cost-center, workload-type)
   is carried end-to-end so cost attribution and governance
   roll-ups work.
5. Confirm the ML-specific invariants are named — model registry
   provenance, feature-store authority, drift / skew
   observability, audit-trail content.
6. Confirm the platform-as-product record names refusal scope.
   "The platform does everything" is a fail signal.
7. Confirm build-vs-buy per layer is deferred to exercise 2,
   not inlined here.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Layer completeness | Six layers each with owner / tech / interface | Missing layer or missing field |
| Governance spans | Governance drawn across the other five | Governance drawn as a sibling layer |
| Lineage invariant | Prediction → feature snapshot → artifact → dataset | Chain broken at any layer |
| Tenancy carry-through | Team / cost-center / workload-type end-to-end | Metadata dropped at a layer boundary |
| Observability keys | Shared correlation IDs across layers | Each layer uses its own IDs |
| Platform-as-product | Customer, roadmap, refusal list per layer | "Platform does everything" |
| ML invariants | Model registry, feature store, drift / skew, audit trail | Only transactional observability |
| Scope discipline | Build-vs-buy deferred to exercise 2 | Vendor commitments inlined |
| Form | Versioned Markdown + diagram | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the layered-architecture deliverable:

1. **MLOps platform built without product-management discipline.**
   The module rationale calls out *features added because
   engineers wanted them, not because customers needed them*. The
   platform-as-product record is the structural fix; a missing
   refusal list is where this failure hides.
2. **Governance drawn as a sibling.** The governance layer is
   cross-cutting; drawing it beside the other layers is the
   subtle architectural tell that the audit trail does not
   actually span the stack.
3. **Lineage chain broken.** A diagram that shows features,
   models, and predictions as separate stores without a lineage
   edge is the "cannot reproduce this prediction" failure the
   module targets.
4. **Owners collapsed to "platform team".** The architect-tier
   value is in decomposing ownership; a single-owner diagram
   defeats the purpose of the deliverable.
5. **ML observability treated as generic metrics.** Drift,
   calibration, and feature-distribution shift are first-class
   signals; a layered architecture whose observability layer
   only emits latency and error rate cannot support NIST AI RMF
   *Measure*.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
