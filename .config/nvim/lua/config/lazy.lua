-- lazy.nvim is a modern plugin manager for Neovim. Bootstrap the lazy.nvim version from the latest stable
-- release on github. This is not a special installation, it's boilerplate from the docs.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Modify the runtime path option to ensure that the lazy.nvim plugin manager is found and loaded correctly by
-- Neovim during startup
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- This setup uses a plugins directory to define our plugins as lua modules. All plugins defined in this
    -- directory will be loaded by lazy.nvim 
    { import = "plugins" }
  },
  install = {
    -- Install missing plugins on startup
    missing = true,
  },
  -- Do not automatically check for plugin updates, perform this manually with :Lazy sync
  checker = { enabled = false },
})

