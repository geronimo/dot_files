call pathogen#infect()

set nocompatible          " We're running Vim, not Vi!
filetype off
set number

set undofile
set undodir=~/.vim/undodir

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

augroup myfiletypes
	" Clear old autocmds in group
	autocmd!
	" autoindent with two spaces, always expand tabs
	autocmd FileType ruby,eruby,yaml,javascript set ai sw=2 sts=2 et
	autocmd FileType python,html set ai sw=4 sts=4 et
	autocmd FileType cpp set ai sw=4 sts=4 et

	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

syntax enable
colorscheme vibrantink

" Display long lines as just one line
set nowrap

let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1
nmap <silent> <Leader>p :NERDTreeToggle<CR>

" Run Ack fast
nnoremap <leader>a :Ack<Space>

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar

" Show invisible characters
set list
set listchars=tab:▸\ ,eol:¬

" Disable the arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

nnoremap ; :

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Remove tailing spaces
" nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
autocmd BufWritePre .py,.rb  :%s/\s\+$//e

" Move among splited windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set so=7 " Set 7 lines to the cursor when moving vertical

map <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

au BufRead,BufNewFile *.handlebars,*.hbs set ft=html syntax=handlebars

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'christoomey/vim-tmux-navigator'
filetype plugin indent on " Enable filetype-specific indenting and plugins

set clipboard=unnamed

set backspace=indent,eol,start

let g:ackprg = 'ag --nogroup --nocolor --column'

function ShowSpaces(...)
	let @/='\v(\s+$)|( +\ze\t)'
	let oldhlsearch=&hlsearch
	if !a:0
		let &hlsearch=!&hlsearch
	else
		let &hlsearch=a:1
	end
	return oldhlsearch
endfunction

function TrimSpaces() range
	let oldhlsearch=ShowSpaces(1)
	execute a:firstline.",".a:lastline."substitute ///gec"
	let &hlsearch=oldhlsearch
endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
nnoremap <F12>     :ShowSpaces 1<CR>
nnoremap <S-F12>   m`:TrimSpaces<CR>``
vnoremap <S-F12>   :TrimSpaces<CR>
