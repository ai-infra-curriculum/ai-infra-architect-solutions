# SOLUTION — Exercise 4: Safety Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-308-llm-rag/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **hallucination and
safety controls** deliverable — *output filters, citation
requirements, refusal patterns, and adversarial-prompt
detection* — together with the module's **prompt-management
discipline** deliverable — *prompts are version-controlled, each
prompt has eval coverage, and prompt changes require review* —
to a concrete enterprise safety program for the LLM platform.
The architect-tier answer is not a filter library; it is a
safety architecture that commits the ingress / egress filter
plane, the citation and refusal contracts, and the prompt-
management discipline that keeps safety from regressing.

The module rationale frames hallucination and safety as a top
module concern and lists "prompts in code, not versioned" and
"no retrieval eval" among the top grader-visible failures. This
exercise is where the learner commits the safety program and the
governance seams that make the LLM platform operable without
silent drift.

## 2. Worked answer

A passing safety submission produces one linked design package
with four named sections, grounded in the module rationale's
hallucination / safety and prompt-management fields:

1. **Input filter plane** — adversarial-prompt detection and
   prompt-injection screening before the model is invoked.
2. **Output filter plane** — content filters, citation
   enforcement, and refusal patterns before the response leaves
   the platform.
3. **Prompt-management discipline** — versioning, eval
   coverage, and review for every prompt the orchestration
   layer dispatches.
4. **Audit and incident contract** — safety outcomes are
   logged, reviewed, and tied to incident response.

### Input filter plane

The submission commits:

- **Prompt-injection screening** — pattern and model-based
  detection applied before the orchestration layer composes the
  retrieval output into the prompt. The RAG citation / grounding
  contract from
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md)
  depends on retrieved passages being themselves screened,
  because indexed documents can carry injection payloads
  (MITRE ATLAS technique family).
- **Adversarial-prompt detection** — jailbreak patterns, policy
  violations, and role-confusion attempts. The module rationale
  names adversarial-prompt detection explicitly as a required
  safety control.
- **Rate / abuse controls** — per-caller and per-tenant limits
  so adversarial probing has a cost ceiling.

The input filter plane sits inside the Exercise 1 safety layer,
on the ingress path of every model call. There is no bypass path.

### Output filter plane

The submission commits:

- **Content filters** — categorical content review tuned to the
  deployment risk profile; filter outcomes are telemetry, not
  only block / allow.
- **Citation enforcement** — the RAG citation requirement from
  Exercise 2 is enforced here: factual answers that lack cited
  evidence do not leave the platform.
- **Refusal pattern** — when retrieval returns no sufficient
  evidence or the output filter flags, the response is a
  structured refusal, not a plausible-sounding generation.

The output filter plane sits on the egress path of every model
call; it reads the Exercise 1 telemetry contract (prompt id,
retrieval evidence ids, safety outcome) and writes decisions
back to it.

### Prompt-management discipline

The module rationale lists prompt management as a top module
concern and "prompts in code, not versioned" as a top failure.
The submission commits:

- **Versioned prompt store** — every prompt the orchestration
  layer dispatches is loaded from a versioned store with a
  stable id. Inline prompts in application code are rejected
  at review.
- **Eval coverage per prompt** — each prompt has a documented
  evaluation set and the metrics it is governed against (the
  RAG retrieval-evaluation set from Exercise 2 covers RAG
  prompts; non-RAG prompts have their own eval).
- **Prompt change review** — prompt changes follow the same
  governance system (`mod-301/exercise-4`) as architecture
  changes; the review covers the eval delta, the safety-filter
  implications, and the retrieval-coupling implications.

### Audit and incident contract

Safety only works if drift is detectable and incidents are
actionable:

- **Audit log** — every safety-filter outcome, every refusal,
  every prompt dispatch is logged with request id so audits
  reconstruct behavior.
- **Review cadence** — a documented cadence for sampling and
  reviewing safety outcomes (what fired, what refused, what
  slipped). "Set and forget" is a fail signal.
- **Incident response path** — when a safety control fails or
  is bypassed, the incident path triggers prompt / filter /
  retrieval review in parallel. Ties to the HA/DR runbook
  pattern from
  [`../../mod-305-ha-dr/exercise-1/SOLUTION.md`](../../mod-305-ha-dr/exercise-1/SOLUTION.md).

### Cross-cutting invariants

The architect-tier value is in the invariants that span the
safety program:

- **No model call bypasses the safety plane** — the Exercise 1
  layered reference pins this; the Exercise 4 submission
  confirms the ingress and egress enforcement points.
- **Prompts are versioned artifacts** — the orchestration layer
  refuses to dispatch unversioned prompts.
- **Safety outcomes are telemetry** — block / allow / refuse /
  flag outcomes feed the Exercise 1 observability contract so
  Exercise 5 cost signals and safety signals correlate.
- **Retrieved content is treated as untrusted input** — indexed
  documents can carry injection payloads; the input filter
  plane screens retrieved passages the same way it screens user
  queries.

### AI/ML-specific considerations

Safety is where the official sources attach most directly:

- **OWASP ML Security Top 10** — maps to the full submission.
  Prompt-injection screening addresses the input-manipulation
  surface; output filtering and refusal patterns address the
  model-output misuse surface; eval coverage addresses the
  model-quality surface; audit addresses supply-chain /
  integrity visibility (ML06).
- **MITRE ATLAS** — adversarial-prompt detection, injection
  screening, and audit logging are the detection and
  mitigation surfaces for ATLAS reconnaissance and evasion
  technique families. The audit log is where ATLAS-style
  campaigns become visible before user harm.
- **NIST AI RMF** — safety spans *Govern* (prompt-management
  policy, review cadence), *Map* (deployment risk profile),
  *Measure* (safety-outcome telemetry), and *Manage* (incident
  response). The submission names which control attaches to
  which function.

### Decision rationale

A four-section safety submission (input filter plane, output
filter plane, prompt-management, audit / incident) is the right
altitude because the module rationale lists the hallucination /
safety field (output filters, citations, refusals, adversarial
detection) and the prompt-management field as two separate
architect-tier deliverables, and the learner-visible "Safety
Application" title scopes both into one program. Trade-offs the
submission should name:

- *Content filtering has false-positive and false-negative
  costs.* The threshold calibration is a per-deployment call
  with the trade-off recorded.
- *Refusals degrade user experience when the retrieval set is
  thin.* The right fix is corpus / retrieval improvement
  (Exercise 2), not weakening the refusal contract.
- *Prompt management is operational work.* Without it, the
  module's named prompt-in-code failure recurs; with it, every
  prompt change has process cost.

### What stays out of scope

The architect-tier answer **does not** redesign the retrieval
pipeline (Exercise 2), commit the vector store (Exercise 3), or
set the cost / model-selection policy (Exercise 5). The goal
here is a safety program tight enough that an audit can read it
and trace an outcome to a control.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names two separate architect-tier
deliverables that this exercise consolidates: the *prompt-
management discipline (exercise 04 in parent numbering)* and the
*hallucination + safety controls (exercise 05 in parent
numbering)*. The learner-visible title for this exercise is
"Safety Application", and this file carries both because they
share enforcement surfaces (filters, telemetry, review) and
share the primary failure modes graders see. The cost-side
module concerns go to Exercise 5. Cross-cutting invariants and
AI/ML considerations are grounded in NIST AI RMF, OWASP ML Top
10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the safety program lands as versioned
architecture and governance assets:

1. **Safety architecture document** — Markdown with one section
   per field (input filter, output filter, prompt management,
   audit / incident).
2. **Safety plane diagram** — the ingress / egress enforcement
   surfaces around the Exercise 1 model-serving layer, with the
   telemetry / audit edges to observability.
3. **Prompt-store spec** — versioning rule, eval-coverage
   requirement, review workflow, and the enforcement point in
   the orchestration layer.
4. **Filter policy table** — for each filter class (prompt
   injection, adversarial, content category, citation
   enforcement, refusal pattern), the ingress / egress
   placement, the mode (block / log / sample), and the owner.
5. **Audit contract** — the fields logged per safety outcome
   and the review cadence.
6. **Incident response hook** — the path from a safety
   violation to prompt / filter / retrieval review, tied to the
   HA/DR runbook pattern.
7. **AI/ML invariants addendum** — OWASP ML Top 10 mapping per
   control, MITRE ATLAS detection surface, NIST AI RMF function
   alignment per control.
8. **Governance hook** — any filter policy change, prompt-store
   policy change, or audit-contract change requires an ADR via
   the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the safety architecture document. Confirm each of the
   four fields (input filter, output filter, prompt management,
   audit / incident) is present and populated.
2. Confirm the safety plane diagram shows ingress and egress
   enforcement around model serving with no bypass path.
3. Confirm the citation enforcement names the Exercise 2
   citation requirement as its source of truth.
4. Confirm the refusal pattern is a structured output, not an
   unconstrained generation.
5. Confirm the prompt store is named with versioning, eval
   coverage, and review workflow; inline prompts are rejected.
6. Confirm safety outcomes land in the Exercise 1 observability
   contract and are reviewed on a documented cadence.
7. Confirm retrieved documents are treated as untrusted input,
   not only user queries.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Ingress enforcement | Prompt injection + adversarial detection + rate limits | Ingress unprotected |
| Egress enforcement | Content filter + citation + refusal pattern | Egress unprotected or decoration-only |
| Prompt versioning | Versioned store with eval coverage + review | Inline prompts tolerated |
| Audit log | Every outcome logged with request id | Outcomes logged selectively |
| Review cadence | Documented sampling + review process | "Set and forget" |
| Retrieved-content screening | Indexed documents screened like user queries | Only user queries screened |
| AI/ML invariants | OWASP ML Top 10 + MITRE ATLAS + NIST AI RMF mapped per control | Framework alignment absent |
| Scope discipline | RAG / vector store / cost deferred | Deferred decisions inlined |
| Form | Versioned Markdown + diagram | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the safety program deliverable:

1. **Prompts in code, not versioned.** The module rationale
   calls this out as a top failure; a safety program that does
   not require versioned prompts cannot audit prompt-driven
   behavior.
2. **No retrieval eval.** Safety enforcement depends on
   retrieval quality for the citation and refusal contracts;
   without the Exercise 2 eval the "hallucination + irrelevance
   silent" failure recurs even with filters in place.
3. **Egress filters only.** Ingress-side injection and
   adversarial detection are what stop the attack before the
   model runs; egress-only safety is reactive.
4. **Retrieved documents treated as trusted.** Indexed content
   is an attack surface (MITRE ATLAS); screening user queries
   while trusting retrieval passages is a known failure.
5. **Citations as display, not contract.** If the output filter
   does not reject answers that lack cited evidence, citations
   are decoration, and the refusal contract is theoretical.
6. **Audit without review.** Logs no one reads are not an
   audit; the review cadence is what turns audit into
   governance.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
