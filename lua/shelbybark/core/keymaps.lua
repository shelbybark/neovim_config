-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- no neck pain (simple narrow view)
-- keymap.set("n", "<leader>nn", ":NoNeckPain<CR>", { desc = "View with wide margin" })

-- wrap mode
keymap.set("n", "<leader>w", ":ToggleWrapMode<CR>", { desc = "Toggle wrap mode" })

-- bufferline
keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Go to next tab" })
keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>x", ":BufDel<CR>", { desc = "Close Current Tab" })

-- Fterm
keymap.set("n", "<leader>q", "<cmd>lua require'FTerm'.toggle()<cr>", { desc = "Open floating term" })

-- Comment
keymap.set("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
keymap.set(
	"v",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Toggle comment" }
)

-- Indents for visual selection
keymap.set("v", ">", ">gv", { desc = "Indent Visual Selection" })
keymap.set("v", "<", "<gv", { desc = "Indent Visual Selection" })
