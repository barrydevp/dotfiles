local LspFn = require("plugins.lsp.utils.fn")
local LspMason = require("plugins.lsp.utils.mason")

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
    init = function()
      -- load all lspconfig
      require("core.utils").load_mappings("lspconfig")
    end,
    opts = function()
      return {
        -- add any global capabilities here
        capabilities = {},
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
      -- Setup Attach
      LspFn.on_attach(function(client, buffer)
        if client then
          require("core.utils").load_mappings("lspconfig_attach", { buffer = buffer })

          if client.server_capabilities.signatureHelpProvider then
            require("plugins.lsp.ui.signature").setup(client, buffer)
          end
        end
      end)

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
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
