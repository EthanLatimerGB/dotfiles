# My Dotfiles

## Backing up my dots

To backup a new dotfile to the repository, you must have `rcm` installed.

Then to **back up** a specific file (assuming your .dotfiles is already cloned into your home directory), then all you need to do is:

```
mkrc -v <file_location>"
```

One example could be `mkrc -v ~/.config/nvim/init.lua`.

Then, just make sure to **add, commit and push** your change to the remote repository.

## Recovering/updating my dots

Assuming your dotfile repository is installed in the correct location (your home dir), then you just need to install with:

* `rcup` - to recover all files

* `rcup -v <dotfile_name>` - to recover specific files. Example: `rcup -v .zshrc`

