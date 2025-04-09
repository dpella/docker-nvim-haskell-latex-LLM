return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Tree sitter
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
        "latex",
        "bibtex",
        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        -- low level
        "c",
        "zig",
        -- noice plugin
        "bash",
        "regex",
      },
    },
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

  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Lazy Git" },
    },
  },

  -- Session manager <leader> z
  {
    "Shatur/neovim-session-manager",
    event = "VimEnter",
    config = function()
      require("session_manager").setup {
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled, -- CurrentDir,
      }
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Latex
  {
    "lervag/vimtex",
    ft = { "tex" },
    init = function()
      vim.g.tex_flavor = "latex"
      -- vim.g.vimtex_quickfix_mode = 0
      -- vim.g.vimtex_mappings_enabled = 0
      -- vim.g.vimtex_indent_enabled = 0
      --
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_context_pdf_viewer = "zathura"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-shell-escape",
        },
      }
      -- For xelatex: add the following line at the beginning of the file
      -- %!TEX TS-program = xelatex
    end,
  },

  -- Telescope search for bibtex entries <leader> bb
  {
    "nvim-telescope/telescope-bibtex.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "bibtex"
    end,
  },

  -- LTex Extras (like adding word to a dictionary)
  -- <leader> ca
  {
    "barreiroleo/ltex-extra.nvim",
  },

  -- Haskell tools
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^3", -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  -- Markdown (:Mtoc)
  {
    "hedyhli/markdown-toc.nvim",
    ft = "markdown", -- Lazy load on markdown filetype
    config = function()
      require("mtoc").setup {}
    end,
  },

  --	Renaming (<leader> re)
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
    lazy = false,
  },

  -- AI
  -- {
  --   "David-Kunz/gen.nvim",
  --   lazy = false,
  --  opts = {
  --    model = "mistral:instruct",
  --    port = "2022",
  --    show_model = true,
  --  },
  -- },

  -- Harpoon, to do marks in files
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Command line in the center, better messages and exposes what happens with LSPs
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- To show that macross are recording
      routes = { { view = "cmdline", filter = { event = "msg_showmode" } } },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "openai",
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
