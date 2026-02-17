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
		-- Default chat adapter used by <leader>cc (you can change this at runtime via :CodeCompanionSwitchModel)
		vim.g.codecompanion_default_adapter = vim.g.codecompanion_default_adapter or "anthropic_haiku"

		-- Helpers: read CodeCompanion's per-chat metadata (adapter/model) and reflect it in bufferline by renaming chat buffers.
		-- CodeCompanion populates _G.codecompanion_chat_metadata and emits User events when adapter/model changes.  See :h codecompanion.
		local function cc_get_meta(bufnr)
			local md = rawget(_G, "codecompanion_chat_metadata")
			if type(md) ~= "table" then
				return nil
			end
			return md[bufnr]
		end

		local function cc_label(bufnr)
			local meta = cc_get_meta(bufnr)
			if not (meta and meta.adapter) then
				return nil
			end

			local a = meta.adapter
			local adapter_name = a.formatted_name or a.name or "CodeCompanion"
			local model = a.model or "?"
			return string.format("%s • %s", adapter_name, model)
		end

		local function cc_update_chat_buf_name(bufnr)
			local label = cc_label(bufnr)
			if not label then
				return
			end

			-- Make the name unique so multiple chats don't collide.
			local meta = cc_get_meta(bufnr)
			local id = (meta and meta.id) or bufnr
			local name = string.format("[CC#%s %s]", id, label)
			pcall(vim.api.nvim_buf_set_name, bufnr, name)
		end

		local function cc_update_all_chat_buf_names()
			local md = rawget(_G, "codecompanion_chat_metadata")
			if type(md) ~= "table" then
				return
			end
			for bufnr, _ in pairs(md) do
				bufnr = tonumber(bufnr)
				if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
					cc_update_chat_buf_name(bufnr)
				end
			end
		end

		local cc_name_group = vim.api.nvim_create_augroup("CodeCompanionBufferNames", { clear = true })
		vim.api.nvim_create_autocmd("User", {
	group = cc_name_group,
	pattern = {
		"CodeCompanionChatCreated",
		"CodeCompanionChatOpened",
		"CodeCompanionChatAdapter",
		"CodeCompanionChatModel",
	},
	callback = function(request)
		local bufnr = request.buf
		-- The plugin updates _G.codecompanion_chat_metadata around the same time it fires events.
		-- Scheduling makes sure we read the latest metadata.
		vim.schedule(function()
			if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
				cc_update_chat_buf_name(bufnr)
			end
			cc_update_all_chat_buf_names()
			pcall(vim.cmd, "redrawtabline")
		end)
	end,
})

		-- Ollama defaults (works locally; set CODECOMPANION_OLLAMA_URL on other machines to use your Tailscale hostname/IP)
		local ollama_model = os.getenv("CODECOMPANION_OLLAMA_MODEL") or "qwen3-coder:30b"
		local ollama_url = os.getenv("CODECOMPANION_OLLAMA_URL") or "http://127.0.0.1:11434"
		local ollama_api_key = os.getenv("CODECOMPANION_OLLAMA_API_KEY") -- optional

		require("codecompanion").setup({
			ignore_warnings = true,

			-- Newer CodeCompanion uses `interactions` (older configs used `strategies`).
			-- We set a startup default, but our keymaps below always pass adapter=... explicitly.
			interactions = {
				chat = { adapter = vim.g.codecompanion_default_adapter },
				inline = { adapter = vim.g.codecompanion_default_adapter },
			},

			adapters = {
				http = {
					-- Claude Sonnet
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY",
							},
							schema = {
								model = { default = "claude-sonnet-4-20250514" },
							},
						})
					end,

					-- Claude Opus
					anthropic_opus = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY",
							},
							schema = {
								model = { default = "claude-opus-4-5-20251101" },
							},
						})
					end,

					-- Claude Haiku
					anthropic_haiku = function()
						return require("codecompanion.adapters").extend("anthropic", {
							env = {
								api_key = "ANTHROPIC_API_KEY",
							},
							schema = {
								model = { default = "claude-haiku-4-5-20251001" },
							},
						})
					end,

					-- Ollama (local or remote)
					ollama = function()
						local adapter = require("codecompanion.adapters").extend("ollama", {
							env = {
								url = ollama_url,
								api_key = ollama_api_key,
							},
							-- If you don't set model=... in :CodeCompanionChat, this is what gets used.
							schema = {
								model = { default = ollama_model },
							},
							headers = {
								["Content-Type"] = "application/json",
								-- Only used if you set CODECOMPANION_OLLAMA_API_KEY (e.g. if you proxy Ollama behind auth)
								["Authorization"] = "Bearer ${api_key}",
							},
							parameters = {
								sync = true,
							},
						})

						-- If no api key is set, drop Authorization so we don't send a meaningless header.
						if not (ollama_api_key and ollama_api_key ~= "") then
							adapter.headers = adapter.headers or {}
							adapter.headers["Authorization"] = nil
						end

						return adapter
					end,
				},
			},

			-- Display settings for the chat window
			display = {
				chat = {
					window = { layout = "vertical" }, -- or "horizontal", "float"
					show_progress = true,
					show_token_count = true,
					-- Consider enabling this if you also want the model/settings visible inside the chat buffer header:
					-- show_settings = true,
				},
				-- Progress notifications using fidget
				progress = {
					enabled = true,
					provider = "fidget",
				},
			},
		})

		-- Update any existing chat buffer names after startup
		vim.schedule(cc_update_all_chat_buf_names)

		-- Keymaps (updated to the newer command syntax: :CodeCompanionChat adapter=... [model=...] Toggle)
		local function cc_toggle(adapter)
			vim.cmd(string.format("CodeCompanionChat adapter=%s Toggle", adapter))
		end

		vim.keymap.set({ "n", "v" }, "<leader>cc", function()
			cc_toggle(vim.g.codecompanion_default_adapter or "anthropic_haiku")
		end, { noremap = true, silent = true, desc = "Chat with CodeCompanion (default)" })

		vim.keymap.set({ "n", "v" }, "<leader>cs", function()
			cc_toggle("anthropic")
		end, { noremap = true, silent = true, desc = "Chat with Claude Sonnet" })

		vim.keymap.set({ "n", "v" }, "<leader>co", function()
			cc_toggle("anthropic_opus")
		end, { noremap = true, silent = true, desc = "Chat with Claude Opus" })

		vim.keymap.set({ "n", "v" }, "<leader>ch", function()
			cc_toggle("anthropic_haiku")
		end, { noremap = true, silent = true, desc = "Chat with Claude Haiku" })

		vim.keymap.set({ "n", "v" }, "<leader>cl", function()
			-- Explicitly set the model you asked for, even if CODECOMPANION_OLLAMA_MODEL isn't set.
			vim.cmd("CodeCompanionChat adapter=ollama model=qwen3-coder:30b")
		end, { noremap = true, silent = true, desc = "Chat with Ollama (qwen3-coder:30b)" })

		vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })


		-- Model picker (one shortcut to open a chat with a specific adapter/model)
		local function cc_chat(adapter, model)
			if model and model ~= "" then
				vim.cmd(("CodeCompanionChat adapter=%s model=%s"):format(adapter, model))
			else
				vim.cmd(("CodeCompanionChat adapter=%s"):format(adapter))
			end
		end

		vim.keymap.set({ "n", "v" }, "<leader>cm", function()
			local choices = {
				{ label = "Ollama • " .. (ollama_model or "qwen3-coder:30b"), adapter = "ollama", model = (ollama_model or "qwen3-coder:30b") },
				{ label = "Claude • Haiku", adapter = "anthropic_haiku", model = "claude-haiku-4-5-20251001" },
				{ label = "Claude • Sonnet", adapter = "anthropic", model = "claude-sonnet-4-20250514" },
				{ label = "Claude • Opus", adapter = "anthropic_opus", model = "claude-opus-4-5-20251101" },
			}

			vim.ui.select(choices, {
				prompt = "CodeCompanion model",
				format_item = function(item)
					return item.label
				end,
			}, function(item)
				if item then
					cc_chat(item.adapter, item.model)
				end
			end)
		end, { noremap = true, silent = true, desc = "CodeCompanion: Pick model" })

		-- Keep an 'info' shortcut to show the current model for the active chat buffer
		vim.keymap.set("n", "<leader>cM", "<cmd>CodeCompanionModel<cr>", {
			noremap = true,
			silent = true,
			desc = "Show current CodeCompanion model",
		})
		-- Show model for the *current* chat buffer (if you're in one), otherwise show your default adapter.
		vim.api.nvim_create_user_command("CodeCompanionModel", function()
			local bufnr = vim.api.nvim_get_current_buf()
			local label = cc_label(bufnr)

			if label then
				vim.notify(string.format("CodeCompanion (this chat): %s", label), vim.log.levels.INFO)
			else
				vim.notify(
					string.format("CodeCompanion default adapter: %s", vim.g.codecompanion_default_adapter or "anthropic_haiku"),
					vim.log.levels.INFO
				)
			end
		end, { desc = "Show current CodeCompanion model" })

		-- Switch which adapter <leader>cc uses (doesn't rewrite plugin config; it just changes your default toggle)
		vim.api.nvim_create_user_command("CodeCompanionSwitchModel", function(args)
			local choice = (args.args or ""):lower()
			if choice == "" then
				vim.notify("Available: sonnet, opus, haiku, ollama", vim.log.levels.INFO)
				return
			end

			local adapter_map = {
				sonnet = "anthropic",
				opus = "anthropic_opus",
				haiku = "anthropic_haiku",
				ollama = "ollama",
			}

			local adapter = adapter_map[choice]
			if not adapter then
				vim.notify("Invalid choice. Use: sonnet, opus, haiku, ollama", vim.log.levels.ERROR)
				return
			end

			vim.g.codecompanion_default_adapter = adapter
			vim.notify(string.format("CodeCompanion default adapter set to: %s", adapter), vim.log.levels.INFO)
		end, {
			nargs = 1,
			complete = function()
				return { "sonnet", "opus", "haiku", "ollama" }
			end,
			desc = "Switch default CodeCompanion adapter used by <leader>cc",
		})
	end,
}
