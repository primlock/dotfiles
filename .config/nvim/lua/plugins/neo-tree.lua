-- neo-tree.nvim is a modern file explorer plugin for Neovim that allows you to browse and manage your
-- project’s files, buffers, and git status in a sidebar or floating window.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    -- Required utility functions
    "nvim-lua/plenary.nvim",
    -- UI components (for floating windows, inputs, etc.)
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Set legacy commands off to avoid warnings
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    require("neo-tree").setup({
      sources = { "filesystem", "buffers", "git_status" },
      position = "left",
      close_if_last_window = false,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        -- Follow Neovim’s current working directory
        bind_to_cwd = true,
        -- Focus the active buffer in the tree
        follow_current_file = true,
        use_libuv_file_watcher = true,
        filtered_items = {
          -- Show dotfiles by default
          hide_dotfiles = false,
          -- Hide .gitignored files
          hide_gitignored = false,
        },
      },
      window = {
        width = 25,
      },
    })

    -- Keymaps for Neo-tree
    local opts = { noremap = true, silent = true, desc = "Neo-tree: Toggle file explorer" }
    vim.keymap.set("n", "<leader>e", ":Neotree toggle left<CR>", opts)
  end,
}
