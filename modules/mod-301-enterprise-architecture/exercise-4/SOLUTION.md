# SOLUTION — Exercise 4: Governance Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-301-enterprise-architecture/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the **architecture decision records (ADRs)**
and **cross-cutting concerns review** deliverables from the
module solution to the broader problem of **architecture
governance** for an AI/ML platform. The architect-tier answer is
a small, operable governance system — not a policy binder — that
tells the organization *how* architectural decisions are made,
recorded, enforced, and revisited.

The module rationale is direct about the shape of the artifact:
every significant architectural decision gets an ADR with
*context / decision / consequences / alternatives-considered*;
ADRs are version-controlled; the reference uses Markdown and
GitHub conventions, not a separate tool. This exercise is where
the learner shows the surrounding system that makes ADRs
operable at enterprise scale.

## 2. Worked answer

A passing governance submission has four linked artifacts:

1. **ADR template and index** — a single ADR template plus an
   index of all accepted / proposed / superseded ADRs,
   versioned in the architecture repository.
2. **Decision triage rubric** — the criteria that decide which
   changes need an ADR vs. an in-PR note vs. an ARB review.
3. **Cross-cutting concerns review template** — the one-page
   template that any change touching identity, observability,
   security, cost, or data governance must fill in.
4. **Supersession and change log** — the mechanism for
   superseding ADRs when the architecture evolves, so the
   current state is always derivable from the index.

### ADR template

The module rationale names four sections directly; a passing
template includes them, and nothing more that is likely to
decay:

- **Context** — the forces at play; what makes a decision
  necessary now.
- **Decision** — the choice made.
- **Consequences** — what becomes easier, harder, or
  constrained by the decision.
- **Alternatives considered** — the options rejected and why.
  The module solution flags *ADRs missing the alternatives-
  rejected section* as a recurring failure mode.

### Decision triage rubric

Not every change deserves an ADR. The rubric should name:

- **In-PR note** — small, reversible, scoped to one component.
- **ADR** — significant, hard to reverse, or affects more than
  one team / capability.
- **ARB review** — crosses capabilities, touches cross-cutting
  concerns, or has stakeholder impact outside engineering
  (ties into exercise 5).

### Cross-cutting concerns review template

A single template that any ADR or ARB submission touching
identity, observability, security, cost, or data governance
must fill in. The template references the single treatment
agreed in the Zachman diagonal (exercise 3) rather than
re-deriving it, so cross-cutting concerns stay uniform. The
module rationale is explicit that the *reference's cross-
cutting review template enforces this.*

### AI/ML-specific governance surfaces

The AI/ML platform has decision classes that generic
enterprise-architecture governance misses, and the module
cross-references them via the AI-specific risk catalogues:

- **Model lifecycle decisions** — introducing a new base
  model, retraining, promoting a fine-tune, retiring a model.
- **Data source decisions** — admitting a new training-data
  source, new prompt-log source, new retrieval index.
- **Risk function decisions** — changes mapped against the
  *Govern / Map / Measure / Manage* functions of the NIST AI
  Risk Management Framework.
- **Adversary-model updates** — ADRs re-opened when OWASP ML
  Top 10 or MITRE ATLAS surface new techniques relevant to the
  platform.

### Decision rationale

Governance via ADRs plus a cross-cutting review template is
the module solution's deliberate trade-off: *ADRs over heavy
enterprise-architecture tools (TOGAF, Archi); Markdown-based
documents over PDF — version control is the audit trail.* The
reason is that governance artifacts that live in a separate
tool are typically not maintained; governance artifacts that
live in the same repo as the code are reviewable in PRs,
diffable, and durable.

Trade-offs — called out by the module rationale:

- Lightweight tooling means governance depends on culture;
  ADRs are only effective if they are actually required.
- The cross-cutting review template adds ceremony to changes
  that touch identity, observability, security, cost, or data
  governance.
- Supersession must be explicit; stale ADRs are worse than no
  ADR because they mislead.

### What stays out of scope

The architect-tier answer **does not** adopt a specific
heavyweight governance platform, define legal / compliance
sign-off procedures, or replace the organization's existing
ARB; it defines the architecture governance that complements
them.

## Implementation

Implementation of the governance system lands as versioned
assets in the architecture repository:

1. **ADR template file** — committed to the repo, used by
   every ADR.
2. **ADR index file** — one row per ADR, with status
   (proposed / accepted / superseded), ownership, and link.
3. **Triage rubric document** — a short, versioned document
   that reviewers point at when deciding whether a change
   needs an ADR, in-PR note, or ARB review.
4. **Cross-cutting review template** — one file per concern
   or a single template with concern-specific sections;
   referenced from the ADR template.
5. **Supersession mechanism** — explicit `supersedes` /
   `superseded-by` fields in each ADR, with the index showing
   the current state.
6. **AI/ML triggers** — the triage rubric names the AI-specific
   events that force ADRs (new base model, new data source,
   new adversary technique recognized).

## 3. Validation steps

1. Open the ADR template. Confirm it has context, decision,
   consequences, and alternatives-considered. The last section
   is the one most often skipped; its absence is a fail.
2. Open the ADR index. Confirm every entry has a status and
   that superseded ADRs point at the superseding ADR.
3. Open the triage rubric. Confirm it distinguishes in-PR
   notes, ADRs, and ARB reviews with concrete criteria, not
   vibes.
4. Open the cross-cutting review template. Confirm it
   references the single treatments agreed in the Zachman
   grid (exercise 3) rather than restating them.
5. Confirm the AI/ML-specific triggers (new base model, new
   data source, new adversary technique) are named in the
   triage rubric.
6. Confirm the governance artifacts live in the versioned
   repository, not in a separate tool.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| ADR template | Context, decision, consequences, **alternatives considered** | Alternatives section missing |
| ADR index | Every entry has status + supersession links | Only accepted ADRs listed, no history |
| Triage rubric | Concrete criteria for in-PR / ADR / ARB | Reviewer discretion only |
| Cross-cutting template | References single treatments | Restates identity / observability per ADR |
| AI/ML triggers | New model, data source, adversary technique named | AI treated as generic |
| Location | In-repo, versioned, Markdown | Separate tool, no diff history |
| Supersession | Explicit, bidirectional | Stale ADRs with no supersession |
| Operability | Reviewers can apply the rubric without ambiguity | Policy prose, no decision tree |

## 5. Common mistakes

Drawn from the module-level "common mistakes graders see",
specialized to the governance frame:

1. **ADRs missing the alternatives-rejected section.** The
   module solution names this directly; it is the most common
   fail.
2. **Governance without enforcement.** An ADR process that
   reviewers do not actually require is theatre.
3. **Cross-cutting concerns re-derived per ADR.** The
   cross-cutting review template exists so that identity,
   observability, security, cost, and data governance stay
   uniform across decisions — not restated each time.
4. **Stale ADRs.** Without supersession, the index misleads
   future readers.
5. **AI treated as generic.** No triggers for new base models,
   new data sources, or new adversary techniques means the
   governance system never updates when the AI-specific
   surface changes.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- The Open Group — TOGAF Standard (Architecture Governance
  content): <https://www.opengroup.org/togaf>
- Module-level rationale: `../SOLUTION.md`
