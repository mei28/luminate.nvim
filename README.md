# luminate.nvim

🌟 Highlight yanked, pasted, and undone/redone text in Neovim with a splash of color.

<img src="https://github.com/mei28/luminate.nvim/assets/51149822/59f58401-c137-431f-ae6e-9fc56fb1ed58" alt="luminate" width="800"/>

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    'mei28/luminate.nvim',
    event = { 'VeryLazy' },
    config = function()
        require'luminate'.setup({
            -- if you want to customize, see Usage!
        })
    end
}
```

## 🔧 Usage
Simply call the setup function in your Neovim configuration:

```lua
require'luminate'.setup({
  duration = 500,                     -- Duration of the highlight in milliseconds. Default is 500.
  yank = {
    hlgroup = "LuminateYank",         -- Highlight group for yanked text. Default is "LuminateYank".
    guibg = "#2d4f67",                -- Background color for GUIs. Default is "#2d4f67".
    fg = "#ebcb8b",                   -- Foreground color. Default is "#ebcb8b".
    enabled = true,                   -- Enable highlight on yank. Default is true.
  },
  paste = {
    hlgroup = "LuminatePaste",        -- Highlight group for pasted text. Default is "LuminatePaste".
    guibg = "#2d4f67",                -- Background color for GUIs. Default is "#2d4f67".
    fg = "#ebcb8b",                   -- Foreground color. Default is "#ebcb8b".
    HIGHLIGHT_THRESHOLD = 0.9,        -- Threshold for highlighting pasted text. Default is 0.9.
    enabled = true,                   -- Enable highlight on paste. Default is true.
  },
  undo = {
    hlgroup = "LuminateUndo",        -- Highlight group for undo. Default is "LuminateUndo".
    guibg = "#2d4f67",                -- Background color for GUIs. Default is "#2d4f67".
    fg = "#ebcb8b",                   -- Foreground color. Default is "#ebcb8b".
    HIGHLIGHT_THRESHOLD = 0.9,        -- Threshold for highlighting undone text. Default is 0.9.
    mode = 'n',                       -- Mode in which to map undo. Default is 'n' (normal mode).
    lhs = 'u',                        -- Keybinding for undo. Default is 'u'.
    map = 'undo',                     -- Command to execute for undo. Default is 'undo'.
    opts = {},                        -- Options for keymap. Default is {}.
    enabled = true,                   -- Enable highlight on undo. Default is true.
  },
  redo = {
    hlgroup = "LuminateRedo",        -- Highlight group for redo. Default is "LuminateRedo".
    guibg = "#2d4f67",                -- Background color for GUIs. Default is "#2d4f67".
    fg = "#ebcb8b",                   -- Foreground color. Default is "#ebcb8b".
    HIGHLIGHT_THRESHOLD = 0.9,        -- Threshold for highlighting redone text. Default is 0.9.
    mode = 'n',                       -- Mode in which to map redo. Default is 'n' (normal mode).
    lhs = '<C-r>',                    -- Keybinding for redo. Default is '<C-r>'.
    map = 'redo',                     -- Command to execute for redo. Default is 'redo'.
    opts = {},                        -- Options for keymap. Default is {}.
    enabled = true,                   -- Enable highlight on redo. Default is true.
  },
  highlight_for_count = true,         -- Highlight for count in undo/redo. Default is true.
})
```

## ✨ Customizing
### Custom Color:
If you'd like to use a custom color, you can define your own highlight group in Vimscript:

```vim
highlight MyYankGroup ctermbg=red guibg=#FF0000
```

Then, specify the custom group in the setup function:

```lua
require'luminate'.setup({
  yank = {
    hlgroup = "MyYankGroup",
    guibg = "#FF0000",
    fg = "red",
  }
})
```

### Enable/Disable Features:

```lua
require'luminate'.setup({
  yank = {
    enabled = false,          -- Disable highlight on yank.
  },
  paste = {
    enabled = true,           -- Enable highlight on paste.
  },
  undo = {
    enabled = true,           -- Enable highlight on undo.
  },
  redo = {
    enabled = true,           -- Enable highlight on redo.
  }
})
```

### ⚙️ Configuration Options

* duration: Time in milliseconds for the highlight to last.
* yank: Configuration for yank highlight.
    * hlgroup: The highlight group to use for yank.
    * guibg: Background color for GUIs.
    * fg: Foreground color.
    * enabled: Enable or disable yank highlight.
* paste: Configuration for paste highlight.
    * hlgroup: The highlight group to use for paste.
    * guibg: Background color for GUIs.
    * fg: Foreground color.
    * HIGHLIGHT_THRESHOLD: Skip highlight if pasted text exceeds this fraction of total lines.
    * enabled: Enable or disable paste highlight.
* undo: Configuration for undo highlight.
    * hlgroup: The highlight group to use for undo.
    * guibg: Background color for GUIs.
    * fg: Foreground color.
    * HIGHLIGHT_THRESHOLD: Skip highlight if undone text exceeds this fraction of total lines.
    * mode: Mode in which to map undo.
    * lhs: Keybinding for undo.
    * map: Command to execute for undo.
    * opts: Options for keymap.
    * enabled: Enable or disable undo highlight.
* redo: Configuration for redo highlight.
    * hlgroup: The highlight group to use for redo.
    * guibg: Background color for GUIs.
    * fg: Foreground color.
    * HIGHLIGHT_THRESHOLD: Skip highlight if redone text exceeds this fraction of total lines.
    * mode: Mode in which to map redo.
    * lhs: Keybinding for redo.
    * map: Command to execute for redo.
    * opts: Options for keymap.
    * enabled: Enable or disable redo highlight.
* highlight_for_count: Highlight for count in undo/redo.

## 📜 License
MIT

## 💡 Inspiration

This plugin was inspired by [highlight-undo.nvim](https://github.com/tzachar/highlight-undo.nvim).



