# dot

My .dotfiles

## Install 

This will overwrite all existing files that you may have created. Make a backup. Use at your own risk.

```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/stvbyr/dot.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
```
