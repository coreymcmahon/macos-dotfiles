-- TypeScript/JavaScript, plus Vue via hybrid mode.
--
-- Vue Language Server 3.0+ removed take-over mode: vue_ls now handles only the
-- template/style blocks, and the TypeScript server handles the script blocks
-- through @vue/typescript-plugin, which ships inside @vue/language-server.
--
-- The plugin location is resolved from the npm global root rather than
-- hardcoded, because Mise moves it per Node version.
local function vue_language_server_path()
  local out = vim.fn.system({ "npm", "root", "-g" })
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local path = vim.trim(out) .. "/@vue/language-server"
  return vim.uv.fs_stat(path) and path or nil
end

local filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}

local global_plugins = {}
local vue_path = vue_language_server_path()

if vue_path then
  table.insert(filetypes, "vue")
  table.insert(global_plugins, {
    name = "@vue/typescript-plugin",
    location = vue_path,
    languages = { "vue" },
    configNamespace = "typescript",
  })
end

---@type vim.lsp.Config
return {
  filetypes = filetypes,
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = global_plugins,
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
      },
    },
  },
}
