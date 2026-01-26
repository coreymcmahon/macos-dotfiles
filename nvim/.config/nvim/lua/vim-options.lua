-- Mainly copied from LazyVim, with some modifications
-- https://raw.githubusercontent.com/LazyVim/LazyVim/refs/heads/main/lua/lazyvim/config/options.lua

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- LazyVim auto format
vim.g.autoformat = true

-- Snacks animations
-- vim.g.snacks_animate = true -- TODO reenable once installed

-- LazyVim picker to use
vim.g.lazyvim_picker = "auto" -- Q: why auto? how does it know which one to use?

-- LazyVim completion engine to use
vim.g.lazyvim_cmp = "auto"  -- Q: why auto? how does it know which one to use?

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

-- LazyVim root dir detection
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Q: set to ghostty?
-- Optionally setup the terminal to use
-- This sets `vim.o.shell` and does some additional configuration for:
-- * pwsh
-- * powershell
-- LazyVim.terminal.setup("pwsh")

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
vim.g.root_lsp_ignore = { "copilot" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false -- Q: true or false hides?

-- Show the current document symbols location from Trouble in lualine
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true -- Automatically saves files when switching buffers
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard; disables in SSH, enables otherwise
opt.completeopt = "menu,menuone,noselect" -- Controls completion menu behavior
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99 -- Default fold level when opening files; 99 == all open
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()" -- Expression used for gq formatting command
opt.formatoptions = "jcroqlnt" -- tcqj ; Controls auto-formatting behavior -- Q: what does this mean?
opt.grepformat = "%f:%l:%c:%m" --  Configure external grep program and output format
opt.grepprg = "rg --vimgrep" -- Use ripgrep as grep program
opt.ignorecase = true -- Ignore case when searching
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view" -- Keep cursor in the same position when jumping
opt.laststatus = 3 -- Controls statusline visibility ; 3 == global statusline 
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs, spaces)
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Show current line number
opt.pumblend = 10 -- Controls popup menu transparency
opt.pumheight = 10 -- Controls popup menu height (and therefore max entries)
opt.relativenumber = true -- Show relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context; Keeps lines/columns visible around cursor
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } -- Q: what does this do?
opt.shiftround = true -- Rounds indentation to shiftwidth
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- Q: what does this do?
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]] -- TODO reenable once installed
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Time to wait for mapped sequences ; lower than default (1000) to quickly trigger which-key
opt.undofile = true -- Persistent undo history
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0