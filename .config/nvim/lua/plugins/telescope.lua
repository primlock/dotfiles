-- telescope.nvim is a highly extendable fuzzy finder that helps navigate, search, and manage files within
-- Neovim
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- ensure you have 'make' installed to compile fzf
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
        },
        pickers = {
          find_files = {
            hidden = true, -- include dotfiles
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- true for fuzzy matching
            override_generic_sorter = true,  -- override the default generic sorter
            override_file_sorter = true,     -- override the default file sorter
            case_mode = "smart_case",        -- or "ignore_case" / "respect_case"
          },
        },
      })

      -- Load the fzf extension
      telescope.load_extension("fzf")

      -- Keymaps for Telescope
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { silent = true, desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { silent = true, desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { silent = true, desc = "List open buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { silent = true, desc = "Search help tags" })
    end,
  },
}
