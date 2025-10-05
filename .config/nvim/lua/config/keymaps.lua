-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Normal Mode

vim.keymap.set ("n", "<C-k>", "<C-W><C-K>")	  -- Focus top split
vim.keymap.set ("n", "<C-j>", "<C-W><C-J>")	  -- Focus bottom split
vim.keymap.set ("n", "<C-l>", "<C-W><C-L>")	  -- Focus right split
vim.keymap.set ("n", "<C-h>", "<C-W><C-H>")	  -- Focus left split
vim.keymap.set ("n", "=", ":res -2<CR>") 		  -- Decrease window height
vim.keymap.set ("n", "-", ":res +2<CR>") 		  -- Increase window height
vim.keymap.set ("n", "+", ":vert res -2<CR>")	-- Decrease window width
vim.keymap.set ("n", "_", ":vert res +2<CR>")	-- Increase window width

-- Insert Mode

vim.keymap.set("i", "jk", "<Esc>")

-- Visual Mode

vim.keymap.set ("v", ">", ">gv") -- Don't exit visual after indent
vim.keymap.set ("v", "<", "<gv") -- Don't exit visual after outdent

-- Visual Mode (No Select)

vim.keymap.set("x", "p", [["_dP]]) -- Replace selected text without yanking it
