local M = {}

M.config = {
  higroup = "LuminateYank",
  timeout = 500,
  ctermbg = 8,
  guibg = "#ebcb8b",
  highlight_on_yank = true,
  highlight_on_paste = true
}


M.setup = function(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  vim.cmd(string.format('highlight %s ctermbg=%s guibg=%s', M.config.higroup, M.config.ctermbg, M.config.guibg))

  vim.cmd('augroup LuminateHighlight')
  vim.cmd('autocmd!')
  if M.config.highlight_on_yank then
    vim.cmd("autocmd TextYankPost * lua require'luminate'.on_yank()")
  end
  if M.config.highlight_on_paste then
    vim.cmd("autocmd TextChanged * lua require'luminate'.on_paste()")
  end
  vim.cmd('augroup END')
end

M.on_yank = function()
  vim.highlight.on_yank({ higroup = M.config.higroup, timeout = M.config.timeout })
end

M.on_paste = function()
  local start_line = vim.api.nvim_buf_get_mark(0, "[")[1]
  local end_line = vim.api.nvim_buf_get_mark(0, "]")[1]
  local start_col = vim.api.nvim_buf_get_mark(0, "[")[2]
  local end_col = vim.api.nvim_buf_get_mark(0, "]")[2]
  local ns_id = vim.api.nvim_create_namespace('LuminatePasteHighlight')

  vim.highlight.range(0, ns_id, M.config.higroup, { start_line - 1, start_col }, { end_line - 1, end_col })

  if M.config.timeout > 0 then
    vim.defer_fn(function()
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end, M.config.timeout)
  end
end

return M
