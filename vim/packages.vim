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
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-vinegar')
call minpac#add('tpope/vim-markdown')

call minpac#add('vim-scripts/BufOnly.vim')

call minpac#add('Raimondi/delimitMate')

call minpac#add('matze/vim-move')
call minpac#add('wesQ3/vim-windowswap')

call minpac#add('terryma/vim-smooth-scroll')

" navigation
call minpac#add('jlanzarotta/bufexplorer')
call minpac#add('Konfekt/FastFold')
call minpac#add('jremmen/vim-ripgrep')

" there's also an extra step in the vimrc file for fzf
call minpac#add('junegunn/fzf.vim')

call minpac#add('jamessan/vim-gnupg')

" colors
call minpac#add('altercation/vim-colors-solarized')
call minpac#add('morhetz/gruvbox')
call minpac#add('apiarian/vim-colors-paramount')
call minpac#add('andreasvc/vim-256noir')

" call minpac#add('maralla/completor.vim')

call minpac#add('w0rp/ale')
call minpac#add('janko/vim-test')

" life planning

call minpac#add('dbeniamine/todo.txt-vim')

" rust
call minpac#add('rust-lang/rust.vim')
call minpac#add('racer-rust/vim-racer')

" go
call minpac#add('fatih/vim-go')
" call minpac#add('garyburd/go-explorer')

call minpac#add('udalov/kotlin-vim')

call minpac#add('christoomey/vim-tmux-navigator')

call minpac#add('elzr/vim-json')

call minpac#add('mtth/scratch.vim')

" clojure
call minpac#add('tpope/vim-sexp-mappings-for-regular-people')
call minpac#add('guns/vim-sexp')
call minpac#add('guns/vim-clojure-static')
call minpac#add('guns/vim-clojure-highlight')
call minpac#add('tpope/vim-fireplace')
call minpac#add('tpope/vim-salve')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-dispatch')
call minpac#add('venantius/vim-cljfmt')

" python
call minpac#add('davidhalter/jedi-vim')
call minpac#add('python/black')
call minpac#add('tmhedberg/SimpylFold')

" csv
call minpac#add('chrisbra/csv.vim')

" yaml
call minpac#add('pedrohdz/vim-yaml-folds')

if s:need_initial_install
	call minpac#update()
	call writefile([], s:lockfile)
endif
