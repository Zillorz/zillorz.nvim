-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local options = {

  base46 = {
    theme = "radium",
    integrations = { "dap", "grug_far" },
  },

  ui = {
    telescope = { style = "bordered" },
  },

  term = {
    startinsert = true,
    base46_colors = true,
    winopts = { number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.175,
      col = 0.125,
      width = 0.7,
      height = 0.6,
      border = "double"
    }
  },

  lsp = { signature = true },
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
