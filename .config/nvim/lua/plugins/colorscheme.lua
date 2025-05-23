local config = require("core.config")

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = config.ui.transparency, -- disables setting the background color.
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

          -- LineNrAbove = { fg = C.surface2 },
          -- LineNrBelow = { fg = C.surface2 },
          -- LineNr = { fg = C.lavender },

          -- Some of the Trouble highlight that is missing
          TroubleNormalNC = { fg = C.text, bg = config.ui.transparency and C.none or C.crust },

          -- cmp
          Pmenu = { bg = C.mantle },

          -- lsp signature
          -- LspSignatureActiveParameter = { fg = C.yellow },
          LspSignatureHintParameter = { fg = C.maroon, bg = C.mantle },

          -- snippet
          SnippetActive = { bg = C.overlay0 },
          SnippetPassive = { bg = C.overlay0 },

          -- misc
          CurSearch = { bg = C.yellow },

          -- Telescope
          TelescopeSelection = {
            fg = C.flamingo or C.text,
            bg = C.surface0,
            style = { "bold" },
          },

          -- AI suggestion
          AIAnnotation = {
            fg = "#808080",
            ctermfg = 244,
          },
          AISuggestion = {
            fg = "#808080",
            ctermfg = 244,
          },
        }
      end,
      integrations = {
        cmp = true,
        blink_cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        treesitter_context = true,
        notify = false,
        mini = true,
        alpha = false,
        dap = true,
        dap_ui = true,
        dashboard = false,
        flash = true,
        fidget = true,
        leap = false,
        mason = true,
        markdown = true,
        neogit = false,
        ufo = true,
        rainbow_delimiters = false,
        semantic_tokens = true,
        telescope = { enabled = true },
        barbecue = false,
        -- illuminate = true,
        indent_blankline = {
          enabled = true,
          -- colored_indent_levels = false,
        },
        lsp_saga = false,
        lsp_trouble = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = {
          enabled = false,
          custom_bg = "NONE",
        },
        dropbar = {
          enabled = false,
          color_mode = false,
        },
        snacks = true,
        which_key = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      -- setup must be called before loading
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
