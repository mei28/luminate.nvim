local api = vim.api
local highlight = require('luminate.highlight')
local config_module = require('luminate.config')
local M = {}

function M.set_additional_autocmds()
  if config_module.config.paste.enabled then
    M.attach_bytes_highlight('paste')
  end
end

function M.set_autocmds()
  api.nvim_create_augroup('LuminateHighlight', { clear = true })

  if config_module.config.yank.enabled then
    api.nvim_create_autocmd('TextYankPost', {
      group = 'LuminateHighlight',
      callback = function() M.on_yank() end
    })
  end

  if config_module.config.paste.enabled then
    api.nvim_create_autocmd('TextChanged', {
      group = 'LuminateHighlight',
      callback = function() M.attach_bytes_highlight('paste') end
    })
  end

  if config_module.config.undo.enabled or config_module.config.redo.enabled then
    api.nvim_create_autocmd('BufEnter', {
      group = 'LuminateHighlight',
      callback = function() M.attach_bytes_highlight('undo_redo') end
    })
  end
end

function M.on_yank()
  vim.highlight.on_yank({
    higroup = config_module.config.yank.hlgroup,
    timeout = config_module.config.duration,
    namespace = config_module.namespaces.yank,
  })
end

function M.attach_bytes_highlight(event_type)
  config_module.config.should_detach = false
  api.nvim_buf_attach(0, false, {
    on_bytes = function(_, bufnr, changedtick, start_row, start_column, byte_offset, old_end_row, old_end_col,
                        old_end_byte, new_end_row, new_end_col, new_end_byte)
      highlight.on_bytes(event_type, bufnr, changedtick, start_row, start_column, byte_offset, old_end_row, old_end_col,
        old_end_byte, new_end_row, new_end_col, new_end_byte)
    end,
  })
end

return M
