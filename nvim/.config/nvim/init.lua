-- This config targets Neovim 0.12+: nvim-treesitter's `main` branch and the
-- native vim.lsp.config API both require it. Fail loudly rather than throwing
-- confusing errors from half-loaded plugins.
if vim.fn.has("nvim-0.12") == 0 then
  vim.api.nvim_echo({
    {
      "This config requires Neovim 0.12+, found "
        .. tostring(vim.version())
        .. "\n",
      "ErrorMsg",
    },
    { "Upgrade with: brew upgrade neovim\n", "WarningMsg" },
  }, true, {})
  return
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
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
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("keymaps")

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    version = false, -- always use the latest commit, not the last release tag
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
