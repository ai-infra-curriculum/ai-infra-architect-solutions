# SOLUTION — Exercise 2: Streaming Application

> Pairs with
> `ai-infra-architect-learning/lessons/mod-307-data-architecture/exercises/exercise-2.md`.
> Factored from the module-level `SOLUTION.md` in this directory's
> parent.

## 1. Solution overview

This exercise applies the module solution's framing that
**streaming vs. batch ingestion** is one of the frames the data
architect commits, together with the module's "when to go
beyond" direction toward **streaming-first for low-latency use
cases**. The architect-tier answer is not a Kafka deployment
runbook; it is a streaming architecture that commits the
per-source pattern (CDC, event stream, change stream), the
schema evolution discipline on the stream, and the governance
seams that let downstream silver / gold tiers trust the stream.

The module rationale lists streaming as an architect-tier frame
alongside lakehouse tiering, ownership, and schema evolution.
Streaming decisions made before ML lands downstream determine
latency, replayability, and the quality bar the lakehouse can
promise. This exercise is where the learner commits the
streaming architecture and the invariants it enforces, so
Exercise 3 (governance), Exercise 4 (contracts), and Exercise 5
(catalog / lineage) have a stream contract to govern.

## 2. Worked answer

A passing streaming architecture submission produces one linked
design package with four named sections, grounded in the module
rationale's streaming / batch framing and the schema-evolution +
contract discipline from the parent SOLUTION:

1. **Source → stream pattern map** — which sources run as
   streams (event stream, CDC) vs. batch (file drop, API pull).
2. **Stream topology** — producer, broker, consumer surfaces
   with the integration contract for each.
3. **Schema evolution on the stream** — the compatibility
   class per topic and the breaking-change workflow.
4. **Replay and backfill contract** — retention, offset
   semantics, and the lakehouse-tier replay story.

### Source → stream pattern map

The module rationale names "streaming vs. batch ingestion" as a
per-source decision. The submission takes the ingestion map
from Exercise 1 (see
[`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md)) and
commits, per source, which of the module's four patterns
applies:

- **Event stream** — application events published to the broker
  as the authoritative emission point. Low latency, strict
  schema per topic.
- **CDC** — row-level change feed from an operational database,
  streamed to the broker. Latency bounded by log reader
  cadence.
- **Batch file drop** — kept out of the stream topology;
  landed to bronze directly.
- **API pull** — kept out of the stream topology unless the
  API exposes a change feed.

"Everything streams" is a fail signal because it buries the
cost of streaming systems on sources that cannot justify it.

### Stream topology

The topology commits three surfaces:

- **Producer contract** — the publisher's responsibility for
  schema registration, key selection, and at-least-once vs.
  exactly-once semantics.
- **Broker surface** — topic naming, partitioning, retention
  class, and the policy for who creates / owns a topic.
- **Consumer contract** — the consumption pattern (per-record,
  windowed, stateful), the offset-commit discipline, and the
  dead-letter path.

Each surface has an owner from the ownership frame the module
rationale sets up (see
[`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md)). A
topology without named owners is the "chaos" failure the module
calls out for data mesh declared without domain ownership.

### Schema evolution on the stream

The module rationale pins the schema evolution policy as a
module frame (forward / backward / full compatibility per data
class). The streaming architecture applies that policy to
topics:

- **Compatibility class per topic** — set according to the
  policy from Exercise 3 (see
  [`../exercise-3/SOLUTION.md`](../exercise-3/SOLUTION.md)).
- **Breaking-change workflow** — version bump + consumer
  migration window, exactly as the module rationale requires.
- **Schema registry role** — the registry is the enforcement
  point; a change that would violate the compatibility class
  is rejected at publish, not caught in silver.

### Replay and backfill contract

Streaming architectures that cannot replay cannot heal from
downstream errors. The contract commits:

- **Retention per topic** — long enough to backfill the
  silver-tier dependency and support the lakehouse replay
  path from
  [`../exercise-1/SOLUTION.md`](../exercise-1/SOLUTION.md).
- **Offset semantics** — explicit at-least-once vs.
  exactly-once per consumer; the trade-off recorded alongside.
- **Lakehouse replay story** — how a bronze reload is driven
  from the stream, including the identification of the window
  being replayed.

### Cross-cutting invariants

The architect-tier value is in the invariants that span the
stream topology:

- **Tenancy carries on the stream** — team / cost-center /
  data-class metadata attached by the producer survives through
  consumers so attribution and policy checks resolve on the
  stream the same way they resolve on the lakehouse.
- **Lineage ties stream to lakehouse** — the stream is the
  bronze-tier source for stream-sourced datasets; the lineage
  edge is recorded in the catalog from Exercise 5 (see
  [`../exercise-5/SOLUTION.md`](../exercise-5/SOLUTION.md)).
- **Streaming does not relax the contract** — the stream has a
  data contract (see
  [`../exercise-4/SOLUTION.md`](../exercise-4/SOLUTION.md))
  just as the batch tier does; "streaming makes contracts
  harder" is not a reason to skip them.

### AI/ML-specific considerations

Streaming systems that feed ML carry risks the generic
transactional stream does not:

- **Feature freshness and training/serving skew** — stream
  latency and offset semantics determine whether online
  features derived from the stream match the offline training
  data. Point-in-time correctness is a stream-layer concern.
- **Data poisoning via producer compromise** — OWASP ML
  Security Top 10 *ML02: Data Poisoning* and *ML06: AI Supply
  Chain Attacks* target the producer side; the producer
  contract (identity, schema enforcement, audit) is where
  these are mitigated.
- **MITRE ATLAS reconnaissance surface** — topic names,
  schemas, and sample payloads leak information about the ML
  pipelines downstream; broker access and schema-registry
  access decisions are governance surfaces.
- **NIST AI RMF *Measure* function** — stream freshness,
  schema violations, and dead-letter rates are first-class
  measurement signals, not operational trivia.

### Decision rationale

A four-section streaming architecture (pattern map, topology,
schema evolution on the stream, replay / backfill) is the right
altitude because the module rationale names streaming as an
architect-tier frame and lists it among the trade-offs
deliberately accepted (schema-evolution discipline, streaming
as the direction for low-latency use cases). The submission
should explicitly accept:

- *Streaming-first is a per-use-case call, not a global one.*
  Sources that cannot justify stream latency stay on batch.
- *Schema evolution discipline becomes stricter under
  streaming.* Breaking changes require stronger coordination
  because consumers cannot be paused like a batch job.
- *Replay cost is real.* Retention and partition sizing are
  cost decisions tracked by
  `mod-304/exercise-1` attribution.

### What stays out of scope

The architect-tier answer **does not** commit the ownership
model (deferred to Exercise 3), set the schema evolution policy
itself (Exercise 3), draft the data contract template
(Exercise 4), or commit the catalog tool (Exercise 5). The
goal here is the streaming architecture tight enough that the
later exercises can commit decisions against it.

### Scope alignment with parent SOLUTION

The parent `../SOLUTION.md` names streaming vs. batch ingestion
as one of the architect-tier frames and names streaming-first
as a "when to go beyond" direction. The learner-visible title
for this exercise is "Streaming Application", and this file
carries the streaming architecture that applies the module's
framing. Cross-cutting invariants and AI/ML considerations are
grounded in NIST AI RMF (Measure function), OWASP ML Top 10,
and MITRE ATLAS cited in §6.

## Implementation

Implementation of the streaming architecture lands as versioned
architecture assets, not as a running broker:

1. **Streaming architecture document** — Markdown with one
   section per field (pattern map, topology, schema evolution,
   replay / backfill).
2. **Stream topology diagram** — producers, broker, consumers
   with owners annotated and the lineage edge to the lakehouse
   bronze tier.
3. **Source → pattern table** — every source system mapped to
   event-stream, CDC, batch file drop, or API pull with
   rationale.
4. **Topic contract template** — per-topic owner, schema
   compatibility class, retention, partition key, and
   producer identity.
5. **Replay runbook outline** — how a bronze reload is driven
   from retained offsets; the window identification rule.
6. **AI/ML invariants addendum** — feature freshness /
   training-serving skew, producer compromise mitigation,
   and NIST AI RMF measurement signals. OWASP ML Top 10 and
   MITRE ATLAS cited inline.
7. **Governance hook** — pattern-map changes, topology
   changes, or compatibility-class changes require an ADR via
   the governance system from `mod-301/exercise-4`.

## 3. Validation steps

1. Open the streaming architecture document. Confirm each of
   the four fields (pattern map, topology, schema evolution,
   replay / backfill) is present and populated.
2. Confirm the pattern map covers every source listed in
   `../exercise-1/SOLUTION.md`'s ingestion pattern map and
   makes the stream-vs-batch call per source.
3. Confirm each topic has a named owner, compatibility class,
   and retention target.
4. Confirm the replay story names how a bronze reload is
   driven from retained offsets.
5. Confirm tenancy metadata (team, cost-center, data class)
   is carried on the stream.
6. Confirm the lineage edge from stream to bronze is recorded
   so it will land in the Exercise 5 catalog.
7. Confirm schema evolution policy, data contract template,
   and catalog tool choice are deferred to the matching later
   exercises, not inlined here.

## 4. Rubric or review checklist

| Area | Pass criterion | Fail signal |
| --- | --- | --- |
| Field completeness | Four fields each committed | Missing field |
| Pattern map coverage | Every source assigned exactly one pattern | "Everything streams" or gaps |
| Topic ownership | Every topic has a named owner | "Platform team" catch-all |
| Compatibility class | Set per topic from Exercise 3 policy | Compatibility unset or ad-hoc |
| Replay contract | Retention + offset semantics + reload rule | Replay listed but not specified |
| Lineage edge | Stream → bronze recorded for catalog | Lineage absent |
| Tenancy carry-through | Team / cost-center / data class on the stream | Metadata dropped at producer or consumer |
| AI/ML invariants | Freshness / skew + producer-compromise mitigation named | ML risks absent |
| Scope discipline | Policy / contract / catalog deferred | Deferred decisions inlined |
| Form | Versioned Markdown + diagram | PDF or slide deck |

## 5. Common mistakes

Specialized from the module-level "common mistakes graders see"
for the streaming architecture deliverable:

1. **Everything declared a stream.** The module rationale
   names streaming vs. batch as a per-source decision;
   streaming every source without justification is the
   dominant failure the architect tier is responsible for
   preventing.
2. **Schema changes pushed without consumer review.** The
   module rationale calls out "schema changes pushed without
   consumer review" as a downstream-breakage failure. On a
   stream the breakage is immediate because consumers cannot
   be paused.
3. **Topic owners collapsed to "platform team".** The architect
   tier value is in decomposing ownership so topics have
   accountable producers; a single-owner topology defeats the
   purpose.
4. **Replay listed but not specified.** "We can replay" without
   retention, offset semantics, and the reload rule is a
   placeholder, not a contract.
5. **Streaming makes contracts optional.** Streaming does not
   relax data contracts (see Exercise 4). A stream without a
   contract is the same quality failure as a silver table
   without one.

## 6. References

- NIST AI Risk Management Framework (AI RMF 1.0) —
  <https://www.nist.gov/itl/ai-risk-management-framework>
- OWASP Machine Learning Security Top 10 —
  <https://owasp.org/projects/machine-learning-security-top-ten>
- MITRE ATLAS — <https://atlas.mitre.org/>
- Module-level rationale: `../SOLUTION.md`
