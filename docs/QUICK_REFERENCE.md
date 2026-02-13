# Quick Reference Card

## 🎯 At a Glance

```
┌─────────────────────────────────────────────────────────────┐
│ CodeCompanion + Ollama + Tailscale Integration             │
│ Quick Reference Card                                        │
└─────────────────────────────────────────────────────────────┘
```

## ⌨️ Keymaps

| Keymap | Action | Mode |
|--------|--------|------|
| `<leader>cll` | Chat with Ollama | Normal, Visual |
| `<leader>cc` | Chat with Claude Haiku | Normal, Visual |
| `<leader>cs` | Chat with Claude Sonnet | Normal, Visual |
| `<leader>co` | Chat with Claude Opus | Normal, Visual |
| `<leader>ca` | Show CodeCompanion actions | Normal, Visual |
| `<leader>cm` | Show current model | Normal |

## 🔧 Setup Checklist

### On Ollama Server
- [ ] `sudo systemctl edit ollama` → Add `Environment="OLLAMA_HOST=0.0.0.0:11434"`
- [ ] `sudo systemctl restart ollama`
- [ ] `ollama pull mistral` (or your preferred model)
- [ ] `tailscale ip -4` → Note the IP (e.g., 100.123.45.67)

### On Other Machines
- [ ] Add to `~/.zshrc` (or `~/.bashrc`):
  ```bash
  export OLLAMA_ENDPOINT="http://100.123.45.67:11434"
  ```
- [ ] `source ~/.zshrc` (reload shell)
- [ ] `curl $OLLAMA_ENDPOINT/api/tags` (test connection)
- [ ] Start Neovim and press `<leader>cll`

## 🧪 Quick Tests

```bash
# Test Ollama is running
curl http://localhost:11434/api/tags

# Test remote access
curl http://100.x.x.x:11434/api/tags

# Test Tailscale
tailscale status
ping 100.x.x.x

# List models
ollama list

# Pull a model
ollama pull mistral
```

## 📊 Model Comparison

```
┌──────────────┬──────┬───────┬─────────┬──────────────┐
│ Model        │ Size │ Speed │ Quality │ Best For     │
├──────────────┼──────┼───────┼─────────┼──────────────┤
│ orca-mini    │ 3B   │ ⚡⚡⚡ │ ⭐⭐   │ Quick answers│
│ mistral      │ 7B   │ ⚡⚡  │ ⭐⭐⭐ │ Coding       │
│ neural-chat  │ 7B   │ ⚡⚡  │ ⭐⭐⭐ │ Chat         │
│ llama2       │ 7B   │ ⚡⚡  │ ⭐⭐⭐ │ General      │
│ dolphin-mix  │ 8x7B │ ⚡   │ ⭐⭐⭐⭐│ Complex      │
└──────────────┴──────┴───────┴─────────┴──────────────┘
```

## 🔍 Troubleshooting Quick Fixes

| Problem | Quick Fix |
|---------|-----------|
| Connection refused | `ps aux \| grep ollama` (check if running) |
| Model not found | `ollama pull mistral` |
| Can't reach remote | `ping 100.x.x.x` (check Tailscale) |
| Env var not working | `echo $OLLAMA_ENDPOINT` (verify it's set) |
| Slow responses | Try smaller model: `ollama pull orca-mini` |

## 📁 Important Files

| File | Purpose |
|------|---------|
| `lua/shelbybark/plugins/codecompanion.lua` | Main config (modified) |
| `docs/OLLAMA_SETUP.md` | Full setup guide |
| `docs/TROUBLESHOOTING.md` | Detailed troubleshooting |
| `docs/ARCHITECTURE.md` | Network diagrams |
| `docs/IMPLEMENTATION_CHECKLIST.md` | Step-by-step checklist |

## 🌐 Network Setup

```
Machine A (Ollama Server)
├─ Ollama: http://localhost:11434
├─ Tailscale IP: 100.123.45.67
└─ OLLAMA_HOST=0.0.0.0:11434

Machine B (Client)
├─ OLLAMA_ENDPOINT=http://100.123.45.67:11434
└─ Connects via Tailscale VPN

Machine C (Client)
├─ OLLAMA_ENDPOINT=http://100.123.45.67:11434
└─ Connects via Tailscale VPN
```

## 💾 Environment Variable

```bash
# Add to ~/.zshrc, ~/.bashrc, or ~/.config/fish/config.fish
export OLLAMA_ENDPOINT=\"http://100.123.45.67:11434\"

# Then reload
source ~/.zshrc  # or ~/.bashrc
```

## 🚀 Usage Flow

```
1. Press <leader>cll
   ↓
2. CodeCompanion opens chat window
   ↓
3. Reads OLLAMA_ENDPOINT env var
   ↓
4. Connects to Ollama server
   ↓
5. Type message and press Enter
   ↓
6. Ollama generates response
   ↓
7. Response appears in Neovim
```

## 📞 Help Commands

```bash
# Check Ollama status
sudo systemctl status ollama

# View Ollama logs
journalctl -u ollama -f

# List available models
ollama list

# Pull a model
ollama pull <model-name>

# Check Tailscale
tailscale status

# Find your Tailscale IP
tailscale ip -4

# Test connection
curl http://localhost:11434/api/tags
curl http://100.x.x.x:11434/api/tags
```

## ⚡ Performance Tips

1. **Use 7B models** for best balance (mistral, neural-chat)
2. **Avoid 13B+ models** on slow networks
3. **Monitor latency**: `ping 100.x.x.x` (should be < 50ms)
4. **Run on GPU** if available for faster inference
5. **Close other apps** to free up resources

## 🔐 Security Checklist

- ✅ Ollama only accessible via Tailscale
- ✅ All traffic encrypted end-to-end
- ✅ Uses private Tailscale IPs (100.x.x.x)
- ✅ No exposure to public internet
- ✅ Firewall rules can further restrict access

## 📋 Common Commands

```bash
# Start Ollama
ollama serve

# Or with systemd
sudo systemctl start ollama

# Pull a model
ollama pull mistral

# List models
ollama list

# Remove a model
ollama rm mistral

# Test connection
curl http://localhost:11434/api/tags | jq '.models[].name'

# Check Tailscale
tailscale status

# Restart Ollama
sudo systemctl restart ollama
```

## 🎓 Learning Resources

- Ollama: https://github.com/ollama/ollama
- Tailscale: https://tailscale.com/kb/
- CodeCompanion: https://github.com/olimorris/codecompanion.nvim
- Neovim: https://neovim.io/

## 📝 Notes

- Default model: `mistral` (change in codecompanion.lua line 40)
- Default endpoint: `http://localhost:11434` (override with env var)
- Keymaps use `<leader>` (usually `\` or `,`)
- All documentation in `docs/` folder

---

**Print this card and keep it handy!**

**Last Updated**: 2026-02-05
