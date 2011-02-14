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

" Use standard regular expressions when searching.
nnoremap / /\v
vnoremap / /\v

" Make searches case-sensitive only when capital letters are included.
set ignorecase
set smartcase

" Make searching more interactive.
set incsearch

" Bounce between bracket pairs with the <tab> key.
nnoremap <tab> %
vnoremap <tab> %

" Wrap long lines
set wrap
set textwidth=79
set formatoptions=tcqrn1

" Displays visible characters for tab and end-of-line characters.
set list
set listchars=tab:▸\ ,eol:¬

" Automatically save when the window loses focus.
au FocusLost * :wa

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,python,haskell,eruby,haml,yaml,lua,io,scala set ai sw=2 sts=2 et
  autocmd FileType html,javascript,java,xml,dot set ai sw=4 sts=4 et

  au BufRead,BufNewFile *.ftl setfiletype ftl
  autocmd FileType ftl set syntax=html ai sw=4 sts=4 et
  au BufRead,BufNewFile *.soy setfiletype soy
  autocmd FileType soy set syntax=html ai sw=4 sts=4 et
  au BufRead,BufNewFile *.md setfiletype markdown
  autocmd FileType markdown set ai sw=4 sts=4 et
augroup END

augroup mkd
  autocmd FileType mkd set ai sw=2 sts=2 et comments=n:>
augroup END

" Store temp files in a central location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Remove menu bar
set guioptions-=m

" Remove toolbar
set guioptions-=T

" Bind JSLint to <F5> key.
map <F4> :JSLintLight<CR>
map <F5> :JSLint<CR>

colorscheme desert

" Set color for end-of-line characters for desert theme.
highlight NonText guibg=grey20 guifg=grey30
" Set color for tab characters for desert theme.
highlight SpecialKey guibg=grey20 guifg=grey30
