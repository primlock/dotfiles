-- This is our plugin configuration for lualine. It uses the everforest theme which has it's own configuration
-- at lualine/themes/everforest.lua
    -- local colorscheme = vim.g.current_colorscheme or "auto"
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
      -- Set laststatus to 0 on init to hide the statusline before lualine loads
      vim.opt.laststatus = 0
  end,
  config = function()
    -- Set laststatus to 3 in config to show a single global statusline across all windows
    vim.opt.laststatus = 3

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha" },
      },
      sections = {
        lualine_a = {
          { "mode", padding = 2 }
        },
        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
        },
        lualine_c = {},
        lualine_x = {
          { "filename", padding = 2 }
        },
        lualine_y = {},
        lualine_z = {}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "nvim-tree", "fzf" },
    })
  end
}
