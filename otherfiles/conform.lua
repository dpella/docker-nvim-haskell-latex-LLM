local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    haskell = { "fourmolu" },
    -- markdown = { "prettier" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
    async = false,
  },
}

require("conform").setup(options)
