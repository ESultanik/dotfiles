# Evan Sultanik's Dotfiles

These are the personal dotfiles for Evan Sultanik.

## Prerequisites

Install [`fish` shell](https://fishshell.com/).

## Installation

On a new machine, from your home directory:

```sh
cd ~
git clone --bare git@github.com:ESultanik/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --recursive
source ~/.config/fish/config.fish
dotfiles config --local status.showUntrackedFiles no
```

## Agent configuration

The canonical Claude Code and Codex configuration is in `~/.config/agents`. Thin adapters expose
the shared instructions and installer skill to each client without duplicating their content.

After checking out the dotfiles, start either client and invoke the installer:

- In Claude Code, run `/install-agent-config`.
- In Codex, ask it to use `$install-agent-config`.

Review the proposed changes before confirming them. The installer merges the portable Codex
defaults into `~/.codex/config.toml`, preserves machine-local state and authentication, validates
the shared hooks, and installs the configured public plugins. It does not track credentials. Set
`EXA_API_KEY` through an untracked environment or credential mechanism to enable the Exa server.

See the [installer workflow](../.config/agents/skills/install-agent-config/references/workflow.md)
for the source files, merge rules, plugins, and validation steps.

## Usage

The `dotfiles` command can be used like `git` to add, remove, and commit files in your home
directory.
