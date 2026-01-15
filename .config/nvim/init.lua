-- Our Neovim environment configurations that aren't plugins
require("config.keymaps")
require("config.options")
require("config.autocmds")
require("config.lazy")

-- Set the colorscheme for Neovim, refer to colorscheme for options
local colorscheme = "nord"
vim.cmd.colorscheme(colorscheme)
vim.g.current_colorscheme = colorscheme
