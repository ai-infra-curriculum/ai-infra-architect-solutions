# SOLUTION — Exercise 1: Data Lakehouse Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-307-data-architecture/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **data architecture
reference document** deliverable — *a lakehouse reference with
bronze / silver / gold tiers, ingestion patterns per source, a
catalog + discovery layer, and an access-control model* — to a
concrete enterprise lakehouse design. The architect-tier answer
is not an inventory of storage services; it is a reference
architecture that commits to the tiering contract, the
per-source ingestion pattern, and the catalog / access seams
that make the lakehouse governable before any ML workload lands
on it.

The module rationale frames the architect tier as the layer that
decides what is possible for ML downstream. The engineer tiers
build the pipelines and tables; the architect tier commits the
tiering contract and the discovery / access boundaries so teams
across the org can integrate against the lakehouse without
re-litigating its shape. This exercise is where the learner
produces that reference and the invariants it enforces.

## 2. Worked answer

A passing lakehouse reference submission produces one linked
design package with four named sections, mirroring the module
rationale's four deliverable fields for Exercise 01:

1. **Bronze / silver / gold tiers** — the storage layout, the
   transformation contract between tiers, and the quality bar
   each tier commits to.
2. **Ingestion patterns per source** — the pattern families
   (batch file drop, CDC, event stream, API pull) with the
   explicit mapping of source to pattern.
3. **Catalog and discovery layer** — the metadata plane that
   makes datasets findable and auditable.
4. **Access-control model** — the authorization frame that
   governs who can read / write each tier.

### Bronze / silver / gold tiers

The module rationale pins the three-tier contract. The
submission commits per tier:

- **Bronze** — raw ingested data, append-only, source-of-truth
  for replay. No cleansing beyond what is required to parse the
  payload. Schema matches source; evolution is tolerant.
- **Silver** — conformed, de-duplicated, joined. Enforces the
  schema evolution policy (see
  [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md)) and
  the data contracts (see
  [`../exercise-4/SOLUTION.md`](../exercise-4/SOLUTION.md)).
- **Gold** — curated for consumption by analytics, ML features,
  and reporting. Business-level semantics; stable schemas with
  explicit deprecation windows.

The transformation contract between tiers is explicit: a silver
table must trace to one or more bronze sources; a gold table
must trace to one or more silver sources. Lineage edges that
jump a tier are a fail signal because they bypass the quality
step.

### Ingestion patterns per source

The module rationale calls out "ingestion patterns per source"
as a required field. The submission names a small, closed set of
patterns and maps each source system to one:

- **Batch file drop** — periodic landing of files from systems
  that cannot stream (vendor exports, mainframe extracts).
- **Change data capture (CDC)** — row-level change feeds from
  operational databases.
- **Event stream** — append-only event topics from applications
  and services (see
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md) for
  the streaming-ingestion architecture).
- **API pull** — scheduled extraction from systems that only
  expose a request/response surface.

Each source in the catalog has exactly one pattern selected,
with the rationale recorded alongside. "Multiple patterns per
source" is a fail signal because it hides which pipeline is
authoritative.

### Catalog and discovery layer

The module rationale names catalog + discovery as a required
field and calls out "catalog without entry curation" as a top
grader-visible failure mode. The submission commits:

- **Dataset entries** — every published silver and gold dataset
  has a catalog entry with owner, source lineage, schema, and
  freshness SLA.
- **Discovery surface** — users (data scientists, analysts,
  platform operators) can find datasets by business term,
  owner, or source system.
- **Curation accountability** — someone is named for keeping
  entries accurate; stale entries are a governance signal, not
  background decay.

Catalog tooling choice (DataHub, Amundsen, vendor) is explicitly
deferred to Exercise 5 (see
[`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md)); this
exercise commits the *layer*, not the tool.

### Access-control model

The access-control model names:

- **Who** — the identity source (SSO group, service identity).
- **What** — the resource shape being authorized (tier, dataset,
  column, row).
- **When / why** — the policy and the audit trail.

Column-level and row-level controls are declared where the data
class requires it (PII, regulated attributes). Access decisions
are logged against the catalog entry so audit queries resolve to
"who read what, when, under which policy".

### Cross-tier invariants

The architect-tier value is in the invariants that cross tiers,
not in any single tier:

- **Lineage end-to-end** — every gold row traces to a silver
  record, which traces to a bronze payload, which traces to a
  source event or file. NIST AI RMF *Govern* and *Measure*
  functions require this traceability.
- **Tenancy carries across tiers** — team / cost-center /
  data-class metadata attached at bronze survives through gold
  so attribution and policy checks resolve at any point in the
  stack.
- **Schema evolution is a policy, not a per-table decision** —
  evolution compatibility class per tier is set in Exercise 3;
  this exercise references the policy, it does not re-litigate
  it.
- **Access decisions are auditable** — the catalog is the
  authoritative record of which policy applied to which read /
  write.

### AI/ML-specific considerations

A lakehouse that feeds ML carries risks the generic analytics
warehouse does not:

- **Training data provenance** — gold datasets consumed as
  training sets must trace back through silver / bronze to the
  originating source. OWASP ML Security Top 10 *ML02: Data
  Poisoning* and *ML06: AI Supply Chain Attacks* targets the
  integrity of this chain.
- **Reconnaissance surface in the catalog** — the discovery
  layer exposes dataset existence, owners, and schemas. MITRE
  ATLAS reconnaissance techniques describe how this metadata
  becomes an attacker's map; access decisions on the catalog
  itself matter.
- **Governance anchor for AI oversight** — NIST AI RMF *Govern*
  function requires that data lifecycle controls (collection,
  storage, access, retention) are documented and enforced; the
  tier contract plus the access-control model is that document
  for data under the AI RMF.

### Decision rationale

A four-section lakehouse reference (tiers, ingestion patterns,
catalog, access) is the right altitude because the module
rationale lists exactly those four fields for Exercise 01.
Trade-offs the submission should explicitly accept, mirroring
the module rationale:

- *Catalog tooling is fragmented in 2026.* The reference commits
  the catalog layer and interfaces; the vendor commitment is
  deferred to Exercise 5.
- *Schema evolution discipline is constant work.* The lakehouse
  reference depends on the Exercise 3 policy being enforced; a
  lakehouse without an evolution policy produces unmaintainable
  silver and gold tiers.
- Streaming vs. batch ingestion is a per-source decision, not a
  global one; the pattern map in this exercise is where that
  per-source call lives.

### What stays out of scope

The architect-tier answer **does not** make the data-mesh vs.
centralized ownership call (deferred to Exercise 3 governance
framing), fix the schema evolution policy (Exercise 3), draft
data contract templates (Exercise 4), or commit the catalog
tool (Exercise 5). The goal here is the lakehouse reference
tight enough that the later exercises can commit decisions
against it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names this deliverable *"Data
architecture reference document (exercise 01)"* with the
tiers / ingestion / catalog / access-control fields. The
learner-visible title for this exercise is "Data Lakehouse
Application", and this file carries the lakehouse reference
architecture and defers the downstream decisions to exercises
2 through 5. Cross-tier invariants and AI/ML considerations are
grounded in NIST AI RMF (Govern / Measure functions), OWASP ML
Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the lakehouse reference lands as versioned
architecture assets, not as a running platform:

1. **Reference architecture document** — Markdown in the
   architecture repository with one section per field
   (tiers, ingestion patterns, catalog, access-control).
2. **Lakehouse diagram** — one diagram showing bronze /
   silver / gold with the catalog drawn across the tiers (not
   beside them) and ingestion patterns annotated per source
   lane.
3. **Ingestion pattern map** — a table mapping each source
   system to exactly one pattern, with rationale and the
   silver-tier conformance target.
4. **Catalog layer spec** — the required dataset-entry fields
   (owner, lineage, schema, freshness SLA, data class) and the
   curation accountability record.
5. **Access-control model** — the identity source, the resource
   shapes (tier / dataset / column / row), and the audit
   contract.
6. **AI/ML invariants addendum** — training-data provenance,
   catalog reconnaissance surface, and the AI RMF alignment
   record. NIST AI RMF, OWASP ML Top 10, and MITRE ATLAS cited
   inline.
7. **Governance hook** — tier contract changes, ingestion
   pattern additions, or access-model changes require an ADR
   via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the reference architecture document. Confirm each of
   the four fields (tiers, ingestion patterns, catalog,
   access-control) is present and populated. Missing field is
   a fail signal.
2. Open the lakehouse diagram. Confirm the catalog is drawn as
   spanning bronze / silver / gold (not sitting beside them).
3. Confirm every source system in the ingestion pattern map
   has exactly one pattern selected. "Multiple patterns per
   source" is a fail signal.
4. Confirm the lineage invariant is testable: a gold row can
   be traced back through silver to bronze and to the source
   event or file.
5. Confirm tenancy metadata (team, cost-center, data class)
   is carried from bronze through gold.
6. Confirm the access-control model names identity, resource
   shape, and audit record — not just a role list.
7. Confirm schema evolution policy, data contract template,
   and catalog tool choice are deferred to the matching later
   exercises, not inlined here.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Tier contract | Bronze / silver / gold with transformation contract | Tiers named but no contract |
| Ingestion mapping | One pattern per source, rationale recorded | Multiple patterns per source |
| Catalog spanning | Catalog drawn across tiers | Catalog drawn as a sibling |
| Lineage invariant | Gold → silver → bronze → source traceable | Chain broken at any tier |
| Tenancy carry-through | Team / cost-center / data class end-to-end | Metadata dropped at a tier boundary |
| Access-control model | Identity, resource, audit record | Role list only |
| AI/ML invariants | Training-data provenance + catalog recon surface named | ML risks absent |
| Scope discipline | Later exercises deferred, not inlined | Policy / tool commitments inlined |
| Form | Versioned Markdown + diagram | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the lakehouse reference deliverable:

1. **Catalog without entry curation.** The module rationale
   calls this out explicitly — "useless search" — and it is the
   dominant lakehouse failure the architect tier is responsible
   for preventing. A reference that commits the catalog layer
   but not the curation accountability record repeats the
   failure.
2. **Multiple ingestion patterns per source.** Hides which
   pipeline is authoritative; silver tier breaks silently when
   patterns disagree.
3. **Lineage chain broken at a tier boundary.** A gold table
   that "mostly" traces to silver is the "cannot reproduce this
   prediction" failure mode when the lakehouse feeds ML.
4. **Access control as a role list.** A list of roles without
   resource shapes and the audit record is not a model; it is a
   placeholder.
5. **Tier contract named but transformation contract absent.**
   Bronze / silver / gold as labels do no work; the quality bar
   per tier and the lineage edge between tiers is what the
   architect tier owes the organization.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
