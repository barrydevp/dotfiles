return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    event = { "VeryLazy" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
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
    },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    opts = {
      ensure_installed = {
        "vimdoc",
        "lua",
        "vim",
        "markdown",
        "markdown_inline",
        "ninja",
        "rst",
        "yaml",
        "toml",
        "json",
        "html",
        "css",
        "scss",

        "javascript",
        "typescript",
        "tsx",

        "bash",
        "dockerfile",

        "python",

        "go",
        "gomod",
        "gowork",
        "gosum",

        "java",
        "c",
        "cpp",
        "c_sharp",
        "rust",
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
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
            -- ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            -- ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

            -- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
            ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
            ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
            -- ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
            -- ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },

            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]b"] = "@block.outer",
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]B"] = "@block.outer",
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[b"] = "@block.outer",
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[B"] = "@block.outer",
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
