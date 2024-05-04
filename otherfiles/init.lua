return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults
        "vim",
        "lua",
        "vimdoc",
        "haskell",
        "markdown",

        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",

        -- low level
        "c",
        "zig",
      },
    },
  },

  -- It describes what to install when running :MasonInstallAll
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local mason = require "mason"
      local mason_lspconfig = require "mason-lspconfig"

      mason.setup()

      mason_lspconfig.setup {
        ensure_installed = {
          "lua_ls", -- Lua
          "hls", -- Haskell
          "marksman", -- Markdown
        },
        automatic_instalation = true,
      }
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- Maximizes a split for a moment
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>mm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
  },

  -- Nicer text input in the file tree
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  -- To highlight TODO: comments and others alike, e.g, BUG: , HACK: , etc.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("base46").load_all_highlights()

      local todo_comments = require "todo-comments"

      todo_comments.setup {
        signs = false,
      }

      local map = vim.keymap.set

      map("n", "]t", function()
        todo_comments.jump_next()
      end, { desc = "Next todo comment" })

      map("n", "[t", function()
        todo_comments.jump_prev()
      end, { desc = "Previous todo comment" })
    end,
    event = "BufReadPost",
  },

  -- To surround text and then add quotes like "", e.g., config ysiw" -> "config"
  {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    config = true,
  },
}