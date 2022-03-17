#!/bin/bash

git clone --separate-git-dir=$HOME/.dotfiles ssh://git@github.com/stvbyr/dot.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles