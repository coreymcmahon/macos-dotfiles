-- lazydev.nvim supplies the Neovim runtime library paths, so this only needs
-- the workspace/telemetry bits.
---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true },
      format = { enable = false }, -- stylua owns formatting
    },
  },
}
