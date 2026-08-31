-- Code formatting.
--
-- Formatters come from the toolchain the dotfiles already install:
--   pint       - per-project, via composer (Laravel's PHP formatter)
--   prettierd  - bin/npm-globals.txt
--   eslint_d   - bin/npm-globals.txt
--   stylua     - bin/Brewfile (honours nvim/.config/nvim/stylua.toml)

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        php = { "pint" },
        blade = { "blade-formatter" },
        javascript = { "prettierd", "eslint_d", stop_after_first = true },
        javascriptreact = { "prettierd", "eslint_d", stop_after_first = true },
        typescript = { "prettierd", "eslint_d", stop_after_first = true },
        typescriptreact = { "prettierd", "eslint_d", stop_after_first = true },
        vue = { "prettierd", "eslint_d", stop_after_first = true },
        css = { "prettierd" },
        scss = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        lua = { "stylua" },
      },
      format_on_save = function(bufnr)
        -- Let `:noautocmd w` skip formatting, and never fight a huge file.
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
    init = function()
      -- :Format / :FormatDisable / :FormatEnable
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "Disable format on save", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable format on save" })
    end,
  },
}
