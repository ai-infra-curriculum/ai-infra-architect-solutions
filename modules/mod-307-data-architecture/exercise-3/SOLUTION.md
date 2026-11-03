# SOLUTION — Exercise 3: Governance Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-307-data-architecture/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **data-mesh vs.
centralized decision** deliverable, together with the module's
**schema evolution policy** deliverable, to a concrete
governance frame for the lakehouse. The architect-tier answer
is not a RACI chart; it is a governance decision — centralized
or data-mesh ownership — plus the schema-evolution policy that
protects consumers when ownership changes shape over time.

The module rationale pins ownership as one of the four
architect-tier frames (lakehouse tiering, streaming vs. batch,
ownership, schema evolution). Ownership decides who is
accountable for a dataset's quality and compatibility; schema
evolution decides how that quality survives change. Together
they are the governance layer that keeps the Exercise 1
lakehouse and the Exercise 2 streams usable by downstream ML.

## 2. Worked answer

A passing governance submission produces one linked policy
package with four named sections, mirroring the module
rationale's ownership and schema-evolution deliverables:

1. **Ownership model decision** — data-mesh vs. centralized,
   with the organizational prerequisites recorded.
2. **Domain / dataset ownership map** — who owns which bronze
   / silver / gold assets and which topics.
3. **Schema evolution policy** — forward / backward / full
   compatibility class per data class, with the
   breaking-change workflow.
4. **Exception and ADR path** — how exceptions to the policy
   are tracked and how governance decisions are versioned.

### Ownership model decision

The module rationale pins the scaling threshold explicitly:
*centralized data platforms scale to ~5-10 producing teams;
past that, data mesh (domain ownership) tends to scale
better.* The submission records:

- **The decision** — centralized or data-mesh, naming the
  producing-team count and the reasoning.
- **The organizational prerequisites** — the module rationale
  calls out *mature engineering culture* and *willing domain
  owners* as data-mesh prerequisites. The submission confirms
  these before committing data-mesh, or justifies the
  centralized choice.
- **The migration path** — if data-mesh is chosen but
  prerequisites are partial, the sequencing by which domains
  take ownership.

"Data-mesh declared but no domain ownership" is the top
grader-visible failure the module names; the submission's
ownership map is the structural fix.

### Domain / dataset ownership map

The map commits:

- **Domains** — the organizational slices that own data
  (customer, order, inventory, etc.). "Platform team owns
  everything" is the centralized default; the data-mesh
  variant names domains explicitly.
- **Assets per domain** — the bronze / silver / gold datasets
  from Exercise 1 (see
  [`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md))
  and the topics from Exercise 2 (see
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md))
  mapped to their domain owner.
- **Cross-domain references** — the explicit record of which
  domains consume from which, so the data contract templates
  in Exercise 4 (see
  [`../exercise-4/SOLUTION.md`](../exercise-4/SOLUTION.md))
  know which consumer sets to sign.

### Schema evolution policy

The module rationale pins the compatibility classes:

- **Forward compatibility** — new producers can emit data that
  old consumers can still read.
- **Backward compatibility** — new consumers can read data that
  old producers emitted.
- **Full compatibility** — both of the above.

The policy commits a compatibility class per data class (PII,
regulated, operational, analytical) with the module rationale's
rule: *breaking changes require version bumps and consumer
migration windows.* The submission names:

- **The per-data-class compatibility default** — the class
  required for each data class.
- **The breaking-change workflow** — version bump, consumer
  notification, migration window length, and the acceptance
  gate for retiring the old version.
- **The schema-registry enforcement point** — the policy is
  enforced at publish for streams (see
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md))
  and at ingestion for batch sources.

### Exception and ADR path

Governance frames that cannot bend break. The submission
commits:

- **Exception process** — how a team requests an exception,
  the required justification, the approver.
- **Exception register** — a versioned record of exceptions
  granted, so the governance layer can audit drift over time.
- **ADR path** — ownership and policy changes are versioned
  via the governance system from `mod-301/exercise-4`; the
  policy itself is a versioned artifact.

### Cross-cutting invariants

The architect-tier value is in the invariants that cross
ownership and schema evolution:

- **Every asset has an owner** — bronze / silver / gold
  tables, stream topics, and catalog entries. An unowned
  asset is a governance failure, not a quality one.
- **Every change has a workflow** — breaking schema changes
  flow through version bump + migration window; ownership
  transfers flow through ADR; exceptions flow through the
  register.
- **Audit trail is cross-cutting** — the governance layer
  records who approved what and when, aligned to NIST AI RMF
  *Govern* function requirements for AI data lifecycle
  oversight.

### AI/ML-specific considerations

Governance of data for ML carries risks the generic data
warehouse does not:

- **Dataset ownership as the integrity anchor** — OWASP ML
  Security Top 10 *ML02: Data Poisoning* and *ML06: AI Supply
  Chain Attacks* require that someone is accountable for the
  quality of the data a model is trained on. The ownership
  map is where that accountability is recorded.
- **Schema change as a model-break surface** — a backward-
  incompatible change on a feature source silently breaks the
  model consuming it; the per-data-class compatibility default
  must treat ML feature sources as "full compatibility" by
  default.
- **NIST AI RMF *Govern* function alignment** — the policy +
  ownership map is the data-side anchor for AI RMF *Govern*;
  the exception register plus ADR path is the audit record
  AI RMF requires.
- **MITRE ATLAS reconnaissance surface** — governance
  artifacts (ownership map, exception register) expose the
  authoritative shape of the data plane. Access to these
  artifacts is itself a governance decision.

### Decision rationale

A four-section governance frame (ownership decision, ownership
map, schema evolution policy, exception / ADR path) is the
right altitude because the module rationale lists the
ownership decision and schema evolution policy as separate
architect-tier frames that together constitute data governance.
Trade-offs the submission should explicitly accept, mirroring
the module rationale:

- *Data-mesh has organizational prerequisites.* The decision
  records whether the prerequisites are met; declaring mesh
  without them is the module's top failure mode.
- *Schema evolution discipline is constant work.* The policy
  does not run itself; the submission commits the workflow and
  the review gate, not just the compatibility class.
- *Centralized data platforms scale to ~5-10 producing teams.*
  The decision records the team count that informed the call.

### What stays out of scope

The architect-tier answer **does not** draft the data contract
template itself (deferred to Exercise 4), commit the catalog
tool (deferred to Exercise 5), or define the lakehouse tiering
or streaming architecture (defined in Exercises 1 and 2). The
goal here is the governance frame tight enough that the
contract template and the catalog can operate against named
owners and known compatibility classes.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names ownership (data-mesh vs.
centralized) and schema evolution policy as separate
deliverables for Exercises 02 and 03. The learner-visible
title for this exercise is "Governance Application", and this
file carries both deliverables together as the governance
layer because governance of data is the ownership decision
plus the policy that enforces compatibility against change.
Cross-cutting invariants and AI/ML considerations are grounded
in NIST AI RMF (Govern function), OWASP ML Top 10, and MITRE
ATLAS cited in §6.

## Implementation

Implementation of the governance frame lands as versioned
policy assets, not as a running tool:

1. **Governance policy document** — Markdown with one section
   per field (ownership decision, ownership map, schema
   evolution policy, exception / ADR path).
2. **Ownership map table** — every domain with its assets
   (datasets from Exercise 1, topics from Exercise 2) and the
   cross-domain consumption record.
3. **Compatibility class table** — one row per data class
   with the default compatibility class, the breaking-change
   workflow, and the enforcement point.
4. **Breaking-change workflow runbook outline** — version
   bump, consumer notification, migration window length, and
   the acceptance gate.
5. **Exception register template** — the fields each granted
   exception captures, so the register can be audited.
6. **AI/ML invariants addendum** — ownership-as-integrity-
   anchor, ML-feature compatibility default, NIST AI RMF
   *Govern* alignment record. OWASP ML Top 10 and MITRE ATLAS
   cited inline.
7. **Governance hook** — ownership transfers, policy class
   changes, or exception grants require an ADR via the
   governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the policy document. Confirm the ownership decision
   records both the choice (centralized or data-mesh) and the
   producing-team count that informed it.
2. If data-mesh is chosen, confirm the organizational
   prerequisites (mature engineering culture, willing domain
   owners) are recorded as met.
3. Open the ownership map. Confirm every asset from Exercise
   1 and every topic from Exercise 2 has a domain owner;
   "platform team" is only acceptable under the centralized
   choice.
4. Open the compatibility class table. Confirm every data
   class has a default compatibility class and that ML
   feature sources default to full compatibility.
5. Confirm the breaking-change workflow names the migration
   window length and the acceptance gate.
6. Confirm the exception register template captures the
   justification and the approver, not just the exception
   text.
7. Confirm the data contract template and the catalog tool
   choice are deferred to Exercises 4 and 5 respectively.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Ownership decision | Choice + team count + prerequisites recorded | Choice without justification |
| Ownership map | Every asset has an owner | Unowned assets |
| Mesh prerequisites | Confirmed before data-mesh declared | Mesh declared without them |
| Compatibility defaults | Class per data class, ML features = full | Compatibility unset |
| Breaking-change workflow | Version bump + migration window + gate | Workflow absent or vague |
| Exception register | Captures justification and approver | Register absent |
| ADR path | Policy / ownership changes routed through ADR | Changes made ad-hoc |
| AI/ML invariants | Ownership-as-integrity + feature compatibility | ML risks absent |
| Scope discipline | Contract template and catalog tool deferred | Deferred decisions inlined |
| Form | Versioned Markdown | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the ownership + schema-evolution deliverables:

1. **Data-mesh declared but no domain ownership.** The module
   rationale names this directly as "chaos" — the top failure
   mode. A governance frame that commits data-mesh without the
   ownership map and prerequisites repeats it.
2. **Schema changes pushed without consumer review.** The
   module rationale lists "downstream breakage" as the
   consequence. A policy that names compatibility classes but
   not the breaking-change workflow is a placeholder.
3. **Owners collapsed to "platform team" under a mesh model.**
   Mesh is domain ownership; collapsing to one owner is the
   centralized model mislabeled as mesh.
4. **Exceptions granted without a register.** Governance that
   bends silently becomes governance that doesn't exist; the
   exception register is the audit record AI RMF *Govern*
   requires.
5. **Compatibility class set globally.** The module policy is
   per data class; a global compatibility class is either too
   loose for ML feature sources or too strict for operational
   data.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
