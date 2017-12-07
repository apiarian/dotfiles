command! PackUpdate packadd minpac | source $MYVIMRC | redraw | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()

if !exists('*minpac#init')
  finish
endif

call minpac#init()

call minpac#add('k-takata/minpac', {'type': 'opt'})

call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-surround')

call minpac#add('jlanzarotta/bufexplorer')
call minpac#add('kien/ctrlp.vim')
call minpac#add('nazo/pt.vim')

call minpac#add('jamessan/vim-gnupg')

call minpac#add('altercation/vim-colors-solarized')

call minpac#add('Shougo/deoplete.nvim')
call minpac#add('roxma/nvim-yarp')
call minpac#add('roxma/vim-hug-neovim-rpc')
call minpac#add('Shougo/neco-vim')
