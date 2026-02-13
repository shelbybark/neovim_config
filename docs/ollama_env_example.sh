#!/bin/bash
# Example shell configuration for Ollama endpoint
# Add this to your ~/.zshrc, ~/.bashrc, or ~/.config/fish/config.fish

# ============================================================================
# OLLAMA CONFIGURATION
# ============================================================================

# Set your Ollama server's Tailscale IP here
# Find it by running: tailscale ip -4 on your Ollama server
OLLAMA_SERVER_IP=\"100.123.45.67\"  # CHANGE THIS TO YOUR TAILSCALE IP

# Set the Ollama endpoint
export OLLAMA_ENDPOINT=\"http://${OLLAMA_SERVER_IP}:11434\"

# Optional: Add a function to quickly test the connection
ollama_test() {
    echo \"Testing Ollama connection to ${OLLAMA_ENDPOINT}...\"
    if curl -s \"${OLLAMA_ENDPOINT}/api/tags\" > /dev/null; then
        echo \"✓ Ollama is reachable\"
        echo \"Available models:\"
        curl -s \"${OLLAMA_ENDPOINT}/api/tags\" | jq '.models[].name' 2>/dev/null || echo \"(Could not parse models)\"
    else
        echo \"✗ Ollama is not reachable at ${OLLAMA_ENDPOINT}\"
        echo \"Troubleshooting:\"
        echo \"1. Verify Tailscale is running: tailscale status\"
        echo \"2. Verify Ollama is running on the server\"
        echo \"3. Check the Tailscale IP is correct\"
    fi
}

# Optional: Add a function to list available models
ollama_models() {
    curl -s \"${OLLAMA_ENDPOINT}/api/tags\" | jq '.models[] | {name: .name, size: .size}' 2>/dev/null || echo \"Could not fetch models\"
}

# ============================================================================
# INSTRUCTIONS
# ============================================================================
# 1. Replace \"100.123.45.67\" with your actual Tailscale IP
# 2. Add this to your shell config file
# 3. Reload your shell: source ~/.zshrc (or ~/.bashrc, etc.)
# 4. Test with: ollama_test
# 5. Use in Neovim: press <leader>cll to chat with Ollama
