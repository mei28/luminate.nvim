local api = vim.api
local config = require('luminate.config')
local highlight = require('luminate.highlight')
local autocmds = require('luminate.autocmds')
local undo_redo = require('luminate.undo_redo')

local M = {}

local function remove_hlgroup(user_config)
  local groups = { 'yank', 'paste', 'undo', 'redo' }
  for _, group in ipairs(groups) do
    if user_config[group] then
      user_config[group].hlgroup = nil
    end
  end
end

local function set_highlight_groups()
  local highlight_groups = { 'yank', 'paste', 'undo', 'redo' }
  for _, group in ipairs(highlight_groups) do
    highlight.set_highlight(config.config[group].hlgroup, {
      ctermbg = config.config[group].ctermbg,
      bg = config.config[group].guibg,
      fg = config.config[group].fg,
    })
  end
end

local function set_keymaps()
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

local function create_autocmds()
  -- Create an augroup for plugin-specific autocmds
  api.nvim_create_augroup('LuminatePlugin', { clear = true })

  -- Listening to the custom setup complete event
  api.nvim_create_autocmd('User', {
    group = 'LuminatePlugin',
    pattern = 'LuminateSetupComplete',
    callback = function()
      autocmds.set_additional_autocmds()
    end
  })

  vim.cmd('doautocmd User LuminateSetupComplete')
end

function M.setup(user_config)
  if user_config then
    remove_hlgroup(user_config)
  end

  config.config = vim.tbl_deep_extend('force', config.config, user_config or {})

  set_highlight_groups()
  autocmds.set_autocmds()
  set_keymaps()
  create_autocmds()
end

return M
