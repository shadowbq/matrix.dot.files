" Install all the VUNDLE pluings by 'check_matrix_dependencies func:check_first_vim'
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'elzr/vim-json'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'chriskempson/base16-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'towolf/vim-helm'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" https://github.com/VundleVim/Vundle.vim


"
" Put your non-Plugin stuff after this line

set t_Co=256
let g:zenburn_high_Contrast=1
colorscheme zenburn
syntax on

set ignorecase " Ignore case in search patterns
set incsearch " While typing a searc:h command, show where the pattern, as it was typed

set ruler

set nobackup
set nowritebackup
set noswapfile

set cursorline
set number
set showmatch
set hidden

" Control tabs/spaces/column displays
set expandtab " Expand tab to spaces
set shiftwidth=2 " How many columns text is indented with the reindent operations (<< and >>). For modifying text
set softtabstop=2 " Set softtabstop to control how many columns vim uses when you hit Tab in insert mode. If softtabstop is less than tabstop and expandtab is not set, vim will use a combination of tabs and spaces to make up the desired spacing. If softtabstop equals tabstop and expandtab is not set, vim will always use tabs. When expandtab is set, vim will always use the appropriate number of spaces

set smarttab
set tabstop=2 " How many columns a tab counts for. For displaying text

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" No direct ExMode
nnoremap Q <nop>

let mapleader="-"
nnoremap <leader>b :BufExplorer<cr>
nnoremap <leader>n :badd .<cr> :BufExplorer<cr>
nnoremap <leader>t :TagbarToggle<cr>
nnoremap <leader>l :NumbersToggle<cr>
nnoremap <leader>s :Ag

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
" let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'

" Markdown Options
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

" NerdTree Options
let NERDTreeShowHidden = 1

" Show IndentGuides
let g:indent_guides_enable_on_vim_startup = 1

" Syntastic Sane Options
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" syntastic_[filetype]_[subchecker]_args
let g:syntastic_python_flake8_args = "--ignore=E501"
