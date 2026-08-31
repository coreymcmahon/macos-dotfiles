-- Vue Language Server (hybrid mode; vtsls handles the script blocks).
--
-- vue-language-server needs to load the TypeScript library itself. When it is
-- installed globally rather than as a project dependency it cannot resolve
-- `typescript` on its own and dies with:
--   TypeError: Cannot read properties of undefined (reading 'protocol')
-- Pointing `typescript.tsdk` at the global lib directory fixes that. A
-- project-local typescript, when present, still takes precedence.
local function global_tsdk()
  local out = vim.fn.system({ "npm", "root", "-g" })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local tsdk = vim.trim(out) .. "/typescript/lib"
  return vim.uv.fs_stat(tsdk) and tsdk or nil
end

---@type vim.lsp.Config
return {
  init_options = {
    typescript = {
      tsdk = global_tsdk(),
    },
  },
}
