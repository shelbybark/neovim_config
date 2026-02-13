# Troubleshooting Guide

## Common Issues and Solutions

### 1. Connection Refused Error

**Error Message:**
```
Error: Connection refused
Failed to connect to http://localhost:11434
```

**Causes:**
- Ollama service is not running
- Ollama is not bound to the correct interface
- Port 11434 is in use by another service

**Solutions:**

```bash
# Check if Ollama is running
ps aux | grep ollama

# If not running, start it
ollama serve

# Or if using systemd
sudo systemctl start ollama
sudo systemctl status ollama

# Check if port is in use
sudo netstat -tlnp | grep 11434
lsof -i :11434

# If another service is using it, either:
# 1. Stop the other service
# 2. Change Ollama port (advanced)
```

---

### 2. Model Not Found Error

**Error Message:**
```
Error: Model 'mistral' not found
```

**Causes:**
- Model hasn't been pulled yet
- Model name is incorrect
- Ollama cache is corrupted

**Solutions:**

```bash
# List available models
curl http://localhost:11434/api/tags | jq '.models[].name'

# Pull the model
ollama pull mistral

# Or pull a different model
ollama pull neural-chat
ollama pull llama2
ollama pull dolphin-mixtral

# Verify it was pulled
ollama list

# If issues persist, remove and re-pull
ollama rm mistral
ollama pull mistral
```

---

### 3. Tailscale Connection Issues

**Error Message:**
```
Error: Connection refused to 100.x.x.x:11434
```

**Causes:**
- Tailscale is not running
- Machines are not on the same Tailscale network
- Firewall is blocking the connection
- Tailscale IP is incorrect

**Solutions:**

```bash
# Check Tailscale status
tailscale status

# If not running, start it
sudo systemctl start tailscaled
tailscale up

# Verify you're logged in
tailscale whoami

# Check your Tailscale IP
tailscale ip -4

# Ping the remote machine
ping 100.x.x.x

# Check if Ollama is accessible from remote
curl http://100.x.x.x:11434/api/tags

# If firewall is blocking, check UFW
sudo ufw status
sudo ufw allow 11434/tcp
```

---

### 4. Slow Responses

**Symptoms:**
- Responses take 30+ seconds
- Neovim appears frozen
- High CPU usage on Ollama server

**Causes:**
- Model is too large for available resources
- Network latency is high
- Server is running other heavy processes
- Ollama is running on CPU instead of GPU

**Solutions:**

```bash
# Check server resources
top
htop

# Check if Ollama is using GPU
nvidia-smi  # For NVIDIA GPUs
rocm-smi    # For AMD GPUs

# Try a smaller model
ollama pull orca-mini  # 3B model, very fast
ollama pull neural-chat  # 7B model, good balance

# Check network latency
ping 100.x.x.x
# Look for latency > 50ms (indicates network issue)

# Monitor Ollama performance
curl http://localhost:11434/api/tags | jq '.models[] | {name, size}'

# Stop other processes on the server
sudo systemctl stop other-service
```

---

### 5. Environment Variable Not Working

**Symptoms:**
- `OLLAMA_ENDPOINT` is set but not being used
- Still trying to connect to localhost

**Causes:**
- Environment variable not exported
- Shell not reloaded after setting variable
- Variable set in wrong shell config file

**Solutions:**

```bash
# Verify the variable is set
echo $OLLAMA_ENDPOINT

# If empty, add to shell config
# For zsh (~/.zshrc):
echo 'export OLLAMA_ENDPOINT="http://100.x.x.x:11434"' >> ~/.zshrc
source ~/.zshrc

# For bash (~/.bashrc):
echo 'export OLLAMA_ENDPOINT="http://100.x.x.x:11434"' >> ~/.bashrc
source ~/.bashrc

# For fish (~/.config/fish/config.fish):
echo 'set -gx OLLAMA_ENDPOINT "http://100.x.x.x:11434"' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish

# Verify it's set
echo $OLLAMA_ENDPOINT

# Restart Neovim to pick up the new variable
```

---

### 6. Ollama Not Accessible from Network

**Symptoms:**
- Works on localhost
- Fails when connecting from another machine
- `curl http://100.x.x.x:11434/api/tags` fails

**Causes:**
- Ollama is only bound to localhost (127.0.0.1)
- Firewall is blocking port 11434
- Network connectivity issue

**Solutions:**

```bash
# Check what Ollama is bound to
sudo netstat -tlnp | grep ollama
# Should show 0.0.0.0:11434 or your IP, not 127.0.0.1:11434

# If bound to localhost only, fix it:
sudo systemctl edit ollama

# Add this line in the [Service] section:
# Environment="OLLAMA_HOST=0.0.0.0:11434"

# Save and restart
sudo systemctl restart ollama

# Verify it's now listening on all interfaces
sudo netstat -tlnp | grep ollama

# Check firewall
sudo ufw status
sudo ufw allow 11434/tcp
sudo ufw reload

# Test from another machine
curl http://100.x.x.x:11434/api/tags
```

---

### 7. Neovim CodeCompanion Not Recognizing Ollama

**Symptoms:**
- Ollama adapter not available
- `<leader>cll` doesn't work
- Error about unknown adapter

**Causes:**
- CodeCompanion plugin not loaded
- Ollama adapter not properly configured
- Neovim config not reloaded

**Solutions:**

```vim
" In Neovim:

" Check if CodeCompanion is loaded
:checkhealth codecompanion

" Reload config
:source ~/.config/nvim/init.lua

" Or restart Neovim completely
:qa!
nvim

" Check available adapters
:CodeCompanionChat <Tab>
" Should show: ollama, anthropic, anthropic_opus, anthropic_haiku

" Test the adapter
:CodeCompanionChat ollama Toggle
```

---

### 8. Ollama Server Crashes

**Symptoms:**
- Ollama process dies unexpectedly
- Connection drops mid-conversation
- Out of memory errors

**Causes:**
- Insufficient RAM
- Model is too large
- System is under heavy load
- Ollama bug

**Solutions:**

```bash
# Check system resources
free -h
df -h

# Check Ollama logs
journalctl -u ollama -n 50
journalctl -u ollama -f  # Follow logs

# Check if model is too large
ollama list
# Compare model size with available RAM

# Reduce model size
ollama rm mistral
ollama pull orca-mini  # Smaller model

# Increase swap (temporary fix)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Monitor while running
watch -n 1 'free -h && echo "---" && ps aux | grep ollama'
```

---

### 9. Timeout Errors

**Error Message:**
```
Error: Request timeout
Connection timed out after 30 seconds
```

**Causes:**
- Model is taking too long to respond
- Network latency is too high
- Server is overloaded

**Solutions:**

```bash
# Check network latency
ping -c 5 100.x.x.x
# Acceptable: < 50ms
# Marginal: 50-100ms
# Poor: > 100ms

# Try a faster model
ollama pull orca-mini

# Check server load
ssh user@100.x.x.x
top
# Look for high CPU or memory usage

# Reduce concurrent requests
# Only run one CodeCompanion chat at a time

# Increase timeout in CodeCompanion (if supported)
# Check CodeCompanion documentation
```

---

### 10. Permission Denied Errors

**Error Message:**
```
Error: Permission denied
Cannot access /var/lib/ollama
```

**Causes:**
- Ollama service running as different user
- File permissions are incorrect
- SELinux or AppArmor restrictions

**Solutions:**

```bash
# Check Ollama service user
sudo systemctl show -p User ollama

# Fix permissions
sudo chown -R ollama:ollama /var/lib/ollama
sudo chmod -R 755 /var/lib/ollama

# Restart service
sudo systemctl restart ollama

# Check SELinux (if applicable)
getenforce
# If "Enforcing", may need to adjust policies

# Check AppArmor (if applicable)
sudo aa-status | grep ollama
```

---

## Quick Diagnostic Script

```bash
#!/bin/bash
# Save as: ~/check_ollama.sh
# Run with: bash ~/check_ollama.sh

echo "=== Ollama Diagnostic Check ==="
echo

echo "1. Ollama Service Status:"
sudo systemctl status ollama --no-pager | head -5
echo

echo "2. Ollama Process:"
ps aux | grep ollama | grep -v grep || echo "Not running"
echo

echo "3. Port Binding:"
sudo netstat -tlnp | grep 11434 || echo "Not listening on 11434"
echo

echo "4. Available Models:"
curl -s http://localhost:11434/api/tags | jq '.models[].name' 2>/dev/null || echo "Cannot connect to Ollama"
echo

echo "5. Tailscale Status:"
tailscale status --self 2>/dev/null || echo "Tailscale not running"
echo

echo "6. System Resources:"
echo "Memory: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
echo "Disk: $(df -h / | tail -1 | awk '{print $3 "/" $2}')"
echo

echo "=== End Diagnostic ==="
```

---

## Getting Help

If you're still having issues:

1. **Check the logs:**
   ```bash
   journalctl -u ollama -n 100
   ```

2. **Test connectivity:**
   ```bash
   curl -v http://localhost:11434/api/tags
   curl -v http://100.x.x.x:11434/api/tags
   ```

3. **Check Neovim messages:**
   ```vim
   :messages
   ```

4. **Report issues:**
   - Ollama: https://github.com/ollama/ollama/issues
   - CodeCompanion: https://github.com/olimorris/codecompanion.nvim/issues
   - Tailscale: https://github.com/tailscale/tailscale/issues
