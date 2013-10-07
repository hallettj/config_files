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

" Fixes H and L movements for use with scrolloff
execute 'nnoremap H H'.&l:scrolloff.'k'
execute 'vnoremap H H'.&l:scrolloff.'k'
execute 'nnoremap L L'.&l:scrolloff.'j'
execute 'vnoremap L L'.&l:scrolloff.'j'

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

  " Overridden in airline customization
  set guifont=Ubuntu\ Mono\ 12
endif

" Automatically save when the window loses focus or when a buffer is
" hidden.
set autowriteall
au FocusLost * silent! wall

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  au BufRead,BufNewFile *.ftl setfiletype ftl.html
  au BufRead,BufNewFile *.soy setfiletype soy.html
augroup END

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
nnoremap <C-\> <C-W>p

" Swaps ' and `
nnoremap ' `
vnoremap ' `
nnoremap ` '
vnoremap ` '

" Retains selection in visual mode when indenting blocks
vnoremap < <gv
vnoremap > >gv

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

" Write file as root
cnoremap w!! w !sudo tee % >/dev/null


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
"}}}

NeoBundle 'tpope/vim-fugitive' "{{{
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap          <leader>ge :Gedit<space>
  nnoremap <silent> <leader>gl :silent Glog<CR>:copen<CR>
  nnoremap <silent> <leader>gp :Git push<CR>
  nnoremap <silent> <leader>gw :Gwrite<CR>
  nnoremap <silent> <leader>gr :Gremove<CR>
  autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
  autocmd BufReadPost fugitive://* set bufhidden=delete
"}}}

NeoBundle 'mhinz/vim-signify' "{{{
  let g:signify_disable_by_default = 1
  let g:signify_mapping_next_hunk = '<leader>gj'
  let g:signify_mapping_prev_hunk = '<leader>gk'
  let g:signify_mapping_toggle_highlight = '<leader>gh'
  let g:signify_mapping_toggle           = '<leader>gt'
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

NeoBundle 'scrooloose/syntastic' "{{{
  let g:syntastic_error_symbol = '✗'
  let g:syntastic_style_error_symbol = '✠'
  let g:syntastic_warning_symbol = '∆'
  let g:syntastic_style_warning_symbol = '≈'
  let g:syntastic_enable_signs=0
  nnoremap <silent> <Leader>e :SyntasticCheck<cr>:silent! Errors<cr>
  vnoremap <silent> <Leader>e :SyntasticCheck<cr>:silent! Errors<cr>
  nnoremap <silent> <leader>lc :lclose<cr>
  nnoremap <silent> <leader>lo :lopen<cr>
"}}}

" unimpaired pairs well with syntastic - provides location list
" shortcuts
NeoBundle 'tpope/vim-unimpaired'

NeoBundle 'majutsushi/tagbar', { 'depends': 'bitc/lushtags' } "{{{
  nnoremap <silent> <Leader>] :TagbarToggle<cr>
  vnoremap <silent> <Leader>] :TagbarToggle<cr>
"}}}

NeoBundle 'tpope/vim-characterize'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-sleuth'
NeoBundle 'tpope/vim-surround'
NeoBundle 'IndentAnything'

NeoBundle 'Valloric/YouCompleteMe' "{{{
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
"}}}

NeoBundle 'pangloss/vim-javascript' "{{{
  if has('conceal')
    let g:javascript_conceal=1
    autocmd FileType javascript set conceallevel=2 concealcursor=n
  endif
"}}}

NeoBundle 'marijnh/tern_for_vim' "{{{
  augroup Tern
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <silent> <leader>td :TernDefSplit<cr>
    autocmd FileType javascript nnoremap <buffer> <silent> <leader>tr :TernRefs<cr>
    autocmd FileType javascript nnoremap <buffer> <silent> <leader>tc :TernRename<cr>
  augroup END
"}}}

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
  if has('gui_running')
    " I like the lower contrast for list characters.  But in a terminal
    " this makes them completely invisible and causes the cursor to
    " disappear.
    let g:solarized_visibility="low" "Specifies contrast of invisibles.
  endif
  colorscheme solarized
  highlight SignColumn guibg=#002b36
"}}}

NeoBundle 'mileszs/ack.vim' "{{{
  nnoremap <leader>a :Ack<space>
"}}}

NeoBundle 'drmikehenry/vim-fontdetect'

NeoBundle 'bling/vim-airline' "{{{
  if fontdetect#hasFontFamily('Ubuntu Mono derivative Powerline')
    set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12,Ubuntu\ Mono\ 12
    let g:airline_powerline_fonts = 1
  else
    let g:airline_powerline_fonts = 0
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇ '
    let g:airline_symbols.whitespace = 'Ξ'
  endif
  set noshowmode  " Mode is indicated in status line instead.

  " Customizes airline theme to reduce contrast
  let g:airline_theme_patch_func = 'AirlineThemePatch'
  function! AirlineThemePatch(palette)
    let ansi_colors = get(g:, 'solarized_termcolors', 16) != 256 && &t_Co >= 16 ? 1 : 0
    let tty         = &t_Co == 8
    let base03  = {'t': ansi_colors ?   8 : (tty ? '0' : 234), 'g': '#002b36'}
    let base02  = {'t': ansi_colors ? '0' : (tty ? '0' : 235), 'g': '#073642'}
    let base01  = {'t': ansi_colors ?  10 : (tty ? '0' : 240), 'g': '#586e75'}
    let base00  = {'t': ansi_colors ?  11 : (tty ? '7' : 241), 'g': '#657b83'}
    let base0   = {'t': ansi_colors ?  12 : (tty ? '7' : 244), 'g': '#839496'}
    let base1   = {'t': ansi_colors ?  14 : (tty ? '7' : 245), 'g': '#93a1a1'}
    let base2   = {'t': ansi_colors ?   7 : (tty ? '7' : 254), 'g': '#eee8d5'}
    let base3   = {'t': ansi_colors ?  15 : (tty ? '7' : 230), 'g': '#fdf6e3'}
    let yellow  = {'t': ansi_colors ?   3 : (tty ? '3' : 136), 'g': '#b58900'}
    let orange  = {'t': ansi_colors ?   9 : (tty ? '1' : 166), 'g': '#cb4b16'}
    let red     = {'t': ansi_colors ?   1 : (tty ? '1' : 160), 'g': '#dc322f'}
    let magenta = {'t': ansi_colors ?   5 : (tty ? '5' : 125), 'g': '#d33682'}
    let violet  = {'t': ansi_colors ?  13 : (tty ? '5' : 61 ), 'g': '#6c71c4'}
    let blue    = {'t': ansi_colors ?   4 : (tty ? '4' : 33 ), 'g': '#268bd2'}
    let cyan    = {'t': ansi_colors ?   6 : (tty ? '6' : 37 ), 'g': '#2aa198'}
    let green   = {'t': ansi_colors ?   2 : (tty ? '2' : 64 ), 'g': '#859900'}

    let mode_fg   = base02
    let mode_bg   = base0
    let branch_fg = base02
    let branch_bg = base00

    " Cheatsheet:
    " airline_a = mode indicator
    " airline_b = branch
    " airline_c = middle (filename)
    " airline_x = filetype & tag
    " airline_y = encoding
    " airline_z = line number / position
    " airline_warning = syntastic & whitespace

    if g:airline_theme == 'solarized'
      let a:palette.normal.airline_a[1] = mode_bg.g
      let a:palette.normal.airline_a[3] = mode_bg.t
      let a:palette.normal.airline_z[1] = mode_bg.g
      let a:palette.normal.airline_z[3] = mode_bg.t
      for modes in keys(a:palette)
        if modes != 'inactive' && has_key(a:palette[modes], 'airline_a')
          let a:palette[modes]['airline_a'][0] = mode_fg.g
          let a:palette[modes]['airline_a'][2] = mode_fg.t
        endif
        if modes != 'inactive' && has_key(a:palette[modes], 'airline_b')
          let a:palette[modes]['airline_b'][0] = branch_fg.g
          let a:palette[modes]['airline_b'][1] = branch_bg.g
          let a:palette[modes]['airline_b'][2] = branch_fg.t
          let a:palette[modes]['airline_b'][3] = branch_bg.t
        endif
        if modes != 'inactive' && has_key(a:palette[modes], 'airline_y')
          let a:palette[modes]['airline_y'][0] = branch_fg.g
          let a:palette[modes]['airline_y'][2] = branch_fg.t
          let a:palette[modes]['airline_y'][2] = branch_fg.t
          let a:palette[modes]['airline_y'][3] = branch_bg.t
        endif
        if modes != 'inactive' && has_key(a:palette[modes], 'airline_z')
          let a:palette[modes]['airline_z'][0] = mode_fg.g
          let a:palette[modes]['airline_z'][2] = mode_fg.t
        endif
      endfor
    endif
  endfunction
"}}}

NeoBundle 'SirVer/ultisnips' "{{{
  let g:UltiSnipsEditSplit = 'vertical'
  "let g:UltiSnipsExpandTrigger = '<C-j>'

  " Allows the same trigger to operate UltiSnips and YouCompleteMe
  function! g:UltiSnips_Complete()
    call UltiSnips_ExpandSnippet()
    if g:ulti_expand_res == 0
      if pumvisible()
        return "\<C-n>"
      else
        call UltiSnips_JumpForwards()
        if g:ulti_jump_forwards_res == 0
          return "\<TAB>"
        endif
      endif
    endif
    return ""
  endfunction

  au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
  "let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsListSnippets="<c-e>"
"}}}

NeoBundle 'jiangmiao/auto-pairs' "{{{
  let g:AutoPairsFlyMode = 1
"}}}

" Installation check.
NeoBundleCheck
