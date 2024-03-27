return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end,
    config = function()
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticWarn",
        linehl = "DapStopped",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "",
        texthl = "DiagnosticInfo",
        linehl = "",
        numhl = "",
      })
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
      },
      layouts = {
        -- You can change the order of elements in the sidebar
        {
          elements = {
            -- Provide as ID strings or tables with "id" and "size" keys
            {
              id = "scopes",
              size = 0.4, -- Can be float or integer > 1
            },
            { id = "breakpoints", size = 0.2 },
            { id = "stacks", size = 0.2 },
            { id = "watches", size = 0.2 },
          },
          size = 30,
          position = "left", -- Can be "left", "right", "top", "bottom"
        },
        {
          elements = { "repl" },
          size = 12,
          position = "bottom", -- Can be "left", "right", "top", "bottom"
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
    end,
  },
}
