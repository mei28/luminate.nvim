local api = vim.api
local config_module = require('luminate.config')
local namespaces = config_module.namespaces
local M = {}

function M.set_highlight(name, params)
  api.nvim_set_hl(0, name, params)
end

function M.on_bytes(event_type, bufnr, changedtick, start_row, start_column, byte_offset, old_end_row, old_end_col,
                    old_end_byte, new_end_row, new_end_col, new_end_byte)
  if config_module.config.should_detach or vim.fn.mode() == 'i' then
    return true
  end

  local event_config = config_module.config[event_type]
  local num_lines = api.nvim_buf_line_count(bufnr)
  local end_row = start_row + new_end_row
  local end_col = start_column + new_end_col

  if end_row >= num_lines then
    end_col = #api.nvim_buf_get_lines(bufnr, -2, -1, false)[1]
  end

  vim.schedule(function()
    if (end_row - start_row) / num_lines <= event_config.HIGHLIGHT_THRESHOLD then
      vim.highlight.range(
        bufnr,
        namespaces[event_type],
        event_config.hlgroup,
        { start_row, start_column },
        { end_row, end_col }
      )
      M.defer_clear_highlights(bufnr, namespaces[event_type])
    end
  end)
end

function M.defer_clear_highlights(bufnr, namespace)
  if not api.nvim_buf_is_valid(bufnr) then return end
  vim.defer_fn(function()
    api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
  end, config_module.config.duration)
end

return M
