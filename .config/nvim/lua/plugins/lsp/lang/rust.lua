local Utils = require("utils")

return {
  recommended = function()
    return Utils.wants {
      ft = "rust",
      root = { "Cargo.toml", "rust-project.json" },
    }
  end,

  -- Add Rust & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },

  -- LSP for Cargo.toml
  -- {
  --   "Saecki/crates.nvim",
  --   event = { "BufRead Cargo.toml" },
  --   opts = {
  --     completion = {
  --       crates = {
  --         enabled = true,
  --       },
  --     },
  --     lsp = {
  --       enabled = true,
  --       actions = true,
  --       completion = true,
  --       hover = true,
  --     },
  --   },
  -- },

  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    opts = {
      -- Let's rustaceanvim handle the setup
      -- servers = {
      --   rust_analyzer = {
      --     settings = {
      --       {
      --         ["rust-analyzer"] = {
      --           -- ["rust-analyzer.cargo.target"] = "",
      --           ["rust-analyzer.checkOnSave.allTargets"] = false,
      --         },
      --       },
      --     },
      --   },
      -- },
      -- setup = {
      --   rust_analyzer = function()
      --     return true
      --   end,
      -- },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    ft = { "rust" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            "codelldb",
          },
        },
      },
    },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          -- vim.keymap.set("n", "<leader>la", function()
          --   vim.cmd.RustLsp("codeAction")
          -- end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            -- checkOnSave = {
            --   allFeatures = true,
            --   command = "clippy",
            --   extraArgs = { "--no-deps" },
            -- },
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local codelldb = vim.fn.exepath("codelldb")
      local codelldb_lib_ext = io.popen("uname"):read("*l") == "Linux" and ".so" or ".dylib"
      local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
      }
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}
