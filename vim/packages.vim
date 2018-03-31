let s:lockfile = $HOME . '/.vim/initial-packages-installed'
let s:need_initial_install = !filereadable(s:lockfile)

command! PackUpdate packadd minpac | source $MYVIMRC | redraw | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()

if !exists('*minpac#init') && !s:need_initial_install
  finish
endif

if s:need_initial_install
	packadd minpac
endif

call minpac#init()

call minpac#add('k-takata/minpac', {'type': 'opt'})

call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-sleuth')

call minpac#add('jlanzarotta/bufexplorer')
call minpac#add('kien/ctrlp.vim')
call minpac#add('nazo/pt.vim')

call minpac#add('jamessan/vim-gnupg')

call minpac#add('altercation/vim-colors-solarized')

call minpac#add('Shougo/deoplete.nvim')
call minpac#add('roxma/nvim-yarp')
call minpac#add('roxma/vim-hug-neovim-rpc')
call minpac#add('Shougo/neco-vim')

" call minpac#add('vim-syntastic/syntastic')
call minpac#add('w0rp/ale')

call minpac#add('rust-lang/rust.vim')
call minpac#add('racer-rust/vim-racer')

call minpac#add('fatih/vim-go')
call minpac#add('zchee/deoplete-go')

cal minpac#add('udalov/kotlin-vim')

if s:need_initial_install
	call minpac#update()
	call writefile([], s:lockfile)
endif
