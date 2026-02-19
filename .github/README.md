# Evan Sultanik's Dotfiles

These are the personal dotfiles for Evan Sultanik

## Prerequisites

Install [`fish` shell](https://fishshell.com/).

## Installation

On a new machine, from your home directory:

```
cd ~
git clone --bare git@github.com:ESultanik/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles --work-tree=$HOME init
git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --recursive
source ~/.config/fish/config.fish
dotfiles config --local status.showUntrackedFiles no
```

## Usage

The new `dotfiles` command can be used just like `git` to add/remove/commit files in your home directory.
