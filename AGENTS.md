# Working on dots-and-configs

This repo is the source of truth for the configs shared by Memnoc's machines
(Fedora Asahi on ARM64, Linux x86_64, macOS). Read `agents/global.md` for the
rules that apply everywhere and `docs/machines.md` for what each machine has.

## How configs reach a machine

Configs are **plain copies, never symlinks**. `bin/sync-config` copies:

| Repo | Live location |
| --- | --- |
| `.zshrc` | `~/.zshrc` |
| `.tmux.conf` | `~/.tmux.conf` |
| `starship.toml` | `~/.config/starship.toml` |
| `ghostty/` | `~/.config/ghostty/` |
| `.config/wezterm/` | `~/.config/wezterm/` |
| `agents/global.md` | `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` |

- With `core.hooksPath .githooks` set, `post-merge` and `post-rewrite` run the
  sync after every `git pull`, whether it fast-forwards or rebases.
- A live file that differs from both the repo and the last synced copy was
  edited on that machine. The sync shows the diff and **skips** it. Either
  copy the edit into the repo, or run `bin/sync-config --force` (keeps a
  `.bak`). Never force without showing the user the diff.
- `bin/sync-config --dry-run` previews. Last-synced hashes live in
  `~/.local/state/dots-and-configs/applied`.
- To sync a new file, add a line to `MAP` at the top of `bin/sync-config`
  and a row to the table above.

`bin/setup-machine` is the one entry point for a new or out-of-date machine:
it pulls every repo in `~/Code`, enables hooks where a repo has `.githooks`,
runs both config syncs and reports missing tools. Before the LazyVim sync it
backs up Neovim's config dir to `nvim.bak-<date>` if that dir holds anything
the repo doesn't, because My-LazyVim's sync replaces it wholesale. Run `--dry-run` first on a
machine you haven't used it on.

Not synced: `.bashrc`/`.bash_profile` (zsh is the shell) and the old Neovim,
kitty, alacritty and neofetch configs under `.config/`.

## Changing a config

1. Decide whether every machine should get the change. Check macOS and
   Linux (ARM64 and x86_64) behaviour, not just the current machine.
2. Shared change: edit the repo file. Machine-specific: guard it in the file
   (`[[ "$OSTYPE" == darwin* ]]`, `uname -m`, `command -v tool`) so the same
   file stays correct everywhere, or leave it out of the repo.
3. Run `bin/sync-config`, verify the tool still loads (e.g. `zsh -i -c exit`,
   `ghostty +validate-config`, `tmux -f ~/.tmux.conf`).
4. Commit and push only when the user asks; the other machines pick it up on
   their next `git pull`.
5. If a machine gained or lost something notable, update `docs/machines.md`.

## Scripts

- Both scripts must run on macOS's bash 3.2: no associative arrays,
  `mapfile`, `${var,,}` or other bash 4 features.
- Keep `bin/setup-machine` idempotent and free of package installs: package
  names differ between Fedora, Ubuntu and Homebrew. It reports; the user or
  agent installs with the platform's package manager.
