# SOLUTION — Exercise 2: ADM Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-301-enterprise-architecture/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the **reference architecture** and
**migration path** deliverables from the module solution through
the lens of **TOGAF's Architecture Development Method (ADM)**.
The architect-tier answer walks the AI/ML platform through the
ADM phases, producing the baseline-to-target migration plan that
the module solution requires but that most learners skip.

The module rationale is explicit that a reference architecture
must include *future state vs. current state, with a migration
path*. The ADM is the discipline that makes that migration path
reproducible — it says *which* architecture work happens *in
which order*, what outputs each phase produces, and what the
hand-off between phases looks like.

## 2. Worked answer

A passing ADM-shaped submission walks the AI/ML platform through
the ADM phases, producing a short, named deliverable per phase.
The phases and the exercise deliverables they anchor:

| ADM phase | Exercise deliverable |
| --- | --- |
| Preliminary | Scope statement, architecture principles, and the frameworks adopted (e.g., TOGAF content, NIST AI RMF) |
| A. Architecture Vision | A one-page vision aligning sponsors on the target platform, success criteria, and constraints |
| B. Business Architecture | The capability map (baseline + target) with ownership |
| C. Information Systems — Data | AI/ML data classes (training, fine-tuning, eval, embeddings, prompt logs, model artifacts), their stores, and lineage |
| C. Information Systems — Application | System inventory with capability assignments and integration patterns |
| D. Technology Architecture | Compute, storage, networking, identity, observability substrates with cross-cutting treatment |
| E. Opportunities and Solutions | Candidate work packages that close the baseline-to-target gaps |
| F. Migration Planning | Sequenced migration plan: order, dependencies, risks, intermediate states |
| G. Implementation Governance | How ADRs, cross-cutting reviews, and ARB touch each in-flight work package |
| H. Architecture Change Management | Triggers that re-enter the ADM (new regulation, new data class, new workload type) |
| Requirements Management | How architecture requirements are captured and traced across phases |

The phases are not reproduced verbatim; they are *used* to
organize the architecture work the module solution already
calls out.

### Baseline vs. target per phase

Each ADM phase B–D produces both a baseline and a target view
plus a gap analysis. The module rationale calls out *reference
architectures that don't show current state* as a recurring
failure. A passing submission therefore has, at minimum:

- Baseline + target capability map (phase B).
- Baseline + target data architecture (phase C data).
- Baseline + target application inventory (phase C application).
- Baseline + target technology architecture (phase D).

### Migration path artifact

Phase F produces the migration plan the module rationale asks
for. It should include:

- **Work packages** — each package closes a named gap.
- **Sequence and dependencies** — order with prerequisites.
- **Risk** — architecture, delivery, and operational risk per
  package.
- **Intermediate state operability** — each stepping stone must
  leave the platform in a working state; "big-bang cutover" is
  a fail signal.
- **Decision checkpoints** — where ADRs or ARB reviews gate
  the move between stages (ties the ADM output back to the
  governance exercise).

### Decision rationale

ADM is chosen as the organizing method because the module
solution asks for a reference architecture *with* a migration
path. ADM makes that path auditable by naming the phase outputs
rather than leaving them as prose. The module rationale accepts
the trade-off that this is heavier than ADR-only governance;
ADM is the right ceremony when the organization needs
sustained enterprise-architecture work rather than one-off
designs.

### What stays out of scope

The architect-tier answer **does not** reproduce the TOGAF ADM
chapter verbatim, map every subphase, or treat phase conformance
as the goal. The goal is a migration-ready architecture that
uses ADM to stay organized.

## Implementation

Implementation of the ADM-shaped artifact lands as versioned
documents in the platform repository, one per phase, with
cross-links:

1. **Preliminary and Vision as living documents** — architecture
   principles and vision are versioned, not slide decks; later
   phases reference them.
2. **Baseline + target per BDAT phase** — publish both views in
   phases B, C (data and application), and D, with the gap
   analysis explicit.
3. **Opportunities and Solutions as a work-package register** —
   each row is a package with scope, gap closed, and estimated
   effort.
4. **Migration plan as a sequenced register** — rows are
   ordered; dependencies and intermediate operability are
   recorded.
5. **Implementation governance hooks** — each in-flight work
   package references the ADRs or ARB entries that gate it;
   this is where the ADM output feeds the governance exercise
   (exercise 4).
6. **Change-management triggers** — the document names the
   events that re-enter the ADM (new regulation, new data
   class, major model lifecycle event, new workload type).

## 3. Validation steps

1. Open the vision. Confirm it names sponsors, success
   criteria, and constraints — not just a product description.
2. Pick any ADM phase B–D. Confirm it has baseline + target
   views and an explicit gap analysis.
3. Open the migration plan. Confirm packages are **sequenced
   with dependencies**, not just listed.
4. Confirm each intermediate state is **operable** — the plan
   does not require a big-bang cutover.
5. Confirm phase G (Implementation Governance) ties work
   packages to ADRs or ARB reviews, closing the loop with the
   governance exercise.
6. Confirm phase H (Change Management) names the triggers that
   re-enter the ADM.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Phase coverage | Preliminary through H + Requirements Management addressed | Only the "fun" phases documented |
| Baseline + target | Both views in phases B / C / D | Target only |
| Gap analysis | Enumerated gaps feed phase E | Narrative gap statement |
| Work packages | Each package closes a named gap | Generic roadmap items |
| Sequencing | Dependencies respected, intermediate states operable | Big-bang cutover |
| Governance hooks | Phase G references ADRs / ARB | Governance left to a separate doc |
| Change management | Phase H names re-entry triggers | ADM treated as one-shot |
| AI/ML risk anchoring | NIST AI RMF + adversary catalogues referenced | AI treated as generic workload |
| Form | Versioned Markdown + structured data | PDF or slide deck |

## 5. Common mistakes

Drawn from the module-level "common mistakes graders see",
specialized to the ADM frame:

1. **Target-only architecture.** Phases B–D must show both
   baseline and target; without baseline, the migration plan
   is undefined.
2. **Phase conformance treated as the goal.** Mapping every
   TOGAF subphase without producing usable outputs is checkbox
   theater.
3. **Big-bang migration.** A sequenced plan with inoperable
   intermediate states is not a plan.
4. **One-shot ADM.** No phase H triggers means the architecture
   decays the moment the project ends.
5. **Governance detached from phases.** Phase G must reference
   the ADR and ARB artefacts produced in the governance and
   stakeholder exercises; otherwise the architecture ships
   without an operating model.

## 6. References

- The Open Group — TOGAF Architecture Development Method:
  <https://www.opengroup.org/togaf>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
