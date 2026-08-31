-- Tailwind. nvim-lspconfig's defaults don't include blade, so class completion
-- wouldn't fire in Laravel templates without this.
---@type vim.lsp.Config
return {
  filetypes = {
    "blade",
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "typescript",
    "typescriptreact",
    "vue",
  },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        blade = "html",
      },
    },
  },
}
