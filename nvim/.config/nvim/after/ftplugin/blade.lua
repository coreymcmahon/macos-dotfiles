-- Neovim has no default commentstring for Blade. Setting it here is all that's
-- needed: Neovim 0.12's built-in `gc` walks the treesitter injection tree and
-- picks the commentstring of the language under the cursor, so PHP regions get
-- `// %s` and HTML regions get `<!-- %s -->` automatically.
vim.bo.commentstring = "{{-- %s --}}"
