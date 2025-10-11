-- ToggleTerm is a Neovim plugin that allows you to use multiple terminals inside of an editing session
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local toggleterm = require("toggleterm")
      local Terminal = require("toggleterm.terminal").Terminal

      toggleterm.setup({
        open_mapping = [[<C-\>]],
        shade_terminals = true,
        float_opts = { border = "curved" },
        size = function(term) -- Constrain the size of the terminal window
          if term.direction == "horizontal" then
            return 15 -- Height in rows
          elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4) -- 40% of editor width
          end
        end,
        direction = "float", -- Open up a floating window by default
      })

      -- Tables to track multiple terminals
      local terminals = {
        horizontal = {},
        vertical = {},
        float = {},
      }

      -- Helper function to create a new terminal
      local function create_terminal(direction)
        local term = Terminal:new({ direction = direction })
        table.insert(terminals[direction], term)
        term:toggle()
      end

      local function opts(desc)
        return { desc = "Terminal: " .. desc, noremap = true, silent = true, nowait = true }
      end

      -- Helper function to simplify the key mappings
      local function map_terminal(key, direction, desc)
        vim.keymap.set("n", key, function()
          create_terminal(direction)
        end, opts(desc))
      end

      -- Keymaps for spawning new independent terminals
      map_terminal("<leader>th", "horizontal", "New Horizontal Terminal")
      map_terminal("<leader>tv", "vertical", "New Vertical Terminal")
      map_terminal("<leader>tf", "float", "New Floating Terminal")

      -- Escape terminal mode
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
    end,
  },
}
