local utils = require("utils")

local present, packer = pcall(require, "packer")

if not present then
	utils.boot_packer()
	return
end

vim.cmd("packadd packer.nvim")

packer.init({
	auto_clean = true,
	compile_on_sync = true,
	git = { clone_timeout = 6000 },
	display = {
		working_sym = "ﲊ",
		error_sym = "✗ ",
		done_sym = " ",
		removed_sym = " ",
		moved_sym = "",
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
})

-- using { } for using different branch , loading plugin with certain commands etc
return require("packer").startup(function(use)
	use({
		"wbthomason/packer.nvim",
	})

	use({
		"nvim-lua/plenary.nvim",
		module = "plenary",
	})

	use({
		"barrydevp/base46",
		after = "plenary.nvim",
		config = function()
			require("plugins.configs.base46")
		end,
	})

	-- color, icons related stuff
	use({
		"norcalli/nvim-colorizer.lua",
		event = "BufRead",
		config = function()
			require("plugins.configs.colorizer")
		end,
	})

	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.configs.webdevicons")
		end,
	})

	-- file managing , picker etc
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.configs.nvimtree")
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			},
			{
				"nvim-telescope/telescope-media-files.nvim",
				setup = function()
					require("mappings").telescope_media()
				end,
			},
		},
		config = function()
			require("plugins.configs.telescope")
		end,
	})

	-- status line
	use({
		"feline-nvim/feline.nvim",
		after = "nvim-web-devicons",
		config = function()
			require("plugins.configs.statusline")
		end,
	})

	use("famiu/bufdelete.nvim")

	-- tabbar
	use({
		"akinsho/bufferline.nvim",
		after = "nvim-web-devicons",
		config = function()
			require("plugins.configs.bufferline")
		end,
		setup = function()
			require("mappings").bufferline()
		end,
	})

	-- git stuff
	use({
		"lewis6991/gitsigns.nvim",
		opt = true,
		config = function()
			require("plugins.configs.gitsigns")
		end,
		setup = function()
			require("utils").packer_lazy_load("gitsigns.nvim")
		end,
	})

	use({ "tpope/vim-fugitive", cmd = "Git" })
	use({ "junegunn/gv.vim" })

	-- editorconfig
	use({ "editorconfig/editorconfig-vim" })

	-- comment
	use({
		"numToStr/Comment.nvim",
		-- module = "Comment",
		-- keys = { "gcc" },
		-- keys = { "gc", "gcc", "gbc" },
		config = function()
			require("plugins.configs.comment")
		end,
	})

	-- indent decorator
	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("plugins.configs.blankline")
		end,
	})

	-- syntax analyzer and parser
	use({
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		run = ":TSUpdate",
		opt = true,
		config = function()
			require("plugins.configs.treesitter")
		end,
		requires = {
			-- 	-- "windwp/nvim-ts-autotag",
			"JoosepAlviste/nvim-ts-context-commentstring",
			-- 	-- { "jose-elias-alvarez/typescript.nvim" },
			-- 	-- { "Hoffs/omnisharp-extended-lsp.nvim" },
			-- 	-- {
			-- 	--     "nvim-treesitter/playground",
			-- 	--     cmd = "TSHighlightCapturesUnderCursor",
			-- 	-- },
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			-- 	-- { "p00f/nvim-ts-rainbow" },
			-- 	-- {
			-- 	--     "akinsho/flutter-tools.nvim",
			-- 	--     ft = "dart",
			-- 	--     config = "require('lsp.flutter')",
			-- 	-- },
		},
	})

	-- use({
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	after = "nvim-treesitter",
	-- })
	-- use({
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- 	after = "nvim-treesitter",
	-- })

	-- lsp stuff
	use({
		"jose-elias-alvarez/null-ls.nvim",
	})

	use({
		"neovim/nvim-lspconfig",
		opt = true,
		wants = {
			"nvim-cmp",
			"null-ls.nvim",
		},
		setup = function()
			require("utils").packer_lazy_load("nvim-lspconfig")
			-- reload the current file so lsp actually starts for it
			vim.defer_fn(function()
				vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
			end, 0)
		end,
		config = function()
			require("plugins.lsp")
		end,
	})

	use({
		"ray-x/lsp_signature.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("plugins.configs.lspsignature")
		end,
	})

	use({
		"andymass/vim-matchup",
		opt = true,
		setup = function()
			require("utils").packer_lazy_load("vim-matchup")
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("plugins.configs.trouble")
		end,
	})

	-- use {
	--     "glepnir/lspsaga.nvim",
	-- }

	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("plugins.configs.lspdap")
		end,
	})

	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("plugins.configs.lspdapui")
			require("plugins.configs.lspdapui")
		end,
	})

	-- load luasnips + cmp related in insert mode only
	use({
		"rafamadriz/friendly-snippets",
		event = "InsertEnter",
	})

	use({
		"hrsh7th/nvim-cmp",
		after = "friendly-snippets",
		config = function()
			require("plugins.configs.cmp")
		end,
	})

	use({
		"L3MON4D3/LuaSnip",
		wants = "friendly-snippets",
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.luasnip")
		end,
	})

	use({
		"saadparwaiz1/cmp_luasnip",
		after = "LuaSnip",
	})

	use({
		"hrsh7th/cmp-nvim-lua",
		after = "cmp_luasnip",
	})

	use({
		"hrsh7th/cmp-nvim-lsp",
		after = "cmp-nvim-lua",
	})

	use({
		"hrsh7th/cmp-buffer",
		after = "cmp-nvim-lsp",
	})

	use({
		"hrsh7th/cmp-path",
		after = "cmp-buffer",
	})

	-- misc
	use({
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
		config = function()
			require("plugins.configs.autopairs")
		end,
	})

	use({
		"tpope/vim-surround",
	})

	use({
		"tpope/vim-repeat",
	})

	-- markdonw preview live reload
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		config = function()
			require("plugins.configs.others").markdown()
		end,
	})

	-- discord rich presence
	-- use "andweeb/presence.nvim"
	use({
		"christoomey/vim-tmux-navigator",
	})

	-- key mapping
	use({
		"folke/which-key.nvim",
		config = function()
			require("plugins.configs.whichkey")
		end,
	})
end, {
	display = {
		border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
	},
})
