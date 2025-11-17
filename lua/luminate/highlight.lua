local api = vim.api
local config_module = require('luminate.config')
local namespaces = config_module.namespaces
local M = {}


function M.set_highlight(name, params)
  api.nvim_set_hl(0, name, params)
end

function M.on_bytes(event_type, bufnr, changedtick, start_row, start_column, byte_offset, old_end_row, old_end_col,
                    old_end_byte, new_end_row, new_end_col, new_end_byte)
  -- Removed should_detach check (managed locally in actions.lua)
  -- Removed mode check (assumed to be called from keymap)

  -- Validate buffer
  if not api.nvim_buf_is_valid(bufnr) then
    return true
  end

  local event_config = config_module.config[event_type]
  if not event_config then
    vim.notify(
      string.format('Luminate: Unknown event type: %s', event_type),
      vim.log.levels.ERROR
    )
    return true
  end

  local ok, num_lines = pcall(api.nvim_buf_line_count, bufnr)
  if not ok or num_lines == 0 then
    return true
  end

  local end_row = start_row + new_end_row
  local end_col = start_column + new_end_col

  -- Handle range exceeding last line
  if end_row >= num_lines then
    local ok_lines, lines = pcall(api.nvim_buf_get_lines, bufnr, -2, -1, false)
    if ok_lines and lines[1] then
      end_col = #lines[1]
    else
      return true
    end
  end

  -- Threshold check: skip if changed range exceeds threshold percentage of buffer
  if (end_row - start_row) / num_lines >= config_module.config.highlight_threshold then
    return true
  end

  vim.schedule(function()
    -- Protect highlight operation with pcall
    local ok_hl, err = pcall(vim.highlight.range,
      bufnr,
      namespaces[event_type],
      event_config.hlgroup,
      { start_row, start_column },
      { end_row, end_col }
    )

    if not ok_hl then
      vim.notify(
        string.format('Luminate: Failed to highlight range: %s', tostring(err)),
        vim.log.levels.WARN
      )
      return
    end

    M.defer_clear_highlights(bufnr, namespaces[event_type])
  end)
end

function M.defer_clear_highlights(bufnr, namespace)
  if not api.nvim_buf_is_valid(bufnr) then return end
  vim.defer_fn(function()
    api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
  end, config_module.config.duration)
end

return M
