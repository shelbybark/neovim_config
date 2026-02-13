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
		-- "nvim-lualine/lualine.nvim",
	},
	event = "VeryLazy", -- Lazy load the plugin
	init = function()
		require("shelbybark.plugins.codecompanion.fidget-spinner"):init()
	end,
	config = function()
		-- Store config in a module-level variable for later access
		local codecompanion_config = {
			strategies = {
				chat = {
					adapter = "anthropic_haiku",
				},
				inline = {
					adapter = "anthropic_haiku",
				},
			},
		}
		_G.codecompanion_config = codecompanion_config

		require("codecompanion").setup({
			ignore_warnings = true,
			strategies = {
			chat = {
				adapter = "anthropic_haiku",
			},
			inline = {
				adapter = "anthropic_haiku",
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
					anthropic_opus = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY",
							},
							schema = {
								model = {
									default = "claude-opus-4-5-20251101",
								},
							},
						})
					end,
					anthropic_haiku = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY",
							},
							schema = {
								model = {
									default = "claude-haiku-4-5-20251001",
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
			"<cmd>CodeCompanionChat anthropic_haiku Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Haiku" }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<leader>cc",
			"<cmd>CodeCompanionChat anthropic_haiku Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Haiku" }
		)
		vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("v", "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })

		vim.api.nvim_set_keymap(
			"n",
			"<leader>cm",
			"<cmd>CodeCompanionModel<cr>",
			{ noremap = true, silent = true, desc = "Show current CodeCompanion model" }
		)

		-- Create commands to show and change current model
		vim.api.nvim_create_user_command("CodeCompanionModel", function()
			local current_adapter = _G.codecompanion_config.strategies.chat.adapter
			local model_info = "Unknown"

			if current_adapter == "anthropic" then
				model_info = "Claude Sonnet (claude-sonnet-4-20250514)"
			elseif current_adapter == "anthropic_opus" then
				model_info = "Claude Opus (claude-opus-4-5-20251101)"
			elseif current_adapter == "anthropic_haiku" then
				model_info = "Claude Haiku (claude-haiku-4-5-20251001)"
			end

			vim.notify(string.format("Current CodeCompanion model: %s", model_info), vim.log.levels.INFO)
		end, {
			desc = "Show current CodeCompanion model",
		})

		vim.api.nvim_create_user_command("CodeCompanionSwitchModel", function(args)
			local model = args.args
			if model == "" then
				vim.notify("Available models: sonnet, opus, haiku", vim.log.levels.INFO)
				return
			end

			local adapter_map = {
				sonnet = "anthropic",
				opus = "anthropic_opus",
				haiku = "anthropic_haiku",
			}

			local adapter = adapter_map[model:lower()]
			if not adapter then
				vim.notify("Invalid model. Use: sonnet, opus, haiku", vim.log.levels.ERROR)
				return
			end

			-- Update the config
			_G.codecompanion_config.strategies.chat.adapter = adapter
			_G.codecompanion_config.strategies.inline.adapter = adapter

			vim.notify(string.format("Switched to %s model", model), vim.log.levels.INFO)

			-- Refresh lualine to update the status
			-- pcall(require("lualine").refresh)
		end, {
			nargs = 1,
			complete = function()
				return { "sonnet", "opus", "haiku" }
			end,
			desc = "Switch CodeCompanion model (sonnet/opus/haiku)",
		})

		-- Additional keymaps for Sonnet (backup primary)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>cs",
			"<cmd>CodeCompanionChat anthropic Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Sonnet" }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<leader>cs",
			"<cmd>CodeCompanionChat anthropic Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Sonnet" }
		)

		-- Additional keymaps for Opus
		vim.api.nvim_set_keymap(
			"n",
			"<leader>co",
			"<cmd>CodeCompanionChat anthropic_opus Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Opus" }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<leader>co",
			"<cmd>CodeCompanionChat anthropic_opus Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Opus" }
		)

		-- Additional keymaps for Haiku
		vim.api.nvim_set_keymap(
			"n",
			"<leader>ch",
			"<cmd>CodeCompanionChat anthropic_haiku Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Haiku" }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<leader>ch",
			"<cmd>CodeCompanionChat anthropic_haiku Toggle<cr>",
			{ noremap = true, silent = true, desc = "Chat with Claude Haiku" }
		)
	end,
}
