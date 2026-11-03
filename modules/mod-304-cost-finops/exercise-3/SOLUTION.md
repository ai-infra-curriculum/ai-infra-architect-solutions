# SOLUTION — Exercise 3: Cost Allocation Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-304-cost-finops/exercises/exercise-3.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **reserved-capacity
strategy** deliverable: *reserved instances / savings plans /
committed-use discounts — which to choose, what coverage % to
target, how to handle forecast uncertainty.* The architect-tier
answer is a cost-allocation posture that commits the
organization to reservations where the TCO forecast is
confident, keeps optionality where it is not, and splits the
risk between the central FinOps team and workload owners
transparently.

The module rationale frames reservations as a **forecast bet**.
Over-committing pays for unused capacity (grader-visible
failure); under-committing leaves savings on the table. Cost
allocation turns that bet into a rule the organization can
operate: each workload class carries a stated coverage target,
and the central FinOps team owns the portfolio-level decisions.

## 2. Worked answer

A passing cost-allocation submission produces three linked
artefacts:

1. **Workload-class coverage matrix** — the target
   reservation / savings-plan / commitment coverage per
   workload class, tied to the tagging schema from exercise 1.
2. **Commitment-posture document** — the organization's
   stance on reservation term, scope, and refresh cadence,
   with the forecast-uncertainty guardrails.
3. **Allocation and showback rules** — how committed-rate
   savings flow back to the workloads that drive them, so the
   portfolio does not socialize wins and privatize losses.

### Workload-class coverage matrix

Coverage is set per workload class, using the `workload-type`
and `environment` tags from exercise 1:

| Workload class | Instrument | Target coverage | Rationale |
| --- | --- | --- | --- |
| **Steady-state inference (prod)** | 1-year savings plan or RI | 70–90% | High forecast confidence; most cost sits here |
| **Steady-state platform services (prod)** | 1-year commitment / CUD | 70–90% | Baseline load does not vary with workload mix |
| **Training (prod, scheduled)** | 1-year commitment on reserved footprint | 30–60% | Partial coverage of the stable baseline; peaks stay on-demand |
| **Burst training** | On-demand or spot | 0% | Volatile; commitment would pay for idle capacity |
| **Dev / staging / sandbox** | On-demand | 0% | Volatile and small enough that commitment risk outweighs saving |

Each row ties back to the tagging schema so the attribution
pipeline from exercise 1 can report coverage against target.

### Commitment-posture document

The module rationale is direct that reservations are a forecast
bet; the posture document names how the organization makes that
bet. Minimum contents:

- **Term preference** — 1-year as default, 3-year only where
  the TCO forecast (exercise 2) covers the term with margin.
- **Scope preference** — compute-family-flexible instruments
  (savings plans, CUDs) over narrowly scoped reservations when
  the ML workload mix is still evolving.
- **Coverage buffer** — the forecast-uncertainty discount; the
  organization commits to a coverage target *below* the
  forecasted baseline, not at it. The buffer is explicit so
  the quarterly review can tighten or loosen it.
- **Refresh cadence** — reservations are reviewed and re-sized
  at the quarterly cadence from exercise 2; the posture
  document names the review inputs.
- **Exit stance** — how under-utilised commitments are
  handled (sale on secondary markets where available,
  internal reallocation, planned burn-down).

### Allocation and showback rules

Reservations create a portfolio-level saving; without an
allocation rule, the saving disappears into a central budget
and workloads optimize to on-demand pricing. The posture
document names the rule:

- **Blended-rate allocation** — committed-rate savings are
  blended across covered workloads and reported in the
  attribution pipeline from exercise 1.
- **Showback to the owning team** — the exercise-1 dashboards
  surface the delta between on-demand and effective (blended)
  rate per workload, so owners see the saving they are
  realising.
- **Charge-through for over-provisioning** — the owning team
  carries the cost of commitments made against their forecast
  that are not realised; this closes the loop between the TCO
  template (exercise 2) and the reservation decision.

### AI/ML risk anchoring

Reservations change the cost shape of ML workloads: committed
footprint lowers the marginal cost of inference and training.
That changes the risk calculus the NIST AI RMF *Manage*
function uses when weighing model deployment decisions — a
cheaper marginal unit raises the ceiling on acceptable
experimentation. The commitment posture is where that signal
becomes explicit, so the Measure function can see when a model
is being retained because it is cheap-to-run rather than
because it meets its quality bar. OWASP ML Top 10 / MITRE
ATLAS abuse patterns that drive cost may remain profitable to
abuse even under commitment; the exercise-4 anomaly surface is
where that abuse is caught.

### Decision rationale

A per-workload-class coverage matrix with an explicit
commitment posture is the right altitude because the module
rationale frames reservations as a bet that must be sized to
forecast confidence, not maximized against possible savings.
Trade-offs the learner should accept:

- **Over-commitment is the named failure.** The matrix sets
  targets below the forecasted baseline on purpose.
- **Flexibility costs saving.** Compute-family-flexible
  instruments carry a smaller discount than narrowly scoped
  reservations; the posture document accepts this trade.
- **Allocation is a political design.** Showback plus charge-
  through aligns incentives; a central silent allocation
  undermines the TCO forecast.

### What stays out of scope

The architect-tier answer **does not** operate the attribution
pipeline (exercise 1), decide team structure (exercise 2),
build anomaly detection (exercise 4), or write workload-level
optimization playbooks (exercise 5). The goal here is the
commitment and allocation posture.

## Implementation

Implementation of the cost-allocation artefacts lands as
versioned architecture assets:

1. **Coverage matrix** — structured file (Markdown table or
   CSV) with workload class, instrument, target coverage, and
   rationale.
2. **Commitment-posture document** — short Markdown document
   with term, scope, buffer, refresh cadence, and exit stance.
3. **Allocation rules** — structured description of blended-
   rate allocation and showback flows, integrated with the
   attribution pipeline from exercise 1.
4. **Charge-through rule** — the stated rule for how
   unrealised commitments are costed back to the forecasting
   team.
5. **Review cadence hook** — the quarterly review from
   exercise 2 is the forcing function for refreshing the
   matrix and posture; the hook is explicit.
6. **Governance hook** — material commitment decisions are
   captured as ADRs via the governance system from
   `mod-301/exercise-4`.

## 3. Validation steps

1. Open the coverage matrix. Confirm each workload class has
   a target coverage and that targets fall *below* the TCO
   forecast baseline (the module rationale's over-commitment
   failure).
2. Confirm the posture document names term, scope, buffer,
   refresh cadence, and exit stance.
3. Confirm compute-family-flexible instruments are the
   default where the workload mix is evolving — reservation
   lock-in on a volatile mix is a failure signal.
4. Open the allocation rules. Confirm showback flows into the
   dashboards from exercise 1 and that charge-through is
   named for unrealised commitments.
5. Confirm the refresh cadence ties to the quarterly review
   from exercise 2.
6. Confirm commitment decisions trigger ADRs when material.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Coverage matrix | Per-workload-class targets below forecast baseline | Single target applied globally, or 100% coverage |
| Instrument choice | Flexible instruments default; narrow only with confidence | Narrow reservations by default |
| Buffer | Named forecast-uncertainty discount | No buffer; commits to forecast baseline |
| Refresh cadence | Tied to quarterly review | Set-and-forget |
| Allocation | Blended-rate showback into exercise-1 dashboards | Savings hidden centrally |
| Charge-through | Named rule for unrealised commitments | None; forecaster carries no cost |
| Exit stance | Named path for under-used commitments | None |
| AI/ML framing | Marginal-cost shift tied to NIST AI RMF Manage/Measure | Cost treated as independent of model governance |
| Form | Versioned Markdown + structured matrix | PDF slide |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
section:

1. **Over-commitment to reservations.** Pay for unused
   capacity — explicitly flagged by the module rationale. The
   coverage matrix must sit below the forecast baseline, not
   at it.
2. **Narrow reservations on a volatile mix.** ML workload
   shape evolves; locking in narrow instrument families
   trades a small discount for large stranded commitment.
3. **Savings socialized, costs privatized.** Without
   showback, the saving is invisible to the workloads that
   generate it; without charge-through, forecasters pay no
   price for over-estimating.
4. **No refresh cadence.** Reservations drift from the
   forecast; without a quarterly re-sizing hook, the posture
   decays within one planning horizon.
5. **ML economics ignored.** The commitment posture must
   recognise that lowering marginal cost changes model-
   retention decisions; this is a NIST AI RMF Manage/Measure
   interface, not a pure procurement decision.

## 6. References

- FinOps Foundation — FinOps Framework overview —
  <https://www.finops.org/framework/>
- FinOps Foundation — *Rate Optimization* capability
  (commitment-based discount strategy) —
  <https://www.finops.org/framework/capabilities/rate-optimization/>
- FinOps Foundation — *Forecasting* capability —
  <https://www.finops.org/framework/capabilities/forecasting/>
- AWS — Savings Plans user guide —
  <https://docs.aws.amazon.com/savingsplans/latest/userguide/what-is-savings-plans.html>
- Google Cloud — Committed use discounts —
  <https://cloud.google.com/docs/cuds>
- Microsoft Azure — Reservation recommendations and
  management —
  <https://learn.microsoft.com/azure/cost-management-billing/reservations/save-compute-costs-reservations>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
