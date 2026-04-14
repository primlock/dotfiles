-- Autocmds sets up automatic commands that trigger on events such as opening a file,
-- allowing buffer-local settings like indentation to be applied based on filetype

-- Indentation based on file extension
local augroup = vim.api.nvim_create_augroup("IndentationRules", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "python", "yaml", "json" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp", "make" },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"lua", "sh", "html", "css"},
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local ok, palette_mod = pcall(require, "github-theme.palette")
    if not ok then return end

    local palette = palette_mod.load("github_dark_dimmed")
    if not palette then return end

    local orange = palette.scale.orange[4]
    local blue = palette.scale.blue[4]

    vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = blue })
    vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = orange })
  end,
})

