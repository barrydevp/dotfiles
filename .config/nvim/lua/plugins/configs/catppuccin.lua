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
  custom_highlights = function(C)
    return {
      -- WinBar = { bg = colors.mantle },
      -- WinBarNC = { bg = colors.mantle },

      LineNrAbove = { fg = C.surface1 },
      LineNrBelow = { fg = C.surface1 },
      LineNr = { fg = C.lavender },

      -- Tabufline
      TblineFill = {
        bg = C.crust,
      },
      TbLineBufOn = {
        fg = C.lavender,
        bg = C.crust,
      },
      TbLineBufOff = {
        fg = C.surface1,
        bg = C.mantle,
      },
      TbLineBufOnModified = {
        fg = C.green,
        bg = C.crust,
      },
      TbLineBufOffModified = {
        fg = C.red,
        bg = C.mantle,
      },
      TbLineBufOnClose = {
        fg = C.red,
        bg = C.crust,
      },
      TbLineBufOffClose = {
        fg = C.surface1,
        bg = C.mantle,
      },
      TblineTabNewBtn = {
        fg = C.lavender,
        bg = C.overlay2,
        bold = true,
      },
      TbLineTabOn = {
        fg = C.crust,
        bg = C.blue,
        bold = true,
      },
      TbLineTabOff = {
        fg = C.lavender,
        bg = C.overlay2,
      },
      TbLineTabCloseBtn = {
        fg = C.crust,
        bg = C.blue,
      },
      TBTabTitle = {
        fg = C.crust,
        bg = C.lavender,
      },
      TbLineThemeToggleBtn = {
        bold = true,
        fg = C.lavender,
        bg = C.overlay2,
      },
      TbLineCloseAllBufsBtn = {
        bold = true,
        bg = C.red,
        fg = C.crust,
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
    ufo = true,
    rainbow_delimiters = false,
    semantic_tokens = true,
    telescope = { enabled = true, style = "nvchad" },
    barbecue = false,
    illuminate = true,
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
