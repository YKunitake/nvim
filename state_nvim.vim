if g:dein#_cache_version != 100 | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/home/em56032/.config/nvim/init.vim'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/home/em56032/.config/nvim'
let g:dein#_runtime_path = '/home/em56032/.config/nvim/.cache/init.vim/.dein'
let g:dein#_cache_path = '/home/em56032/.config/nvim/.cache/init.vim'
let &runtimepath = '/home/em56032/.config/nvim,/etc/xdg/nvim,/home/em56032/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/var/lib/snapd/desktop/nvim/site,/home/em56032/.config/nvim/repos/github.com/Shougo/dein.vim,/home/em56032/.config/nvim/.cache/init.vim/.dein,/usr/share/nvim/runtime,/home/em56032/.config/nvim/.cache/init.vim/.dein/after,/var/lib/snapd/desktop/nvim/site/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/em56032/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/em56032/.config/nvim/after'
filetype off
