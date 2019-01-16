""dein Scripts-----------------------------
"let g:python3_host_prog = system('(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/$(pyenv global | grep python3)/bin/python") || o -n $(which python3)')
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=C:/Users/em56032/AppData/Local/nvim/repos/github.com/Shougo/dein.vim

"let s:dein_home_dir = expand('C:/Users/em56032/AppData/Local/nvim')
let s:dein_repo_dir = expand('C:/Users/em56032/AppData/Local/nvim/repos/github.com/Shougo/dein.vim')
"let s:toml_file = expand('C:/Users/em56032/AppData/Local/nvim/dein.tom')

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

if dein#load_state(s:dein_repo_dir)
  call dein#begin(s:dein_repo_dir)

 " Let dein manage dein
 " Required:
  call dein#add(s:dein_repo_dir)

 " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

 " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', {'rev': '3787e5'})

 " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on 
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
" 色付け
colorscheme evening
syntax on
" 行番号を表示
set number
set title
set ambiwidth=double
" インデントを自動で合わせてくれる
set autoindent
" タブをスペース4つ分の大きさにする
set expandtab
set tabstop=4
set shiftwidth=4
" ~.swpファイルを作らない
set noswapfile
set hidden
set backspace=indent,eol,start
set virtualedit=block
set t_Co=256
set termguicolors
set background=dark
" レジスタではなくクリップボードを使用
"set clipboard=unnamed,autoselect
