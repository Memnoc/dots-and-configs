# dots-and-configs

![GitHub last commit](https://img.shields.io/github/last-commit/Memnoc/dots-and-configs)
![GitHub repo size](https://img.shields.io/github/repo-size/Memnoc/dots-and-configs)
![GitHub license](https://img.shields.io/github/license/Memnoc/dots-and-configs)

A collection of my configuration files and dotfiles for various tools and environments.

## Set up a machine

Do this once on every machine (Linux or macOS). Repos are expected in `~/Code`.

**1. Get this repo onto the machine.**

Already cloned? Pull it; the pull is what brings `bin/setup-machine` with it:

```sh
cd ~/Code/dots-and-configs && git pull
```

Not cloned yet:

```sh
git clone git@github.com:Memnoc/dots-and-configs.git ~/Code/dots-and-configs
cd ~/Code/dots-and-configs
```

**2. Preview, then run the setup.**

```sh
bin/setup-machine --dry-run   # shows what would happen, changes nothing
bin/setup-machine
```

Always start with `--dry-run` on a machine that has not run it before
(especially macOS). The setup:

1. pulls every repo in `~/Code` (you only pull this one yourself; repos with
   uncommitted work are reported and left alone)
2. turns on the sync hooks in repos that have them (this one and My-LazyVim)
3. copies the configs into place (table below); Neovim's config dir is backed
   up first if it holds edits the My-LazyVim repo doesn't have
4. lists anything still missing: packages, zap, TPM, Uzume, zsh as login
   shell. It installs no packages; install those with the platform's package
   manager and run it again

**3. Fix anything marked `!` and run `bin/setup-machine` again** until it
reports `Machine is set up.` It is safe to run as often as you like.

**4. Record the machine** in [docs/machines.md](docs/machines.md) (what was
installed, anything machine-specific) and commit it.

### After that

- `git pull` in this repo or My-LazyVim is all you need: the hooks copy any
  changed configs into place automatically.
- Run `bin/setup-machine` again after cloning a new repo into `~/Code`, or to
  check a machine you haven't used for a while.
- Change configs in this repo, not in the live copies; see
  [Keeping machines in sync](#keeping-machines-in-sync).
- Coding agents (Claude Code, Codex) on every set-up machine read
  `agents/global.md`, installed as `~/.claude/CLAUDE.md` and
  `~/.codex/AGENTS.md`. Agents working in this repo also read
  [AGENTS.md](AGENTS.md).

## Table of Contents

- [Set up a machine](#set-up-a-machine)
- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Keeping machines in sync](#keeping-machines-in-sync)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contribution](#contribution)
- [License](#license)

## Introduction

This repository contains configuration files and dotfiles for various applications and environments I use. It is designed to streamline the setup process for new machines or environments.

## Features

- **Neovim Configurations**:
  - [FrontVim](https://github.com/Memnoc/dots-and-configs/blob/main/.config/FrontVim/README.md)
  - [KickstartNeovim](https://github.com/Memnoc/dots-and-configs/blob/main/.config/KickstartNeovim/README.md)
  - [MemnocVim](https://github.com/Memnoc/dots-and-configs/blob/main/.config/MemnocVim/README.md)
- **Shell Configurations**:
  - Zsh
  - Bash
- **Other Tools**:
  - tmux
  - Git

## Installation

See [Set up a machine](#set-up-a-machine) at the top: clone or pull this
repo, then run `bin/setup-machine --dry-run` and `bin/setup-machine`.

## Keeping machines in sync

Configs are installed as plain copies (no symlinks). `bin/sync-config` copies
the tracked files to their live locations:

| Repo | Live location |
| --- | --- |
| `.zshrc` | `~/.zshrc` |
| `.tmux.conf` | `~/.tmux.conf` |
| `starship.toml` | `~/.config/starship.toml` |
| `ghostty/` | `~/.config/ghostty/` |
| `.config/wezterm/` | `~/.config/wezterm/` |
| `agents/global.md` | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md` |
| `macos/aerospace/` (macOS only) | `~/.config/aerospace/` |
| `macos/karabiner/` (macOS only) | `~/.config/karabiner/` |

`bin/setup-machine` turns on the hooks (`git config core.hooksPath .githooks`),
after which every `git pull` runs `bin/sync-config` automatically. You can also
run it by hand after editing a config here.

A live file edited directly on a machine is never overwritten silently: the
sync shows the diff and skips it. Copy the edit into the repo, or run
`bin/sync-config --force` to take the repo version (a `.bak` copy is kept).
`bin/sync-config --dry-run` previews changes. To sync another file, add a line
to the `MAP` at the top of the script.

## Usage

### Neovim Configurations

Each Neovim configuration has its own README with specific instructions and features. Refer to the individual READMEs for detailed setup and usage information:

- [FrontVim](https://github.com/Memnoc/dots-and-configs/blob/main/.config/FrontVim/README.md)
- [KickstartNeovim](https://github.com/Memnoc/dots-and-configs/blob/main/.config/KickstartNeovim/README.md)
- [MemnocVim](https://github.com/Memnoc/dots-and-configs/blob/main/.config/MemnocVim/README.md)

### Shell Configurations

- **Zsh**: Customize your shell experience with the `.zshrc` configuration.
- **Bash**: Improve your Bash shell with the `.bashrc` configuration.

### Other Tools

- **tmux**: Enhance your terminal multiplexing with the provided `.tmux.conf`.
- **Git**: Use the `.gitconfig` to streamline your Git workflow.

## Configuration

Feel free to modify any configuration files to suit your personal preferences. This repository is meant to be a starting point for your custom setup.

## Contribution

Contributions are welcome! If you have improvements or new configurations to add, please open a pull request with a detailed description.

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---

Feel free to further customize and add any additional information as needed!
