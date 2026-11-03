# SOLUTION — Exercise 4: Migration Application (Strategy)

> Pairs with
> `ai-infra-architect-learning/lessons/mod-302-multicloud-hybrid/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **migration
strategy** deliverable: *existing single-cloud to multi-cloud:
which workloads move first, which never move, what the rollback
plan is.* The architect-tier answer is a one-page strategy
document plus a workload-classification register that
operationalizes it. Exercise 5 picks up the execution side
(wave planning, cutover discipline).

The module rationale frames the migration deliverable as a
sequencing problem: not every workload moves, not every workload
moves first, and every move is reversible. This exercise is where
the learner names the classification rule, the first-wave
candidates, and the exit conditions — before any execution
planning.

## 2. Worked answer

A passing migration-strategy submission produces three linked
artefacts:

1. **Workload classification register** — one row per workload
   with a classification (move / stay / defer) and the rule
   that produced it.
2. **Strategy document** — the one-page summary stating which
   classes move first, which never move, and the rollback
   posture.
3. **Reversibility design** — the explicit rollback plan the
   module rationale calls for, per migrating workload class.

### Workload classification register

The register classifies each workload against the triggering
event from exercise 1 and the vendor selection from exercise 3.
Classifications and typical rules:

| Class | Rule | Typical workloads |
| --- | --- | --- |
| **Move first** | Low coupling, clear cost / residency win, reversible | Batch inference, offline eval, isolated training jobs |
| **Move with care** | Material cost / residency win, moderate coupling, reversible with planning | Online inference, feature store readers |
| **Move last** | Load-bearing, high coupling, long rollback window | System-of-record integrations, auth, platform services |
| **Never move** | Hardware-pinned, residency-pinned, or contractually anchored | Specialised GPU inventory under lease, data under residency |
| **Defer** | Will be rewritten or retired within the planning horizon | Legacy pipelines slated for replacement |

The classifications must map back to triggering events; a *move
first* classification without a stated reason is a fail by the
module rationale.

### Strategy document

The module rationale asks three questions directly. The strategy
document answers each:

1. **Which workloads move first?** — the *move first* class
   with the per-workload reason.
2. **Which never move?** — the *never move* class with the
   anchoring constraint (hardware, residency, contract).
3. **What is the rollback plan?** — the exit stance per
   migrating class, not per workload. A per-workload plan
   decays; a per-class stance is maintainable.

The document is explicit about what the migration is *not*:

- Not a lift-and-shift of the entire estate — the module
  rationale accepts that some workloads *never move*.
- Not a product rewrite — refactor work is tagged as the
  *defer* class, with a sibling program.
- Not a one-way door — reversibility is a design input, not an
  afterthought.

### Reversibility design

For each migrating class, the document names the exit:

- **Data return path** — how authoritative data gets back to
  the origin cloud / on-prem, with the staleness bound.
- **Rollback trigger** — the stated signal that invokes
  rollback (cost overrun, SLO breach, compliance failure,
  vendor contract change).
- **Rollback window** — the maximum time the organization
  commits to be able to roll back; after this window closes,
  rollback requires a new strategy, not an invocation.
- **Dependencies to unwind** — the identity, networking, and
  observability couplings that were created during the move,
  with their teardown order.

### AI/ML risk anchoring

AI/ML migrations surface risk the generic migration framing
misses:

- **Model artefact portability** — the artefact format must
  survive the move; otherwise the migration is a reimplementation.
- **Training data lineage** — the lineage graph must span the
  pre- and post-migration state so audits remain valid.
- **Adversary surface delta** — the move changes the trust
  boundary; OWASP ML Top 10 and MITRE ATLAS techniques that
  were mitigated by the origin environment must be
  re-mitigated at the destination.
- **NIST AI RMF Govern / Measure** — governance and
  evaluation surfaces must stay unified across the migration
  wave; otherwise metrics decouple and incident response
  cannot follow a migrating workload.

### Decision rationale

A workload classification register plus a one-page strategy is
the right altitude because the module rationale asks for the
*which* and *rollback* questions, not an execution plan. The
execution plan is the exercise-5 deliverable. Trade-offs the
learner should accept:

- The register will be revisited; it is a living artefact, not
  a one-off deliverable.
- Reversibility carries fixed cost; the module rationale
  implicitly accepts it as the price of not having a locked-in
  cutover.
- *Never move* is a legitimate answer; the module rationale is
  explicit that the enterprise-architecture goal is not
  consolidation but *fit to the triggering event*.

### What stays out of scope

The architect-tier answer **does not** schedule the migration
waves, pick cutover windows, or write runbooks; those are the
exercise-5 execution deliverables. The goal here is the *why
and when* at the class level.

## Implementation

Implementation of the migration-strategy artefacts lands as
versioned architecture assets:

1. **Workload classification register** — one structured file
   (Markdown table or CSV) with workload, class, rule, origin,
   destination.
2. **Strategy document** — short, versioned Markdown; one page
   is the target.
3. **Reversibility design** — one entry per migrating class
   with data return path, rollback trigger, rollback window,
   and unwind dependencies.
4. **Classification review cadence** — a stated cadence at
   which the register is re-evaluated against vendor pricing,
   compliance changes, and workload evolution.
5. **AI/ML risk mapping** — references NIST AI RMF functions
   and OWASP ML Top 10 / MITRE ATLAS techniques per migrating
   class, so the trust-boundary delta is explicit.
6. **Governance hook** — any class change requires an ADR via
   the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the register. Confirm every workload has a class and
   that the rule maps back to a triggering event from
   exercise 1 (residency, concentration, M&A, cost).
2. Confirm the register contains **never move** entries; a
   register with no permanent-stay class is a fail by the
   module rationale.
3. Open the strategy. Confirm it answers the three module
   questions: *which first*, *which never*, *rollback*.
4. Open the reversibility design. Confirm each migrating class
   has a data return path, rollback trigger, rollback window,
   and unwind dependencies.
5. Confirm the AI/ML risk mapping ties the trust-boundary
   delta to NIST AI RMF functions and adversary-technique
   catalogues.
6. Confirm the register has a review cadence and that class
   changes are gated by ADRs.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Classification register | Every workload has a class and a rule | Workloads uncategorised |
| Never-move class | Present and populated | All workloads marked movable |
| Strategy document | Answers first / never / rollback | Prose only, no classes |
| Rollback trigger | Stated signal per class | "If needed" |
| Rollback window | Maximum time to invoke rollback | Open-ended |
| Unwind dependencies | Identity / networking / observability named | Rollback as "re-deploy" |
| AI/ML risk mapping | NIST AI RMF + OWASP ML / ATLAS referenced for the migrating boundary | AI treated as generic |
| Governance hook | Class changes require ADRs | Register edited without record |
| Form | Versioned Markdown + structured data | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see":

1. **No never-move class.** The module rationale is explicit
   that some workloads do not move; a register that treats
   everything as movable misses the exercise point.
2. **Rollback as "re-deploy".** Without a stated data return
   path and window, the strategy is one-way-door in disguise.
3. **Rules missing or vague.** A classification without a rule
   degenerates into opinion; the register must map back to a
   triggering event.
4. **Vendor concentration dropping silently.** Learners
   sometimes migrate without noticing the triggering event
   from exercise 1 was *vendor concentration risk*; the
   strategy must preserve the posture the earlier decision
   established.
5. **AI treated as generic.** The migration changes the
   trust boundary; adversary-technique coverage must be
   re-established at the destination, not assumed.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
