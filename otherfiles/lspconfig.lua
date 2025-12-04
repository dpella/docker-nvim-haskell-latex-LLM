-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = { "lua_ls", "marksman", "texlab", "html", "cssls" }

local keymap = vim.keymap -- for conciseness

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    --     -- set keybinds
    --     opts.desc = "Show LSP references"
    --     keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
    --
    opts.desc = "Go to definition"
    keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to definition (same buffer)
    --
    opts.desc = "List LSP workspace symbols"
    keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_workspace_symbols<CR>", opts) -- show lsp definitions

    opts.desc = "List LSP diagnostic"
    keymap.set("n", "<leader>ld", "<cmd>Telescope diagnostics<CR>", opts) -- show lsp definitions

    opts.desc = "List LSP tags"
    keymap.set("n", "<leader>lt", "<cmd>Telescope tags<CR>", opts) -- show lsp definitions

    opts.desc = "List LSP buffers"
    keymap.set("n", "<leader>lb", "<cmd>Telescope buffers<CR>", opts) -- show lsp definitions

    --     opts.desc = "Show LSP implementations"
    --     keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
    --
    --     opts.desc = "Show LSP type definitions"
    --     keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
    --
    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>sr", function()
      return ":IncRename " .. vim.fn.expand "<cword>"
    end, { expr = true, desc = opts.desc }) -- smart rename

    --
    --     opts.desc = "Show buffer diagnostics"
    --     keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
    --
    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts) -- show diagnostics for line

    --     opts.desc = "Go to previous diagnostic"
    --     keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
    --
    --     opts.desc = "Go to next diagnostic"
    --     keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
    --
    --     opts.desc = "Show documentation for what is under cursor"
    --     keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
    --
    --     opts.desc = "Restart LSP"
    --     keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    --
    -- Haskell
    local ht = require "haskell-tools"
    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local opts1 = opts
    -- haskell-language-server relies heavily on codeLenses,
    -- so auto-refresh (see advanced configuration) is enabled by default
    opts1.desc = "Run code in -- >>>"
    vim.keymap.set("n", "<leader>rr", vim.lsp.codelens.run, opts1)
    -- -- Hoogle search for the type signature of the definition under the cursor
    opts1.desc = "Hoogle search"
    vim.keymap.set("n", "<leader>ts", ht.hoogle.hoogle_signature, opts1)
    -- Evaluate all code snippets
    opts1.desc = "Run all the code snippets in -- >>>"
    vim.keymap.set("n", "<space>ra", ht.lsp.buf_eval_all, opts1)
    -- Toggle a GHCi repl for the current package
    opts1.desc = "GHCi for the package"
    vim.keymap.set("n", "<leader>rp", ht.repl.toggle, opts1)
    -- Toggle a GHCi repl for the current buffer
    opts1.desc = "GHCi for the current file"
    vim.keymap.set("n", "<leader>rf", function()
      ht.repl.toggle(vim.api.nvim_buf_get_name(0))
    end, opts1)
    opts1.desc = "GHCi quit"
    vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts1)
  end,
})

local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end

-- For ltex extension to add to dictionaries
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

vim.lsp.config("ltex", {
  on_attach = function(client, bufnr)
    require("ltex_extra").setup()
    on_attach(client, bufnr)
  end,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    ltex = {
      checkFrequency = "save",
      language = "en-US",
    },
  },
})

-- Enable ltex for markdown, text, and tex files
vim.lsp.enable("ltex", { "markdown", "text", "tex" })

-- configuring single server, example: typescript
-- vim.lsp.config("ts_ls", {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- })
