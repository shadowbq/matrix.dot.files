## Vundle 

This repo uses VUNDLE to inject VIM plugins

* https://github.com/gmarik/vundle

When you install a new shell for matrix it will ask to install from command line: `vim +PluginInstall +qall`

This is checked in `check_matrix_dependencies func:check_first_vim`

### Vundle Plugin List
```
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
```

## Vim Airline

vim-airline is essentially a fork of powerline, but slimmed down and built specifically for ViM. This repo is configured to use powerline fonts. 

Base16 Theme is used by airline.

* https://github.com/vim-airline/vim-airline/wiki/Screenshots#base16  
* https://github.com/chriskempson/base16  

## Vim Colors

The .VIMRC uses `colorscheme zenburn`

You can copy a scheme file (whateva.vim) into the `.vim\color\` folder and load it with the proper name in the `.vimrc`

### Changing the Scheme

Addition Color Schemes: https://github.com/shadowbq/vim_colors

## VIM shortcuts to remember

### Save file you forgot to sudo first

`:w !sudo tee %`
