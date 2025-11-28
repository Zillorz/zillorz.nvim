require "nvchad.autocmds"

-- tab fix :/
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  callback = function()
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end
})

vim.api.nvim_create_autocmd('RecordingEnter', {
  pattern = '*',
  callback = function()
    Snacks.notifier.notify(
      "Recording @" .. vim.fn.reg_recording(),
      nil,
      {
        id = 'MACRO',
        title = 'Macro',
        timeout = false
      }
    );
  end
})

vim.api.nvim_create_autocmd('RecordingLeave', {
  pattern = '*',
  callback = function()
    Snacks.notifier.hide('MACRO')
  end
})
