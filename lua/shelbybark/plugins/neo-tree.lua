-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	keys = {
		{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
	},
	opts = {
		default_component_configs = {
			indent = {
				with_expanders = true, -- show arrows next to folders
				expander_collapsed = "", -- closed icon
				expander_expanded = "", -- open icon (pick whatever you like)
				-- optional niceties:
				indent_size = 2,
				padding = 1,
				with_markers = true,
				expander_highlight = "NeoTreeExpander",
			},
		},
		filesystem = {
			window = {
				mappings = {
					["\\"] = "close_window",
				},
			},
		},
	},
}
