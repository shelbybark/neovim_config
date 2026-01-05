return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- Toggle for shortened mode names
		vim.g.lualine_use_short_modes = vim.g.lualine_use_short_modes or true

		-- Short mode names (single letters)
		local short_mode_map = {
			["n"] = "N",
			["no"] = "N",
			["nov"] = "N",
			["noV"] = "N",
			["niI"] = "N",
			["niR"] = "N",
			["niV"] = "N",
			["i"] = "I",
			["ic"] = "I",
			["ix"] = "I",
			["v"] = "V",
			["V"] = "VL",
			[""] = "VB",
			["s"] = "S",
			["S"] = "SL",
			[""] = "SB",
			["r"] = "R",
			["rm"] = "R",
			["r?"] = "R",
			["R"] = "R",
			["Rv"] = "R",
			["c"] = "C",
			["cv"] = "C",
			["ce"] = "C",
			["t"] = "T",
		}

		-- Full mode names
		local full_mode_map = {
			["n"] = "NORMAL",
			["no"] = "NORMAL",
			["nov"] = "NORMAL",
			["noV"] = "NORMAL",
			["niI"] = "NORMAL",
			["niR"] = "NORMAL",
			["niV"] = "NORMAL",
			["i"] = "INSERT",
			["ic"] = "INSERT",
			["ix"] = "INSERT",
			["v"] = "VISUAL",
			["V"] = "V-LINE",
			[""] = "V-BLOCK",
			["s"] = "SELECT",
			["S"] = "S-LINE",
			[""] = "S-BLOCK",
			["r"] = "REPLACE",
			["rm"] = "REPLACE",
			["r?"] = "REPLACE",
			["R"] = "REPLACE",
			["Rv"] = "REPLACE",
			["c"] = "COMMAND",
			["cv"] = "COMMAND",
			["ce"] = "COMMAND",
			["t"] = "TERMINAL",
		}

		-- Enhanced CodeCompanion status function with model display
		local function codecompanion_status()
			local ok, codecompanion = pcall(require, "codecompanion")
			if not ok then
				return ""
			end

			-- Always start with CodeCompanion indicator since it's loaded
			local status_parts = { "🤖" }

			-- Try to get current adapter and model info
			local current_adapter = nil
			local current_model = nil

			-- First try to get from active chat
			local chat_ok, chat = pcall(codecompanion.last_chat)
			if chat_ok and chat and chat.adapter then
				current_adapter = chat.adapter.name or "active"
				if chat.adapter.schema and chat.adapter.schema.model then
					current_model = chat.adapter.schema.model.default or chat.adapter.schema.model
				end
			end

			-- If no active chat, get from config
			if not current_adapter and codecompanion.config then
				if
					codecompanion.config.strategies
					and codecompanion.config.strategies.chat
					and codecompanion.config.strategies.chat.adapter
				then
					current_adapter = codecompanion.config.strategies.chat.adapter

					-- Try to get model from adapter config
					if
						codecompanion.config.adapters
						and codecompanion.config.adapters.http
						and codecompanion.config.adapters.http[current_adapter]
						and type(codecompanion.config.adapters.http[current_adapter]) == "function"
					then
						local success, adapter_instance = pcall(codecompanion.config.adapters.http[current_adapter])
						if
							success
							and adapter_instance
							and adapter_instance.schema
							and adapter_instance.schema.model
							and adapter_instance.schema.model.default
						then
							current_model = adapter_instance.schema.model.default
						end
					end
				end
			end

			-- Add model/adapter info
			if current_model then
				-- Shorten model names for better display
				local short_model = current_model
					:gsub("claude%-sonnet%-4%-20250514", "Sonnet")
					:gsub("claude%-opus%-4%-5%-20251101", "Opus")
					:gsub("claude%-3%-5%-sonnet%-20241022", "3.5S")
					:gsub("claude%-3%-haiku%-20240307", "Haiku")
					:gsub("gpt%-4o", "GPT-4o")
					:gsub("gpt%-4", "GPT-4")
					:gsub("gpt%-3.5%-turbo", "GPT-3.5")
				table.insert(status_parts, short_model)
			elseif current_adapter then
				-- Show adapter name if model not available
				local short_adapter = current_adapter:gsub("anthropic", "Claude"):gsub("openai", "OpenAI")
				table.insert(status_parts, short_adapter)
			end

			-- Return the formatted string
			return table.concat(status_parts, " ")
		end

		local colors = {
			blue = "#65D1FF",
			green = "#3EFFDC",
			violet = "#FF61EF",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
			semilightgray = "#6b7280",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
				disabled_filetypes = { "NvimTree", "Avante" },
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_a = {
					{
						function()
							local mode = vim.fn.mode()
							if vim.g.lualine_use_short_modes then
								return short_mode_map[mode] or mode
							else
								return full_mode_map[mode] or mode
							end
						end,
					},
				},
				lualine_x = {
					{
						-- "codecompanion",
						codecompanion_status,
						color = { fg = colors.green },
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "filetype" },
				},
			},
		})

		-- Create command to toggle short modes
		vim.api.nvim_create_user_command("ToggleLualineShortModes", function()
			vim.g.lualine_use_short_modes = not vim.g.lualine_use_short_modes
			require("lualine").refresh()
			local status = vim.g.lualine_use_short_modes and "short (single letter)" or "full words"
			vim.notify("Lualine modes set to " .. status, vim.log.levels.INFO)
		end, {
			desc = "Toggle between short and full mode names in lualine",
		})
	end,
}
