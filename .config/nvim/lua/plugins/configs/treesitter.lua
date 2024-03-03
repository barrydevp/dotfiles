local ts_config = require("nvim-treesitter.configs")

local default = {
  ensure_installed = {
    "vimdoc",
    "lua",
    "vim",
    "markdown",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "scss",
    "bash",
    "json",
    "python",
    "go",
    "gomod",
    "yaml",
    "toml",
    "dockerfile",
    "java",
    "c",
    "cpp",
    "c_sharp",
  },
  highlight = {
    enable = true,
    -- use_languagetree = true,
    -- disable = { "comment", "jsdoc" },
    disable = function(lang, bufnr) -- Disable in large C++ buffers
      local disable = { "comment", "jsdoc" }
      for _, parser in pairs(disable) do
        if lang == parser then
          return true
        end
      end

      -- return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 20000
      return false
    end,
  },
  indent = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
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
}

ts_config.setup(default)
