-- mini.pairs is a plugin to manage the automatic pairing of characters like brackets, quotes, and other 
-- user-defined pairs
return {
  -- mini.pairs is a minimal and fast auto pairs plugin, i.e., ([{}])
  "echasnovski/mini.pairs",
  -- Load this plugin as late as possible during the startup process
  event = "VeryLazy",
  opts = {
    -- In which modes mappings from this `config` should be created
    modes = { insert = true, command = false, terminal = false },
    -- Global mappings. Each right hand side should be a pair information, a table with at least these fields:
    --  <action> - one of 'open', 'close', 'closeopen'
    --  <pair> - two character string for pair to be used
    -- By default pair is not inserted after `\`, quotes are not recognized by <CR>, `'` does not insert pair
    -- after a letter
    mappings = {
      ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
      ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
      ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

      [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
      [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
      ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

      ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    },
  }
}
