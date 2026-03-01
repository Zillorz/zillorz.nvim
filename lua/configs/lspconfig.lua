-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- rustaceanvim replaces rust_analyzer
local servers = {
  "html",
  "cssls",
  "basedpyright",
  "clangd",
  "dockerls",
  "emmet_language_server",
  "jsonls",
  "marksman",
  "matlab_ls",
  "svelte",
  "taplo",
  "yamlls",
  "gopls",
  "denols",
  "vtsls",
  "jdtls",
}

-- See more inlay_hint configs here
-- https://github.com/MysticalDevil/inlay-hints.nvim
vim.lsp.config("denols", {
  settings = {
    deno = {
      inlayHints = {
        parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enable = true },
        enumMemberValues = { enabled = true },
      },
    },
  }
})

-- the rest of the code below is just for java!
local mason = vim.fn.stdpath "data" .. "/mason/packages"
local bundles = {
  vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
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
vim.lsp.config("jdtls", {
  init_options = {
    bundles = bundles,
  },
  flag = {
    allow_incremental_sync = true,
  },
  cmd = {
    "jdtls",
    "-data",
    vim.fn.stdpath "cache" .. "/jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
  },
  settings = { java = {} },
  root_markers = { ".classpath", ".project", ".git", "gradlew", "mvnw" },
})

vim.lsp.enable(servers)
