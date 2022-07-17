# Stvbyr dot files

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

**Note:** A backup will be created for all files that would be affected. After that
all files in this repo will replace the once in your home dir.

If you wanna create your own dotfile repo from this make sure to check your
workspace with `dot status` and check if there are any private files that you DO
NOT want to push to github.

Add them to `.gitignore` to not accidentally check them in.
