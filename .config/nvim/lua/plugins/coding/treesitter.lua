local Utils = require("utils")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    event = { "VeryLazy" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    keys = {
      { "<CR>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    build = ":TSUpdate",
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "scss",
      },
      highlight = {
        enable = true,
        -- disable = { "comment", "jsdoc" },
        disable = function(lang, bufnr) -- Disable in large C++ buffers
          local disable = { "comment", "jsdoc" }
          for _, parser in pairs(disable) do
            if lang == parser then
              return true
            end
          end

          return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 4000
        end,
      },
      indent = {
        enable = true,
      },
      -- matchup = { -- this cause very lagging when typing large file
      --   enable = true,
      -- },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]b"] = "@block.outer",
            ["]f"] = "@function.outer",
            -- ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]B"] = "@block.outer",
            ["]F"] = "@function.outer",
            -- ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[b"] = "@block.outer",
            ["[f"] = "@function.outer",
            -- ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[B"] = "@block.outer",
            ["[F"] = "@function.outer",
            -- ["[C"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = Utils.extras.dedup(opts.ensure_installed)
      end

      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if Utils.plugin.is_loaded("nvim-treesitter") then
        local opts = Utils.plugin.opts("nvim-treesitter")
        require("nvim-treesitter.configs").setup { textobjects = opts.textobjects }
      end

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local conf = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(conf or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
}
