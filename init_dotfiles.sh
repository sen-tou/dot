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
    printf "    -i Install the dot files, a backup of all affected files will be created\n"
    printf "    -d Download dotfiles\n"
    printf "    -b Backup dotfiles (only works if the project has been downloaded via -d or -i)\n"
    printf "    -V Print version\n"
    exit
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
function install() {    
    download
    backup
    rsync --recursive --verbose --exclude '.git' $TMP_DIR/ $HOME/
    rm -rf $TMP_DIR

    exit
}

if [[ ${#} -eq 0 ]]; then
   usage
fi

while getopts ":hdbiV" opt
do
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
