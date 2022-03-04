#!/bin/bash

git clone --separate-git-dir=$HOME/.dotfiles https://github.com/stvbyr/dot.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles