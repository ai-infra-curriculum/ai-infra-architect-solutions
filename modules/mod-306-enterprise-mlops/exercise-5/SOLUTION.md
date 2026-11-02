# SOLUTION — Exercise 5: Real-time Serving Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-306-enterprise-mlops/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise extends the serving-layer architecture from
exercise 4 into the **platform team operating model**
deliverable — *centralized vs. embedded vs. federated platform
team; the reference recommends embedded-platform-engineers +
central-tooling-team for orgs with 50+ ML engineers* — plus the
"when to go beyond" posture that handles real-time serving at
enterprise scale. The architect-tier answer is the operating
model that keeps the serving layer governable as the
organization grows, together with the beyond-the-reference
upgrades the module rationale names (platform-as-product
discipline, internal developer platform, EU AI Act risk
classification).

The module rationale frames the platform team as a product
team with data scientists / ML engineers as customers. Exercise
4 commits the serving architecture; this exercise commits the
operating model that keeps the serving platform's customers
productive and the governance commitments honored at scale.

## 2. Worked answer

A passing exercise-5 submission produces one linked design
package with four named sections:

1. **Operating model** — the centralized / embedded /
   federated commitment, with the role split and interface
   between platform-team segments.
2. **Serving-platform SLOs and customer contract** — what the
   platform team owns and what the model-serving teams own,
   with the shared observability and incident process.
3. **Beyond-the-reference posture** — the three "when to go
   beyond" items the module rationale lists, scoped to the
   serving layer.
4. **Scaling triggers** — the events and metrics that force a
   model shift (centralized → embedded, in-house → vendor,
   per-team serving → fleet-level serving).

### Operating model

The module rationale names three archetypes:

- **Centralized platform team** — one team runs the platform
  for all data scientists and ML engineers. Works at small
  scale; bottlenecks at ~20+ ML engineers.
- **Embedded platform engineers** — platform engineers
  embedded in product teams, with a central tooling team
  owning the shared tools. The module rationale recommends
  this *for orgs with 50+ ML engineers*.
- **Federated platform team** — each business unit runs its
  own platform. Avoids central bottleneck but duplicates
  investment and fragments governance.

The submission commits to one archetype with:

- **Role split** — platform-team roles (serving-infra
  engineers, SRE, product-manager, security-engineer) and
  their reporting lines. "Platform team" without roles is a
  fail signal.
- **Interface to data scientists / ML engineers** — the
  self-service surface (SDK, declarative resource, UI) and
  the escalation path when the self-service surface does not
  cover a request.
- **Governance operating integration** — how the governance
  tiers from exercise 2 are enforced inside the operating
  model (central security review for tier-1; embedded review
  for tier-3).
- **Capacity assumptions** — the number of ML engineers,
  teams, and models the operating model is sized for, with
  the trigger that invalidates the sizing.

### Serving-platform SLOs and customer contract

The platform-as-product discipline the module rationale calls
out means the serving platform publishes:

- **Platform SLOs** — control-plane availability, deployment
  pipeline latency, feature-store availability. Separate from
  the per-model inference SLO (exercise 4).
- **Customer contract** — what model-serving teams can expect:
  deployment turnaround, incident response, roadmap input.
  The contract is published so expectations are not
  negotiated per incident.
- **Shared observability** — the dashboards that both the
  platform team and the model-serving teams consult. The
  observability layer from exercise 1 feeds this.
- **Incident process** — who pages, who owns root-cause,
  who writes the post-incident review. The split is explicit
  (platform owns infra, model team owns model behavior).
- **Deprecation contract** — how the platform retires an
  interface. The lead time is stated so model teams can plan.

### Beyond-the-reference posture

The module rationale names three "when to go beyond"
postures. The submission commits to the serving-specific
instantiation of each:

- **Platform-as-product discipline (DORA / Team Topologies)**
  — the serving platform publishes a quarterly roadmap, has a
  product manager (named role), and runs customer-interview
  cadence with model-serving teams. The DORA metrics
  (deployment frequency, lead time, change-fail rate,
  recovery time) are measured for model deployments.
- **Internal developer platform (Backstage) as unifying
  interface** — the catalog of models, feature definitions,
  and serving endpoints lands in a single self-service UI so
  data scientists have one entry point. Replaces team-by-team
  README documentation. Adoption is a stated commitment, not
  a label.
- **EU AI Act risk classification for regulated workloads** —
  the governance tiering from exercise 2 is extended with
  the EU AI Act high-risk / limited-risk / minimal-risk
  classification where regulated workloads land. The
  mapping to governance tiers is explicit; the gap between
  the frameworks is named rather than hand-waved.

### Scaling triggers

Operating models drift silently; the submission names the
triggers that force a re-evaluation:

- **Headcount triggers** — moving from centralized to
  embedded at ~20 ML engineers; from embedded to a federated
  split at a stated upper bound.
- **Incident triggers** — a tier-1 serving incident that
  exposes a seam between platform and model-team ownership
  triggers an operating-model review.
- **Regulatory triggers** — a new regulated workload (EU AI
  Act, sector-specific regulation) triggers a review of
  governance integration.
- **Vendor-change triggers** — a vendor exit or vendor
  consolidation triggers a build-vs-buy re-evaluation that
  can shift which team owns the capability.

### AI/ML operating-model specifics

The module targets AI/ML; the operating model addresses
risks the generic platform team does not:

- **ML-specific SRE** — classical SRE patterns (SLOs, error
  budgets) extended to model-specific signals. The on-call
  rotation includes model-serving incidents that look like
  drift rather than infrastructure outages.
- **Shared responsibility for model quality** — platform
  owns serving reliability; model teams own model behavior
  under distribution shift. The seam is where incidents
  slip through; the operating model names it explicitly.
- **Data-scientist developer-experience** — the module
  rationale names *platform team disconnected from customers*
  as a dominant failure. Customer-interview cadence and
  self-service metrics (time-to-first-deployment,
  self-service rate) are the structural fix.
- **Compliance operating cadence** — regulated workloads
  carry regulator-facing artifacts (model documentation,
  audit evidence). The operating model names who maintains
  them and how often. NIST AI RMF *Govern* function is the
  anchor.

### Decision rationale

An operating model that embeds platform engineers for scale,
publishes a customer contract, and adopts the three "beyond
the reference" postures is the right altitude because the
module rationale lists both the operating-model deliverable
and the beyond-the-reference adjacencies as architect-tier
concerns. Trade-offs the submission should explicitly accept,
mirroring the module rationale:

- *Enterprise patterns are slower than startup patterns* —
  the operating model is friction over startup speed; the
  trade is for governable scale.
- Embedded platform engineers raise coordination overhead;
  the central tooling team is the counterweight.
- EU AI Act classification raises documentation burden; the
  operating model names the maintainer so the burden is
  bounded.

### What stays out of scope

The architect-tier answer **does not** re-litigate the
serving architecture (exercise 4), the governance policy
(exercise 2), the feature-store architecture (exercise 3), or
the layered architecture (exercise 1). The goal here is the
operating model + beyond-the-reference posture that keeps
the serving layer governable at enterprise scale.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names *"Platform team operating
model (exercise 05)"* in its older module-level enumeration
with the centralized / embedded / federated archetypes and
the embedded-platform-engineers + central-tooling-team
recommendation for 50+ ML engineers. The parent also lists
three "when to go beyond this implementation" items
(platform-as-product discipline, internal developer
platform, EU AI Act risk classification). The per-exercise
table maps Exercise 5 to **Real-time Serving Application**,
so this file layers the operating model and the beyond-the-
reference postures onto the serving architecture from
exercise 4. Platform-as-product, IDP, and EU AI Act
commitments are grounded in NIST AI RMF, OWASP ML Top 10,
and MITRE ATLAS cited in §6.

## Implementation

Implementation of the operating model + beyond-the-reference
posture lands as versioned architecture assets, not as a
running org change:

1. **Operating model document** — Markdown in the
   architecture repository stating the committed archetype,
   role split, interface to customers, governance integration,
   and capacity assumptions. The archetype choice carries a
   stated rationale against the module rationale's 50-ML-
   engineer threshold.
2. **Platform SLO + customer contract** — one Markdown page
   stating platform SLOs, deployment-pipeline SLOs, incident
   process, deprecation contract, and the shared observability
   dashboards.
3. **Beyond-the-reference posture record** — platform-as-
   product commitments (DORA metrics measured, product-manager
   role, interview cadence), IDP adoption plan (catalog scope,
   migration from team READMEs), and EU AI Act mapping
   (governance tier ↔ EU AI Act class).
4. **Scaling triggers table** — structured Markdown keyed on
   trigger type (headcount, incident, regulatory, vendor) with
   the metric or event, the review it forces, and the owner.
5. **AI/ML operating addendum** — ML-specific SRE posture,
   shared-responsibility seam between platform and model
   teams, data-scientist DX metrics, and compliance operating
   cadence. NIST AI RMF, OWASP ML Top 10, and MITRE ATLAS
   cited inline.
6. **Governance hook** — any operating-model change, SLO
   change, or scope shift between platform and model-team
   ownership requires an ADR via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the operating model. Confirm one archetype is
   committed (centralized / embedded / federated) with the
   role split and the stated rationale against the 50-ML-
   engineer threshold.
2. Confirm the interface to data scientists / ML engineers is
   stated (SDK, declarative resource, UI) with an escalation
   path for cases the self-service surface does not cover.
3. Open the platform SLO + customer contract. Confirm
   platform SLOs are separate from per-model inference SLOs
   (exercise 4) and that the customer contract names
   deployment turnaround, incident process, and deprecation.
4. Open the beyond-the-reference posture. Confirm
   platform-as-product commitments include DORA metrics and a
   named product-manager role; IDP adoption names catalog
   scope; EU AI Act mapping is explicit (tier ↔ class).
5. Open the scaling triggers. Confirm trigger types
   (headcount, incident, regulatory, vendor) are each stated
   with a metric or event and the review they force.
6. Confirm ML-specific SRE is addressed and the shared-
   responsibility seam between platform and model teams is
   named explicitly.
7. Confirm the customer-interview cadence or similar
   DX-metric commitment is in place. "No DX metrics" is how
   the platform-disconnected-from-customers failure hides.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Archetype commitment | One of centralized / embedded / federated chosen with rationale | Hybrid without role split |
| Role split | Named roles with reporting lines | "Platform team" as monolith |
| Customer interface | Self-service surface + escalation path | Ad-hoc requests |
| Platform SLOs | Control-plane + pipeline SLOs | Only model inference SLOs reused |
| Customer contract | Deployment turnaround + incident + deprecation named | "Best effort" |
| Platform-as-product | DORA metrics + product-manager role + interview cadence | DORA mentioned as label |
| IDP commitment | Catalog scope + migration plan | IDP as aspiration |
| EU AI Act mapping | Governance tier ↔ class with gap named | Ambiguous mapping |
| Scaling triggers | Headcount / incident / regulatory / vendor with metric | Triggers absent or qualitative only |
| Shared responsibility | Seam between platform and model teams named | Overlapping ownership unresolved |
| DX metrics | Self-service rate / time-to-first-deployment | "Teams are happy" |
| Form | Versioned Markdown + table | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
and the "when to go beyond" section:

1. **Platform team disconnected from customers.** The module
   rationale names this as the dominant failure. Customer-
   interview cadence, published SLOs, and DX metrics are the
   structural fix; a serving platform without them drifts
   toward infrastructure engineers' preferences.
2. **Hybrid archetype without a role split.** "Mostly embedded
   with some central support" collapses the trade-off; the
   role split and reporting lines must be explicit.
3. **DORA / IDP named as label, not practice.** Adopting the
   term without the metrics or the catalog is theater;
   platform-as-product requires the DORA measurements, not
   the vocabulary.
4. **EU AI Act mapping skipped or hand-waved.** Regulated
   workloads require explicit classification; "we will handle
   it" is not a plan. The gap between the internal governance
   tier and the EU AI Act class must be stated.
5. **Scaling triggers absent.** Operating models drift
   silently; without triggers (headcount, incident,
   regulatory, vendor), the model is a point-in-time snapshot
   that becomes stale.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
