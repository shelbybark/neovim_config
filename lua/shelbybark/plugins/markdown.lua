return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons", -- Optional: for file icons
	},
	ft = { "markdown", "codecompanion" }, -- Only load for markdown files
	config = function()
		require("render-markdown").setup({
			-- Enable/disable the plugin
			enabled = true,
			-- Maximum file size (MB) to render
			max_file_size = 10.0,
			-- Debounce rendering after changes (ms)
			debounce = 100,
			-- Preset configurations: 'none', 'lazy', 'obsidian'
			preset = "none",
			-- Render modes: 'n' (normal), 'c' (command), 'i' (insert), 'v' (visual)
			render_modes = { "n", "c" },
			-- Anti-conceal behavior
			anti_conceal = {
				-- Disable anti-conceal on cursor line
				enabled = true,
			},
			-- Heading configurations
			heading = {
				-- Turn on/off heading icon & background
				enabled = true,
				-- Turn on/off any sign column related rendering
				sign = true,
				-- Replaces '#+' of 'atx_h._marker'
				-- The number of '#' in the heading determines the 'level'
				-- The 'level' is used to index into the array using a cycle
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				-- Added to the sign column if enabled
				-- The 'level' is used to index into the array using a cycle
				signs = { "󰫎 " },
				-- Width of the heading background
				width = "full",
				-- Amount of margin to add to the left of headings
				left_margin = 0,
				-- Amount of padding to add to the left of headings
				left_pad = 0,
				-- Amount of padding to add to the right of headings
				right_pad = 0,
			},
			-- Code block configurations
			code = {
				-- Turn on/off code block & inline code rendering
				enabled = true,
				-- Turn on/off any sign column related rendering
				sign = true,
				-- Determines how code blocks & inline code are rendered:
				--   none: disables all rendering
				--   normal: adds highlight group to code blocks & inline code
				--   language: adds language icon to sign column if enabled and icon + name above code blocks
				--   full: normal + language
				style = "full",
				-- Amount of padding to add to the left of code blocks
				left_pad = 0,
				-- Amount of padding to add to the right of code blocks
				right_pad = 0,
				-- Width of the code block background
				width = "full",
				-- Determines how the top / bottom of code block are rendered:
				--   thick: use the same highlight as the code body
				--   thin: when lines are empty overlay the above & below icons
				border = "thin",
				-- Used above code blocks for thin border
				above = "▄",
				-- Used below code blocks for thin border
				below = "▀",
				-- Highlight for code blocks
				highlight = "RenderMarkdownCode",
			},
		})

		-- Optional keymaps
		vim.api.nvim_set_keymap(
			"n",
			"<leader>mr",
			"<cmd>RenderMarkdown toggle<cr>",
			{ noremap = true, silent = true, desc = "Toggle markdown rendering" }
		)
	end,
}

