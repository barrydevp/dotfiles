local util = require("vim.lsp.util")
local ms = require("vim.lsp.protocol").Methods
local api = vim.api
local fn = vim.fn
local dwidth = fn.strdisplaywidth

local hint_mode = "overlay"
local hint_prefix = "󰞂 "
local hint_postfix = " "
local hint_scheme = "LspSignatureHintParameter"

local M = {
  vt_ns = vim.api.nvim_create_namespace("lsp_signature_vt"),
  state = {},
}

M.set_state = function(v, r)
  -- replaced
  if r then
    M.state = v
  else
    M.state = vim.tbl_extend("force", M.state, v)
  end
end

M.clear_state = function()
  M.set_state({}, true)
end

--[[
Trigger Result {
  is_triggered: boolean
  pos: number
  trigger_char: char | nil
}
--]]
M.check_trigger_char = function(ctx, last_tr, trigger_chars, retrigger_chars)
  local pos = ctx.pos
  local line = ctx.line

  local tr = {
    is_triggered = false,
    pos = pos,
    trigger_char = nil,
  }

  if not trigger_chars then
    return tr
  end

  local cur_char = line:sub(pos[2], pos[2])

  for _, char in ipairs(trigger_chars) do
    if cur_char == char then
      tr.is_triggered = true
      tr.pos = pos
      tr.trigger_char = char

      return tr
    end
  end

  if last_tr and last_tr.is_triggered then
    -- if trigger_chars contains "("
    -- we assume function args are surronded by () in this language
    local parenthesis = vim.tbl_contains(trigger_chars, "(")

    if last_tr.pos[1] ~= ctx.pos[1] or last_tr.pos[2] > ctx.pos[2] then
      -- in case of remove text or move cursor to the left or up/down
      -- we let lsp decide if signature hint still active
      tr.is_triggered = true
      return tr
    else
      local untrigger_chars = retrigger_chars
      if parenthesis then
        untrigger_chars = { ")" }
      end

      for _, char in ipairs(untrigger_chars) do
        -- if we found untrigger char
        -- we let lsp decide if signature hint still active
        -- since some untrigger char is not the end of the param hint
        -- eg: assert((true & false), "is not true")
        --                         ^ -> this untrigger char is not for closeing
        if cur_char == char then
          tr.is_triggered = true
          tr.pos = pos
          tr.trigger_char = char

          return tr
        end
      end
    end

    -- if no untrigger char found, keep the previous result
    -- as we do not know if param hint is closed yet
    return last_tr
  end

  return tr
end

-- modified of:
-- https://github.com/neovim/neovim/blob/e3bd04f2aff738722c06276cc926d4bdd4501402/runtime/lua/vim/lsp/util.lua#L896
M.parse_signature = function(signature_help)
  if not (signature_help and signature_help.signatures) then
    return
  end

  local active_signature = signature_help.activeSignature or 0
  -- If the activeSignature is not inside the valid range, then clip it.
  -- In 3.15 of the protocol, activeSignature was allowed to be negative
  if active_signature >= #signature_help.signatures or active_signature < 0 then
    active_signature = 0
  end
  local signature = signature_help.signatures[active_signature + 1]
  if not signature then
    return
  end

  local parameter

  if signature.parameters and #signature.parameters > 0 then
    local active_parameter = (signature.activeParameter or signature_help.activeParameter or 0)
    if active_parameter < 0 then
      active_parameter = 0
    end

    -- If the activeParameter is > #parameters, then set it to the last
    -- NOTE: this is not fully according to the spec, but a client-side interpretation
    if active_parameter >= #signature.parameters then
      active_parameter = #signature.parameters - 1
    end

    parameter = signature.parameters[active_parameter + 1]
    if parameter then
      --[=[
      --Represents a parameter of a callable-signature. A parameter can
      --have a label and a doc-comment.
      interface ParameterInformation {
        --The label of this parameter information.
        --
        --Either a string or an inclusive start and exclusive end offsets within its containing
        --signature label. (see SignatureInformation.label). The offsets are based on a UTF-16
        --string representation as `Position` and `Range` does.
        --
        --*Note*: a label of type string should be a substring of its containing signature label.
        --Its intended use case is to highlight the parameter label part in the `SignatureInformation.label`.
        label: string | [number, number];
        --The human-readable doc-comment of this parameter. Will be shown
        --in the UI but can be omitted.
        documentation?: string | MarkupContent;
      }
      --]=]
      if parameter.label then
        if type(parameter.label) == "table" then
          parameter.text = signature.label:sub(parameter.label[1] + 1, parameter.label[2])
        else
          parameter.text = parameter.label
        end
      end
    end
  end

  return signature, parameter
end

M.cleanup = function()
  -- vim.schedule(function()
  api.nvim_buf_clear_namespace(0, M.vt_ns, 0, -1)
  -- end)
end

M.virtual_hint = function(ctx, val)
  M.cleanup()

  if not val then
    return
  end

  local hint = vim.tbl_get(val, "param", "text")
  if hint == nil or hint == "" then
    return
  end

  local lines_above = vim.fn.winline() - 1
  -- dont show if not have any lines above
  if lines_above == 0 then
    return
  end

  local prev_line = api.nvim_buf_get_lines(0, ctx.pos[1] - 2, ctx.pos[1] - 1, false)[1]
  -- local prev_x = dwidth(prev_line)
  local prev_x = #prev_line
  local width = api.nvim_win_get_width(0)

  local hint_text = hint_prefix .. hint .. hint_postfix
  -- use dwidth() because UTF char occupies 1 col
  local dw_hint_text = dwidth(hint_text)
  -- 6 is the margin (sign + number col)
  local margin = 6
  -- overflow line is wrapped
  -- so offset is relative to the width
  local offset = (ctx.pos[2] - 1) % (width - margin) + 1 -- 1-index based
  -- if hint is overflow the screen, we move the hint to the left
  -- we minus 1 in the left hand side of comparision because extmarks is 1 more
  -- colunm than buffer line
  if (offset + dw_hint_text) > (width - margin + 1) then
    offset = width - margin - dw_hint_text + 1
  end

  local pad_len = offset - prev_x
  local col = offset - 1 -- 0-index based
  local vts
  if pad_len > 0 then
    vts = { { string.rep(" ", pad_len), "Normal" }, { hint_text, hint_scheme } }
    col = offset - pad_len
  else
    vts = { { hint_prefix .. hint .. hint_postfix, hint_scheme } }
  end
  -- print(vim.inspect(vts))
  -- print(pad_len .. "," .. offset)

  -- print("col: " .. col .. ", ctx.pos[1]: " .. ctx.pos[1])
  vim.api.nvim_buf_set_extmark(0, M.vt_ns, ctx.pos[1] - 2, col, {
    virt_text = vts,
    virt_text_pos = hint_mode,
    hl_mode = "combine",
  })
end

M.trigger_signature = function(ctx, tr)
  if tr.is_triggered then
    -- if current char is trigger char, request new signature state
    if tr.pos[2] == ctx.pos[2] then
      local params = util.make_position_params()
      vim.lsp.buf_request(0, ms.textDocument_signatureHelp, params, function(_, result, rctx, _)
        if api.nvim_get_current_buf() ~= rctx.bufnr then
          -- Ignore result since buffer changed. This happens for slow language servers.
          return
        end

        -- if not (result and result.signatures and result.signatures[1]) then
        --   M.clear_state()
        --   M.cleanup()
        --   return
        -- end

        local sign, param = M.parse_signature(result)
        if not param then
          M.clear_state()
          M.cleanup()
          return
        end

        local val = {
          sign = sign,
          param = param,
        }

        -- cached the result for further render
        M.set_state({ val = val }, false)

        -- render the active parameter
        M.virtual_hint(ctx, val)
      end)
    else -- else keep the current signature state and re-render
      M.virtual_hint(ctx, M.state.val)
    end
  else
    M.clear_state()
    M.cleanup()
  end
end

M.retrive_ctx = function()
  local pos = api.nvim_win_get_cursor(0)
  local line = api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])
  return {
    line = line,
    pos = pos,
    line_to_cursor = line_to_cursor,
  }
end

M.parameter_hints = function()
  local ctx = M.retrive_ctx()
  local tr = {
    is_triggered = true,
    pos = ctx.pos,
    trigger_char = nil,
  }
  M.set_state({ tr = tr, ctx = ctx }, false)
  M.trigger_signature(ctx, tr)
end

M.setup = function(client, bufnr)
  local group = vim.api.nvim_create_augroup("LspSignature", { clear = false })
  vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }

  local trigger_chars = vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "triggerCharacters")
  local retrigger_chars = vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "retriggerCharacters")

  -- { "InsertLeave", "BufHidden", "ModeChanged" }
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      M.clear_state()
      M.cleanup()
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      -- let lsp decide if signature hint is available for current position
      M.parameter_hints()
    end,
  })

  vim.api.nvim_create_autocmd({ "CursorMovedI" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      local ctx = M.retrive_ctx()
      M.set_state({ ctx = ctx }, false)

      local tr = M.check_trigger_char(ctx, M.state.tr, trigger_chars, retrigger_chars)
      M.set_state({ tr = tr }, false)
      -- print(vim.inspect(tr))

      M.trigger_signature(ctx, tr)
    end,
  })
end

return M
