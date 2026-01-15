-- neo-tree.nvim is a modern file explorer plugin for Neovim that allows you to browse and manage your
-- project’s files, buffers, and git status in a sidebar or floating window.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- Required utility functions
    "nvim-tree/nvim-web-devicons",   -- File type icons
    "MunifTanjim/nui.nvim",          -- UI components (for floating windows, inputs, etc.)
  },
  config = function()
    -- Set legacy commands off to avoid warnings
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    require("neo-tree").setup({
      sources = { "filesystem", "buffers", "git_status" },
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        bind_to_cwd = true,         -- Follow Neovim’s current working directory
        follow_current_file = true, -- Focus the active buffer in the tree
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,    -- Show dotfiles by default
          hide_gitignored = false,   -- Hide .gitignored files
        },
      },

      window = {
        width = 30,                  -- Applies to the sidebar
        popup = {
          size = {
            height = "70%",          -- Change vertical size
            width = "40%",           -- Change horizontal size
          },
          position = "50%",          -- Center the popup
          title = function() return "File Explorer" end,
          title_pos = "center",
        },
        border = {
          style = "rounded",
          padding = { 1, 2 },
        },
        mappings = {
          ["<CR>"] = "open",         -- Open the selected file or folder
          ["<BS>"] = "navigate_up",  -- Go up one directory
          ["R"] = "refresh",         -- Refresh the tree
          ["a"] = "add",             -- Create a new file
          ["d"] = "delete",          -- Delete selected file
          ["r"] = "rename",          -- Rename selected file
        },
      },
    })

    -- Match Neo-tree background to Everforest
    local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    local border_color ="#3b4439"

    vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = bg })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = bg })
    vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = bg })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = bg, bg = bg })
    vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = border_color, bg = bg })
    vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { bg = bg, fg = vim.api.nvim_get_hl(0, { name = "Title" }).fg })

    -- Keymaps for Neo-tree
    local opts = { noremap = true, silent = true, desc = "Neo-tree: Toggle file explorer" }
    vim.keymap.set("n", "<leader>e", ":Neotree toggle float<CR>", opts)

    -- Optional: open in sidebar instead of floating
    -- vim.keymap.set("n", "<leader>e", ":Neotree toggle left<CR>", opts)
  end,
}
