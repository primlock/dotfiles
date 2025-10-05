-- nvim-cmp is a completion engine for Neovim. The completion sources are installed from external
-- repositories and are sourced by the plugin.
return {
  "hrsh7th/nvim-cmp",
 -- Only load this plugin when you enter Insert mode
  event = "InsertEnter",
  dependencies = {
    -- LSP completions
    "hrsh7th/cmp-nvim-lsp",
    -- filesystem paths
    "hrsh7th/cmp-path",
    -- command-line completions
    "hrsh7th/cmp-cmdline",
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      -- Modify the completion key mappings when in "Insert Mode"
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      -- Define the types of suggestions you're going to recieve from completion
      sources = cmp.config.sources({
        -- LSP based suggestions
        { name = "nvim_lsp" },
        -- Filesystem path suggestions
        { name = "path" },
      }),
    })
  end,
}
