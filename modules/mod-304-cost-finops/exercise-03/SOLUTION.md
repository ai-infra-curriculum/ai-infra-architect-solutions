# SOLUTION — Exercise 03: Reserved-Capacity Strategy (Cost Allocation Application)

Reference for the matching learning exercise
[`lessons/mod-304-cost-finops/exercises/exercise-3.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-3.md).
See also the module-level rationale in [`../SOLUTION.md`](../SOLUTION.md).

## 1. Solution overview

The learning prompt is a generic "apply cost-allocation concepts to a
real architecture problem." At the architect tier, the deliverable is
the one the module SOLUTION names for exercise 03: a **reserved-
capacity strategy** — which commitment vehicle to use (reserved
instances vs. savings plans vs. committed-use discounts), what
coverage % to target, and how to handle forecast uncertainty.

A complete submission produces:

1. A **decision document** that selects a commitment vehicle and
   defends the choice.
2. A **coverage-target rationale** stated as a range (e.g., "65–75%
   of baseline") with the reasoning behind the range.
3. A **forecast-uncertainty playbook** — what happens when actual
   usage diverges from the commitment.
4. A **stakeholder deck** that frames the commitment as the
   forecast bet it actually is.

## 2. Worked answer

### 2a. Choosing a commitment vehicle

The module SOLUTION lists three options and frames the choice as a
forecast bet. The architect-tier answer is to match the vehicle to
the *kind* of workload, not pick one globally:

| Workload shape | Vehicle | Why |
|---|---|---|
| Stable baseline, single instance family | Reserved instances / committed-use | Highest discount, narrowest fit. |
| Stable baseline, mixed instance families or regions | Savings plan / flexible commitment | Lower discount, survives instance-family changes. |
| Bursty or unpredictable | On-demand + spot | Don't reserve uncertainty. |

### 2b. Coverage target

The coverage % must be stated as a **range tied to forecast
confidence**, not a single fixed number. The reasoning a grader
looks for: too low a number and the operational overhead of
managing reservations outweighs the discount; too high a number
and the architect is paying for unused capacity — the module
SOLUTION's named failure mode for this exercise.

A submission that picks a single fixed number ("we'll cover 80%")
without a range or a defense of why that number survives forecast
error has not internalized the forecast-uncertainty point.

<!-- needs-research: cite an industry-benchmark coverage % range (FinOps Foundation / cloud provider best-practice guidance) so this section can name a defensible target rather than only the reasoning structure. -->



### 2c. Forecast-uncertainty playbook

The forecast is going to be wrong. The playbook names what happens
when it is:

- **Quarterly reforecast** at the FinOps review meeting (exercise 02
  ties in here).
- **Floor and ceiling** on coverage — if utilization on the
  commitment falls below X% for two consecutive months, reduce
  coverage at the next renewal. If on-demand spend on covered
  workloads is consistently > Y%, increase coverage.
- **Vehicle-specific exit cost** — reservations are harder to
  unwind than savings plans; that asymmetry belongs in the
  decision rationale.

### 2d. Stakeholder framing

The slide deck (per the learning file's Task 4) should lead with the
forecast bet, not the discount %. Engineering leadership signs off
on the bet; finance signs off on the cash commitment.

## 3. Validation steps

- [ ] Vehicle choice is workload-shape-driven, not one-size-fits-all.
- [ ] Coverage target stated as a range with reasoning.
- [ ] Forecast-uncertainty playbook names the reforecast cadence,
      adjustment thresholds, and exit cost asymmetry.
- [ ] Spot / on-demand role for bursty workloads is acknowledged.
- [ ] Trade-off (reserved capacity is a forecast bet) is the
      headline of the rationale, not a footnote.

## 4. Rubric

| Criterion (weight) | Excellent | Adequate | Insufficient |
|---|---|---|---|
| Architecture quality (40%) | Vehicle matched to workload shape; coverage as range; playbook addresses reforecast, adjustment thresholds, and exit cost. | Vehicle and coverage chosen with some reasoning; playbook incomplete. | Single vehicle applied globally; single fixed coverage %; no playbook. |
| Documentation (30%) | Decision document defends the choice for each workload shape; playbook is operational, not aspirational. | Document explains the choice but doesn't tie it to operations. | Narrative without decision criteria. |
| Strategic thinking (20%) | "Reserved capacity is a forecast bet" is treated as the central insight. | Forecast uncertainty mentioned but not central. | Discount % is the headline. |
| Communication (10%) | Deck separates engineering's bet from finance's commitment. | Deck combines both into a single ask. | Deck presents only the discount. |

## 5. Common mistakes

From the module SOLUTION's "common mistakes graders see":

1. **Over-commitment to reservations.** Paying for unused capacity.
   This is the named failure mode for this exercise.
2. Picking one vehicle (reservations) for every workload, including
   bursty ones that should be on spot.
3. Treating the forecast as if it were a plan — no reforecast
   cadence, no adjustment thresholds.
4. Hiding the cash-commitment ask from finance behind the discount
   headline.

## 6. References

- Learning exercise: [`lessons/mod-304-cost-finops/exercises/exercise-3.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-3.md)
- Module-level architect-tier framing: [`../SOLUTION.md`](../SOLUTION.md) §"Reserved-capacity strategy (exercise 03)"
- Companion in this module: [`../exercise-02/SOLUTION.md`](../exercise-02/SOLUTION.md) — the quarterly review is where the reforecast happens.

<!-- needs-research: cite the AWS Savings Plans, AWS Reserved Instances, and GCP Committed Use Discounts product documentation once vetted links are available. -->
