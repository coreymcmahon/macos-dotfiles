-- file searching / live greppin' / ...
return {
  { -- use telescope picker for select items in neovim
    "nvim-telescope/telescope-ui-select.nvim",
  },

  { -- telescope core
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "jvgrootveld/telescope-zoxide",
      "nvim-tree/nvim-web-devicons",
      -- Native fzf sorter; markedly faster on large repos.
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local z_utils = require("telescope._extensions.zoxide.utils")
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
            width = 0.9,
            height = 0.9,
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "vendor/",
            "%.lock",
            "__pycache__",
            "dist/",
            "build/",
            "*.min.js",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
            "--hidden",
            "--glob=!.git/",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<esc>"] = actions.close,
              ["<C-u>"] = false, -- clear the prompt rather than scrolling
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "fd",
              "--type",
              "f",
              "--hidden",
              "--follow",
              "--exclude",
              ".git",
              "--exclude",
              "node_modules",
              "--exclude",
              "vendor",
              "--exclude",
              "dist",
              "--exclude",
              "build",
              "--strip-cwd-prefix",
            },
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!.git/" }
            end,
          },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = {
              i = { ["<c-d>"] = actions.delete_buffer },
            },
          },
          oldfiles = {
            cwd_only = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          undo = {
            mappings = {
              i = {
                ["<s-cr>"] = require("telescope-undo.actions").yank_additions,
                ["<c-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<cr>"] = require("telescope-undo.actions").restore,
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          zoxide = {
            prompt_title = "Zoxide",
            mappings = {
              default = {
                after_action = function(selection)
                  print(
                    "Update to (" .. selection.z_score .. ") " .. selection.path
                  )
                end,
              },
              ["<C-q>"] = { action = z_utils.create_basic_command("split") },
            },
          },
        },
      })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("undo")
      require("telescope").load_extension("zoxide")
    end,
  },
}
