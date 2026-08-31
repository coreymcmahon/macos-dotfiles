-- Blade files are HTML-shaped, so let the HTML server work in them too.
---@type vim.lsp.Config
return {
  filetypes = { "html", "templ", "blade" },
}
