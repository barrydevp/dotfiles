local cmd = vim.cmd

local colors = {
    white = "#abb2bf",
    black = "#1e222a", --  nvim bg
    black2 = "#252931",
    one_bg = "#282c34", -- real bg of onedark
    one_bg2 = "#353b45",
    grey = "#676a71",
    light_grey = "#54585f",
    red = "#d47d85",
    line = "#2a2e36", -- for lines like vertsplit
    green = "#A3BE8C",
    nord_blue = "#81A1C1",
    blue = "#61afef",
    yellow = "#e7c787",
    purple = "#b4bbc8"
}

-- for guifg , bg
local function fg(group, color) cmd("hi " .. group .. " guifg=" .. color) end

local function bg(group, color) cmd("hi " .. group .. " guibg=" .. color) end

local function fg_bg(group, fgcol, bgcol)
    cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

-- blankline
fg("IndentBlanklineChar", colors.line)

-- misc --
fg_bg("Normal", "NONE", "NONE")
fg_bg("NonText", "NONE", "NONE")
fg("LineNr", colors.light_grey)
fg("Comment", colors.grey)
fg("NvimInternalError", colors.red)
fg("EndOfBuffer", colors.black)
fg("NormalFloat", "NONE")
fg("CursorLineNr", colors.white)
bg("CursorLine", "#31353c")
cmd("hi MatchParen gui=bold")
cmd("hi TODO gui=bold guibg=#282c34")

-- Pmenu
bg("Pmenu", colors.one_bg)
bg("PmenuSbar", colors.one_bg2)
bg("PmenuSel", colors.green)
bg("PmenuThumb", colors.nord_blue)

-- Git
fg_bg("SignifySignAdd", '#98c379', "NONE")
fg_bg("SignifySignChange", '#61afef', "NONE")
fg_bg("SignifySignDelete", '#e06c75', "NONE")
fg_bg("SignifySignChangeDelete", '#c678dd', "NONE")
fg("DiffAdd", '#98c379')
fg("DiffChange", '#61afef')
fg("DiffDelete", '#e06c75')
fg("DiffText", '#c678dd')

-- NvimTree
fg("NvimTreeFolderIcon", colors.blue)
fg("NvimTreeFolderName", colors.blue)
fg("NvimTreeOpenedFolderName", colors.blue)
fg("NvimTreeEmptyFolderName", colors.blue)
fg("NvimTreeIndentMarker", colors.one_bg2)
fg("NvimTreeVertSplit", "#3a404d")
bg("NvimTreeVertSplit", "NONE")

-- telescope
fg("TelescopeBorder", colors.green)
fg("TelescopePromptBorder", colors.green)
fg("TelescopeResultsBorder", colors.green)
fg("TelescopePreviewBorder", colors.green)

-- === LspDiagnostics === ---
-- error / warnings
fg("LspDiagnosticsSignError", colors.red)
fg("LspDiagnosticsVirtualTextError", colors.red)
fg("LspDiagnosticsSignWarning", colors.yellow)
fg("LspDiagnosticsVirtualTextWarning", colors.yellow)

-- info
fg("LspDiagnosticsSignInformation", colors.green)
fg("LspDiagnosticsVirtualTextInformation", colors.green)

-- hint
fg("LspDiagnosticsSignHint", colors.purple)
fg("LspDiagnosticsVirtualTextHint", colors.purple)

