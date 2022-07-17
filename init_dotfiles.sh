#!/bin/bash

VERSION="$(basename $0) 0.1.0"

LOCALREPO_DIR="$HOME/.dotfiles"

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
    printf "    -b Backup dotfiles\n"
    printf "    -V Print version\n"
    exit
}

# -b
function backup {
    BACKUP_FOLDER=".dotfile_backup/$(date +'%Y-%m-%d-%H-%M-%S')"
    mkdir -p "$BACKUP_FOLDER"
    dot "ls-tree -r --full-name --name-only main" |
        xargs -I "{}" rsync "$HOME/{}" "$BACKUP_FOLDER/{}"
    printf "Backup created in %s\n" $BACKUP_FOLDER
    exit
}

# -i
function install() {
    if [[ ! -d "$LOCALREPO_DIR" || ! "$(ls -A $LOCALREPO_DIR)" ]]
    then
        [ -d "$LOCALREPO_DIR" ] && rm -r "$LOCALREPO_DIR"
        git clone --separate-git-dir="$LOCALREPO_DIR" ssh://git@github.com/stvbyr/dot.git tmpdotfiles
        rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
        rm -r tmpdotfiles
    else
        dot pull 
    fi

    exit
}

if [[ ${#} -eq 0 ]]; then
   usage
fi

while getopts ":hbiV" opt
do
    case "${opt}" in
        h)
            usage
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
