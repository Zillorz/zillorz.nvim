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
  },
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/denols.lua
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    local root_markers = { 'deno.lock', 'deno.json', 'deno.jsonc' }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })
    -- only include deno projects
    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
    local project_root = vim.fs.root(bufnr, root_markers)
    if
      (deno_lock_root and (not project_root or #deno_lock_root > #project_root))
      or (deno_root and (not project_root or #deno_root >= #project_root))
    then
      -- deno config is closer than or equal to package manager lock,
      -- or deno lock is closer than package manager lock. Attach at the project root,
      -- or deno lock or deno config path. At least one of these is always set at this point.
      on_dir(project_root or deno_lock_root or deno_root)
    else
      -- only change from github, check if there isn't a node project either, and attach if this is a single file
      local vtsls_root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }

      -- Give the root markers equal priority by wrapping them in a table
      vtsls_root_markers = { vtsls_root_markers, { ".git" } }
      local node_project_root = vim.fs.root(bufnr, vtsls_root_markers)

      if not node_project_root then
        on_dir(vim.fn.getcwd())
      end
    end
  end,
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/vtsls.lua
vim.lsp.config("vtsls", {
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
    -- Give the root markers equal priority by wrapping them in a table
    root_markers = vim.fn.has "nvim-0.11.3" == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })
    -- exclude deno
    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, root_markers)

    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
      -- deno lock is closer than package manager lock, abort
      return
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      -- deno config is closer than or equal to package manager lock, abort
      return
    end

    -- project is standard TS, not deno
    -- NO single file support, if there's no root, don't run vtsls! (this is the only change from the original nvim-lspconfig github)
    if project_root then
      on_dir(project_root)
    end
  end,
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
