return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },


  -- Installing Haskell tools   
  {
    "mrcjkb/haskell-tools.nvim",
    version = '^3', -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  -- It describes what to install when running :MasonInstallAll 
  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server",
  			"stylua",
  		},
  	},
  },

  -- Maximizes a split for a moment 
  {
  	"szw/vim-maximizer",
  	keys = {
        { "<leader>mm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split"},
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

        local todo_comments = require("todo-comments")

        todo_comments.setup({
                signs = false,
            })

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
