-- Treesitter configuration for syntax highlighting and text objects
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		priority = 1000,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"astro", "bash", "c", "css", "diff", "go", "gomod", "gowork", "gosum",
					"graphql", "html", "javascript", "jsdoc", "json", "jsonc", "json5",
					"lua", "luadoc", "luap", "markdown", "markdown_inline", "python",
					"query", "regex", "toml", "tsx", "typescript", "vim", "vimdoc",
					"yaml", "ruby",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			multiwindow = true,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "BufReadPre",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
		},
	},
}
