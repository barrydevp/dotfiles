local packer = require("packer")
local use = packer.use

-- using { } for using different branch , loading plugin with certain commands etc
return require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- color related stuff
        use "siduck76/nvim-base16.lua"
        use {
            "norcalli/nvim-colorizer.lua",
            event = "BufRead",
            config = function()
                require("colorizer").setup()
                vim.cmd("ColorizerReloadAllBuffers")
            end
        }
        -- use "ollykel/v-vim" -- v syntax highlighter

        -- file managing , picker etc
        -- use "kyazdani42/nvim-tree.lua"
        -- use "kyazdani42/nvim-web-devicons"
        use {
            "kyazdani42/nvim-tree.lua",
            requires = 'kyazdani42/nvim-web-devicons',
            config = function() 
                require("lua-nvim-tree").config()
            end
        }
        use "ryanoasis/vim-devicons"
        use {
            "nvim-telescope/telescope.nvim",
            config = function()
                require("lua-telescope").config()
            end,
            requires = {
                {"nvim-lua/popup.nvim"},
                {"nvim-lua/plenary.nvim"},
                {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
                {"nvim-telescope/telescope-media-files.nvim"}
            },
            cmd = "Telescope",
        }

        -- lsp stuff
        use "nvim-treesitter/nvim-treesitter"
        use "neovim/nvim-lspconfig"
        use {
            "onsails/lspkind-nvim",
            event = "BufRead",
            config = function()
                require("lspkind").init()
            end
        }
        use {
            "ray-x/lsp_signature.nvim",
        }
        use {
            'glepnir/lspsaga.nvim',
        }
        use "sbdchd/neoformat"
        -- use "nvim-lua/plenary.nvim"

        use "lewis6991/gitsigns.nvim"
        use "akinsho/nvim-bufferline.lua"
        use "glepnir/galaxyline.nvim"
        -- use "windwp/nvim-autopairs"
        -- use "alvan/vim-closetag"

        -- comment
        use "terrortylor/nvim-comment"
        use {
            "hrsh7th/nvim-compe",
            event = "InsertEnter",
            config = function()
                require("lua-nvim-compe").config()
            end,
            wants = {"LuaSnip"},
            requires = {
                {
                    "L3MON4D3/LuaSnip",
                    wants = "friendly-snippets",
                    event = "InsertCharPre",
                    config = function()
                        require("lua-nvim-compe").snippets()
                    end
                },
                "rafamadriz/friendly-snippets"
            }
        }
        -- snippet support
        -- load compe in insert mode only
        use {
            "windwp/nvim-autopairs",
            after = "nvim-compe",
            config = function()
                require("nvim-autopairs").setup()
                require("nvim-autopairs.completion.compe").setup(
                    {
                        map_cr = true,
                        map_complete = true -- insert () func completion
                    }
                )
            end
        }
        -- use "hrsh7th/vim-vsnip"
        -- use "rafamadriz/friendly-snippets"

        -- typo
        -- use {
        --   "blackCauldron7/surround.nvim",
        --   config = function()
        --     require("surround").setup({})
        --   end
        -- }
        use {
          "tpope/vim-surround"
        }
        -- misc
        use "tweekmonster/startuptime.vim"
        -- use "907th/vim-auto-save"
        -- use "karb94/neoscroll.nvim"
        -- use "kdav5758/TrueZen.nvim"
        use "folke/which-key.nvim"

        -- discord rich presence
        --use "andweeb/presence.nvim"

        use {"lukas-reineke/indent-blankline.nvim"}
    end,
    {
        display = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
        }
    }
)
