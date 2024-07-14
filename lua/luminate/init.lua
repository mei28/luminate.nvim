local api = vim.api
local config = require('luminate.config')
local highlight = require('luminate.highlight')
local autocmds = require('luminate.autocmds')
local undo_redo = require('luminate.undo_redo')

local M = {}

function M.setup(user_config)
  config.config = vim.tbl_deep_extend('force', config.config, user_config or {})

  -- yank/paste/undo/redo highlight settings
  highlight.set_highlight(config.config.yank.hlgroup, {
    ctermbg = config.config.yank.ctermbg,
    bg = config.config.yank.guibg,
    fg = config.config.yank.fg,
  })

  highlight.set_highlight(config.config.paste.hlgroup, {
    ctermbg = config.config.paste.ctermbg,
    bg = config.config.paste.guibg,
    fg = config.config.paste.fg,
  })

  highlight.set_highlight(config.config.undo.hlgroup, {
    ctermbg = config.config.undo.ctermbg,
    bg = config.config.undo.guibg,
    fg = config.config.undo.fg,
  })

  highlight.set_highlight(config.config.redo.hlgroup, {
    ctermbg = config.config.redo.ctermbg,
    bg = config.config.redo.guibg,
    fg = config.config.redo.fg,
  })

  autocmds.set_autocmds()

  -- undo/redo keymap
  local undo = config.config.undo
  vim.keymap.set(undo.mode, undo.lhs, function()
    if config.config.highlight_for_count or vim.v.count == 0 then
      undo_redo.highlight_undo_redo('undo', function()
        undo_redo.call_original_kemap(undo.map)
      end)
    else
      local keys = api.nvim_replace_termcodes(vim.v.count .. 'u', true, false, true)
      api.nvim_feedkeys(keys, 'n', false)
    end
    undo_redo.open_folds_on_undo()
  end, undo.opts)

  local redo = config.config.redo
  vim.keymap.set(redo.mode, redo.lhs, function()
    if config.config.highlight_for_count or vim.v.count == 0 then
      undo_redo.highlight_undo_redo('redo', function()
        undo_redo.call_original_kemap(redo.map)
      end)
    else
      local keys = api.nvim_replace_termcodes(vim.v.count .. '<C-r>', true, false, true)
      api.nvim_feedkeys(keys, 'n', false)
    end
    undo_redo.open_folds_on_undo()
  end, redo.opts)
end

return M
