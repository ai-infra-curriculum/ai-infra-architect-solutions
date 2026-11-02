# SOLUTION — Exercise 1: Executive Comms Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-309-arch-communication/exercises/exercise-1.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **strategy memo for
executives** deliverable — *"one page. State the decision, the
alternatives, the recommendation, the ask. Executives want
decisions, not expositions."* — to a concrete AI-platform
proposal. The architect-tier answer is not a status update or a
technical narrative; it is a one-page memo that lets a sponsor
decide in a single reading pass.

The module rationale pins executive communication to the ask,
not the context, and names "memos that bury the recommendation"
as a top grader-visible failure. This exercise is where the
learner produces the executive artifact for the proposal, so
later exercises (visual communication, ADRs, stakeholder
management) have a decision-shaped anchor to attach to.

## 2. Worked answer

A passing executive-comms submission produces one one-page memo
with six sections, mirroring the local reusable kit in
`../../../guides/stakeholder-communication.md` *The one-page
brief* field. Each section is roughly ~150 words:

1. **TL;DR** — three sentences: what we propose, why, what we
   need from the reader.
2. **Context** — one paragraph: the problem, the world today,
   why now.
3. **Proposal** — one paragraph: the actual recommendation
   (specific vendor, specific plan, specific scope).
4. **Trade-offs** — three bullets: what we give up, what we
   accept as risk.
5. **What we need** — one paragraph: approval, budget,
   headcount, decision deadline.
6. **References** — three links: the deep-dive doc, the ADR,
   the cost model.

The one-pager is the artifact that most stakeholders will read;
the module rationale is explicit that executives "want decisions,
not expositions."

### Lead with the ask, not the context

The module rationale orders the memo as *decision → alternatives
→ recommendation → ask*. The local stakeholder-communication
guide sharpens this: *"Most engineering communication leads with
context ... Executive communication leads with the ask."* The
TL;DR must contain the ask verbatim ("approve X by Y date for Z
budget"), not an invitation to read on.

### Use specific numbers, not adjectives

The stakeholder-communication guide names *"significant cost"* as
a failure phrase: a passing memo quotes numbers (annual spend,
payback, headcount) and ranges when numbers are uncertain. An
executive memo that says *"this will save substantial money"*
fails even if the underlying analysis is correct, because the
decision cannot be ratified against the sentence.

### Anchor on outcomes, not activities

The same guide separates *"we will refactor X"* (activity) from
*"we will reduce incidents by N over M months"* (outcome). The
executive memo commits to the outcome; the activity belongs in
the referenced deep-dive.

### Alternatives, briefly

The module rationale requires alternatives, but the executive
memo surfaces them in a bullet or a small table — not a
side-by-side analysis. The depth of the alternatives analysis
lives in the ADR produced for [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md)
and in the pre-read packet from [`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md);
the executive memo links to them.

### Audience fit

The audience here is the executive sponsor (SVP+ class in the
stakeholder-communication guide's audience table), who "cares
about outcome, risk, narrative arc" and reads "one page; then
questions." The memo is the artifact that opens the Q&A; it is
not the deck. Decks longer than roughly five slides are an
anti-pattern per the module rationale's *death by deck* failure
mode.

### AI/ML-specific considerations

When the architecture being communicated is an AI/ML platform,
the executive memo surfaces the governance framing an executive
sponsor will recognize:

- **NIST AI Risk Management Framework** — the sponsor needs to
  see that the proposal commits to the *Govern*, *Map*,
  *Measure*, and *Manage* functions, not that it enumerates
  them. One bullet in the memo (e.g. "controls aligned to NIST
  AI RMF") suffices; the detail lives in the deep-dive.
- **OWASP Machine Learning Security Top 10** — if the proposal
  surfaces ML-specific risk (supply chain, prompt injection,
  data poisoning), the trade-off bullet names which categories
  are mitigated and which are deferred.
- **MITRE ATLAS** — adversarial-ML threat framing an executive
  recognizes without technical detail; cite only when the
  proposal has an adversarial-threat exposure to communicate.

The executive memo cites these frameworks by name; it does not
teach them.

### Decision rationale

The one-page strategy memo is the right artifact for the
executive-sponsor audience because the module rationale pins
executive communication to a decision-shaped artifact and the
local stakeholder-communication guide names the one-pager as
"the artifact that 80% of stakeholders read." Trade-offs the
submission should explicitly accept, mirroring the module
rationale:

- *One-page memos require painful editing.* The brevity is the
  deliverable, not an inconvenience to it.
- *Multiple-altitude documents mean producing the same content
  in different shapes.* The executive memo is one altitude; the
  deep-dive is another; the ADR is a third.
- *Diagrams age fast.* The executive memo refers to a single
  diagram at most; the diagram set lives in Exercise 2.

### What stays out of scope

The architect-tier answer **does not** render the full diagram
set (deferred to Exercise 2), produce the ADR (deferred to
Exercise 3), build the stakeholder map (deferred to Exercise 4),
or assemble the ARB pre-read packet (deferred to Exercise 5).
The goal here is one page that gets the decision made.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names the executive deliverable as
*"Strategy memo for executives: one page. State the decision,
the alternatives, the recommendation, the ask."* The learner-
visible title for this exercise is "Executive Comms
Application"; this file carries the one-page memo depth and
defers the referenced artifacts (diagrams, ADR, pre-read) to
exercises 2, 3, and 5. The local supporting kit comes from
`../../../guides/stakeholder-communication.md`.

## Implementation

Implementation of the executive memo lands as versioned
documentation, not as a running system:

1. **One-page memo** — Markdown in the architecture repository
   with the six sections above (TL;DR, Context, Proposal,
   Trade-offs, What we need, References). Hard-limit length;
   edit until it fits.
2. **Numbers block** — the specific dollar figures, timelines,
   and headcount asks are present verbatim in the memo; a
   `<!-- research-pending: ... -->` comment is used if a number
   is not yet available, so auto-merge gates on the gap.
3. **Alternatives bullet** — a short table or bullet list of
   considered alternatives, each with a one-line reason it was
   not chosen. Depth lives in the ADR.
4. **Diagram link** — one architecture diagram (context-level,
   per Exercise 2) linked from the References section.
5. **Decision gates** — the memo names the specific decision
   requested, the deadline, and the decision-maker role.
6. **AI/ML governance line** — if the proposal is an AI/ML
   platform, one line maps to NIST AI RMF; one line maps to
   OWASP ML Top 10 if ML-specific risk is in scope; one line
   maps to MITRE ATLAS if adversarial-ML exposure is a factor.
7. **Governance hook** — the memo is reviewed by the proposal
   owner's lead and the sponsor's chief of staff before
   distribution; distribution follows pre-wire via the pattern
   from the stakeholder-communication guide.

## 3. Validation steps

1. Open the memo. Confirm it is one page in the target
   formatting. More than one page is a fail signal.
2. Confirm the TL;DR contains the ask verbatim in the first
   three sentences.
3. Confirm specific numbers appear for cost, timeline, and
   headcount, or that `<!-- research-pending: ... -->` markers
   exist in their place.
4. Confirm the trade-offs section has three bullets, not two
   and not five.
5. Confirm the References section links to the deep-dive, the
   ADR (from Exercise 3), and the cost model.
6. Confirm the decision requested, the decision-maker, and the
   decision deadline are explicit.
7. Confirm the alternatives are surfaced briefly, not
   analyzed; the full analysis is deferred to the ADR and the
   pre-read packet.
8. If the proposal is an AI/ML platform, confirm the
   governance frameworks (NIST AI RMF, OWASP ML Top 10, MITRE
   ATLAS as applicable) are named without being taught.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Length | One page | More than one page |
| Section completeness | All six sections present | Any missing |
| Ask placement | Ask in the first three sentences | Ask after section 3 |
| Numbers | Specific numbers or `research-pending` markers | Adjectives in place of numbers |
| Outcome framing | Outcome stated, not activity | "We will refactor" phrasing |
| Trade-offs | Three bullets of what is given up | None, or a defensive list |
| Alternatives | Surfaced briefly; depth in linked ADR | Full comparative analysis inline |
| Decision gates | Ask, decision-maker, deadline named | Any missing |
| References | Deep-dive, ADR, cost model linked | Links absent |
| AI/ML governance | Framework names surfaced when applicable | Taught or absent when applicable |
| Form | Versioned Markdown | PDF-only or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the executive communication deliverable:

1. **Burying the recommendation.** The module rationale calls
   this out directly ("memos that bury the recommendation").
   The ask lives in the first three sentences; a memo where the
   reader has to search for the decision has already failed.
2. **One document, all audiences.** The module rationale names
   this as a top failure. The executive memo is for the
   executive audience; it does not try to also serve
   engineering peers or regulators. Those audiences get their
   own artifacts via Exercises 2–5.
3. **Death by deck.** A 20+-slide companion deck replaces the
   one-pager. Per the stakeholder-communication guide, the deck
   is backup material for the Q&A, not the primary artifact.
4. **Adjectives instead of numbers.** "Significant savings" is
   not a decidable claim; "$2.4M annually with 9-month payback"
   is. A memo without specific numbers (or explicit
   `research-pending` markers) is not actionable.
5. **Status theater.** The memo cannot be a project update
   disguised as a decision ask; executives learn to filter
   those. The ask must be concrete and the deadline binding.
6. **Asymmetric disclosure.** The memo must tell the same story
   as the deep-dive and the ADR, in a shorter shape. If the
   executive memo and the engineering deep-dive disagree, trust
   collapses when the audiences compare notes.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
- Local stakeholder-communication kit:
  `../../../guides/stakeholder-communication.md`
