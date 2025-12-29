# North Shore AI Architecture

> Interactive version: [nsai.space/architecture](https://nsai.space/architecture.html)

This document provides architectural diagrams for the NSAI ecosystem. All diagrams are auto-generated from repository metadata and dependency analysis.

---

## Table of Contents

1. [System Overview](#system-overview)
2. [7-Tier Architecture](#7-tier-architecture)
3. [Crucible Reliability Stack](#crucible-reliability-stack)
4. [CNS Dialectical Reasoning](#cns-dialectical-reasoning)
5. [Metalworking Data Pipeline](#metalworking-data-pipeline)
6. [MLOps Pipeline](#mlops-pipeline)
7. [Infrastructure Layer](#infrastructure-layer)
8. [Cross-Cutting Dependencies](#cross-cutting-dependencies)

---

## System Overview

High-level view of all major subsystems and their relationships:

```mermaid
flowchart TB
    subgraph External["External Interfaces"]
        UI["crucible_ui<br/>cns_ui<br/>ingot"]
        Sites["nsai.online<br/>nsai.store<br/>nsai.space"]
    end

    subgraph Gateway["Gateway Layer"]
        GW[nsai_gateway]
        REG[nsai_registry]
    end

    subgraph Processing["Processing Domains"]
        subgraph Crucible["Crucible Stack"]
            CF[crucible_framework]
            CB[crucible_bench]
        end
        subgraph CNS["CNS Stack"]
            CNSCore[cns]
            CNSC[cns_crucible]
        end
        subgraph Metal["Metalworking"]
            Forge[forge]
            Anvil[anvil]
        end
    end

    subgraph MLOps["MLOps Assembly"]
        Train[crucible_train]
        Registry[crucible_model_registry]
        Deploy[crucible_deployment]
        Feedback[crucible_feedback]
    end

    subgraph Reliability["Reliability & Safety"]
        Ensemble[crucible_ensemble]
        Hedging[crucible_hedging]
        Guard[LlmGuard]
        XAI[crucible_xai]
    end

    subgraph Utilities["Foundational Utilities"]
        Tiktoken[tiktoken_ex]
        Embed[embed_ex]
        HFHub[hf_hub_ex]
        HFData[hf_datasets_ex]
    end

    UI --> GW
    Sites --> GW
    GW --> REG
    GW --> Crucible
    GW --> CNS
    GW --> Metal

    CF --> Ensemble
    CF --> Hedging
    CF --> XAI
    CF --> Train

    Train --> Registry
    Registry --> Deploy
    Deploy --> Feedback
    Feedback --> Train

    CNSCore --> CNSC
    CNSC --> CF

    Forge --> Anvil
    Anvil --> CF

    Ensemble --> Guard
    Hedging --> Guard

    Train --> Tiktoken
    Train --> Embed
    Train --> HFHub
    CF --> HFData

    classDef ui fill:#8b5cf6,stroke:#7c3aed,color:#fff
    classDef gateway fill:#f59e0b,stroke:#d97706,color:#000
    classDef crucible fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef cns fill:#10b981,stroke:#059669,color:#fff
    classDef metal fill:#ef4444,stroke:#dc2626,color:#fff
    classDef mlops fill:#6366f1,stroke:#4f46e5,color:#fff
    classDef reliability fill:#f97316,stroke:#ea580c,color:#fff
    classDef utility fill:#64748b,stroke:#475569,color:#fff

    class UI,Sites ui
    class GW,REG gateway
    class CF,CB crucible
    class CNSCore,CNSC cns
    class Forge,Anvil metal
    class Train,Registry,Deploy,Feedback mlops
    class Ensemble,Hedging,Guard,XAI reliability
    class Tiktoken,Embed,HFHub,HFData utility
```

---

## 7-Tier Architecture

The ecosystem is organized into seven distinct tiers, from user-facing interfaces down to foundational utilities:

```mermaid
flowchart TB
    subgraph T1["Tier 1: Public Interface"]
        direction LR
        nsai_sites["nsai_sites<br/>(Cloudflare Workers)"]
    end

    subgraph T2["Tier 2: Gateway & Orchestration"]
        direction LR
        nsai_gateway["nsai_gateway<br/>(Auth, Rate Limiting)"]
        nsai_registry["nsai_registry<br/>(Service Discovery)"]
    end

    subgraph T3["Tier 3: Processing Domains"]
        direction LR
        kitchen["Kitchen<br/>(Training)"]
        forge_t["Forge<br/>(Data)"]
        cns_t["CNS<br/>(Reasoning)"]
    end

    subgraph T4["Tier 4: Core Framework"]
        direction LR
        crucible_framework
        crucible_ir
        crucible_bench
    end

    subgraph T5["Tier 5: MLOps Assembly"]
        direction LR
        crucible_train
        crucible_model_registry
        crucible_deployment
        crucible_feedback
    end

    subgraph T6["Tier 6: Reliability & Safety"]
        direction LR
        LlmGuard
        crucible_ensemble
        crucible_hedging
        crucible_xai
        crucible_adversary
    end

    subgraph T7["Tier 7: Foundational Utilities"]
        direction LR
        tiktoken_ex
        embed_ex
        hf_hub_ex
        hf_datasets_ex
    end

    T1 --> T2
    T2 --> T3
    T3 --> T4
    T4 --> T5
    T4 --> T6
    T5 --> T7
    T6 --> T7

    classDef tier1 fill:#8b5cf6,stroke:#7c3aed,color:#fff
    classDef tier2 fill:#f59e0b,stroke:#d97706,color:#000
    classDef tier3 fill:#10b981,stroke:#059669,color:#fff
    classDef tier4 fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef tier5 fill:#6366f1,stroke:#4f46e5,color:#fff
    classDef tier6 fill:#f97316,stroke:#ea580c,color:#fff
    classDef tier7 fill:#64748b,stroke:#475569,color:#fff

    class nsai_sites tier1
    class nsai_gateway,nsai_registry tier2
    class kitchen,forge_t,cns_t tier3
    class crucible_framework,crucible_ir,crucible_bench tier4
    class crucible_train,crucible_model_registry,crucible_deployment,crucible_feedback tier5
    class LlmGuard,crucible_ensemble,crucible_hedging,crucible_xai,crucible_adversary tier6
    class tiktoken_ex,embed_ex,hf_hub_ex,hf_datasets_ex tier7
```

---

## Crucible Reliability Stack

The core ML experimentation and reliability platform:

```mermaid
flowchart TB
    subgraph Core["Core Framework"]
        framework[crucible_framework<br/><i>Pipeline orchestration</i>]
        ir[crucible_ir<br/><i>Intermediate representation</i>]
        bench[crucible_bench<br/><i>Statistical testing</i>]
    end

    subgraph Reliability["Reliability Primitives"]
        ensemble[crucible_ensemble<br/><i>Multi-model voting</i>]
        hedging[crucible_hedging<br/><i>Request hedging</i>]
        trace[crucible_trace<br/><i>Reasoning chains</i>]
    end

    subgraph Safety["Safety & Quality"]
        guard[LlmGuard<br/><i>AI firewall</i>]
        adversary[crucible_adversary<br/><i>Red teaming</i>]
        xai[crucible_xai<br/><i>Explainability</i>]
        fairness[ExFairness<br/><i>Bias detection</i>]
        datacheck[ExDataCheck<br/><i>Data validation</i>]
    end

    subgraph Instrumentation["Instrumentation"]
        telemetry[crucible_telemetry<br/><i>Metrics streaming</i>]
        harness[crucible_harness<br/><i>Experiment runner</i>]
    end

    subgraph Interface["User Interface"]
        ui[crucible_ui<br/><i>Phoenix dashboard</i>]
        examples[crucible_examples<br/><i>Interactive demos</i>]
    end

    framework --> ir
    framework --> bench
    framework --> ensemble
    framework --> hedging
    framework --> trace

    ensemble --> guard
    hedging --> guard

    framework --> adversary
    framework --> xai
    framework --> fairness
    framework --> datacheck

    framework --> telemetry
    harness --> framework
    harness --> telemetry

    ui --> telemetry
    ui --> framework
    examples --> framework

    classDef core fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef reliability fill:#10b981,stroke:#059669,color:#fff
    classDef safety fill:#ef4444,stroke:#dc2626,color:#fff
    classDef instrumentation fill:#f59e0b,stroke:#d97706,color:#000
    classDef interface fill:#8b5cf6,stroke:#7c3aed,color:#fff

    class framework,ir,bench core
    class ensemble,hedging,trace reliability
    class guard,adversary,xai,fairness,datacheck safety
    class telemetry,harness instrumentation
    class ui,examples interface
```

### Voting Strategies

```mermaid
flowchart LR
    subgraph Input
        Q[Query]
    end

    subgraph Models["Model Ensemble"]
        M1[Model A]
        M2[Model B]
        M3[Model C]
    end

    subgraph Voting["crucible_ensemble"]
        MAJ[Majority Vote]
        WGT[Weighted Vote]
        RCV[Ranked Choice]
        SEM[Semantic Similarity]
    end

    subgraph Output
        R[Final Response]
    end

    Q --> M1 & M2 & M3
    M1 & M2 & M3 --> MAJ & WGT & RCV & SEM
    MAJ & WGT & RCV & SEM --> R

    classDef input fill:#64748b,stroke:#475569,color:#fff
    classDef model fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef voting fill:#10b981,stroke:#059669,color:#fff
    classDef output fill:#f59e0b,stroke:#d97706,color:#000

    class Q input
    class M1,M2,M3 model
    class MAJ,WGT,RCV,SEM voting
    class R output
```

### Hedging Strategies

```mermaid
flowchart LR
    subgraph Request
        REQ[Incoming Request]
    end

    subgraph Hedging["crucible_hedging"]
        FIXED[Fixed Delay<br/><i>Send backup after Xms</i>]
        ADAPT[Adaptive<br/><i>Based on latency history</i>]
        PCT[Percentile<br/><i>p95/p99 threshold</i>]
        WORK[Workload-Aware<br/><i>Queue depth based</i>]
    end

    subgraph Backends
        B1[Backend 1]
        B2[Backend 2]
    end

    subgraph Response
        RESP[First Response Wins]
    end

    REQ --> FIXED & ADAPT & PCT & WORK
    FIXED & ADAPT & PCT & WORK --> B1 & B2
    B1 & B2 --> RESP

    classDef request fill:#64748b,stroke:#475569,color:#fff
    classDef hedging fill:#f97316,stroke:#ea580c,color:#fff
    classDef backend fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef response fill:#10b981,stroke:#059669,color:#fff

    class REQ request
    class FIXED,ADAPT,PCT,WORK hedging
    class B1,B2 backend
    class RESP response
```

---

## CNS Dialectical Reasoning

Chiral Narrative Synthesis for structured argumentation:

```mermaid
flowchart TB
    subgraph Input
        CLAIM[Initial Claim]
    end

    subgraph Proposer["Proposer Agent"]
        P_SNO[Extract SNOs<br/><i>Claims + Evidence</i>]
        P_THESIS[Form Thesis]
    end

    subgraph Antagonist["Antagonist Agent"]
        A_CONTRA[Find Contradictions]
        A_B1[Flag Beta-1 Gaps<br/><i>Missing evidence</i>]
        A_CHIRAL[Check Chirality<br/><i>Logical handedness</i>]
        A_ANTI[Form Antithesis]
    end

    subgraph Critics["Critic Ensemble"]
        C_GROUND[Grounding Critic<br/><i>Factual accuracy</i>]
        C_LOGIC[Logic Critic<br/><i>Argument validity</i>]
        C_NOVEL[Novelty Critic<br/><i>New information</i>]
        C_BIAS[Bias Critic<br/><i>Fairness check</i>]
        C_CAUSAL[Causal Critic<br/><i>Cause-effect validity</i>]
    end

    subgraph Synthesizer["Synthesizer Agent"]
        S_RESOLVE[Resolve Conflicts]
        S_SYNTH[Form Synthesis]
    end

    subgraph Output
        RESULT[Refined Claim<br/>+ Supporting Evidence]
    end

    CLAIM --> P_SNO --> P_THESIS
    P_THESIS --> A_CONTRA & A_B1 & A_CHIRAL --> A_ANTI

    P_THESIS --> C_GROUND & C_LOGIC & C_NOVEL & C_BIAS & C_CAUSAL
    A_ANTI --> C_GROUND & C_LOGIC & C_NOVEL & C_BIAS & C_CAUSAL

    C_GROUND & C_LOGIC & C_NOVEL & C_BIAS & C_CAUSAL --> S_RESOLVE
    A_ANTI --> S_RESOLVE
    S_RESOLVE --> S_SYNTH --> RESULT

    classDef input fill:#64748b,stroke:#475569,color:#fff
    classDef proposer fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef antagonist fill:#ef4444,stroke:#dc2626,color:#fff
    classDef critic fill:#f59e0b,stroke:#d97706,color:#000
    classDef synthesizer fill:#10b981,stroke:#059669,color:#fff
    classDef output fill:#8b5cf6,stroke:#7c3aed,color:#fff

    class CLAIM input
    class P_SNO,P_THESIS proposer
    class A_CONTRA,A_B1,A_CHIRAL,A_ANTI antagonist
    class C_GROUND,C_LOGIC,C_NOVEL,C_BIAS,C_CAUSAL critic
    class S_RESOLVE,S_SYNTH synthesizer
    class RESULT output
```

### SNO Graph Structure

```mermaid
flowchart TB
    subgraph SNO1["SNO: Climate Claim"]
        C1[Claim: Global temps rising]
        E1A[Evidence: NASA data]
        E1B[Evidence: NOAA records]
    end

    subgraph SNO2["SNO: Causal Attribution"]
        C2[Claim: Human activity cause]
        E2A[Evidence: CO2 correlation]
        E2B[Evidence: Industrial timeline]
    end

    subgraph SNO3["SNO: Counterclaim"]
        C3[Claim: Natural cycles exist]
        E3A[Evidence: Ice core data]
    end

    C1 --> C2
    E1A --> C1
    E1B --> C1
    E2A --> C2
    E2B --> C2
    C3 -.->|contradicts| C2
    E3A --> C3

    classDef claim fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef evidence fill:#10b981,stroke:#059669,color:#fff
    classDef counter fill:#ef4444,stroke:#dc2626,color:#fff

    class C1,C2 claim
    class E1A,E1B,E2A,E2B,E3A evidence
    class C3 counter
```

---

## Metalworking Data Pipeline

The data labeling stack using metalworking metaphors:

```mermaid
flowchart LR
    subgraph Raw["Raw Materials"]
        DATA[Unstructured Data<br/><i>Text, images, audio</i>]
    end

    subgraph Forge["Forge (forge)"]
        F_INGEST[Ingest]
        F_PARSE[Parse]
        F_SAMPLE[Generate Samples]
        F_TRANSFORM[Transform]
    end

    subgraph Anvil["Anvil (anvil)"]
        A_QUEUE[Label Queue]
        A_ASSIGN[Assignment]
        A_LABEL[Human Labeling]
        A_QC[Quality Control]
        A_IRR[Inter-Rater Reliability<br/><i>Cohen's Kappa</i>]
    end

    subgraph Ingot["Ingot (ingot)"]
        I_UI[Phoenix LiveView UI]
        I_REVIEW[Review Interface]
        I_EXPORT[Export Tools]
    end

    subgraph Crucible["Crucible (experimentation)"]
        C_TRAIN[Training]
        C_EVAL[Evaluation]
    end

    DATA --> F_INGEST --> F_PARSE --> F_SAMPLE --> F_TRANSFORM
    F_TRANSFORM --> A_QUEUE --> A_ASSIGN --> A_LABEL --> A_QC --> A_IRR
    A_IRR --> I_UI
    I_UI --> I_REVIEW --> I_EXPORT
    I_EXPORT --> C_TRAIN --> C_EVAL
    C_EVAL -.->|feedback| A_QUEUE

    classDef raw fill:#64748b,stroke:#475569,color:#fff
    classDef forge fill:#ef4444,stroke:#dc2626,color:#fff
    classDef anvil fill:#f59e0b,stroke:#d97706,color:#000
    classDef ingot fill:#10b981,stroke:#059669,color:#fff
    classDef crucible fill:#3b82f6,stroke:#2563eb,color:#fff

    class DATA raw
    class F_INGEST,F_PARSE,F_SAMPLE,F_TRANSFORM forge
    class A_QUEUE,A_ASSIGN,A_LABEL,A_QC,A_IRR anvil
    class I_UI,I_REVIEW,I_EXPORT ingot
    class C_TRAIN,C_EVAL crucible
```

---

## MLOps Pipeline

Training infrastructure using the Kitchen metaphor:

```mermaid
flowchart TB
    subgraph Kitchen["Kitchen (crucible_kitchen)"]
        K_PROVISION[Compute Provisioning]
        K_SCHEDULE[Job Scheduling]
        K_RESOURCE[Resource Management]
    end

    subgraph Cookbook["Cookbook (tinkex_cookbook)"]
        CB_RECIPE[Training Recipes]
        CB_CONFIG[Configurations]
        CB_TEMPLATE[Templates]
    end

    subgraph Training["Training (crucible_train)"]
        T_SUPERVISED[Supervised Learning]
        T_RL[Reinforcement Learning]
        T_DPO[Direct Preference Optimization]
        T_DISTILL[Distillation]
    end

    subgraph Registry["Registry (crucible_model_registry)"]
        R_VERSION[Versioning]
        R_ARTIFACT[Artifact Storage<br/><i>S3/HF/Local</i>]
        R_LINEAGE[Lineage Tracking]
    end

    subgraph Deployment["Deployment (crucible_deployment)"]
        D_VLLM[vLLM]
        D_OLLAMA[Ollama]
        D_TGI[TGI]
        D_K8S[Kubernetes]
        D_CANARY[Canary Rollout]
        D_BG[Blue/Green]
    end

    subgraph Feedback["Feedback (crucible_feedback)"]
        FB_INGEST[Feedback Ingestion]
        FB_DRIFT[Drift Detection]
        FB_ACTIVE[Active Learning]
        FB_TRIGGER[Retrain Triggers]
    end

    CB_RECIPE --> Kitchen
    CB_CONFIG --> Kitchen
    Kitchen --> Training

    T_SUPERVISED & T_RL & T_DPO & T_DISTILL --> Registry
    R_VERSION --> R_ARTIFACT --> R_LINEAGE

    Registry --> Deployment
    D_VLLM & D_OLLAMA & D_TGI --> D_K8S
    D_K8S --> D_CANARY & D_BG

    D_CANARY & D_BG --> Feedback
    FB_INGEST --> FB_DRIFT --> FB_ACTIVE --> FB_TRIGGER
    FB_TRIGGER -.->|retrain| Training

    classDef kitchen fill:#f59e0b,stroke:#d97706,color:#000
    classDef cookbook fill:#fbbf24,stroke:#f59e0b,color:#000
    classDef training fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef registry fill:#8b5cf6,stroke:#7c3aed,color:#fff
    classDef deployment fill:#10b981,stroke:#059669,color:#fff
    classDef feedback fill:#ef4444,stroke:#dc2626,color:#fff

    class K_PROVISION,K_SCHEDULE,K_RESOURCE kitchen
    class CB_RECIPE,CB_CONFIG,CB_TEMPLATE cookbook
    class T_SUPERVISED,T_RL,T_DPO,T_DISTILL training
    class R_VERSION,R_ARTIFACT,R_LINEAGE registry
    class D_VLLM,D_OLLAMA,D_TGI,D_K8S,D_CANARY,D_BG deployment
    class FB_INGEST,FB_DRIFT,FB_ACTIVE,FB_TRIGGER feedback
```

---

## Infrastructure Layer

Gateway, service discovery, and cross-cutting concerns:

```mermaid
flowchart TB
    subgraph External["External Clients"]
        WEB[Web Apps]
        CLI[CLI Tools]
        API[API Consumers]
    end

    subgraph Gateway["nsai_gateway"]
        G_AUTH[Authentication<br/><i>JWT/OAuth2</i>]
        G_RATE[Rate Limiting]
        G_ROUTE[Routing]
        G_CB[Circuit Breaker]
        G_TRACE[Distributed Tracing]
    end

    subgraph Registry["nsai_registry"]
        R_DISC[Service Discovery]
        R_HEALTH[Health Checking]
        R_LB[Load Balancing]
        R_MESH[Service Mesh]
    end

    subgraph Services["Internal Services"]
        S1[Crucible Services]
        S2[CNS Services]
        S3[MLOps Services]
    end

    subgraph Telemetry["Observability"]
        T_METRICS[Prometheus Metrics]
        T_LOGS[Structured Logging]
        T_SPANS[OpenTelemetry Spans]
    end

    WEB & CLI & API --> G_AUTH
    G_AUTH --> G_RATE --> G_ROUTE --> G_CB
    G_CB --> R_DISC
    R_DISC --> R_HEALTH --> R_LB
    R_LB --> S1 & S2 & S3

    G_TRACE --> T_SPANS
    S1 & S2 & S3 --> T_METRICS & T_LOGS
    R_HEALTH --> T_METRICS

    classDef external fill:#64748b,stroke:#475569,color:#fff
    classDef gateway fill:#f59e0b,stroke:#d97706,color:#000
    classDef registry fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef service fill:#10b981,stroke:#059669,color:#fff
    classDef telemetry fill:#8b5cf6,stroke:#7c3aed,color:#fff

    class WEB,CLI,API external
    class G_AUTH,G_RATE,G_ROUTE,G_CB,G_TRACE gateway
    class R_DISC,R_HEALTH,R_LB,R_MESH registry
    class S1,S2,S3 service
    class T_METRICS,T_LOGS,T_SPANS telemetry
```

---

## Cross-Cutting Dependencies

Shared utilities used across all subsystems:

```mermaid
flowchart TB
    subgraph Consumers["Consumer Projects"]
        C_CRUCIBLE[Crucible Stack]
        C_CNS[CNS Stack]
        C_MLOPS[MLOps Stack]
    end

    subgraph Tokenization["Tokenization"]
        tiktoken_ex[tiktoken_ex<br/><i>BPE tokenizer</i>]
    end

    subgraph Embeddings["Embeddings"]
        embed_ex[embed_ex<br/><i>Multi-provider vectors</i>]
    end

    subgraph HuggingFace["HuggingFace Integration"]
        hf_hub_ex[hf_hub_ex<br/><i>Hub API client</i>]
        hf_datasets_ex[hf_datasets_ex<br/><i>Datasets port</i>]
    end

    subgraph Datasets["Dataset Management"]
        datasets_ex[datasets_ex<br/><i>Custom datasets</i>]
        crucible_datasets[crucible_datasets<br/><i>Evaluation workflows</i>]
    end

    subgraph Math["Math & Statistics"]
        nx_penalties[nx_penalties<br/><i>Regularization</i>]
        ex_topology[ex_topology<br/><i>TDA</i>]
        crucible_bench[crucible_bench<br/><i>Statistical tests</i>]
    end

    subgraph Config["Configuration"]
        chz_ex[chz_ex<br/><i>CLI parsing</i>]
    end

    C_CRUCIBLE & C_CNS & C_MLOPS --> tiktoken_ex
    C_CRUCIBLE & C_CNS & C_MLOPS --> embed_ex
    C_MLOPS --> hf_hub_ex --> hf_datasets_ex
    C_CRUCIBLE --> datasets_ex --> crucible_datasets
    C_CRUCIBLE --> nx_penalties & ex_topology & crucible_bench
    C_CRUCIBLE & C_CNS & C_MLOPS --> chz_ex

    classDef consumer fill:#64748b,stroke:#475569,color:#fff
    classDef tokenization fill:#ef4444,stroke:#dc2626,color:#fff
    classDef embedding fill:#3b82f6,stroke:#2563eb,color:#fff
    classDef hf fill:#fbbf24,stroke:#f59e0b,color:#000
    classDef dataset fill:#10b981,stroke:#059669,color:#fff
    classDef math fill:#8b5cf6,stroke:#7c3aed,color:#fff
    classDef config fill:#f97316,stroke:#ea580c,color:#fff

    class C_CRUCIBLE,C_CNS,C_MLOPS consumer
    class tiktoken_ex tokenization
    class embed_ex embedding
    class hf_hub_ex,hf_datasets_ex hf
    class datasets_ex,crucible_datasets dataset
    class nx_penalties,ex_topology,crucible_bench math
    class chz_ex config
```

---

## Legend

| Color | Meaning |
|-------|---------|
| 🟦 Blue | Core framework / primary components |
| 🟩 Green | Synthesis / output / success paths |
| 🟥 Red | Antagonist / safety / critical checks |
| 🟨 Yellow/Orange | Gateway / infrastructure / warnings |
| 🟪 Purple | Interface / user-facing / telemetry |
| ⬜ Gray | External / input / utilities |

---

## Auto-Generation

This document is auto-generated by `scripts/generate_architecture.sh`. To regenerate:

```bash
./scripts/generate_architecture.sh
```

The script parses:
- Repository topics (`nshkr-*` labels)
- `mix.exs` dependency declarations
- README category mappings

---

_Last updated: 2025-12-29_
