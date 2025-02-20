local LspFn = require("utils.lsp")
local LspMason = require("utils.mason")
local keys = require("core.lsp").keys

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      -- Binary management for language servers.
      { "williamboman/mason.nvim" },
      -- Neovim notifications and LSP progress messages.
      {
        "j-hui/fidget.nvim",
        opts = {
          -- options
        },
      },
    },
    keys = {
      { "<leader>lz", "<cmd>LspInfo<cr>", { desc = "lsp info" } },
    },
    opts = function()
      return {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 2,
            source = "if_many",
            prefix = "●",
            -- prefix = function(diagnostic)
            --   for d, icon in pairs(icons.diagnostics) do
            --     if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            --       return icon
            --     end
            --   end
            --   return " "
            -- end,
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          -- signs = false,
          -- signs = {
          --   text = {
          --     [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          --     [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
          --     [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
          --     [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
          --   },
          -- },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = false,
          exclude = {}, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- LSP Server Settings
        servers = { -- example setup lua_ls
          -- lua_ls = {
          --   settings = {
          --     Lua = {
          --       workspace = {
          --         checkThirdParty = false,
          --       },
          --     },
          --   },
          -- },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        -- return false if you want this server to be setup with lspconfig
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
    end,
    config = function(_, opts)
      -- General
      vim.diagnostic.config(opts.diagnostics)

      -- Setup Attach
      LspFn.on_attach(function(client, buffer)
        if client then
          require("utils").set_keymaps(keys, { buffer = buffer })

          if client.server_capabilities.signatureHelpProvider then
            -- print(vim.inspect(client))
            require("plugins.lsp.ui.signature").setup(client, buffer)
          end

          -- check supported method
          local on_supports_method = function(method, fn)
            if client.supports_method(method, buffer) then
              fn()
            end
          end

          -- codelens
          if opts.codelens.enabled and vim.lsp.codelens then
            on_supports_method("textDocument/codeLens", function()
              vim.lsp.codelens.refresh()
              vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = buffer,
                callback = vim.lsp.codelens.refresh,
              })
            end)
          end
        end
      end)

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server, server_opts)
        server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, server_opts or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- Call setup for all register LSP servers
      for server, server_opts in pairs(servers) do
        setup(server, server_opts)
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = {
      ensure_installed = {}, -- not an option from mason.nvim
      max_concurrent_installers = 10,
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local ensure_installed = {}
      for binary, _ in pairs(opts.ensure_installed) do
        table.insert(ensure_installed, LspMason.server_maps[binary] or binary)
      end

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if #ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = ensure_installed
    end,
  },
}
