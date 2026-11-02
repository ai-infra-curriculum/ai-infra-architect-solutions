# SOLUTION — Exercise 4: Optimization Application (Cost Anomaly Detection)

> Pairs with
> `ai-infra-architect-learning/lessons/mod-304-cost-finops/exercises/exercise-4.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **cost-anomaly
detection** deliverable: *daily anomaly detection on per-
service spend with PagerDuty escalation for runaway costs. The
reference uses cloud-native anomaly detection (AWS Cost Anomaly
Detection / GCP equivalent) augmented with custom rules for ML
workloads.* The architect-tier answer is the detection surface
plus the escalation that makes a $50k/day runaway visible on
the same day it starts, not a week later.

The module rationale lists *no on-call for cost anomalies: a
$50k/day runaway runs for a week* as a grader-flagged failure.
Exercise 4 is where the organization closes that gap: cloud-
native detectors cover baseline anomalies, custom rules cover
the ML-specific shapes those detectors miss, and PagerDuty
carries the pageable signal into an on-call rotation that
owns cost response.

## 2. Worked answer

A passing anomaly-detection submission produces four linked
artefacts:

1. **Detection coverage map** — which detector (cloud-native
   or custom) covers which workload class and signal type.
2. **Custom-rule catalogue** — the ML-specific detection
   rules the cloud-native service does not cover natively.
3. **Escalation policy** — the PagerDuty routing, severity
   thresholds, and runbook pointer.
4. **False-positive management plan** — the stated process
   for tuning rules so the on-call surface stays actionable.

### Detection coverage map

The map pairs the attribution surface from exercise 1 with the
detection instruments:

| Signal | Source | Instrument | Threshold shape |
| --- | --- | --- | --- |
| Service-level daily spend | Attribution pipeline (exercise 1) | Cloud-native anomaly detection | Dynamic (statistical) |
| Workload-type daily spend (ML) | Attribution pipeline | Custom rule | Dynamic + rate-of-change |
| Model-name daily spend | Attribution pipeline | Custom rule | Dynamic + per-model guardrail |
| Account / project-level spend | Billing export | Cloud-native anomaly detection | Dynamic |
| Reservation under-utilisation | Attribution pipeline | Custom rule | Static threshold with trend window |

Dynamic thresholds are the default so seasonal variation does
not generate alerts; static thresholds are reserved for
guardrails whose violation is unambiguous.

### Custom-rule catalogue

The module rationale notes custom rules exist because cloud-
native services do not model ML workload shapes natively. The
catalogue names the rules the organization operates:

- **Per-model-name daily budget breach** — detect spend on a
  `model-name` tag exceeding a stated budget, scoped by
  environment.
- **Inference request-cost drift** — detect per-request cost
  rising above baseline, often a signal of model-serving
  misconfiguration or request-shape shift (long inputs,
  prompt stuffing).
- **Training job overrun** — detect a scheduled training job
  exceeding its planned footprint or duration.
- **Egress spike** — detect data egress charges rising
  outside the baseline for a given workload-type, often a
  signal of an un-tuned replication or exfiltration pattern.
- **Reservation under-utilisation** — detect blended-rate
  savings below the exercise-3 coverage target, signalling a
  stranded commitment.

Each rule names its signal, threshold shape, data source
(attribution pipeline tag or billing-export field), and
owning champion from exercise 2.

### Escalation policy

The module rationale specifies PagerDuty for runaway costs.
The policy names:

- **Severity thresholds** — e.g., SEV-1 for predicted
  monthly impact above a stated figure, SEV-2 for sustained
  anomalies above baseline, SEV-3 for informational.
- **On-call rotation** — the FinOps-adjacent on-call that
  carries the signal; the central FinOps team (exercise 2)
  owns the rotation.
- **Runbook pointer** — each alert links to a runbook with
  the triage steps (confirm the signal, identify the
  workload, contact the champion, apply or request
  mitigation).
- **Business-hours vs. 24/7 routing** — the module rationale
  motivates 24/7 for runaway costs; informational alerts can
  stay business-hours.
- **Automatic suppression windows** — planned events (model
  releases, training campaigns) that would otherwise trigger
  false positives are suppressed through a stated workflow.

### False-positive management plan

The module trade-offs section notes **cost anomaly detection
has false-positives**. A passing submission names:

- **Weekly alert review** at the monthly champion huddle
  (exercise 2) rolled up by rule.
- **Suppression and tuning workflow** — champions can
  propose rule tuning; central FinOps approves and versions
  the rule.
- **Alert-to-action ratio target** — a stated minimum
  fraction of alerts that produce an action; below the
  target, the rule is tuned, not disabled.
- **Known-planned-event registry** — upcoming events that
  would predictably trigger alerts, pre-registered so the
  on-call sees context rather than noise.

### AI/ML risk anchoring

Cost anomalies are a security signal. OWASP ML Top 10 and
MITRE ATLAS catalogue abuse patterns that drive cost —
denial-of-wallet via inference flooding, model theft via
exhaustive querying, data exfiltration via egress bursts. The
custom-rule catalogue covers those shapes explicitly, and the
escalation path carries into the security surface when the
signal matches an adversary technique rather than a benign
spike. The NIST AI RMF *Measure* function uses the same
dashboards; a cost anomaly on `model-name` can be the first
visible symptom of model-serving abuse.

### Decision rationale

Cloud-native detection plus a bounded custom-rule catalogue
with PagerDuty escalation is the right altitude because the
module rationale wants same-day visibility on runaway spend
and names cloud-native detection as the base layer. Trade-offs
the learner should accept:

- **False positives are inevitable.** The management plan is
  the mitigation, not detection pessimism.
- **Custom rules are a tax.** Each custom rule carries
  tuning cost; the catalogue is kept small on purpose.
- **On-call for cost is non-negotiable.** Without an on-call,
  the module rationale's $50k/day failure is the default.

### What stays out of scope

The architect-tier answer **does not** write workload-level
optimization playbooks (exercise 5), rebuild the attribution
pipeline (exercise 1), restructure the FinOps team (exercise
2), or revise the reservation posture (exercise 3). The goal
here is the detection and escalation surface.

## Implementation

Implementation of the anomaly-detection artefacts lands as
versioned architecture assets:

1. **Coverage map document** — Markdown in the architecture
   repository tying each signal to a detector and threshold
   shape.
2. **Custom-rule catalogue** — one entry per rule with
   signal, data source, threshold, owning champion, and
   runbook link; versioned in the architecture repository.
3. **Escalation policy** — PagerDuty service and routing
   configuration-as-code, severity thresholds, and runbook
   pointer.
4. **Suppression workflow** — the stated workflow for
   registering planned events and tuning noisy rules.
5. **Alert-to-action metric** — the measurement that keeps
   the on-call surface honest, reviewed at the monthly
   champion huddle.
6. **Governance hook** — new or modified rules require an
   ADR via the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the coverage map. Confirm cloud-native detection
   covers service / account signals and that custom rules
   cover the ML shapes the native service misses.
2. Open the custom-rule catalogue. Confirm per-`model-name`
   budget breaches, inference request-cost drift, and
   training-job overrun are present.
3. Open the escalation policy. Confirm PagerDuty routing is
   named with severity thresholds, 24/7 posture for runaway
   costs, and a runbook pointer per alert.
4. Confirm the suppression workflow exists; without it,
   false positives either disable rules or burn out the
   on-call.
5. Confirm the alert-to-action metric is defined and
   reviewed at the monthly champion huddle (exercise 2).
6. Confirm reservation under-utilisation (exercise 3) is one
   of the detection signals, closing the loop with the
   commitment posture.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Native detection coverage | Service / account signals covered | Only custom rules, native service unused |
| Custom rules | ML shapes (model, inference drift, training overrun, egress) named | Generic rules; no ML specificity |
| Escalation | PagerDuty with severity + runbook pointer | Email alias only |
| On-call | 24/7 rotation for runaway signals | Business-hours only |
| Suppression | Planned-event workflow and rule-tuning path | None |
| Alert-to-action metric | Named and reviewed | Alerts without feedback loop |
| Reservation feedback | Under-utilisation surfaced here | Blind to commitment waste |
| AI/ML risk framing | Abuse patterns from OWASP ML / MITRE ATLAS mapped to rules | Cost treated as pure finance signal |
| Form | Versioned Markdown + config-as-code | Screenshots of a dashboard |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
section:

1. **No on-call for cost anomalies.** The $50k/day runaway is
   the module rationale's explicit worst case; the on-call
   rotation and PagerDuty routing exist to prevent it.
2. **Static thresholds everywhere.** Static thresholds in a
   seasonal environment produce either runaway misses (too
   high) or alert fatigue (too low); the default is dynamic.
3. **Custom rules without owners.** A rule without a named
   champion decays within a quarter; the catalogue entry
   must name the owner from exercise 2.
4. **No suppression workflow.** The on-call either disables
   rules under pressure or burns out; the suppression
   workflow is the alternative.
5. **Abuse patterns ignored.** The module targets AI/ML
   infrastructure; cost anomalies that are abuse signals
   (denial-of-wallet, exfiltration) must cross into the
   security surface, not stay inside FinOps.

## 6. References

- FinOps Foundation — FinOps Framework overview —
  <https://www.finops.org/framework/>
- FinOps Foundation — *Anomaly Management* capability —
  <https://www.finops.org/framework/capabilities/anomaly-management/>
- AWS — Cost Anomaly Detection (SNS-routed alerts and
  monitor types) —
  <https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html>
- Google Cloud — Budgets and anomaly detection
  (Pub/Sub notifications) —
  <https://cloud.google.com/billing/docs/how-to/budgets-programmatic-notifications>
- Microsoft Azure — Create anomaly alerts in Cost
  Management —
  <https://learn.microsoft.com/azure/cost-management-billing/understand/analyze-unexpected-charges>
- OWASP — Denial-of-Wallet / unrestricted resource
  consumption (API Security Top 10 — API4:2023) —
  <https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/>
- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
