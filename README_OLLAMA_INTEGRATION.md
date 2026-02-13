# CodeCompanion + Ollama + Tailscale Integration

## 🎯 What This Does

This setup allows you to use Ollama (local LLM) with CodeCompanion across your entire Tailscale network. You can:

- ✅ Use Ollama locally on your main machine
- ✅ Access Ollama from other machines via Tailscale (no local Ollama needed)
- ✅ Switch between Claude and Ollama models instantly
- ✅ Keep your configuration synced across machines
- ✅ Maintain privacy with encrypted Tailscale connections

## 🚀 Quick Start

### Step 1: On Your Ollama Server (Main Machine)

```bash
# Ensure Ollama listens on all interfaces
sudo systemctl edit ollama
# Add: Environment=\"OLLAMA_HOST=0.0.0.0:11434\"
# Save and exit
sudo systemctl restart ollama

# Pull a model
ollama pull mistral

# Find your Tailscale IP
tailscale ip -4
# Note this down (e.g., 100.123.45.67)
```

### Step 2: On Other Machines

Add to your shell config (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
export OLLAMA_ENDPOINT=\"http://100.123.45.67:11434\"
```

Replace `100.123.45.67` with your actual Tailscale IP.

### Step 3: Use in Neovim

```vim
\" Press <leader>cll to chat with Ollama
\" Press <leader>cc to chat with Claude
\" Press <leader>ca to see all actions
```

## 📁 Files Changed/Created

### Modified
- `lua/shelbybark/plugins/codecompanion.lua` - Added Ollama adapter and keymaps

### Created Documentation
- `docs/OLLAMA_SETUP.md` - Comprehensive setup guide
- `docs/OLLAMA_QUICK_SETUP.md` - Quick reference
- `docs/ARCHITECTURE.md` - Network architecture diagrams
- `docs/TROUBLESHOOTING.md` - Common issues and solutions
- `docs/IMPLEMENTATION_CHECKLIST.md` - Step-by-step checklist
- `docs/INTEGRATION_SUMMARY.md` - Overview of changes
- `docs/ollama_env_example.sh` - Shell configuration example

## 🔑 Key Features

### Environment-Based Configuration
```lua
-- Automatically reads OLLAMA_ENDPOINT environment variable
local ollama_endpoint = os.getenv(\"OLLAMA_ENDPOINT\") or \"http://localhost:11434\"
```

### Easy Model Switching
- `<leader>cll` - Ollama
- `<leader>cc` - Claude Haiku
- `<leader>cs` - Claude Sonnet
- `<leader>co` - Claude Opus

### Network-Aware
- Works locally without any configuration
- Works remotely with just one environment variable
- Secure via Tailscale encryption

## 🏗️ Architecture

```
Your Machines (Tailscale Network)
│
├─ Machine A (Ollama Server)
│  └─ Ollama Service :11434
│     └─ Tailscale IP: 100.123.45.67
│
├─ Machine B (Laptop)
│  └─ Neovim + CodeCompanion
│     └─ OLLAMA_ENDPOINT=http://100.123.45.67:11434
│
└─ Machine C (Desktop)
   └─ Neovim + CodeCompanion
      └─ OLLAMA_ENDPOINT=http://100.123.45.67:11434
```

## 📋 Configuration Details

### Ollama Adapter
- **Location**: `lua/shelbybark/plugins/codecompanion.lua` (lines 30-45)
- **Default Model**: `mistral` (7B, fast and capable)
- **Endpoint**: Reads from `OLLAMA_ENDPOINT` env var
- **Fallback**: `http://localhost:11434`

### Available Models
| Model | Size | Speed | Quality | Best For |
|-------|------|-------|---------|----------|
| mistral | 7B | ⚡⚡ | ⭐⭐⭐ | General coding |
| neural-chat | 7B | ⚡⚡ | ⭐⭐⭐ | Conversation |
| orca-mini | 3B | ⚡⚡⚡ | ⭐⭐ | Quick answers |
| llama2 | 7B/13B | ⚡⚡ | ⭐⭐⭐ | General purpose |
| dolphin-mixtral | 8x7B | ⚡ | ⭐⭐⭐⭐ | Complex tasks |

## 🔧 Customization

### Change Default Model
Edit `lua/shelbybark/plugins/codecompanion.lua` line 40:
```lua
default = \"neural-chat\",  -- Change this
```

### Add More Adapters
```lua
ollama_fast = function()
    return require(\"codecompanion.adapters\").extend(\"ollama\", {
        env = { url = os.getenv(\"OLLAMA_ENDPOINT\") or \"http://localhost:11434\" },
        schema = { model = { default = \"orca-mini\" } },
    })
end,
```

## 🧪 Testing

### Test 1: Ollama is Running
```bash
curl http://localhost:11434/api/tags
```

### Test 2: Network Access
```bash
export OLLAMA_ENDPOINT=\"http://100.x.x.x:11434\"
curl $OLLAMA_ENDPOINT/api/tags
```

### Test 3: Neovim Integration
```vim
:CodeCompanionChat ollama Toggle
\" Type a message and press Enter
```

## 🆘 Troubleshooting

### Connection Refused
```bash
# Check Ollama is running
ps aux | grep ollama

# Check it's listening on all interfaces
sudo netstat -tlnp | grep 11434
# Should show 0.0.0.0:11434, not 127.0.0.1:11434
```

### Model Not Found
```bash
# List available models
ollama list

# Pull the model
ollama pull mistral
```

### Can't Reach Remote Server
```bash
# Verify Tailscale
tailscale status

# Test connectivity
ping 100.x.x.x
curl http://100.x.x.x:11434/api/tags
```

See `docs/TROUBLESHOOTING.md` for more detailed solutions.

## 📚 Documentation

- **OLLAMA_SETUP.md** - Full setup guide with all details
- **OLLAMA_QUICK_SETUP.md** - Quick reference for other machines
- **ARCHITECTURE.md** - Network diagrams and data flow
- **TROUBLESHOOTING.md** - Common issues and solutions
- **IMPLEMENTATION_CHECKLIST.md** - Step-by-step checklist
- **INTEGRATION_SUMMARY.md** - Overview of all changes

## 🎓 How It Works

1. **Local Machine**: CodeCompanion connects to `http://localhost:11434`
2. **Remote Machine**: CodeCompanion connects to `http://100.x.x.x:11434` via Tailscale
3. **Tailscale**: Provides encrypted VPN tunnel between machines
4. **Ollama**: Runs on server, serves models to all connected machines

## ⚙️ System Requirements

### Ollama Server Machine
- 8GB+ RAM (for 7B models)
- Modern CPU or GPU
- Tailscale installed and running
- Ollama installed and running

### Client Machines
- Neovim 0.11.6+
- CodeCompanion plugin
- Tailscale installed and running
- No Ollama needed!

## 🔐 Security

- **Tailscale**: All traffic is encrypted end-to-end
- **Private IPs**: Uses Tailscale private IP addresses
- **No Port Exposure**: Ollama only accessible via Tailscale
- **Network Isolation**: Separate from public internet

## 💡 Tips

1. **Use smaller models** for faster responses (mistral, neural-chat)
2. **Monitor network latency** with `ping 100.x.x.x`
3. **Keep Tailscale updated** for best performance
4. **Run Ollama on GPU** if available for faster inference
5. **Use Claude for complex tasks**, Ollama for quick answers

## 🚨 Common Mistakes

❌ **Don't**: Forget to set `OLLAMA_HOST=0.0.0.0:11434` on server
✅ **Do**: Bind Ollama to all interfaces so it's accessible from network

❌ **Don't**: Use localhost IP (127.0.0.1) for remote access
✅ **Do**: Use Tailscale IP (100.x.x.x) for remote access

❌ **Don't**: Forget to export environment variable
✅ **Do**: Add to shell config and reload shell

## 📞 Support

- **Ollama Issues**: https://github.com/ollama/ollama/issues
- **Tailscale Help**: https://tailscale.com/kb/
- **CodeCompanion**: https://github.com/olimorris/codecompanion.nvim

## 📝 Next Steps

1. Follow the checklist in `docs/IMPLEMENTATION_CHECKLIST.md`
2. Set up Ollama on your server
3. Configure environment variables on other machines
4. Test with `<leader>cll` in Neovim
5. Enjoy local LLM access across your network!

---

**Status**: ✅ Ready to use!

**Last Updated**: 2026-02-05

**Configuration Version**: 1.0
