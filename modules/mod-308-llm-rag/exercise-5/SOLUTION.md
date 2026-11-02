# SOLUTION — Exercise 5: Cost Optimization Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-308-llm-rag/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **model selection
policy** deliverable — *how to choose between OSS (Llama,
Mistral), commercial (OpenAI, Anthropic), and self-hosted
commercial for each use case, considering cost, capability,
data sensitivity, and latency* — together with the module's
**cost forecasting** concern — *LLM spend grows fast* — to a
concrete enterprise cost-optimization program for the LLM
platform. The architect-tier answer is not a vendor price
sheet; it is a policy that commits the routing / selection
rules, the attribution model, the measurement contract, and the
guardrails that keep LLM spend predictable.

The module rationale frames LLM cost as roughly linear with
usage and names "no cost monitoring on commercial APIs" as a top
grader-visible failure (surprise bills) and "single-model
architecture" as the "pays the strongest model's price for every
request" failure. This exercise is where the learner commits the
cost program and the invariants it enforces against the stack
built in Exercises 1 through 4.

## 2. Worked answer

A passing cost-optimization submission produces one linked
design package with four named sections, grounded in the module
rationale's model-selection and cost fields:

1. **Model-selection policy** — how a request is routed across
   OSS, commercial, and self-hosted-commercial models.
2. **Attribution and chargeback** — who pays for which calls,
   anchored in the Exercise 1 tenant-attribution invariant.
3. **Measurement and forecasting** — the Exercise 1 cost
   telemetry rolled up into forecasts and budgets.
4. **Guardrails and controls** — the enforcement points that
   stop runaway spend.

### Model-selection policy

The policy commits selection on four dimensions, taken directly
from the module rationale:

- **Cost** — token-cost class per candidate model, with the
  specific per-use-case ceiling (e.g. "customer support
  general-purpose answer must not exceed X per response").
- **Capability** — the minimum capability class required for
  the use case; weaker (cheaper) models are preferred when they
  meet the Exercise 2 retrieval-grounded eval and the Exercise 4
  safety eval.
- **Data sensitivity** — the data class involved determines
  whether a commercial API is allowed at all, which carriers
  are allowed, and whether the self-hosted-commercial path is
  the floor for the use case. This ties to the lakehouse
  access-control model from
  [`../../mod-307-data-architecture/exercise-1/SOLUTION.md`](../../mod-307-data-architecture/exercise-1/SOLUTION.md).
- **Latency** — the per-use-case latency ceiling that may
  exclude a strong-but-slow model regardless of its cost /
  capability profile.

The routing seam is the Exercise 1 orchestration layer; this
exercise commits the *policy*, not the routing implementation.
"Single-model architecture" is a fail signal because the module
rationale names it directly.

### Attribution and chargeback

The submission commits:

- **Tenant / cost-center attribution** — every call carries the
  Exercise 1 telemetry attribution fields; the cost roll-up is
  by tenant / cost-center and by use case.
- **Chargeback or showback decision** — whether cost is
  internally rebilled (chargeback) or made visible for
  accountability (showback), with the trade-off recorded.
- **Vendor-side cost reconciliation** — commercial API invoices
  are reconciled against measured token cost so vendor-side
  bugs are detectable. The Exercise 3 vector-store spend rolls
  up here too.
- **Shared RAG and prompt costs** — retrieval, embedding, and
  prompt-store costs are attributed to the calling tenant, not
  pooled, so the Exercise 2 pipeline is not an unmetered shared
  resource.

### Measurement and forecasting

The module rationale names cost forecasting explicitly. The
submission commits:

- **Measurement contract** — the Exercise 1 telemetry contract
  carries per-call cost; this exercise commits the roll-up to
  the time grain used for forecasting (daily, weekly, monthly).
- **Forecast model** — the specific projection method (linear
  on usage, seasonal, scenario-based) and the confidence band.
  "LLM cost grows roughly linearly with usage" is the module-
  rationale baseline the forecast refines, not replaces.
- **Variance review** — a documented cadence for comparing
  forecast to actual and acting on the variance.
- **Ties to FinOps** — the LLM-specific cost program slots into
  the broader FinOps program from
  [`../../mod-304-cost-finops/exercise-1/SOLUTION.md`](../../mod-304-cost-finops/exercise-1/SOLUTION.md).

### Guardrails and controls

The submission commits:

- **Per-tenant and per-use-case budgets** — soft budgets
  (alert) and hard budgets (block or downgrade) with the mode
  per use case recorded.
- **Downgrade path** — when a hard budget is reached, the
  request is served by a lower-cost model if the Exercise 4
  safety / eval contract allows; otherwise it refuses, matching
  the Exercise 4 refusal pattern.
- **Rate limits** — the Exercise 4 rate / abuse control is also
  a cost control. The two share the enforcement surface.
- **Alerting** — threshold alerts on forecast variance,
  per-tenant spike, and vendor-invoice reconciliation
  mismatch.

### Cross-cutting invariants

The architect-tier value is in the invariants that span the
cost program:

- **Every call is attributable** — the Exercise 1 telemetry
  contract carries tenant / cost-center / use-case fields; a
  call without attribution is unaccountable spend.
- **Model selection is policy, not per-request improv** — the
  routing seam reads the policy; application code does not
  select a model directly.
- **Safety outweighs cost on data-class decisions** — a cheaper
  commercial path cannot be chosen for a data class that
  requires self-hosted-commercial, regardless of cost delta.
- **Vendor cost is measurable** — if token-level cost cannot be
  tracked per vendor, the vendor is not production-ready for
  the cost program.

### AI/ML-specific considerations

Cost intersects with the official sources at several points:

- **OWASP ML Security Top 10** — *ML06: AI Supply Chain Attacks*
  applies to the commercial-API vendor relationship; the vendor
  cost program and reconciliation controls are also integrity
  controls, because vendor-side bugs (or compromise) show up
  as unexplained spend before they show up as behavior
  changes.
- **MITRE ATLAS** — adversaries can inflate cost through
  prompt-injection-driven loops, retrieval abuse, or
  high-token-cost payloads; rate / spend guardrails are a
  defensive surface against resource-exhaustion techniques.
- **NIST AI RMF** — the *Manage* function covers vendor /
  supplier risk; the *Measure* function covers continuous
  measurement. The cost program is where both land in dollars.

### Decision rationale

A four-section cost-optimization program (model-selection
policy, attribution / chargeback, measurement / forecasting,
guardrails / controls) is the right altitude because the module
rationale names model-selection as an architect-tier
deliverable and names cost monitoring and cost growth as module
concerns. Trade-offs the submission should name:

- *OSS self-hosting saves money at scale but is complex to
  operate.* The module rationale names this trade-off; the
  model-selection policy is where it is applied per use case.
- *Showback is cheaper to run than chargeback.* The policy
  records why one was chosen.
- *Hard budgets protect spend but produce refusals.* The
  trade-off is recorded; the refusal contract from Exercise 4
  is reused rather than reinvented.

### What stays out of scope

The architect-tier answer **does not** redesign the LLM platform
(Exercise 1), redesign the RAG pipeline (Exercise 2), re-decide
the vector store (Exercise 3), or redraft safety controls
(Exercise 4). The goal here is a cost program tight enough that
spend is predictable and auditable without altering the stack.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names model-selection policy as the
*Exercise 02* deliverable and names cost monitoring and cost
growth as module-level concerns. The learner-visible title for
this exercise is "Cost Optimization Application", and this file
carries both because they share enforcement surfaces (routing,
telemetry, budgets) and share the primary failure modes
graders see (single-model architecture, surprise bills).
Cross-cutting invariants and AI/ML considerations are grounded
in NIST AI RMF, OWASP ML Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the cost-optimization program lands as
versioned policy and measurement assets:

1. **Cost program document** — Markdown with one section per
   field (model-selection policy, attribution / chargeback,
   measurement / forecasting, guardrails / controls).
2. **Model-selection policy table** — per use case: capability
   class required, data-class constraint, latency ceiling,
   token-cost ceiling, primary and fallback models.
3. **Attribution model** — the telemetry fields that enable
   roll-up, the time grain, and the chargeback / showback
   decision.
4. **Forecast spec** — the forecast method, the confidence
   band, the variance review cadence, and the FinOps integration
   point from `mod-304`.
5. **Guardrail policy** — per-tenant and per-use-case budgets
   with soft / hard modes, the downgrade path, and alerting
   thresholds.
6. **Vendor reconciliation runbook** — how commercial-API
   invoices are reconciled against measured spend and what
   mismatch triggers.
7. **AI/ML invariants addendum** — OWASP ML Top 10 (ML06)
   vendor-supply-chain attachment, MITRE ATLAS resource-abuse
   detection surface, NIST AI RMF *Manage* and *Measure*
   alignment.
8. **Governance hook** — model-selection policy changes,
   budget changes, and chargeback / showback changes require an
   ADR via the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the cost program document. Confirm each of the four
   fields (model-selection policy, attribution, measurement /
   forecasting, guardrails) is present and populated.
2. Confirm the model-selection policy evaluates cost,
   capability, data sensitivity, and latency per use case, with
   a primary and fallback model named.
3. Confirm every call is attributable to tenant / cost-center /
   use case via the Exercise 1 telemetry contract.
4. Confirm commercial-API invoices are reconciled against
   measured spend on a documented cadence.
5. Confirm the forecast method is named with a confidence band
   and a variance review cadence.
6. Confirm per-tenant and per-use-case budgets are declared
   with soft / hard modes and a downgrade path that reuses the
   Exercise 4 refusal pattern.
7. Confirm the data-sensitivity constraint overrides the cost
   constraint; a cheaper commercial path cannot be chosen for a
   data class that requires self-hosted-commercial.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Selection policy | Cost + capability + data sensitivity + latency per use case | Policy on fewer dimensions |
| Multi-model routing | Primary + fallback named per use case | Single-model default |
| Attribution | Tenant / cost-center / use-case fields in telemetry | Attribution ad-hoc |
| Reconciliation | Vendor invoice vs. measured spend reconciled | Reconciliation absent |
| Forecast | Method + confidence band + variance review | "Linear growth" without specifics |
| Guardrails | Soft + hard budgets with downgrade path | Alerts only; no enforcement |
| Data-class override | Sensitivity constraint beats cost | Cost-first on sensitive data |
| AI/ML invariants | OWASP ML (ML06) + MITRE ATLAS + NIST AI RMF *Manage/Measure* mapped | Framework alignment absent |
| Scope discipline | LLM platform / RAG / vector store / safety deferred | Deferred decisions inlined |
| Form | Versioned Markdown + policy table | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the cost-optimization deliverable:

1. **Single-model architecture.** The module rationale names
   this as the "pays the strongest model's price for every
   request" failure. A cost program that does not require
   multi-model routing per use case has no cost lever.
2. **No cost monitoring on commercial APIs.** The module
   rationale names "surprise bills" directly; the measurement
   and reconciliation sections exist to prevent this.
3. **Cost-first on sensitive data.** Routing to the cheapest
   model regardless of data class breaks the Exercise 1
   access-control invariants and risks regulatory exposure;
   data sensitivity overrides cost.
4. **Hard budgets without a downgrade path.** A hard budget
   that only refuses is operationally brittle; the policy
   should route to a lower-cost model where safety / eval
   allow, and only refuse when it does not.
5. **Alerts without reconciliation.** Threshold alerts on spend
   catch spikes; without vendor-invoice reconciliation they do
   not catch vendor-side bugs or compromises (ML06).
6. **Showback declared, never read.** The module rationale's
   "common mistakes" theme is governance that exists on paper
   but not in review; a chargeback / showback that is not
   reviewed on a cadence does not change behavior.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
