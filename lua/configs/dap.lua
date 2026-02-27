local dap = require "dap"
dap.adapters.codelldb = {
  type = "executable",
  command = "codelldb",

  -- On windows you commandy have to uncomment this:
  -- detached = false,
}

-- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook/4bddc7f431eb056379960727ce0e4bf899ce3fda#using-telescope-for-selecting-an-executable-to-debug
local pick_program = function ()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  return coroutine.create(function(coro)
    local opts = {}
    pickers
      .new(opts, {
        prompt_title = "Path to executable",
        finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" }, {}),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(buffer_number)
          actions.select_default:replace(function()
            actions.close(buffer_number)
            coroutine.resume(coro, action_state.get_selected_entry()[1])
          end)
          return true
        end,
      })
      :find()
  end)
end

dap.configurations.c = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = pick_program,
    args = "",
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Launch file with arguments",
    type = "codelldb",
    request = "launch",
    program = pick_program,
    args = function()
      local args_string = vim.fn.input "Arguments: "
      return vim.split(args_string, " +")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

-- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
local last_config = nil

---@param session Session
dap.listeners.after.event_initialized["store_config"] = function(session)
  last_config = session.config
end

dap.run_last = function()
  if last_config then
    dap.run(last_config)
  else
    dap.continue()
  end
end
