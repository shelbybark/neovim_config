# Stylua Crash Fix

## Problem
You were experiencing stylua crashing errors after upgrading Neovim. This was likely caused by stylua 2.1.0 requiring explicit configuration.

## Root Cause
Stylua 2.1.0 introduced stricter configuration requirements. Without a `.stylua.toml` configuration file, stylua may fail or behave unexpectedly when called by conform.nvim.

## Solution
Created a `.stylua.toml` configuration file in your project root with sensible defaults that match your Neovim configuration style:

```toml
column_width = 120
line_endings = "Unix"
indent_type = "Tabs"
indent_width = 4
quote_style = "AutoPreferDouble"
call_parentheses = "Input"
collapse_simple_statement = "Never"
```

## What This Configuration Does
- **column_width = 120**: Wraps lines at 120 characters
- **line_endings = "Unix"**: Uses Unix line endings (LF)
- **indent_type = "Tabs"**: Uses tabs for indentation (matches your config)
- **indent_width = 4**: Tab width of 4 spaces
- **quote_style = "AutoPreferDouble"**: Prefers double quotes
- **call_parentheses = "Input"**: Preserves input parentheses style
- **collapse_simple_statement = "Never"**: Doesn't collapse simple statements

## Files Modified
- Created: `.stylua.toml` (new configuration file)

## Testing
Stylua now works correctly:
```bash
stylua lua/shelbybark/core/init.lua  # ✓ Success
```

## How to Verify
1. Open any Lua file in Neovim
2. Press `<leader>mp` to format
3. Stylua should format without errors

## Additional Notes
- This configuration file will be used by stylua automatically
- It applies to all Lua files in your project
- You can customize the settings in `.stylua.toml` as needed
- The configuration is compatible with stylua 2.1.0+

## If You Still Have Issues
1. Verify stylua is installed: `which stylua`
2. Check version: `stylua --version`
3. Test manually: `stylua --check lua/shelbybark/core/init.lua`
4. Check for errors: `stylua -v lua/shelbybark/core/init.lua`
