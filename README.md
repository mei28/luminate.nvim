# luminate.nvim

🌟 Highlight yanked and pasted text in Neovim with a splash of color.

<!-- ![demo image here](path_to_demo_image.gif)  <!-- If you have a demo GIF --> 

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    'mei28/luminate.nvim',
    event = { 'TextYankPost' },
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
  timeout = 500,                     -- Duration of the highlight in milliseconds. Default is 500.
  ctermbg = 8,                       -- Terminal background color. Default is 8 (gray).
  guibg = "#ebcb8b",                 -- Background color for GUIs like Neovim-Qt or gVim. Default is "#ebcb8b".
  highlight_on_yank = true,          -- Whether to highlight on yank. Default is true.
  highlight_on_paste = true          -- Whether to highlight on paste. Default is true.
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
  higroup = "MyYankGroup",
  cterm = "red",
  guibg = "#FF0000"
})

```

### Enable/Disable Features:

```lua
require'luminate'.setup({
  highlight_on_yank = false,          -- Disable highlight on yank.
  highlight_on_paste = true           -- Enable highlight on paste.
})
```

## 📜 License
MIT
