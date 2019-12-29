			"""""""""""""""""""""""""""""
			" ██      ██ ██             "
			"░██     ░██░░              "
			"░██     ░██ ██ ██████████  "
			"░░██    ██ ░██░░██░░██░░██ "
			" ░░██  ██  ░██ ░██ ░██ ░██ "
			"  ░░████   ░██ ░██ ░██ ░██ "
			"   ░░██    ░██ ███ ░██ ░██ "
			"    ░░     ░░ ░░░  ░░  ░░  "
			"			    "
			"            R C	    "
			"""""""""""""""""""""""""""""
" -- Dein {{{
call plugin#dein_init('/home/ruwey/.config/nvim/plugins.yaml')
"}}}

"-- Color scheme {{{
" General
colorscheme nord

" Set a working highlight for spellcheck
hi clear SpellBad 
hi SpellBad cterm=underline ctermfg=9

" Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'nord'
"-- }}}

"-- Settings {{{
"------- Vim settings
" Relative Numbers
set relativenumber

" Disable word wrap
set nowrap

" Disable default insert text as lightline makes it redundant
set noshowmode

" Change Lightline Separator
let g:lightline.separator = { 'left': '', 'right': '' }

"-- Startify {{{
let g:startify_custom_header = [
			\ '	 ██       ██          ██                                     ',
			\ '	░██      ░██         ░██                                     ',
			\ '	░██   █  ░██  █████  ░██  █████   ██████  ██████████   █████ ',
			\ '	░██  ███ ░██ ██░░░██ ░██ ██░░░██ ██░░░░██░░██░░██░░██ ██░░░██',
			\ '	░██ ██░██░██░███████ ░██░██  ░░ ░██   ░██ ░██ ░██ ░██░███████',
			\ '	░████ ░░████░██░░░░  ░██░██   ██░██   ░██ ░██ ░██ ░██░██░░░░ ',
			\ '	░██░   ░░░██░░██████ ███░░█████ ░░██████  ███ ░██ ░██░░██████',
			\ '	░░       ░░  ░░░░░░ ░░░  ░░░░░   ░░░░░░  ░░░  ░░  ░░  ░░░░░░ ',
			\ ]
" }}}

" Get a diff between curent file and saved file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Automaticaly go to insert mode in the terminal
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" No numbers in terminal
au TermOpen * :setlocal norelativenumber

" Folding
set foldmethod=marker

" View nfo file correctly
autocmd BufReadPre *.nfo :setlocal fileencodings=cp437,utf-8

"-- }}}

"-- Key bindings {{{
" Set leader key
let mapleader = ","

" Open vimrc in a split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Refresh vimrc
nnoremap <leader>rv :source $MYVIMRC<cr>

" Toggle spell check
nnoremap <leader>sp :set spell!<cr>

" Toggle relative numbers
nnoremap <leader>rn :set relativenumber!<cr>

" Toggle numbers
nnoremap <leader>nn :set number!<cr>

" Toggle word wrap
nnoremap <leader>ww :set wrap!<cr>

" Resize bindings
noremap <leader>= :vertical resize +5<cr>
noremap <leader>- :vertical resize -5<cr>
noremap <leader>+ :resize +5<cr>
noremap <leader>_ :resize -5<cr>

" Open a NEW TERMINAL
nnoremap <leader>nt :split<cr> :terminal<cr>
nnoremap <leader>vnt :vsplit<cr> :terminal<cr>

" Map ctrl + vim keys to move panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Who want to press esc
inoremap jk <esc>
inoremap <esc> <nop>

" Bind Copy to + register
vnoremap <C-y> "+y

" Bind paste to + register
map <C-p> "+p

" Exit terminal mode with esc
tnoremap <Esc> <C-\><C-n>

" Do the same but in the term
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" Coc
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
let g:coc_snippet_next = '<C-Space>'

"------- Abbreviations
" Make <ld> go to <leader>
iabbrev ld leader

iabbrev @@ ruwey<cr>gd@ruwey.com
autocmd FileType vim :iabbrev <buffer> nnr nnoremap

"-- }}}
" vim:fileencoding=utf-8:foldmethod=marker
