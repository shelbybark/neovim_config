return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			--mode = "tabs",
			separator_style = "slant",
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "center",
					separator = true, -- use a "true" to enable the default, or set your own character
				},
			},
		},
	},
}
