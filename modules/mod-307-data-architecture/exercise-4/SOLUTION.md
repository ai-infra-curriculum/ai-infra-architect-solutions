# SOLUTION — Exercise 4: Data Quality Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-307-data-architecture/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **data contract
template** deliverable — *producer / consumer / SLA / schema /
change-process, versioned alongside producing code* — as the
quality mechanism that enforces the silver-tier promise from
Exercise 1 and the schema-evolution policy from Exercise 3. The
architect-tier answer is not a quality dashboard; it is the
data contract template plus the signing and enforcement model
that makes "data quality" a producer commitment rather than a
consumer wish.

The module rationale frames data contracts as the artifact
through which producers commit obligations and consumers rely
on them. Contracts that producers do not sign onto are "not
real contracts" — the module names this explicitly as a top
grader-visible failure. This exercise is where the learner
produces the template and the operating model that keeps it
signed, versioned, and enforced.

## 2. Worked answer

A passing data-contract submission produces one linked package
with four named sections, mirroring the module rationale's
five contract fields:

1. **Contract template** — producer, consumer, SLA, schema,
   change-process.
2. **Signing and ownership model** — how producers sign and
   consumers register, tied to the ownership map from Exercise
   3.
3. **Versioning and change workflow** — how contract versions
   are published, deprecated, and retired against the schema
   evolution policy.
4. **Enforcement surfaces** — where in the pipeline the
   contract is checked (publish-time, ingestion, silver
   conformance).

### Contract template

The module rationale pins the five fields; the submission
commits each as a required section of the template:

- **Producer** — the identity publishing the dataset or
  topic. Named owner from the Exercise 3 ownership map
  (see
  [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md));
  "platform team" is only valid under the centralized
  ownership model.
- **Consumer** — the registered consumer set, so a breaking
  change knows who to notify.
- **SLA** — freshness, completeness, and availability
  commitments. The silver-tier promise from Exercise 1 (see
  [`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md))
  is the reference for silver / gold contracts; stream SLAs
  from Exercise 2 (see
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md))
  apply to topic contracts.
- **Schema** — the typed shape, the data class, and the
  compatibility class from the Exercise 3 policy.
- **Change-process** — the versioning rule, the migration
  window, and the retirement gate — all inherited from the
  Exercise 3 schema evolution policy.

### Signing and ownership model

Contracts that producers do not sign onto are the module's
named failure. The submission commits:

- **Signing event** — the producer-side ceremony that commits
  the obligations. Signing is a code or config artifact in
  the producer repository, so the contract is versioned
  alongside producing code (as the module rationale
  requires).
- **Consumer registration** — the explicit record of which
  consumers rely on the contract. Consumer registration is
  what makes migration windows resolvable; an unregistered
  consumer has no claim and no notification path.
- **Ownership tie-in** — the signing identity resolves through
  the Exercise 3 ownership map so changes in ownership flow
  back into the contract register automatically.

### Versioning and change workflow

The change workflow inherits the Exercise 3 schema-evolution
policy:

- **Version bump rule** — compatibility class determines
  whether a change is additive (minor), backward-compatible
  (minor), or breaking (major). The rule mirrors the
  per-data-class default from
  [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md).
- **Migration window** — breaking changes carry a window
  length from the Exercise 3 policy; the window ends when
  the acceptance gate is cleared, not on a fixed date.
- **Retirement gate** — a version is retired only after
  registered consumers have migrated. Retirement without
  migration is a contract violation, logged.

### Enforcement surfaces

Contracts without enforcement are documentation. The
submission names the surfaces where enforcement runs:

- **Publish-time (streams)** — the schema registry rejects a
  publish that violates the compatibility class (see
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md)).
- **Ingestion (batch)** — bronze ingestion rejects a payload
  whose schema does not match the registered contract.
- **Silver conformance** — the silver-tier transformation
  cannot promote a bronze record whose contract has been
  violated; dead-letter or quarantine is the default.
- **Catalog audit** — the Exercise 5 catalog (see
  [`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md))
  records contract compliance so audit queries can resolve
  which datasets are governed and which drifted.

### Cross-cutting invariants

The architect-tier value is in the invariants that cross the
contract lifecycle:

- **Every published dataset has a signed contract.** No
  silver or gold table and no topic without an active,
  signed contract. "Unsigned" is a governance signal, not a
  rollout backlog item.
- **Every contract has registered consumers.** Contracts with
  no consumers are retired; contracts with un-registered
  consumers block version retirement.
- **Contract changes flow through the Exercise 3 workflow.**
  Compatibility class drives the change path; the contract
  does not have its own policy.
- **Enforcement is audit-logged.** Violations and dead-letter
  events feed the catalog so quality trends are measurable.

### AI/ML-specific considerations

Contracts for ML feature sources carry risks the generic
analytics dataset does not:

- **Training/serving skew via contract drift** — an online
  feature source and the offline training table must share a
  contract (or share a compatible contract pair) or risk
  skew. The contract is the integrity anchor.
- **OWASP ML Security Top 10 *ML02: Data Poisoning*** — the
  contract is a defense surface: schema and value-range
  constraints are a first-line check against adversarial
  input through the producer.
- **MITRE ATLAS supply-chain techniques** — the contract plus
  the signing event is the chain-of-custody record for a
  training dataset; without it, the ML supply chain is
  undocumented.
- **NIST AI RMF *Measure* function** — contract violation
  rates, dead-letter rates, and migration-window compliance
  are first-class measurement signals.

### Decision rationale

A four-section contract package (template, signing / ownership,
versioning / change, enforcement) is the right altitude because
the module rationale names the contract as the artifact that
holds producer / consumer / SLA / schema / change-process. The
submission should explicitly accept:

- *Contracts that producers do not sign onto are not real
  contracts.* The signing event is the structural fix.
- *Contracts are versioned alongside producing code.* Living
  in the producer repository is non-negotiable.
- *Enforcement surfaces are plural.* No single surface catches
  every violation; publish, ingest, and silver each check what
  only that surface can.

### What stays out of scope

The architect-tier answer **does not** set the compatibility
classes themselves (deferred to Exercise 3), define lakehouse
tiering or streaming (defined in Exercises 1 and 2), or commit
the catalog tool (deferred to Exercise 5). The goal here is
the contract template and operating model tight enough that
Exercise 5's catalog can record compliance and lineage against
contracted datasets.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names the *"Data contract template
(exercise 04)"* with the producer / consumer / SLA / schema /
change-process fields and the "versioned alongside producing
code" discipline. The learner-visible title for this exercise
is "Data Quality Application", and this file carries the data
contract as the quality mechanism because quality the architect
tier commits to is the producer's signed obligation, not a
consumer-side scrubbing step. Cross-cutting invariants and
AI/ML considerations are grounded in NIST AI RMF (Measure
function), OWASP ML Top 10, and MITRE ATLAS cited in §6.

## Implementation

Implementation of the contract package lands as versioned
artifacts, not as a running pipeline:

1. **Contract template file** — Markdown or YAML (producer's
   choice) with the five required fields and the signing
   stanza. Lives in the producer repository.
2. **Signing documentation** — Markdown describing how
   producers sign (CODEOWNERS, review approval, or signed
   commit) so the signing event is reproducible.
3. **Consumer registry** — the versioned record of which
   consumers rely on which contract version. Shape chosen so
   the catalog from Exercise 5 can resolve it.
4. **Change-workflow runbook outline** — the version-bump
   rule, the migration window, and the retirement gate — all
   referenced to the Exercise 3 policy, not re-litigated.
5. **Enforcement spec** — one subsection per surface (publish,
   ingest, silver conformance, catalog audit) with the
   action on violation (reject, dead-letter, quarantine).
6. **AI/ML invariants addendum** — training/serving skew,
   ML02 defense surface, MITRE ATLAS supply-chain record.
   NIST AI RMF, OWASP ML Top 10 cited inline.
7. **Governance hook** — contract template changes,
   enforcement spec changes, and retirement-gate changes
   require an ADR via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the contract template. Confirm all five fields
   (producer, consumer, SLA, schema, change-process) are
   present and required.
2. Confirm the template lives in the producer repository, not
   in a central contract repo. "Versioned alongside producing
   code" is a module requirement.
3. Open the signing documentation. Confirm the signing event
   is reproducible (named mechanism, named approver).
4. Open the consumer registry. Confirm every active contract
   version has at least one registered consumer or is
   scheduled for retirement.
5. Confirm the change workflow references the Exercise 3
   policy for compatibility class and migration window
   length — not a new policy.
6. Confirm each enforcement surface (publish, ingest, silver,
   catalog audit) has an action on violation.
7. Confirm the ML invariants (training/serving skew, ML02
   defense, ATLAS chain-of-custody) are named.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Template completeness | Five fields each required | Missing field |
| Location | Template lives with producing code | Central contract-only repo |
| Signing | Reproducible mechanism named | Signing described abstractly |
| Consumer registry | Every active version has consumers | Registry absent or stale |
| Change workflow | References Exercise 3 policy | Reinvents compatibility rules |
| Enforcement coverage | Publish + ingest + silver + catalog audit | Single surface only |
| Violation action | Reject / dead-letter / quarantine named | Violation action vague |
| AI/ML invariants | Skew, ML02 defense, ATLAS chain | ML risks absent |
| Scope discipline | Classes, tiering, catalog deferred | Deferred decisions inlined |
| Form | Versioned Markdown / YAML in producer repo | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the data contract deliverable:

1. **Contracts that producers don't sign onto.** The module
   rationale names this directly: "not real contracts." A
   template without a signing event is documentation, not a
   contract.
2. **Contracts not versioned alongside producing code.** The
   module rationale is explicit — contracts live with the
   producer. A central contract-only repository breaks the
   co-versioning promise.
3. **Change workflow re-litigates compatibility rules.** The
   compatibility class is set in Exercise 3; the contract
   references that policy, it does not duplicate it. A
   contract that invents its own classes drifts from the
   governance frame.
4. **Enforcement at silver only.** A dead-letter in silver
   does not help a streaming consumer that already consumed
   the violating payload; publish-time enforcement is the
   first-line defense.
5. **Consumer registry treated as optional.** Without
   registered consumers, migration windows have no notifier
   and retirement gates have no gate.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
