# Stvbyr dotfiles

These are my dotfiles that I am currently using.

**Note:** I do not take responsibility for lost files. Read this manual carefully
and take a look at the source yourself. If you spot something I would be happy to
receive an issue/pr. Use at your own risk.

## Installation with script

1. Change the repo url in the script below to use https or fork it and replace with
your own url. There is no config for this yet.

2. Download the install script

```sh
cd ~ && curl -O https://raw.githubusercontent.com/stvbyr/dot/main/init_dotfiles.sh && chmod +x ./init_dotfiles.sh
```

3. Make yourself familiar with the script

```txt
Usage: init_dotfiles.sh [options]

Options:
    -h Output usage
    -i Install the dotfiles, a backup of all affected files will be created
    -I Install dependencies that the dotfiles refer to
    -d Download dotfiles (no install)
    -b Backup dotfiles (only works if the project has been downloaded via -d or -i Install the dotfiles, a backup of all affected files will be created
```

4. A backup should be created with the `-b` option for all files that would be
affected before installing. Use the `-d` option first to download the files.
[@see Backup](#backup)

5. `./init_dotfiles.sh -i` will install the dotfiles. (It will download the files
again and sync it with your home folder)

**Optional:** You can also use the `-I` option to install dependencies that are
required for my dotfiles to work. Please make sure to check the script so you
understand what is installed and how.

### Making it your home

If you forked the project and changed the repo url in the script as in `1.`
these changes are lost after the install. Makes sure to check them in and push
them to your fork. 

If you wanna create your own dotfile repo from this make sure to check your
workspace with `dot status` and check if there are any private files that you DO
NOT want to push to github.

Add them to `.gitignore` to not accidentally check them in.

## Managing your files with the `dot` alias

An alias is defined that lets you reference your dotfiles from everywhere. `dot`
is just an alias for `git` that defines a different working-tree/git-dir.

My typical workflow looks like this:
`dot status` - for showing changed files in your home dir
`dot add .` - add all changes
`dot commit -m "..."` - commit your changes
`dot push` - push changes

## Backup

`./init_dotfiles.sh -b` will create a backup if you have the repo downloaded
already (or installed). 

The folder `.dotfile_backup` contains all backups created with ISO date.

For example: `~/.dotfile_backup/2022-07-24-17-14-46`