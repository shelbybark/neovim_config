-- ~/.config/nvim/lua/plugins/lspconfig.lua
return {
	"neovim/nvim-lspconfig",
	lazy = false, -- load on start; adjust if you prefer events
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },

		-- Mason moved orgs; the old URLs redirect but it's cleaner to update.
		{ "mason-org/mason.nvim", opts = {} },
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				-- Optional: let Mason auto-install. Add server IDs here as you like.
				-- ensure_installed = { "lua_ls", "emmet-language-server" },
				-- By default, mason-lspconfig v2 will auto-enable installed servers for you.
				-- See: :help mason-lspconfig-settings
				-- automatic_enable = true,
			},
			dependencies = { "neovim/nvim-lspconfig" },
		},
	},

	config = function()
		-----------------------------------------------------------------------
		-- 1) Global LSP keymaps (buffer-local) via LspAttach (recommended)
		-----------------------------------------------------------------------
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
			callback = function(ev)
				local buf = ev.buf
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
				end

				-- examples: tweak to your taste
				map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
				map("n", "gd", vim.lsp.buf.definition, "LSP: Goto Definition")
				map("n", "gD", vim.lsp.buf.declaration, "LSP: Goto Declaration")
				map("n", "gi", vim.lsp.buf.implementation, "LSP: Goto Implementation")
				map("n", "gr", vim.lsp.buf.references, "LSP: References")
				map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
				map({ "n", "x" }, "=", function()
					vim.lsp.buf.format({ async = true })
				end, "LSP: Format")
				map("n", "[d", vim.diagnostic.goto_prev, "Diag: Prev")
				map("n", "]d", vim.diagnostic.goto_next, "Diag: Next")
				map("n", "<leader>e", vim.diagnostic.open_float, "Diag: Float")
			end,
		})

		-----------------------------------------------------------------------
		-- 2) Diagnostics signs (same icons you had; adjust if you used others)
		-----------------------------------------------------------------------
		local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-----------------------------------------------------------------------
		-- 3) Capabilities (nvim-cmp) applied to *all* servers
		-----------------------------------------------------------------------
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- Set defaults for every LSP config via the special "*" name.
		-- :help lsp-config-merge
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-----------------------------------------------------------------------
		-- 4) Server-specific tweaks using the new API
		--    You can do these here OR drop files in: ~/.config/nvim/lsp/<name>.lua
		--    (Nvim auto-merges those with upstream configs)
		-----------------------------------------------------------------------

		-- Emmet: keep your custom filetypes (html, htmldjango, svelte, etc)
		vim.lsp.config("emmet_ls", {
			-- tip: if you prefer the newer server, Mason also ships "emmet-language-server"
			-- In that case, use server name: "emmet_language_server" instead of "emmet_ls".
			filetypes = {
				"css",
				"eruby",
				"html",
				"htmldjango",
				"javascript",
				"javascriptreact",
				"less",
				"python",
				"sass",
				"scss",
				"svelte",
				"pug",
				"typescriptreact",
				"vue",
				"php",
			},
			init_options = {
				html = { options = { ["bem.enabled"] = true } },
			},
		})

		-- (Example) Lua: make LuaLS happy in Neovim configs
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim", "require" } },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		-- (Example) Svelte: notify TS/JS change (matches common lspconfig advice)
		vim.lsp.config("svelte", {
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					group = vim.api.nvim_create_augroup("SvelteTSNotify", { clear = true }),
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_fname(ctx.file) })
					end,
					buffer = bufnr,
				})
			end,
		})

		-- (Example) GraphQL alongside React/Svelte
		vim.lsp.config("graphql", {
			filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact", "svelte" },
		})

		-----------------------------------------------------------------------
		-- 5) Enabling servers
		--
		-- With mason-lspconfig v2, installed servers are auto-enabled by default.
		-- If you also have some servers NOT installed via Mason (system PATH),
		-- explicitly enable them here:
		--
		--   vim.lsp.enable("emmet_ls")
		--   vim.lsp.enable("lua_ls")
		--   vim.lsp.enable("svelte")
		--   vim.lsp.enable("graphql")
		--
		-- Otherwise, you can rely on Mason’s automatic_enable for anything it installs.
		-----------------------------------------------------------------------
	end,
}
