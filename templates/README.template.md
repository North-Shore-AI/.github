# North Shore AI

**Reliability-first AI infrastructure on Elixir/BEAM**

**{{REPO_COUNT}} public repos** | **{{STAR_COUNT}} stars**

---

## Executive Summary

The Elixir/BEAM platform provides technical capabilities essential for production AI systems that other runtimes cannot match: lightweight process isolation enables thousands of concurrent model calls without shared state corruption, supervisor trees provide automatic failure recovery without human intervention, and hot code upgrades allow model updates without service interruption. These are not conveniences but prerequisites for systems targeting 99%+ reliability in adversarial production environments.

North Shore AI builds the ML reliability research ecosystem that Elixir deserves. From statistical testing and ensemble voting to adversarial robustness and explainable AI, the stack addresses the full lifecycle of getting LLMs to behave predictably. The goal is world-class tooling that leverages BEAM's unique properties while remaining accessible to researchers and practitioners.

Two industrial metaphors unify the ecosystem. The **Kitchen/Cookbook** pattern treats ML training as a culinary operation: the kitchen provides infrastructure, cookbooks contain recipes, and practitioners are chefs executing them. The **Metalworking** pattern treats data labeling as manufacturing: raw data enters the forge, receives careful refinement on the anvil, and emerges as polished UI components (ingots) ready for crucible experimentation.

---

## The 7-Tiered Architectural Model

| Tier | Layer | Components |
|------|-------|------------|
| 1 | Public Interface | nsai_sites (Cloudflare Workers) |
| 2 | Gateway & Orchestration | nsai_gateway, nsai_registry |
| 3 | Processing Domains | Kitchen (training), Forge (data), CNS (reasoning) |
| 4 | Core Framework | crucible_framework, crucible_ir, crucible_bench |
| 5 | MLOps Assembly | crucible_train, crucible_model_registry, crucible_deployment, crucible_feedback |
| 6 | Reliability & Safety | LlmGuard, crucible_ensemble, crucible_hedging, crucible_xai, crucible_adversary |
| 7 | Foundational Utilities | tiktoken_ex, embed_ex, hf_hub_ex, hf_datasets_ex |

---

## Industrial Metaphors

### Kitchen/Cookbook (Training Infrastructure)

The training stack uses culinary terminology to separate concerns:

- **Kitchen** (`crucible_kitchen`): The infrastructure and orchestration engine. Backend-agnostic, handles compute provisioning, job scheduling, and resource management.
- **Cookbook** (`tinkex_cookbook`): Training recipes and configurations. Declarative specifications for training runs that can be versioned and shared.
- **Chef**: The ML practitioner who uses the kitchen and follows recipes to produce trained models.

### Metalworking (Data Labeling Stack)

The data labeling pipeline uses metalworking terminology to describe data transformation:

- **Forge** (`forge`): Raw data processing factory. Takes unstructured inputs and shapes them into structured samples.
- **Anvil** (`anvil`): Human-in-the-loop labeling and governance. Where careful refinement and quality control occur.
- **Ingot** (`ingot`): Polished UI components. Production-ready Phoenix LiveView modules for labeling interfaces.
- **Crucible**: ML experimentation. Where refined data undergoes testing and transformation under pressure.

---

## Core Projects by Category

### Crucible Reliability Stack

Open research platform targeting 99%+ LLM reliability through ensembles, hedging, and statistical testing.

| Repository | Description |
|------------|-------------|
{{CRUCIBLE_REPOS}}

### Data Labeling (Metalworking)

| Repository | Description |
|------------|-------------|
{{INGOT_REPOS}}

### CNS Dialectical Reasoning

Critic-Network Synthesis: structured argumentation for AI reasoning transparency.

| Repository | Description |
|------------|-------------|
{{RESEARCH_REPOS}}

**CNS Dialectical Flow:**
```
Proposer (thesis) -> Antagonist (antithesis) -> Synthesizer (synthesis)
     |                    |                         |
  Extract SNOs      Flag contradictions      Resolve with evidence
  (claims+evidence) (B1 gaps, chirality)    (critic-guided)
```

Critics: Grounding, Logic, Novelty, Bias, Causal

### Safety & Quality

| Repository | Description |
|------------|-------------|
{{SAFETY_REPOS}}

### Infrastructure

| Repository | Description |
|------------|-------------|
{{INFRA_REPOS}}

### Data & Utilities

| Repository | Description |
|------------|-------------|
{{DATA_REPOS}}

---

## Public Sites

| Site | Purpose |
|------|---------|
| [nsai.online](https://nsai.online) | Corporate landing, architecture overview |
| [nsai.store](https://nsai.store) | Open source packages catalog |
| [nsai.space](https://nsai.space) | Research lab, CNS experiments |

---

**BEAM Native** | OTP supervision, telemetry, distributed resilience
**Research Backed** | Every feature tied to reliability research
**Production Ready** | Hex packages, docs, test suites

[@nshkrdotcom](https://github.com/nshkrdotcom)

_Updated {{UPDATE_DATE}}_
