-- Put this inside your plugins/lazy.lua setup
return {
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '▁' },
          topdelete    = { text = '▔' },
          changedelete = { text = '▒' },
          untracked    = { text = '╏' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 500,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        watch_gitdir = {
          follow_files = true
        },
        attach_to_untracked = true,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }

	  -- Setup the key mappings for gitsigns
	  vim.keymap.set('n', '<leader>gb', function()
		require('gitsigns').toggle_current_line_blame()
	  end, { desc = 'Toggle git blame for current line' })
    end
  }
}
