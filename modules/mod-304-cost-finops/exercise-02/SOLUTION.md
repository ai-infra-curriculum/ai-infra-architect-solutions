# SOLUTION — Exercise 02: FinOps Team Structure (TCO Analysis Application)

Reference for the matching learning exercise
[`lessons/mod-304-cost-finops/exercises/exercise-2.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-2.md).
See also the module-level rationale in [`../SOLUTION.md`](../SOLUTION.md).

## 1. Solution overview

The learning prompt is a generic "apply TCO analysis to a real
architecture problem." At the architect tier, the deliverable behind
that prompt — per the module SOLUTION — is the **operating model that
makes TCO visibility durable**, not a one-shot spreadsheet. That
operating model is the FinOps team structure.

A complete submission produces:

1. An **org-chart sketch** showing the central FinOps team, the
   embedded FinOps champions per platform team, and the reporting
   relationship to engineering leadership.
2. A **RACI** for the recurring activities (tooling ownership,
   anomaly response, quarterly review).
3. A **cadence document** that names the quarterly review meeting,
   its inputs, and the decisions it produces.
4. A **stakeholder deck** that justifies the org-design ask in
   business terms.

## 2. Worked answer

### 2a. The three-part structure (from the module SOLUTION)

The module SOLUTION defines the reference structure verbatim:

- **Central FinOps team** for tooling, dashboards, and anomaly
  detection. Owns the attribution pipeline from exercise 01 and the
  anomaly system from exercise 04.
- **Embedded FinOps champions per platform team.** Part-time role
  (~10–20% allocation) held by someone already on the team —
  typically a senior engineer or tech lead.
- **Quarterly review cadence with engineering leadership.** The
  forum where TCO trends turn into decisions about reservations,
  workload retirements, and platform investments.

### 2b. RACI for the recurring activities

| Activity | Central FinOps | Embedded champion | Engineering leadership |
|---|---|---|---|
| Maintain tagging policy & enforcement | R/A | C | I |
| Run attribution pipeline & dashboards | R/A | I | I |
| Investigate cost anomalies | A | R | I |
| Drive workload-level optimization | C | R/A | I |
| Quarterly TCO review meeting | R | C | A |
| Reservation-coverage decisions | R | C | A |

Leadership is Accountable for the reservation decision because it is
the place where forecast-uncertainty risk lives. Central FinOps is
Responsible for surfacing the data and the recommendation.

### 2c. Cadence document (quarterly review)

Inputs the meeting expects (produced by central FinOps):

- TCO trend per business unit, quarter over quarter.
- Per-workload cost drivers — what grew, what shrank, why.
- Reservation coverage % and forecast variance.
- Open anomalies (count + dollars).

Decisions the meeting produces:

- Reservation-coverage target for the next quarter.
- Any workloads slated for retirement or right-sizing.
- Any new champion appointments / replacements.

### 2d. Stakeholder framing

The slide deck (per the learning file's Task 4) should sell the
operating model — *why a central team plus embedded champions* —
not the architecture. The argument is the one the module SOLUTION
makes implicitly: a central team without champions produces
dashboards no one looks at; champions without a central team produce
inconsistent practice across platforms.

## 3. Validation steps

- [ ] Three roles named: central team, embedded champions, leadership
      review cadence.
- [ ] Champion allocation is bounded (part-time) and located on
      existing teams, not a new headcount per platform.
- [ ] RACI shows leadership Accountable for reservation decisions —
      not central FinOps.
- [ ] Quarterly cadence has named inputs *and* named decisions.
- [ ] Trade-off (cost of running a central team vs. cost of
      uncoordinated optimization) is addressed.

## 4. Rubric

| Criterion (weight) | Excellent | Adequate | Insufficient |
|---|---|---|---|
| Architecture quality (40%) | Three-part structure, RACI with leadership Accountable on reservation decisions, quarterly cadence with named decisions. | Structure present, but RACI is vague or cadence has no decisions named. | Single central team with no champions, or champions with no central function. |
| Documentation (30%) | Org-chart sketch + RACI + cadence document each readable on their own. | Structure described in prose with no diagram or RACI. | Narrative only. |
| Strategic thinking (20%) | The "central + embedded" trade-off is named and defended. | Structure asserted without justification. | Structure mimicked without understanding why. |
| Communication (10%) | Deck pitches the operating model to engineering leadership in their language (headcount, decisions, KPIs). | Deck describes the structure. | Architect notes only. |

## 5. Common mistakes

1. **Central FinOps team owning everything.** When central owns
   optimization on every platform, no one platform actually
   optimizes. The module SOLUTION places optimization with the
   embedded champion for a reason.
2. **Champion as a full-time role.** Drives headcount cost up and
   isolates the champion from the team they're meant to influence.
3. **No on-call for cost anomalies.** Per the module SOLUTION's
   common mistakes: "a $50k/day runaway runs for a week." Anomaly
   response belongs in the RACI.
4. **Quarterly review with no decisions.** A meeting that produces
   only dashboards is not the operating model the architect tier is
   asked for.

## 6. References

- Learning exercise: [`lessons/mod-304-cost-finops/exercises/exercise-2.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-2.md)
- Module-level architect-tier framing: [`../SOLUTION.md`](../SOLUTION.md) §"FinOps team structure (exercise 02)"
- Related curriculum: `architect/projects/project-301-enterprise-mlops` (per module SOLUTION §"Related curriculum touchpoints").

<!-- needs-research: cite the FinOps Foundation's "FinOps Framework" personas / capabilities documentation for the central-team + embedded-champion model once a vetted link is available. -->
