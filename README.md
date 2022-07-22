# Stvbyr dot files

These are my dot files that I am currently using.

**Note:** There are of course no tools in this repo. You have to install them in
addition to using this repo. For example zsh and oh-my-zsh.

## Installation

```sh
cd ~ && wget -O- https://raw.githubusercontent.com/stvbyr/dot/main/init_dotfiles.sh
```

```txt
Options:
    -h Output usage
    -i Install the dot files, a backup of all affected files will be created
    -b Backup dotfiles
    -V Print version
```

`./init_dotfiles.sh -i` will install the dot files.

**Note:** A backup should be created with the -b option for all files that would be affected before installing. After that
all files in this repo will replace the once in your home dir.

If you wanna create your own dotfile repo from this make sure to check your
workspace with `dot status` and check if there are any private files that you DO
NOT want to push to github.

Add them to `.gitignore` to not accidentally check them in.
