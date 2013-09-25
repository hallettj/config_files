set nocompatible          " We're running Vim, not Vi!

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

syntax on
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

" Highlights the given column.
set colorcolumn=80

" Store temp files in a central location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set wildignore+=**/target,*.class,*.jar,*.o,*.hi

if has('gui_running')
  " Remove menu bar, toolbar, and scrollbars
  set guioptions+=mTLlRrb
  set guioptions-=mTLlRrb

  set guifont=Ubuntu\ Mono\ 12
endif

" colorscheme desert

" " Set color for end-of-line characters for desert theme.
" highlight NonText guibg=grey20 guifg=grey30
" " Set color for tab characters for desert theme.
" highlight SpecialKey guibg=grey20 guifg=grey30
" highlight ColorColumn guibg=grey21 ctermbg=darkgray

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

" window manipulation
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
set splitbelow
set splitright

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    let curNum = winnr()            "Mark destination
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    let markedBuf = bufnr( "%" )    "Switch to source and shuffle dest->source
    exe 'hide buf' curBuf
    exe curNum . "wincmd w"
    exe 'hide buf' markedBuf
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>


" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim', { 'rev': 'master' }

" Recommended to install
NeoBundleDepends 'Shougo/vimproc', {
      \ 'build': {
        \ 'mac': 'make -f make_mac.mak',
        \ 'unix': 'make -f make_unix.mak',
        \ 'cygwin': 'make -f make_cygwin.mak',
        \ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe" make_msvc32.mak',
      \ },
    \ }

" Customizations for Unite
" copied from https://github.com/bling/dotvim/blob/master/vimrc
NeoBundle 'Shougo/unite.vim' "{{{
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
"}}}

NeoBundle 'kien/ctrlp.vim' "{{{
  let g:ctrlp_clear_cache_on_exit=1
  let g:ctrlp_max_height=40
  let g:ctrlp_show_hidden=0
  let g:ctrlp_follow_symlinks=1
  let g:ctrlp_working_path_mode=0
  let g:ctrlp_max_files=60000
  let g:ctrlp_cache_dir='~/.vim/.cache/ctrlp'
  nnoremap <silent> <leader>t :CtrlP<cr>
  nnoremap <silent> <leader>b :CtrlPBuffer<cr>
"}}}

NeoBundle 'tpope/vim-fugitive' "{{{
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gp :Git push<CR>
  nnoremap <silent> <leader>gw :Gwrite<CR>
  nnoremap <silent> <leader>gr :Gremove<CR>
  autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
  autocmd BufReadPost fugitive://* set bufhidden=delete
"}}}

NeoBundle 'scrooloose/nerdtree' "{{{
  let NERDTreeShowHidden=1
  let NERDTreeQuitOnOpen=0
  let NERDTreeShowLineNumbers=1
  let NERDTreeChDirMode=0
  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.git','\.hg']
  let NERDTreeBookmarksFile='~/.vim/.cache/NERDTreeBookmarks'
  nnoremap <silent> <leader>d :NERDTreeToggle<CR>
  nnoremap <silent> <leader>f :NERDTreeFind<CR>
"}}}

NeoBundle 'scrooloose/nerdcommenter' "{{{
  let NERDSpaceDelims = 1
  let NERD_ftl_alt_style=1
  let NERDCustomDelimiters = {
      \ 'ftl': { 'leftAlt': '<#--', 'rightAlt': '-->' }
  \ }
"}}}

NeoBundle 'scrooloose/syntastic' "{{{
  let g:syntastic_error_symbol = '✗'
  let g:syntastic_style_error_symbol = '✠'
  let g:syntastic_warning_symbol = '∆'
  let g:syntastic_style_warning_symbol = '≈'
  let g:syntastic_enable_signs=0
  nnoremap <Leader>e :SyntasticCheck<cr>:Errors<cr>
  vnoremap <Leader>e :SyntasticCheck<cr>:Errors<cr>
"}}}

NeoBundle 'majutsushi/tagbar', { 'depends': 'bitc/lushtags' } "{{{
  nnoremap <silent> <Leader>] :TagbarToggle<cr>
  vnoremap <silent> <Leader>] :TagbarToggle<cr>
"}}}

NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'IndentAnything'
NeoBundle 'pangloss/vim-javascript'

NeoBundle 'maksimr/vim-jsbeautify' "{{{
  nnoremap <leader>fjs :call JsBeautify()<cr>
"}}}

NeoBundle 'kchmck/vim-coffee-script' "{{{
  " Disable error highlighting on trailing spaces
  hi link coffeeSpaceError None
"}}}

NeoBundle 'jhenahan/idris-vim'

NeoBundle 'benmills/vimux'
NeoBundle 'jpalardy/vim-slime' "{{{
  " Run slime.vim sessions in tmux
  let g:slime_target = "tmux"
"}}}

NeoBundle 'sotte/presenting.vim'

NeoBundle 'altercation/vim-colors-solarized' "{{{
  set background=dark
  set t_Co=16
  let g:solarized_visibility="low" "Specifies contrast of invisibles.
  colorscheme solarized
"}}}

NeoBundle 'mileszs/ack.vim' "{{{
  nnoremap <silent> <leader>a :Ack<space>
"}}}

NeoBundle 'bling/vim-airline' "{{{
  set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12,Ubuntu\ Mono\ 12
  let g:airline_powerline_fonts = 1
  set noshowmode  " Mode is indicated in status line instead.
"}}}

" Installation check.
NeoBundleCheck
