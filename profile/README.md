# North Shore AI

**Reliability-first ML infrastructure on Elixir/BEAM**

> Building the ML reliability research ecosystem that Elixir deserves.

**51 repositories** | [nsai.online](https://nsai.online) | [nsai.space](https://nsai.space) | [nsai.store](https://nsai.store)

---

## Vision

The Elixir/BEAM platform provides technical capabilities essential for production AI systems that other runtimes cannot match: lightweight process isolation enables thousands of concurrent model calls without shared state corruption, supervisor trees provide automatic failure recovery without human intervention, and hot code upgrades allow model updates without service interruption. These are not conveniences but prerequisites for systems targeting 99%+ reliability in adversarial production environments.

North Shore AI builds ML infrastructure that leverages BEAM's unique properties. From statistical testing and ensemble voting to adversarial robustness and explainable AI, the stack addresses the full lifecycle of getting LLMs to behave predictably. The goal is world-class tooling that remains accessible to researchers and practitioners.

---

## Architecture

### The 7-Tiered Model

| Tier | Layer | Components |
|------|-------|------------|
| 1 | **Interface** | Phoenix LiveView dashboards (`crucible_ui`, `cns_ui`, `ingot`) |
| 2 | **Gateway** | API orchestration (`nsai_gateway`, `nsai_registry`) |
| 3 | **Processing** | Kitchen (training), Forge (data), CNS (reasoning) |
| 4 | **Core Framework** | Pipeline orchestration (`crucible_framework`, `crucible_ir`, `crucible_bench`) |
| 5 | **MLOps** | Training and deployment (`crucible_train`, `crucible_model_registry`, `crucible_deployment`) |
| 6 | **Reliability** | Safety and robustness (`LlmGuard`, `crucible_ensemble`, `crucible_hedging`) |
| 7 | **Utilities** | Foundational libraries (`tiktoken_ex`, `embed_ex`, `hf_hub_ex`) |

### Industrial Metaphors

**Kitchen/Cookbook** (Training Infrastructure): The training stack uses culinary terminology. The Kitchen (`crucible_kitchen`) provides backend-agnostic infrastructure. The Cookbook (`tinkex_cookbook`) contains declarative training recipes. Practitioners are chefs who use these to produce trained models.

**Metalworking** (Data Labeling): The data pipeline uses metalworking terminology. The Forge (`forge`) shapes raw data into structured samples. The Anvil (`anvil`) provides human-in-the-loop refinement and governance. Ingots (`ingot`) are production-ready Phoenix LiveView labeling interfaces. The Crucible is where refined data undergoes ML experimentation.

### CNS Dialectical Reasoning

Critic-Network Synthesis provides structured argumentation for AI reasoning transparency:

```
Proposer (thesis) -> Antagonist (antithesis) -> Synthesizer (synthesis)
     |                    |                         |
  Extract SNOs      Flag contradictions      Resolve with evidence
  (claims+evidence) (B1 gaps, chirality)    (critic-guided)
```

**Critics:** Grounding, Logic, Novelty, Bias, Causal

**Key Concepts:**
- **SNO (Structured Narrative Objects)**: Claims with supporting evidence
- **Beta-1 Gaps**: Missing supporting evidence
- **Chirality**: Logical handedness of arguments

---

## Repositories

<!-- AUTO_GENERATED_START -->
### Crucible Stack

| Repository | Description |
|------------|-------------|
| [ExDataCheck](https://github.com/North-Shore-AI/ExDataCheck) | Data validation and quality library for ML pipelines in Elixir |
| [ExFairness](https://github.com/North-Shore-AI/ExFairness) | Fairness and bias detection library for Elixir AI/ML systems |
| [LlmGuard](https://github.com/North-Shore-AI/LlmGuard) | AI Firewall and guardrails for LLM-based Elixir applications |
| [cns_crucible](https://github.com/North-Shore-AI/cns_crucible) |  |
| [crucible_adversary](https://github.com/North-Shore-AI/crucible_adversary) | Adversarial testing and robustness evaluation for the Crucible framework |
| [crucible_bench](https://github.com/North-Shore-AI/crucible_bench) | Statistical testing and analysis framework for AI research |
| [crucible_datasets](https://github.com/North-Shore-AI/crucible_datasets) | Dataset management and caching for AI research benchmarks |
| [crucible_deployment](https://github.com/North-Shore-AI/crucible_deployment) | ML model deployment for the Crucible ecosystem. vLLM and Ollama integration, ... |
| [crucible_ensemble](https://github.com/North-Shore-AI/crucible_ensemble) | Multi-model ensemble voting strategies for LLM reliability |
| [crucible_examples](https://github.com/North-Shore-AI/crucible_examples) | Interactive Phoenix LiveView demonstrations of the Crucible Framework - showc... |
| [crucible_feedback](https://github.com/North-Shore-AI/crucible_feedback) | ML feedback loop management for the Crucible ecosystem. Quality monitoring, d... |
| [crucible_framework](https://github.com/North-Shore-AI/crucible_framework) | CrucibleFramework: A scientific platform for LLM reliability research on the ... |
| [crucible_harness](https://github.com/North-Shore-AI/crucible_harness) | Experimental research framework for running AI benchmarks at scale |
| [crucible_hedging](https://github.com/North-Shore-AI/crucible_hedging) | Request hedging for tail latency reduction in distributed systems |
| [crucible_ir](https://github.com/North-Shore-AI/crucible_ir) | Intermediate Representation for the Crucible ML reliability ecosystem |
| [crucible_kitchen](https://github.com/North-Shore-AI/crucible_kitchen) | Industrial ML training orchestration - backend-agnostic workflow engine for s... |
| [crucible_model_registry](https://github.com/North-Shore-AI/crucible_model_registry) | ML model registry for the Crucible ecosystem. Artifact storage, model version... |
| [crucible_telemetry](https://github.com/North-Shore-AI/crucible_telemetry) | Advanced telemetry collection and analysis for AI research |
| [crucible_trace](https://github.com/North-Shore-AI/crucible_trace) | Structured causal reasoning chain logging for LLM transparency |
| [crucible_train](https://github.com/North-Shore-AI/crucible_train) | ML training orchestration for the Crucible ecosystem. Distributed training, h... |
| [crucible_ui](https://github.com/North-Shore-AI/crucible_ui) | Phoenix LiveView dashboard for the Crucible ML reliability stack |
| [crucible_xai](https://github.com/North-Shore-AI/crucible_xai) | Explainable AI (XAI) tools for the Crucible framework |
| [datasets_ex](https://github.com/North-Shore-AI/datasets_ex) | Dataset management library for ML experiments—loaders for SciFact, FEVER, GSM... |
| [eval_ex](https://github.com/North-Shore-AI/eval_ex) | Model evaluation harness for standardized benchmarking—comprehensive metrics ... |
| [hf_datasets_ex](https://github.com/North-Shore-AI/hf_datasets_ex) | HuggingFace Datasets for Elixir - A native Elixir port of the popular Hugging... |
| [metrics_ex](https://github.com/North-Shore-AI/metrics_ex) | Metrics aggregation and alerting for ML experiments—multi-backend export (Pro... |
| [training_ir](https://github.com/North-Shore-AI/training_ir) | Training IR for reproducible ML jobs across Crucible and Kitchen. Defines mod... |

### Ingot Stack

| Repository | Description |
|------------|-------------|
| [anvil](https://github.com/North-Shore-AI/anvil) | Labeling queue library for managing human labeling workflows |
| [forge](https://github.com/North-Shore-AI/forge) | Sample factory library for generating, transforming, and computing measuremen... |
| [ingot](https://github.com/North-Shore-AI/ingot) | Phoenix LiveView interface for sample generation and human labeling workflows |
| [labeling_ir](https://github.com/North-Shore-AI/labeling_ir) | Shared IR structs for the North Shore labeling stack (Forge/Anvil/Ingot) — ty... |

### AI Infrastructure

| Repository | Description |
|------------|-------------|
| [hf_hub_ex](https://github.com/North-Shore-AI/hf_hub_ex) | Elixir client for HuggingFace Hub—dataset/model metadata, file downloads, cac... |
| [hf_peft_ex](https://github.com/North-Shore-AI/hf_peft_ex) | Elixir port of HuggingFace's PEFT (Parameter-Efficient Fine-Tuning) library. ... |
| [nsai_gateway](https://github.com/North-Shore-AI/nsai_gateway) | Unified API gateway for the NSAI ecosystem—authentication (JWT, API keys, OAu... |
| [nsai_registry](https://github.com/North-Shore-AI/nsai_registry) | Service discovery and registry for the NSAI ecosystem—distributed registry wi... |
| [nsai_work](https://github.com/North-Shore-AI/nsai_work) | NSAI.Work - Unified job scheduler for North-Shore-AI platform |
| [pilot](https://github.com/North-Shore-AI/pilot) | Interactive CLI and REPL for the NSAI ecosystem—unified interface to registry... |
| [tiktoken_ex](https://github.com/North-Shore-AI/tiktoken_ex) | Pure Elixir TikToken-style byte-level BPE tokenizer (Kimi K2 compatible). |
| [tinkerer](https://github.com/North-Shore-AI/tinkerer) | Chiral Narrative Synthesis workspace for Thinker/Tinker LoRA pipelines, seman... |
| [tinkex](https://github.com/North-Shore-AI/tinkex) | Elixir SDK for the Tinker ML platform—LoRA training, sampling, and service or... |
| [tinkex_cookbook](https://github.com/North-Shore-AI/tinkex_cookbook) | Elixir port of tinker-cookbook: training and evaluation recipes for the Tinke... |

### AI SDKs

| Repository | Description |
|------------|-------------|
| [crucible_prompts](https://github.com/North-Shore-AI/crucible_prompts) | Prompt and parsing utilities for Crucible and NSAI. Provides templating, sche... |
| [nsai_llm](https://github.com/North-Shore-AI/nsai_llm) | Shared LLM Actions for NSAI runtimes. Wraps PortfolioCore adapters with Jido.... |

### Schema

| Repository | Description |
|------------|-------------|
| [batch_ir](https://github.com/North-Shore-AI/batch_ir) | Batch IR for standardized data interchange across training and inference back... |

### Research

| Repository | Description |
|------------|-------------|
| [cns](https://github.com/North-Shore-AI/cns) | Chiral Narrative Synthesis - Dialectical reasoning framework for automated kn... |
| [cns_ui](https://github.com/North-Shore-AI/cns_ui) | Phoenix LiveView interface for CNS dialectical reasoning experiments |

### Observability

| Repository | Description |
|------------|-------------|
| [lineage_ir](https://github.com/North-Shore-AI/lineage_ir) | Lineage IR for cross-system traces, spans, artifacts, and provenance edges. P... |

### Data

| Repository | Description |
|------------|-------------|
| [embed_ex](https://github.com/North-Shore-AI/embed_ex) | Vector embeddings service for Elixir—multi-provider support (OpenAI, Cohere, ... |
| [ex_topology](https://github.com/North-Shore-AI/ex_topology) | Pure Elixir library for graph topology, TDA, and computational topology |
| [nx_penalties](https://github.com/North-Shore-AI/nx_penalties) | Composable regularization penalties for Elixir Nx. L1/L2/Elastic Net, KL dive... |

### Utilities

| Repository | Description |
|------------|-------------|
| [chz_ex](https://github.com/North-Shore-AI/chz_ex) | Elixir port of OpenAI's chz library - a powerful configuration management sys... |


<!-- AUTO_GENERATED_END -->

---

## Resources

| Resource | Description |
|----------|-------------|
| [Interactive Architecture](https://nsai.space/architecture.html) | Visual architecture explorer |
| [Documentation](docs/ARCHITECTURE.md) | Full technical documentation |
| [@nshkrdotcom](https://github.com/nshkrdotcom) | Personal projects and AI systems |

---

**BEAM Native** | OTP supervision, telemetry, distributed resilience
**Research Backed** | Every feature tied to reliability research
**Production Ready** | Hex packages, documentation, test suites

_Updated 2026-02-26_
