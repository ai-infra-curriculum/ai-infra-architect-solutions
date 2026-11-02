# SOLUTION — Exercise 1: TOGAF Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-301-enterprise-architecture/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the **reference architecture** and
**capability map** deliverables from the module solution through
the lens of **TOGAF** as the chosen enterprise-architecture
framework. The architect-tier answer is *not* a TOGAF compliance
audit; it is a worked enterprise architecture that uses TOGAF's
content framework to organize the AI/ML platform's architecture
assets so another architect can read, review, and extend them.

The module rationale is explicit about the shape of the
deliverable: a reference architecture document that includes a
capability mapping, a system inventory with capability
assignments, integration patterns, cross-cutting concerns, and a
future-state-vs-current-state view with a migration path. This
file turns that spine into a TOGAF-shaped worked example,
validation steps, and a grading rubric.

## 2. Worked answer

A passing TOGAF-shaped submission produces four linked
architecture artifacts, aligned to TOGAF's Business / Data /
Application / Technology (BDAT) domains:

1. **Business architecture** — the capability map from the
   module solution: a 2–3 layer hierarchy of *what* the
   organization does, with an owning team per capability. The
   module rationale calls out the discipline: *map the business,
   not the org chart.*
2. **Data architecture** — the data classes the platform
   operates on (training data, fine-tuning data, eval data,
   embeddings, prompt / response logs, model artifacts), the
   authoritative stores for each class, and the lineage between
   them.
3. **Application architecture** — the system inventory from
   the module solution, with each system assigned to the
   capabilities it realizes and the integration patterns it
   participates in (event-driven, API, batch).
4. **Technology architecture** — the platform substrates
   (compute, storage, networking, identity, observability) and
   the cross-cutting concerns applied uniformly across them.

Each artifact is published in a form another architect can
diff: Markdown or structured data in a versioned repository,
not slide decks. The module rationale explicitly accepts the
trade-off of *Markdown-based documents over PDF — version
control is the audit trail.*

### Baseline vs. target architecture

TOGAF requires both a **baseline (current state)** and a
**target (future state)** architecture, with the delta driving
the migration plan. The module rationale calls out the
recurring failure mode of *reference architectures that don't
show current state — only the aspirational future.* The
deliverable must therefore include:

- A **baseline** description of each BDAT domain as it stands
  today, including systems to be retired or consolidated.
- A **target** description reflecting the architecture the
  learner is proposing.
- A **gap analysis** that enumerates the capabilities, data
  classes, systems, and technology components that must move
  between baseline and target.
- A **migration path** that sequences the gap-closing work.

### Decision rationale

TOGAF is chosen as the organizing frame because the module
solution explicitly scopes the enterprise-architecture
deliverables to capability maps, reference architectures, and
cross-cutting concerns — all of which TOGAF's content framework
names directly. The module solution also calls out, under *when
to go beyond this implementation*, that heavier structure
(TOGAF, Archi, arc42) is appropriate when the organization
needs it. This exercise is where the learner shows they can use
that structure deliberately.

Trade-offs the learner should explicitly accept — these mirror
the module rationale:

- Heavier ceremony than ADR-only governance.
- The baseline-plus-target discipline is slower than drafting
  only the aspirational future.
- Capability maps stay simple (the module solution caps them at
  roughly 30 top-level capabilities); learners who overshoot
  this should justify it.

### What stays out of scope

The architect-tier answer **does not** reproduce TOGAF
certification material, enumerate every TOGAF deliverable, or
treat TOGAF conformance as the goal. The goal is a usable
enterprise architecture, with TOGAF providing the vocabulary
and structure.

## Implementation

Implementation of the TOGAF-shaped artifact lands in the
platform repository as versioned architecture assets:

1. **Author BDAT artifacts as code** — publish capability map,
   data architecture, application architecture, and technology
   architecture as Markdown + structured data (YAML / CSV) in a
   versioned repository, so diffs surface scope changes.
2. **Record the system inventory** — one row per system, with
   explicit capability assignments, integration patterns, and a
   pointer to the owning team.
3. **Call out cross-cutting concerns** — identity,
   observability, security, cost, and data-governance treatment
   is referenced once and applied uniformly across the
   application and technology artifacts (the module solution
   calls out per-system inconsistency as a recurring failure
   mode).
4. **Separate baseline from target** — publish both views, with
   a gap-analysis section that enumerates the deltas.
5. **Sequence the migration path** — order the gap-closing work
   so dependencies are respected and intermediate states are
   operable.
6. **Anchor AI/ML risk framing** — reference the NIST AI RMF
   *Govern / Map / Measure / Manage* functions and relevant
   adversary catalogues (OWASP ML Top 10, MITRE ATLAS) in the
   cross-cutting concerns section, so the enterprise
   architecture reflects AI-specific risk rather than treating
   the ML surfaces as generic workloads.

## 3. Validation steps

1. Open the capability map. Confirm it is a hierarchy of
   capabilities, not an org chart; each capability names an
   owning team.
2. Pick any system in the application-architecture inventory.
   Confirm the document names which capabilities it realizes,
   which integration patterns it participates in, and which
   data classes it touches.
3. Confirm both **baseline** and **target** architectures are
   present and that the gap analysis is explicit — a submission
   with only a future state is a fail by the module rationale.
4. Confirm the migration path sequences the gap-closing work;
   a target architecture without a path is incomplete.
5. Confirm cross-cutting concerns (identity, observability,
   security, cost, data governance) are treated once and
   applied uniformly, rather than re-stated per system.
6. Confirm the artifact is machine-diffable (Markdown +
   structured data in a repo), not a slide deck or PDF.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Business architecture | Capability map, 2–3 layers, owner per capability | Reproduction of org chart |
| Data architecture | ML data classes (training, embeddings, prompt logs, artifacts) named with lineage | "Data lives in the data lake" |
| Application architecture | System inventory with capability + integration assignments | Diagram without capability traceability |
| Technology architecture | Substrates named with cross-cutting treatment | Vendor list |
| Baseline vs. target | Both views present, gap analysis explicit | Target only |
| Migration path | Sequenced, dependencies respected | Target with no path |
| Cross-cutting concerns | Treated uniformly | Per-system, inconsistent |
| Form | Versioned Markdown + structured data | PDF or slide deck |
| AI/ML risk anchoring | References NIST AI RMF + adversary catalogue | AI treated as generic workload |

## 5. Common mistakes

Drawn directly from the module-level "common mistakes graders
see" section:

1. **Capability maps that are org charts.** The capability map
   should describe *what the business does*, independent of
   current reporting lines.
2. **Reference architectures that don't show current state —
   only the aspirational future.** Without a baseline, the
   migration path is undefined.
3. **Cross-cutting concerns treated per-system, inconsistently.**
   Identity, observability, security, cost, and data
   governance need a single treatment applied across the
   application and technology layers.
4. **TOGAF conformance treated as the goal.** The point of
   TOGAF here is vocabulary and structure, not certification.
5. **AI/ML surfaces treated as generic workloads.** The
   architecture must reflect ML-specific risks surfaced by
   NIST AI RMF, OWASP ML Top 10, and MITRE ATLAS.

## 6. References

- The Open Group — TOGAF Standard (framework overview and
  content framework): <https://www.opengroup.org/togaf>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
