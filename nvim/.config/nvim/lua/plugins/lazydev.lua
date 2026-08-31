-- Proper completion and diagnostics for the Neovim Lua API while editing this
-- config. Configures lua_ls with the right library paths on the fly.
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
