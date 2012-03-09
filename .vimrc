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
set wildignore+=target/java/**,*.class,*.jar

" Remove menu bar, toolbar, and scrollbars
set guioptions+=mTLlRrb
set guioptions-=mTLlRrb

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
  autocmd FileType coffee,ruby,python,haskell,eruby,haml,yaml,lua,io,scala set sw=2 sts=2

  " Use hard tabs with these file types.
  autocmd FileType snippet,gitconfig set noexpandtab

  au BufRead,BufNewFile *.ftl setfiletype ftl.html
  au BufRead,BufNewFile *.soy setfiletype soy.html

  au BufRead,BufNewFile *.md setfiletype markdown
  autocmd FileType markdown set comments=n:>
  autocmd FileType mkd set comments=n:>
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
runtime! macros/matchit.vim

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

" vim-coffee-script config
" Disable error highlighting on trailing spaces
hi link coffeeSpaceError None
