filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#beigin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'othree/html5.vim'
Plugin 'ap/vim-css-color'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'mattn/emmet-vim'
Plugin 'lumiliet/vim-twig'
Plugin 'vim-ruby/vim-ruby'
Bundle 'sickill/vim-pasta'
Plugin 'airblade/vim-gitgutter'
Plugin 'anned20/vimsence'
Plugin 'luochen1990/rainbow'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Put your non-Plugin stuff after this line

let g:rainbow_active = 1

syntax enable

set expandtab
set tabstop=2

set number
set showcmd
set cursorline
filetype indent on
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set wildmode=longest,list,full
set wildmenu

" Random settings
set background=light
set synmaxcol=400
set cursorline
set colorcolumn=
set t_Co=256
set nospell
set laststatus=2
set showtabline=2
set ttyfast
set showcmd
set noshowmode
set ruler
set noerrorbells
set undofile
set undodir=/tmp/vim-undodir " mkdir /tmp/vim-undodir
set textwidth=0
set backspace=indent,eol,start
set complete=.,w,b,u,t,i
set completeopt=longest,menuone,preview
set omnifunc=syntaxcomplete#Complete
set showmatch
set matchtime=5
set tabstop=2
set shiftwidth=2
set smarttab
set softtabstop=2
set expandtab
set autoindent
set cindent
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do,for,switch,case
set modeline
set modelines=5
set autowrite
set autoread
set backup
set backupdir=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set writebackup
set shell=zsh


" hybrid line numbers
set number relativenumber

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
" Make it faster!
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Statusline theme

au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=72
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=72

let g:currentmode={
  \ 'n'  : 'Normal',
  \ 'no' : 'Normal·Operator Pending',
  \ 'v'  : 'Visual',
  \ 'V'  : 'V·Line',
  \ '^V' : 'V·Block',
  \ 's'  : 'Select',
  \ 'S'  : 'S·Line',
  \ '^S' : 'S·Block',
  \ 'i'  : 'Insert',
  \ 'R'  : 'Replace',
  \ 'Rv' : 'V·Replace',
  \ 'c'  : 'Command',
  \ 'cv' : 'Vim Ex',
  \ 'ce' : 'Ex',
  \ 'r'  : 'Prompt',
  \ 'rm' : 'More',
  \ 'r?' : 'Confirm',
  \ '!'  : 'Shell',
  \ 't'  : 'Terminal'
  \}

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ 「\ %{toupper(g:currentmode[mode()])}\ 」         " mode
set statusline+=%3*│                                          " separator
set statusline+=%1*\ %Y\                                      " FileType
set statusline+=%3*│                                          " Separator
set statusline+=%1*\ %{''.(&fenc!=''?&fenc:&enc).''}          " Encoding
set statusline+=\ (%{&ff})                                    " FileFormat (dos/unix..)
set statusline+=%3*│                                          " Separator
set statusline+=%0*\ %F%m%r%h%w\                            " File path, modified, readonly, helpfile, preview
set statusline+=%=                                            " Right Side
set statusline+=%1*\ %3*POS:\ %1*%02v\                        " Colomn number
set statusline+=%3*│                                          " Separator
set statusline+=%1*\ %3*LINE:\ %1*%02l/%L\ %3*(%1*%p%%%3*)\   " Line number / total lines, percentage of document
set statusline+=%3*│                                          " Separator
set statusline+=%1*\ %n\                                      " Buffer number

hi User1 ctermfg=72 ctermbg=235  " Green
hi User2 ctermfg=250 ctermbg=236 " background
hi User3 ctermfg=250 ctermbg=235 " White
hi User3 ctermfg=240 ctermbg=235 " label

hi Visual       ctermfg=255 guifg=#eeeeee ctermbg=29  guibg=#008000
