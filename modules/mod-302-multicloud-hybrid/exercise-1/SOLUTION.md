# SOLUTION — Exercise 1: Multi-cloud Strategy Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-302-multicloud-hybrid/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the **multi-cloud decision document**
deliverable from the module solution. The architect-tier answer
is *not* a tour of each cloud's AI/ML services; it is a signed,
versioned decision document that says *why* this organization
is going multi-cloud, what the topology is, where the data
master lives, and what the ongoing operational cost is.

The module rationale is explicit: *if the document can't answer
"why specifically multi-cloud," the decision is wrong.* The
multi-cloud ops tax is real; so are the triggering events
(sovereign-cloud / data-residency mandates, vendor
concentration risk, M&A, workload-specific cost differentials).
This exercise is where the learner shows they can match a
specific triggering event to a specific topology and then
budget the ops cost that falls out.

## 2. Worked answer

A passing multi-cloud strategy submission produces one linked
decision document with four named sections, mirroring the four
questions the module rationale lists:

1. **Why multi-cloud, specifically?** — the triggering event or
   requirement that *rules out* single-cloud.
2. **Topology — active/active, active/passive, or federated?**
3. **Data master** — where authoritative state lives and how it
   crosses cloud boundaries.
4. **Ops cost** — the operational tax the organization is
   accepting, with the staffing and tooling line items that
   realize it.

### Why multi-cloud, specifically?

The document names one or more of the triggering events the
module rationale calls out:

- **Sovereign-cloud / data-residency mandates** — regulated
  data must stay in a specific jurisdiction and the primary
  cloud does not offer a qualifying region.
- **Vendor concentration risk** — concentration limits imposed
  by regulators, boards, or key customers (common in financial
  services, defence, critical infrastructure).
- **M&A** — the organization inherited workloads on another
  cloud and the migration cost or risk makes consolidation
  worse than federation.
- **Workload-specific cost differentials** — a specific
  workload class (e.g., GPU training vs. batch inference vs.
  warehouse analytics) is materially cheaper or faster on a
  second cloud.

The failure mode the module rationale flags — *multi-cloud
chosen for resilience without a triggering event* — is where
most submissions fail. A passing document names the specific
event, not generic "avoid lock-in" prose.

### Topology selection

Given a triggering event, the topology falls out:

| Trigger | Typical topology |
| --- | --- |
| Data residency | **Federated** — jurisdictional workloads pinned to the qualifying cloud; the rest consolidated |
| Vendor concentration limit | **Active/active** across two clouds for the covered workload class |
| M&A | **Active/passive** moving toward consolidation, or **federated** if consolidation is deferred |
| Workload cost differential | **Workload-pinned** — specific workload moves; the rest stays |

The document commits to one topology per workload class and
names the trade-offs. The module rationale is explicit that
*LCD (lowest common denominator) services lose features* — the
document must say which cloud-native features the organization
is giving up for each active/active workload.

### Data master

The module rationale calls out *data master ambiguous* as a
recurring failure mode leading to split-brain incidents. The
decision document picks exactly one answer per data class:

- **Single-master** — one cloud owns writes; the other reads a
  replica. Simpler, bounded staleness window.
- **Multi-master with conflict resolution** — both clouds
  accept writes; conflicts resolved by a stated rule
  (last-writer-wins, CRDT, business rule). Harder; requires
  explicit convergence SLOs.
- **Partitioned** — jurisdictional data never leaves the home
  cloud; cross-jurisdiction reads are explicitly scoped.

For AI/ML specifically, the document names the data master for
each class on the module's inventory: training data,
fine-tuning data, eval data, embeddings, prompt / response
logs, model artifacts. "Where does the authoritative embedding
store live?" is the question that most submissions skip and
most incidents hinge on.

### Ops cost

The document budgets the operational tax the module rationale
accepts. Minimum line items:

- **N-cloud expertise** — the architecture team must maintain
  working knowledge of each cloud; estimated headcount
  loading.
- **Observability federation** — one logical signal store or
  explicit cross-cloud query layer; licensing / build cost
  stated.
- **Identity federation** — one authority or stated
  federation; without it, *federated identity not designed;
  manual sync forever* becomes the failure mode the module
  rationale names.
- **Egress and support tiers** — per-workload line items,
  since cross-cloud data movement is where multi-cloud bills
  land.
- **Policy / compliance surface** — one more cloud is one more
  audit surface, one more set of control mappings.

The budget is numbered as *delta over single-cloud*, not
absolute, so the triggering event's value can be weighed
against it.

### AI/ML risk anchoring

The decision document names where ML-specific risk sits across
clouds. The NIST AI RMF *Govern / Map / Measure / Manage*
functions carry across the topology: the Measure function in
particular needs a unified evaluation surface regardless of
which cloud trains or serves a model. Adversary-technique
catalogues (OWASP ML Top 10, MITRE ATLAS) apply to each cloud
boundary — the document names which cloud's identity layer
owns which trust boundary, so attack-path analysis is not
cloud-specific guesswork.

### Decision rationale

A single decision document is the right altitude because the
module rationale frames the multi-cloud decision as a *why
specifically* question that must be answered before any
topology detail. Trade-offs the learner should explicitly
accept, mirroring the module rationale:

- Multi-cloud has a real ops tax; the triggering event must
  justify it.
- LCD services lose features; the submission names what is
  given up.
- The architecture team has to maintain N-cloud expertise;
  the budget reflects this.

### What stays out of scope

The architect-tier answer **does not** reproduce each cloud's
service catalogue, pick specific SKUs, or render a Terraform
plan — those belong to the reference-topology exercise. The
goal here is the *decision*, with just enough topology detail
to make the budget real.

## Implementation

Implementation of the multi-cloud strategy artifact lands as
versioned architecture assets:

1. **Decision document in the architecture repository** —
   Markdown + structured data, diffable, so the organization
   can see when and why the strategy was revised.
2. **One topology diagram per covered workload class** —
   active/active, active/passive, or federated, named per
   workload rather than globally.
3. **Data-master table** — one row per data class with the
   authoritative cloud, replication SLOs, and conflict-
   resolution rule.
4. **Ops-cost budget** — line items for N-cloud expertise,
   observability federation, identity federation, egress /
   support tiers, policy surface; stated as delta over
   single-cloud.
5. **AI/ML risk map** — mapping the NIST AI RMF functions and
   relevant OWASP ML Top 10 / MITRE ATLAS techniques to the
   multi-cloud trust boundaries.
6. **Exit criteria** — the module rationale calls out *no exit
   strategy if multi-cloud doesn't pay off* as a recurring
   failure. The document names the conditions under which the
   strategy is revisited (consolidation, further
   diversification) and the cost of exit.

## 3. Validation steps

1. Open the decision document. Confirm the first section names
   a specific triggering event; "avoid lock-in" without a
   triggering event is a fail by the module rationale.
2. Confirm topology is picked per workload class, not globally,
   and that each pick names the LCD features given up.
3. Open the data-master table. Confirm every data class on the
   AI/ML inventory has exactly one answer and that
   authoritative stores are named per cloud.
4. Open the ops-cost budget. Confirm it includes N-cloud
   expertise, observability federation, identity federation,
   egress / support tiers, and policy surface — stated as
   delta over single-cloud.
5. Confirm federated identity is designed (one authority or a
   stated federation), not deferred to "manual sync" — a fail
   signal per the module rationale.
6. Confirm the AI/ML risk map ties NIST AI RMF functions and
   adversary catalogue entries to the specific cross-cloud
   trust boundaries.
7. Confirm exit criteria are named; a strategy without an exit
   path is incomplete.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Triggering event | Specific event named (residency, concentration, M&A, cost) | Generic "avoid lock-in" |
| Topology | One pick per workload class, LCD features named | One global topology, features unaddressed |
| Data master | One authoritative cloud per data class | Ambiguous or "either side" |
| Identity federation | Single authority or explicit federation | Manual sync |
| Ops cost | Delta over single-cloud with line items | Absolute budget, or absent |
| AI/ML risk anchoring | NIST AI RMF + OWASP ML / ATLAS mapped to trust boundaries | AI treated as generic workload |
| Exit criteria | Named conditions and exit cost | No exit path |
| Form | Versioned Markdown + structured data | PDF or slide deck |

## 5. Common mistakes

Drawn directly from the module-level "common mistakes graders
see" section:

1. **Multi-cloud chosen for resilience without a triggering
   event.** Doubles cost without value. A passing document
   names the specific event (residency, concentration, M&A,
   workload cost) that rules out single-cloud.
2. **Data master ambiguous.** The module rationale calls out
   split-brain incidents; the document picks one authoritative
   cloud per data class.
3. **No exit strategy if multi-cloud doesn't pay off.** The
   decision has to be reversible on stated conditions.
4. **Federated identity not designed; manual sync forever.**
   Identity federation is budgeted explicitly, not deferred.
5. **AI treated as generic.** The module rationale emphasizes
   the module targets AI/ML infrastructure; the risk map must
   reference NIST AI RMF functions and adversary catalogues
   (OWASP ML Top 10, MITRE ATLAS) across the cross-cloud trust
   boundaries.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
