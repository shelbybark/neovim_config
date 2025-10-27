return {
	"mason-org/mason.nvim",
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- Use LSPCONFIG SERVER NAMES here
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_language_server", -- <- was "emmet_ls"
				"prismals",
				-- "ts_ls", -- <- if you enable TypeScript later
			},
			-- automatic_enable = true, -- default in v2; can omit
		})

		mason_tool_installer.setup({
			-- Use MASON PACKAGE NAMES here
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
