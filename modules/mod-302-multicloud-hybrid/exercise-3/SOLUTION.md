# SOLUTION — Exercise 3: Vendor Selection Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-302-multicloud-hybrid/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **cost-comparison
model** deliverable framing — *per-workload TCO across clouds,
including hidden costs (data egress, support tiers,
professional services). The deliverable is a spreadsheet model
with documented assumptions* — to the broader problem of
**vendor selection** for an AI/ML platform. The architect-tier
answer is a reproducible scoring artefact plus the TCO model
that feeds it, so vendor selection is defensible rather than
preferential.

The module rationale is direct that multi-cloud carries an ops
tax, that lowest-common-denominator services lose features, and
that *the architecture team has to maintain N-cloud expertise*.
Vendor selection is where those costs become line items; the
exercise exists so that the learner's selection recommendation
is traceable to criteria rather than vendor preference.

## 2. Worked answer

A passing vendor-selection submission produces three linked
artefacts:

1. **Scoring criteria** — the weighted criteria the
   organization uses to evaluate vendors, derived from the
   module rationale and the triggering events from exercise 1.
2. **Per-workload TCO model** — the spreadsheet-style model
   the module rationale asks for, with documented assumptions
   and visible hidden-cost line items.
3. **Vendor scorecard and recommendation** — the applied
   criteria + TCO per candidate vendor, with the recommended
   selection and the alternatives that were rejected (mirroring
   the ADR *alternatives-considered* discipline from
   `mod-301/exercise-4`).

### Scoring criteria

A passing scoring sheet weights criteria explicitly. Minimum
criteria, with suggested weightings:

| Criterion | What it measures | Suggested weight |
| --- | --- | --- |
| Fit to triggering event | Does the vendor resolve the exercise-1 trigger (residency, concentration, M&A, cost)? | 20% |
| TCO over 3 years | Fully loaded cost including egress, support, prof services | 20% |
| AI/ML service depth | Fitness for named ML workloads (training, serving, retrieval) | 15% |
| Cross-cutting concerns | Identity, observability, security, data governance treatments | 15% |
| Exit cost | Cost of unwinding the selection | 10% |
| Operational maturity | SLAs, incident history, support quality | 10% |
| Compliance surface | Certifications aligned to the organization's frames | 5% |
| Ecosystem / partners | Integrations with existing systems | 5% |

The weighting is stated and defended. "Preference" is not a
criterion.

### Per-workload TCO model

The module rationale is explicit that the deliverable is a
*spreadsheet model with documented assumptions*. The model has
one tab per workload (or structured-data equivalent), with
these rows:

- **Compute** — training vs. inference, GPU vs. CPU, baseline
  utilisation, autoscaling behaviour.
- **Storage** — hot / warm / cold tiers, retention, and
  snapshot cost.
- **Data egress** — called out explicitly by the module
  rationale as a hidden cost; the model shows egress volumes
  and rate per direction.
- **Support tier** — the chosen support plan with its monthly
  cost, not the free tier.
- **Professional services** — one-off and standing
  engagements.
- **Licensing** — any add-on licensing (orchestration,
  observability, security tooling).
- **FX / commitment** — reserved capacity vs. on-demand, with
  commitment risk documented.

Each line names its assumption source (vendor pricing page,
negotiated discount, internal estimate) and the date the
assumption was captured.

### Vendor scorecard and recommendation

The scorecard applies the weighted criteria to each candidate
vendor and shows the arithmetic. The recommendation names:

- **The recommended selection** — per workload class if
  multi-cloud (exercise 1) placed workloads differently; per
  platform if single-cloud.
- **Rejected alternatives with reasons** — mirrors the ADR
  *alternatives-considered* discipline; the reasons map back
  to the scoring criteria so the recommendation is auditable.
- **Re-evaluation triggers** — the events that reopen the
  selection (vendor pricing change, new workload class, new
  regulatory frame, failed SLA quarter).

### AI/ML risk anchoring

Vendor selection carries ML-specific risk the generic criteria
miss. The scorecard explicitly addresses:

- **NIST AI RMF** — the vendor's ability to support the
  *Govern / Map / Measure / Manage* functions (model
  inventory, evaluation surfaces, incident response
  integration).
- **OWASP ML Top 10 and MITRE ATLAS** — which adversary
  techniques are mitigated by vendor-provided controls versus
  which must be built on top.
- **Supply chain** — provenance of base models, third-party
  model APIs, and dependency surfaces introduced by the vendor
  choice.

### Decision rationale

Vendor selection as a scored artefact plus a TCO model is the
right altitude because the module rationale lists cost as one
of the four deliverables and names *data egress, support tiers,
professional services* as the hidden costs that make or break
multi-cloud economics. Trade-offs the learner should accept,
mirroring the module rationale:

- A weighted scorecard surfaces preferences as weights; the
  weighting itself must be defended rather than concealed.
- TCO snapshots age; a dated model with re-evaluation triggers
  is better than a one-off estimate.
- Vendor concentration can be *the* answer when the triggering
  event is cost or depth; multi-vendor should emerge from the
  criteria, not from an aesthetic.

### What stays out of scope

The architect-tier answer **does not** negotiate contracts,
pick specific SKUs beyond what the TCO needs, or produce legal
procurement documents. The goal is a defensible selection
*architecture* side; procurement is downstream.

## Implementation

Implementation of the vendor-selection artefacts lands as
versioned architecture assets:

1. **Scoring criteria document** — Markdown table with
   weightings and the rationale for each weight.
2. **TCO model** — one spreadsheet (or structured data file)
   per workload or a workbook with per-workload tabs; the
   module rationale is explicit about the format.
3. **Vendor scorecard** — the applied criteria per candidate
   vendor, with the arithmetic visible.
4. **Recommendation document** — ADR-style, with
   alternatives-considered and re-evaluation triggers.
5. **AI/ML risk map** — the vendor-side control coverage
   mapped against NIST AI RMF functions and OWASP ML Top 10 /
   MITRE ATLAS techniques; gaps become architectural work for
   the platform.
6. **Dated assumptions log** — every TCO assumption has a
   source and a capture date; the log is the signal for when
   the TCO is stale.

## 3. Validation steps

1. Open the scoring criteria. Confirm each criterion has a
   weighting and that the weightings sum to 100%. Any
   un-weighted "we also care about" bullets is a fail.
2. Open the TCO model. Confirm each workload has line items
   for compute, storage, **egress**, support tier,
   professional services, licensing, and commitment risk.
   Missing egress is the single most common fail, flagged by
   the module rationale.
3. Confirm each TCO assumption cites a source and a date.
4. Open the vendor scorecard. Confirm the arithmetic is
   visible (per-criterion scores and the weighted total), not
   just a bolded recommendation.
5. Open the recommendation document. Confirm it names rejected
   alternatives with reasons, mirroring the ADR
   *alternatives-considered* discipline.
6. Confirm re-evaluation triggers are stated — a selection
   without a re-opening path decays silently.
7. Confirm the AI/ML risk map ties vendor-side controls to
   NIST AI RMF functions and adversary-technique catalogues.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Scoring criteria | Weighted, summing to 100% | Un-weighted bullet list |
| TCO — hidden costs | Egress, support, prof services, licensing present | Headline rate only |
| Assumption traceability | Each line cites a dated source | Un-sourced estimates |
| Scorecard arithmetic | Per-criterion scores visible, totals computed | Bolded recommendation only |
| Alternatives | Rejected vendors with reasons | Winner only |
| Re-evaluation triggers | Events that reopen the selection named | Selection presented as permanent |
| AI/ML risk map | Vendor controls mapped to NIST AI RMF + OWASP ML / ATLAS | AI treated as generic |
| Form | Versioned document + spreadsheet / structured data | PDF or slide deck |

## 5. Common mistakes

Drawn from and specialized from the module-level "common
mistakes graders see":

1. **Headline rates only.** The module rationale is specific:
   *data egress, support tiers, professional services* are
   where multi-cloud / vendor economics live. Omitting them is
   the dominant fail.
2. **Un-weighted criteria.** Without weights, the
   recommendation is a vote; the exercise asks for a defensible
   selection.
3. **No alternatives considered.** Mirrors the ADR failure
   mode from `mod-301/exercise-4`.
4. **TCO without an expiry.** Vendor pricing changes; a model
   without re-evaluation triggers decays silently.
5. **AI treated as generic.** Vendor selection for an AI/ML
   platform must consider base-model provenance, evaluation
   surfaces, and adversary-technique coverage; NIST AI RMF and
   OWASP ML / ATLAS references are the anchor.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
