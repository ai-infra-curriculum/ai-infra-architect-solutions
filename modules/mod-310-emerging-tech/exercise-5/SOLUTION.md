# SOLUTION — Exercise 5: Responsible AI Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-310-emerging-tech/exercises/exercise-5.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's **roadmap integration**
deliverable — *"Emerging-tech decisions feed back into the multi-year
roadmap (architect/mod-603 / mod-501 territory)."* — to a
responsible-AI capability the organization has committed to (a
governance program, a bias-and-eval pipeline, model-risk management,
or a guardrails / red-team capability).

The architect-tier answer is a roadmap integration that closes the
loop so the radar, pilot proposal, tech-debt impact analysis, and
vendor/OSS evaluation produced by exercises 1–4 land as entries on
the multi-year roadmap that governs the responsible-AI commitment,
rather than running beside it. The module rationale pins
*"no follow-through on pilot learnings"* as a top grader-visible
failure; this exercise is where the learner closes that loop.

## 2. Worked answer

A passing submission produces four named artifacts, mirroring the
module rationale and the roadmap-integration section:

1. **Feedback path** — a one-page mapping that names, for every
   output of exercises 1–4, where it enters the responsible-AI
   roadmap.
2. **Roadmap view** — the multi-year roadmap expressed as
   responsible-AI *capabilities* the organization is committing to,
   each anchored to an authoritative AI-risk taxonomy so leadership
   and audit can defend the roadmap on its own terms.
3. **Cadence** — a reconciliation rhythm between radar updates and
   roadmap updates, matched to the module rationale's quarterly
   radar cadence.
4. **Hand-off** — a named upstream owner of the multi-year horizon
   itself, so this module's integration is not the end of the chain.

### 2a. Feedback path

Every emerging-tech artifact from this module has exactly one entry
point into the responsible-AI roadmap. The module rationale frames
the four artifacts in order; the feedback path keeps that order and
pins each one to a roadmap effect:

| Input from this module | Effect on the responsible-AI roadmap |
| --- | --- |
| **Radar movement** (exercise 1) — a candidate moves between adopt / trial / assess / hold | Adds, removes, or re-slots a capability line item on the roadmap. |
| **Pilot exit** (exercise 2) — adopt / defer / drop against the stated kill criteria | Confirms a roadmap bet, defers it to the next review, or removes it from the plan. |
| **Tech-debt impact analysis** (exercise 3) — easier-in-2-years, harder-in-2-years, and migration-cost-out findings | Sets the "next-review" date on the roadmap line item and the explicit exit cost if the organization has to migrate off. |
| **Vendor / OSS evaluation** (exercise 4) — recommendation with community, governance, ownership, migration, and vendor-health evidence | Chooses or swaps the implementation that currently backs a capability line item without altering the capability line itself. |

Without this mapping the module rationale's trade-off — *"frameworks
help but don't eliminate judgment"* — degrades into the failure the
module names: emerging-tech work that runs beside the roadmap
instead of into it.

### 2b. Roadmap view

For a responsible-AI application, the roadmap line items are
**capabilities, not tools**. A capability line reads, for example,
"the organization can detect bias in production models within a
committed time of deployment" — the vendor or OSS stack chosen in
exercise 4 is the current implementation that satisfies the line.
If the vendor changes, the capability line is stable and the
implementation swaps under it.

Capability lines are anchored to an authoritative AI-risk taxonomy
so the roadmap can be defended to leadership, to audit, and to the
ARB on its own terms rather than through the tooling of the
quarter:

- **NIST AI Risk Management Framework** — capability lines can be
  mapped to the *Govern / Map / Measure / Manage* functions. The
  roadmap entry names the functions the capability commits to.
- **OWASP Machine Learning Security Top 10** — capability lines can
  be mapped to specific ML-security risks the organization is
  committing to address. The roadmap entry names the OWASP ML Top
  10 categories the capability covers.
- **MITRE ATLAS** — capability lines can be mapped to
  adversarial-ML tactics the organization is committing to defend
  against. The roadmap entry names the ATLAS techniques within
  scope.

The roadmap view *cites* these taxonomies rather than teaching
them; roadmap readers with the right expertise can audit each
capability line against the external framework.

### 2c. Cadence

The module rationale names **quarterly** as the radar cadence.
Roadmap reconciliation happens on the same cadence, immediately
after the radar update, so the roadmap always reflects the most
recent radar state. A reconciliation that lags the radar by a
quarter re-creates the gap this exercise exists to close.

Off-cycle reconciliation is triggered when the inputs demand it —
a pilot killed against its kill criteria, a vendor acquisition
flagged by exercise 4, or a tech-debt-impact review that materially
changes migration cost out.

### 2d. Hand-off

The module rationale explicitly points the multi-year horizon at
two upstream modules:

- `principal-engineer/mod-505-long-term-technical-bets` — the
  long-bet framework itself.
- `principal-architect/mod-602-industry-standards` — the
  standards-adoption frame.

A roadmap integration that does not name where the multi-year view
is maintained upstream is incomplete; the responsible-AI roadmap
is a *view* onto that upstream horizon, not a standalone artifact.

### 2e. Trade-offs the architect should call out

Mirroring the module rationale, the submission names the trade-offs
it deliberately accepts:

- *Emerging tech is high-risk — most pilots fail.* The roadmap
  reflects that: capability lines carry the pilot evidence that
  backs them, including killed pilots that removed candidate
  implementations.
- *Conservative architects miss windows; aggressive ones bet
  wrong.* The quarterly reconciliation cadence is the explicit
  budget for revising bets without churning the roadmap every
  sprint.
- *Frameworks help but don't eliminate judgment.* The NIST AI RMF /
  OWASP ML Top 10 / MITRE ATLAS anchors do not replace the
  architect's judgement on which capabilities make the roadmap;
  they let that judgement be audited.

### What stays out of scope

The architect-tier answer **does not** rebuild the radar (that is
exercise 1), re-propose the pilot (exercise 2), re-run the tech-debt
impact analysis (exercise 3), or re-score the vendor evaluation
(exercise 4). It links to each of them and routes their outputs into
the responsible-AI roadmap.

## Implementation

Implementation of the roadmap integration lands as versioned
Markdown artifacts in the architecture repository, not as a
running system:

1. **Feedback-path mapping** — one page, four rows, one row per
   module artifact (radar movement, pilot exit, tech-debt impact,
   vendor / OSS evaluation), each row naming the exact roadmap
   effect from §2a.
2. **Capability-anchored roadmap view** — the responsible-AI
   roadmap re-expressed as capability lines (not tools), each
   capability line carrying at least one taxonomy anchor from §2b
   (NIST AI RMF function, OWASP ML Security Top 10 category, or
   MITRE ATLAS technique).
3. **Reconciliation cadence record** — the quarterly cadence
   from §2c together with the off-cycle trigger list (pilot
   killed against kill criteria, vendor acquisition flagged by
   exercise 4, materially changed migration cost out from
   exercise 3).
4. **Upstream hand-off pointer** — a named reference from the
   roadmap artifact to `principal-engineer/mod-505-long-term-
   technical-bets` and `principal-architect/mod-602-industry-
   standards` per §2d, so the multi-year horizon has a declared
   home outside this module.
5. **Cross-link index** — explicit links back to the exercise-1
   through exercise-4 solutions this integration consumes, so a
   reviewer can trace every roadmap entry to the emerging-tech
   artifact that produced it.

All five artifacts live under version control alongside the
module's other solution assets; the integration is the
*assembly* of these artifacts, not a separate deliverable.

## 3. Validation steps

1. Open the feedback-path artifact. Confirm every one of the four
   module artifacts (radar, pilot, impact, vendor) has a named point
   of entry into the roadmap. A missing input is a fail signal.
2. Open the roadmap view. Confirm every line item is stated as a
   **capability**, not a tool. A line that names a vendor or
   project in the capability text is a fail signal.
3. For each capability line, confirm the anchor to at least one
   authoritative taxonomy (NIST AI RMF function, OWASP ML Top 10
   category, or MITRE ATLAS technique). Unanchored lines cannot be
   defended to audit.
4. Confirm the reconciliation **cadence** is stated and matches the
   radar cadence from the module rationale (quarterly). A roadmap
   that is reconciled on a different cadence from the radar re-opens
   the gap this exercise exists to close.
5. Confirm an **off-cycle trigger list** is stated (pilot killed,
   vendor acquisition, impact-analysis change).
6. Confirm the **hand-off** to `principal-engineer/mod-505-long-
   term-technical-bets` and `principal-architect/mod-602-industry-
   standards` is named by module slug.
7. Confirm the flow runs *emerging-tech → roadmap*, not the
   reverse. A roadmap that dictates which emerging tech is admitted
   to the radar has inverted the module rationale.
8. Mark any taxonomy claim that cannot be verified at write time
   with an HTML research-pending comment rather than guessing.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Feedback path | All four module artifacts (radar, pilot, impact, vendor) land on the roadmap | Any input missing |
| Capability framing | Every roadmap line is a capability, not a tool | Vendor/project names appear in the capability text |
| Taxonomy anchor | Each capability line names at least one NIST AI RMF function, OWASP ML Top 10 category, or MITRE ATLAS technique | Capability line unanchored to any authoritative taxonomy |
| Cadence | Reconciliation cadence stated and matches the radar's quarterly cadence | Cadence absent or divergent |
| Off-cycle triggers | Named list of events that force an off-cycle reconciliation | Only the quarterly cadence, no triggers |
| Flow direction | Emerging-tech feeds the roadmap, not the reverse | Roadmap dictates radar admission |
| Hand-off | `principal-engineer/mod-505-long-term-technical-bets` and `principal-architect/mod-602-industry-standards` named by slug | Hand-off module(s) absent |
| Cross-links | Links to exercise-1 through exercise-4 solutions in this module | Any missing |
| Research markers | HTML research-pending comments present for unverified taxonomy claims | Guessed taxonomy claims presented as fact |
| Form | Versioned Markdown in the architecture repository | Ad-hoc artifact outside version control |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see" for
the roadmap-integration deliverable:

1. **No follow-through on pilot learnings.** The module rationale
   calls this out directly. The analogue here is a roadmap that
   never integrates what pilots found: the emerging-tech work runs
   beside the roadmap instead of into it, so pilot adopt / defer /
   drop verdicts never reach the plan that leadership reads.
2. **Roadmap items expressed as tools.** When the vendor changes
   the roadmap breaks. Capabilities are stable; implementations
   swap underneath them.
3. **Capability lines unanchored to any taxonomy.** A
   responsible-AI roadmap that cannot be mapped to NIST AI RMF
   functions, OWASP ML Top 10 categories, or MITRE ATLAS techniques
   cannot be defended to audit; leadership eventually loses
   confidence that the capabilities named are the right ones.
4. **No cadence, so radar / pilot / vendor updates never reach the
   roadmap.** Quarterly radar updates are stated by the module;
   roadmap reconciliation that lags recreates the gap.
5. **Emerging-tech decisions treated as inputs to the current
   quarter's plan instead of the multi-year roadmap.** The module
   rationale specifically names the *multi-year* horizon; a
   roadmap that only reflects the current quarter is operating at
   the wrong altitude.
6. **Flow inverted.** The roadmap dictates which emerging tech is
   admitted to the radar instead of the radar feeding the roadmap.
   The module rationale is explicit on the direction.
7. **No hand-off upstream.** Omitting the pointer to
   `principal-engineer/mod-505-long-term-technical-bets` and
   `principal-architect/mod-602-industry-standards` leaves the
   roadmap orphan: this module's integration is the input, not the
   home, of the multi-year horizon.
8. **Taxonomy-washing.** Dropping *NIST AI RMF* or *OWASP ML Top
   10* on the page without naming the specific function or category
   per capability line is marketing, not an anchor. Each capability
   line names the specific element it maps to, or carries an HTML
   research-pending comment.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/www-project-machine-learning-security-top-10/>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: [`../SOLUTION.md`](../SOLUTION.md),
  §"Roadmap integration (exercise 05)"
- Companion exercises in this module (inputs this exercise
  integrates): [`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md),
  [`../exercise-2/SOLUTION.md`](../exercise-2/SOLUTION.md),
  [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md),
  [`../exercise-4/SOLUTION.md`](../exercise-4/SOLUTION.md).
- Upstream long-horizon frame (per module rationale):
  `principal-engineer/mod-505-long-term-technical-bets` and
  `principal-architect/mod-602-industry-standards`.
