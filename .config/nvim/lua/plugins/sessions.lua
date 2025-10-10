-- session-select.nvim is a lightweight session management plugin for Neovim that allows users to easily save,
-- visually select and load, and delete sessions with minimal automation.
return {
  {
    "xorangekiller/session-select.nvim",
    dependencies = {
      "stevearc/dressing.nvim", -- ensures Telescope-style UI for session selection
    },
    config = function ()
      require("session-select").setup({
        cmd = {
          "SaveSession",
          "LoadSession",
          "DeleteSession",
        },
        opts = {},
      })
    end,
  }
}
