# Network Architecture Diagram

## Setup Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        TAILSCALE NETWORK                         │
│                    (Encrypted VPN Tunnel)                        │
└─────────────────────────────────────────────────────────────────┘
         │                                              │
         │                                              │
    ┌────▼─────────────────┐              ┌────────────▼──────────┐
    │  OLLAMA SERVER       │              │  OTHER MACHINES       │
    │  (Main Machine)      │              │  (Laptop, Desktop)    │
    │                      │              │                       │
    │  ┌────────────────┐  │              │  ┌────────────────┐   │
    │  │ Ollama Service │  │              │  │ Neovim +       │   │
    │  │ :11434         │  │              │  │ CodeCompanion  │   │
    │  └────────────────┘  │              │  └────────────────┘   │
    │         ▲            │              │         ▲             │
    │         │            │              │         │             │
    │  ┌──────┴──────────┐ │              │  ┌──────┴──────────┐  │
    │  │ Tailscale IP:   │ │              │  │ OLLAMA_ENDPOINT │  │
    │  │ 100.123.45.67   │ │              │  │ env variable    │  │
    │  └─────────────────┘ │              │  │ 100.123.45.67   │  │
    │                      │              │  └─────────────────┘  │
    └──────────────────────┘              └──────────────────────┘
         │                                              │
         │                                              │
         └──────────────────┬───────────────────────────┘
                            │
                    ┌───────▼────────┐
                    │ Tailscale VPN  │
                    │ Encrypted Link │
                    └────────────────┘
```

## Data Flow

### Scenario 1: Local Ollama Access (Main Machine)

```
Neovim (localhost)
    │
    ├─ <leader>cll pressed
    │
    ├─ CodeCompanion loads Ollama adapter
    │
    ├─ Reads OLLAMA_ENDPOINT env var
    │  (not set, uses default)
    │
    ├─ Connects to http://localhost:11434
    │
    └─ Ollama Service
       │
       ├─ Loads model (mistral)
       │
       └─ Returns response
```

### Scenario 2: Remote Ollama Access (Other Machine)

```
Neovim (other machine)
    │
    ├─ <leader>cll pressed
    │
    ├─ CodeCompanion loads Ollama adapter
    │
    ├─ Reads OLLAMA_ENDPOINT env var
    │  (set to http://100.123.45.67:11434)
    │
    ├─ Connects via Tailscale VPN
    │
    ├─ Tailscale Network
    │  (Encrypted tunnel)
    │
    └─ Ollama Service (on main machine)
       │
       ├─ Loads model (mistral)
       │
       └─ Returns response
```

## Configuration Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│ CodeCompanion Ollama Adapter Configuration                  │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
        ┌─────────────────────────────────┐
        │ Check OLLAMA_ENDPOINT env var   │
        └─────────────────────────────────┘
                          │
                ┌─────────┴─────────┐
                │                   │
            Set?                Not Set?
                │                   │
                ▼                   ▼
        ┌──────────────┐    ┌──────────────────┐
        │ Use env var  │    │ Use default:     │
        │ value        │    │ localhost:11434  │
        └──────────────┘    └──────────────────┘
                │                   │
                └─────────┬─────────┘
                          │
                          ▼
        ┌─────────────────────────────────┐
        │ Connect to Ollama Service       │
        └─────────────────────────────────┘
```

## Model Selection Flow

```
User presses <leader>cll
    │
    ▼
CodeCompanion opens chat window
    │
    ▼
Loads Ollama adapter
    │
    ├─ Checks schema.model.default
    │  (currently: "mistral")
    │
    ▼
Connects to Ollama endpoint
    │
    ├─ Requests model: mistral
    │
    ▼
Ollama loads model into memory
    │
    ├─ If not loaded, pulls from registry
    │
    ▼
Ready for chat
    │
    ├─ User types message
    │
    ▼
Ollama generates response
    │
    ▼
Response displayed in Neovim
```

## Environment Variable Resolution

```
Machine A (Ollama Server)
├─ OLLAMA_ENDPOINT not set
├─ CodeCompanion uses: http://localhost:11434
└─ Connects to local Ollama

Machine B (Other Machine)
├─ OLLAMA_ENDPOINT="http://100.123.45.67:11434"
├─ CodeCompanion uses: http://100.123.45.67:11434
└─ Connects via Tailscale to Machine A's Ollama

Machine C (Another Machine)
├─ OLLAMA_ENDPOINT="http://100.123.45.67:11434"
├─ CodeCompanion uses: http://100.123.45.67:11434
└─ Connects via Tailscale to Machine A's Ollama
```

## Adapter Priority

```
CodeCompanion Strategies
│
├─ Chat Strategy
│  └─ adapter: "anthropic_haiku" (default)
│     └─ Can switch to "ollama" with <leader>cll
│
├─ Inline Strategy
│  └─ adapter: "anthropic_haiku" (default)
│     └─ Can switch to "ollama" if needed
│
└─ Available Adapters
   ├─ anthropic (Claude Sonnet)
   ├─ anthropic_opus (Claude Opus)
   ├─ anthropic_haiku (Claude Haiku)
   └─ ollama (Local or Remote)
```

## Tailscale Network Benefits

```
Without Tailscale:
┌──────────────┐         ┌──────────────┐
│ Machine A    │         │ Machine B    │
│ (Ollama)     │         │ (Neovim)     │
└──────────────┘         └──────────────┘
       │                        │
       └────────────────────────┘
       Direct IP (exposed, insecure)

With Tailscale:
┌──────────────┐         ┌──────────────┐
│ Machine A    │         │ Machine B    │
│ (Ollama)     │         │ (Neovim)     │
└──────────────┘         └──────────────┘
       │                        │
       └────────────────────────┘
       Encrypted VPN Tunnel (secure)
       Private Tailscale IPs only
```

## Recommended Model Sizes

```
Network Latency Impact:
┌─────────────────────────────────────────┐
│ Model Size │ Speed │ Quality │ Latency │
├─────────────────────────────────────────┤
│ 3B         │ ⚡⚡⚡ │ ⭐⭐   │ Low     │
│ 7B         │ ⚡⚡  │ ⭐⭐⭐ │ Medium  │
│ 13B        │ ⚡   │ ⭐⭐⭐ │ Medium  │
│ 8x7B (MoE) │ ⚡   │ ⭐⭐⭐⭐│ High    │
└─────────────────────────────────────────┘

For Tailscale (network latency):
Recommended: 7B models (mistral, neural-chat)
Good balance of speed and quality
```
