#!/bin/bash

TMP_DIR="$HOME/tmpdotfiles"
LOCALREPO_DIR="$HOME/.dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

set -e

function dot {
    git --git-dir="$LOCALREPO_DIR" --work-tree="$HOME" $1
}

# -h
function usage {
    color="\x1b["
    colorEnd="\x1b[0m"
    green="32m"

    printf "\n"
    printf "================================================================\n"
    printf "Usage: ${color}${green}%s [proto] [-{options}]${colorEnd}\n" $(basename $0)
    printf "\n"
    printf "Arguments:\n"
    printf "    proto: [ssh, https] specify how to download the repo \n"
    printf "\n"
    printf "Options:\n"
    printf "    -h Output usage\n"
    printf "    -i Install the dotfiles, a backup of all affected files\n" 
    printf "       will be created\n"
    printf "    -I Install dependencies that the dotfiles refer to\n"
    printf "    -c Show changes since last version\n"
    printf "    -d Download dotfiles\n"
    printf "    -b Backup dotfiles (only works if the project has been\n" 
    printf "       downloaded via -d or -i)\n"
    printf "================================================================\n"
    printf "\n"
}

# -d
function download {
    [ -d "$LOCALREPO_DIR" ] && rm -rf "$LOCALREPO_DIR"
    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"

    if [ "$1" = "ssh" ]; then
        git clone --separate-git-dir="$LOCALREPO_DIR" git@github.com:stvbyr/dot.git $TMP_DIR
        return
    fi

    if [ "$1" = "https" ]; then
        git clone --separate-git-dir="$LOCALREPO_DIR" https://github.com/stvbyr/dot.git $TMP_DIR
        return
    fi

    printf "[%s] is not a valid protocol. Allowed protocols are ssh and https.\n" $1
    exit 1
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
    download $1
    backup
    rsync --recursive --verbose --exclude '.git' $TMP_DIR/ $HOME/
    rm -rf $TMP_DIR
}

function _install_zsh {
    if command -v zsh &>/dev/null; then
        return
    fi

    echo "installing zsh ..."

    if command -v apt &>/dev/null; then
        sudo apt install zsh
        return
    fi

    if command -v pacman &>/dev/null; then
        sudo pacman -Sy zsh
        return
    fi
}

function _install_ohmyzsh {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "updating oh-my-zsh ..."
        git -C "$HOME/.oh-my-zsh" pull
        return
    fi

    echo "installing ohmyzsh ..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function _install_p10k {
    if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "updating p10k ..."
        git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
        return
    fi

    echo "installing p10k ..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}

function _install_delta {
    if command -v delta &>/dev/null; then
        return
    fi

    echo "installing delta ..."

    if command -v pacman &>/dev/null; then
        sudo pacman -S git-delta
        return
    fi

    if command -v dpkg &>/dev/null; then
        curl -SL https://github.com/dandavison/delta/releases/download/0.13.0/git-delta_0.13.0_amd64.deb -o delta.deb
        sudo dpkg -i delta.deb
        rm delta.deb
        return
    fi
}

function _install_z {
    if [ ! -d "$ZSH_CUSTOM/shell-tools/z" ]; then
        echo "updating z ..."
        git clone https://github.com/rupa/z.git "$ZSH_CUSTOM/shell-tools/z"
        return
    fi

    echo "installing z ..."
    git -C "$ZSH_CUSTOM/shell-tools/z" pull
}

function _install_omz_plugins {
    [ -f "$HOME/omz_plugin_update.sh" ] && source "$HOME/omz_plugin_update.sh" && return

    echo "oh-my-zsh plugin updater is not there!"
    exit 3
}

# -I
function install_deps {
    _install_zsh
    _install_ohmyzsh
    _install_p10k
    _install_delta
    _install_z
    _install_omz_plugins
}

# -c
function changes_since_last_tag {
    LATEST_TAG=$(dot "describe --tags --abbrev=0")
    echo "Files changed: \n"
    dot "diff --name-only $LATEST_TAG HEAD"
    dot "diff $LATEST_TAG HEAD"
}

if [[ ${#} -eq 0 ]]; then
    usage
fi

# first command specifies the protocol to use
proto=ssh
# it is optional so we're only able to shift if there are more than 1 argument
if [[ $# -gt 1 ]]; then
    proto=${1:-ssh}
    # this shifts the position of the arguments to the left making the second argument the first. we need this because the next block (getopts) expects the options at position $1 which would be $2 without shift
    shift
fi

while getopts ":hdbiVIc" opt; do
    case "${opt}" in
    h)
        usage
        ;;
    d)
        download $proto
        ;;
    b)
        backup
        ;;
    i)
        install $proto
        ;;
    I)
        install_deps
        ;;
    c)
        changes_since_last_tag
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
