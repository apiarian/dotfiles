let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	Plug 'apiarian/vim-colors-paramount'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-unimpaired'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-sleuth'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-vinegar'
	Plug 'tpope/vim-markdown'

	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'elzr/vim-json'
	Plug 'jremmen/vim-ripgrep'

	Plug 'vimwiki/vimwiki'
	Plug 'w0rp/ale'
	Plug 'chrisbra/csv.vim'

	Plug 'christoomey/vim-tmux-navigator'
	Plug 'HerringtonDarkholme/yats'
	Plug 'MaxMEllon/vim-jsx-pretty'
call plug#end()

set nocompatible

" all the plugin detection and stuff
filetype plugin indent on

" enable syntax in terminals which can display colors
if has('syntax') && (&t_Co > 2)
	syntax enable
	colorscheme paramount
	set background=dark
endif

" command line completion
set wildmode=list:longest,full
set wildignorecase

" where are we?
set showmode
set showcmd

" indentation controls
set shiftwidth=2
set tabstop=2
set softtabstop=2
set noexpandtab
set shiftround
set autoindent
set smartindent

" don't reformat text automatically
set formatoptions-=t

" spelling
set spelllang=en_us

" reload files edited externally automatically
set autoread

" highlight search stuff and highlight as you type
set hlsearch
set incsearch

" highlight current line
set cursorline

" hidden buffers hang around
set hidden

" split in the right direction
set splitbelow
set splitright

" completion
set completeopt=menuone,noinsert,noselect,preview

" handy bindings
"

" space to toggle folds
nmap <Space> za

" Y to yank to the end of the line from the cursor
map Y y%

" let backspace span lines
set backspace=2

" better movement
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" search next and center
nnoremap n nzz
nnoremap N Nzz

" quick escape
inoremap jk <Esc>

" enable mouse
set mouse=a
if &term =~ '^screen'
	" tmux knows the extended mode mouse
	set ttymouse=xterm2
endif

" fix the mouse on wide displays
if has("mouse_sgr")
	set ttymouse=sgr
else
	set ttymouse=xterm2
end

" tmux navigator tweaks
let g:tmux_navigator_disable_when_zoomed = 1

" append a comma
nnoremap ,, A,<Esc>

"
" interface improvements
"

" vertically resize window when it's just one line high, toggles between
" fullscreen windows
function! ToggleWindowSize()
	if winheight(0) == 1
		resize
	endif
	if winwidth(0) == 1
		vertical resize
	endif
endfunction
autocmd WinEnter * :call ToggleWindowSize()

" status line
set laststatus=2
set statusline=%F%m%r%h%w\%=%y[L:\%l\ C:\%c\ A:\%b\ H:\x%02B\ P:\%p%%]
au InsertEnter * hi StatusLine term=bold cterm=bold ctermbg=9
au InsertLeave * hi StatusLine term=bold,reverse ctermbg=236

" show invisibles

set list
set listchars=tab:▸\ ,eol:¬

" line numbers
function! NumberToggle()
	if(&relativenumber == 1)
		set norelativenumber
	else
		set relativenumber
	endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>
set numberwidth=2

" Save temporary/backup files not in the local directory, but in your ~/.vim
" directory, to keep them out of git repos. 
" But first mkdir backup, swap, and undo first to make this work
call system('mkdir ~/.vim')
call system('mkdir ~/.vim/backup')
call system('mkdir ~/.vim/swap')
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
	call system('mkdir ~/.vim/undo')
	set undodir=~/.vim/undo//
	set undofile
	set undolevels=1000
	set undoreload=10000
endif

" fzf stuff
nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>r :Tags<CR>

" ALE
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title
nmap ]w :ALENextWrap<CR>
nmap [w :ALEPreviousWrap<CR>
nmap <Leader>f <Plug>(ale_fix)
augroup VimDiff
  autocmd!
  autocmd VimEnter,FilterWritePre * if &diff | ALEDisable | endif
augroup END
let g:ale_fixers = {'python': ['isort']}

set wildignore+='*.pyc'
let g:netrw_list_hide = ',^\.\.\=/\=$,\(^\|\s\s\)\zs\.\S\+,.*\.pyc$'

let g:vimwiki_list = [{'path': '~/notes', 'syntax': 'default', 'ext': '.md'}]

function! ImportSplit()
  :leftabove 10split
  :0
endfunction
nmap <leader>i :call ImportSplit() <CR>

let g:tmux_navigator_disable_when_zommed = 1

"
" flatiron
"

let g:ale_virtualenv_dir_names = ["env", "env3"]
let g:ale_virtualenv_dir_names = ["env3", "env"]

" flatiron repo
for repo in ["flatiron", "wario-workflows", "data-locator"]
  let s:repo_python = "/Users/apasechnik/code/" . repo . "*.py"
  for part in ["let b:ale_python_flake8_options = '--max-line-length=120'", "set colorcolumn=121 textwidth=120", "let g:black_linelength = 120"]
    let s:full_command = "autocmd BufEnter,BufNewFile,BufRead " . s:repo_python . " " . part
    execute s:full_command
  endfor
endfor
autocmd BufEnter,BufNewFile,BufRead /Users/apasechnik/code/flatiron/*.py let test#python#pytest#executable = '/Users/apasechnik/code/flatiron/bin/pyte'
for repo in ["qreed", "academic-document-processing"]
  let s:repo_python = "/Users/apasechnik/code/" . repo . "/*.py"
  for part in ["let b:ale_python_flake8_options = '--max-line-length=88'", "set colorcolumn=89 textwidth=88", "let g:black_linelength=88"]
    let s:full_command = "autocmd BufEnter,BufNewFile,BufRead " . s:repo_python . " " . part
    execute s:full_command
  endfor
endfor

autocmd BufEnter,BufNewFile,BufRead /Users/apasechnik/code/flatiron/blocks/*.meta set ft=meta
