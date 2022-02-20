-- Install Packer.nvim
-- local execute = vim.api.nvim_command
-- local fn = vim.fn
-- local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- 
-- if fn.empty(fn.glob(install_path)) > 0 then
--     execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
-- end
-- 
-- local packer = require("packer")
-- local use = packer.use
-- 
-- vim.cmd [[packadd packer.nvim]]
   
vim.cmd "packadd packer.nvim"

local present, packer = pcall(require, "packer")

if not present then
   local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

   print "Cloning packer.."
   -- remove the dir before cloning
   vim.fn.delete(packer_path, "rf")
   vim.fn.system {
      "git",
      "clone",
      "https://github.com/wbthomason/packer.nvim",
      "--depth",
      "20",
      packer_path,
   }

   vim.cmd "packadd packer.nvim"
   present, packer = pcall(require, "packer")

   if present then
      print "Packer cloned successfully."
   else
      error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
   end
end

packer.init {
   display = {
      open_fn = function()
         return require("packer.util").float { border = "single" }
      end,
      prompt_border = "single",
   },
   git = {
      clone_timeout = 6000, -- seconds
   },
   auto_clean = true,
   compile_on_sync = true,
}

local plugins = {
   -- enable and disable plugins (false for disable)
   status = {
      blankline = true, -- show code scope with symbols
      bufferline = true, -- list open buffers up the top, easy switching too
      colorizer = false, -- color RGB, HEX, CSS, NAME color codes
      comment = true, -- easily (un)comment code, language aware
      dashboard = false, -- NeoVim 'home screen' on open
      esc_insertmode = true, -- map to <ESC> with no lag
      feline = true, -- statusline
      gitsigns = true, -- gitsigns in statusline
      lspsignature = true, -- lsp enhancements
      telescope_media = false, -- media previews within telescope finders
      vim_matchup = true, -- % operator enhancements
      cmp = true,
      nvimtree = true,
   },
   options = {
      lspconfig = {
         setup_lspconf = "", -- path of file containing setups of different lsps
      },
      nvimtree = {
         enable_git = 0,
      },
      luasnip = {
         snippet_path = {},
      },
      statusline = { -- statusline related options
         -- these are filetypes, not pattern matched
         -- shown filetypes will overrule hidden filetypes
         hidden = {
            "help",
            "dashboard",
            "NvimTree",
            "terminal",
         },
         -- show short statusline on small screens
         shortline = true,
         shown = {},
         -- default, round , slant , block , arrow
         style = "default",
      },
      esc_insertmode_timeout = 300,
   },
   default_plugin_config_replace = {},
}

local status = plugins.status

-- using { } for using different branch , loading plugin with certain commands etc
return require("packer").startup(
    function()
        use {
            "wbthomason/packer.nvim",
            -- event = "VimEnter",
        }

        use {
            "nvim-lua/plenary.nvim",
        }

        -- color related stuff
        use {
            "norcalli/nvim-colorizer.lua",
            event = "BufRead",
            config = function()
                require("plugins.others").colorizer()
            end
        }

        use {
            "kyazdani42/nvim-web-devicons",
            config = function()
                require("plugins.nvim-web-devicons")
            end
        }

        -- status line
        use {
            "feline-nvim/feline.nvim",
            disable = not status.feline,
            after = "nvim-web-devicons",
            config = function()
                require("plugins.statusline")
            end
        }

        -- buffer line
        use {
            "akinsho/bufferline.nvim",
            disable = not status.bufferline,
            after = "nvim-web-devicons",
            config = function()
                require("plugins.bufferline")
            end,
            setup = function()
                require("mappings").bufferline()
            end,
        }

        use {
            "lukas-reineke/indent-blankline.nvim",
            disable = not status.blankline,
            event = "BufRead",
            config = function()
                require("plugins.others").blankline()
            end
        }

        use {
            "nvim-treesitter/nvim-treesitter",
            event = "BufRead",
            -- run = ':TSUpdate',
            config = function()
                require("plugins.nvim-treesitter")
            end,
        }

        -- git stuff
        use {
            "lewis6991/gitsigns.nvim",
            disable = not status.gitsigns,
            opt = true,
            config = function()
                require("plugins.gitsigns")
            end,
            setup = function()
                 require("utils").packer_lazy_load("gitsigns.nvim")
            end,
        }

        -- lsp stuff
        use {
            "neovim/nvim-lspconfig",
            opt = true,
            setup = function()
                require("utils").packer_lazy_load("nvim-lspconfig")
                -- reload the current file so lsp actually starts for it
                vim.defer_fn(function()
                    vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
                end, 0)

            end,
            config = function()
                require("plugins.lsp")
            end,
        }

        use {
            "ray-x/lsp_signature.nvim",
            disable = not status.lspsignature,
            after = "nvim-lspconfig",
            config = function()
                require("plugins.others").signature()
            end,
        }

        use {
            "andymass/vim-matchup",
            disable = not status.vim_matchup,
            opt = true,
            setup = function()
                require("utils").packer_lazy_load "vim-matchup"
            end,
        }

        use {
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require("plugins.trouble")
            end,
        }

        -- use {
        --     "max397574/better-escape.nvim",
        --     disable = not status.esc_insertmode,
        --     event = "InsertEnter",
        --     config = function()
        --         require("plugins.others").better_escape()
        --     end,
        -- }

        -- use {
        --     "glepnir/lspsaga.nvim",
        -- }

        use {
            "sbdchd/neoformat",
        }

        use {
            "mfussenegger/nvim-dap",
            config = function()
                require("plugins.nvim-dap")
            end,
        }

        use {
            "rcarriga/nvim-dap-ui",
            requires = {"mfussenegger/nvim-dap"},
            config = function()
                require("plugins.others").dapui()
            end,
        }

        -- load luasnips + cmp related in insert mode only

        use {
            "rafamadriz/friendly-snippets",
            disable = not status.cmp,
            event = "InsertEnter",
        }

        use {
            "hrsh7th/nvim-cmp",
            disable = not status.cmp,
            after = "friendly-snippets",
            config = function()
                require("plugins.cmp")
            end,
        }

        use {
            "L3MON4D3/LuaSnip",
            disable = not status.cmp,
            wants = "friendly-snippets",
            after = "nvim-cmp",
            config = function()
                require("plugins.others").luasnip()
            end,
        }

        use {
            "saadparwaiz1/cmp_luasnip",
            disable = not status.cmp,
            after = "LuaSnip",
        }

        use {
            "hrsh7th/cmp-nvim-lua",
            disable = not status.cmp,
            after = "cmp_luasnip",
        }

        use {
            "hrsh7th/cmp-nvim-lsp",
            disable = not status.cmp,
            after = "cmp-nvim-lua",
        }

        use {
            "hrsh7th/cmp-buffer",
            disable = not status.cmp,
            after = "cmp-nvim-lsp",
        }

        use {
            "hrsh7th/cmp-path",
            disable = not status.cmp,
            after = "cmp-buffer",
        }

        -- comment
        use {
            "terrortylor/nvim-comment",
            disable = not status.comment,
            cmd = "CommentToggle",
            config = function()
                require("plugins.others").comment()
            end,
            setup = function()
                require("mappings").comment()
            end,
        }

        -- file managing , picker etc

        use {
            "kyazdani42/nvim-tree.lua",
            disable = not status.nvimtree,
            requires = 'kyazdani42/nvim-web-devicons',
            config = function() 
                require("plugins.nvim-tree")
            end,
            -- setup = function()
            --     require("core.mappings").nvimtree()
            -- end,
        }


        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {"nvim-lua/plenary.nvim"},
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    run = "make",
                },
                {
                    "nvim-telescope/telescope-media-files.nvim",
                    disable = not status.telescope_media,
                    setup = function()
                        require("mappings").telescope_media()
                    end,
                },
            },
            cmd = "Telescope",
            config = function()
                require("plugins.telescope")
            end,
        }

        -- misc
        use {
            "windwp/nvim-autopairs",
            disable = not status.cmp,
            after = "nvim-cmp",
            config = function()
                require("plugins.others").autopairs()
            end,
        }

        use {
          "tpope/vim-surround"
        }

        use {
            "folke/which-key.nvim",
            config = function()
                require("plugins.which-key")
            end,
        }

        -- markdonw preview live reload
        use {
            "iamcco/markdown-preview.nvim",
            run = "cd app && yarn install",
            config = function()
                require("plugins.others").markdown()
            end,
        }

        -- discord rich presence
        -- use "andweeb/presence.nvim"
        use {
            "christoomey/vim-tmux-navigator",
        }
        
    end,
    {
        display = {
            border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
        }
    }
)
