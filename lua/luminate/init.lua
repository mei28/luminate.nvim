local api = vim.api

local M = {
  config = {
    duration = 500,
    timer = (vim.uv or vim.loop).new_timer(),
    should_detach = true,
    current_hlgroup = nil,
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
      HIGHLIGHT_THRESHOLD = 0.9,
      enabled = true,
    },
    undo = {
      hlgroup = 'HighlightUndo',
      guibg = '#2d4f67',
      fg = '#ebcb8b',
      HIGHLIGHT_THRESHOLD = 0.9,
      mode = 'n',
      lhs = 'u',
      map = 'undo',
      opts = {},
    },
    redo = {
      hlgroup = 'HighlightRedo',
      guibg = '#2d4f67',
      fg = '#ebcb8b',
      HIGHLIGHT_THRESHOLD = 0.9,
      mode = 'n',
      lhs = '<C-r>',
      map = 'redo',
      opts = {},
    },
    highlight_for_count = true,
  },
  namespaces = {
    yank = api.nvim_create_namespace('LuminateYankHighlight'),
    paste = api.nvim_create_namespace('LuminatePasteHighlight'),
    undo = api.nvim_create_namespace('HighlightUndoNamespace'),
    redo = api.nvim_create_namespace('HighlightRedoNamespace'),
  },
}

local function set_highlight(name, params)
  api.nvim_set_hl(0, name, params)
end

-- setup autocmds
local function set_autocmds()
  api.nvim_create_augroup('LuminateHighlight', { clear = true })

  if M.config.yank.enabled then
    api.nvim_create_autocmd('TextYankPost', {
      group = 'LuminateHighlight',
      callback = function() M.on_yank() end
    })
  end

  if M.config.paste.enabled then
    api.nvim_create_autocmd('TextChanged', {
      group = 'LuminateHighlight',
      callback = function() M.attach_bytes_highlight('paste') end
    })
  end

  if M.config.undo.enabled or M.config.redo.enabled then
    api.nvim_create_autocmd('BufEnter', {
      group = 'LuminateHighlight',
      callback = function() M.attach_bytes_highlight('undo_redo') end
    })
  end
end

function M.on_bytes(event_type, bufnr, changedtick,
                    start_row, start_column,
                    byte_offset, old_end_row,
                    old_end_col, old_end_byte,
                    new_end_row, new_end_col, new_end_byte)
  if M.should_detach then
    return true
  end

  local config = M.config[event_type]
  local num_lines = api.nvim_buf_line_count(bufnr)
  local end_row = start_row + new_end_row
  local end_col = start_column + new_end_col

  if end_row >= num_lines then
    end_col = #api.nvim_buf_get_lines(bufnr, -2, -1, false)[1]
  end

  vim.schedule(function()
    if (end_row - start_row) / num_lines <= config.HIGHLIGHT_THRESHOLD then
      vim.highlight.range(
        bufnr,
        M.namespaces[event_type],
        config.hlgroup,
        { start_row, start_column },
        { end_row, end_col }
      )

      M.defer_clear_highlights(bufnr, M.namespaces[event_type])
    end
  end)
end

function M.attach_bytes_highlight(event_type)
  M.should_detach = false
  api.nvim_buf_attach(0, false, {
    on_bytes = function(ignored, bufnr, changedtick,
                        start_row, start_column,
                        byte_offset, old_end_row,
                        old_end_col, old_end_byte,
                        new_end_row, new_end_col, new_end_byte)
      M.on_bytes(event_type, bufnr, changedtick,
        start_row, start_column,
        byte_offset, old_end_row,
        old_end_col, old_end_byte,
        new_end_row, new_end_col, new_end_byte)
    end,
  })
end

-- highlight after yank
function M.on_yank()
  vim.highlight.on_yank({
    higroup = M.config.yank.hlgroup,
    timeout = M.config.duration,
    namespace = M.namespaces.yank,
  })
end

-- clear highlights
function M.defer_clear_highlights(bufnr, namespace)
  vim.defer_fn(function()
    api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
  end, M.config.duration)
end

-- original keymap
function M.call_original_kemap(map)
  if type(map) == 'string' then
    vim.cmd(map)
  elseif type(map) == 'function' then
    map()
  end
end

-- open fold when undo
local function open_folds_on_undo()
  if vim.tbl_contains(vim.opt.foldopen:get(), "undo") then
    vim.cmd.normal({ "zv", bang = true })
  end
end

-- initialize
function M.setup(config)
  M.config = vim.tbl_deep_extend('force', M.config, config or {})

  -- yank/paste/undo/redo highlight settings
  set_highlight(M.config.yank.hlgroup, {
    ctermbg = M.config.yank.ctermbg,
    bg = M.config.yank.guibg,
    fg = M.config.yank.fg,
  })

  set_highlight(M.config.paste.hlgroup, {
    ctermbg = M.config.paste.ctermbg,
    bg = M.config.paste.guibg,
    fg = M.config.paste.fg,
  })

  set_highlight(M.config.undo.hlgroup, {
    ctermbg = M.config.undo.ctermbg,
    bg = M.config.undo.guibg,
    fg = M.config.undo.fg,
  })

  set_highlight(M.config.redo.hlgroup, {
    ctermbg = M.config.redo.ctermbg,
    bg = M.config.redo.guibg,
    fg = M.config.redo.fg,
  })

  set_autocmds()

  -- undo/redo keymap
  local undo = M.config.undo
  vim.keymap.set(undo.mode, undo.lhs, function()
    if M.config.highlight_for_count or vim.v.count == 0 then
      M.highlight_undo_redo('undo', function()
        M.call_original_kemap(undo.map)
      end)
    else
      local keys = api.nvim_replace_termcodes(vim.v.count .. 'u', true, false, true)
      api.nvim_feedkeys(keys, 'n', false)
    end
    open_folds_on_undo()
  end, undo.opts)

  local redo = M.config.redo
  vim.keymap.set(redo.mode, redo.lhs, function()
    if M.config.highlight_for_count or vim.v.count == 0 then
      M.highlight_undo_redo('redo', function()
        M.call_original_kemap(redo.map)
      end)
    else
      local keys = api.nvim_replace_termcodes(vim.v.count .. '<C-r>', true, false, true)
      api.nvim_feedkeys(keys, 'n', false)
    end
    open_folds_on_undo()
  end, redo.opts)
end

-- undo/redo higlight
function M.highlight_undo_redo(event_type, command)
  M.current_hlgroup = M.config[event_type].hlgroup
  api.nvim_buf_attach(0, false, {
    on_bytes = function(ignored, bufnr, changedtick,
                        start_row, start_column,
                        byte_offset, old_end_row,
                        old_end_col, old_end_byte,
                        new_end_row, new_end_col, new_end_byte)
      M.on_bytes(event_type, bufnr, changedtick,
        start_row, start_column,
        byte_offset, old_end_row,
        old_end_col, old_end_byte,
        new_end_row, new_end_col, new_end_byte)
    end,
  })
  M.should_detach = false

  if M.config.highlight_for_count then
    for _ = 1, vim.v.count1 do
      command()
    end
  else
    command()
  end

  M.should_detach = true
end

return M
