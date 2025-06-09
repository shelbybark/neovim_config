return {
	"olimorris/codecompanion.nvim",
	lazy = true,
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		strategies = {
			chat = {
				adapter = "ollama",
			},
			inline = {
				adapter = "ollama",
			},
			cmd = {
				adapter = "ollama",
			},
		},
		adapters = {
			ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					env = {
						url = "http://10.72.2.200:11434",
						-- api_key = "OLLAMA_API_KEY",
						schema = {
							model = {
								default = "qwen2.5-coder:latest",
							},
						},
					},
					headers = {
						["Content-Type"] = "application/json",
						-- ["Authorization"] = "Bearer ${api_key}",
					},
					parameters = {
						sync = true,
					},
				})
			end,
		},
	},
}
