# North Shore AI

Reliability-first AI infrastructure built on the Elixir/BEAM stack. We design, verify, and harden large language model systems so they behave predictably in production.

## Mission

- Deliver 99%+ LLM reliability through ensembles, request hedging, and rigorous statistical testing.  
- Bring research-grade tooling to Elixir teams so reliability work is reproducible, observable, and automatable.  
- Share battle-tested patterns, from guardrails to telemetry pipelines, with the open-source community.

## Crucible Reliability Stack

| Project | What it adds |
| --- | --- |
| [crucible_framework](https://github.com/North-Shore-AI/crucible_framework) | Documentation hub that ties the full stack together and captures research playbooks. |
| [crucible_bench](https://github.com/North-Shore-AI/crucible_bench) | Statistical harness with 15+ significance tests, effect sizes, and power analysis. |
| [crucible_ensemble](https://github.com/North-Shore-AI/crucible_ensemble) | Elastic multi-model voting for higher accuracy and graceful degradation. |
| [crucible_hedging](https://github.com/North-Shore-AI/crucible_hedging) | Tail-latency insurance with adaptive hedged requests and circuit breaking. |
| [crucible_trace](https://github.com/North-Shore-AI/crucible_trace) | Causal chain logging so every token has an attributable decision path. |
| [crucible_datasets](https://github.com/North-Shore-AI/crucible_datasets) | Unified access to benchmark suites like MMLU, HumanEval, GSM8K, cached for BEAM workloads. |
| [crucible_telemetry](https://github.com/North-Shore-AI/crucible_telemetry) | Research-grade instrumentation and metrics streaming across experiments. |
| [crucible_harness](https://github.com/North-Shore-AI/crucible_harness) | Automated experiment orchestration, reproducible runs, and reporting pipelines. |
| [crucible_examples](https://github.com/North-Shore-AI/crucible_examples) | LiveView-driven demos showing how the stack fits together in real systems. |

## Reliability & Safety Libraries

- [ExDataCheck](https://github.com/North-Shore-AI/ExDataCheck): Great Expectations-inspired data validation for Elixir ML pipelines with 22+ expectations, drift detection, and quality scoring.  
- [ExFairness](https://github.com/North-Shore-AI/ExFairness): Fairness metrics, bias diagnostics, and mitigation tooling to keep model outcomes equitable.  
- [LlmGuard](https://github.com/North-Shore-AI/LlmGuard): AI firewall and guardrails for LLM applications with prompt-injection, jailbreak, and PII detection.

## How We Work

- **Research Backed**: See the [AI Reliability Ecosystem Survey](https://github.com/North-Shore-AI/North-Shore-AI/blob/main/AI_Reliability_Ecosystem_Survey.md) for the strategy behind our roadmap.  
- **BEAM Native**: Everything runs on OTP processes, leveraging supervision trees, telemetry, and distributed resilience.  
- **Operational Focus**: Every repo ships with Hex.pm packages, docs, and automated test suites—ready for production integration.

## Get Involved

- Star or watch the repositories you rely on to stay up to date with releases.  
- Open issues with real reliability pain points—we prioritize features that unblock teams shipping critical workloads.  
- Interested in research collaborations or enterprise support? Reach out via [@nshkrdotcom](https://github.com/nshkrdotcom) or start a discussion in any repo.

---

_North Shore AI — building trustworthy AI systems from the ground up._
