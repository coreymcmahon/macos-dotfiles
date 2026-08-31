-- Completion.
--
-- blink.cmp replaces nvim-cmp + cmp-nvim-lsp. Buffer, path, snippet and LSP
-- sources are built in, so there are no companion source plugins to install.

return {
  {
    "saghen/blink.cmp",
    -- Not lazy-loaded: blink registers its LSP capabilities from plugin/, which
    -- has to run before any server attaches, otherwise servers come up
    -- advertising Neovim's defaults and completion is degraded.
    lazy = false,
    version = "*", -- release tag ships the prebuilt fuzzy matcher binary
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "default", -- <C-y> accepts, <C-n>/<C-p> cycle, <C-e> hides
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          border = "rounded",
        },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
    opts_extend = { "sources.default" },
  },
}
