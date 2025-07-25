require "nvchad.mappings" -- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "gl", function () vim.diagnostic.open_float() end)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.schedule(function()
			map({ "n", "v" }, "<leader>ca", function()
				require("tiny-code-action").code_action()
			end, { noremap = true, silent = true, buffer = args.buf })
		end)
	end,
})

map("n", "<leader>gl", function() Snacks.lazygit() end)

del("n", "<C-n>")
map({ "n", "v" }, "<C-n>", function() Snacks.explorer() end)

del("n", "<leader>e")
map("n", "<leader>e", "<C-w>h")

map("n", "<leader>pp", "<cmd>Precognition peek<cr>")
map("n", "<leader>pt", "<cmd>Precognition toggle<cr>")

map("n", "<leader>sf", '<cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<CR>')
map("n", "<leader>sw", '<cmd>:lua require("grug-far").open({ engine = "astgrep" })<CR>')

map("v", "<Tab>", ">gv")
map("v", "<S-Tab>", "<gv")

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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
