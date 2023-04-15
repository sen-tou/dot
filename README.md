# Stvbyr dotfiles

These are my dotfiles that I am currently using.

**Note:** I do not take responsibility for lost files. Read this manual carefully
and take a look at the source yourself. If you spot something I would be happy to
receive an issue/pr. Use at your own risk.

## Installation with script

### Download the install script

```sh
cd ~ && curl -O https://raw.githubusercontent.com/stvbyr/dot/main/init_dotfiles.sh && chmod +x ./init_dotfiles.sh
```

### Make yourself familiar with the script

`./init_dotfiles.sh https -h` to get a help page.

### Full install

Use `./init_dotfiles.sh https -f` to get a full install. This will setup your
   home directory as well as install all dependencies and changes your default
   shell to zsh

### Alternate install

Use `./init_dotfiles.sh https -i` where you want the repo to be readonly and
`./init_dotfiles.sh -i` where you can make modifications. This will only setup
your home directory but will not install any dependencies for the dotfiles.

**Optional:** After installing you can use the `-I` option to install dependencies that are
required for my dotfiles to work. Please make sure to check the script so you
understand what is installed and how.

### Making it your home

If you wanna create your own dotfiles repo from this, create a fork. Make sure to check your
workspace with `dot status` and check if there are any private files that you **DO
NOT** want to push to github.

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

## Testing

Included is a test file that you can use to test changes to your dotfiles. It
will create a new user that you can specify and deletes it afterwards. You can
specify a develop branch to test your changes to your install script.

```txt
Usage: dotfiles_test.sh user [branch]

Arguments:
    user: Specify the name of the new user that you want to test (don't use an existing user, they will be deleted after the script has finished running)
    branch: Git branch you want to use for testing, default branch is main
```
