#!/usr/bin/env bash

if [ ! -d "$HOME/.matrix/vim/bundle" ]; then
    mkdir -p "$HOME/.matrix/vim/bundle";
fi

cd "$HOME/.matrix/vim/bundle";

case $1 in
    'install')
        git clone git://github.com/thinca/vim-guicolorscheme.git;
        git clone git://github.com/Shougo/neocomplcache.git;
        git clone git://github.com/thinca/vim-quickrun.git;
        git clone git://github.com/Shougo/unite.vim.git;
        git clone git://github.com/thinca/vim-ref.git;
        ;;
    'upgrade')
        dirlista=`find . -maxdepth 1 -type d -print`;
        for d in $dirlista; do
            if [ "$d" != "." ]; then
                cd "$d";
                echo $d;
                git pull;
                cd '..';
            fi
        done;
        ;;
    *)
        cat << EOM
Usage:
    $0 install

    $0 upgrade

EOM
        ;;
esac


