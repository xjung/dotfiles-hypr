--- Neovim entry point.
---
--- Load order matters: options define <leader> before any plugin spec is read,
--- and the colorscheme is applied before lazy.nvim starts plugins so that the
--- ones drawing chrome (bufferline, lualine) see the final palette.

require("config.options")
require("config.filetypes")

vim.cmd.colorscheme("dark-2026")

require("config.lazy")
require("config.keymaps")
require("config.autocmds")
