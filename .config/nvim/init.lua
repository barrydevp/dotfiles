local g = vim.g

g.mapleader = ","
g.auto_save = false

-- colorscheme related stuff

g.custom_theme = "onedark"

-- load all plugins
require "plugins"

-- load settings, mappings
require "settings"
require "mappings"

-- load lua config pluing
require "lua-nvim-web-devicons"
require "lua-nvim-bufferline"
require "lua-galaxyline"

-- require("colorizer").setup()
-- require("neoscroll").setup() -- smooth scroll

-- lsp stuff
require "lua-lspconfig"
-- require "lua-nvim-compe"

require "customs.highlights"

require "lua-nvim-treesitter"

-- require "lua-telescope"
require "lua-nvim-tree"
require "lua-which-key"
require "lua-nvim-comment"

-- git signs , lsp symbols etc
require "lua-gitsigns"

-- require("nvim-autopairs").setup()
-- require("lspkind").init()

-- setup for TrueZen.nvim
-- require "lua-truezen"
