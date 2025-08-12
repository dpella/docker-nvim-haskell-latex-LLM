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

require("codecompanion").setup {
  prompt_library = {
    ["Improve English"] = {
      strategy = "inline",
      description = "Improves sentences, paragraphs",
      opts = {
        adapter = {
          name = "openai",
          model = "gpt-4.1-mini",
        },
      },
      prompts = {
        {
          role = "system",
          content = "You are a native English speaker writting academic text",
        },
        {
          role = "user",
          content = "Make the following text flow better",
        },
      },
    },
  },
}
