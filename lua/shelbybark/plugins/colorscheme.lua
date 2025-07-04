return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				custom_highlights = function(colors)
					return {
						LineNr = { fg = "#838DA0", bg = "#495060" },
					}
				end,
			})
			-- load the colorscheme here
			-- vim.cmd([[colorscheme catppuccin]])
		end,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			local bg = "#011628"
			local bg_dark = "#011423"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#838DA0"
			local bg_gutter = "#495060"
			local border = "#547998"

			require("tokyonight").setup({
				style = "night",
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = bg_dark
					colors.bg_float = bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = bg_dark
					colors.bg_statusline = bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.bg_gutter = bg_gutter
					colors.fg_sidebar = fg_dark
				end,
			})
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
			-- Sets colors to line numbers Above, Current and Below  in this order
			function LineNumberColors()
				vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#51B3EC", bg = "#495060", bold = true })
				vim.api.nvim_set_hl(0, "LineNr", { fg = "#838DA0", bg = "#495060", bold = true })
				vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#FB508F", bg = "#495060", bold = true })
			end
			LineNumberColors()
		end,
	},
	-- {
	--   "navarasu/onedark.nvim",
	--   priority = 1000, -- make sure to load this before all the other start plugins
	--   config = function()
	--     require('onedark').setup {
	--       style = 'deep',
	--       -- Custom Highlights --
	--       colors = {
	--         line_bg = "#495060",    -- define a new color
	--         line_fg = "#838DA0",    -- define a new color
	--       }, -- Override default colors
	--       highlights = {
	--         ["LineNr"] = {fg = '$line_fg', bg = '$line_bg', fmt = 'none'},
	--       }, -- Override highlight groups
	--     }
	--     -- Enable theme
	--     require('onedark').load()
	--   end
	-- }
}
