# LiteLLM Copilot Proxy for Claude Code

This repo helps you use Github Models (Copilot) with Claude Code.

A LiteLLM proxy configuration that enables using GitHub Copilot as a backend for Claude Code and other AI tools.

## Overview

This project provides a Docker-based LiteLLM proxy that routes API requests through GitHub Copilot, giving you access to multiple AI models including:

- **OpenAI Models**: GPT-4.1, GPT-5, GPT-5.1 series
- **Anthropic Models**: Claude Haiku 4.5, Claude Sonnet 4/4.5, Claude Opus 4.5
- **Google Models**: Gemini 2.5 Pro, Gemini 3 Pro
- **xAI Models**: Grok Code Fast 1
- **Embedding Models**: text-embedding-3-small, text-embedding-ada-002

## Prerequisites

- Docker installed and running
- Claude code is installed (`curl -fsSL https://claude.ai/install.sh | bash`)
- GitHub account with an active Copilot subscription

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/matanbaruch/litellm-copilot-claude-code.git
   cd litellm-copilot-claude-code
   ```

2. Run the startup script:
   ```bash
   ./start-litellm.sh
   ```

3. Follow the authentication flow:
   - Watch the container logs: `docker logs -f litellm-proxy`
   - When prompted, visit https://github.com/login/device
   - Enter the device code to authenticate

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LITELLM_PORT` | `4000` | Port for the proxy server |
| `LITELLM_MASTER_KEY` | `sk-12345678` | API key for authenticating with the proxy |

### Claude Code Integration

Use environment variables:

```bash
export ANTHROPIC_BASE_URL=http://localhost:4000/v1
export ANTHROPIC_API_KEY=sk-12345678
export ANTHROPIC_MODEL=claude-sonnet-4.5
export ANTHROPIC_SMALL_FAST_MODEL=claude-haiku-4.5
```

Then run
```bash
claude
```

## Available Models

### General Availability
- `gpt-4.1`, `gpt-5`, `gpt-5-mini`
- `claude-haiku-4.5`, `claude-sonnet-4`, `claude-sonnet-4.5`, `claude-opus-4-5`
- `gemini-2.5-pro`
- `grok-code-fast-1`

### Public Preview
- `gpt-5-codex`, `gpt-5.1`, `gpt-5.1-codex`, `gpt-5.1-codex-mini`, `gpt-5.1-codex-max`, `gpt-5.2`
- `claude-opus-4-5-20251101`
- `gemini-3-pro`
- `raptor-mini`

## Troubleshooting

Verify the proxy is running:

```bash
curl http://localhost:4000/health
```

Verify Github Authentication

```bash
docker logs litellm-proxy
```

## License

MIT
