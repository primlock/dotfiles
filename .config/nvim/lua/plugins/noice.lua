-- noice is an plugin designed to overhaul the user interface for messages, the command line, and the 
-- popupmenu
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      progress = {
        enabled = true,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      -- Use a classic bottom cmdline for search
      bottom_search = true,
      -- Position the cmdline and popupmenu together
      command_palette = true,
      -- Long messages will be sent to a split
      long_message_to_split = true,
      -- Enables an input dialog for inc-rename.nvim
      inc_rename = false,
      -- Add a border to hover docs and signature help
      lsp_doc_border = false,
    },
  },
}
