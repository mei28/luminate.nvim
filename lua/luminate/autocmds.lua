local api = vim.api
local highlight = require('luminate.highlight')
local config_module = require('luminate.config')
local M = {}

function M.set_autocmds()
  api.nvim_create_augroup('LuminateHighlight', { clear = true })

  if config_module.config.yank.enabled then
    api.nvim_create_autocmd('TextYankPost', {
      group = 'LuminateHighlight',
      callback = function() M.on_yank() end
    })
  end

  -- paste/undo/redo highlights are triggered only via keymaps
  -- BufEnter buffer attach removed to prevent unwanted highlights on unintended operations
end

function M.on_yank()
  vim.highlight.on_yank({
    higroup = config_module.config.yank.hlgroup,
    timeout = config_module.config.duration,
    namespace = config_module.namespaces.yank,
  })
end

return M

