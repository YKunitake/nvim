require("config.lazy")
require("config.nvim_treesitter")
require("config.lsp")

vim.g.python3_host_prog = '/usr/bin/python3'

--color
vim.cmd('colorscheme evening')

--encoding
vim.o.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
--visual
vim.o.syntax = 'on'
vim.o.number = true
vim.o.title = true
vim.o.ambiwidth = 'double'
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.hidden = true
vim.o.backspace = "indent,eol,start"
vim.o.termguicolors = true
vim.o.background = 'dark'
