local api = vim.api
local config_module = require('luminate.config')
local highlight = require('luminate.highlight')
local autocmds = require('luminate.autocmds')
local actions = require('luminate.actions')

local M = {}

local function set_highlight_groups()
  local highlight_groups = { 'yank', 'paste', 'undo', 'redo' }
  for _, group in ipairs(highlight_groups) do
    highlight.set_highlight(config_module.config[group].hlgroup, {
      ctermbg = config_module.config[group].ctermbg,
      bg = config_module.config[group].guibg,
      fg = config_module.config[group].fg,
    })
  end
end

local function set_keymaps()
  local function set_keymap_for_action(action, keys)
    local config = config_module.config[action]
    for _, lhs in ipairs(keys) do
      vim.keymap.set(config.mode, lhs, function()
        if config_module.config.highlight_for_count or vim.v.count == 0 then
          actions.highlight_action(config_module, action, function()
            if lhs == '<C-r>' then
              vim.cmd('redo')
            else
              actions.call_original_map(config.map[lhs] or config.map)
            end
          end)
        else
          local key_sequence = api.nvim_replace_termcodes(vim.v.count .. lhs, true, false, true)
          api.nvim_feedkeys(key_sequence, 'n', false)
        end
        actions.open_folds_on_undo()
      end, config.opts)
    end
  end

  set_keymap_for_action('undo', config_module.config.undo.lhs)
  set_keymap_for_action('redo', config_module.config.redo.lhs)
  set_keymap_for_action('paste', config_module.config.paste.lhs)
end

function M.setup(user_config)
  config_module.config = vim.tbl_deep_extend('force', config_module.config, user_config or {})

  set_highlight_groups()
  autocmds.set_autocmds()
  set_keymaps()
end

return M
