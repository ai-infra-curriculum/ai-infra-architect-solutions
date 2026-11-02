# SOLUTION — Exercise 2: TCO Analysis Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-304-cost-finops/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **FinOps team
structure** deliverable: *a central FinOps team for tooling,
dashboards, and anomaly detection; embedded FinOps champions
per platform team; a quarterly review cadence with engineering
leadership.* The architect-tier answer is the organizational
design that makes TCO analysis a repeatable capability rather
than a one-off spreadsheet.

The module rationale frames FinOps as a capability the business
depends on to *see, attribute, forecast, and optimize* ML
spend. TCO analysis is the forecast surface — it tells the
organization what a workload will cost over its lifecycle, so
leadership can commit to it (exercise 3), monitor it against
anomalies (exercise 4), and iterate on its optimization
(exercise 5). Without a named team and cadence, TCO analyses
become shelf-ware the week after they are produced.

## 2. Worked answer

A passing TCO application submission produces three linked
artefacts:

1. **Team structure chart** — central FinOps team plus
   embedded champions per platform team, with charters.
2. **TCO review cadence** — the quarterly engineering
   leadership review plus any supporting rhythms (monthly
   champion huddle, weekly dashboard check).
3. **TCO analysis template** — the artefact a champion
   produces for a workload, consumed by the quarterly review.

### Team structure

The module rationale enumerates the roles:

| Role | Responsibility | Reports into |
| --- | --- | --- |
| **Central FinOps team** | Tooling, dashboards, anomaly detection, warehouse pipeline (exercise 1), reservation strategy (exercise 3) | Platform / infrastructure leadership |
| **Embedded FinOps champion** | TCO analyses for the champion's platform team, dashboard review, tagging compliance | Platform team (dotted line to central) |
| **Quarterly review audience** | Engineering leadership, finance partners, central FinOps | Programme sponsor |

The central team owns the horizontal capability; the embedded
champions carry the workload-level analysis into their teams.
Both roles are necessary — a central team without embedded
champions becomes a reporting function; champions without a
central team drift onto per-team spreadsheets.

### TCO review cadence

The module rationale is explicit about **quarterly review with
engineering leadership**. The passing submission names the
rhythms that feed it:

- **Weekly dashboard check (champion level)** — spend by
  service, environment, model-name against prior-week delta.
- **Monthly champion huddle (central + embedded)** — surface
  anomalies, align on reservation posture, review new TCO
  submissions.
- **Quarterly leadership review** — forecasts updated,
  reservation strategy adjusted, workload-level optimization
  priorities reset.

The quarterly review is the forcing function; the lower
cadences exist so the quarterly review is not the first time a
problem is seen.

### TCO analysis template

Each TCO analysis is produced by the owning champion and
reviewed in the leadership forum. Minimum sections:

1. **Workload scope** — which service(s), environments, and
   models are inside the analysis boundary, with the tag
   filters that define it.
2. **Current state** — rolling-12-month attributed spend from
   the exercise-1 pipeline, broken down by compute / storage /
   data egress / managed services / support.
3. **Forecast** — projected spend for the next planning
   horizon, with assumptions documented alongside the number.
4. **Hidden-cost line items** — data egress, support tier,
   professional services, developer time; the module rationale
   accepts that these recur as grader-flagged omissions.
5. **Scenario comparison** — at least one alternative scenario
   (right-sizing, workload consolidation, reservation
   coverage), with the delta against the baseline.
6. **Decision asks** — the specific decisions the review is
   being asked to make (reservation commitment, workload exit,
   optimization investment).

The template is the artefact that gets reused; the quarterly
review consumes templates, not ad-hoc memos.

### AI/ML risk anchoring

The NIST AI RMF *Govern* function frames risk as an
organizational capability, not a document — the FinOps team
structure is where cost-of-AI risk becomes a governed
capability with named owners and a stated cadence. For ML
workloads the TCO template exposes model-name-level spend
(from exercise 1), so model economics stay visible when the
Measure function reviews production models. Adversary-technique
catalogues (OWASP ML Top 10, MITRE ATLAS) include cost-amplifying
abuse patterns; the champion huddle is the place those signals
cross the FinOps / security boundary.

### Decision rationale

A central-plus-champions structure with a quarterly cadence is
the right altitude because the module rationale frames FinOps
as a *capability* that must be owned, not a dashboard that must
be built. Trade-offs the learner should explicitly accept:

- **Dual reporting is intentional.** The embedded champion
  reports into their platform team but takes guidance from
  central FinOps; both relationships are necessary.
- **Quarterly cadence is the minimum.** Faster rhythms are
  additive; slower cadences lose the forecast surface.
- **TCO templates are versioned.** The template evolves as the
  business learns which hidden costs recur.

### What stays out of scope

The architect-tier answer **does not** build the attribution
pipeline (exercise 1), commit to reservations (exercise 3),
stand up anomaly detection (exercise 4), or author workload-
level optimization playbooks (exercise 5). The goal here is
the team structure and TCO review surface.

## Implementation

Implementation of the FinOps team and TCO review artefacts
lands as versioned architecture assets:

1. **Team charter document** — Markdown in the architecture
   repository defining the central team, embedded-champion
   role, and reporting lines.
2. **Cadence calendar** — weekly / monthly / quarterly rhythms
   named with owners and inputs.
3. **TCO analysis template** — structured Markdown template
   with the six required sections.
4. **Decision log** — the record of decisions the quarterly
   review has made; without this, the review becomes a
   presentation rather than a governance body.
5. **Governance hook** — material TCO decisions (reservation
   commitment, workload exit) are captured as ADRs via the
   governance system from `mod-301/exercise-4`.
6. **Interface to adjacent capabilities** — named handoffs to
   security (abuse signals), platform engineering (right-
   sizing work), and finance (budget alignment).

## 3. Validation steps

1. Open the team charter. Confirm it names a central FinOps
   team *and* embedded champions per platform team — a
   charter missing either role is a fail per the module
   rationale.
2. Confirm the quarterly review with engineering leadership is
   named and that the lower-cadence rhythms feed it.
3. Open the TCO analysis template. Confirm it covers scope,
   current state, forecast, hidden costs, scenario comparison,
   and decision asks.
4. Confirm hidden-cost line items (egress, support, services)
   are first-class, not left as a general "other" bucket.
5. Confirm model-name-level spend is reachable in the current-
   state section for ML workloads, so the forecast ties back
   to per-model economics from exercise 1.
6. Confirm the decision log exists and that decisions trace to
   ADRs when they are material.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Central team | Named with charter | Only a project manager role |
| Embedded champions | One per platform team with scope | Champions optional or unassigned |
| Review cadence | Weekly / monthly / quarterly all named | Quarterly only, no supporting rhythms |
| Leadership review | Engineering leadership + finance in attendance | Peer review only |
| TCO template | All six sections present | Spreadsheet without narrative |
| Hidden costs | Egress / support / services first-class | Buried in "other" |
| ML granularity | Per-model-name spend reachable | ML as a single bucket |
| Decision log | Decisions captured with owners and dates | Review notes without decisions |
| Form | Versioned Markdown + structured template | PDF deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
section:

1. **FinOps as a reporting function.** A central team without
   embedded champions produces dashboards that *no one looks
   at* — the module rationale flags this failure directly.
2. **Review cadence named, not operated.** A quarterly review
   on the calendar without the monthly / weekly rhythms that
   feed it is a presentation, not a capability.
3. **Hidden costs omitted from TCO.** Data egress, support
   tiers, and professional services are where multi-cloud
   bills land; a TCO template that leaves them out is
   immediately misleading.
4. **ML aggregated.** The TCO template must expose per-model
   spend; otherwise the forecast cannot support the model-
   level decisions the business needs to make.
5. **No decision log.** The review loses its governance role
   if decisions are not captured and traced to ADRs.

## 6. References

- FinOps Foundation — FinOps Framework overview —
  <https://www.finops.org/framework/>
- FinOps Foundation — Personas (FinOps practitioner,
  engineering, finance, leadership) —
  <https://www.finops.org/framework/personas/>
- FinOps Foundation — *Education & Enablement* capability
  (champions and training) —
  <https://www.finops.org/framework/capabilities/education-enablement/>
- FinOps Foundation — *Policy & Governance* capability —
  <https://www.finops.org/framework/capabilities/policy-governance/>
- AWS Well-Architected — Cost Optimization pillar
  (organizational practices) —
  <https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/welcome.html>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
