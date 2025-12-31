# North Shore AI

**Reliability-first AI infrastructure on Elixir/BEAM**

**45 public repos** | **18 stars**

> **[Interactive Architecture Explorer](https://nsai.space/architecture.html)** | **[Full Documentation](docs/ARCHITECTURE.md)**

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
| [ExDataCheck](https://github.com/North-Shore-AI/ExDataCheck) | Data validation and quality library for ML pipelines in Elixir |
| [ExFairness](https://github.com/North-Shore-AI/ExFairness) | Fairness and bias detection library for Elixir AI/ML systems |
| [LlmGuard](https://github.com/North-Shore-AI/LlmGuard) | AI Firewall and guardrails for LLM-based Elixir applications |
| [cns_crucible](https://github.com/North-Shore-AI/cns_crucible) |  |
| [crucible_adversary](https://github.com/North-Shore-AI/crucible_adversary) | Adversarial testing and robustness evaluation for the Crucible fram... |
| [crucible_bench](https://github.com/North-Shore-AI/crucible_bench) | Statistical testing and analysis framework for AI research |
| [crucible_datasets](https://github.com/North-Shore-AI/crucible_datasets) | Dataset management and caching for AI research benchmarks |
| [crucible_deployment](https://github.com/North-Shore-AI/crucible_deployment) | ML model deployment for the Crucible ecosystem. vLLM and Ollama int... |
| [crucible_ensemble](https://github.com/North-Shore-AI/crucible_ensemble) | Multi-model ensemble voting strategies for LLM reliability |
| [crucible_examples](https://github.com/North-Shore-AI/crucible_examples) | Interactive Phoenix LiveView demonstrations of the Crucible Framewo... |
| [crucible_feedback](https://github.com/North-Shore-AI/crucible_feedback) | ML feedback loop management for the Crucible ecosystem. Quality mon... |
| [crucible_framework](https://github.com/North-Shore-AI/crucible_framework) | CrucibleFramework: A scientific platform for LLM reliability resear... |
| [crucible_harness](https://github.com/North-Shore-AI/crucible_harness) | Experimental research framework for running AI benchmarks at scale |
| [crucible_hedging](https://github.com/North-Shore-AI/crucible_hedging) | Request hedging for tail latency reduction in distributed systems |
| [crucible_ir](https://github.com/North-Shore-AI/crucible_ir) | Intermediate Representation for the Crucible ML reliability ecosystem |
| [crucible_kitchen](https://github.com/North-Shore-AI/crucible_kitchen) | Industrial ML training orchestration - backend-agnostic workflow en... |
| [crucible_model_registry](https://github.com/North-Shore-AI/crucible_model_registry) | ML model registry for the Crucible ecosystem. Artifact storage, mod... |
| [crucible_telemetry](https://github.com/North-Shore-AI/crucible_telemetry) | Advanced telemetry collection and analysis for AI research |
| [crucible_trace](https://github.com/North-Shore-AI/crucible_trace) | Structured causal reasoning chain logging for LLM transparency |
| [crucible_train](https://github.com/North-Shore-AI/crucible_train) | ML training orchestration for the Crucible ecosystem. Distributed t... |
| [crucible_ui](https://github.com/North-Shore-AI/crucible_ui) | Phoenix LiveView dashboard for the Crucible ML reliability stack |
| [crucible_xai](https://github.com/North-Shore-AI/crucible_xai) | Explainable AI (XAI) tools for the Crucible framework |
| [datasets_ex](https://github.com/North-Shore-AI/datasets_ex) | Dataset management library for ML experiments—loaders for SciFact, ... |
| [eval_ex](https://github.com/North-Shore-AI/eval_ex) | Model evaluation harness for standardized benchmarking—comprehensiv... |
| [hf_datasets_ex](https://github.com/North-Shore-AI/hf_datasets_ex) | HuggingFace Datasets for Elixir - A native Elixir port of the popul... |
| [metrics_ex](https://github.com/North-Shore-AI/metrics_ex) | Metrics aggregation and alerting for ML experiments—multi-backend e... |

### Data Labeling (Metalworking)

| Repository | Description |
|------------|-------------|
| [anvil](https://github.com/North-Shore-AI/anvil) | Labeling queue library for managing human labeling workflows |
| [forge](https://github.com/North-Shore-AI/forge) | Sample factory library for generating, transforming, and computing ... |
| [ingot](https://github.com/North-Shore-AI/ingot) | Phoenix LiveView interface for sample generation and human labeling... |
| [labeling_ir](https://github.com/North-Shore-AI/labeling_ir) | Shared IR structs for the North Shore labeling stack (Forge/Anvil/I... |

### CNS Dialectical Reasoning

Critic-Network Synthesis: structured argumentation for AI reasoning transparency.

| Repository | Description |
|------------|-------------|
| [cns](https://github.com/North-Shore-AI/cns) | Chiral Narrative Synthesis - Dialectical reasoning framework for au... |
| [cns_ui](https://github.com/North-Shore-AI/cns_ui) | Phoenix LiveView interface for CNS dialectical reasoning experiments |

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
| [ExDataCheck](https://github.com/North-Shore-AI/ExDataCheck) | Data validation and quality library for ML pipelines in Elixir |
| [ExFairness](https://github.com/North-Shore-AI/ExFairness) | Fairness and bias detection library for Elixir AI/ML systems |
| [LlmGuard](https://github.com/North-Shore-AI/LlmGuard) | AI Firewall and guardrails for LLM-based Elixir applications |
| [datasets_ex](https://github.com/North-Shore-AI/datasets_ex) | Dataset management library for ML experiments—loaders for SciFact, ... |
| [eval_ex](https://github.com/North-Shore-AI/eval_ex) | Model evaluation harness for standardized benchmarking—comprehensiv... |
| [hf_datasets_ex](https://github.com/North-Shore-AI/hf_datasets_ex) | HuggingFace Datasets for Elixir - A native Elixir port of the popul... |
| [metrics_ex](https://github.com/North-Shore-AI/metrics_ex) | Metrics aggregation and alerting for ML experiments—multi-backend e... |

### Infrastructure

| Repository | Description |
|------------|-------------|
| [hf_hub_ex](https://github.com/North-Shore-AI/hf_hub_ex) | Elixir client for HuggingFace Hub—dataset/model metadata, file down... |
| [nsai_gateway](https://github.com/North-Shore-AI/nsai_gateway) | Unified API gateway for the NSAI ecosystem—authentication (JWT, API... |
| [nsai_registry](https://github.com/North-Shore-AI/nsai_registry) | Service discovery and registry for the NSAI ecosystem—distributed r... |
| [pilot](https://github.com/North-Shore-AI/pilot) | Interactive CLI and REPL for the NSAI ecosystem—unified interface t... |
| [tiktoken_ex](https://github.com/North-Shore-AI/tiktoken_ex) | Pure Elixir TikToken-style byte-level BPE tokenizer (Kimi K2 compat... |
| [tinkerer](https://github.com/North-Shore-AI/tinkerer) | Chiral Narrative Synthesis workspace for Thinker/Tinker LoRA pipeli... |
| [tinkex](https://github.com/North-Shore-AI/tinkex) | Elixir SDK for the Tinker ML platform—LoRA training, sampling, and ... |
| [tinkex_cookbook](https://github.com/North-Shore-AI/tinkex_cookbook) | Elixir port of tinker-cookbook: training and evaluation recipes for... |
| [work](https://github.com/North-Shore-AI/work) | NSAI.Work - Unified job scheduler for North-Shore-AI platform |

### Data & Utilities

| Repository | Description |
|------------|-------------|
| [chz_ex](https://github.com/North-Shore-AI/chz_ex) | Elixir port of OpenAI's chz library - a powerful configuration mana... |
| [embed_ex](https://github.com/North-Shore-AI/embed_ex) | Vector embeddings service for Elixir—multi-provider support (OpenAI... |
| [ex_topology](https://github.com/North-Shore-AI/ex_topology) | Pure Elixir library for graph topology, TDA, and computational topo... |
| [nx_penalties](https://github.com/North-Shore-AI/nx_penalties) | Composable regularization penalties for Elixir Nx. L1/L2/Elastic Ne... |

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

_Updated 2025-12-31_
