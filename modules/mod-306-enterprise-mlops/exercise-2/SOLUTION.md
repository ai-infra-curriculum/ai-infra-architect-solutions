# SOLUTION — Exercise 2: Model Governance Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-306-enterprise-mlops/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **risk-tiering for
ML systems** deliverable — *ML systems classified by decision
impact, affected population, and reversibility, with risk tier
driving review depth, audit cadence, and approval gate* — plus
the governance seams of the **build-vs-buy decision**
deliverable, to a concrete model-governance policy. The
architect-tier answer is a governance frame that enforces review
depth and approval gates proportional to risk, so the platform
can scale across ~100 data scientists without the governance
layer becoming a bottleneck or a rubber stamp.

The module rationale frames governance as a cross-cutting
concern that spans the data, feature, training, serving, and
observability layers of the architecture (exercise 1). Model
governance is where the governance layer gets its policy:
classification, review process, audit trail, and the operating
rules that decide when a model needs an approval gate versus
self-service deployment.

## 2. Worked answer

A passing model governance submission produces one linked policy
package with four named sections, mirroring the module
rationale's risk-tiering + governance deliverables:

1. **Risk classification policy** — the dimensions, the tier
   bands, and the examples that make the classification
   defensible.
2. **Review and approval matrix** — the review depth, audit
   cadence, and approval gate per tier.
3. **Audit trail contract** — the artifacts captured per model
   lifecycle event and how long they are retained.
4. **Governance of governance** — how the policy itself is
   updated, who signs it, and how exceptions are tracked.

### Risk classification policy

The module rationale pins the three dimensions:

- **Decision impact** — the magnitude of the business impact
  (financial, safety, legal). Scored on a stated scale with
  anchor examples per band.
- **Affected population** — the number of people whose outcomes
  are shaped by the model, with a secondary distinction for
  vulnerable populations where NIST AI RMF *Govern* and *Map*
  functions apply additional review requirements.
- **Reversibility** — whether a wrong decision can be undone
  and the recovery window. Irreversible decisions carry a
  stricter tier regardless of population size.

The policy produces a **tier band** per model (e.g., tier A /
B / C, or risk 1 / 2 / 3) that the review matrix below acts on.
"Everything is low risk" and "everything is high risk" are both
fail signals — the module rationale lists *risk tiering applied
unevenly* as a grader-visible failure.

### Review and approval matrix

Each tier has a stated:

- **Review depth** — self-service deployment, peer review,
  governance board review, or external audit. Higher tiers
  demand deeper review.
- **Audit cadence** — how often the production model is
  re-reviewed after launch. Lower-risk tiers may audit yearly;
  higher-risk tiers audit quarterly or on-change.
- **Approval gate** — the role authorized to approve
  deployment at this tier. "Everyone approves everything" and
  "one director approves everything" are both fail signals.
- **Documentation requirements** — the model card, the
  intended-use statement, and the known-limitation list the
  tier requires at approval time.

The matrix is a published artifact so data scientists know
their path *before* they build the model. Governance that
surfaces at deployment is theater.

### Audit trail contract

The governance layer records, per model and per lifecycle
event (training, evaluation, promotion, deployment, incident):

- **Who** — human and service identities. NIST AI RMF *Govern*
  function requires traceable accountability.
- **What** — the artifact id (training run id, model id,
  dataset id, feature snapshot id); the governance layer
  joins these back through the cross-layer lineage invariant
  from exercise 1.
- **When** — timestamp and retention window.
- **Approval evidence** — the signed approval tied to the
  review-and-approval matrix tier.
- **Model card** — the published model card at promotion
  time; the audit trail retains the version at approval and
  the version at each subsequent update.

The audit trail is tamper-evident; append-only or signed
checkpoints prevent after-the-fact rewriting during an
investigation.

### Governance of governance

The policy itself is an artifact that drifts if not maintained;
the submission names:

- **Policy owner** — the role accountable for the policy, not
  "the platform team" generically.
- **Review cadence** — a stated cadence for policy review
  (annual or at major regulatory change), with the
  mechanism that triggers an out-of-cadence review (incident,
  new model class, external audit).
- **Exception process** — how a team gets a time-boxed
  exemption. Exceptions without expiry are the hidden path
  that collapses the tiering.
- **Metrics** — the governance layer's own observability:
  review turnaround time, exception count, incident rate per
  tier. "No metrics" is how governance becomes bureaucracy.

### AI/ML governance specifics

The module targets AI/ML; the policy addresses the governance
surface the generic risk-management framework does not:

- **Dataset provenance** — the policy requires evidence of
  dataset sourcing, consent, and licensing. OWASP ML Top 10
  *ML02: Data Poisoning* and *ML06: AI Supply Chain* are
  anchored here.
- **Adversarial-resilience review** — higher-tier models
  require a documented adversarial-robustness assessment
  (MITRE ATLAS techniques). The depth matches the tier.
- **Fairness / bias assessment** — mandatory per tier, with
  the methodology named. NIST AI RMF *Measure* function
  requires the assessment; the policy requires the artifact.
- **Monitoring commitments** — the production monitoring the
  model carries by tier (drift thresholds, performance decay
  thresholds, alerting routes). Governance commits the
  observability layer to a per-tier posture.

### Decision rationale

A classification policy + review-and-approval matrix anchored
to a tamper-evident audit trail is the right altitude because
the module rationale lists risk tiering + review depth +
approval gate as the governance deliverables. Trade-offs the
submission should explicitly accept, mirroring the module
rationale:

- *Heavy governance can frustrate data scientists.* The matrix
  must allow self-service at the lowest tier; a single gate for
  all models collapses the trade-off.
- *Risk tiering applied unevenly* is the dominant failure. The
  policy includes examples per band so classification is
  defensible, not negotiated per model.
- Build-vs-buy for the governance tooling itself (model
  registry, policy engine, audit sink) is referenced from
  exercise 1's build-vs-buy work, not re-litigated here.

### What stays out of scope

The architect-tier answer **does not** author the layered
architecture (exercise 1), assess current maturity
(exercise 3), commit the serving posture (exercise 4), or
define the platform team operating model (exercise 5). The
goal here is the governance policy tight enough that the
platform's governance layer can act on it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names *"Risk-tiering for ML systems
(exercise 04)"* in its older module-level enumeration — three
dimensions (decision impact, affected population, reversibility)
with risk tier driving review depth, audit cadence, and approval
gate. The per-exercise table maps Exercise 2 to **Model
Governance Application**, so this file absorbs the parent's
risk-tiering deliverable along with the governance seams of the
build-vs-buy deliverable, because the policy is only operable
when the review process is also committed. Risk-tiering,
provenance, adversarial-robustness, and fairness requirements
are grounded in NIST AI RMF (Govern, Map, Measure, Manage),
OWASP ML Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the model governance policy lands as versioned
architecture assets, not as a running review process:

1. **Risk classification policy** — Markdown in the architecture
   repository with the three dimensions, the tier bands, and
   anchor examples per band. "Everything is tier X" cases are
   rejected at review.
2. **Review and approval matrix** — structured Markdown table
   keyed on tier with columns for review depth, audit cadence,
   approval gate, and documentation requirements. The matrix is
   published, not implicit.
3. **Audit trail schema** — the structured definition of the
   per-event record (who / what / when / approval evidence /
   model card snapshot) and the retention / tamper-evidence
   mechanism.
4. **Governance operating record** — the policy owner, review
   cadence, exception process, and governance metrics (review
   turnaround, exception count, incident rate per tier).
5. **AI/ML addendum** — dataset provenance requirements,
   adversarial-robustness review by tier, fairness assessment
   methodology, and per-tier monitoring commitments. NIST AI
   RMF, OWASP ML Top 10, and MITRE ATLAS cited inline.
6. **Governance hook** — the policy itself is versioned via an
   ADR when the matrix or dimensions change, through the
   governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the risk classification policy. Confirm the three
   dimensions (decision impact, affected population,
   reversibility) are named and that each tier band has anchor
   examples.
2. Open the review-and-approval matrix. Confirm every tier has
   a stated review depth, audit cadence, approval gate, and
   documentation requirement. "Peer review for everything" or
   "director approval for everything" are fail signals.
3. Walk one hypothetical model through the policy. Confirm the
   path is deterministic: classification → tier → review path
   → approval gate → audit record.
4. Open the audit trail schema. Confirm it names who, what,
   when, approval evidence, and model-card snapshot per event,
   and that the retention / tamper-evidence mechanism is
   stated.
5. Confirm the governance-of-governance section names the
   policy owner (not "the platform team"), the review cadence,
   and the exception process with expiry.
6. Confirm the AI/ML addendum covers dataset provenance,
   adversarial robustness, fairness, and per-tier monitoring.
7. Confirm governance metrics exist (review turnaround,
   exception count, incident rate per tier) so the policy can
   be observed, not merely promulgated.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Classification dimensions | Decision impact, affected population, reversibility | Fewer than three or renamed |
| Tier bands with examples | Each tier has anchor examples | Bands without examples |
| Review matrix | Review depth, audit cadence, approval gate, docs per tier | Flat process for all tiers |
| Audit trail content | Who / what / when / approval / model card | Partial record |
| Tamper evidence | Append-only or signed checkpoints | Mutable log |
| Governance of governance | Owner, review cadence, exception expiry, metrics | Policy with no owner or no metrics |
| Provenance | Dataset sourcing / consent / licensing captured | Provenance absent |
| Adversarial robustness | Required by tier with methodology named | Mentioned but not tier-aware |
| Fairness assessment | Methodology stated per tier | Checkbox without method |
| Form | Versioned Markdown + structured matrix | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the governance half of the module:

1. **Risk tiering applied unevenly.** The module rationale lists
   this as the dominant failure. Teams claim "low risk" for
   high-impact systems; anchor examples per band and audit
   cadence per tier are the structural defense.
2. **Governance that surfaces at deployment.** The matrix must
   be published up-front so data scientists know their review
   path before they build. Post-hoc governance is theater.
3. **Audit trail without tamper evidence.** A mutable log is
   indistinguishable from no log during an investigation.
4. **Exceptions without expiry.** Time-boxed exemptions keep
   the tiering honest; permanent exceptions collapse it.
5. **AI/ML governance treated as generic SDLC.** Dataset
   provenance, adversarial robustness, and fairness assessment
   are the specific controls that distinguish ML governance.
   OWASP ML Top 10, MITRE ATLAS, and NIST AI RMF anchor the
   trust model.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
