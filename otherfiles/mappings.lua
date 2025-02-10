require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Session manager
map("n", "<leader>z", "<cmd> SessionManager <CR>", { desc = "Session manager" })

map("n", "<leader>cv", "<cmd> VimtexView <CR>", { desc = "Tex: View" })
map("n", "<leader>cl", "<cmd> VimtexCompile <CR>", { desc = "Tex: Compile" })

-- AI
map({ "n", "v" }, "<leader>ww", ":Gen<CR>", { desc = "LLM Prompt" })

local conform = require "conform"

map({ "n", "v" }, "<leader>mp", function()
  conform.format {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  }
end)

-- Quickfix list
map({ "n" }, "ff", "<cmd> cprev <CR>", { desc = "Prev quickfix" })
map({ "n" }, "vv", "<cmd> cnext <CR>", { desc = "Next quickfix" })

-- Moving tabs
map("n", "<A-1>", "<cmd> tabnext 1 <CR>", { desc = "Tab 1" })
map("n", "<A-2>", "<cmd> tabnext 2 <CR>", { desc = "Tab 2" })
map("n", "<A-3>", "<cmd> tabnext 3 <CR>", { desc = "Tab 3" })
map("n", "<A-4>", "<cmd> tabnext 4 <CR>", { desc = "Tab 4" })
map("n", "<A-5>", "<cmd> tabnext 5 <CR>", { desc = "Tab 5" })
map("n", "<A-6>", "<cmd> tabnext 6 <CR>", { desc = "Tab 6" })

-- Toggle auto-formatting
vim.api.nvim_create_user_command("ToggleAutoformat", function()
  vim.g.autoformat = not vim.g.autoformat
  print("Autoformat is now " .. (vim.g.autoformat and "enabled" or "disabled"))
end, {})

vim.api.nvim_set_keymap("n", "<leader>tt", ":ToggleAutoformat<CR>", { noremap = true, silent = true })
