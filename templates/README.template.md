# North Shore AI

**Reliability-first ML infrastructure on Elixir/BEAM**

> Building the ML reliability research ecosystem that Elixir deserves.

**{{REPO_COUNT}} repositories** | [nsai.online](https://nsai.online) | [nsai.space](https://nsai.space) | [nsai.store](https://nsai.store)

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
{{AUTO_GENERATED_CONTENT}}
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

_Updated {{UPDATE_DATE}}_
