# Implementation Checklist

## ✅ Completed

- [x] Added Ollama adapter to CodeCompanion configuration
- [x] Configured environment variable support (`OLLAMA_ENDPOINT`)
- [x] Added keymaps for Ollama (`<leader>cll`)
- [x] Created comprehensive documentation
- [x] Created quick setup guide for other machines
- [x] Created shell configuration example

## 📋 To Do

### On Your Ollama Server Machine

- [ ] Verify Ollama is installed: `ollama --version`
- [ ] Ensure Ollama listens on all interfaces:
  ```bash
  sudo systemctl edit ollama
  # Add: Environment="OLLAMA_HOST=0.0.0.0:11434"
  sudo systemctl restart ollama
  ```
- [ ] Pull your preferred model:
  ```bash
  ollama pull mistral
  # or: ollama pull neural-chat
  ```
- [ ] Find your Tailscale IP:
  ```bash
  tailscale ip -4
  # Note this down: 100.x.x.x
  ```
- [ ] Test Ollama is accessible:
  ```bash
  curl http://localhost:11434/api/tags
  ```

### On Your Main Machine (with Ollama)

- [ ] Reload Neovim config: `:source ~/.config/nvim/init.lua` or restart Neovim
- [ ] Test Ollama integration:
  ```vim
  :CodeCompanionChat ollama Toggle
  ```
- [ ] Verify it works by sending a message

### On Other Machines (without Ollama)

- [ ] Add to shell config (`~/.zshrc`, `~/.bashrc`, etc.):
  ```bash
  export OLLAMA_ENDPOINT="http://100.x.x.x:11434"
  # Replace 100.x.x.x with your Tailscale IP
  ```
- [ ] Reload shell: `source ~/.zshrc` (or your shell config)
- [ ] Test connection:
  ```bash
  curl http://100.x.x.x:11434/api/tags
  ```
- [ ] Start Neovim and test:
  ```vim
  :CodeCompanionChat ollama Toggle
  ```

## 🔧 Optional Customizations

- [ ] Change default Ollama model in `lua/shelbybark/plugins/codecompanion.lua` (line 40)
- [ ] Add more Ollama adapters for different models
- [ ] Create machine-specific configs if needed
- [ ] Set up Ollama to run on GPU for faster inference

## 📚 Documentation Files

- `docs/OLLAMA_SETUP.md` - Full setup guide with troubleshooting
- `docs/OLLAMA_QUICK_SETUP.md` - Quick reference for other machines
- `docs/ollama_env_example.sh` - Shell configuration example
- `docs/INTEGRATION_SUMMARY.md` - Overview of changes

## 🧪 Testing

### Test 1: Local Ollama Access
```bash
# On your Ollama server machine
curl http://localhost:11434/api/tags
# Should return JSON with available models
```

### Test 2: Network Access via Tailscale
```bash
# On another machine
export OLLAMA_ENDPOINT="http://100.x.x.x:11434"
curl $OLLAMA_ENDPOINT/api/tags
# Should return JSON with available models
```

### Test 3: Neovim Integration
```vim
# In Neovim on any machine
:CodeCompanionChat ollama Toggle
# Should open chat window
# Type a message and press Enter
# Should get response from Ollama
```

## 🆘 Quick Troubleshooting

| Problem | Quick Fix |
|---------|-----------|
| "Connection refused" | Check Ollama is running: `curl http://localhost:11434/api/tags` |
| "Model not found" | Pull the model: `ollama pull mistral` |
| "Can't reach server" | Verify Tailscale: `tailscale status` |
| "Slow responses" | Try smaller model or check server resources |

## 📞 Support Resources

- Ollama Issues: https://github.com/ollama/ollama/issues
- Tailscale Help: https://tailscale.com/kb/
- CodeCompanion: https://github.com/olimorris/codecompanion.nvim

---

**Status**: Ready to use! Follow the "To Do" section to complete setup.
