# Machines

What each machine has and what is still to do. Run `bin/setup-machine` on a
machine to pull, sync and see what is missing; update this file when a
machine's setup changes. The shared rules are in `../agents/global.md`.

## Checklist for any machine

Done by `bin/setup-machine` (safe to repeat):

- [ ] every repo in `~/Code` pulled
- [ ] `core.hooksPath .githooks` in dots-and-configs and My-LazyVim
- [ ] configs copied: zsh, tmux, starship, Ghostty, WezTerm, agent guidance
- [ ] LazyVim synced to Neovim's config dir

Manual, per platform (the script reports which are missing):

- [ ] packages: git, zsh, neovim, ripgrep, fd, jq, fzf, zoxide, eza, tmux,
      starship, Ghostty, WezTerm, a C toolchain
- [ ] JetBrainsMono Nerd Font
- [ ] zsh as login shell (`chsh -s "$(command -v zsh)"`)
- [ ] zap: `git clone --depth 1 -b release-v1 https://github.com/zap-zsh/zap.git ~/.local/share/zap`
      (plugins install on the first zsh start)
- [ ] TPM: `git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`,
      then `~/.tmux/plugins/tpm/bin/install_plugins`
- [ ] Rust via rustup; Node via `n` or fnm (`.zshrc` loads whichever exists)
- [ ] Uzume: `cd ~/Code/uzume && python3 setup-editor --register`
- [ ] northstar skills: `cd ~/Code/northstar && bash install.sh`
- [ ] agent-statusline: `cd ~/Code/agent-statusline && bash install.sh --harness claude`,
      plus the `statusLine` entry in `~/.claude/settings.json`
- [ ] git global config (not in this repo): identity, `core.editor uzume`,
      `pull.rebase true`, `push.autoSetupRemote true`, `init.defaultBranch main`

## Fedora Asahi laptop (Linux ARM64)

Apple MacBook Pro 16" M1 Max, Fedora Asahi Remix 45, COSMIC desktop.
Fully set up 2026-11-24/25.

- **Packages (dnf):** gcc, clang + clang-tools-extra (clangd), gdb, lldb,
  valgrind, make, cmake, ninja, meson, ccache, bear, git, git-lfs, gh, neovim,
  ripgrep, fd, jq, fzf, zoxide, eza, zsh, tmux, rustup.
  Ghostty from COPR `scottames/ghostty`, WezTerm from COPR
  `wezfurlong/wezterm-nightly`.
- **User-space:** Rust via rustup (`~/.cargo`); Node LTS via fnm (installed
  with cargo) with pnpm, TypeScript 7, prettier, eslint_d and the
  HTML/CSS/JSON/Tailwind language servers as global npm packages; starship
  via `cargo install`; JetBrainsMono Nerd Font in `~/.local/share/fonts`.
- **Editors:** Uzume registered (`~/.local/bin/uzume`, default `$EDITOR`);
  LazyVim in `~/.config/nvim`. Mason has no linux-arm64 clangd, so LazyVim
  uses the system clangd here (`lua/plugins/clangd-system.lua`). Uzume's
  recorded Node tool paths point at fnm's stable
  `~/.local/share/fnm/aliases/default/bin`, not a per-shell fnm directory.
- **Agents:** northstar skills in `~/.claude/skills`; agent-statusline wired
  into `~/.claude/settings.json`.
- **Local only, not in any repo:**
  `~/.local/bin/fix-cosmic-flatpak-applets` works around Flatpak 1.18.4
  stripping `X-CosmicApplet` from exported desktop files (rerun after
  installing or updating a Flatpak COSMIC applet). COSMIC theme
  `radius_xl` set to 4px in `~/.config/cosmic/com.system76.CosmicTheme.*`.
- **Backups (set up 2026-11-25, local only):**
  - *System:* snapper on the btrfs `root` subvolume (config `root`,
    snapshots in `/.snapshots`). `libdnf5-plugin-actions` with
    `/etc/dnf/libdnf5-plugins/actions.d/snapper.actions` takes a pre/post
    pair around every dnf transaction. Retention: `NUMBER_LIMIT=6`
    (the last 3 dnf transactions; the hook marks nothing important, so
    `NUMBER_LIMIT_IMPORTANT` never applies). Timeline snapshots are off
    (`TIMELINE_CREATE=no`, `snapper-timeline.timer` disabled);
    `snapper-cleanup.timer` enabled; `ALLOW_USERS=memnoc` (it can create
    and list snapshots, but `set-config` needs sudo). Snapshot #1 ("Known good: before One Touch
    setup") has no cleanup algorithm, so it is kept until deleted by hand.
    Undo an update: `snapper status A..B`, `sudo snapper undochange A..B`.
  - *Files:* Pika Backup (Flatpak) to the external 700 GB ext4 drive (UUID
    `85bd9193-922b-4396-8f45-fcc3d64a4d7e`), encrypted borg repo in
    `pika/`. Whole home minus the Caches preset, daily at 17:00 when the
    drive is connected and on AC, old archives pruned (Pika defaults).
    First run: 11.5 GB, 187k files, about 2 minutes.
  - *Not Timeshift:* removed. Its btrfs mode needs `@`/`@home` subvolumes
    (Fedora uses `root`/`home`), and in rsync mode Timeshift 25.12.4 on
    aarch64 finished the copy in about 90 s and then sat at 100% CPU for over
    an hour before saving the snapshot. Its rsync mode would also copy
    `/.snapshots` unless excluded.
- **Known limits:** sleep is s2idle only and drains about 3.5%/hour
  (~3 W); there is no hibernate. Shut down for long periods unplugged.
  x86_64 binaries committed to repos will not run here; build locally.

## Linux x86_64 machine

Not yet checked from this repo. On it: run `bin/setup-machine --dry-run`,
then `bin/setup-machine`, and record the result here. Node is managed with
`n` there (per `.zshrc`).

## macOS

Not yet checked from this repo. `bin/sync-config` and `bin/setup-machine`
are written for bash 3.2 but have not been run on macOS yet: start with
`--dry-run`. Ghostty and WezTerm are detected in `/Applications`.
