require "nvchad.mappings" -- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })

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

map("n", "<leader>pp", "<cmd>Precognition peek<cr>", { desc = "next key precog" })
map("n", "<leader>pt", "<cmd>Precognition toggle<cr>", { desc = "toggle precog" })

map("n", "<leader>sf", '<cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<CR>', { desc = "search & replace in current file" })
map("n", "<leader>sw", '<cmd>lua require("grug-far").open({ engine = "astgrep" })<CR>', { desc = "search & replace" })

map("v", "<Tab>", ">gv")
map("v", "<S-Tab>", "<gv")

map("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to type definition" })

map("n", "<leader>B", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })

map("n", "<leader>tl", function()
  local enabled = not vim.lsp.inlay_hint.is_enabled({})
  vim.lsp.inlay_hint.enable(enabled)
  vim.notify("Inlay hints: " .. (enabled and " on" or "off"))
end, { desc = "Toggle inlay hints" })


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
