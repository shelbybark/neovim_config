return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>ac", desc = "Toggle Claude Code" },
	},
	config = function()
		require("claude-code").setup({
			window = {
				position = "botright vsplit",
				split_ratio = 0.38,
				enter_insert = true,
				hide_numbers = true,
				hide_signcolumn = true,
			},
			refresh = {
				enable = true,
				updatetime = 100,
				timer_interval = 500,
				show_notifications = true,
			},
			keymaps = {
				toggle = {
					normal = "<leader>ac",
					terminal = "<leader>ac",
				},
				window_navigation = true,
				scrolling = true,
			},
		})
	end,
}
