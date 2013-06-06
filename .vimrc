set nocompatible          " We're running Vim, not Vi!

" Needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins

" Map <Leader> to , key
let mapleader = ","

" Default tab options
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set hidden
set wildmode=longest
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2

" Make searches case-sensitive only when capital letters are included.
set ignorecase
set smartcase

" Make searching more interactive.
set incsearch

" Wrap long lines
set wrap
set textwidth=72
set formatoptions=cqrn1

" Displays visible characters for tab and end-of-line characters.
set list
set listchars=tab:▸\ ,eol:¬

" Store temp files in a central location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" NERD Commenter preferences
let NERDSpaceDelims = 1
let NERD_ftl_alt_style=1
let NERDCustomDelimiters = {
    \ 'ftl': { 'leftAlt': '<#--', 'rightAlt': '-->' }
\ }

" Customizations for Command-T
let g:CommandTMaxFiles = 30000
set wildignore+=**/target,*.class,*.jar,*.o,*.hi


" Customizations for Unite
" copied from https://github.com/bling/dotvim/blob/master/vimrc
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#set_profile('files', 'smartcase', 1)

let g:unite_data_directory='~/.vim/.cache/unite'
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_source_file_rec_max_cache_files=5000
let g:unite_prompt='» '

function! s:unite_settings()
  nmap <buffer> Q <plug>(unite_exit)
  nmap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <esc> <plug>(unite_exit)
endfunction
autocmd FileType unite call s:unite_settings()

nmap <space> [unite]
nnoremap [unite] <nop>

nnoremap <silent> [unite]<space> :<C-u>Unite -resume -auto-resize -buffer-name=mixed file_rec/async buffer file_mru bookmark<cr>
nnoremap <silent> [unite]f :<C-u>Unite -resume -auto-resize -buffer-name=files file_rec/async<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -auto-resize -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline -vertical -winwidth=35 outline<cr>
nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>


if has('gui_running')
  " Remove menu bar, toolbar, and scrollbars
  set guioptions+=mTLlRrb
  set guioptions-=mTLlRrb

  set guifont=Ubuntu\ Mono\ 12
endif

colorscheme desert

" Set color for end-of-line characters for desert theme.
highlight NonText guibg=grey20 guifg=grey30
" Set color for tab characters for desert theme.
highlight SpecialKey guibg=grey20 guifg=grey30

" Automatically save when the window loses focus or when a buffer is
" hidden.
set autowriteall
au FocusLost * wall

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!

  " When working with certain programming languages I want to indent
  " with 2 spaces instead of 4.
  autocmd FileType cabal,coffee,ruby,python,eruby,haml,yaml,lua,io,scala setlocal sw=2 sts=2

  " Use hard tabs with these file types.
  autocmd FileType snippet,gitconfig setlocal noexpandtab

  au BufRead,BufNewFile *.ftl setfiletype ftl.html
  au BufRead,BufNewFile *.soy setfiletype soy.html

  au BufRead,BufNewFile *.md setfiletype markdown
  autocmd FileType markdown setlocal comments=n:>
  autocmd FileType mkd      setlocal comments=n:>
augroup END

" statusline
" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" format markers:
"   %< truncation point
"   %n buffer number
"   %f relative path to file
"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
"   %r readonly flag [RO]
"   %y filetype [ruby]
"   %= split point for left and right justification
"   %-35. width specification
"   %l current line number
"   %L number of lines in buffer
"   %c current column number
"   %V current virtual column number (-n), if different from %c
"   %P percentage through buffer
"   %) end of width specification
set statusline=%<\ %n:%f\ %m%r%y%=%{fugitive#statusline()}\ %-35.(line:\ %l\ of\ %L,\ col:\ %c\ (%P)%)

" Load matchit to bounce between do and end in Ruby and between opening
" and closing tags in HTML.
if has('gui_running')
    runtime! macros/matchit.vim
else
    set noshowmatch
    let loaded_matchparen = 1  " Prevents DoMatchParen plugin from loading.
endif

" I don't want code to be folded when I open a file.
set nofoldenable

" Bounce between bracket pairs with the <tab> key.
nnoremap <tab> %
vnoremap <tab> %

" Shortcuts for Fugitive commands.
nnoremap <Leader>gs :Gstatus<cr>
vnoremap <Leader>gs :Gstatus<cr>

" Run slime.vim sessions in tmux
let g:slime_target = "tmux"

" Syntastic config
let g:syntastic_enable_signs=0
nnoremap <Leader>e :SyntasticCheck<cr>:Errors<cr>
vnoremap <Leader>e :SyntasticCheck<cr>:Errors<cr>

"" Shortcut to open Tagbar
"nnoremap <silent> <Leader>tt :TagbarOpen j<cr>
"vnoremap <silent> <Leader>tt :TagbarOpen j<cr>

" vim-coffee-script config
" Disable error highlighting on trailing spaces
hi link coffeeSpaceError None
