# 🎉 Setup Complete - Start Here!

## What You Now Have

Your CodeCompanion is now configured to work with **Ollama** across your **Tailscale network**. This means:

- ✅ Use local Ollama on your main machine
- ✅ Access Ollama from other machines via Tailscale (no local Ollama needed)
- ✅ Switch between Claude and Ollama instantly
- ✅ Secure, encrypted connections via Tailscale

## 🚀 Get Started in 5 Minutes

### Step 1: Configure Your Ollama Server (5 min)

On the machine running Ollama:

```bash
# Make Ollama accessible from network
sudo systemctl edit ollama
```

Add this line in the `[Service]` section:
```ini
Environment="OLLAMA_HOST=0.0.0.0:11434"
```

Save and exit, then:
```bash
sudo systemctl restart ollama

# Pull a model
ollama pull mistral

# Find your Tailscale IP
tailscale ip -4
# You'll see something like: 100.123.45.67
```

### Step 2: Configure Other Machines (2 min)

On each machine that needs to access Ollama:

```bash
# Add to ~/.zshrc (or ~/.bashrc)
echo 'export OLLAMA_ENDPOINT="http://100.123.45.67:11434"' >> ~/.zshrc

# Reload shell
source ~/.zshrc

# Test it works
curl $OLLAMA_ENDPOINT/api/tags
```

### Step 3: Use in Neovim (1 min)

```vim
" Start Neovim
nvim

" Press <leader>cll to chat with Ollama
" Type a message and press Enter
" You should get a response!
```

## 📚 Documentation

Start with these in order:

1. **`README_OLLAMA_INTEGRATION.md`** ← Read this first for overview
2. **`docs/QUICK_REFERENCE.md`** ← Quick reference card
3. **`docs/OLLAMA_SETUP.md`** ← Full setup guide
4. **`docs/TROUBLESHOOTING.md`** ← If something doesn't work

## ⌨️ Keymaps

| Keymap | What It Does |
|--------|--------------|
| `<leader>cll` | Chat with Ollama |
| `<leader>cc` | Chat with Claude Haiku |
| `<leader>cs` | Chat with Claude Sonnet |
| `<leader>co` | Chat with Claude Opus |
| `<leader>ca` | Show all CodeCompanion actions |

## 🔧 What Was Changed

### Modified
- `lua/shelbybark/plugins/codecompanion.lua` - Added Ollama adapter and keymaps

### Created
- 8 comprehensive documentation files in `docs/`
- 1 main README file

## 🎯 Common Tasks

### Pull a Different Model
```bash
ollama pull neural-chat
ollama pull llama2
ollama pull dolphin-mixtral
```

### Change Default Model
Edit `lua/shelbybark/plugins/codecompanion.lua` line 40:
```lua
default = "neural-chat",  -- Change this
```

### Test Connection
```bash
# Local
curl http://localhost:11434/api/tags

# Remote
curl http://100.x.x.x:11434/api/tags
```

### List Available Models
```bash
ollama list
```

## 🆘 Something Not Working?

1. **Check Ollama is running**: `ps aux | grep ollama`
2. **Check it's listening**: `sudo netstat -tlnp | grep 11434`
3. **Check Tailscale**: `tailscale status`
4. **Read troubleshooting**: `docs/TROUBLESHOOTING.md`

## 📋 Checklist

- [ ] Ollama server configured with `OLLAMA_HOST=0.0.0.0:11434`
- [ ] Ollama restarted: `sudo systemctl restart ollama`
- [ ] Model pulled: `ollama pull mistral`
- [ ] Tailscale IP found: `tailscale ip -4`
- [ ] Environment variable set on other machines
- [ ] Shell reloaded: `source ~/.zshrc`
- [ ] Connection tested: `curl $OLLAMA_ENDPOINT/api/tags`
- [ ] Neovim tested: Press `<leader>cll`

## 💡 Pro Tips

1. **Use mistral** - Fast, good quality, recommended
2. **Monitor latency** - `ping 100.x.x.x` should be < 50ms
3. **Keep Tailscale updated** - Better performance
4. **Use GPU if available** - Much faster inference
5. **Try smaller models** - orca-mini for quick answers

## 📞 Need Help?

- **Setup issues**: See `docs/OLLAMA_SETUP.md`
- **Troubleshooting**: See `docs/TROUBLESHOOTING.md`
- **Architecture**: See `docs/ARCHITECTURE.md`
- **Quick reference**: See `docs/QUICK_REFERENCE.md`

## 🎓 How It Works (Simple Version)

```
Your Machine A (Ollama Server)
    ↓
    Ollama Service (localhost:11434)
    ↓
    Tailscale Network (Encrypted)
    ↓
Your Machine B (Laptop)
    ↓
    Neovim + CodeCompanion
    ↓
    Press <leader>cll
    ↓
    Chat with Ollama!
```

## 🔐 Security

- All traffic encrypted via Tailscale
- Uses private Tailscale IPs (100.x.x.x)
- Not exposed to public internet
- Secure end-to-end

## 🚀 Next Steps

1. ✅ Read `README_OLLAMA_INTEGRATION.md`
2. ✅ Follow the 5-minute setup above
3. ✅ Test with `<leader>cll` in Neovim
4. ✅ Enjoy local LLM access across your network!

---

**Everything is ready to go!**

**Start with**: `README_OLLAMA_INTEGRATION.md`

**Questions?**: Check `docs/QUICK_REFERENCE.md`

**Issues?**: Check `docs/TROUBLESHOOTING.md`

---

**Date**: 2026-02-05
**Status**: ✅ Ready to Use
