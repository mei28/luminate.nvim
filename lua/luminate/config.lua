local api = vim.api

local config = {
  duration = 500,
  timer = (vim.uv or vim.loop).new_timer(),
  should_detach = true,
  current_hlgroup = nil,
  highlight_threshold = 0.9,
  yank = {
    hlgroup = "LuminateYank",
    guibg = '#2d4f67',
    fg = '#ebcb8b',
    enabled = true,
  },
  paste = {
    hlgroup = "LuminatePaste",
    guibg = '#2d4f67',
    fg = '#ebcb8b',
    enabled = true,
    mode = 'n',
    lhs = { 'p', 'P' },
    map = { p = 'p', P = 'P' },
    opts = {},
  },
  undo = {
    hlgroup = 'LuminateUndo',
    guibg = '#2d4f67',
    fg = '#ebcb8b',
    enabled = true,
    mode = 'n',
    lhs = { 'u', 'U' },
    map = { u = 'u', U = 'U' },
    opts = {},
  },
  redo = {
    hlgroup = 'LuminateRedo',
    guibg = '#2d4f67',
    fg = '#ebcb8b',
    enabled = true,
    mode = 'n',
    lhs = { '<C-r>' },
    map = '<C-r>',
    opts = {},
  },
  highlight_for_count = true,
}

local namespaces = {
  yank = api.nvim_create_namespace('LuminateYankHighlight'),
  paste = api.nvim_create_namespace('LuminatePasteHighlight'),
  undo = api.nvim_create_namespace('LuminateUndoHighlight'),
  redo = api.nvim_create_namespace('LuminateRedoHighlight'),
}

return {
  config = config,
  namespaces = namespaces,
}
