# dots-and-configs

![GitHub last commit](https://img.shields.io/github/last-commit/Memnoc/dots-and-configs)
![GitHub repo size](https://img.shields.io/github/repo-size/Memnoc/dots-and-configs)
A collection of my configuration files and dotfiles for various tools and environments.

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

To get started with these configurations, follow these steps:

1. **Clone the Repository**:

   ```sh
   git clone https://github.com/Memnoc/dots-and-configs.git
   cd dots-and-configs
   ```

2. **Backup Existing Configurations**:

   ```sh
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.zshrc ~/.zshrc.backup
   mv ~/.bashrc ~/.bashrc.backup
   mv ~/.tmux.conf ~/.tmux.conf.backup
   ```

3. **Symlink Configuration Files**:
   ```sh
   ln -s $(pwd)/.config/nvim ~/.config/nvim
   ln -s $(pwd)/.zshrc ~/.zshrc
   ln -s $(pwd)/.bashrc ~/.bashrc
   ln -s $(pwd)/.tmux.conf ~/.tmux.conf
   ```

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
