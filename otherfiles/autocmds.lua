local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
