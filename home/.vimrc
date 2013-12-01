set t_Co=256
let g:zenburn_high_Contrast=1
colorscheme zenburn
syntax on

set history=100 " Increase the search history
set ignorecase " Ignore case in search patterns
set incsearch " While typing a searc:h command, show where the pattern, as it was typed

set ruler

set nobackup
set nowritebackup
set noswapfile

set cursorline
set number
set showmatch

" Control tabs/spaces/column displays
set expandtab " Expand tab to spaces
set shiftwidth=2 " How many columns text is indented with the reindent operations (<< and >>). For modifying text
set softtabstop=2 " Set softtabstop to control how many columns vim uses when you hit Tab in insert mode. If softtabstop is less than tabstop and expandtab is not set, vim will use a combination of tabs and spaces to make up the desired spacing. If softtabstop equals tabstop and expandtab is not set, vim will always use tabs. When expandtab is set, vim will always use the appropriate number of spaces
set smarttab
set tabstop=2 " How many columns a tab counts for. For displaying text


