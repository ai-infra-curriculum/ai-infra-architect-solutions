# SOLUTION — Exercise 3: Vector Databases Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-308-llm-rag/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **retrieval
strategy** deliverable — specifically the *vector-store choice*
field and the module's acknowledgment that *vector stores
fragment by capability* — to a concrete enterprise vector-
database commitment. The architect-tier answer is not a vendor
spec sheet; it is a decision record that commits one vector
store (or a small, scoped set) to carry the RAG pipeline from
Exercise 2, with the capability trade-off, the operational
contract, and the migration seam named explicitly.

The module rationale names Pinecone, Weaviate, pgvector, and
FAISS as the candidate shape and makes "vector stores fragment
by capability" a trade-off deliberately accepted. The architect-
tier value is in the *choice itself and its justification* —
not in writing another vector-store survey. This exercise is
where the learner commits the store and the invariants it must
uphold, so later governance (Exercise 4 safety audit, Exercise 5
cost monitoring) has a specific target to attach to.

## 2. Worked answer

A passing vector-database submission produces one architecture
decision record (ADR) with four named sections, grounded in the
module rationale's retrieval-strategy and trade-off framing:

1. **Capability requirements** — what the RAG pipeline from
   Exercise 2 asks of the store.
2. **Candidate evaluation** — the module-named candidates
   measured against the capability requirements.
3. **Decision and operational contract** — one store (or scoped
   set) committed, with the operational commitments that make
   it governable.
4. **Migration seam** — how the system changes stores if the
   trade-off goes wrong.

### Capability requirements

The submission commits the requirements that *follow from*
Exercise 2 and Exercise 1, not an abstract wishlist:

- **Index scale and update cadence** — number of vectors,
  dimension, write / read ratio, acceptable staleness. These
  come from the Exercise 2 corpus and chunking policy.
- **Query shape** — top-k range, filter / metadata selectivity,
  hybrid (sparse + dense) support when the Exercise 2 pipeline
  commits hybrid for any corpus.
- **Tenancy and isolation** — multi-tenant namespacing or
  per-tenant indices; access-control enforcement at the store
  surface (not only at the application layer).
- **Operational envelope** — availability target, backup /
  restore guarantee, observability hooks, and the deployment
  shape (managed service, self-hosted, in-DB extension).

### Candidate evaluation

The submission measures the module-named candidates against the
capability requirements:

- **Pinecone** — managed, dense + sparse hybrid, metadata
  filtering, strong operational envelope at a managed-service
  cost. Trade-off: vendor lock-in and recurring spend.
- **Weaviate** — open source and managed options, hybrid search,
  schema and modules support. Trade-off: operational burden
  when self-hosted.
- **pgvector** — Postgres extension; near-zero operational
  burden if Postgres is already a committed system. Trade-off:
  index scale ceiling and query performance under high
  dimensions and large k.
- **FAISS** — library, not a service; strongest for in-process
  low-latency retrieval. Trade-off: no multi-tenant surface,
  no managed life cycle; typically wrapped by another system.

The submission records how each candidate scores against the
Exercise 2 requirements. "All candidates equivalent" is a fail
signal because the module rationale makes capability fragmentation
explicit.

### Decision and operational contract

One choice is committed, with the operational contract named:

- **Chosen store and version** — the specific commitment and
  the pinned version policy.
- **Index topology** — one index vs. per-tenant vs. per-corpus,
  with the rationale (the Exercise 2 tenancy invariant).
- **Backup / replay** — how the index is reconstructed from the
  source corpus if lost; this is the Exercise 2 ingestion
  pipeline being idempotent.
- **Metadata and filtering model** — the fields stored
  alongside vectors (document class, owner, data class) that
  support the Exercise 2 citation contract and the Exercise 1
  tenant-attribution invariant.
- **Access-control enforcement** — identity, resource shape,
  audit record at the store surface, aligned with the
  lakehouse access-control model from
  [`../../mod-307-data-architecture/exercise-1/SOLUTION.md`](../../mod-307-data-architecture/exercise-1/SOLUTION.md).

### Migration seam

Vector stores fragment by capability; the module rationale makes
this an accepted trade-off, not a decision avoided. The
submission commits:

- **Rebuild path** — the index is a derived artifact of the
  Exercise 2 corpus; a full rebuild on a different store is the
  escape hatch.
- **Interface abstraction** — the Exercise 1 retrieval contract
  does not leak store-specific SDK calls into orchestration;
  the retrieval layer owns the adapter.
- **Trigger conditions** — the specific signals that would
  justify re-opening the decision (query latency, cost per
  million queries, capability gap for a new workload).

### Cross-cutting invariants

The architect-tier value is in the invariants that make the
chosen store governable:

- **Store is reconstructible from the corpus** — losing the
  index is a recovery event, not a data-loss event; the
  Exercise 2 ingestion pipeline is the authority.
- **Access-control decisions are enforced at the store surface**
  — application-layer-only enforcement is bypassable; the
  store must enforce at the query surface.
- **Observability hooks exist** — the Exercise 1 telemetry
  contract gets query latency, recall-indicator (where the
  store exposes it), cost signals, and error rate from the
  store.
- **Vendor cost rolls up to Exercise 5 cost monitoring** — if
  the store is a managed service, its spend lands in the cost
  signals Exercise 5 governs.

### AI/ML-specific considerations

A vector store that backs RAG carries risks a generic
operational database does not; grounded against the official
sources:

- **OWASP ML Security Top 10** — the index is an ML artifact
  derived from the corpus; *ML02: Data Poisoning* applies when
  the corpus is poisoned and the index silently propagates it,
  and *ML06: AI Supply Chain Attacks* applies to the embedding
  model and the store itself. Rebuild and provenance invariants
  are the mitigation seam.
- **MITRE ATLAS** — adversaries probe RAG systems through
  retrieval-source enumeration; access-control at the store
  surface and query-rate limits are detection / mitigation
  points for ATLAS reconnaissance techniques.
- **NIST AI RMF** — the *Manage* function requires that the
  vendor / supplier relationship is governed; a committed
  vector-store vendor sits inside that scope with the
  operational contract committed here.

### Decision rationale

A four-section ADR (capability requirements, candidate
evaluation, decision + operational contract, migration seam) is
the right altitude because the module rationale names the
vector-store choice as the architect-tier commitment and makes
capability fragmentation the trade-off deliberately accepted.
Additional trade-offs the submission should name:

- *Managed vs. self-hosted is a cost / operability trade-off,
  not a capability one.* The decision records why either side
  of the trade-off was chosen.
- *Embedding model choice is coupled to the store.* Changing
  the embedding model requires a full rebuild; the Exercise 2
  pipeline treats embedding model as a versioned dependency.
- *In-DB (pgvector) wins when Postgres is already an invariant.*
  Standing up a separate vector service to serve a small index
  is overhead the module rationale would flag.

### What stays out of scope

The architect-tier answer **does not** redesign the RAG
pipeline (Exercise 2), draft the safety / hallucination controls
(Exercise 4), or set the cost / model-selection policy
(Exercise 5). The goal here is a defensible vector-store commit
tight enough that the rest of the stack can operate against it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names vector-store choice as a field
of the retrieval-strategy deliverable (Exercise 03 in the parent
numbering) and names "vector stores fragment by capability" as a
trade-off deliberately accepted. The learner-visible title for
this exercise is "Vector Databases Application", and this file
carries the ADR for the specific store commitment. Cross-cutting
invariants and AI/ML considerations are grounded in NIST AI RMF
(Manage), OWASP ML Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the vector-database decision lands as a
versioned ADR plus the operational artifacts that make it
governable:

1. **Architecture decision record** — Markdown ADR with the four
   fields (capability requirements, candidate evaluation,
   decision + operational contract, migration seam).
2. **Candidate scoring table** — Pinecone / Weaviate /
   pgvector / FAISS scored against the capability requirements
   with cells carrying rationale, not just scores.
3. **Operational contract** — index topology, backup / replay
   rule, metadata schema, access-control decisions, deployment
   shape.
4. **Retrieval adapter contract** — the interface the Exercise 1
   retrieval layer uses so a future migration does not require
   orchestration-level changes.
5. **Telemetry mapping** — the specific store signals that land
   in the Exercise 1 observability contract.
6. **AI/ML invariants addendum** — OWASP ML Top 10 (ML02 /
   ML06) attachment, MITRE ATLAS reconnaissance surface at the
   store, NIST AI RMF *Manage* alignment for vendor /
   supplier governance.
7. **Governance hook** — a change in the chosen store, index
   topology, or embedding model requires an ADR via the
   governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the ADR. Confirm each of the four fields (capability
   requirements, candidate evaluation, decision + operational
   contract, migration seam) is present and populated.
2. Confirm the capability requirements trace back to the
   Exercise 2 RAG pipeline (corpus size, query shape, hybrid
   needs, tenancy).
3. Confirm every module-named candidate (Pinecone, Weaviate,
   pgvector, FAISS) appears in the scoring table with rationale.
4. Confirm one store is committed and the operational contract
   names topology, backup, metadata, and access control.
5. Confirm the migration seam names the retrieval adapter and
   the specific trigger conditions.
6. Confirm the access-control decisions enforce at the store
   surface, not only in the application layer.
7. Confirm the store's telemetry signals land in Exercise 1
   observability and Exercise 5 cost monitoring.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Requirements traced | Capability requirements follow Exercise 2 | Requirements abstract or unanchored |
| Candidate coverage | Pinecone / Weaviate / pgvector / FAISS scored with rationale | Candidate list without evaluation |
| Decision clarity | One store committed with version policy | "Any of these" or deferred decision |
| Operational contract | Topology + backup + metadata + access control | Decision made, operation unaddressed |
| Migration seam | Adapter + trigger conditions named | "We'd migrate if needed" without specifics |
| Store-level ACL | Enforcement at the query surface | Application-layer only |
| AI/ML invariants | OWASP ML (ML02/ML06) + MITRE ATLAS + NIST AI RMF *Manage* mapped | ML risks absent |
| Scope discipline | RAG pipeline / safety / cost deferred | Deferred decisions inlined |
| Form | Versioned Markdown ADR | Spreadsheet-only comparison |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the vector-database deliverable:

1. **Vendor comparison without a decision.** A survey of
   candidates is not an ADR; the architect-tier output is the
   choice and its justification.
2. **Capability requirements written as an abstract wishlist.**
   The requirements must trace to the Exercise 2 corpus / query
   / tenancy / hybrid commitments. "Supports vectors" is not a
   requirement.
3. **Access control at the application layer only.** The
   module-rationale "catalog without curation" failure
   translates here as "store without ACL enforcement";
   application-layer-only enforcement is bypassable from any
   caller that reaches the store.
4. **No migration seam.** The module rationale names
   fragmentation as an accepted trade-off; accepting it without
   a rebuild path is the "locked-in by accident" failure mode.
5. **Embedding model treated as a free variable.** Changing the
   embedding model requires a full index rebuild; the ADR must
   acknowledge the embedding dependency, not treat it as
   independently swappable.
6. **In-DB vector in a Postgres-committed shop ignored.**
   Standing up a separate managed service when pgvector would
   fit is the kind of avoidable cost the module rationale's
   "LLM cost grows linearly" warning applies to indirectly.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
