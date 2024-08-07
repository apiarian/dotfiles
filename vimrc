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
	Plug 'guns/xterm-color-table.vim'
	Plug 'itchyny/vim-qfedit'
	Plug 'supercollider/scvim'

	Plug 'dense-analysis/ale'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'rhysd/vim-lsp-ale'
	Plug 'chrisbra/csv.vim'
	Plug 'vim-test/vim-test'

	Plug 'christoomey/vim-tmux-navigator'
call plug#end()


" to filter quickfix lists
packadd cfilter


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
set linebreak

set textwidth=79

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

" start with top-level folds open
set foldlevelstart=1

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

" system copy
vnoremap YY "+y

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
hi StatusLine term=bold,reverse ctermbg=22
hi StatusLineNC term=bold,reverse ctermbg=53
set statusline=%F%m%r%h%w\%=%y[L:\%l\ C:\%c\ A:\%b\ H:\x%02B\ P:\%p%%]
au InsertEnter * hi StatusLine term=bold cterm=bold ctermbg=9
au InsertLeave * hi StatusLine term=bold,reverse ctermbg=22

" show invisibles

set list
set listchars=tab:▸\ ,eol:¬

set colorcolumn=81

" line numbers
function! NumberToggle()
	if(&relativenumber == 1)
		set norelativenumber
		set nonumber
	else
		set relativenumber
		set number
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
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

function! CurrentSearch()
	let search_term = substitute(getreg("/"), "[\W\\<>]", "", "g")
	echo "searching for " . search_term
	execute ":Rg '" . l:search_term . "'"
endfunc
nmap <Leader>R :call CurrentSearch()<cr>

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

" pip install "python-lsp-server[all]"
" pip install pylsp-mypy
" pip install python-lsp-black
" pip install pyls-isort
if executable('pylsp')
	autocmd User lsp_setup call lsp#register_server({
				\	'name': 'pylsp',
				\	'cmd': ['pylsp'],
				\	'allowlist': ['python'],
				\	'workspace_config': {'pylsp': {'plugins': {
				\		'pylint': {'enabled': v:true},
				\		'rope_autoimport': {'enabled': v:false},
				\	}}},
				\	})
endif

if executable('typescript-language-server')
	autocmd User lsp_setup call lsp#register_server({
		\	'name': 'javascript and typescript-language-server',
		\	'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
		\	'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
		\	'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact', 'typescript', 'typescript.tsx', 'typescriptreact'],
		\	})
endif

if executable('rls')
	autocmd User lsp_setup call lsp#register_server({
		\ 'name': 'rls',
		\ 'cmd': { server_info->['rustup', 'run', 'stable', 'rls'] },
		\ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
		\ 'whitelist': ['rust'],
		\ })
endif

function! s:on_lsp_buffer_enabled() abort
	setlocal signcolumn=yes

	nmap <buffer> gD :rightbelow vertical LspDefinition<CR>
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	" nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> [g <plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g <plug>(lsp-next-diagnostic)
	nmap <buffer> K <plug>(lsp-hover)
	nmap <buffer> df <plug>(lsp-document-format)
	nmap <buffer> <leader>a <plug>(lsp-code-action)
	vmap <buffer> <leader>a :LspCodeAction<CR>
endfunction

augroup lsp_install
	au!
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

augroup lsp_folding
	au!
	au FileType python if line('$') < 100 | setlocal foldmethod=expr foldexpr=lsp#ui#vim#folding#foldexpr() foldtext=lsp#ui#vim#folding#foldtext() | endif
augroup end

let g:lsp_preview_float = 0
let g:lsp_completion_documentation_enabled = 0
let g:lsp_format_sync_timeout = 2000
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_signs_insert_mode_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_max_buffer_size = 10000000
let g:lsp_document_highlight_enabled = 0
let g:lsp_signature_help_enabled = 0
let g:lsp_hover_conceal = 0
let g:lsp_log_file = expand('~/vim-lsp.log')
" let g:lsp_log_file = ''

" python
set wildignore+='*.pyc'
let g:netrw_list_hide = ',^\.\.\=/\=$,\(^\|\s\s\)\zs\.\S\+,.*\.pyc$'

au FileType python setlocal formatoptions-=t

function! ImportSplit()
  :leftabove 10split
  :0
endfunction
nmap <leader>i :call ImportSplit() <CR>


let g:tmux_navigator_disable_when_zommed = 1

" json
au FileType json setlocal foldmethod=syntax

" snips
nmap <leader>s :call fzf#run({'dir': '~/snips', 'sink': '.-1r'})<CR>


nmap <silent> <leader>T :TestNearest<CR>

"
" flatiron
"

" flatiron repo
for repo in ["flatiron", "wario-workflows", "data-locator"]
  let s:repo_python = "/Users/apasechnik/code/" . repo . "*.py"
  for part in ["set colorcolumn=121 textwidth=120"]
    let s:full_command = "autocmd BufEnter,BufNewFile,BufRead " . s:repo_python . " " . part
    execute s:full_command
  endfor
endfor
autocmd BufEnter,BufNewFile,BufRead /Users/apasechnik/code/flatiron/*.py let test#python#pytest#executable = '/Users/apasechnik/code/flatiron/bin/pyte'
for repo in ["qreed", "academic-document-processing", "phabricator-read-only"]
  let s:repo_python = "/Users/apasechnik/code/" . repo . "/*.py"
  for part in ["set colorcolumn=89 textwidth=88"]
    let s:full_command = "autocmd BufEnter,BufNewFile,BufRead " . s:repo_python . " " . part
    execute s:full_command
  endfor
endfor

autocmd BufEnter,BufNewFile,BufRead /Users/apasechnik/code/flatiron/blocks/*.meta set ft=meta
