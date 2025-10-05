-- mason.nvim to manage the external editor tooling like LSP & DAP servers, linters and formatters. You might
-- notice "failed to install ..." errors when you start using mason.nvim which could be due to missing 
-- dependencies. You should ensure the following are installed on your system for mason.nvim to get archives:
--  git, wget, curl, unzip
return {
  "mason-org/mason.nvim",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }
}
