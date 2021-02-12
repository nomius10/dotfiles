"###############################
"#### PLUGINS

call plug#begin()

Plug 'dag/vim-fish'

call plug#end()


set encoding=utf-8
set printencoding=utf-8

" swap real<->display line navigation
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" no arrow keys for you
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" spaces instead of tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" so i can see
set background=dark

set mouse=a " enable mouse usage (all modes) in terminals

