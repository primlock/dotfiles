-- Define and set the colorscheme used by LazyVim
return {
  -- Import the colorschemes
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    init = function ()
      -- Enables or disables italics
      vim.g.nord_italic = false

      -- Enables or disables bold text
      vim.g.nord_bold = false
    end,
  },
}
