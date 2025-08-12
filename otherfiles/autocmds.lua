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
    -- Make English flow
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
          content = "<user_prompt> Make the following text flow better <user_prompt>",
        },
      },
    },
    -- Expand text based on a sentence in the end of it
    ["Expand on the text"] = {
      strategy = "inline",
      description = "Expand the flow of a given text",
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
          content = function(context)
            local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
            return "I have the following text:\n\n{text}\n<user_prompt> Keep the given text as it is except the last sentence where you expand on the idea<user_prompt>"
          end,
        },
      },
    },
  },
}

