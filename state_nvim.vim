if g:dein#_cache_version != 100 | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/home/kunitake-main/.config/nvim/init.vim'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/home/kunitake-main/.config/nvim'
let g:dein#_runtime_path = '/home/kunitake-main/.config/nvim/.cache/init.vim/.dein'
let g:dein#_cache_path = '/home/kunitake-main/.config/nvim/.cache/init.vim'
let &runtimepath = '/home/kunitake-main/.config/nvim,/etc/xdg/nvim,/home/kunitake-main/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/var/lib/snapd/desktop/nvim/site,/home/kunitake-main/.config/nvim/repos/github.com/Shougo/dein.vim,/home/kunitake-main/.config/nvim/.cache/init.vim/.dein,/usr/share/nvim/runtime,/home/kunitake-main/.config/nvim/.cache/init.vim/.dein/after,/var/lib/snapd/desktop/nvim/site/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/home/kunitake-main/.local/share/nvim/site/after,/etc/xdg/nvim/after,/home/kunitake-main/.config/nvim/after'
filetype off
