local api = vim.api
local highlight = require('luminate.highlight')
local M = {}

function M.open_folds_on_undo()
  if vim.tbl_contains(vim.opt.foldopen:get(), "undo") then
    vim.cmd.normal({ "zv", bang = true })
  end
end

function M.highlight_action(config_module, event_type, command)
  config_module.config.current_hlgroup = config_module.config[event_type].hlgroup
  config_module.config.should_detach = false

  api.nvim_buf_attach(0, false, {
    on_bytes = function(_, bufnr, changedtick, start_row, start_column, byte_offset, old_end_row, old_end_col,
                        old_end_byte, new_end_row, new_end_col, new_end_byte)
      highlight.on_bytes(event_type, bufnr, changedtick, start_row, start_column, byte_offset, old_end_row, old_end_col,
        old_end_byte, new_end_row, new_end_col, new_end_byte)
    end,
  })

  if config_module.config.highlight_for_count then
    for _ = 1, vim.v.count1 do
      command()
    end
  else
    command()
  end

  config_module.config.should_detach = true
end

return M

