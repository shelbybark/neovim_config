return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"j-hui/fidget.nvim",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "openai",
				},
				inline = {
					adapter = "openai",
				},
			},
			adapters = {},
		},
		config = function(_, opts)
			local api_key = ""
			local handle = io.popen("pass openai/api_key")
			if handle then
				api_key = handle:read("*a"):gsub("%s+$", "")
				handle:close()
			end

			opts.adapters.openai = function()
				return require("codecompanion.adapters").extend("openai", {
					env = {
						api_key = api_key,
					},
				})
			end
			-- opts.adapters.openai = require("codecompanion.adapters").extend("openai", {
			-- 	env = {
			-- 		api_key = api_key,
			-- 	},
			-- })

			require("codecompanion").setup(opts)

			local progress = require("fidget.progress")
			local handles = {}
			local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeCompanionRequestStarted",
				group = group,
				callback = function(e)
					handles[e.data.id] = progress.handle.create({
						title = "CodeCompanion",
						message = "Thinking...",
						lsp_client = { name = e.data.adapter.formatted_name },
					})
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeCompanionRequestFinished",
				group = group,
				callback = function(e)
					local h = handles[e.data.id]
					if h then
						h.message = e.data.status == "success" and "Done" or "Failed"
						h:finish()
						handles[e.data.id] = nil
					end
				end,
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},
}
