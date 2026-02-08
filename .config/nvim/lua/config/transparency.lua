-- Set the background element colors to be transparent so the opacity can be controlled by the terminal
-- setting the opacity

local groups = {
  "Normal",
  "NormalNC",
  "EndOfBuffer",
  "SignColumn",
  "LineNr",
  "FoldColumn",
  "VertSplit",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
}

local function set_transparent()
  for _, group in ipairs(groups) do
    vim.cmd("highlight " .. group .. " guibg=NONE ctermbg=NONE")
  end
end

-- Run once on startup
set_transparent()

-- Re-run whenever the colorscheme changes
vim.api.nvim_create_autocmd("colorscheme", {
  callback = set_transparent,
})

