#!/bin/bash

# LiteLLM Gateway Proxy Startup Script for GitHub Copilot
# Requires: Docker, GitHub account with Copilot subscription

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/litellm_config.yaml"
CONTAINER_NAME="litellm-proxy"
PORT="${LITELLM_PORT:-4000}"
MASTER_KEY="${LITELLM_MASTER_KEY:-sk-12345678}"

# Token storage directory (mounted for OAuth persistence)
TOKEN_DIR="${HOME}/.config/litellm/github_copilot"
mkdir -p "$TOKEN_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting LiteLLM Gateway Proxy with GitHub Copilot${NC}"
echo "=================================================="

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Error: Config file not found at $CONFIG_FILE${NC}"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Stop existing container if running
if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
    echo -e "${YELLOW}Stopping existing container...${NC}"
    docker stop "$CONTAINER_NAME" > /dev/null
fi

# Remove existing container if exists
if docker ps -aq -f name="$CONTAINER_NAME" | grep -q .; then
    echo -e "${YELLOW}Removing existing container...${NC}"
    docker rm "$CONTAINER_NAME" > /dev/null
fi

# Pull latest image
echo -e "${YELLOW}Pulling latest LiteLLM image...${NC}"
docker pull docker.litellm.ai/berriai/litellm:main-latest

# Run the container
echo -e "${GREEN}Starting LiteLLM proxy on port $PORT...${NC}"
docker run -d \
    --name "$CONTAINER_NAME" \
    -v "$CONFIG_FILE:/app/config.yaml:ro" \
    -v "$TOKEN_DIR:/root/.config/litellm/github_copilot" \
    -p "$PORT:4000" \
    -e GITHUB_COPILOT_TOKEN_DIR="/root/.config/litellm/github_copilot" \
    -e LITELLM_MASTER_KEY="$MASTER_KEY" \
    docker.litellm.ai/berriai/litellm:main-latest \
    --config /app/config.yaml

echo ""
echo -e "${GREEN}Master Key: $MASTER_KEY${NC}"

echo ""
echo -e "${GREEN}LiteLLM proxy started successfully!${NC}"
echo ""
echo "=================================================="
echo -e "${YELLOW}IMPORTANT: First-time GitHub Copilot Authentication${NC}"
echo "=================================================="
echo "1. Watch the container logs for the device code:"
echo "   docker logs -f $CONTAINER_NAME"
echo ""
echo "2. When you see a device code, visit:"
echo "   https://github.com/login/device"
echo ""
echo "3. Enter the code to authenticate with GitHub Copilot"
echo ""
echo "=================================================="
echo -e "${GREEN}Claude Code Configuration${NC}"
echo "=================================================="
echo "Use environment variables:"
echo "  export ANTHROPIC_BASE_URL=http://localhost:$PORT/v1"
echo "  export ANTHROPIC_API_KEY=$MASTER_KEY"
echo "  export ANTHROPIC_MODEL=claude-sonnet-4.5"
echo "  export ANTHROPIC_SMALL_FAST_MODEL=claude-haiku-4.5"
echo ""
echo "=================================================="
echo "Proxy URL: http://localhost:$PORT"
echo "Health check: curl http://localhost:$PORT/health"
echo "=================================================="
