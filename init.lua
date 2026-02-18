vim.loader.enable()

-- This actually speeds up launch by 50ms on windows!
if vim.fn.has('win32') == 1 then
  vim.g.clipboard = "win32yank"
end

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Neovide config is now seperate, see (extra/neovide_config.toml)
if vim.g.neovide then
  vim.g.neovide_input_macos_option_key_is_meta = 'both'
end

vim.opt.relativenumber = true

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "syntax")
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- This is here for now ig?
-- Try to lazy load these??
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
 dofile(vim.g.base46_cache .. v)
end

require "options"
require "autocmds"
require "chadrc"

vim.schedule(function()
  require "mappings"
  require "commands"
end)
