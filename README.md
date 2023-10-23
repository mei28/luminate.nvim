# luminate.nvim

🌟 Highlight yanked text in Neovim with a splash of color.

<!-- ![demo image here](path_to_demo_image.gif)  <!-- If you have a demo GIF --> 

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    'mei28/luminate.nvim',
    event = 'VeryLazy',
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
  timeout = 500,            -- Duration of the highlight in milliseconds. Default is 500.
  ctermbg = "lightyellow",  -- Background color for terminals. Default is "lightyellow".
  guibg = "#FFFFE0"         -- Background color for GUIs like Neovim-Qt or gVim. Default is "#FFFFE0".
})
```

## ✨ Customizing
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

## 📜 License
MIT
