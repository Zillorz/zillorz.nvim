require "nvchad.options"

-- add yours here!
vim.o.winborder = "rounded"
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
vim.fn.sign_define('DapBreakpoint', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})

vim.fn.sign_define('DapStopped', {text='→', texthl='', linehl='DapStopped', numhl=''})
