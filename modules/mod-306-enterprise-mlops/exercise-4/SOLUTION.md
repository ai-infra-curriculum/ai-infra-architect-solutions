# SOLUTION — Exercise 4: Real-time Serving Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-306-enterprise-mlops/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **serving-layer**
component of the platform architecture (exercise 1), the
**risk-tiering** policy from governance (exercise 2), and the
layered-architecture invariants (lineage, tenancy,
observability) to the online inference capability. The
architect-tier answer is a real-time serving architecture that
commits to the request-time contract (latency, availability,
rollout, rollback) and the per-tier approval and observability
posture that enterprise governance requires.

The module rationale frames serving as one of six layers but
does not re-litigate the engineer-tier serving stack. The
architect-tier value is in the serving posture that enforces
tenancy, lineage, and tier-aware approval across many
model-serving teams without forcing each team to redesign the
request path.

## 2. Worked answer

A passing real-time serving submission produces one linked
design package with four named sections:

1. **Serving-layer architecture** — request path, routing,
   model loading, resource isolation, and the inference SLO
   contract per tier.
2. **Rollout and rollback posture** — shadow, canary,
   percentage rollout, and the automated rollback trigger per
   tier.
3. **Tier-aware approval and observability** — the gates and
   signals that enforce the governance tiers from exercise 2.
4. **ML-specific serving concerns** — model loading, batch vs.
   request concurrency, feature-fetch latency, and the
   adversarial-input posture.

### Serving-layer architecture

The serving layer is the online inference contract. The
submission commits to:

- **Request path** — client → routing / API gateway → feature
  fetch (online store from exercise 3) → model execution →
  response. Each hop has a latency budget and an availability
  budget inside the per-tier inference SLO.
- **Routing** — model version addressing (by name + version,
  by alias) and the shadow / canary / A-B split mechanism.
- **Model loading** — cold-start cost, warm-up strategy, and
  the memory / GPU residency posture. "Always resident" vs.
  "load on demand" is an explicit choice with cost and
  latency implications.
- **Resource isolation** — per-tenant isolation at the pod,
  node, or cluster level. Tenancy carried from the data /
  feature layers lands here; a noisy neighbor must not
  violate a tier-1 model's SLO.
- **Inference SLO** — per model, with the latency (p50, p95,
  p99), availability, and tenancy-adjusted budget. Tier
  (from exercise 2) sets the floor; the model owner can set
  stricter.

### Rollout and rollback posture

The module rationale makes governance the cross-cutting
concern; the serving layer is where governance is physically
enforced at promotion:

- **Shadow deployment** — the new version runs on live
  traffic without serving responses, so skew and
  performance regressions are measurable before user impact.
- **Canary rollout** — a small percentage of traffic routes
  to the new version with the stop condition stated (error
  rate, latency, drift). The percentage ramp follows a
  committed schedule.
- **Automated rollback** — the metrics that trigger rollback
  without human-in-the-loop, with the per-tier threshold.
  Tier-1 rolls back aggressively; lower tiers tolerate more
  before rollback.
- **Blast-radius bounding** — percentage rollout is bounded
  by region, tenant, or user segment so a bad model does
  not reach the entire user base. The segmentation is
  stated, not implicit.
- **Human approval gate** — tied to the tier-aware approval
  matrix from exercise 2. Low tier: self-service canary;
  high tier: governance-board approval before any
  production traffic.

### Tier-aware approval and observability

The governance tiering from exercise 2 is enforced at serving
time:

- **Promotion gates** — each tier's required review depth is
  encoded as a gate the deployment pipeline consults before
  routing production traffic.
- **Observability per tier** — tier-1 (highest-risk) models
  carry the full observability stack: latency, availability,
  drift, feature-distribution shift, calibration error,
  prediction-outcome lag, fairness slice metrics. Lower tiers
  carry a documented minimum.
- **Alert routing** — the on-call route per tier is named.
  Tier-1 pages the owning team; lower tiers emit a daily
  digest.
- **Audit emit** — each promotion, rollback, and incident
  writes to the audit trail (exercise 2) with the
  correlation keys from exercise 1's lineage invariant.

### ML-specific serving concerns

The module targets AI/ML; the serving posture addresses
risks the generic microservice serving does not:

- **Model loading cost** — large models carry non-trivial
  cold-start cost; the posture names warm pools, lazy loading
  with a documented latency hit, or always-resident with the
  cost stated. "Loads on demand" without a latency budget is
  a fail.
- **Feature-fetch latency** — the online feature store from
  exercise 3 is on the critical path; the per-request feature
  fetch budget is stated and the fallback when a feature is
  missing is defined.
- **Batch vs. request concurrency** — request-time models
  often share capacity with batch scoring. The isolation
  posture is stated so batch cannot starve request-time
  serving.
- **Adversarial-input posture** — OWASP ML Top 10 *ML01:
  Input Manipulation* and MITRE ATLAS evasion techniques
  apply at the request boundary. The posture names input
  validation, rate limiting, and abuse signal collection.
  Higher-tier models from exercise 2 carry stricter posture.
- **Prediction logging** — predictions, inputs (subject to
  PII policy from exercise 3), and feature versions are
  logged with retention stated. NIST AI RMF *Measure* is
  anchored here.

### Decision rationale

A serving architecture that commits to tier-aware rollout and
observability is the right altitude because the module
rationale lists serving as one of six layers and governance
as cross-cutting; the serving-time enforcement is where the
governance tier becomes operational. Trade-offs the submission
should explicitly accept, mirroring the module rationale:

- *Heavy governance can frustrate data scientists* — the
  lowest tier must offer self-service deployment with
  automated gates. A single approval gate for all models
  collapses the tiering.
- Request-time latency is in tension with per-request feature
  fetches and heavy models; the posture names the budget and
  the fallback.
- Automated rollback can cause false-positive reverts; the
  tier-aware thresholds balance false-positive cost against
  user-impact cost.

### What stays out of scope

The architect-tier answer **does not** author the governance
policy itself (exercise 2 does), define the feature store
(exercise 3 does), or commit to the platform operating model
(exercise 5 does). The goal here is the serving-layer
architecture tight enough that the governance tiers are
enforceable and the engineer-tier serving teams have a
contract to build against.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` lists serving as one of six layers
in *"Platform architecture document (exercise 01)"* but does
not break out a serving exercise in its older enumeration. The
per-exercise table maps Exercise 4 to **Real-time Serving
Application**, so this file carries the serving-layer
architecture, the rollout / rollback posture, and the
tier-aware approval + observability enforcement that comes
from the governance policy in exercise 2. Rollout, rollback,
adversarial-input, and observability requirements are
grounded in NIST AI RMF, OWASP ML Top 10, and MITRE ATLAS
cited in §6.

## Implementation

Implementation of the real-time serving architecture lands as
versioned architecture assets:

1. **Serving-layer architecture document** — Markdown in the
   architecture repository covering request path, routing,
   model loading, resource isolation, and per-tier inference
   SLO. One diagram showing the request path with latency and
   availability budgets annotated.
2. **Rollout and rollback policy** — Markdown with shadow,
   canary (schedule + stop conditions), automated-rollback
   thresholds per tier, and the blast-radius segmentation
   mechanism.
3. **Tier enforcement artifact** — structured policy (CI/CD
   gates, admission controller policies, policy-as-code
   rules) that implements the per-tier promotion gate from
   exercise 2.
4. **Observability contract** — the required signals per tier
   (latency, availability, drift, calibration, fairness,
   prediction-outcome lag) with the alert routing.
5. **AI/ML serving addendum** — model-loading posture,
   feature-fetch latency budget, batch / request isolation,
   adversarial-input posture, and prediction logging. NIST
   AI RMF, OWASP ML Top 10, and MITRE ATLAS cited inline.
6. **Governance hook** — any serving-SLO change, rollout
   policy change, or tier enforcement change requires an ADR
   via the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the serving-layer architecture. Confirm the request
   path is drawn with latency and availability budgets per
   hop and that the per-tier inference SLO is stated.
2. Confirm resource isolation is named (pod / node / cluster
   per tenant) and that tenancy metadata carries into
   serving.
3. Open the rollout policy. Confirm shadow, canary (with
   stop conditions and ramp schedule), and automated-rollback
   thresholds are named per tier.
4. Confirm the blast-radius bounding is explicit (region,
   tenant, or user segment).
5. Confirm promotion gates implement the governance tiers
   from exercise 2 (low tier → self-service; high tier →
   board approval).
6. Confirm per-tier observability lists drift / calibration /
   fairness / prediction-outcome lag — not just latency and
   error rate.
7. Confirm the AI/ML addendum covers model-loading posture,
   feature-fetch latency budget, batch / request isolation,
   adversarial-input posture, and prediction logging.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Request path | Hops drawn with latency / availability budget | Flat "it serves" |
| Model loading | Cold-start / warm pool / residency named | On-demand without budget |
| Resource isolation | Per-tenant isolation + tenancy carry | Shared without tier guarantees |
| Inference SLO | Per model, per tier, with budgets | One SLO for all models |
| Rollout policy | Shadow + canary + schedule + stop conditions | Blue-green only |
| Rollback | Automated, per-tier thresholds | Manual-only |
| Blast radius | Region / tenant / segment bounding | Full traffic exposure |
| Tier gates | Per-tier promotion gates implemented | Flat approval |
| ML observability | Drift / calibration / fairness / outcome lag | Latency + errors only |
| Adversarial posture | Input validation + rate limiting + abuse signal | Absent |
| Prediction logging | Logged with retention stated | Logged ad hoc or not at all |
| Form | Versioned Markdown + diagram | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the serving-layer deliverable:

1. **Flat rollout and rollback for all tiers.** The module
   rationale separates governance tiers; a serving policy that
   treats tier-1 and tier-3 identically either over-governs
   low-risk models (friction) or under-governs high-risk
   models (incidents).
2. **Model loading left implicit.** Large models carry
   non-trivial cold-start cost; a serving posture without a
   loading strategy will produce surprise latency incidents.
3. **ML observability treated as transactional observability.**
   Drift, calibration, and fairness are first-class signals
   per NIST AI RMF *Measure*; a serving layer that emits only
   latency and error rate cannot support the governance
   layer's audit cadence.
4. **No adversarial-input posture.** OWASP ML Top 10 *ML01*
   and MITRE ATLAS evasion techniques apply at the request
   boundary; serving architectures that assume benign input
   are the common ML-specific security gap.
5. **Blast-radius bounding absent.** A canary that reaches the
   entire user base is not a canary; the segmentation
   mechanism must be stated.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
