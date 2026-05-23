<div align="center">
    <h1>META-REASONING-OFFLOAD (MRO): A FRAMEWORK FOR EDGE-CLOUD COLLABORATIVE REASONING</h1>
</div>

<h5 align="center">

 <br>

</h5>



## Introduction

<p float="left" align="middle">
  <img src="./imgs/overview.png" width="750">
</p>

Deploying Large Language Models (LLMs) on edge devices for complex multi-step reasoning is highly desirable for privacy and cost efficiency, yet fundamentally bottlenecked by hardware constraints. Existing edge-cloud collaborative frameworks typically rely on coarse-grained task-level routing or heavy Process Reward Models (PRMs) for step-level verification, which impose severe memory and latency overheads on edge GPUs. In this paper, we present Meta-Reasoning-Offload (MRO), a novel step-level collaborative inference framework designed to optimize the division of labor between edge and cloud models. To eliminate the “cognitive tax” of external verifiers, MRO introduces Edge-Autonomous Verification (P-TRUE), a training-free self-verification mechanism. P-TRUE leverages the edge draft model’s endogenous token probabilities to perform zero-shot logical evaluation of each reasoning step, perfectly reusing KV-cache for near-zero latency overhead. When the edge model predicts an impending logical failure, MRO dynamically offloads the context to a high-capacity cloud target model for targeted correction. Systematic evaluations on the NVIDIA Jetson AGX Orin demonstrate that MRO establishes a new Pareto-optimal deployment frontier. By precisely allocating computational resources, MRO reduces cloud API costs and token consumption by over 40% while preserving reasoning accuracy comparable to pure-cloud deployment.


## Installation
```shell
# For math evaluation
pip install -r requirements.txt 

# For using Skywork-PRM
git clone https://github.com/SkyworkAI/skywork-o1-prm-inference.git
cd skywork-o1-prm-inference
pip install -e .
```

## Efficient Decoding
**1. Preparation**

We mainly use [Qwen2.5-Math family](https://huggingface.co/collections/Qwen/qwen25-math-66eaa240a1b7d5ee65f1da3e) and [Skywork-o1-Open-PRM-Qwen-2.5-1.5B](https://huggingface.co/Skywork/Skywork-o1-Open-PRM-Qwen-2.5-1.5B). You need to change ``max_position_embeddings`` in their config.json from 4096 to 16384, which aims to avoid max_tokens error in vLLM. We only use the generation shorter than 4096, so this change won't affect the performance.

**2. Model serve**
```shell
bash scripts/serve_draft_model.sh
bash scripts/serve_target_model.sh
bash scripts/serve_prm.sh 
```

**3. Evaluation**
```shell
bash scripts/math_eval.sh
````

## Acknowledgement
The code base mainly builds on [RSD](https://github.com/BaohaoLiao/RSD) and [EdgeReasoning](https://github.com/edge-inference/edgereasoning).

