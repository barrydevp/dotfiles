--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm")
local k = require("utils/key")
local act = wezterm.action

local config = {
  -- default_prog = { "/opt/homebrew/bin/sesh" },
  background = {
    {
      source = {
        Gradient = {
          colors = { "#000000" },
        },
      },
      width = "100%",
      height = "100%",
      opacity = 0.8,
    },
  },

  font_size = 15,

  line_height = 1.0,
  font = wezterm.font_with_fallback {
    -- { family = "CommitMono", weight = "Medium" },
    -- { family = "Monaspace Neon", weight = "Medium" },
    { family = "JetBrainsMono Nerd Font", weight = "Medium" },
  },

  -- color_scheme = "Catppuccin Mocha",

  window_padding = {
    left = 30,
    right = 30,
    top = 20,
    bottom = 10,
  },

  set_environment_variables = {
    TERM = "xterm-256color",
    LC_ALL = "en_US.UTF-8",
  },

  -- general options
  adjust_window_size_when_changing_font_size = false,
  debug_key_events = false,
  enable_tab_bar = false,
  -- native_macos_fullscreen_mode = false,
  -- window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",

  -- keys
  keys = {
    k.cmd_key("[", act.SendKey { mods = "OPT", key = "[" }),
    k.cmd_key("]", act.SendKey { mods = "OPT", key = "]" }),
    k.cmd_to_tmux_prefix("1", "1"),
    k.cmd_to_tmux_prefix("2", "2"),
    k.cmd_to_tmux_prefix("3", "3"),
    k.cmd_to_tmux_prefix("4", "4"),
    k.cmd_to_tmux_prefix("5", "5"),
    k.cmd_to_tmux_prefix("6", "6"),
    k.cmd_to_tmux_prefix("7", "7"),
    k.cmd_to_tmux_prefix("8", "8"),
    k.cmd_to_tmux_prefix("9", "9"),
    k.cmd_to_tmux_prefix("b", "B"),
    k.cmd_to_tmux_prefix("C", "C"),
    k.cmd_to_tmux_prefix("d", "D"),
    k.cmd_to_tmux_prefix("g", "G"),
    k.cmd_to_tmux_prefix("o", "O"),
    k.cmd_to_tmux_prefix("k", "K"),
    k.cmd_to_tmux_prefix("l", "L"),
    k.cmd_to_tmux_prefix("w", "x"),
    k.cmd_to_tmux_prefix("z", "Z"),
    k.cmd_to_tmux_prefix("q", "Q"),

    k.cmd_key(
      "s",
      act.Multiple {
        act.SendKey { key = "\x1b" }, -- escape
        k.multiple_actions(":w"),
      }
    ),

    {
      mods = "CMD|SHIFT",
      key = "}",
      action = act.Multiple {
        act.SendKey(k.TmuxPrefix),
        act.SendKey { key = "n" },
      },
    },
    {
      mods = "CMD|SHIFT",
      key = "{",
      action = act.Multiple {
        act.SendKey(k.TmuxPrefix),
        act.SendKey { key = "p" },
      },
    },
  },
}

return config
