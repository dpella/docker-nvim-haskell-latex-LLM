require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Session manager
map("n", "<leader>z", "<cmd> SessionManager <CR>", { desc = "Session manager" })

-- Moving tabs
map("n", "<A-1>", "<cmd> tabnext 1 <CR>", { desc = "Tab 1" })
map("n", "<A-2>", "<cmd> tabnext 2 <CR>", { desc = "Tab 2" })
map("n", "<A-3>", "<cmd> tabnext 3 <CR>", { desc = "Tab 3" })
map("n", "<A-4>", "<cmd> tabnext 4 <CR>", { desc = "Tab 4" })
map("n", "<A-5>", "<cmd> tabnext 5 <CR>", { desc = "Tab 5" })
map("n", "<A-6>", "<cmd> tabnext 6 <CR>", { desc = "Tab 6" })

-- Latex
map("n", "<leader>cv", "<cmd> VimtexView <CR>", { desc = "Tex: View" })
map("n", "<leader>cl", "<cmd> VimtexCompile <CR>", { desc = "Tex: Compile" })

-- References search using Telescope.
-- Initilize nvim in the directory of the paper, otherwise it does not work
map("n", "<leader>bb", "<cmd> Telescope bibtex <CR>", { desc = "Tex: Search BibTex" })

-- Renaming using LSP
map("n", "<leader>re", ":IncRename ", { desc = "LSP: Smart renaming" })

-- LLM
map({ "n", "v" }, "<leader>ww", ":Gen<CR>", { desc = "LLM Prompt" })
