# SOLUTION — Exercise 5: Stakeholder Management Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-301-enterprise-architecture/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the **Architecture Review Board (ARB)
preparation** deliverable from the module solution to the
broader problem of **stakeholder management** for enterprise AI
architecture. The architect-tier answer is a small set of linked
artifacts — a stakeholder map, a communication plan, and an ARB
package template — that let a busy executive, a security owner,
a data owner, and an engineering lead each read the same change
in the depth they need, in the time they have.

The module rationale is direct about the final deliverable:
*ARB packages document the change, its alternatives, the
recommendation, and the implementation plan. The deliverable is
one PDF a busy executive can read in 15 minutes.* This exercise
is where the learner shows the stakeholder-management discipline
that lets that document actually work.

## 2. Worked answer

A passing stakeholder-management submission produces three
linked artifacts:

1. **Stakeholder map** — the parties with a legitimate interest
   in enterprise-architecture decisions, their decision rights,
   and what each one needs out of a review.
2. **Communication plan** — the standing cadence (who reads
   what, when) plus the event-driven channel for decisions
   that cannot wait.
3. **ARB package template** — the structured document that the
   architect produces for each ARB review, factored so each
   stakeholder reads only their section first.

### Stakeholder map

A passing stakeholder map names, for each stakeholder,
decision rights and the information they need from an ARB
package:

| Stakeholder | Decision right | What they need |
| --- | --- | --- |
| Executive sponsor | Approve / defer / reject at ARB | One-page summary: change, risk, cost, recommendation |
| Security owner | Veto on cross-cutting security | Trust boundary impact, adversary-technique coverage, incident-response delta |
| Data owner | Veto on cross-cutting data governance | Data classes touched, lineage impact, retention / residency delta |
| Finance / FinOps | Advisory on cost | Cost shape (one-off, run-rate), optimization levers |
| Engineering lead | Advisory on delivery | Migration plan, risks, sequencing, team load |
| Compliance / legal | Veto within scoped frames | Which compliance frames engaged, evidence surface |
| Operations / SRE | Advisory on operability | Runbook impact, SLO impact, incident classes |
| Model / ML owners | Advisory on model lifecycle | Model / data / adversary surface delta |

Stakeholders without decision rights still receive packages;
their advisory input is captured so the architect does not have
to re-collect it mid-review.

### Communication plan

The module rationale accepts that the ARB package is the formal
communication artifact; the plan around it tells reviewers when
to expect packages and what to do between reviews:

- **Standing ARB cadence** — reviews on a predictable schedule;
  packages shipped a stated interval before the meeting so
  reviewers can read in advance.
- **Pre-reads for cross-cutting concerns** — each cross-cutting
  owner (identity, observability, security, cost, data
  governance) receives the relevant section ahead of the full
  package.
- **Out-of-cycle path** — the event-driven channel for
  decisions that cannot wait for the next ARB; the module's
  governance exercise (exercise 4) names the triage rubric that
  routes a change here.
- **Decision broadcast** — how ARB outcomes get back to the
  teams whose work depends on them; without this, decisions
  made do not become decisions kept.

### ARB package template

The module rationale states the package *documents the change,
its alternatives, the recommendation, and the implementation
plan* and is readable by a busy executive in 15 minutes. The
template is factored so each stakeholder reads the section
they own first:

1. **Executive summary** — one page: the change, why now, the
   recommendation, the top three risks, the ask of the ARB.
2. **Context** — baseline state, drivers (new capability, new
   data class, new adversary technique, cost pressure,
   compliance requirement).
3. **Options considered** — the alternatives, with the
   trade-offs the architect used to pick the recommendation.
   Mirrors the ADR *alternatives-considered* discipline from
   exercise 4.
4. **Recommendation** — the proposed decision, framed as an
   architecture change rather than a product selection.
5. **Cross-cutting concerns impact** — identity, observability,
   security, cost, data governance. Points at the uniform
   treatments from the Zachman grid (exercise 3).
6. **AI/ML risk impact** — mapped against NIST AI RMF
   functions (*Govern / Map / Measure / Manage*) and against
   relevant OWASP ML Top 10 / MITRE ATLAS techniques for the
   platform.
7. **Implementation plan** — the sequenced migration plan from
   exercise 2, with the specific stages that depend on this
   decision.
8. **Ask** — what the ARB is being asked to approve, with the
   explicit decision options.

Appendices carry depth material (full data-flow diagrams,
detailed ADRs, cost models). The main document stays within the
15-minute executive bound.

### Decision rationale

Stakeholder management is treated as the operating model
around the ARB package rather than a separate program because
the module solution's deliverable *is* the package. Trade-offs
the module rationale accepts:

- Executive readability constrains depth; appendices carry
  everything else.
- Standing cadence slows some decisions; the out-of-cycle
  channel is the pressure release.
- Pre-reads add preparation load for cross-cutting owners;
  this is the price of consistent cross-cutting treatment.

### What stays out of scope

The architect-tier answer **does not** redesign the
organization's governance structure, redefine corporate RACI
charts, or replace executive communication conventions; it
produces the architecture-side artifacts that plug into the
existing governance.

## Implementation

Implementation of the stakeholder-management artifacts lands
alongside the governance artifacts from exercise 4:

1. **Stakeholder map file** — a versioned document / structured
   file listing stakeholders, decision rights, and
   information needs.
2. **Communication plan file** — the cadence, pre-read
   routing, out-of-cycle channel, and decision-broadcast
   mechanism.
3. **ARB package template** — the template committed to the
   repo; each ARB submission starts as a copy of this
   template.
4. **Section ownership** — each ARB section names the
   stakeholder role responsible for signing off on it;
   signatures sit in the versioned package rather than in
   email.
5. **AI/ML risk anchoring** — the risk section explicitly
   references the NIST AI RMF function(s) engaged and the
   adversary-technique catalogue entries (OWASP ML Top 10 /
   MITRE ATLAS) relevant to the change.
6. **Linkage back to ADRs** — each ARB package references the
   ADRs it depends on or supersedes, so governance and
   stakeholder communication share a single history.

## 3. Validation steps

1. Open the stakeholder map. Confirm every named stakeholder
   has decision rights (even if "advisory") and an information
   need; absence of either is a fail.
2. Open the communication plan. Confirm it names both the
   standing cadence and the out-of-cycle path, and that the
   out-of-cycle path references the triage rubric from the
   governance exercise.
3. Open the ARB package template. Confirm it starts with a
   one-page executive summary readable in 15 minutes.
4. Walk the template as the executive sponsor would: read
   only the summary. Confirm the summary names the change,
   drivers, recommendation, top risks, and the ask.
5. Walk the template as the security owner would: read only
   section 5 and 6. Confirm cross-cutting impact and AI/ML
   risk are present, with references to the uniform
   treatments and the NIST AI RMF / adversary catalogues.
6. Confirm the implementation plan section references the
   migration plan from exercise 2, so the decision is not made
   in a vacuum.
7. Confirm the package references related ADRs so governance
   history is traceable.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Stakeholder map | Decision rights + info needs per stakeholder | List of names only |
| Communication plan | Standing cadence + out-of-cycle path + decision broadcast | Only "we meet when needed" |
| ARB template — exec summary | One page, 15-minute readable | Multi-page summary |
| ARB template — alternatives | Alternatives considered with trade-offs | Recommendation only |
| ARB template — cross-cutting | Impact across identity / observability / security / cost / data gov | Only engineering impact |
| ARB template — AI/ML risk | NIST AI RMF function(s) + OWASP ML / ATLAS techniques named | Generic risk section |
| ARB template — implementation plan | References exercise 2 migration plan | Freestanding plan |
| ADR linkage | References dependent / superseded ADRs | ARB and ADR histories disconnected |
| Section ownership | Each section has a named owner | Unowned sections |
| Form | Versioned Markdown; PDF generated for the executive read-out | PDF-only, no diffable source |

## 5. Common mistakes

Drawn from the module-level "common mistakes graders see",
specialized to the stakeholder-management frame:

1. **Executive summary that is not a summary.** Multi-page
   "summaries" break the 15-minute bound the module rationale
   sets.
2. **Alternatives missing.** The ARB package mirrors the ADR
   discipline from exercise 4; without alternatives, graders
   cannot evaluate the recommendation.
3. **Cross-cutting impact only in engineering terms.** The
   module solution calls out *cross-cutting concerns treated
   per-system, inconsistently* as a recurring failure; the
   stakeholder-management artifact is where it finally
   surfaces to the owners of each concern.
4. **AI treated as generic.** No reference to the NIST AI RMF
   functions or to specific adversary techniques leaves ML
   risk invisible to reviewers.
5. **Decisions that do not broadcast.** Without a
   decision-broadcast mechanism, ARB outcomes do not reach the
   teams whose work depends on them, and governance decays.
6. **Stakeholder map as a contact list.** Without decision
   rights, the map is not usable; reviewers cannot tell who
   can veto what.

## 6. References

- The Open Group — TOGAF Standard (Architecture Governance
  and Stakeholder Management content):
  <https://www.opengroup.org/togaf>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
