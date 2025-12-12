return {
	"milanglacier/minuet-ai.nvim",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"nvim-lua/plenary.nvim",
	},
	event = "InsertEnter",
	config = function()
		require("minuet").setup({
			provider = "gemini",
			provider_options = {
				gemini = {
					model = "gemini-1.5-flash", -- or "gemini-1.5-pro"
					api_key = "GEMINI_API_KEY", -- Environment variable name
					max_tokens = 512,
					temperature = 0.1,
					top_p = 1,
				},
			},
			-- Completion settings
			completion = {
				enabled = true,
				auto_trigger = true,
				trigger_delay = 100, -- ms
				max_lines = 20,
			},
			-- Display settings
			display = {
				ghost_text = {
					enabled = true,
					hl_group = "Comment",
				},
				notification = {
					enabled = true,
					timeout = 3000,
				},
			},
			-- Keymaps
			keymaps = {
				accept = "<Tab>",
				accept_word = "<C-Right>",
				accept_line = "<C-Down>",
				dismiss = "<C-c>",
				cycle_next = "<C-]>",
				cycle_prev = "<C-[>",
			},
		})
	end,
}
