-- Bufferline is a plugin that provides a visual tab-like user interface, often at the top of the screen, to 
-- manage and switch between open buffers
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    require('bufferline').setup({
      options = {
        buffer_close_icon = '󰅖',
        modified_icon = '● ',
        close_icon = ' ',
        left_trunc_marker = ' ',
        right_trunc_marker = ' ',
        separator_style = "slant",
      }
    })

    -- Cycle buffers
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { silent = true })
    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { silent = true })

    -- Reorder buffers
    vim.keymap.set("n", "<A-l>", "<cmd>BufferLineMoveNext<CR>", { silent = true })
    vim.keymap.set("n", "<A-h>", "<cmd>BufferLineMovePrev<CR>", { silent = true })

    -- Close buffer
    vim.keymap.set("n", "<S-w>", "<cmd>bdelete<CR>", { silent = true })
  end
}

