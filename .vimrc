set nocompatible          " We're running Vim, not Vi!
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype-specific indenting and plugins

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haskell,eruby,html,haml,yaml,lua,io set ai sw=2 sts=2 et
  autocmd FileType javascript set ai sw=4 sts=4 et
augroup END

augroup mkd
  autocmd FileType mkd set ai sw=2 sts=2 et formatoptions=tcroqn2 comments=n:>
augroup END

" Store temp files in a central location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set visualbell

" Remove menu bar
set guioptions-=m

" Remove toolbar
set guioptions-=T

" Bind JSLint to <F5> key.
map <F5> :JSLint<CR>
