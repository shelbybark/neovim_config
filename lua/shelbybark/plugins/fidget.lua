return {
	"j-hui/fidget.nvim",
	event = "VeryLazy",
	opts = {
		-- Options related to LSP progress subsystem
		progress = {
			poll_rate = 0, -- How and when to poll for progress messages
			suppress_on_insert = false, -- Suppress new messages while in insert mode
			ignore_done_already = false, -- Ignore new tasks that are already complete
			ignore_empty_message = false, -- Ignore new tasks that don't contain a message
			clear_on_detach = function(client_id)
				local client = vim.lsp.get_client_by_id(client_id)
				return client and client.name or nil
			end,
			notification = {
				poll_rate = 10, -- How frequently to update and render the progress notifications
				filter = vim.log.levels.INFO, -- Minimum notifications level
				history_size = 128, -- Number of removed messages to retain in history
				override_vim_notify = false, -- Automatically override vim.notify() with Fidget
				configs = { -- How to configure notification groups when instantiated
					default = require("fidget.notification").default_config,
				},
				redirect = function(msg, level, opts)
					if opts and opts.on_open then
						return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
					end
				end,
				view = {
					stack_upwards = true, -- Display notification items from bottom to top
					icon_separator = " ", -- Separator between group name and icon
					group_separator = "---", -- Separator between notification groups
					group_separator_hl = "Comment", -- Highlight group used for group separator
					render_message = function(msg, cnt)
						return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
					end,
				},
			},
			lsp = {
				progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
			},
		},
		-- Options related to notification subsystem
		notification = {
			poll_rate = 10, -- How frequently to update and render the notification window
			filter = vim.log.levels.INFO, -- Minimum notifications level
			history_size = 128, -- Number of removed messages to retain in history
			override_vim_notify = false, -- Automatically override vim.notify() with Fidget
			configs = { -- How to configure notification groups when instantiated
				default = require("fidget.notification").default_config,
			},
			redirect = function(msg, level, opts)
				if opts and opts.on_open then
					return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
				end
			end,
			view = {
				stack_upwards = true, -- Display notification items from bottom to top
				icon_separator = " ", -- Separator between group name and icon
				group_separator = "---", -- Separator between notification groups
				group_separator_hl = "Comment", -- Highlight group used for group separator
				render_message = function(msg, cnt)
					return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
				end,
			},
			window = {
				normal_hl = "Comment", -- Base highlight group in the notification window
				winblend = 100, -- Background color opacity in the notification window
				border = "none", -- Border around the notification window
				zindex = 45, -- Stacking priority of the notification window
				max_width = 0, -- Maximum width of the notification window
				max_height = 0, -- Maximum height of the notification window
				x_padding = 1, -- Padding from right edge of window boundary
				y_padding = 0, -- Padding from bottom edge of window boundary
				align = "bottom", -- How to align the notification window
				relative = "editor", -- What the notification window position is relative to
			},
		},
		-- Options related to integrating with other plugins
		integration = {
			["nvim-tree"] = {
				enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if available)
			},
			["xcodebuild-nvim"] = {
				enable = true, -- Integrate with wojciech-kulik/xcodebuild.nvim (if available)
			},
		},
		-- Options related to logging
		logger = {
			level = vim.log.levels.WARN, -- Minimum logging level
			max_size = 10000, -- Maximum log file size, in KB
			float_precision = 0.01, -- Limit the number of decimals displayed for floats
			path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")), -- Where Fidget writes its logs to
		},
	},
}