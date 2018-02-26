"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/em56032/.config/nvim/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/em56032/.config/nvim')
  call dein#begin('/home/em56032/.config/nvim')

  " Let dein manage dein
  " Required:
  call dein#add('/home/em56032/.config/nvim/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/deol.nvim', { 'rev': 'a1b5108fd' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
set number
set title
set ambiwidth=double
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent
set list
set nrformats-=octal
set hidden
set history=50
set virtualedit=block
set backspace=indent,eol,start
