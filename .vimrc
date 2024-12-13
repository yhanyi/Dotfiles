" [Copied and edited from 2030S .vimrc file]

set notermguicolors

" Turns on syntax highlighting
syntax on

" Makes vim behave less like vim
set nocompatible

" Keep a backup copy of the file being edited
" set backup

" Location of the backup files
" set backupdir=~/.backup

" Backspace key options
set backspace=indent,eol,start

" Automatically indent the new line
set autoindent

" Indent the new line according to C-like syntax
set smartindent

" Make default indent at 2 spaces
set shiftwidth=2

" Set tab stop to 2
set tabstop=2

" Load the relevant plugins and indentation rules based on file types
filetype plugin indent on

" Replace all tab with spaces
set expandtab

" Display lines longer than the current window on the next line(s)
set wrap

" Prevent breaking a word into multiple lines when wrapping
set linebreak

" Display line and column number on the lower-right corner
set ruler

" To get around the problem where seeminly random characters appear in certain
" terminals
set t_RV=
set t_u7=

color zaibatsu

" Turns on line number
set number

" Turn on relative line numbers
" set relativenumber

" vim is optimized for keyboard-only, but if you insist on using mouse,
" uncomment the following
set mouse+=a

" Some advanced options requested by students.
" set hidden
" set wildmenu
set showcmd
" set hlsearch
" set confirm
" set visualbell
" set ignorecase
" set smartcase
set showmode
set cursorline
set clipboard+=unnamedplus

" Statusline

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

" For students who are used to using the psvm/sout/sop abbreviation, you can
" uncomment the following
" abbr psvm public static void main(String[] args){<CR>}<esc>0
" abbr sout System.out.println("");<esc>2hi
" abbr sop System.out.print("");<esc>2hi
