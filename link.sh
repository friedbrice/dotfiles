#!/bin/bash

function link-file {
    if [ ! -f ~/$1 ]; then
        ln ./$1 ~/$1
    else
        read -p "~/$1 exists, overwrite? " yn
        case $yn in
            [Yy]* ) rm ~/$1 && ln ./$1 ~/$1 && echo "replaced $1" ;;
            [Nn]* ) echo "skipping $1" ;;
        esac
    fi
}

link-file ".bash_aliases"
link-file ".bash_prompt"
link-file ".bashrc"
link-file ".gitconfig"
link-file ".gitexcludes"
link-file ".profile"
link-file ".vimrc"
link-file ".xmobarrc"
link-file ".Xresources"
link-file "bin/backlight"
link-file ".xmonad/xmonad.hs"
