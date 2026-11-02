# SOLUTION — LLM and RAG Architecture

> Read this *after* you have designed the reference LLM+RAG
> enterprise architecture. This document explains the
> architect-tier LLM-platform frame and acts as a high-level
> index for the per-exercise solutions in this directory.

## Per-exercise solutions

The rationale below is factored into per-exercise `SOLUTION.md`
files. Start here for orientation, then go to the exercise file
that matches the deliverable you are reviewing.

| Exercise | Topic | File |
| --- | --- | --- |
| Exercise 1 | LLM Architecture Application | [`exercise-1/SOLUTION.md`](exercise-1/SOLUTION.md) |
| Exercise 2 | RAG Application | [`exercise-2/SOLUTION.md`](exercise-2/SOLUTION.md) |
| Exercise 3 | Vector Databases Application | [`exercise-3/SOLUTION.md`](exercise-3/SOLUTION.md) |
| Exercise 4 | Safety Application | [`exercise-4/SOLUTION.md`](exercise-4/SOLUTION.md) |
| Exercise 5 | Cost Optimization Application | [`exercise-5/SOLUTION.md`](exercise-5/SOLUTION.md) |

The legacy `exercise-01/` … `exercise-05/` directories remain as
pointer READMEs into the learning repository; the depth lives in
the new `exercise-1/` … `exercise-5/` directories above.

## What this module is really teaching

LLM serving at enterprise scale isn't "deploy an inference
server." It's:
- RAG architecture with vector store + retrieval evaluation.
- Multi-model routing for cost / capability balance.
- Prompt-management governance.
- Hallucination / quality controls.
- Cost forecasting (LLM spend grows fast).

## What the deliverables should actually look like

### Reference LLM platform architecture (exercise 01)

Layered: model serving / retrieval / orchestration / observability
/ safety. Each layer has interface contracts.

### Model selection policy (exercise 02)

How to choose between OSS (Llama, Mistral) vs. commercial
(OpenAI, Anthropic) vs. self-hosted commercial for each use
case. The policy considers: cost, capability, data sensitivity,
latency.

### Retrieval strategy (exercise 03)

Vector store choice (Pinecone / Weaviate / pgvector / FAISS).
Embedding model selection. Chunk-size + overlap policy.
Hybrid search (sparse + dense) when appropriate.

### Prompt-management discipline (exercise 04)

Prompts are version-controlled; each prompt has eval coverage;
prompt changes require review.

### Hallucination + safety controls (exercise 05)

Output filters, citation requirements, refusal patterns,
adversarial-prompt detection.

## Trade-offs we deliberately accepted

- OSS self-hosting saves money at scale; complex to operate.
- Vector stores fragment by capability.
- LLM cost grows ~linearly with usage; budget vigilantly.

## Common mistakes graders see

1. **No retrieval eval**: hallucination + irrelevance silent.
2. **Single-model architecture**: pays the strongest model's
   price for every request.
3. **Prompts in code, not versioned**.
4. **No cost monitoring on commercial APIs**: surprise bills.

## When to go beyond this implementation

- Adopt **multi-LoRA** serving for fine-tuned variants.
- Move to **agentic architectures** with tool-use observability.
- Add **continuous prompt tuning** via DSPy or similar.

## Related curriculum touchpoints

- ``engineer/mod-110-llm-infrastructure`` — serving
  foundations.
- ``architect/projects/project-303-llm-rag-platform`` — the
  enterprise LLM project.
