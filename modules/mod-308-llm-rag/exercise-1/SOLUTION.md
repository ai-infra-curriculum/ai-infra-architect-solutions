# SOLUTION — Exercise 1: LLM Architecture Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-308-llm-rag/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **reference LLM
platform architecture** deliverable — *a layered reference with
model serving, retrieval, orchestration, observability, and
safety, each layer carrying an interface contract* — to a
concrete enterprise LLM platform. The architect-tier answer is
not an inventory of inference servers; it is a reference
architecture that commits the layer stack, the interface
contract between layers, and the governance seams that let later
exercises commit decisions against the stack without
re-litigating its shape.

The module rationale frames LLM serving at enterprise scale as
"not deploy an inference server" but a stack of five concerns:
RAG retrieval, multi-model routing, prompt-management
governance, hallucination / quality controls, and cost
forecasting. This exercise is where the learner produces the
layered reference and the invariants it enforces, so Exercises 2
through 5 — RAG, vector databases, safety, cost optimization —
have an architecture to attach to.

## 2. Worked answer

A passing LLM platform reference submission produces one linked
design package with five named layers, mirroring the module
rationale's layered frame for the Exercise 01 deliverable:

1. **Model serving** — the inference surface and the model
   runtime commitments.
2. **Retrieval** — the RAG surface that makes grounded answers
   possible, deferred in depth to Exercise 2.
3. **Orchestration** — the request router, prompt-template
   dispatch, and multi-model routing seam.
4. **Observability** — the telemetry contract that makes cost,
   latency, quality, and safety measurable.
5. **Safety** — the input / output filter plane that is enforced
   around every model call, deferred in depth to Exercise 4.

Each layer declares its interface contract: who calls it, what
it returns, and what guarantees it carries across the boundary.

### Model serving layer

The model serving layer owns the inference surface and the model
runtime. The submission commits:

- **Serving surface** — the request / response contract exposed
  to orchestration (not to end-users directly).
- **Model inventory** — the set of models the platform serves,
  distinguishing OSS self-hosted (e.g. Llama, Mistral family)
  from commercial API (e.g. OpenAI, Anthropic) from self-hosted
  commercial. The *selection policy* across these is deferred to
  [`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md),
  which carries the module's cost / capability trade-off.
- **Capacity and isolation** — tenancy and quota contract per
  caller so one workload cannot starve another.

### Retrieval layer

The retrieval layer is the RAG surface. The reference commits
the layer boundary; the depth lives in Exercises 2 and 3:

- **Retrieval contract** — orchestration asks for context by
  query + policy; retrieval returns ranked passages with
  provenance.
- **Vector store seam** — the vector-store choice (Pinecone /
  Weaviate / pgvector / FAISS as module-named candidates) is
  committed in [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md);
  this exercise commits that there is one.
- **RAG pattern** — the retrieval-then-generation flow, with
  the citation requirement surfacing in Exercise 4's safety
  controls.

### Orchestration layer

Orchestration owns the request lifecycle. The submission
commits:

- **Prompt-template dispatch** — the orchestration layer loads
  prompts from the versioned prompt store, not from inline
  strings. Prompt-management discipline (versioning, eval
  coverage, review) is a cross-cutting invariant anchored in
  this layer.
- **Multi-model routing** — the module rationale pins
  multi-model routing as an architect-tier concern for cost /
  capability balance. Orchestration is the routing point; the
  routing *policy* is committed in
  [`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md).
- **Request shaping** — the orchestration layer composes the
  retrieval output with the prompt template and passes the
  shaped request to model serving.

### Observability layer

Observability spans the stack. The submission commits:

- **Telemetry contract** — every model call emits token counts,
  latency, model id, prompt id, retrieval evidence ids, and
  safety-filter outcome.
- **Quality signals** — retrieval evaluation metrics (the
  module calls out "no retrieval eval" as a top failure mode)
  and output-quality signals land here, with the measurement
  depth in [`../exercise-4/SOLUTION.md`](../exercise-4/SOLUTION.md).
- **Cost signals** — token-level cost per request is a
  first-class signal so Exercise 5 can commit the routing /
  monitoring policy against measured data.

### Safety layer

Safety is enforced around every model call, not bolted on. The
reference commits the layer boundary; the depth lives in
Exercise 4:

- **Input filter** — adversarial-prompt detection and
  prompt-injection screening before the model is called.
- **Output filter** — citation requirements, refusal patterns,
  and content filters applied before the response leaves the
  platform.
- **Audit trail** — safety outcomes are a telemetry channel so
  violations are reviewable, not silent.

### Cross-layer invariants

The architect-tier value is in the invariants that cross the
five layers, not any single layer:

- **Every call is traceable end-to-end** — orchestration request
  id ties retrieval evidence, prompt version, model id, and
  safety-filter outcome in observability. NIST AI RMF *Measure*
  and *Govern* functions require this traceability.
- **Prompts are versioned and reviewable** — the orchestration
  layer refuses to dispatch an unversioned prompt; the module
  rationale calls out "prompts in code, not versioned" as a top
  failure.
- **No model call bypasses safety** — safety filters are the
  only ingress / egress to the model-serving layer from
  orchestration; a backdoor path is a fail signal.
- **Cost is attributable per call** — every request carries
  caller / tenant / cost-center attribution for Exercise 5 and
  for [`mod-304-cost-finops/exercise-1/SOLUTION.md`](../../mod-304-cost-finops/exercise-1/SOLUTION.md).

### AI/ML-specific considerations

An LLM platform carries risks a generic serving platform does
not; grounding the layered reference against the official
sources:

- **OWASP ML Security Top 10** — the RAG and prompt plane expose
  the ML supply chain and data-poisoning surfaces the OWASP ML
  Top 10 enumerates; the layered reference names where each
  control attaches (retrieval provenance, prompt-store integrity,
  model-inventory signing).
- **MITRE ATLAS** — reconnaissance against an LLM platform
  targets prompt leakage, retrieval-source enumeration, and
  model-behavior probing; the observability layer is also the
  detection surface for ATLAS techniques.
- **NIST AI RMF** — the *Govern*, *Map*, *Measure*, and *Manage*
  functions require that the platform documents what it serves,
  measures how it behaves, and manages the risk continuously;
  the five-layer reference is the structure that lets each
  function land somewhere specific.

### Decision rationale

A five-layer LLM platform reference (model serving, retrieval,
orchestration, observability, safety) is the right altitude
because the module rationale names exactly those five layers for
the Exercise 01 deliverable and gives each an interface-contract
expectation. Trade-offs the submission should explicitly accept,
mirroring the module rationale:

- *OSS self-hosting saves money at scale but is complex to
  operate.* The model-serving layer carries both runtime
  classes; the policy that chooses between them is deferred to
  Exercise 5.
- *Vector stores fragment by capability.* The retrieval layer
  commits the seam; the vendor commitment is deferred to
  Exercise 3.
- *LLM cost grows roughly linearly with usage.* The
  observability layer treats cost as a first-class telemetry
  signal so Exercise 5 can commit routing / budgets against
  measured data.

### What stays out of scope

The architect-tier answer **does not** commit the vector-store
vendor (deferred to Exercise 3), draft the safety-control
specifics (Exercise 4), set the model-selection / cost policy
(Exercise 5), or detail the RAG retrieval pipeline (Exercise 2).
The goal here is the layered reference tight enough that the
later exercises can commit decisions against it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names this deliverable *"Reference
LLM platform architecture (exercise 01)"* with the layered
fields (model serving / retrieval / orchestration /
observability / safety) and the interface-contract requirement.
The learner-visible title for this exercise is "LLM Architecture
Application", and this file carries the layered reference and
defers the downstream decisions to exercises 2 through 5.
Cross-layer invariants and AI/ML considerations are grounded in
NIST AI RMF, OWASP ML Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the LLM platform reference lands as versioned
architecture assets, not as a running platform:

1. **Reference architecture document** — Markdown in the
   architecture repository with one section per layer (model
   serving, retrieval, orchestration, observability, safety)
   and the interface contract for each.
2. **Platform diagram** — one diagram showing the five layers
   with the request flow annotated (orchestration → retrieval →
   orchestration → safety → model serving → safety →
   orchestration) and the observability plane spanning the
   stack.
3. **Interface contract tables** — one table per layer naming
   the inputs, outputs, and guarantees across the boundary.
4. **Model inventory record** — the OSS / commercial / self-hosted
   commercial classification per served model (policy for
   selection is deferred).
5. **Telemetry contract** — the per-call fields emitted
   (request id, prompt id, retrieval ids, model id, token
   counts, latency, safety outcome, cost, tenant attribution).
6. **AI/ML invariants addendum** — OWASP ML Top 10 mapping to
   layer, MITRE ATLAS reconnaissance / detection surface, and
   NIST AI RMF function alignment.
7. **Governance hook** — layer-contract changes or model-inventory
   additions require an ADR via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the reference architecture document. Confirm each of
   the five layers (model serving, retrieval, orchestration,
   observability, safety) is present and populated with an
   interface contract. Missing layer is a fail signal.
2. Confirm the platform diagram shows the request flow passing
   through safety before and after model serving, with no
   bypass path.
3. Confirm the observability plane spans all five layers in
   the diagram, not sitting beside them.
4. Confirm the model inventory classifies each served model as
   OSS self-hosted, commercial API, or self-hosted commercial,
   and *does not* select among them (deferred to Exercise 5).
5. Confirm the telemetry contract includes prompt id, retrieval
   evidence ids, safety outcome, and cost attribution.
6. Confirm prompt-management discipline (versioning, eval
   coverage, review) is anchored to the orchestration layer.
7. Confirm the vector-store choice, RAG pipeline depth, safety
   controls, and model-selection / cost policy are deferred to
   exercises 2, 3, 4, and 5 respectively, not inlined.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Layer completeness | Five layers each committed with an interface contract | Missing layer or contract |
| Request flow | Flow traverses safety on ingress and egress | Safety bypass path exists |
| Observability spanning | Observability drawn across all five layers | Observability drawn as a sibling |
| Model inventory | OSS / commercial / self-hosted commercial classified per model | Inventory listed but unclassified |
| Prompt discipline | Prompt versioning anchored to orchestration | Prompts dispatched from code |
| Telemetry contract | Prompt id, retrieval ids, safety outcome, cost attribution emitted | Fields missing |
| Traceability invariant | Request id ties retrieval, prompt, model, safety end-to-end | Chain broken at a layer |
| AI/ML invariants | OWASP ML Top 10 + MITRE ATLAS + NIST AI RMF mapped to layer | ML risks absent |
| Scope discipline | Vector store / safety / cost / RAG depth deferred | Deferred decisions inlined |
| Form | Versioned Markdown + diagram | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the LLM platform reference deliverable:

1. **Prompts in code, not versioned.** The module rationale
   calls this out as a top failure. A reference that commits
   the orchestration layer but does not anchor prompt
   versioning to it repeats the failure.
2. **No retrieval eval.** The observability layer must treat
   retrieval quality as a first-class signal; "no retrieval
   eval" is the module's named "hallucination + irrelevance
   silent" failure mode.
3. **Single-model architecture.** A reference that assumes one
   model for every request pays the strongest model's price
   for every call; the orchestration layer must expose a
   multi-model routing seam even if the policy is deferred.
4. **No cost monitoring on commercial APIs.** The module
   rationale calls out "surprise bills" as a top failure; the
   observability contract must include cost attribution so
   Exercise 5 has signal to govern.
5. **Safety as a bolt-on.** Safety filters attached only to the
   egress path leave the ingress path (prompt injection,
   adversarial queries) uncovered. The layer sits around the
   model, not after it.
6. **Observability as a sibling layer.** Telemetry must span
   the stack; a telemetry layer that only watches model serving
   cannot explain retrieval or routing decisions.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
