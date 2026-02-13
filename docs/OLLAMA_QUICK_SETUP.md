# Quick Setup for Other Machines

## Step 1: Find Your Ollama Server's Tailscale IP

On your Ollama server machine, run:
```bash
tailscale ip -4
```

Example output: `100.123.45.67`

## Step 2: Set Environment Variable on Other Machines

Add this to your shell config file (`~/.zshrc`, `~/.bashrc`, or `~/.config/fish/config.fish`):

```bash
export OLLAMA_ENDPOINT="http://100.123.45.67:11434"
```

Replace `100.123.45.67` with your actual Tailscale IP.

## Step 3: Verify Connection

Test the connection:
```bash
curl http://100.123.45.67:11434/api/tags
```

You should see a JSON response with available models.

## Step 4: Use in Neovim

Start Neovim and press `<leader>cll` to chat with Ollama!

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection refused | Verify Ollama is running: `curl http://100.123.45.67:11434/api/tags` |
| Tailscale not working | Run `tailscale status` on both machines |
| Model not found | Pull the model on the server: `ollama pull mistral` |
| Slow responses | Try a smaller model or check server resources |

## Available Keymaps

- `<leader>cll` - Chat with Ollama
- `<leader>cc` - Chat with Claude Haiku
- `<leader>cs` - Chat with Claude Sonnet
- `<leader>co` - Chat with Claude Opus
