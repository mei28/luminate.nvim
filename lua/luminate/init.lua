local M = {}

M.config = {
  higroup = "LuminateYank",
  timeout = 500,
  ctermbg = "lightyellow",
  guibg = "#FFFFE0"
}

M.setup = function(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  vim.cmd(string.format('highlight %s ctermbg=%s guibg=%s', M.config.higroup, M.config.ctermbg, M.config.guibg))

  vim.cmd([[
        augroup LuminateHighlight
            autocmd!
            autocmd TextYankPost * lua require'luminate'.on_yank()
        augroup END
    ]])
end

M.on_yank = function()
  vim.highlight.on_yank({ higroup = M.config.higroup, timeout = M.config.timeout })
end

return M
