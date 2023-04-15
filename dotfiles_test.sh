#!/bin/bash

# Get the new username from the first parameter
NEW_USER=$1

# branch to be tested agains
TEST_BRANCH=${2:-'main'}
# Create the new user account with a home directory and default shell
useradd -m -s /bin/bash $NEW_USER

# Set the password for the new user account
echo "${NEW_USER}:Pass_word123" | chpasswd

# Switch to the new user account
su - $NEW_USER <<EOF

TMP_DIR="\$HOME/tmpdotfiles"

# Run your command here
echo "Hello from $NEW_USER's home directory: \$HOME"

# download the dotfiles and make them executable
cd \$HOME && curl -O https://raw.githubusercontent.com/stvbyr/dot/$TEST_BRANCH/init_dotfiles.sh && chmod +x ./init_dotfiles.sh

# install the dotfiles
./init_dotfiles.sh https -d
git --git-dir="\$TMP_DIR" checkout $TEST_BRANCH
rsync --recursive --verbose --exclude '.git' --exclude 'init_dotfiles.sh' \$TMP_DIR/ \$HOME/
./init_dotfiles.sh https -I
./init_dotfiles.sh https -t

# Switch back to the original user account
exit
EOF

su - $NEW_USER

# Delete the test user
userdel -r $NEW_USER
