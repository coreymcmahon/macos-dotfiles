-- Treesitter: syntax highlighting, indentation and textobjects.
--
-- This targets the `main` branch of nvim-treesitter, which is a full rewrite and
-- requires Neovim 0.12+. The old `master` branch (ensure_installed/highlight
-- tables, `nvim-treesitter.configs`) is frozen and does not work on 0.12.

-- Blade is a first-class parser on the `main` branch, so it no longer needs a
-- custom install_info block, and Neovim 0.12 detects `*.blade.php` natively.
local ensure_installed = {
  "bash",
  "blade",
  "c",
  "comment",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "html",
  "http",
  "ini",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  "php",
  "php_only",
  "phpdoc",
  "printf",
  "python",
  "query",
  "regex",
  "scss",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
}

-- Treesitter indentation is unreliable for these, so leave them on Vim's own.
local no_indent = {
  yaml = true,
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local TS = require("nvim-treesitter")
      TS.setup({})

      -- Install anything we want that isn't present yet. This is async, so it
      -- doesn't block startup; parsers light up on the next buffer of that type.
      local installed = {}
      for _, lang in ipairs(TS.get_installed()) do
        installed[lang] = true
      end

      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, ensure_installed)

      if #missing > 0 then
        TS.install(missing)
      end

      -- Neovim 0.12 only enables treesitter highlighting for Markdown by
      -- default. Everything else has to be started explicitly.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(
          "treesitter_start",
          { clear = true }
        ),
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          -- Fails harmlessly when the parser isn't installed yet.
          if not pcall(vim.treesitter.start, ev.buf, lang) then
            return
          end

          if not no_indent[ft] then
            vim.bo[ev.buf].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true,
        keys = {
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
          },
        },
      },
      -- Carried over from the old master-branch config.
      select = {
        enable = true,
        lookahead = true,
        keys = {
          ["if"] = "@function.inner",
          ["af"] = "@function.outer",
          ["ia"] = "@parameter.inner",
          ["aa"] = "@parameter.outer",
          ["ic"] = "@class.inner",
          ["ac"] = "@class.outer",
        },
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter-textobjects")
      if TS.setup then
        TS.setup(opts)
      end

      local function attach(buf)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        if vim.tbl_get(opts, "select", "enable") then
          for key, query in pairs(vim.tbl_get(opts, "select", "keys") or {}) do
            vim.keymap.set({ "x", "o" }, key, function()
              require("nvim-treesitter-textobjects.select").select_textobject(
                query,
                "textobjects"
              )
            end, {
              buffer = buf,
              desc = "Select " .. query,
              silent = true,
            })
          end
        end

        if not vim.tbl_get(opts, "move", "enable") then
          return
        end

        local moves = vim.tbl_get(opts, "move", "keys") or {}
        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              local part = q:gsub("@", ""):gsub("%..*", "")
              part = part:sub(1, 1):upper() .. part:sub(2)
              table.insert(parts, part)
            end
            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc
              .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
            if not (vim.wo.diff and key:find("[cC]")) then
              vim.keymap.set({ "n", "x", "o" }, key, function()
                require("nvim-treesitter-textobjects.move")[method](
                  query,
                  "textobjects"
                )
              end, {
                buffer = buf,
                desc = desc,
                silent = true,
              })
            end
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(
          "treesitter_textobjects",
          { clear = true }
        ),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },

  -- Automatically add closing tags for HTML, JSX, Vue and Blade
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
