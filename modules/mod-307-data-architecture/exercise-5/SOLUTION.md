# SOLUTION — Exercise 5: Data Quality Application (Catalog + Lineage)

> Pairs with
> `ai-infra-architect-learning/lessons/mod-307-data-architecture/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **catalog strategy**
deliverable — *discovery + lineage + glossary; reference uses
DataHub or Amundsen; the decision considers OSS maturity vs.
vendor support* — as the quality-and-trust layer that makes
Exercises 1 through 4 observable. The architect-tier answer is
not a tool deployment; it is a catalog strategy that commits
discovery, lineage, and glossary as a measurement surface and
chooses the tool against stated criteria.

The module rationale frames the catalog as the layer that turns
the architecture (tiering, streaming, ownership, contracts)
into something teams can find, trust, and audit. The learning
exercise's "Data Quality" framing resolves naturally into
catalog + lineage: quality trends are only visible if datasets
are catalogued, their lineage is traced, and consumers can see
contract compliance in context.

## 2. Worked answer

A passing catalog submission produces one linked package with
four named sections, mirroring the module rationale's catalog
fields:

1. **Discovery surface** — how users find datasets, topics,
   and features by business term, owner, or source.
2. **Lineage model** — the edges captured end-to-end across
   streams, bronze / silver / gold, and consumer applications.
3. **Business glossary** — the controlled vocabulary that
   connects discovery to business semantics.
4. **Tool decision record** — DataHub, Amundsen, or vendor,
   with the OSS-maturity vs. vendor-support trade-off recorded.

### Discovery surface

The discovery surface commits:

- **Entity coverage** — bronze / silver / gold datasets from
  Exercise 1 (see
  [`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md)),
  topics from Exercise 2 (see
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md)),
  and the ML feature sources downstream. Features surfaced in
  the discovery UI are the training/serving skew defense from
  Exercise 4.
- **Search axes** — business term, owner (from Exercise 3's
  ownership map), source system, data class, and compatibility
  class.
- **Entry-curation accountability** — who keeps entries
  accurate; stale entries are a governance signal, not
  background decay (the module names "catalog without entry
  curation" as a top failure mode).

### Lineage model

Lineage is where quality becomes auditable. The submission
commits:

- **Edge coverage** — producer → topic (from streams), topic →
  bronze, bronze → silver, silver → gold, gold → consumer
  (reports, ML features, ML models). The Exercise 1 lakehouse
  lineage invariant and the Exercise 2 stream-to-bronze edge
  both land here.
- **Contract tie-in** — each lineage edge records the active
  contract version (from Exercise 4) so a change in contract
  version is visible as a lineage event, not a schema diff
  surprise.
- **Impact query support** — "what breaks if this contract is
  retired" is a standing query the catalog must answer.
- **ML extension** — lineage extends into the model training
  dataset so a production prediction traces to a feature
  snapshot, a training dataset version, and the contracts in
  force when the training ran.

### Business glossary

The glossary commits:

- **Term definitions** — the business entities (customer,
  order, inventory) with the authoritative definition and the
  domain owner from Exercise 3.
- **Term-to-asset bindings** — each term binds to the datasets
  / topics / features that implement it, so discovery resolves
  "where is customer defined" to the actual silver / gold
  tables.
- **Glossary governance** — term changes flow through the
  Exercise 3 exception / ADR path; the glossary is not a wiki.

### Tool decision record

The module rationale pins the trade-off explicitly: *the
reference uses DataHub or Amundsen; the decision considers
OSS-maturity vs. vendor support.* The submission records:

- **The choice** — DataHub, Amundsen, or a vendor, named with
  version.
- **The OSS-maturity vs. vendor-support axes** — community
  activity, feature coverage against the fields above, upgrade
  path, support contract availability. The module rationale
  calls out "catalog tooling is fragmented in 2026" as a
  deliberately accepted trade-off; the decision is time-stamped.
- **The reconsideration trigger** — the condition under which
  the tool choice is re-evaluated (vendor acquisition, OSS
  stewardship change, scale breakpoint).

### Cross-cutting invariants

The architect-tier value is in the invariants that cross the
catalog:

- **Every entity in the lakehouse / stream has a catalog
  entry.** Datasets, topics, and features all surface in
  discovery; dark data is a governance signal.
- **Every edge in the data plane is a lineage edge.** The
  catalog is the source of truth for lineage, aligned with the
  AI RMF *Govern* function requirement that AI data flow be
  documented.
- **Glossary terms resolve.** Every published glossary term
  binds to at least one asset, or is retired.
- **Tool choice is revisited on trigger.** The decision record
  is dated; the reconsideration trigger is named.

### AI/ML-specific considerations

Catalog + lineage for ML carries risks the generic analytics
catalog does not:

- **Reproducibility of predictions** — a production prediction
  must trace to the feature snapshot, the trained model
  artifact, the training dataset version, and the contracts
  that were in force. The lineage model's ML extension is this
  reproducibility surface.
- **OWASP ML Security Top 10 *ML06: AI Supply Chain Attacks***
  — the catalog is where the ML supply chain becomes visible;
  training data provenance, feature provenance, and model
  provenance are the chain-of-custody record.
- **MITRE ATLAS reconnaissance surface** — the catalog
  concentrates sensitive metadata (dataset names, schemas,
  sample values, lineage to ML models). Discovery access
  control is itself a governance decision.
- **NIST AI RMF *Measure* and *Manage* functions** — contract
  violation rates, lineage completeness, and glossary binding
  rates are first-class measurement signals; the catalog is
  the measurement surface.

### Decision rationale

A four-section catalog package (discovery, lineage, glossary,
tool decision) is the right altitude because the module
rationale names those four fields for Exercise 05 and pins the
OSS-maturity vs. vendor-support trade-off. The submission
should explicitly accept:

- *Catalog tooling is fragmented in 2026.* The decision is
  dated; the reconsideration trigger is explicit.
- *Catalog without entry curation is useless search.* The
  curation accountability record is non-negotiable.
- *Lineage must be end-to-end to serve ML.* A catalog that
  stops at silver cannot reproduce a prediction.

### What stays out of scope

The architect-tier answer **does not** redefine lakehouse
tiering (Exercise 1), streaming topology (Exercise 2),
ownership or schema evolution policy (Exercise 3), or the
contract template (Exercise 4). The goal here is the catalog
strategy tight enough that the operating organization can
measure quality against the earlier commitments and audit the
data plane end-to-end.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names the *"Catalog strategy
(exercise 05)"* with discovery + lineage + glossary and the
DataHub / Amundsen / vendor trade-off. The learner-visible
title for this exercise is "Data Quality Application", and
this file carries the catalog strategy as the quality
measurement surface because quality visibility is a catalog
and lineage problem once Exercises 1 through 4 are in place.
Cross-cutting invariants and AI/ML considerations are grounded
in NIST AI RMF (Govern, Measure, Manage functions), OWASP ML
Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the catalog strategy lands as versioned
strategy assets, not as a running catalog:

1. **Catalog strategy document** — Markdown with one section
   per field (discovery, lineage, glossary, tool decision).
2. **Entity-coverage checklist** — which Exercise 1 datasets,
   Exercise 2 topics, and downstream features are catalogued.
   Gaps are tracked, not hidden.
3. **Lineage model spec** — the edge types captured and the
   contract-version tie-in rule.
4. **Glossary governance record** — term definition template,
   owner, and the ADR path for term changes.
5. **Tool decision ADR** — DataHub / Amundsen / vendor
   decision with the dated OSS-maturity vs. vendor-support
   analysis and the reconsideration trigger.
6. **AI/ML invariants addendum** — prediction reproducibility,
   ML supply chain record, discovery access-control decision.
   NIST AI RMF, OWASP ML Top 10, MITRE ATLAS cited inline.
7. **Governance hook** — tool choice changes, lineage model
   extensions, or glossary governance changes require an ADR
   via the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the strategy document. Confirm each of the four
   fields (discovery, lineage, glossary, tool decision) is
   present and populated.
2. Open the entity-coverage checklist. Confirm every Exercise
   1 dataset, every Exercise 2 topic, and the downstream ML
   features are listed and either catalogued or on an
   explicit backlog.
3. Open the lineage model spec. Confirm the edge types cover
   producer → topic → bronze → silver → gold → consumer, and
   that contract-version is recorded on the edge.
4. Confirm the glossary governance record names the term
   definition template, the owner, and the ADR path.
5. Open the tool-decision ADR. Confirm the choice, the
   dated OSS-maturity vs. vendor-support analysis, and the
   reconsideration trigger.
6. Confirm the ML invariants (reproducibility, supply chain,
   discovery access) are named.
7. Confirm the strategy does not re-litigate Exercises 1
   through 4.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Entity coverage | Datasets + topics + features catalogued | Dark data unlisted |
| Search axes | Business term + owner + source + class | Owner-only search |
| Lineage edges | Producer → topic → bronze → silver → gold → consumer | Lineage stops at silver |
| Contract tie-in | Contract version on lineage edge | Edges without contracts |
| Glossary bindings | Every term binds to assets | Terms without bindings |
| Curation accountability | Named curator; stale entries flagged | No curation record |
| Tool decision | Dated ADR + trade-off + reconsideration trigger | Tool named without ADR |
| AI/ML invariants | Reproducibility + ML supply chain + ATLAS recon | ML risks absent |
| Scope discipline | Earlier exercises not re-litigated | Policy / contract re-written |
| Form | Versioned Markdown + ADR | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the catalog deliverable:

1. **Catalog without entry curation.** The module rationale
   names this directly: "useless search." A catalog strategy
   that commits a tool but not the curation accountability
   repeats the failure mode.
2. **Lineage that stops at silver.** A catalog that cannot
   trace a production prediction back through gold → silver →
   bronze → source cannot support AI RMF *Measure* or
   reproducibility; it is not an ML-safe catalog.
3. **Glossary as a wiki.** Terms without owners and without
   asset bindings decay; the glossary becomes narrative
   instead of a governed vocabulary.
4. **Tool choice without reconsideration trigger.** The
   module rationale calls out that catalog tooling is
   fragmented in 2026; a dated decision without a
   reconsideration trigger will drift into vendor lock-in.
5. **Catalog treated as a tooling project.** The strategy is
   discovery + lineage + glossary + decision; tool selection
   is the smallest of the four fields, not the whole exercise.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
