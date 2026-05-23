#!/bin/bash

IMAGE="dustynv/vllm:0.8.6-r36.4-cu128-24.04"
CONTAINER_NAME="vllm_worker" # 给容器起个固定名字，方便管理
PROJECT_PATH="/home/yang/workspace/edgereasoning" # 宿主机路径

# 1. 尝试获取正在运行的容器 ID
CID=$(docker ps --filter "ancestor=${IMAGE}" --format "{{.ID}}" | head -n1)

# 2. 如果没有运行中的容器，则启动一个
if [ -z "$CID" ]; then
  echo "* No running container found. Starting a new one..."
  
  # 启动容器：后台运行 (-d), 自动删除 (--rm), 开启 NVIDIA 运行时, 挂载代码目录
  CID=$(docker run -d --rm --cap-add=NET_ADMIN \
    --name "$CONTAINER_NAME" \
    --runtime nvidia \
    --network host \
    -v "${PROJECT_PATH}:/workspace/edgereasoning" \
    -w /workspace/edgereasoning \
    "$IMAGE" \
    sleep infinity) 

  if [ -z "$CID" ]; then
    echo "ERROR: Failed to start docker container."
    exit 1
  fi
  echo "* Container started: $CID"
  
  # 如果是新启动的容器，强制执行安装逻辑（无视参数 1），确保环境可用
  FORCE_INSTALL=true
else
  echo "* Found running container: $CID"
  FORCE_INSTALL=false
fi

# 3. 安装依赖 (如果提供了参数且不是 '1'，或者容器是刚启动的)
if [ "$1" != "1" ] || [ "$FORCE_INSTALL" = true ]; then
  echo "* Setting up environment (Installing packages)..."

  APT_PACKAGES=(screen vim)
  PIP_PACKAGES=(datasets nvtx openpyxl matplotlib seaborn numpy pandas)

  docker exec -it "$CID" bash -c "
    apt update && \
    apt install -y ${APT_PACKAGES[*]} && \
    pip install --index-url https://pypi.org/simple ${PIP_PACKAGES[*]}
  "
else
  echo "* Skipping installation (container was already running and '1' provided)"
fi

# 4. 进入容器并切换到项目目录
echo "* Connecting to container workspace..."
exec docker exec -it "$CID" bash -c "cd /workspace/edgereasoning && exec bash"
