set termguicolors
syntax on
set nocompatible
set backspace=indent,eol,start
set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
set expandtab
set wrap
set linebreak
set ruler
set number
set relativenumber
set mouse+=a
set clipboard=unnamedplus
filetype plugin indent on

colorscheme catppuccin

set showcmd
set showmode
set cursorline
" set hidden
" set wildmenu
" set hlsearch
" set confirm
" set visualbell
" set ignorecase
" set smartcase

function! StatuslineMode()
  let l:mode=mode()
  if l:mode==#"n"
    return "NORMAL"
  elseif l:mode==#"v"
    return "VISUAL"
  elseif l:mode==#"i"
    return "INSERT"
  elseif l:mode==#"R"
    return "REPLACE"
  elseif l:mode==#"s"
    return "SELECT"
  elseif l:mode==#"t"
    return "TERMINAL"
  elseif l:mode==#"c"
    return "COMMAND"
  elseif l:mode==#"!"
    return "SHELL"
  endif
endfunction

set laststatus=2
set statusline=
set statusline+=%1*
set statusline+=\ %{StatuslineMode()} 
set statusline+=\ 
set statusline+=%2*
set statusline+=\ %F 
set statusline+=\ %m 
set statusline+=\ 
set statusline+=%=
set statusline+=\ %y 
set statusline+=\ 
set statusline+=%3*
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} 
set statusline+=\ 
set statusline+=\[%{&fileformat}\]
set statusline+=\ 
set statusline+=%4*
set statusline+=\ %p%%
set statusline+=\ line:\ %l/%L 
set statusline+=\ col:\ %c 
set statusline+=\ 

hi User1 ctermbg=lightcyan ctermfg=black guibg=lightcyan guifg=black
hi User2 ctermbg=black ctermfg=cyan guibg=black guifg=cyan
hi User3 ctermbg=darkgray ctermfg=white guibg=darkgray guifg=white
hi User4 ctermbg=lightgreen ctermfg=black guibg=lightgreen guifg=black

