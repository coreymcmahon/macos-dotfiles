-- Laravel LSP - first-party Laravel language server (laravel/lsp).
--
-- Not shipped by nvim-lspconfig, so this is a full definition rather than an
-- override. Note nvim-lspconfig's `laravel_ls` is a *different*, community
-- server (laravel-ls/laravel-ls) - don't confuse the two.
--
-- Install:  composer global require laravel/lsp
-- Requires: PHP 8.2+, and ~/.composer/vendor/bin on $PATH

---@type vim.lsp.Config
return {
  cmd = { "laravel-lsp" },
  filetypes = { "php", "blade" },
  root_markers = { "artisan", "composer.json", ".git" },
}
