-- dashboard-nvim is a low-memory usage startup screen for Neovim.
return {
 "nvimdev/dashboard-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = 'VimEnter',
  config = function()
    local datetime = os.date("%Y-%m-%d %H:%M:%S")
    -- Header style
    vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#5E81AC", bold = true })
    -- Footer style
    vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#E5E9F0", italic = true })

    require('dashboard').setup({
      theme = 'hyper',
      config = {
        header = {
          "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
          "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
          "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
          "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          "",
          datetime,
          "",
        },
        -- show how many plugins neovim loaded
        packages = { enable = false },
        -- The group field is just the highlight group that gets applied to the text, you can use any valid
        -- Neovim highlight group.
        -- Normal, Comment Constant, String, Character, Number, Boolean, Float, Identifier, Function, etc.
        shortcut = {
          { desc = ' Update', group = '@keyword', action = 'Lazy update', key = 'u' },
          {
            icon_hl = '@variable',
            desc = ' files',
            group = '@Error',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' keymaps',
            group = 'String',
            action = 'Telescope keymaps',
            key = 'a',
          },
          {
            desc = ' commands',
            group = 'Number',
            action = 'Telescope commands',
            key = 'd',
          },
          {
            desc = 's sessions',
            group = 'PreCondit',
            action = 'LoadSession',
            key = 'l',
          },
        },
        footer = {
          "",
          -- Insert quote here
          ""
        },
      },
    })
  end
}
