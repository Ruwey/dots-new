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
set termguicolors

"{%@@ if colorscheme == "Nord" @@%}"
" General
colorscheme nord

" Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'nord'

"{%@@ elif colorscheme == "Mntns" @@%}"
color mntns
"{%@@ endif @@%}"

" Color Highlighting
lua require 'colorizer'.setup(nil, {css = true })
"-- }}}

"-- Settings {{{
"------- Vim settings
" Relative Numbers
set relativenumber

" Disable word wrap
set nowrap

" Disable default insert text as lightline makes it redundant
set noshowmode

" Add Dynamic Title
set title
"{%@@ if colorscheme == "Nord" @@%}"
" Change Lightline Separator
let g:lightline.separator = { 'left': '', 'right': '' }
"{%@@ endif @@%}"

"-- Startify {{{
"let s:startify_header_text = [
"			\ ' ██       ██          ██                                     ',
"			\ '░██      ░██         ░██                                     ',
"			\ '░██   █  ░██  █████  ░██  █████   ██████  ██████████   █████ ',
"			\ '░██  ███ ░██ ██░░░██ ░██ ██░░░██ ██░░░░██░░██░░██░░██ ██░░░██',
"			\ '░██ ██░██░██░███████ ░██░██  ░░ ░██   ░██ ░██ ░██ ░██░███████',
"			\ '░████ ░░████░██░░░░  ░██░██   ██░██   ░██ ░██ ░██ ░██░██░░░░ ',
"			\ '░██░   ░░░██░░██████ ███░░█████ ░░██████  ███ ░██ ░██░░██████',
"			\ '░░       ░░  ░░░░░░ ░░░  ░░░░░   ░░░░░░  ░░░  ░░  ░░  ░░░░░░ ',
"			\ ]
let s:startify_header_text = [
			\ "  ____  __  __  _____   ",
			\ " /',__\\/\\ \\/\\ \\/\\ '__`\\ ",
			\ "/\\__, `\\ \\ \\_\\ \\ \\ \\L\\ \\",
			\ "\\/\\____/\\ \\____/\\ \\ ,__/",
			\ " \\/___/  \\/___/  \\ \\ \\/ ",
			\ "                  \\ \\_\\ ",
			\ "                   \\/_/ ",
			\ ]
let g:startify_custom_header = plugin#center(s:startify_header_text)
""}}}

" Get a diff between curent file and saved file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Automatically go to insert mode in the terminal
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" No numbers in terminal
au TermOpen * :setlocal norelativenumber

" Folding
set foldmethod=marker

" Mouse Controls
set mouse=a

" View nfo file correctly
autocmd BufReadPre *.nfo :setlocal fileencodings=cp437,utf-8

" Set two space for yaml
augroup yaml
	autocmd!
	autocmd FileType yaml set tabstop=2 shiftwidth=2
augroup END

augroup json
	autocmd!
	autocmd FileType json set tabstop=2 shiftwidth=2
augroup END

augroup lua
	autocmd!
	autocmd FileType lua set tabstop=4 shiftwidth=4
augroup END

" Startup
autocmd VimEnter *
	\ if !argc() 
	\ |	Startify "Open Startify
	\ | endif
"-- }}}

"-- Key bindings {{{
" Set leader key
let mapleader = " "

" Browse files
nnoremap <leader>. :Files <CR>

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

" Toggle Color Toggle
nnoremap <leader>ch :ColorHighlight<cr>

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

autocmd FileType vim :iabbrev <buffer> nnr nnoremap

"-- }}}
" vim:fileencoding=utf-8:foldmethod=marker
