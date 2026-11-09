-- `npm root -g`, resolved once per session. Neovim re-runs each after/lsp file
-- whenever it resolves that server's config, so caching has to live in a module.
local root
local resolved = false

return function()
  if not resolved then
    local out = vim.fn.system({ "npm", "root", "-g" })
    root = vim.v.shell_error == 0 and vim.trim(out) or nil
    resolved = true
  end
  return root
end
