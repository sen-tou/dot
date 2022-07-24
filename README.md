# Stvbyr dot files

These are my dot files that I am currently using.

**Note:** There are of course no tools in this repo. You have to install them in
addition to using this repo. For example zsh and oh-my-zsh.
**Note:** I do not take responsibility for lost files. Read this manual carefully
and take a look at the source yourself. If you spot something open an issue.  Use at your own risk.

## Installation with script

Change the repo url in the script below to use https or fork it and replace with
your own url. There is no config for this yet.

```sh
cd ~ && curl -O https://raw.githubusercontent.com/stvbyr/dot/main/init_dotfiles.sh && chmod +x ./init_dotfiles.sh
```

```txt
Usage: init_dotfiles.sh [options]

Options:
    -h Output usage
    -i Install the dot files, a backup of all affected files will be created
    -d Download dotfiles
    -b Backup dotfiles (only works if the project has been downloaded via -d or -i)
    -V Print version
```

A backup should be created with the `-b` option for all files that would be
affected before installing. Use the `-d` option first to download the files.

`./init_dotfiles.sh -i` will install the dot files. (It will download the files
again and sync it with your home folder)

### Making it your home

If you forked the project and changed the repo url in the script
these changes are lost after the install. Makes sure to check them in and push
them to your fork. 

If you wanna create your own dotfile repo from this make sure to check your
workspace with `dot status` and check if there are any private files that you DO
NOT want to push to github.

Add them to `.gitignore` to not accidentally check them in.
