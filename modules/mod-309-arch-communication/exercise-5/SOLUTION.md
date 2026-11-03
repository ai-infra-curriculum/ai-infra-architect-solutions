# SOLUTION — Exercise 5: Stakeholder Management Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-309-arch-communication/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **pre-read packet
for ARB** deliverable — *"distributed 48 hours before the
meeting. Includes context, proposal, alternatives,
recommendation, supporting analysis. ARB members come
prepared."* — to the concrete proposal being carried through
this module. The architect-tier answer is a packet that
operationalizes the stakeholder map from
[`../exercise-4/SOLUTION.md`](../exercise-4/SOLUTION.md): it
distributes the right artifact to each voting member in advance,
executes the pre-wire conversations the map scheduled, and makes
the meeting itself a ratification step rather than a reveal.

The module rationale pins "pre-reads sent the morning of" as a
top grader-visible failure. This exercise is where the learner
closes the loop on the module by assembling the pre-read packet
and the ongoing stakeholder-engagement plan that keeps the
decision landed after the ARB meeting ends.

## 2. Worked answer

A passing pre-read + ongoing-engagement submission produces one
versioned packet with five named sections, mirroring the module
rationale's pre-read fields and the local stakeholder-
communication kit:

1. **Context** — one page restating the problem, the current
   state, and why now. Draws from the executive memo
   ([`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md))
   without copying it verbatim; ARB members read deeper than
   the executive sponsor.
2. **Proposal** — the specific decision and the plan,
   referencing the ADR
   ([`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md))
   as the authoritative record.
3. **Alternatives** — a side-by-side table of alternatives with
   trade-offs and the reason each was not chosen; depth lives
   in the ADR.
4. **Recommendation** — the architect's recommendation,
   explicitly separated from the proposal, with the asks of
   the ARB (approve / defer / reject, and any conditions).
5. **Supporting analysis** — the diagram set
   ([`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md)),
   the cost model, the risk register from the ADR, and any
   proof-of-concept evidence.

### 48-hour distribution window

The module rationale is explicit: 48 hours before the meeting.
A packet distributed the morning of produces an unprepared ARB;
a packet distributed a week in advance is forgotten by the
meeting. 48 hours is the committed window, and the submission
names it as the distribution rule, not an aspiration.

### Pre-wire execution

The stakeholder map from Exercise 4 scheduled 1:1 pre-wire
conversations with voting members. This exercise executes them:
each voting member receives a 1:1 before the formal distribution
or shortly after, with the pre-wire owner (usually the
proposal's architect) walking the member through the proposal,
hearing objections, and either addressing them inline or
flagging them for the meeting. The module rationale's framing —
*"ARB members come prepared"* — is the test: a voting member
who first sees the proposal in the meeting is a pre-wire that
did not happen.

### Ongoing engagement plan

Stakeholder management does not end at the ARB meeting. The
packet includes an ongoing-engagement plan that commits:

- **Status cadence** — a committed update rhythm (not status
  theater: material changes only, per the module rationale and
  the local stakeholder-communication guide).
- **Decision log** — a running log of material decisions made
  after the ARB meeting, each linked to an ADR amendment or new
  ADR via Exercise 3's governance seam.
- **Escalation triggers** — the conditions under which the ARB
  is re-engaged (budget overrun > N%, timeline slip > M months,
  risk materializing, scope change).
- **Deprecation path** — when the ARB-approved decision is
  itself superseded, the pre-read for the superseding decision
  references this packet.

The ongoing engagement plan is the module's answer to decisions
that are approved and then quietly drift; the module rationale's
*diagrams age fast* trade-off generalizes to "approvals age
fast" and demands the same governance.

### Format and distribution

The packet is Markdown in the architecture repository with
rendered artifacts linked. Distribution is via the channel the
ARB has committed to (not ad-hoc email): the stakeholder
map named it; this exercise uses it. A packet sent through a
one-off channel bypasses the review record and is a fail signal.

### AI/ML-specific considerations

When the proposal is an AI/ML platform, the pre-read packet
surfaces the governance content the AI-adjacent members of the
ARB expect:

- **NIST AI Risk Management Framework** — the recommendation
  section explicitly names which *Govern* / *Map* / *Measure* /
  *Manage* functions the decision commits to; the supporting
  analysis section includes the AI RMF profile excerpt that
  informed the decision.
- **OWASP Machine Learning Security Top 10** — the alternatives
  table carries a risk column that includes relevant OWASP ML
  Top 10 categories per alternative; silent omission on an
  AI/ML proposal is a fail signal.
- **MITRE ATLAS** — the supporting analysis section links the
  threat model from the security review board's pre-wire, with
  the applicable ATLAS techniques enumerated.

The pre-read packet does not teach these frameworks; it cites
them, so ARB members with the right expertise can audit the
proposal against them.

### Decision rationale

The pre-read packet plus ongoing-engagement plan is the right
artifact because the module rationale names the ARB pre-read as
the final committed deliverable and because the stakeholder-
communication guide names the pre-wire + distribute + ratify
pattern as the one that produces considered decisions. Trade-
offs the submission should explicitly accept, mirroring the
module rationale:

- *Multiple-altitude documents mean producing the same content
  in different shapes.* The pre-read is the ARB altitude; the
  executive memo (Exercise 1) is the sponsor altitude; the ADR
  (Exercise 3) is the archival altitude. All three exist.
- *Pre-reads sent the morning of fail.* The 48-hour rule is
  non-negotiable; sliding it is the failure the module names.
- *Status theater degrades signal.* The ongoing-engagement plan
  commits to material-change updates, not calendar-driven
  noise.

### What stays out of scope

The architect-tier answer **does not** rewrite the executive
memo (that is Exercise 1), rebuild the diagram set (Exercise 2),
duplicate the ADR (Exercise 3), or re-derive the stakeholder map
(Exercise 4). It links to each of them and uses them to run the
review.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names the pre-read deliverable as
*"distributed 48 hours before the meeting. Includes context,
proposal, alternatives, recommendation, supporting analysis.
ARB members come prepared."* The learner-visible title for this
exercise is "Stakeholder Management Application"; because the
task briefing uses the same title for Exercise 4, this file
carries the *execution* half of stakeholder management (ARB
pre-read packet, pre-wire execution, ongoing engagement) and
defers the *mapping* half (audience table, decision-role
classification, format binding) to Exercise 4.

## Implementation

Implementation of the pre-read packet and the ongoing-engagement
plan lands as versioned documentation and committed cadence,
not as a running system:

1. **Pre-read packet** — Markdown in the architecture
   repository with the five sections above (Context, Proposal,
   Alternatives, Recommendation, Supporting analysis). Target
   length is enough to brief but not enough to re-read: the
   ADR is the deep source.
2. **Distribution rule** — 48 hours before the ARB meeting,
   via the committed ARB channel. The distribution event is
   logged.
3. **Pre-wire log** — a short log naming each voting member,
   the pre-wire date, the surfaced concerns, and the resolution
   (addressed inline / flagged for meeting / unresolved).
4. **Ongoing-engagement plan** — a Markdown section (or sibling
   file) committing status cadence (material changes only),
   decision log location, escalation triggers, and deprecation
   path.
5. **Cross-links** — the packet links to the executive memo
   (Exercise 1), the C4 set (Exercise 2), the ADR (Exercise 3),
   and the stakeholder map (Exercise 4). Missing links are
   fail signals.
6. **AI/ML governance block** — on AI/ML platforms, the
   recommendation and alternatives sections name the NIST AI
   RMF functions, OWASP ML Top 10 categories, and MITRE ATLAS
   techniques that are in play, with `research-pending` markers
   where claims cannot be verified at write time.
7. **Governance hook** — the pre-read goes through pull
   request review by the proposal owner's lead and the ARB
   secretariat; ARB-ratified changes update the ADR via the
   governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the pre-read packet. Confirm the five sections
   (Context, Proposal, Alternatives, Recommendation, Supporting
   analysis) are each present and populated.
2. Confirm the Recommendation section explicitly names the ask
   of the ARB (approve / defer / reject, with any conditions).
3. Confirm the distribution rule is 48 hours before the ARB
   meeting, logged as an event. A packet distributed the
   morning of is a fail signal.
4. Confirm the pre-wire log exists and names each voting
   member, the pre-wire date, surfaced concerns, and
   resolution.
5. Confirm the ongoing-engagement plan commits status cadence,
   decision log location, escalation triggers, and deprecation
   path.
6. Confirm cross-links to the executive memo, C4 set, ADR, and
   stakeholder map are all present.
7. For an AI/ML platform, confirm the recommendation and
   alternatives sections name the applicable NIST AI RMF
   functions, OWASP ML Top 10 categories, and MITRE ATLAS
   techniques, with `research-pending` markers where applicable.
8. Confirm the packet references the ADR as the authoritative
   decision record rather than restating the ADR in full; a
   pre-read that duplicates the ADR is a maintenance liability.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Section completeness | Context / Proposal / Alternatives / Recommendation / Supporting analysis all present | Any missing |
| Ask clarity | Recommendation section names approve / defer / reject with conditions | Ambiguous ask |
| 48-hour rule | Distribution logged ≥ 48 hours before the meeting | Distributed on the day |
| Pre-wire log | Owner, date, concerns, resolution per voting member | Pre-wire not recorded |
| Ongoing-engagement plan | Status cadence, decision log, escalation, deprecation declared | Any missing |
| Cross-links | Memo / diagrams / ADR / stakeholder map all linked | Any missing |
| Framework alignment | NIST AI RMF / OWASP ML Top 10 / MITRE ATLAS surfaced when AI/ML | Framework names absent on applicable proposal |
| ADR usage | Pre-read links to ADR as source | Pre-read inlines decision text, drifting from ADR |
| Research markers | `research-pending` for unverified framework claims | Guessed claims presented as fact |
| Form | Versioned Markdown via PR | Ad-hoc email attachment |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the pre-read + ongoing-engagement deliverable:

1. **Pre-reads sent the morning of.** The module rationale calls
   this out directly. A packet distributed less than 48 hours
   before the meeting predicts an unprepared ARB and a reactive
   decision.
2. **Pre-wire skipped.** Taking a proposal to the ARB without
   1:1s with voting members produces objection cascades in the
   meeting. The stakeholder-communication guide names pre-wire
   as the pattern; the pre-wire log is the evidence.
3. **Ambiguous ask.** A Recommendation section that does not
   explicitly state approve / defer / reject with conditions
   gives the ARB nothing to decide against. The module
   rationale's "burying the recommendation" failure applies to
   pre-reads as well.
4. **Pre-read duplicates the ADR.** Copying the ADR into the
   pre-read creates two copies of the decision that will drift.
   The pre-read links to the ADR; the ADR is the source.
5. **No ongoing-engagement plan.** The decision is approved and
   then quietly drifts; six months later nobody can tell whether
   the ARB conditions were honored. The ongoing-engagement plan
   is the fix.
6. **Status theater.** A weekly status update that re-states
   the project plan without new information teaches
   stakeholders to ignore the cadence. The module rationale and
   the stakeholder-communication guide both treat this as a
   failure.
7. **AI/ML governance invisible.** On an AI/ML platform
   proposal, a pre-read that does not surface NIST AI RMF
   functions or the OWASP ML Top 10 / MITRE ATLAS risk framing
   leaves the AI-adjacent ARB members without the content they
   are responsible for reviewing.
8. **One document, all audiences.** The pre-read is for the
   ARB audience; the executive memo (Exercise 1) is for the
   sponsor; the ADR (Exercise 3) is for engineering peers. A
   pre-read that tries to also serve the sponsor loses the ARB
   altitude.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
- Local stakeholder-communication kit:
  `../../../guides/stakeholder-communication.md`
