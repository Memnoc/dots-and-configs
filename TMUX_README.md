# tmux Setup

Requires tmux 3.0+, git, and a [Nerd Font](https://www.nerdfonts.com/) set in your terminal.

## 1. Install tmux

**Linux (Debian/Ubuntu)**

```bash
sudo apt install tmux
```

**Linux (Arch)**

```bash
sudo pacman -S tmux
```

**Linux (Fedora)**

```bash
sudo dnf install tmux
```

**macOS**

```bash
brew install tmux
```

> macOS: bash 5.2+ is required for tmux2k colors.
>
> ```bash
> brew install bash
> ```

## 2. Install TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## 3. Install the config

```bash
curl -o ~/.tmux.conf https://your-config-location/tmux.conf
# or copy manually
```

## 4. Install plugins

Start tmux:

```bash
tmux
```

Inside the session:

```
prefix + I
```

Default prefix is `Ctrl-b`. This clones all plugins into `~/.tmux/plugins/`.

## 5. Apply

```bash
tmux kill-server
tmux new-session
```

---

## Plugins installed

| Plugin             | Purpose                                    |
| ------------------ | ------------------------------------------ |
| tpm                | Plugin manager                             |
| tmux-sensible      | Sane defaults                              |
| vim-tmux-navigator | Seamless pane/split navigation with Neovim |
| tmux-resurrect     | Persist sessions across reboots            |
| tmux-continuum     | Auto-save sessions every 15 min            |
| tmux2k             | Status bar theme                           |

---

## Key bindings

All use `Ctrl-b` prefix unless noted.

### Panes

| Key              | Action                              |
| ---------------- | ----------------------------------- |
| `prefix -`       | Split horizontal (vertical divider) |
| `prefix _`       | Split vertical (horizontal divider) |
| `prefix m`       | Zoom/unzoom pane                    |
| `prefix h/j/k/l` | Resize pane left/down/up/right      |
| `Ctrl-h/j/k/l`   | Move between panes (no prefix)      |

### Windows

| Key            | Action                           |
| -------------- | -------------------------------- |
| `prefix c`     | New window (inherits cwd)        |
| `prefix ,`     | Rename window                    |
| `prefix n / p` | Next/previous window             |
| `prefix 1-9`   | Jump to window by number         |
| `prefix l`     | Last used window                 |
| `prefix .`     | Move window to numbered position |
| `prefix &`     | Kill window                      |
| `prefix w`     | Visual session/window switcher   |

### Sessions

| Command               | Action                |
| --------------------- | --------------------- |
| `tmux ls`             | List sessions         |
| `tmux attach -t name` | Attach by name        |
| `tmux attach`         | Attach to most recent |

### Misc

| Key        | Action              |
| ---------- | ------------------- |
| `prefix r` | Reload tmux.conf    |
| `prefix b` | Toggle status bar   |
| `prefix :` | tmux command prompt |
| `prefix x` | Kill pane           |

### Copy mode (`prefix [`)

| Key | Action          |
| --- | --------------- |
| `v` | Begin selection |
| `y` | Copy selection  |

---

## Updating plugins

```
prefix + U
```
