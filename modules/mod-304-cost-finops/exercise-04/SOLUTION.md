# SOLUTION — Exercise 04: Cost-Anomaly Detection (Optimization Application)

Reference for the matching learning exercise
[`lessons/mod-304-cost-finops/exercises/exercise-4.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-4.md).
See also the module-level rationale in [`../SOLUTION.md`](../SOLUTION.md).

## 1. Solution overview

The learning prompt is a generic "apply optimization to a real
architecture problem." At the architect tier — per the module
SOLUTION — the optimization deliverable for this exercise is **cost-
anomaly detection with on-call escalation**: the control system that
catches runaway spend before it accumulates.

A complete submission produces:

1. A **detection architecture** that runs daily on per-service spend.
2. An **escalation path** through PagerDuty (or equivalent) for
   runaway costs.
3. A **rules layer** that augments cloud-native anomaly detection
   with ML-workload-specific rules.
4. A **stakeholder deck** that frames the system as cost on-call —
   the same operational rigor as production on-call.

## 2. Worked answer

### 2a. Detection architecture (the module SOLUTION's reference)

```
attribution pipeline (ex 01) ──> daily per-service spend
                                            │
                                            ├── cloud-native anomaly detection
                                            │   (AWS Cost Anomaly Detection /
                                            │    GCP equivalent)
                                            │
                                            └── ML-workload custom rules
                                                    │
                                                    └── PagerDuty escalation
```

The system runs on the per-service spend produced by exercise 01's
attribution pipeline. The architect-tier point is that anomaly
detection is *coupled* to attribution — you cannot detect a runaway
in a service whose spend is not attributed.

### 2b. ML-workload custom rules

Cloud-native detection alone misses ML-specific failure modes. The
custom rules layer adds patterns the architect can predict:

- Training-job spend spike beyond a configured per-run ceiling.
- Inference autoscaling that didn't scale back down.
- A single experiment GPU left allocated overnight or over a
  weekend.
- Per-model spend exceeding the model owner's stated budget.

These rules use the `model-name` and `workload-type` tags from
exercise 01 — another point of coupling.

### 2c. Escalation path

The module SOLUTION names PagerDuty as the escalation surface. The
architect-tier point is that there is *someone on-call* — a real
rotation, not a shared mailbox. The rotation can live with the FinOps
champion of the affected team (exercise 02) or with central FinOps
during the champion's off-hours.

### 2d. Trade-off the architect must own

The module SOLUTION lists "cost anomaly detection has false-
positives" as an explicitly accepted trade-off. The submission must
acknowledge this and describe how false-positives are tuned
*without* silencing the rotation — typically by threshold-tuning
after each false page, not by disabling rules.

## 3. Validation steps

- [ ] Detection runs daily on per-service spend produced by the
      attribution pipeline.
- [ ] Cloud-native anomaly detection + custom ML rules are both
      named.
- [ ] Custom rules reference the ML-specific tags from exercise 01.
- [ ] PagerDuty (or equivalent) escalation is wired to a named
      rotation.
- [ ] False-positive trade-off is acknowledged with a tuning
      process — not by silencing.

## 4. Rubric

| Criterion (weight) | Excellent | Adequate | Insufficient |
|---|---|---|---|
| Architecture quality (40%) | Daily detection on attribution feed; cloud-native + ML custom rules; on-call rotation defined. | Detection present but coupling to attribution is implicit, or escalation goes to a mailbox. | Periodic manual review treated as detection; no on-call. |
| Documentation (30%) | Architecture diagram shows feed → detection → escalation; runbook for first response. | Diagram only, no runbook. | Concept described without diagram. |
| Strategic thinking (20%) | False-positive trade-off named with a tuning process. | Trade-off mentioned. | "We'll just tune until there are no false alarms." |
| Communication (10%) | Deck pitches cost-on-call as a production-rigor decision, not a finance ask. | Deck frames it as cost-savings only. | Architect notes only. |

## 5. Common mistakes

From the module SOLUTION:

1. **No on-call for cost anomalies.** The named failure mode:
   "a $50k/day runaway runs for a week." This is the central
   insight of the exercise; a submission without an on-call
   rotation fails the rubric's strategic-thinking band.
2. Detection on totals, not per-service. A 5% spike on a $1M base
   hides a 200% spike on a $25k service.
3. Custom rules that ignore the ML-specific tags from exercise 01
   — re-deriving model identity from log scraping instead.
4. Silencing rules to suppress false-positives instead of tuning
   thresholds.

## 6. References

- Learning exercise: [`lessons/mod-304-cost-finops/exercises/exercise-4.md`](https://github.com/ai-infra-curriculum/ai-infra-architect-learning/blob/main/lessons/mod-304-cost-finops/exercises/exercise-4.md)
- Module-level architect-tier framing: [`../SOLUTION.md`](../SOLUTION.md) §"Cost-anomaly detection (exercise 04)"
- Coupled components in this module:
  - [`../exercise-01/SOLUTION.md`](../exercise-01/SOLUTION.md) — supplies the per-service spend feed and the ML tags.
  - [`../exercise-02/SOLUTION.md`](../exercise-02/SOLUTION.md) — supplies the on-call rotation owner.

<!-- needs-research: cite AWS Cost Anomaly Detection and the GCP / Azure equivalents (product documentation) so the cloud-native detection references resolve to verified links. -->
