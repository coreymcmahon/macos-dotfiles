-- file searching / live greppin' / ...
return {
    { -- use telescope picker for select items in neovim
      "nvim-telescope/telescope-ui-select.nvim",
    },
  
    { -- telescope core
      'nvim-telescope/telescope.nvim',
      tag = '0.1.5',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'debugloop/telescope-undo.nvim',
        'jvgrootveld/telescope-zoxide',
      },
      config = function()
        local z_utils = require("telescope._extensions.zoxide.utils")

        require("telescope").setup({
          extensions = {
            undo = {
              mappings = {
                i = {
                  ["<s-cr>"] = require("telescope-undo.actions").yank_additions,
                  ["<c-cr>"] = require("telescope-undo.actions").yank_deletions,
                  ["<cr>"] = require("telescope-undo.actions").restore
                },
              },
            },
            ['ui-select'] = {
              require("telescope.themes").get_dropdown { }
            },
            zoxide = {
              prompt_title = "Zoxide",
              mappings = {
                default = {
                  after_action = function(selection)
                    print("Update to (" .. selection.z_score .. ") " .. selection.path)
                  end
                },
                ["<C-q>"] = { action = z_utils.create_basic_command("split") },
              },
            },
          }
        })

        require("telescope").load_extension("ui-select")
        require("telescope").load_extension("undo")
        require("telescope").load_extension("zoxide")
      end
    },
  }