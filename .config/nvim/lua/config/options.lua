-- Enable line numbers
vim.opt.number = true

-- Enable relative numbering position
vim.opt.relativenumber = true

-- Enable copying and pasting between vim and the system's clipboard
vim.opt.clipboard:append("unnamedplus")

-- Define the the equivalent number of spaces
vim.opt.tabstop = 4

-- Length to use when shifting text (0 for tabstop)
vim.opt.shiftwidth = 0

-- The length to use when editing text
-- vim.opt.softtabstop = 0

-- Use spaces when pressing <TAB>
-- vim.opt.expandtab = true -- use spaces

-- Disable word wrapping in vim
vim.opt.wrap = false

-- Use the dark background inside of vim
vim.opt.background = "dark"

-- Reproduce the indentation of the previous line
vim.opt.autoindent = true

-- Indent appropriately before/after {} for c-like languages
vim.opt.smartindent = true

-- Use GUI colors for display elements, rather than the terminal's 256-color palette
vim.opt.termguicolors = true

-- Define the default text with that should be used when formatting
vim.opt.textwidth = 110

-- Visually show the whitespace characters
if vim.fn.has("multi_byte") == 1 and vim.o.encoding == "utf-8" then
    vim.opt.listchars = {
        tab = "▸ ",
        trail = "~",
        extends = "❯",
        precedes = "❮",
        nbsp = "±",
    }
else
    vim.opt.listchars = {
        tab = "> ",
        trail = "~",
        extends = ">",
        precedes = "<",
        nbsp = ".",
    }
end
vim.opt.list = true
