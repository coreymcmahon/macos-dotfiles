-- space leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- quickly hide search result with ESC
vim.keymap.set('n', '<ESC>', ':nohlsearch<CR>:echo<CR>')

-- Trigger Neo-Tree filetree:
vim.keymap.set('n', '<C-n>', '<cmd>Neotree filesystem reveal left<CR>')

-- Telescope
vim.keymap.set('n', '<leader>ff', function() require("telescope.builtin").find_files() end, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', function() require("telescope.builtin").live_grep() end, { desc = "Grep in files" })
vim.keymap.set('n', '<leader>fb', function() require("telescope.builtin").buffers() end, { desc = "Show buffers" })
vim.keymap.set('n', '<leader>fq', function() require("telescope.builtin").diagnostics() end, { desc = "Show fixlist" })
vim.keymap.set('n', '<leader>fu', '<cmd>Telescope undo<cr>', { desc = "Undo tree" })
vim.keymap.set('n', '<leader>fz', '<cmd>Telescope zoxide list<cr>', { desc = "Zoxide" })

-- cp to copy to system clipboard
vim.keymap.set({ 'n', "v" }, 'cp', '"+y')

----------------------
-- LazyVim keymaps ---

-- better up/down
-- navigates "visual" lines when no count is given, retains original behavior when a count is used.
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })