-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_python_lsp = require("config.python").preferred_server()
vim.g.autoformat = true
vim.opt.winborder = "rounded"
