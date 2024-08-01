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
    if not config then print("LUMINATE.NVIM ERROR: config is nil.") return end
    local mappings = api.nvim_get_keymap(config.mode)
    local buf_mappings = api.nvim_buf_get_keymap(0, config.mode)
    for _, lhs in ipairs(keys) do
      local original_map = mappings[lhs] or buf_mappings[lhs] or {}
      local rhs = original_map.rhs or original_map.callback or lhs
      vim.keymap.set(config.mode, lhs,
        (type(rhs) == "string" and rhs .. " <cmd>doautocmd User Luminate_" .. action .. "<CR>")
        or (type(rhs) == "function" and function ()
          rhs()
          api.nvim_exec_autocmds("User", { "Luminate_" .. action })
        end
        or ""),
        { noremap = true, desc = original_map.desc or "" }
      )
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
