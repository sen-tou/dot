#!/bin/bash

# Get the new username from the first parameter
NEW_USER=$1

# Create the new user account with a home directory and default shell
useradd -m -s /bin/bash $NEW_USER

# Set the password for the new user account
echo "${NEW_USER}:Pass_word123" | chpasswd

# Switch to the new user account
su - $NEW_USER <<EOF

# Run your command here
echo "Hello from $NEW_USER's home directory: \$HOME"

# download the dotfiles and make them executable
cd $HOME && curl -O https://raw.githubusercontent.com/stvbyr/dot/oh-my-zsh-fix-install/init_dotfiles.sh && chmod +x ./init_dotfiles.sh

# install the dotfiles
init_dotfiles.sh -i && init_dotfiles.sh -I

# Switch back to the original user account
exit
EOF

# Delete the test user
userdel -r $NEW_USER
