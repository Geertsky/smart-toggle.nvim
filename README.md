# Smart Toggle

A minimal, context-aware Neovim plugin that extends the `~` key to smartly toggle common values such as:

- Booleans: `true ⇄ false`, `on ⇄ off`, `yes ⇄ no` (all case variants)
- Quotes: `' ⇄ "`
- Operators: `+ ⇄ -`

Supports both **Normal** and **Visual** modes.

## ✨ Features

- 🧠 Context-aware toggle under the cursor
- 📚 Visual mode support — toggles all matching items in the selection
- 🛠 Simple and dependency-free
- 🐢 Lazy-loadable with [lazy.nvim](https://github.com/folke/lazy.nvim)

## 🔧 Installation

### With [lazy.nvim](https://github.com/folke/lazy.nvim)

```
{
  "Geertsky/smart-toggle.nvim",
  config = function()
    require("smart_toggle").setup()
  end,
}
```
