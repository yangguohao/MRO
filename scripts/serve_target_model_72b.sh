#!/bin/bash

hostname --ip-address
MODEL="unsloth/Qwen2.5-Math-72B-Instruct-bnb-4bit"
MODEL_NAME="Qwen2.5-Math-72B-Instruct-bnb-4bit"

export CUDA_VISIBLE_DEVICES=2,3
python -m vllm.entrypoints.openai.api_server \
        --model $MODEL \
        --quantization bitsandbytes \
        --load-format bitsandbytes \
        --served-model-name $MODEL_NAME \
        --tensor-parallel-size 1 \
        --pipeline-parallel-size 2 \
        --port 12341 \
        --host 0.0.0.0 \
        --trust-remote-code \
        --max-model-len 8192 \
        --enable-prefix-caching \
        --gpu_memory_utilization 0.95 \
        --dtype float16 \
        --enforce-eager \



