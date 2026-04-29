return {
	{
		-- Tmux navigator, to move in and out of nvim to terminal
		"christoomey/vim-tmux-navigator",
		lazy = false, -- always load this plugin
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- uncomment for format on save
		opts = require("configs.conform"),
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
				"norg",
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
		config = function(_, opts)
			-- Use the new module name (config instead of configs)
			require("nvim-treesitter.config").setup(opts)
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
			require("session_manager").setup({
				autoload_mode = require("session_manager.config").AutoloadMode.Disabled, -- CurrentDir,
			})
		end,
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
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
			require("telescope").setup({
				extensions = {
					bibtex = {
						-- Enable context awareness to find \bibliography{} in tex files
						context = true,
						-- Fallback to global/directory .bib files if context not found
						context_fallback = true,
					},
				},
			})
			require("telescope").load_extension("bibtex")
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
			require("mtoc").setup({})
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
	-- {
	--   "olimorris/codecompanion.nvim",
	--   opts = {
	--     log_level = "DEBUG",
	--   },
	--   dependencies = {
	--     "nvim-lua/plenary.nvim",
	--     "nvim-treesitter/nvim-treesitter",
	--   },
	--   lazy = false,
	--   config = function()
	--     require("codecompanion").setup {
	--       adapters = {
	--         openai = function()
	--           return require("codecompanion.adapters").extend("openai", {
	--             env = {
	--               model = "gpt-4.1-mini",
	--               api_key = os.getenv('OPENAI_API_KEY'),
	--             },
	--           })
	--         end,
	--  anthropic = function()
	--           return require("codecompanion.adapters").extend("anthropic", {
	--             env = {
	--               model = "claude-sonnet-4-20250514",
	--               api_key = os.getenv('ANTHROPIC_API_KEY'),
	--             },
	--           })
	--         end,
	--       },
	--       strategies = {
	--         chat = {
	--           adapter = "anthropic",
	--         },
	--         inline = {
	--           adapter = "anthropic",
	--         },
	--         agent = {
	--           adapter = "anthropic",
	--         },
	--       },
	--       prompt_library = {
	--         -- Make English flow
	--         ["Improve English"] = {
	--           strategy = "inline",
	--           description = "Improves sentences, paragraphs",
	--           opts = {
	--             adapter = {
	--               name = "openai",
	--               model = "gpt-4.1-mini",
	--             },
	--           },
	--           prompts = {
	--             {
	--               role = "system",
	--               content = "You are a native English speaker writting academic text",
	--             },
	--             {
	--               role = "user",
	--               content = "<user_prompt> Make the following text flow better <user_prompt>",
	--             },
	--           },
	--         },
	--         -- Expand text based on a sentence in the end of it
	--         ["Expand on the text"] = {
	--           strategy = "inline",
	--           description = "Expand the flow of a given text",
	--           opts = {
	--             adapter = {
	--               name = "openai",
	--               model = "gpt-4.1-mini",
	--             },
	--           },
	--           prompts = {
	--             {
	--               role = "system",
	--               content = "You are a native English speaker writting academic text",
	--             },
	--             {
	--               role = "user",
	--               content = function(context)
	--                 local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
	--                 return "I have the following text:\n\n{text}\n<user_prompt> Keep the given text as it is except the last sentence where you expand on the idea<user_prompt>"
	--               end,
	--             },
	--           },
	--         },
	--       },
	--     }
	--
	--     local keymap = vim.keymap
	--
	--     keymap.set("n", "<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle Code Companion Chat" })
	--     keymap.set("v", "<leader>aa", "<cmd>CodeCompanion<CR>", { desc = "Open Code Companion Inline" })
	--   end,
	-- },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},
	{
		"HakonHarnes/img-clip.nvim",
		opts = {
			filetypes = {
				codecompanion = {
					prompt_for_file_name = false,
					template = "[Image]($FILE_PATH)",
					use_absolute_path = true,
				},
			},
		},
	},
	{
		-- Tmux navigator, to move in and out of nvim to terminal
		"christoomey/vim-tmux-navigator",
		lazy = false, -- always load this plugin
	},
	{
		"0xferrous/ansi.nvim",
		lazy = false,
		config = function()
			require("ansi").setup({
				auto_enable = true, -- Auto-enable for configured filetypes
				filetypes = { "log", "ansi", "ans" }, -- Filetypes to auto-enable
			})
		end,
	},
	-- Neorg, structured note-taking
	{
		"nvim-neorg/neorg",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-neotest/nvim-nio" },
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "/vol/notes",
							},
							default_workspace = "notes",
						},
					},
					["core.completion"] = {
						config = { engine = "nvim-cmp" },
					},
				},
			})
		end,
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
}
