# SOLUTION — Exercise 1: FinOps Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-304-cost-finops/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **cost-attribution
architecture** deliverable: *every resource is tagged with
environment, team, service, cost-center, workload-type, and
model-name (for ML). Tagging is enforced at provisioning. The
deliverable is the tagging policy + the attribution pipeline
(cloud billing → warehouse → per-team dashboards).* The
architect-tier answer is the policy and pipeline that make
per-team FinOps possible, not a line-item inventory.

The module rationale frames ML workloads as unusually expensive;
the FinOps capability exists so that the business can **see,
attribute, forecast, and optimize** that spend. Exercise 1 is
the *see* and *attribute* foundation — without it, the later
exercises (team structure, reserved capacity, anomaly detection,
workload optimization) do not have signal to act on.

## 2. Worked answer

A passing FinOps application submission produces three linked
artefacts:

1. **Tagging policy** — the required-tag schema with
   enforcement rule.
2. **Attribution pipeline** — the data path from cloud billing
   into the warehouse and out to per-team dashboards.
3. **Per-team dashboard contract** — what every team sees,
   where it lives, and the cadence at which it is reviewed.

### Tagging policy

The module rationale enumerates the mandatory tag schema:

| Tag | Required value | Why |
| --- | --- | --- |
| `environment` | `prod` / `staging` / `dev` / `sandbox` | Separates production spend from experimentation |
| `team` | Owning team identifier | Routes cost to a named owner |
| `service` | Owning service identifier | Maps to the service catalogue |
| `cost-center` | Finance cost-center code | Lets finance roll spend into budget |
| `workload-type` | `training` / `inference` / `batch` / `data` / `platform` | ML-specific optimization lenses apply by type |
| `model-name` | Model identifier for ML workloads | Per-model unit economics (cost per request, cost per training run) |

Enforcement is **at provisioning**, not after the fact. The
module rationale lists *tagging policy without enforcement* as a
grader-visible failure; the policy must name the enforcement
mechanism (policy-as-code gates, provisioning templates, or
denies on untagged resources).

### Attribution pipeline

The pipeline moves billing data from the cloud provider into a
warehouse and emits per-team views:

1. **Cloud billing export** — the native export (AWS CUR, GCP
   BigQuery billing export, Azure Cost Management export) is
   the authoritative source.
2. **Warehouse ingestion** — the raw export lands in a
   warehouse table partitioned by billing day, with tag
   columns parsed into first-class fields.
3. **Attribution join** — the warehouse joins billing rows to
   the tag schema and the organizational directory (team →
   cost-center → business unit).
4. **Per-team dashboards** — the warehouse feeds per-team
   dashboards that show spend by service, environment, and
   workload-type, with the drill-down to model-name for ML.
5. **Audit path** — every row traces back to a specific
   billing-export row so cost disputes can be settled against
   the authoritative source.

### Per-team dashboard contract

The module rationale lists *cost dashboards no one looks at* as
a grader-visible failure. The deliverable is a dashboard
*contract*, not a dashboard: every team is told what it will
see, where it lives, and the cadence at which it must be
reviewed. Minimum contents:

- **Rolling 30-day spend by service / environment /
  workload-type**, with the delta against the prior period.
- **Untagged-spend indicator** so a team can see when its own
  spend is dropping off the attribution pipeline.
- **Per-model unit economics** (cost per request, cost per
  training run) for ML workloads tagged with `model-name`.
- **Review cadence** — the dashboard is reviewed at a stated
  cadence (monthly engineering review or weekly FinOps-champion
  check-in from exercise 2).

### AI/ML risk anchoring

ML workloads are the module's focus; the attribution pipeline
must support the governance surface the broader programme
depends on. The NIST AI RMF *Measure* function requires
per-model operational metrics; `model-name` is the join key
that lets cost sit alongside quality and latency metrics in the
same measurement surface. Adversary-technique catalogues (OWASP
ML Top 10, MITRE ATLAS) treat unexpected cost spikes as a
possible abuse signal — the attribution pipeline is where that
signal becomes visible to the security surface in exercise 4.

### Decision rationale

A tagging policy plus a warehouse-backed attribution pipeline
is the right altitude because the module rationale frames
attribution as the foundation of the FinOps capability:
without it, the organization cannot *see, attribute, forecast,
or optimize*. Trade-offs the learner should accept, mirroring
the module rationale:

- **Tagging discipline requires enforcement; the organization
  accepts the friction.** This is explicit in the module
  trade-offs.
- A warehouse-backed pipeline carries fixed cost; it buys
  per-team visibility that per-cloud dashboards cannot
  reproduce.
- Model-name tagging requires discipline from ML teams; the
  policy must be designed with their workflow in mind.

### What stays out of scope

The architect-tier answer **does not** stand up the FinOps
*team* (exercise 2), commit to reservations (exercise 3), build
anomaly detection (exercise 4), or author workload-level
playbooks (exercise 5). The goal here is the attribution
foundation.

## Implementation

Implementation of the FinOps attribution artefacts lands as
versioned architecture assets:

1. **Tagging policy document** — Markdown in the architecture
   repository with the required-tag schema and the enforcement
   mechanism.
2. **Attribution pipeline diagram** — one diagram covering
   cloud billing export → warehouse → per-team dashboards,
   with the attribution join explicit.
3. **Warehouse schema** — the structured definition of the
   billing-with-tags table and the dimensional joins (team,
   cost-center, service).
4. **Per-team dashboard contract** — one page naming the
   required panels, review cadence, and dashboard ownership.
5. **Enforcement artefact** — policy-as-code template,
   provisioning module, or deny rule that implements the
   enforcement promise in the policy document.
6. **Governance hook** — any schema change requires an ADR via
   the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the tagging policy. Confirm it names every mandatory
   tag from the module rationale (`environment`, `team`,
   `service`, `cost-center`, `workload-type`, `model-name`).
2. Confirm the policy names the enforcement mechanism
   explicitly; a policy without enforcement is a fail per the
   module's "tagging policy without enforcement" failure
   signal.
3. Open the pipeline diagram. Confirm the authoritative source
   is the cloud billing export and that the per-team
   dashboards trace back to that export.
4. Open the dashboard contract. Confirm it names a review
   cadence; dashboards without a review cadence satisfy the
   module's "cost dashboards no one looks at" failure signal.
5. Confirm per-model unit economics are reachable for ML
   workloads via `model-name`; a pipeline that cannot cut by
   model is incomplete for an AI-infra programme.
6. Confirm an untagged-spend indicator is present so teams can
   detect when their attribution is drifting.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Tag schema | All six required tags present and defined | Missing tags, or tags without allowed-value lists |
| Enforcement | Policy-as-code / provisioning gate named | "Teams will tag their resources" |
| Pipeline | Cloud billing export → warehouse → dashboards | Dashboards fed from ad-hoc exports |
| Audit path | Dashboard rows trace to billing export | No lineage to authoritative source |
| Dashboard cadence | Stated review cadence and owner | Dashboards exist, no one reviews |
| Untagged-spend indicator | Present per team | Untagged spend hidden |
| ML granularity | `model-name` tag + per-model unit economics | ML treated as a single bucket |
| Form | Versioned Markdown + structured policy artefact | PDF or screenshot of a dashboard |

## 5. Common mistakes

Drawn directly from the module-level "common mistakes graders
see" section:

1. **Cost dashboards no one looks at.** Build the review
   cadence into the dashboard contract, not into optimistic
   intent.
2. **Tagging policy without enforcement.** The policy document
   must name a provisioning-time enforcement mechanism, not a
   human promise.
3. **ML treated as a single bucket.** The module targets AI/ML
   infrastructure; a pipeline that cannot cut by `model-name`
   or `workload-type` cannot support the later optimization
   exercises.
4. **No audit path to the billing export.** Without lineage,
   cost disputes cannot be settled and the pipeline becomes a
   political artefact rather than a decision tool.

## 6. References

- FinOps Foundation — FinOps Framework overview —
  <https://www.finops.org/framework/>
- FinOps Foundation — *Allocation* capability (tagging,
  showback, and chargeback discipline) —
  <https://www.finops.org/framework/capabilities/allocation/>
- AWS — User-defined cost allocation tags —
  <https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-alloc-tags.html>
- Google Cloud — Billing export to BigQuery —
  <https://cloud.google.com/billing/docs/how-to/export-data-bigquery>
- Microsoft Azure — Tag resources, resource groups, and
  subscriptions for logical organization —
  <https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
