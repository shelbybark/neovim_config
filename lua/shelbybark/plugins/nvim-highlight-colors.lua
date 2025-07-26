return {
	"brenoprata10/nvim-highlight-colors",
	config = function()
		local highlight = require("nvim-highlight-colors")

		vim.opt.termguicolors = true

		highlight.setup({})
	end,
}
