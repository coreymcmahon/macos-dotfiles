-- Overrides merged on top of nvim-lspconfig's intelephense defaults.
--
-- Intelephense is freemium: rename, code actions and a few other features need
-- a licence key. Drop the key in ~/.config/intelephense/licence.txt and it gets
-- picked up automatically.
local licence = vim.fn.expand("~/.config/intelephense/licence.txt")

---@type vim.lsp.Config
return {
  init_options = {
    licenceKey = vim.uv.fs_stat(licence) and licence or nil,
  },
  settings = {
    intelephense = {
      files = {
        -- Laravel apps blow past the 1MB default on some vendor files.
        maxSize = 5000000,
      },
      environment = {
        includePaths = {
          -- Picked up by Laravel IDE Helper, if the project uses it.
          "_ide_helper.php",
          "_ide_helper_models.php",
        },
      },
    },
  },
}
