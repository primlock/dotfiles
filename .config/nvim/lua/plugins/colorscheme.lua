-- Define and set the colorscheme used by LazyVim
return {
  -- Import the colorschemes
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    init = function()
      -- options: github_dark, github_dark_dimmed, github_dark_tritanopia
      vim.cmd('colorscheme github_dark_dimmed')
      vim.g.current_colorscheme = "github_dark_dimmed"
    end,
  },
}
