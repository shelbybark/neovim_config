# CodeCompanion Model Status Display

This document explains the enhancements made to display the current CodeCompanion model in your Neovim status bar.

## Features Added

### 1. Enhanced Status Bar Display
The lualine configuration now includes an improved `codecompanion_status()` function that shows:
- Activity indicators (🤖 for active requests, 💬 for active chats)
- Current model being used with shortened names for better display:
  - `claude-sonnet-4-20250514` → `Sonnet`
  - `claude-opus-4-5-20251101` → `Opus`
  - `claude-3-5-sonnet-20241022` → `3.5S`
  - `claude-3-haiku-20240307` → `Haiku`
  - `gpt-4o` → `GPT-4o`
  - `gpt-4` → `GPT-4`
  - `gpt-3.5-turbo` → `GPT-3.5`

### 2. New Commands
- `:CodeCompanionModel` - Shows the current model being used
- `:CodeCompanionSwitchModel [sonnet|opus]` - Switch between available models

### 3. New Keymaps
- `<leader>cm` - Show current CodeCompanion model
- `<leader>cc` - Toggle CodeCompanion chat (existing)
- `<leader>ca` - CodeCompanion actions (existing)
- `<leader>co` - Chat with Claude Opus specifically (existing)

## How It Works

The status function tries multiple approaches to determine the current model:
1. First, it checks if there's an active chat buffer and gets the adapter/model from it
2. If no active chat, it falls back to the default adapter from the configuration
3. It then tries to resolve the actual model name from the adapter configuration
4. Finally, it formats the display with activity indicators and shortened model names

## Usage Examples

```vim
" Show current model
:CodeCompanionModel

" Switch to Sonnet model
:CodeCompanionSwitchModel sonnet

" Switch to Opus model
:CodeCompanionSwitchModel opus

" Show current model (keymap)
<leader>cm
```

## Configuration

The status bar component is automatically integrated into your lualine configuration in the `lualine_x` section, positioned between other status indicators and file type information.

The model names are shortened to save space in the status bar while still being recognizable. You can modify the name mappings in the `codecompanion_status()` function if you prefer different abbreviations.