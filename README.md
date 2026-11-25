# dots-and-configs

![GitHub last commit](https://img.shields.io/github/last-commit/Memnoc/dots-and-configs)
![GitHub repo size](https://img.shields.io/github/repo-size/Memnoc/dots-and-configs)
![GitHub license](https://img.shields.io/github/license/Memnoc/dots-and-configs)

A collection of my configuration files and dotfiles for various tools and environments.

## New or out-of-date machine

```sh
cd ~/Code/dots-and-configs && git pull && bin/setup-machine --dry-run
bin/setup-machine
```

Pulls every repo in `~/Code`, enables the sync hooks, copies configs and lists
what is still missing. See [docs/machines.md](docs/machines.md) for each
machine's state and [AGENTS.md](AGENTS.md) for how changes are made.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
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

```sh
git clone git@github.com:Memnoc/dots-and-configs.git ~/Code/dots-and-configs
cd ~/Code/dots-and-configs
bin/setup-machine --dry-run   # preview
bin/setup-machine
```

Configs are installed as copies, never symlinks. Existing files that differ
from the repo are shown and skipped rather than overwritten; see below.

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

Enable it once per clone and every `git pull` applies changes automatically:

```sh
git config core.hooksPath .githooks
bin/sync-config
```

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
