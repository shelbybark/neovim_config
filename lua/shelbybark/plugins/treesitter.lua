-- Treesitter configuration for syntax highlighting
-- Note: The new version of nvim-treesitter (post June 2023) dropped the module system.
-- Highlighting is now handled by Neovim's native treesitter API.
-- Text objects are handled by Neovim's native treesitter text objects (0.10+)
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		priority = 1000,
		build = ":TSUpdate",
		config = function()
			-- Install parsers
			require("nvim-treesitter").install({
				"astro",
				"bash",
				"c",
				"css",
				"diff",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"graphql",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"json5",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"ruby",
			})

			-- Enable treesitter highlighting for supported filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local ok = pcall(vim.treesitter.start)
					if not ok then
						-- Parser not available for this filetype
					end
				end,
			})

			-- Enable treesitter-based indentation for supported filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local ok = pcall(function()
						vim.opt_local.indentexpr = "v:lua.vim.treesitter.indentexpr()"
					end)
					if not ok then
						-- Parser not available for this filetype
					end
				end,
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
}
