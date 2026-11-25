# Memnoc's machines: shared setup

Installed by `~/Code/dots-and-configs/bin/sync-config` as `~/.claude/CLAUDE.md`
(Claude Code) and `~/.codex/AGENTS.md` (Codex). Edit the repo copy
`dots-and-configs/agents/global.md`, never the installed one.

## Machines

The same repos in `~/Code` are used on several machines:

- Apple Silicon MacBook running Fedora Asahi Remix (Linux ARM64, COSMIC desktop)
- a Linux x86_64 machine
- macOS

Shell: zsh. Editor: Uzume (`uzume`, default `$EDITOR`); plain `nvim` is LazyVim.

## Rules for any change

1. **Decide where a change belongs.** Before changing a config or a repo,
   check whether every machine should get it (macOS and Linux, ARM64 and
   x86_64) or only this one. Shared changes go in the repo. Machine-specific
   ones are guarded in code (OS/arch/`command -v` checks) or stay local. Say
   which you chose.
2. **No symlinks for configs.** Configs are plain copies of repo files. The
   only exception is `~/.config/uzume`, which Uzume's installer requires.
3. **Edit the repo, not the live copy.** Change files in
   `~/Code/dots-and-configs` or `~/Code/My-LazyVim`, then run that repo's
   `bin/sync-config`. Commit or push only when the user asks.
4. **Pull before working.** `git pull` in those two repos applies config
   changes automatically through `.githooks`.

## Setting up or checking a machine

```sh
cd ~/Code/dots-and-configs && git pull && bin/setup-machine --dry-run
bin/setup-machine
```

It pulls every repo, enables the sync hooks, copies configs and lists missing
tools. It installs no packages. Full details, per-machine notes and the
checklist: `~/Code/dots-and-configs/AGENTS.md` and `docs/machines.md`.
