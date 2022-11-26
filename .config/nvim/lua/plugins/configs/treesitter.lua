local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then
  return
end

local default = {
  ensure_installed = {
    "lua",
    "vim",
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
    use_languagetree = true,
    disable = { "comment", "jsdoc" },
  },
  indent = {
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
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]b"] = "@block.outer",
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]B"] = "@block.outer",
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[b"] = "@block.outer",
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[B"] = "@block.outer",
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

ts_config.setup(default)
