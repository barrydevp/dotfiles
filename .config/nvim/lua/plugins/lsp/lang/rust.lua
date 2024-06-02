return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        rust_analyzer = {},

        codelldb = {},
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
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
    version = "^4", -- Recommended
    ft = { "rust" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
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
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}
