# SOLUTION — Architect-Tier Security and Compliance

> Read this *after* you have designed the reference enterprise
> security architecture. This document explains the architect-
> tier security frame.

## What this module is really teaching

Engineer-tier security (senior-engineer/mod-209) is about
controls and implementations. Architect-tier security is about:
- Designing a security architecture that the org can sustain.
- Choosing a compliance frame (SOC 2 / ISO 27001 / HIPAA /
  FedRAMP / EU AI Act) and engineering toward it.
- Defining standards that the engineering org follows.
- Building security review processes that scale.

## What the deliverables should actually look like

### Security architecture document (exercise 01)

The reference security architecture document covers:
- Trust boundaries.
- Identity and access management approach.
- Network segmentation strategy.
- Data classification framework.
- Encryption-at-rest / in-transit policies.
- Incident response governance.

### Compliance mapping (exercise 02)

Each requirement of the chosen compliance frame is mapped to a
control owner + implementation pattern. The deliverable is a
spreadsheet/database that audit can query.

### Standards document (exercise 03)

The standards document tells engineering teams *what* they must
do (no long-lived credentials, all images signed, etc.) and
references implementation patterns. Standards are versioned;
exceptions are recorded.

### Security review process (exercise 04)

The review process defines:
- When security review is required (new external integration,
  new data class, new compliance scope).
- Who reviews.
- What review depth maps to which risk class.
- Service-level expectation for review turnaround.

### Threat modeling template (exercise 05)

Reference threat models follow STRIDE / LINDDUN with ML-specific
extensions (training-data poisoning, model inversion, prompt
injection).

## Trade-offs we deliberately accepted

- Architect-tier security adds ceremony.
- Strict standards slow some engineering decisions.
- Compliance scope creep is a recurring issue.

## Common mistakes graders see

1. **Security architecture that's a list of products**, not a
   coherent design.
2. **Compliance mapping that's checkbox theater**.
3. **Standards without enforcement (admission control)**.
4. **Threat models done once, never updated**.

## When to go beyond this implementation

- Adopt **zero-trust architecture** as the unifying frame.
- Move to **continuous compliance** (Drata / Vanta).
- Add **EU AI Act** mapping for ML-heavy orgs serving the EU.

## Related curriculum touchpoints

- ``senior-engineer/mod-209-security-compliance`` — engineer
  view.
- ``architect/projects/project-305-security-framework`` — the
  user-facing project.
