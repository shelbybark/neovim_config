-- lua/plugins/mason.lua
return {
	-- Make mason-lspconfig the primary spec and feed it opts
	"mason-org/mason-lspconfig.nvim",
	opts = {
		-- LSPCONFIG SERVER NAMES here
		ensure_installed = {
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"graphql",
			"emmet_language_server", -- valid id in modern lspconfig
			-- "ts_ls",
			-- "prismals",
		},
		-- automatic_enable = true, -- default; can omit
	},
	dependencies = {
		-- Ensure mason is set up first (we’ll give it opts inline)
		{
			"mason-org/mason.nvim",
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		},

		-- CRITICAL: guarantee lspconfig is on rtp before mason-lspconfig runs
		"neovim/nvim-lspconfig",

		-- Tools installer (uses Mason package names, not LSP ids)
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	config = function(_, opts)
		-- mason-lspconfig via opts
		require("mason-lspconfig").setup(opts)

		-- tools installer stays separate and uses Mason package names
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
				"django-template-lsp",
				"superhtml",
				"djlint",
			},
			run_on_start = true,
		})
	end,
}
