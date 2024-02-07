local ts_config = require("nvim-treesitter.configs")

local default = {
  ensure_installed = {
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
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
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
}

ts_config.setup(default)
