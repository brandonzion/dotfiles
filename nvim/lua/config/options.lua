-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false -- no format on save; use <leader>cf to format manually
vim.opt.selection = "old" -- selections can't extend past end of line (keeps mouse drags from grabbing the newline)
