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
