return {

  "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },

  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("Comment").setup({
      -- ft.calculate uses a LanguageTree API that changed in Neovim 0.12 and crashes.
      -- This hook looks up the commentstring directly, bypassing the broken treesitter path.
      pre_hook = function(ctx)
        return require("Comment.ft").get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring
      end,
    })
  end,
}
