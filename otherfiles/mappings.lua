require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
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
-- map({ "n", "v" }, "<leader>ww", ":Gen<CR>", { desc = "LLM Prompt" })

-- Harpoon
local harpoon = require "harpoon"
harpoon:setup()

map({ "n" }, "<leader>ha", function()
  harpoon:list():add()
end, { desc = "Harpoon: add into the list" })

map({ "n" }, "<leader>ht", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: toogle list" })

map({ "n" }, "<leader>hp", function()
  harpoon:list():prev()
end, { desc = "Harpoon: prev" })

map({ "n" }, "<leader>hn", function()
  harpoon:list():next()
end, { desc = "Harpoon: next" })

map("n", "<leader>h1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon: 1" })

map("n", "<leader>h2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon: 2" })

map("n", "<leader>h3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon: 3" })

map("n", "<leader>h4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon: 4" })

-- When selecting lines, moving them up or down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Half page scrolling without moving the cursor
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Joining lines without moving cursor
map("n", "J", "mzJ`z")

-- Replace every word under the cursor
map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>//g<left><left>")

-- Haskell
map("n", "<leader>fcg", "<cmd> Telescope ht package_grep <CR>", { desc = "Live grep within (sub) cabal packages" })

map("n", "<leader>fcf", "<cmd> Telescope ht package_files <CR>", { desc = "Search files within (sub) cabal packages" })

map(
  "n",
  "<leader>fho",
  "<cmd> Telescope ht hoogle_signature <CR>",
  { desc = "Run a Hoogle search for the type signature under the cursor" }
)
 
-- Paper-review / prose mode (<leader>tw).
--
-- Soft-wraps the text at a fixed width *without* inserting hard line breaks,
-- so yanking a paragraph gives one unbroken line: pasting it into a browser
-- (dictionary, grammar checker, ...) needs no rejoining.
-- The width is enforced by shrinking nvim itself ('columns'), and numbers /
-- signs are hidden so the text column is exactly REVIEW_WIDTH characters.
local REVIEW_WIDTH = 80

local review = { on = false, saved = nil }

local function review_apply()
  local o = vim.o
  o.textwidth = 0
  o.wrapmargin = 0
  o.wrap = true
  o.linebreak = true -- break by word rather than mid-character
  o.breakindent = true
  o.number = false
  o.relativenumber = false
  o.signcolumn = "no"
  o.colorcolumn = ""
  o.columns = REVIEW_WIDTH
end

local function review_toggle()
  local o = vim.o

  if not review.on then
    review.saved = {
      textwidth = o.textwidth,
      wrapmargin = o.wrapmargin,
      wrap = o.wrap,
      linebreak = o.linebreak,
      breakindent = o.breakindent,
      number = o.number,
      relativenumber = o.relativenumber,
      signcolumn = o.signcolumn,
      colorcolumn = o.colorcolumn,
      columns = o.columns,
    }
    review.on = true
    review_apply()

    -- Move by screen line, which is what you want on wrapped prose
    map({ "n", "x" }, "j", "gj", { desc = "Review: down by screen line" })
    map({ "n", "x" }, "k", "gk", { desc = "Review: up by screen line" })
    map({ "n", "x" }, "0", "g0", { desc = "Review: start of screen line" })
    map({ "n", "x" }, "$", "g$", { desc = "Review: end of screen line" })
  else
    review.on = false
    for opt, val in pairs(review.saved or {}) do
      o[opt] = val
    end
    review.saved = nil

    for _, lhs in ipairs { "j", "k", "0", "$" } do
      pcall(vim.keymap.del, { "n", "x" }, lhs)
    end
  end

  vim.notify("Review mode " .. (review.on and "on" or "off"))
end

-- A terminal/tmux resize makes nvim reclaim the full width, so re-apply it
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Keep review mode at REVIEW_WIDTH columns after a resize",
  callback = function()
    if review.on and vim.o.columns ~= REVIEW_WIDTH then
      review_apply()
    end
  end,
})

map("n", "<leader>tw", review_toggle, { desc = "Toggle review mode (soft wrap at 80)" })
vim.api.nvim_create_user_command("ReviewMode", review_toggle, { desc = "Toggle review mode" })

-- Noice disregard messages
map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice message" })

-- Override nvchad's navigation settings for tmux-vim-navigor to work in nvim
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up" }) 
