#!/bin/bash

set -e

# exit when first argument is not set
if [ $# -eq 0 ]; then
    echo "Please provide a username for the test. Do not use an existing user or else they will be deleted."
    exit 1
fi

# Get the new username from the first parameter
NEW_USER=$1

# git branch to be tested against
TEST_BRANCH=${2:-'main'}

# Check that the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Create the new user account with a home directory and default shell
useradd -m -s /bin/bash $NEW_USER

# Set the password for the new user account
echo "${NEW_USER}:Pass_word123" | chpasswd

# Allow the new user to run privileged commands without a password
echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NEW_USER

# Switch to the new user account
su - $NEW_USER <<EOF

TMP_DIR="\$HOME/tmpdotfiles"
LOCALREPO_DIR="\$HOME/.dotfiles"

set -e

# Run your command here
echo "Hello from $NEW_USER's home directory: \$HOME"

# download the dotfiles and make them executable
cd \$HOME && curl -O https://raw.githubusercontent.com/stvbyr/dot/$TEST_BRANCH/init_dotfiles.sh && chmod +x ./init_dotfiles.sh

# download the dotfiles
./init_dotfiles.sh https -d

# switch to the configured branch and sync home with these files
git --git-dir="\$LOCALREPO_DIR" --work-tree="\$TMP_DIR" checkout $TEST_BRANCH
rsync --recursive --verbose --exclude '.git' --exclude 'init_dotfiles.sh' \$TMP_DIR/ \$HOME/

# install dependencies and set default shell, cleanup afterwards
./init_dotfiles.sh https -I
./init_dotfiles.sh https -t

# confirm that the shell is zsh and is set as default
if [ "\$0" = "zsh" ] && [ "$(which "$SHELL")" = "$(which zsh)" ]; then
    echo "[ OK ] shell is set to zsh"
else
    echo "[ FAIL ] zsh wasn't setup correctly"
fi

# Switch back to the original user account
exit
EOF

# Remove the passwordless sudo rule for the new user
rm /etc/sudoers.d/$NEW_USER

# Delete the test user
userdel -r $NEW_USER
