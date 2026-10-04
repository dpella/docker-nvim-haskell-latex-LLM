local autocmd = vim.api.nvim_create_autocmd

-- Auto-reload files changed outside nvim (pairs with autoread = true)
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd "checktime"
    end
  end,
})

-- Set filetype for .ansi files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ansi",
  callback = function()
    vim.bo.filetype = "ansi"
  end,
})

-- Prose files: hard wrap at 80 while typing; review mode (<leader>tw, see
-- mappings.lua) switches to soft wrap and restores this when toggled off
autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.wrapmargin = 0
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})
