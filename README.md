# diagnostic-filter.nvim

> A simple Neovim plugin to let you filter out diagnostics based on patterns.

## installation

### lazy.nvim

```lua
require("lazy").setup({
  "rayzr522/diagnostic-filter.nvim",
})
```

here's an example configuration with `eslint_d`'s "no configuration found" error suppressed (the whole reason i built this plugin lol):

```lua
require("lazy").setup({
  {
    "rayzr522/diagnostic-filter.nvim",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require('diagnostic-filter').setup({
        diagnostic_filters = {
          ["eslint_d"] = { "^Error: No ESLint configuration found in .*$" }
        }
      })
    end
  },
})
```
