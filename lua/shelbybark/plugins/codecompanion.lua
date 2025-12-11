return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- Optional: for enhanced diagnostics/context
		"georgeharker/mcp-diagnostics.nvim",
		-- For progress notifications
		"j-hui/fidget.nvim",
		-- For statusline integration
		"nvim-lualine/lualine.nvim",
	},
	event = "VeryLazy", -- Lazy load the plugin
	config = function()
		require("codecompanion").setup({
			ignore_warnings = true,
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
			},
			adapters = {
				http = {
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY",
							},
							schema = {
								model = {
									default = "claude-sonnet-4-20250514",
								},
							},
						})
					end,
				},
			},
			-- Display settings for the chat window
			display = {
				chat = {
					window = {
						layout = "vertical", -- or "horizontal", "float"
					},
					show_progress = true,
					show_token_count = true,
				},
				-- Progress notifications using fidget
				progress = {
					enabled = true,
					provider = "fidget",
				},
			},
		})

		-- Optional: Set up keymaps
		vim.api.nvim_set_keymap(
			"n",
			"<leader>cc",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<leader>cc",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("v", "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })


	end,
}
