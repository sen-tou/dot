#!/bin/bash

VERSION="$(basename $0) 0.2.1"

TMP_DIR="$HOME/tmpdotfiles"
LOCALREPO_DIR="$HOME/.dotfiles"

set -e

function dot {
    git --git-dir="$LOCALREPO_DIR" --work-tree="$HOME" $1
}

# -h 
function usage {
    printf "Usage: %s [options]\n" $(basename $0)
    printf "\n"
    printf "Options:\n"
    printf "    -h Output usage\n"
    printf "    -i Install the dotfiles, a backup of all affected files will be created\n"
    printf "    -I Install dependencies that the dotfiles refer to\n"
    printf "    -d Download dotfiles\n"
    printf "    -b Backup dotfiles (only works if the project has been downloaded via -d or -i)\n"
    printf "    -V Print version\n"
}

# -d
function download {
    [ -d "$LOCALREPO_DIR" ] && rm -rf "$LOCALREPO_DIR"
    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"

    git clone --separate-git-dir="$LOCALREPO_DIR" git@github.com:stvbyr/dot.git $TMP_DIR   
}

# -b
function backup {
    BACKUP_FOLDER=".dotfile_backup/$(date +'%Y-%m-%d-%H-%M-%S')"
    mkdir -p "$BACKUP_FOLDER"
    dot "ls-tree -r --full-name --name-only main" |
        xargs -I "{}" rsync --ignore-missing-args "$HOME/{}" "$BACKUP_FOLDER/{}"

    printf "Backup created in %s\n" $BACKUP_FOLDER
}

# -i
function install {    
    echo "installing dotfiles"
    download
    backup
    rsync --recursive --verbose --exclude '.git' $TMP_DIR/ $HOME/
    rm -rf $TMP_DIR
}

function _install_zsh {
    echo "installing zsh ..."
    if command -v apt &> /dev/null; then
        sudo apt install zsh
        return
    fi

    if command -v pacman &> /dev/null; then
        sudo pacman -Sy zsh
        return
    fi
}

function _install_ohmyzsh {
    echo "installing ohmyzsh ..."
    
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function _install_p10k {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}

# -I
function install_deps {
    # install zsh
    if ! command -v zsh &> /dev/null; then
        _install_zsh
    fi

    if ! [ -d "$HOME/.oh-my-zsh" ]; then
        _install_ohmyzsh
    fi

    if ! [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        _install_p10k
    fi
}

if [[ ${#} -eq 0 ]]; then
   usage
fi

while getopts ":hdbiVI" opt; do
    case "${opt}" in
        h)
            usage
            ;;
        d)
            download
            ;;
        b)
            backup
            ;;
        i)
            install
            ;;
        I)
            install_deps
            ;;
        V)
            echo $VERSION
            ;;
        :)
            echo "$0: -$OPTARG needs an argument." >&2
            exit 1
            ;;
        ?)
            echo "Invalid option: -${OPTARG}." >&2
            exit 2
            ;;
    esac
done 
