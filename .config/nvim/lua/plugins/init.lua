require("core.utils").load_keymaps("lazy")

require("lazy").setup {
  spec = {
    { import = "plugins.util" },
    { import = "plugins.colorscheme" },
    { import = "plugins.ui" },
    { import = "plugins.treesitter" },
    { import = "plugins.editor" },
    { import = "plugins.coding" },
    { import = "plugins.lsp" },
    { import = "plugins.extras" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
  -- checker = { enabled = true }, -- automatically check for plugin updates
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = false, -- get a notification when changes are found
  },

  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
