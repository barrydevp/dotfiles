require("catppuccin").setup {
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false, -- disables setting the background color.
  show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
  term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
  dim_inactive = {
    enabled = false, -- dims the background color of inactive window
    shade = "dark",
    percentage = 0.15, -- percentage of the shade to apply to the inactive window
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  no_underline = false, -- Force no underline
  styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    -- miscs = {}, -- Uncomment to turn off hard-coded styles
  },
  custom_highlights = function(colors)
    return {
      -- WinBar = { bg = colors.mantle },
      -- WinBarNC = { bg = colors.mantle },

      -- Tabufline
      TblineFill = {
        bg = colors.crust,
      },
      TbLineBufOn = {
        fg = colors.lavender,
        bg = colors.crust,
      },
      TbLineBufOff = {
        fg = colors.surface1,
        bg = colors.mantle,
      },
      TbLineBufOnModified = {
        fg = colors.green,
        bg = colors.crust,
      },
      TbLineBufOffModified = {
        fg = colors.red,
        bg = colors.mantle,
      },
      TbLineBufOnClose = {
        fg = colors.red,
        bg = colors.crust,
      },
      TbLineBufOffClose = {
        fg = colors.surface1,
        bg = colors.mantle,
      },
      TblineTabNewBtn = {
        fg = colors.lavender,
        bg = colors.overlay2,
        bold = true,
      },
      TbLineTabOn = {
        fg = colors.crust,
        bg = colors.blue,
        bold = true,
      },
      TbLineTabOff = {
        fg = colors.lavender,
        bg = colors.overlay2,
      },
      TbLineTabCloseBtn = {
        fg = colors.crust,
        bg = colors.blue,
      },
      TBTabTitle = {
        fg = colors.crust,
        bg = colors.lavender,
      },
      TbLineThemeToggleBtn = {
        bold = true,
        fg = colors.lavender,
        bg = colors.overlay2,
      },
      TbLineCloseAllBufsBtn = {
        bold = true,
        bg = colors.red,
        fg = colors.crust,
      },
    }
  end,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = false,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    alpha = false,
    dap = true,
    dap_ui = true,
    dashboard = false,
    flash = false,
    leap = false,
    mason = true,
    markdown = true,
    neogit = false,
    ufo = false,
    rainbow_delimiters = false,
    semantic_tokens = true,
    telescope = { enabled = true, style = "nvchad" },
    barbecue = false,
    illuminate = false,
    indent_blankline = {
      enabled = true,
      -- colored_indent_levels = false,
    },
    lsp_saga = false,
    lsp_trouble = false,
    navic = {
      enabled = false,
      custom_bg = "NONE",
    },
    dropbar = {
      enabled = true,
      color_mode = true,
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
}

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
