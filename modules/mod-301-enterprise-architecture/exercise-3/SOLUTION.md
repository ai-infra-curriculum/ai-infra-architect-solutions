# SOLUTION — Exercise 3: Zachman Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-301-enterprise-architecture/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the **cross-cutting concerns review** and
**reference architecture** deliverables from the module solution
through the lens of the **Zachman Framework for Enterprise
Architecture**. The architect-tier answer is a classification
artifact that places every element of the AI/ML platform
architecture on the Zachman grid, so cross-cutting concerns are
treated consistently rather than per-system.

The module rationale calls out, as a recurring failure mode,
*cross-cutting concerns treated per-system, inconsistently*.
Zachman's contribution is a two-dimensional classification —
perspectives (rows) crossed with interrogatives (columns) — that
forces the architect to think about every concern from every
perspective exactly once.

## 2. Worked answer

A passing Zachman-shaped submission produces a filled grid for
the AI/ML platform. The axes are the standard Zachman
dimensions:

- **Perspectives (rows)** — Executive / Scope, Business
  Management, Architect / System Logic, Engineer / Technology
  Physics, Technician / Component Assemblies, Enterprise /
  Operations instances.
- **Interrogatives (columns)** — What (data), How (function /
  process), Where (network / location), Who (people / roles),
  When (time / events), Why (motivation / goals).

Each cell is a short, named artifact — a document, diagram, or
dataset reference — rather than prose. The architect-tier
discipline is that the artifact in each cell exists
*somewhere*, and the grid tells the reader where to find it.

### ML-specific extensions per interrogative

To avoid treating the AI/ML platform as a generic workload (a
failure mode called out across the module), each interrogative
is extended with ML-specific concerns:

| Interrogative | ML extensions |
| --- | --- |
| What (data) | Training data, fine-tuning data, eval data, embeddings, prompt / response logs, model artifacts |
| How (function) | Data pipelines, training jobs, evaluation pipelines, model serving, retrieval, agent orchestration |
| Where (network) | Data residency per class, model artifact storage, inference endpoints, retrieval index locations |
| Who (people) | Capability-owning teams, data stewards, model owners, reviewers, operators |
| When (time) | Training cadence, re-evaluation cadence, model refresh events, incident clocks, review cadences |
| Why (motivation) | Capabilities realized, risks managed, compliance frames engaged, architecture principles honored |

### Cross-cutting concerns, placed on the grid

The module solution calls out identity, observability, security,
cost, and data-governance as the cross-cutting concerns that
must be treated once and applied uniformly. On the Zachman grid,
each cross-cutting concern is a diagonal — it has entries in
multiple cells, but the architect commits to a single
*treatment* that is referenced from each cell.

| Cross-cutting concern | How it threads the grid |
| --- | --- |
| Identity | Who (workload + human identity) × every perspective |
| Observability | When (events, cadences) × every perspective, with artifact references in How |
| Security | Why (risks managed) + Where (segmentation) + Who (least privilege), referenced from each system |
| Cost | Why (business justification) + How (resource shape), rolled up at the executive perspective |
| Data governance | What (classification) + Where (residency) + When (retention), referenced from each data flow |

### Decision rationale

Zachman is chosen because its grid is the simplest tool that
*forces* cross-cutting consistency. Where TOGAF (exercise 1)
answers *what the deliverables are* and ADM (exercise 2)
answers *in what order they are produced*, Zachman answers *how
to make sure none of them silently disagrees on identity,
observability, security, cost, or data governance.*

Trade-offs — these mirror the module rationale:

- The grid is heavier than ADR-only governance; the module
  solution accepts this heavier structure when needed.
- Filling every cell is overkill for small platforms; the
  learner is expected to drop cells that are not applicable
  *explicitly*, rather than quietly.
- The Zachman grid is a *classification*, not an *order of
  work* — it does not replace the ADM output from exercise 2.

### What stays out of scope

The architect-tier answer **does not** reproduce the full
Zachman Framework definitions, enforce every cell, or treat
Zachman adherence as the goal. The goal is uniform cross-cutting
treatment, with Zachman providing the classification.

## Implementation

Implementation of the Zachman-shaped artifact lands as a
single grid document plus the artifacts it points at:

1. **Author the grid as code** — publish the grid as a
   Markdown table or structured file in the versioned
   repository; cells point at other documents in the repo.
2. **Promote one treatment per cross-cutting concern** — one
   identity design, one observability design, one security
   design, one cost model, one data-governance treatment;
   each cell on the diagonal references the single treatment
   rather than restating it.
3. **Anchor the AI/ML extensions** — the What / How / Where
   columns include ML-specific entries (training data,
   embeddings, prompt logs, model artifacts, inference
   endpoints) so the architecture reflects the actual
   workloads.
4. **Thread Why through every row** — every cell exists because
   it realizes a capability or manages a risk; untraceable
   cells are candidates for deletion.
5. **Record dropped cells explicitly** — cells that are not
   applicable are *marked* as not applicable rather than left
   blank; silent blanks are indistinguishable from oversights.

## 3. Validation steps

1. Open the grid. Confirm it has the standard perspectives
   (rows) and interrogatives (columns), and that every cell is
   either filled or explicitly marked not-applicable with a
   reason.
2. Pick any cross-cutting concern (identity, observability,
   security, cost, data governance). Confirm the diagonal is
   consistent — every cell references the same treatment.
3. Pick any ML-specific data class (embeddings, prompt / response
   logs). Confirm it appears in the What column *and* that
   related rows (data residency, retention, access policies)
   point at a consistent treatment.
4. Confirm every cell's content exists elsewhere in the
   repository as an artifact; the grid is an index, not the
   artifacts themselves.
5. Confirm cells trace to a capability or risk in the Why
   column; otherwise the cell is unmotivated.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Grid structure | Full perspectives × interrogatives, with ML extensions | Only "designer" row filled, columns incomplete |
| Not-applicable cells | Marked with a reason | Silent blanks |
| Cross-cutting diagonals | One treatment per concern, referenced from every relevant cell | Per-system identity / observability / etc. |
| ML data classes | Embeddings, prompt logs, artifacts explicitly placed | Treated as generic data |
| Traceability | Every cell traces to a capability or risk in Why | Untraceable cells |
| Artifact index | Cells point at concrete repo artifacts | Grid is standalone prose |
| Form | Versioned Markdown / structured data | PDF or slide deck |
| AI/ML risk anchoring | Risks surfaced from NIST AI RMF, OWASP ML Top 10, MITRE ATLAS | AI treated as generic workload |

## 5. Common mistakes

Drawn from the module-level "common mistakes graders see",
specialized to the Zachman frame:

1. **Cross-cutting concerns treated per-system,
   inconsistently.** This is the module's named failure mode;
   the grid exists to prevent it, so inconsistent diagonals
   are the primary fail signal.
2. **Row-only or column-only coverage.** Learners frequently
   fill only the designer row ("how we built it"), skipping the
   executive and operator perspectives.
3. **ML surfaces treated as generic workloads.** The What /
   How / Where columns must name training data, embeddings,
   prompt logs, model artifacts, and inference endpoints
   explicitly.
4. **Silent blanks.** Not-applicable cells must be labeled;
   otherwise graders cannot distinguish deliberate exclusions
   from oversights.
5. **Grid as the architecture, not as an index.** The grid
   points at artifacts; it is not the artifact.

## 6. References

- Zachman International — Zachman Framework for Enterprise
  Architecture: <https://www.zachman.com/>
- The Open Group — TOGAF Standard (used alongside Zachman for
  the content framework): <https://www.opengroup.org/togaf>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
