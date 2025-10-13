vim.api.nvim_create_user_command(
  'JavaTestAll',
  function()
    require("jdtls").test_class()
  end,
  {}
)

vim.api.nvim_create_user_command(
  'JavaTest',
  function()
    require("jdtls").test_nearest_method()
  end,
  {}
)
