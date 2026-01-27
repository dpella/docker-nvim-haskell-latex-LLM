local autocmd = vim.api.nvim_create_autocmd

-- Set filetype for .ansi files
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ansi",
  callback = function()
    vim.bo.filetype = "ansi"
  end,
})

autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
