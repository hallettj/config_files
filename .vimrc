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

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

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
  autocmd FileType mkd set ai sw=2 sts=2 et formatoptions=tcroqn2 comments=n:>
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
