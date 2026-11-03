# SOLUTION — Exercise 2: Hybrid Cloud Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-302-multicloud-hybrid/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **hybrid
integration patterns** deliverable: *on-prem + cloud requires
explicit connectivity (Direct Connect, ExpressRoute,
Interconnect) and identity bridging. The deliverable enumerates
patterns for synchronous vs. async integration.* The
architect-tier answer is a named catalogue of integration
patterns, with the one each workload is assigned to, so the
hybrid platform is operable rather than ad-hoc.

Hybrid is not the same decision as multi-cloud. Multi-cloud
answers "which clouds and why"; hybrid answers "which workloads
stay on-prem and how do they integrate with the cloud." The
triggering events overlap (sovereignty, M&A, workload cost),
but the integration surface is different: a dedicated
connectivity path and an identity bridge, with explicit
synchronous vs. asynchronous patterns per workload.

## 2. Worked answer

A passing hybrid cloud submission produces one document with
three linked artifacts:

1. **Workload residency map** — one row per workload stating
   where it lives (on-prem, cloud, or hybrid), why, and the
   constraint that pins it.
2. **Connectivity design** — the dedicated path(s) between
   on-prem and each cloud, with the identity bridge named.
3. **Integration pattern catalogue** — the synchronous and
   asynchronous patterns the platform supports, with each
   workload assigned to one.

### Workload residency map

Each workload is assigned to on-prem, cloud, or hybrid for a
reason the module rationale would accept — data residency, a
compliance surface that is only certified on-prem, a
specialized hardware stack (GPU clusters pre-dating the cloud
contract), or a cost / latency differential. The failure mode
to avoid is the inverse of the multi-cloud failure: *hybrid
chosen without a triggering event*. "We have on-prem servers"
is not a design rationale.

For AI/ML workloads the residency pins are typically:

- **Training data under residency** — training pipeline stays
  on-prem (or in a sovereign region) because the data cannot
  leave.
- **Specialized GPU inventory** — existing on-prem GPU fleet
  carries training until it ages out; cloud GPUs serve
  bursts.
- **Low-latency inference adjacent to systems-of-record** —
  on-prem serving next to the transactional system; cloud
  serving for externally facing surfaces.
- **Model artefacts and governance surface** — centralized
  in one location to keep adversary-technique and risk
  tracking consistent across environments.

### Connectivity design

The module rationale names the three vendor options:
**AWS Direct Connect**, **Azure ExpressRoute**, **Google Cloud
Interconnect**. The decision is not "which one is best" — it
is "which cloud(s) the hybrid connects to and what the
redundancy posture is." Minimum content:

- **Primary / secondary circuits** — at least two independent
  physical paths; otherwise the hybrid has a single point of
  failure for every integration pattern.
- **Private IP range plan** — on-prem and cloud ranges that
  do not collide, with a documented handoff.
- **DNS strategy** — one authoritative resolver story; split
  DNS is where hybrid platforms silently degrade.
- **Throughput commitment** — stated capacity, with a notice
  period for upgrades.

### Identity bridge

The module rationale is explicit about identity: without
federation, the hybrid platform drifts to manual sync. The
identity bridge names:

- **Authoritative identity provider** — on-prem IdP, cloud
  IdP, or an explicit federation. Only one.
- **Service identity model** — workload identities between
  on-prem and cloud (SPIFFE / SPIRE, workload identity
  federation, or an equivalent). Avoids long-lived shared
  secrets for cross-boundary calls.
- **Role / attribute mapping** — the stated mapping between
  on-prem roles and cloud roles; this is where unaudited
  privilege creep lives in most hybrid platforms.

### Integration pattern catalogue

The module rationale asks for *patterns for synchronous vs.
async integration*. A minimum catalogue:

| Pattern | When | Trade-off |
| --- | --- | --- |
| **Synchronous API over private link** | Low-latency reads, user-facing | Couples availability on both sides |
| **Request/response via API gateway** | External integrations | Adds a hop; useful for policy enforcement |
| **Event bus / message queue (async)** | Decoupled workflows, batch | Eventual consistency; needs idempotent consumers |
| **File transfer / batch** | Bulk data movement | Simple, high-latency; needs integrity checks |
| **Change data capture (async)** | Cross-boundary state replication | Tightest with a stated conflict-resolution rule |
| **ML-specific: feature-store read-through** | Online inference reading on-prem features | Add caching; be explicit about staleness |
| **ML-specific: training-data staging** | Cloud training against on-prem data | Encrypted staging + residency guard |

Each workload in the residency map is assigned to one or two
patterns; "ad-hoc integration" is a fail signal.

### AI/ML risk anchoring

Hybrid platforms double the trust-boundary count: on-prem to
cloud *and* cloud to on-prem both carry risk. The document
maps the hybrid boundaries against:

- **NIST AI RMF** — the *Measure* and *Manage* functions
  require unified evaluation and incident response across the
  boundary; the catalogue states where metrics and incidents
  are centralized.
- **OWASP ML Top 10** and **MITRE ATLAS** — supply chain,
  model-extraction, and inference-abuse techniques apply at
  each boundary; the integration pattern per workload names
  which controls apply where.

### Decision rationale

Treating hybrid as a *catalogue of patterns with per-workload
assignments* is the right altitude because the module
rationale frames the deliverable that way. Trade-offs the
learner should explicitly accept:

- Explicit connectivity and identity federation carry fixed
  cost; this is the price of operability.
- A short catalogue (five to seven patterns) is easier to
  defend than a per-workload one-off; new workloads should fit
  an existing pattern.
- Hybrid retains an on-prem operations muscle; the
  organization is choosing to pay for N-environment
  expertise, not only N-cloud.

### What stays out of scope

The architect-tier answer **does not** redesign on-prem
infrastructure, pick a specific SD-WAN vendor, or author
Terraform modules. The goal is the hybrid *shape* — residency,
connectivity, identity, patterns — with enough detail to
assign new workloads without re-opening the decision.

## Implementation

Implementation of the hybrid cloud design lands as versioned
architecture assets:

1. **Workload residency map** — Markdown table or structured
   data; one row per workload with the pin reason.
2. **Connectivity design document** — primary / secondary
   circuits, IP plan, DNS strategy, throughput commitment,
   per each cloud touched.
3. **Identity bridge document** — authoritative IdP, service
   identity model, role / attribute mapping, with an audit
   trail requirement.
4. **Integration pattern catalogue** — one entry per pattern
   with when-to-use, trade-off, and reference implementation
   pointer; each workload references the pattern it uses.
5. **AI/ML control mapping** — references NIST AI RMF
   functions and relevant OWASP ML Top 10 / MITRE ATLAS
   techniques, specifying which pattern realizes which control.
6. **Change management hook** — new workloads must declare
   residency, pattern, and identity treatment before onboarding;
   ties into the governance exercise in `mod-301`.

## 3. Validation steps

1. Open the residency map. Confirm every workload names a
   pin reason — "data residency," "specialized hardware,"
   "low-latency adjacency," etc. "Legacy" without further
   detail is a fail.
2. Open the connectivity design. Confirm **primary and
   secondary** circuits are specified; single-path hybrid is
   a fail signal.
3. Open the identity bridge. Confirm exactly one authoritative
   IdP is named and workload identity is explicit, not
   long-lived shared secrets.
4. Open the integration pattern catalogue. Confirm there is
   coverage for synchronous *and* asynchronous patterns, and
   that each workload is assigned to a pattern.
5. Confirm the AI/ML control mapping references NIST AI RMF
   functions and adversary-technique catalogues for the
   boundary.
6. Confirm the artefacts are in the versioned repository,
   diffable, and that onboarding references the catalogue.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Residency map | Pin reason per workload | "We have on-prem servers" |
| Connectivity | Primary + secondary, IP plan, DNS, throughput | Single circuit, split DNS unresolved |
| Identity bridge | Single authority, service identity, role mapping | Long-lived shared secrets |
| Pattern catalogue | Sync + async patterns with workload assignments | Ad-hoc integration |
| AI/ML controls | NIST AI RMF + OWASP ML / ATLAS mapped per pattern | AI treated as generic |
| Form | Versioned Markdown + structured data | PDF or slide deck |
| Onboarding hook | New workloads must choose a pattern | Catalogue not referenced |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders
see":

1. **Hybrid chosen without a triggering event.** Mirrors the
   module's multi-cloud failure mode. "We have on-prem" is not
   a design.
2. **Identity bridge deferred.** The module rationale is
   emphatic: without federation, hybrid drifts to manual sync
   forever.
3. **Single-circuit connectivity.** A hybrid platform with no
   secondary path has a single point of failure for every
   integration pattern.
4. **Ad-hoc integrations.** Without a catalogue, each new
   workload invents its own integration, and operations cannot
   be rationalized across them.
5. **AI treated as generic.** The hybrid boundary is a trust
   boundary; the control mapping to NIST AI RMF and
   adversary-technique catalogues cannot be skipped.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
