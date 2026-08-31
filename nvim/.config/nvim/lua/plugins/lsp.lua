-- Language Server Protocol
--
-- Server *definitions* live in `lsp/` and `after/lsp/` (Neovim 0.11+ convention):
--   lsp/<name>.lua        - servers Neovim/nvim-lspconfig don't ship
--   after/lsp/<name>.lua  - overrides merged on top of nvim-lspconfig's defaults
--
-- The servers themselves are installed by the dotfiles, not by Mason:
--   npm globals   -> bin/npm-globals.txt, installed by bin/setup-mise.sh
--   laravel-lsp   -> composer global require laravel/lsp

local servers = {
  "bashls",
  "cssls",
  "emmet_ls",
  "html",
  "intelephense", -- general PHP
  "jsonls",
  "laravel_lsp", -- first-party Laravel LSP (routes, views, config, translations)
  "lua_ls", -- brew; paired with lazydev.nvim for the Neovim API
  "tailwindcss",
  "vtsls", -- TypeScript/JavaScript, plus Vue via @vue/language-server
  "vue_ls",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.enable(servers)

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = true },
        virtual_text = { spacing = 2, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      -- Neovim 0.11+ ships gr-prefixed LSP maps: grn (rename), gra (code
      -- action), grr (references), gri (implementation), grt (type definition),
      -- grx (codelens). Do NOT map a bare `gr` - it shadows that whole prefix
      -- and makes every gr* press wait for 'timeoutlen'. We just point the
      -- existing maps at Telescope instead.
      --
      -- gd and ga replace built-in *motions*, not mappings, so they are
      -- unambiguous: `gd` (local declaration) and `ga` (:ascii).
      local keymaps = {
        { "grr", "<cmd>Telescope lsp_references<cr>", "References" },
        { "gri", "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
        { "grt", "<cmd>Telescope lsp_type_definitions<cr>", "Type definition" },
        { "gd", "<cmd>Telescope lsp_definitions<cr>", "Goto definition" },
        { "ga", vim.lsp.buf.code_action, "Code action" },
        { "<leader>d", vim.diagnostic.open_float, "Line diagnostics" },
        { "<leader>lr", "<cmd>LspRestart<cr>", "Restart LSP" },
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(ev)
          for _, m in ipairs(keymaps) do
            vim.keymap.set("n", m[1], m[2], {
              buffer = ev.buf,
              desc = m[3],
              silent = true,
            })
          end
        end,
      })
    end,
  },
}
