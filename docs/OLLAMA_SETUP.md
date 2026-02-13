# CodeCompanion + Ollama Setup Guide

This guide explains how to use Ollama with CodeCompanion across your network via Tailscale.

## Overview

Your CodeCompanion configuration now supports both Claude (via Anthropic API) and Ollama models. You can:
- Use Ollama locally on your main machine
- Access Ollama from other machines on your network via Tailscale
- Switch between Claude and Ollama models seamlessly

## Prerequisites

### On Your Ollama Server Machine

1. **Install Ollama** (if not already done)
   ```bash
   curl -fsSL https://ollama.ai/install.sh | sh
   ```

2. **Start Ollama with network binding**
   
   By default, Ollama only listens on `localhost:11434`. To access it from other machines, you need to expose it to your network:
   
   ```bash
   # Option 1: Run Ollama with network binding (temporary)
   OLLAMA_HOST=0.0.0.0:11434 ollama serve
   
   # Option 2: Set it permanently in systemd (recommended)
   sudo systemctl edit ollama
   ```
   
   Add this to the systemd service file:
   ```ini
   [Service]
   Environment="OLLAMA_HOST=0.0.0.0:11434"
   ```
   
   Then restart:
   ```bash
   sudo systemctl restart ollama
   ```

3. **Pull a model** (if not already done)
   ```bash
   ollama pull mistral
   # Or try other models:
   # ollama pull neural-chat
   # ollama pull dolphin-mixtral
   # ollama pull llama2
   ```

4. **Find your Tailscale IP**
   ```bash
   tailscale ip -4
   # Output example: 100.123.45.67
   ```

## Configuration

### On Your Main Machine (with Ollama)

**Default behavior:** The config will use `http://localhost:11434` automatically.

To override, set the environment variable:
```bash
export OLLAMA_ENDPOINT="http://localhost:11434"
```

### On Other Machines (without Ollama)

Set the `OLLAMA_ENDPOINT` environment variable to point to your Ollama server's Tailscale IP:

```bash
export OLLAMA_ENDPOINT="http://100.123.45.67:11434"
```

**Make it persistent** by adding to your shell config (`~/.zshrc`, `~/.bashrc`, etc.):
```bash
export OLLAMA_ENDPOINT="http://100.123.45.67:11434"
```

## Usage

### Keymaps

- **`<leader>cll`** - Toggle chat with Ollama (normal and visual modes)
- **`<leader>cc`** - Toggle chat with Claude Haiku (default)
- **`<leader>cs`** - Toggle chat with Claude Sonnet
- **`<leader>co`** - Toggle chat with Claude Opus
- **`<leader>ca`** - Show CodeCompanion actions
- **`<leader>cm`** - Show current model

### Switching Models

You can also use the `:CodeCompanionSwitchModel` command:
```vim
:CodeCompanionSwitchModel haiku
:CodeCompanionSwitchModel sonnet
:CodeCompanionSwitchModel opus
```

To add Ollama to this command, you would need to extend the configuration.

## Troubleshooting

### "Connection refused" error

**Problem:** You're getting connection errors when trying to use Ollama.

**Solutions:**
1. Verify Ollama is running: `curl http://localhost:11434/api/tags`
2. Check if it's bound to the network: `sudo netstat -tlnp | grep 11434`
3. Verify Tailscale connectivity: `ping 100.x.x.x` (use the Tailscale IP)
4. Check firewall: `sudo ufw status` (if using UFW)

### "Model not found" error

**Problem:** The model you specified doesn't exist on the Ollama server.

**Solution:**
1. List available models: `curl http://localhost:11434/api/tags`
2. Pull the model: `ollama pull mistral`
3. Update the default model in `lua/shelbybark/plugins/codecompanion.lua` if needed

### Slow responses

**Problem:** Responses are very slow.

**Causes & Solutions:**
1. **Network latency**: Tailscale adds minimal overhead, but check your network
2. **Model size**: Larger models (7B+) are slower. Try smaller models like `mistral` or `neural-chat`
3. **Server resources**: Check CPU/RAM on the Ollama server with `top` or `htop`

### Tailscale not connecting

**Problem:** Can't reach the Ollama server via Tailscale IP.

**Solutions:**
1. Verify Tailscale is running: `tailscale status`
2. Check both machines are on the same Tailscale network
3. Verify the Tailscale IP is correct: `tailscale ip -4`
4. Check firewall rules on the Ollama server

## Recommended Models for CodeCompanion

| Model | Size | Speed | Quality | Best For |
|-------|------|-------|---------|----------|
| mistral | 7B | Fast | Good | General coding |
| neural-chat | 7B | Fast | Good | Chat/conversation |
| dolphin-mixtral | 8x7B | Slower | Excellent | Complex tasks |
| llama2 | 7B/13B | Medium | Good | General purpose |
| orca-mini | 3B | Very Fast | Fair | Quick answers |

## Advanced Configuration

### Custom Model Selection

To change the default Ollama model, edit `lua/shelbybark/plugins/codecompanion.lua`:

```lua
schema = {
    model = {
        default = "neural-chat",  -- Change this to your preferred model
    },
},
```

### Multiple Ollama Servers

If you have multiple Ollama servers, you can create multiple adapters:

```lua
ollama_main = function()
    return require("codecompanion.adapters").extend("ollama", {
        env = { url = "http://100.123.45.67:11434" },
        schema = { model = { default = "mistral" } },
    })
end,
ollama_backup = function()
    return require("codecompanion.adapters").extend("ollama", {
        env = { url = "http://100.123.45.68:11434" },
        schema = { model = { default = "neural-chat" } },
    })
end,
```

Then add keymaps for each.

## Performance Tips

1. **Use smaller models** for faster responses (mistral, neural-chat)
2. **Run Ollama on a machine with good specs** (8GB+ RAM, modern CPU)
3. **Keep Tailscale updated** for best network performance
4. **Monitor network latency** with `ping` to your Ollama server
5. **Consider running Ollama on GPU** if available for faster inference

## References

- [Ollama Documentation](https://github.com/ollama/ollama)
- [Tailscale Documentation](https://tailscale.com/kb/)
- [CodeCompanion Documentation](https://github.com/olimorris/codecompanion.nvim)
