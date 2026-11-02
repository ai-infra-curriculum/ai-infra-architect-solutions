# SOLUTION — Exercise 2: RAG Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-308-llm-rag/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **retrieval
strategy** deliverable — *vector store choice, embedding model
selection, chunk-size and overlap policy, and hybrid search when
appropriate* — to a concrete enterprise RAG application. The
architect-tier answer is not a retrieval SDK integration guide;
it is a RAG architecture that commits the retrieval contract,
the evaluation seam, and the citation discipline that make
grounded answers measurable rather than aspirational.

The module rationale frames RAG as the primary mechanism the
architect commits for making LLM output grounded, and names "no
retrieval eval" as the top grader-visible failure (hallucination
and irrelevance go silent). This exercise is where the learner
commits the RAG pipeline and the invariants it enforces, so the
vector-store choice (Exercise 3), safety controls (Exercise 4),
and cost / model-selection policy (Exercise 5) have a RAG
contract to attach to.

## 2. Worked answer

A passing RAG application submission produces one linked design
package with four named sections, grounded in the module
rationale's retrieval-strategy fields and the "no retrieval
eval" failure mode:

1. **Corpus and chunking policy** — what goes into the index
   and the chunk-size / overlap commitment.
2. **Retrieval pipeline** — the retrieve-rerank-compose flow and
   the hybrid-search decision.
3. **Citation and grounding contract** — the output must cite
   evidence; the orchestration layer refuses answers that do
   not.
4. **Retrieval evaluation** — the measurement discipline that
   makes retrieval quality a first-class signal.

### Corpus and chunking policy

The submission commits:

- **Corpus inclusion rules** — which document classes are
  indexed, who owns each class, and the ingestion cadence. The
  "who owns" record is the Exercise 1 orchestration seam that
  Exercise 4 safety reviews depend on.
- **Chunk size and overlap** — a single, declared policy per
  document class with the trade-off recorded (small chunks
  improve precision at the cost of context; overlap reduces
  boundary loss at the cost of index size). The module
  rationale names chunk-size + overlap policy as an architect-
  tier commitment, not a per-pipeline tweak.
- **Preprocessing contract** — the normalization, structural
  parsing (tables, lists, code), and PII handling applied
  before chunks are embedded.

### Retrieval pipeline

The retrieval pipeline commits three stages:

- **Retrieve** — the query is embedded and the vector store
  returns top-k candidates. The vector store itself is
  committed in [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md);
  this exercise commits the retrieval surface.
- **Rerank** — a second-stage ranker refines the top-k to the
  top-n used in the prompt. "Hybrid search" (sparse + dense)
  from the module rationale lives here when the corpus has
  structured identifiers (part numbers, policy ids) that dense
  embeddings miss.
- **Compose** — selected passages are composed into the prompt
  through the versioned prompt template from Exercise 1's
  orchestration layer, with provenance preserved for citation.

The hybrid-search decision is explicit: dense-only is the
default; sparse-plus-dense is committed per corpus with the
rationale (keyword-heavy identifiers, long tail terminology)
recorded.

### Citation and grounding contract

Grounded answers require that evidence travel with the
generation. The submission commits:

- **Citation requirement** — every answer passes evidence ids
  to the output and the safety layer (see
  [`../exercise-4/SOLUTION.md`](../exercise-4/SOLUTION.md))
  enforces that at least one cited passage appears for any
  factual claim.
- **Refusal pattern** — when retrieval returns no sufficient
  evidence, the orchestration layer refuses rather than
  generating from parametric knowledge.
- **Provenance in telemetry** — the Exercise 1 observability
  contract carries retrieval evidence ids so audits can
  reconstruct which passage drove which answer.

### Retrieval evaluation

The module rationale makes "no retrieval eval" the top failure.
The submission commits:

- **Evaluation set** — a curated set of query / expected-
  evidence pairs maintained alongside the corpus, versioned the
  same way prompts are versioned in Exercise 1.
- **Metrics** — recall@k and nDCG for the retrieval stage, plus
  faithfulness / groundedness for the end-to-end answer. The
  metric names are examples; the submission commits the
  specific metrics it governs against.
- **Cadence and ownership** — who runs eval, how often, and
  what regression thresholds block a corpus or chunk-policy
  change.

### Cross-cutting invariants

The architect-tier value is in the invariants that cross the
RAG pipeline, not any single stage:

- **No answer without evidence or an explicit refusal** — the
  orchestration layer treats "no evidence" as a terminal state,
  not a prompt to improvise.
- **Retrieval metrics are measured continuously** — the
  Exercise 1 observability contract carries retrieval metrics
  so regression is caught before user-visible hallucination.
- **Corpus changes are reviewable** — ingestion changes require
  an eval re-run; silent corpus drift is the "retrieval
  silently got worse" failure.
- **Tenancy and data-class boundaries cross retrieval** —
  retrieval respects the access-control model from
  [`../../mod-307-data-architecture/exercise-1/SOLUTION.md`](../../mod-307-data-architecture/exercise-1/SOLUTION.md);
  a user cannot pull evidence from a document class they are
  not authorized to read.

### AI/ML-specific considerations

RAG pipelines carry risks a generic search pipeline does not;
grounding against the official sources:

- **OWASP ML Security Top 10** — RAG retrieval expands the
  training / grounding data surface; *ML02: Data Poisoning*
  applies to indexed corpora, and *ML06: AI Supply Chain
  Attacks* applies to the embedding model and third-party
  retrieval components. The citation and provenance contract is
  the mitigation seam.
- **MITRE ATLAS** — adversaries probe RAG systems through
  prompt-injection payloads embedded in indexed documents and
  through retrieval-source enumeration. The Exercise 4 safety
  layer is where these are detected; this exercise commits the
  provenance surface the safety layer needs.
- **NIST AI RMF** — the *Measure* function requires continuous
  measurement; the retrieval-evaluation discipline here is the
  RAG-specific instantiation of that function.

### Decision rationale

A four-section RAG application (corpus / chunking, retrieval
pipeline, citation / grounding, retrieval evaluation) is the
right altitude because the module rationale names those exact
retrieval-strategy fields and makes retrieval evaluation the top
failure to prevent. Trade-offs the submission should explicitly
accept, mirroring the module rationale:

- *Vector stores fragment by capability.* The retrieval
  pipeline commits the stages; the vendor commitment is
  deferred to Exercise 3.
- *Hybrid search is corpus-dependent.* Dense-only is the
  default; sparse-plus-dense is a per-corpus call recorded
  with rationale.
- *Retrieval evaluation is work.* Without it the module's
  "hallucination + irrelevance silent" failure is the default.

### What stays out of scope

The architect-tier answer **does not** commit the vector-store
vendor (Exercise 3), draft the safety / hallucination controls
(Exercise 4), or set the model-selection / cost routing
(Exercise 5). The goal here is the RAG application tight enough
that the later exercises can commit decisions against it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names the retrieval strategy as the
Exercise 03 deliverable with vector-store choice, embedding
model, chunk-size + overlap, and hybrid-search fields. The
learner-visible title for this exercise is "RAG Application",
and this file carries the retrieval-strategy depth as it applies
to the RAG surface the Exercise 1 reference committed; the
vector-store vendor choice is split out to Exercise 3 where the
learner-visible title focuses on the store itself. Cross-cutting
invariants and AI/ML considerations are grounded in NIST AI RMF
(Measure), OWASP ML Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the RAG application lands as versioned
architecture assets, with executable eval harness optional:

1. **RAG architecture document** — Markdown with one section
   per field (corpus / chunking, retrieval pipeline, citation
   contract, retrieval evaluation).
2. **Pipeline diagram** — ingest → chunk → embed → index on
   one side; query → embed → retrieve → rerank → compose on
   the other; the observability plane spanning both.
3. **Chunking policy table** — per document class: chunk size,
   overlap, preprocessing rules, owner.
4. **Evaluation set spec** — the shape of a query / expected-
   evidence pair, the versioning rule, and the regression
   threshold.
5. **Metric contract** — the specific retrieval and
   groundedness metrics tracked and the alert thresholds.
6. **AI/ML invariants addendum** — OWASP ML Top 10 (ML02 /
   ML06) attachment points, MITRE ATLAS detection surface for
   indexed-document injection, NIST AI RMF *Measure*
   alignment.
7. **Governance hook** — chunk-policy changes, corpus-
   inclusion changes, or metric-threshold changes require an
   ADR via the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the RAG architecture document. Confirm each of the four
   fields (corpus / chunking, retrieval pipeline, citation
   contract, retrieval evaluation) is present and populated.
2. Confirm the chunking policy is a single declared policy per
   document class, not per-pipeline.
3. Confirm the retrieval pipeline names the retrieve-rerank-
   compose stages and the hybrid-search decision per corpus.
4. Confirm "no evidence → refuse" is an explicit terminal
   state, not an implicit edge case.
5. Confirm an evaluation set exists, versioned alongside the
   corpus and prompts.
6. Confirm retrieval metrics appear in the Exercise 1
   observability contract.
7. Confirm the vector-store vendor, safety controls, and
   model-selection policy are deferred to exercises 3, 4, and
   5 respectively.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Chunking policy | One policy per document class with trade-off recorded | Chunk sizes vary pipeline-by-pipeline |
| Retrieval stages | Retrieve + rerank + compose named | Single-stage retrieval |
| Hybrid-search decision | Dense default; sparse+dense committed per corpus | Hybrid chosen or skipped globally |
| Citation contract | Evidence travels to output and safety layer | Answers without cited passages |
| Refusal pattern | "No evidence → refuse" declared | Model free-generates on empty retrieval |
| Evaluation set | Versioned alongside corpus + prompts | Eval set absent or ad-hoc |
| Metrics | Specific retrieval + groundedness metrics tracked | Metrics named but thresholds absent |
| Scope discipline | Vector store / safety / cost deferred | Deferred decisions inlined |
| Form | Versioned Markdown + diagram | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the RAG application deliverable:

1. **No retrieval eval.** The module rationale calls this out
   as the top RAG failure. A pipeline without a versioned eval
   set and tracked metrics ships silent regressions.
2. **Prompts in code, not versioned.** RAG prompts carry the
   retrieval-composition logic; keeping them in code hides
   changes that alter grounding behavior. The orchestration
   layer from Exercise 1 is where versioned prompts live.
3. **Model free-generation on empty retrieval.** Treating "no
   evidence" as a soft case rather than a refusal is the
   hallucination surface that defeats RAG.
4. **Single chunk size for all documents.** The architect-tier
   call is a per-document-class policy; one-size-fits-all is
   the default that produces poor retrieval on either precision
   or context.
5. **Citations as a UX decoration.** If citations do not block
   output when missing, they do not change behavior; the
   contract is enforcement, not display.
6. **Hybrid search as a global default.** The module rationale
   says hybrid when appropriate; globally defaulting to hybrid
   pays indexing and query cost on corpora that do not benefit.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
