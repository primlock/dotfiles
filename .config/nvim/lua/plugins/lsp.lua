-- nvim-lspconfig is a plugin that provides a collection of pre-defined configurations for various 
-- Language Server Protocol (LSP) servers
return {
  {
    "neovim/nvim-lspconfig",
    -- Load this plugin only when you are either opening an existing file or creating a new one
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- We use mason as our LSP server manager
      "mason-org/mason.nvim",
      -- Bridge the mason plugin with the lspconfig plugin
      "mason-org/mason-lspconfig.nvim",
      -- Integrate LSP with cmp
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- Start Mason
      mason.setup()

      mason_lspconfig.setup({
        -- Install the defined LSP servers below
        ensure_installed = {
          "lua_ls",
          "clangd",
        },
        automatic_enable = false,
      })

      -- nvim-cmp capabilities for LSP
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Run this function when an LSP server attaches to a buffer. We are defining which keymaps are used to
      -- interact with the LSP servers.
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        local lsp_buf = vim.lsp.buf
        local lsp_diagnostic = vim.diagnostic

        -- Go to the definition of the symbol under the cursor
        vim.keymap.set("n", "gd", lsp_buf.definition, opts)
        -- Go to the declaration (e.g., for variables or functions)
        vim.keymap.set("n", "gD", lsp_buf.declaration, opts)
        -- Go to implementation(s) of a method/interface
        vim.keymap.set("n", "gi", lsp_buf.implementation, opts)
        -- Show all references to the symbol under the cursor
        vim.keymap.set("n", "gr", lsp_buf.references, opts)
        -- Show hover information (like function signatures or comments)
        vim.keymap.set("n", "K", lsp_buf.hover, opts)
        -- Rename the symbol under the cursor (refactors all usages)
        vim.keymap.set("n", "<leader>rn", lsp_buf.rename, opts)
        -- Show the diagnostic message(s)
        vim.keymap.set("n", "<C-d>", lsp_diagnostic.open_float, opts)
      end

      -- Define the diagnostic symbols
      local signs = {
          Error = "",
          Warn  = "",
          Hint  = "",
          Info  = "",
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- List of servers you want to manually configure. For the full list of options see 
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      local servers = {
        -- Lua configuration
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                  vim.env.VIMRUNTIME .. "/lua",
                  vim.env.VIMRUNTIME .. "/lua/vim/lsp",
                  "${3rd}/luv/library", -- for luv, Neovim's libuv bindings)
                },
                checkThirdParty = false,
              },
            },
          },
        },
        -- C/C++ configuration
        clangd = { },
      }

      -- Configure each server in the list to comply with the migration away from require("lspconfig") in
      -- favor of vim.lsp.config
      for server, config in pairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = config.settings,
        })

        -- Enable the server
        vim.lsp.enable(server, true)
      end
    end,
  },
}
