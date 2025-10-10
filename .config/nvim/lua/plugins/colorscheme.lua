-- Define and set the colorscheme used by LazyVim
return {
  -- Import the colorschemes
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    init = function ()
      -- Enables or disables italics
      vim.g.nord_italic = false
    end,
  },
  {
    "sainnhe/everforest",
    name = "everforest",
  },
  {
    "agude/vim-eldar",
    name = "eldar"
  },
}
