-- Everforest is a green based color scheme; it's designed to be warm and soft in order to protect developers
-- eyes. This colorscheme is intended to be paired with FiraCode Nerd Font
return {
      'sainnhe/everforest',
      lazy = false,
      priority = 1000,
      config = function()
        -- Enable italic in this color scheme
        vim.g.everforest_enable_italic = 1

        -- Keep comments italic
        vim.g.everforest_disable_italic_comment = 0

        -- The background contrast used in this color scheme [hard, medium, soft]
        vim.g.everforest_background = "hard"

        -- Customize the cursor color [auto, red, orange, yellow, green, aqua, blue, purple]
        vim.g.everforest_cursor = "auto"

        -- Highlight error/warning/info/hint texts for supported plugins. This option  highlights the 
        -- background of them
        vim.g.everforest_diagnostic_text_highlight = 1

        -- Set the colorscheme for Neovim
        vim.cmd.colorscheme('everforest')
      end
}
