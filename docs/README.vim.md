# VIM

The `dot.matrix` has two components for VIM.

* VIM matrix ext bash functions that provide symlinks
* Homebrew `.vim` symlink with Vundle plugins

## matrix extension vim

This extension adds basic symlinks for `vim`, `svi`, and `svim`. 

This is configured in the `.matrix_config`

## Vundle 

This repo also uses VUNDLE to inject VIM plugins for the homebrew linked `.vim`.

* https://github.com/gmarik/vundle

When you install a new shell for dot.matrix it will ask to install all the plugins from the command line: `vim +PluginInstall +qall`

This is checked in `check_matrix_dependencies func:check_first_vim`

### Vundle Plugin List

What I prefer as my `vim` plugin list, included in matrix.dot.files.

```vim
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

### Vim Airline

`vim-airline` is essentially a fork of `powerline`, but slimmed down and built specifically for ViM. This repo is configured to use powerline fonts. 

Base16 Theme is used by airline.

* https://github.com/vim-airline/vim-airline/wiki/Screenshots#base16  
* https://github.com/chriskempson/base16  

### Vim Colors

The .VIMRC uses `colorscheme zenburn`

You can copy a scheme file (whateva.vim) into the `.vim\color\` folder and load it with the proper name in the `.vimrc`

#### Changing the Scheme

Addition Color Schemes: https://github.com/shadowbq/vim_colors

## VIM shortcuts to remember

### Save file you forgot to sudo first

`:w !sudo tee %`
