-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

vim.diagnostic.config({
  update_in_insert = true 
})

-- rustaceanvim replaces rust_analyzer
local servers = { "html", "cssls", "basedpyright", "clangd", "dockerls", "emmet_language_server", "jsonls", "marksman", "svelte", "tailwindcss", "taplo", "yamlls", "gradle_ls", "gopls", "denols", "vtsls", "jdtls"
}

vim.lsp.config("denols", {
  root_markers = { "deno.json", "deno.jsonc" },
  workspace_required = true
})

vim.lsp.config("vtsls", {
  root_markers = { 'package.json', 'tsconfig.json' },
  workspace_required = true
})

local mason = vim.fn.stdpath("data") .. "/mason/packages"
local bundles = {
  vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
}

local jars = vim.split(vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true), "\n")
local excluded = {
  "com.microsoft.java.test.runner-jar-with-dependencies.jar",
  "jacocoagent.jar",
}
for _, jar in ipairs(jars) do
  local fname = vim.fn.fnamemodify(jar, ":t")
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, jar)
  end
end

-- require('java').setup()
vim.lsp.config('jdtls', {
  init_options = {
     bundles = bundles,
  },
  settings = { java = { } },
  root_dir = vim.fs.root(0, {'.classpath', '.project', '.git', 'gradlew', 'mvnw'})
})

vim.lsp.enable(servers);
